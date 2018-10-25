#!/usr/bin/env bash
# Usage: install pre-commit for checking style with SwiftLint

set -eu

ln -s ../../scripts/pre-commit.sh .git/hooks/pre-commit
