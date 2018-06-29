#!/usr/bin/env bash

# Script to automate development build for personal website.
# Copyright (C) 2015 Logan Martel - All Rights Reserved
# Permission to copy and modify is granted under the GNU Apache License 2.0
# Last revised 06/29/2018
# See README.md for further details.

# Note, this script has been modified & based loosely on: 
# https://github.com/X1011/git-directory-deploy/blob/master/deploy.sh

set -o errexit # abort if any command fails
scriptname=$(basename "$0")

help_message="\
Usage: $scriptname
Deploy generated files to a git branch.

Options:

  -h, --help               Show this help information.
"

parse_args() {
	# Set args from a local environment file.
	if [ -e ".env" ]; then
		source .env
	fi

	# Set args from file specified on the command-line.
	if [[ $1 = "-c" || $1 = "--config-file" ]]; then
		source "$2"
		shift 2
	fi

	# Parse arg flags
	# If something is exposed as an environment variable, set/overwrite it
	# here. Otherwise, set/overwrite the internal variable instead.
	while : ; do
		if [[ $1 = "-h" || $1 = "--help" ]]; then
			echo "$help_message"
			return 0
		else
			break
		fi
	done
}

main() {
	parse_args "$@"

	# build distribution
	coffee --compile javascripts/*.coffee
	compass compile sass/*
	minify javascripts/ --clean
	minify stylesheets/ --clean
}

[[ $1 = --source-only ]] || main "$@"
