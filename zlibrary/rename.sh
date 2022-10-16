#!/usr/bin/env sh
set -e
dirs=$(find ./ui/src/cocoa -name '*.m')
firstArg=$1
set -- $dirs

for dir in "$@"; do
    n=$(echo $dir | sed 's/\.m//')
    mv $dir $n.mm
done
