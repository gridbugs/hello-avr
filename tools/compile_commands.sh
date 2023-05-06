#!/bin/sh
set -exuo pipefail

# Script that uses the `bear` tool to print the compilation database
# (typically stored in "compile_commands.json") to stdout

TMP="$(mktemp -d)"
trap "rm -rf $TMP" EXIT

COMPILE_COMMANDS_ORIGINAL=$TMP/compilation_commands.json

bear --output $COMPILE_COMMANDS_ORIGINAL -- make --always-make > /dev/stderr
cat $COMPILE_COMMANDS_ORIGINAL
