#!/bin/sh

set -e
xmake f -c --file=./3rd/xmake.lua
xmake lua ./3rd/fetch.lua
xmake build --file=./3rd/xmake.lua
xmake lua ./3rd/copy.lua
