#!/bin/sh
set -exuo pipefail

# Script that reads a compilation database from stdin and a file listing additional
# include paths, one per line, from its first argument, and prints a compilation
# database to stdout which adds -I<file> arguments to include the paths listed in
# the file.

INCLUDE_FILE_LIST=$1
COMMA_SEPARATED_INCLUDE_ARGS=$(cat $INCLUDE_FILE_LIST | xargs -I{} echo '"-I{}"' | tr '\n' , | sed 's/,$//')
jq "map(.arguments += [$COMMA_SEPARATED_INCLUDE_ARGS])"
