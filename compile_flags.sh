#!/bin/sh

CC=avr-gcc
MCU=atmega328p
CFLAGS="-mmcu=$MCU -std=c99 -Werror"

include_paths() {
    $CC -E -Wp,-v - < /dev/null 2>&1 | sed -n '/#include <...> search starts here:/,/End of search list./{//!p}'
}

args_I() {
    include_paths | xargs -I{} printf "-I{}\n"
}

cflags() {
    for flag in $CFLAGS; do
        printf "%s\n" $flag
    done
}

cflags
args_I
