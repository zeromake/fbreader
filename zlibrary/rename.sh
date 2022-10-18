#!/usr/bin/env sh
set -e
dirs=$(find ./ui/src/iphone -name '*.M')
firstArg=$1
set -- $dirs

for dir in "$@"; do
    n=$(echo $dir | sed 's/\.M//')
    mv $dir $n.mm
done
