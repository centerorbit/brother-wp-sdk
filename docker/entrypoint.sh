#!/bin/bash
set -e

if [ "$1" == "build" ]; then
    cd /code
    z80asm -i ./samples/hello-world/hello.asm -o ./builds/HELLO.APL
    exit
fi

exec "$@"