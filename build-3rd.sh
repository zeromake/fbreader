#!/bin/sh

set -e

rm -rf ./3rd/include
rm -rf ./3rd/lib
rm -rf ./3rd/build
xmake f -c --file=./3rd/xmake.lua
xmake lua ./3rd/fetch.lua
xmake build --file=./3rd/xmake.lua
xmake lua ./3rd/copy.lua
