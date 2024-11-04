# Wait for a tx to show up in a block
wait_for_tx() {
  local tx_hash=$1
  echo "Waiting for tx ${tx_hash} to be included in a block..."
  minid tx wait-tx "${tx_hash}" \
    --output json | \
    jq '{height, txhash, codespace, code, raw_log}'
}