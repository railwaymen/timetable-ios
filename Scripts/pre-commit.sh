#!/bin/bash
export PATH=/usr/local/bin:$PATH

LINT=$(which swiftlint)

if [[ -e "${LINT}" ]]; then
	echo "Starting SwiftLint to check style."
else
	echo "Warning: SwiftLint not installed, download from https://github.com/realm/SwiftLint"
	exit 1
fi

RESULT=$($LINT lint --quiet)

if [ "$RESULT" == '' ]; then
	printf "SwiftLint Finished!"
else
	printf "\e[91mSwiftLint Failed. Please check the project.\n\e[0m"
	exit 1
fi
