#!/bin/ash
set -e

function checkWorkspace () {
    if [ ! "$(ls -A ./)" ]; then
        echo 'You must mount the repo into docker using the -v option.'
        echo ' Example: docker run -v $(pwd):/workspace registry.gitlab.com/centerorbit/brother-wp-sdk:latest build'
        exit 1
    fi
}


if [ "$1" == "build" ]; then
    checkWorkspace
    depcharge -f -s -k app -x z80asm  -- --includepath='./targets/{{../name}}' -i './{{location}}/{{input}}' -o './builds/{{../name}}/{{output}}'
    exit
fi

if [ "$1" == "clean" ]; then
    checkWorkspace
    depcharge -f -s -k app -x rm -- -f './builds/{{../name}}/{{output}}'
    depcharge -f -s -k machine -x ash -- -c 'cd "./builds/{{name}}/"; rm -f "{{name}}.zip"'
    exit
fi

if [ "$1" == "package" ]; then
    checkWorkspace
    depcharge -f -s -k machine -x ash -- -c 'cd "./builds/{{name}}/"; zip -r "{{name}}.zip" *'
    exit
fi

exec "$@"