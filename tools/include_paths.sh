#!/bin/sh
set -exuo pipefail

# Script to print custom include paths used by the avr compiler to stdout,
# one per line

CC=avr-gcc
$CC -E -Wp,-v - < /dev/null 2>&1 | sed -n '/#include <...> search starts here:/,/End of search list./{//!p}' | xargs -n1 echo
