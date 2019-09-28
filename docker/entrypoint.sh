#!/bin/ash
set -e

function checkWorkspace () {
    if [ ! "$(ls -A /workspace)" ]; then
        echo 'You must mount the repo into docker using the -v option.'
        echo ' Example: docker run -v $(pwd):/workspace registry.gitlab.com/centerorbit/brother-wp-sdk:latest build'
        exit 1
    fi
}

cd /workspace

if [ "$1" == "build" ]; then
    checkWorkspace
    depcharge -f -s -k build -x z80asm  -- --includepath='targets/{{../name}}' -i './{{location}}/{{input}}' -o './builds/{{../name}}/{{output}}'
    exit
fi

if [ "$1" == "clean" ]; then
    checkWorkspace
    depcharge -f -s -k build -x rm -- -f './builds/{{../name}}/{{output}}'
    exit
fi

exec "$@"