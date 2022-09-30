Remove-Item -Force -Recurse .\3rd\include
Remove-Item -Force -Recurse .\3rd\lib
Remove-Item -Force -Recurse .\3rd\build
xmake f -c --file=.\3rd\xmake.lua
xmake lua .\3rd\fetch.lua
xmake build --file=.\3rd\xmake.lua
xmake lua .\3rd\copy.lua
