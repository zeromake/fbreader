## FBReader

fork to [FBReader](https://github.com/geometer/FBReader).


## build guide

**pre**

``` bash
xmake repo -a local https://github.com/zeromake/xrepo.git
```

**windows**
> install Visual Studio

``` powershell
xmake f -c -y
xmake build -y fbreader
xmake lua pkg.lua
```

**windows by mingw**
> install [llvm-mingw](https://github.com/mstorsjo/llvm-mingw/releases) or other `mingw`.
``` powershell
$MINGW="D:\mingw64"
xmake f -p mingw --mingw=$MINGW -y -c
xmake build -y fbreader
xmake lua pkg.lua
```

**osx**
> install xcode or clang

``` bash
xmake f -y -c
xmake build -y onscripter
xmake lua pkg.lua
```

pkg file is on dist dir.

## change

- [x] fix windows build.
- [x] merge by [harbour-books](https://github.com/monich/harbour-books) change.
- [x] makefile build migrate to xmake.
- [x] support msvc build.
- [x] win32 add openFileDialog support by [portable-file-dialogs](https://github.com/samhocevar/portable-file-dialogs).
- [x] deps ues xmake build.
- [x] windows nsis pkg exe installer
- [x] windows github action release
- [x] MacOS xmake build support
- [x] MacOS xmake arm64 build support
- [x] MacOS xmake universal binary build
- [x] MacOS github action release
- [x] tools/StatisticsGenerator xmake build support
