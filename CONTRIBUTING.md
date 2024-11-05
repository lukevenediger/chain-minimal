# Contribution Guidelines

We welcome all contributions to this project. Please use the guidelines below to set up your development environment.

If you'd like to contribute to the Checkers module itself, please visit https://github.com/lukevenediger/checkers/

## Prerequisites

The following tools are required to contribute to this project:

* [Go](https://golang.org/dl/)
* [Docker](https://docs.docker.com/get-docker/)
* [pre-commit](https://pre-commit.com/)
* [make](https://www.gnu.org/software/make/)

## Pre-Commit Hooks

Our pre-commit hooks help maintain code quality and consistency by performing the following actions:
* Formatting all Go files with `go fmt`.
* Removing trailing whitespace.
* Standardizing end-of-file (EOF) newlines.
* Enforcing the Conventional Commit message standard.

### Conventional Commit Messages

We follow a lightweight structure for commit messages using the Conventional Commits standard. The format is `<type>(<scope>): <description>`, where `type` can be one of `feat`, `fix`, `docs`, `style`, `refactor`, `test`, or `chore`.

For more details, see the [Conventional Commits Quickstart Guide](https://www.conventionalcommits.org/en/v1.0.0/#summary).

### Installing Pre-Commit

1. Install [pre-commit](https://pre-commit.com/).
2. Apply the pre-commit and commit message hooks to this repository:
   ```sh
   pre-commit install
   pre-commit install --hook-type commit-msg
   ```
