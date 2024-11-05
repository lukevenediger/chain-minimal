package keeper_test

import (
	"testing"

	"cosmossdk.io/core/appmodule"
	"cosmossdk.io/log"
	storetypes "cosmossdk.io/store/types"
	cmtproto "github.com/cometbft/cometbft/proto/tendermint/types"
	addresscodec "github.com/cosmos/cosmos-sdk/codec/address"
	"github.com/cosmos/cosmos-sdk/runtime"
	"github.com/cosmos/cosmos-sdk/testutil/integration"
	"github.com/cosmos/cosmos-sdk/testutil/sims"
	sdk "github.com/cosmos/cosmos-sdk/types"
	moduletestutil "github.com/cosmos/cosmos-sdk/types/module/testutil"
	"github.com/cosmos/cosmos-sdk/x/auth"
	authtypes "github.com/cosmos/cosmos-sdk/x/auth/types"
	checkers "github.com/lukevenediger/checkers"
	"github.com/lukevenediger/checkers/keeper"
	checkersmodule "github.com/lukevenediger/checkers/module"
	"github.com/stretchr/testify/assert"
)

type fixture struct {
	app            *integration.App
	ctx            sdk.Context
	queryClient    checkers.QueryClient
	checkersKeeper keeper.Keeper

	addrPlayers []sdk.AccAddress
}

func initFixture(t testing.TB) *fixture {
	keys := storetypes.NewKVStoreKeys(checkers.StoreKey)
	cdc := moduletestutil.MakeTestEncodingConfig(auth.AppModuleBasic{}).Codec

	// Use log.NewTestLogger(t) if you need to debug a test failure
	logger := log.NewNopLogger()

	cms := integration.CreateMultiStore(keys, logger)
	newCtx := sdk.NewContext(cms, cmtproto.Header{}, true, logger)
	authority := authtypes.NewModuleAddress("gov")

	checkersKeeper := keeper.NewKeeper(cdc,
		addresscodec.NewBech32Codec(sdk.Bech32MainPrefix),
		runtime.NewKVStoreService(keys[checkers.StoreKey]),
		authority.String())

	checkersModule := checkersmodule.NewAppModule(cdc, checkersKeeper)

	integrationApp := integration.NewIntegrationApp(newCtx,
		logger,
		keys,
		cdc,
		map[string]appmodule.AppModule{
			checkers.ModuleName: checkersModule,
		},
	)

	sdkCtx := sdk.UnwrapSDKContext(integrationApp.Context())

	// Register gRPC servers
	checkers.RegisterCheckersTorramServer(
		integrationApp.MsgServiceRouter(),
		keeper.NewMsgServerImpl(checkersKeeper),
	)
	checkers.RegisterQueryServer(
		integrationApp.QueryHelper(),
		keeper.NewQueryServerImpl(checkersKeeper),
	)

	queryClient := checkers.NewQueryClient(integrationApp.QueryHelper())

	return &fixture{
		app:            integrationApp,
		ctx:            sdkCtx,
		checkersKeeper: checkersKeeper,
		queryClient:    queryClient,
		addrPlayers:    sims.CreateRandomAccounts(3),
	}
}

func TestCannotCreateSameGameTwice(t *testing.T) {
	t.Parallel()

	f := initFixture(t)
	f.ctx = f.ctx.WithIsCheckTx(false).WithBlockHeight(1)

	// New Game message
	msg := checkers.ReqCheckersTorram{
		Creator: f.addrPlayers[0].String(),
		Index:   "game1",
		Black:   f.addrPlayers[0].String(),
		Red:     f.addrPlayers[1].String(),
	}

	// First game creation
	_, err := f.app.RunMsg(
		&msg,
		integration.WithAutomaticFinalizeBlock(),
		integration.WithAutomaticCommit(),
	)
	assert.NoError(t, err)

	// Move forward one block
	f.ctx = f.ctx.WithBlockHeight(f.ctx.BlockHeight() + 1)

	// Second game creation
	_, err = f.app.RunMsg(
		&msg,
		integration.WithAutomaticFinalizeBlock(),
		integration.WithAutomaticCommit(),
	)
	assert.ErrorContains(t, err, "duplicate game index")
}

func TestOpponentsCannotBeTheSamePlayer(t *testing.T) {
	t.Parallel()

	f := initFixture(t)
	f.ctx = f.ctx.WithIsCheckTx(false).WithBlockHeight(1)

	// New Game message
	msg := checkers.ReqCheckersTorram{
		Creator: f.addrPlayers[0].String(),
		Index:   "game1",
		Black:   f.addrPlayers[0].String(),
		Red:     f.addrPlayers[0].String(),
	}

	// First game creation
	_, err := f.app.RunMsg(
		&msg,
		integration.WithAutomaticFinalizeBlock(),
		integration.WithAutomaticCommit(),
	)
	assert.ErrorContains(t, err, "cannot play against self")
}
