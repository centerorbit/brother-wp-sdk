#!/bin/ash
set -e

if [ "$1" == "build" ]; then
    if [ ! "$(ls -A /workspace)" ]; then
        echo 'You must mount the repo into docker using the -v option.'
        echo ' Example: docker run -v $(pwd):/workspace registry.gitlab.com/centerorbit/brother-wp-sdk:latest build'
    fi

    cd /workspace
    depcharge -f -s -k build -x z80asm  -- --includepath='targets/{{../name}}' -i './{{location}}/{{input}}' -o './builds/{{../name}}/{{output}}'
    exit
fi

exec "$@"