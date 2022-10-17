local arch = os.getenv("ARCH") or "x64"
if arch == "x86_64" then
    arch = "x64"
end
local is32bit = arch ~= "x64" and arch ~= "arm64"
local isarm64 = arch == "arm64"

local includeDir = path.join(os.scriptdir(), "include")
local libDir = path.join(os.scriptdir(), "lib-"..arch)

os.mkdir(includeDir)
os.mkdir(libDir)

if is_host("macosx") then
    if isarm64 then
        os.cp(path.join(os.scriptdir(), "../build/macosx/arm64/release/*.a"), libDir)
    else
        os.cp(path.join(os.scriptdir(), "../build/macosx/x86_64/release/*.a"), libDir)
    end
    os.rm(path.join(libDir, "libzlcore.a"))
    os.rm(path.join(libDir, "libzltext.a"))
    os.rm(path.join(libDir, "libzlui.a"))
elseif is_host("windows") then
    if is32bit then
        os.cp(path.join(os.scriptdir(), "build/mingw/x86/release/*.a"), libDir)
        os.cp(path.join(os.scriptdir(), "build/windows/x86/release/*.lib"), libDir)
    else
        os.cp(path.join(os.scriptdir(), "build/mingw/x86_64/release/*.a"), libDir)
        os.cp(path.join(os.scriptdir(), "build/windows/x64/release/*.lib"), libDir)
    end
end
-- os.cp("curl/curl-7.83.1_2-win64-mingw/lib/*.a", "lib/")

local headerFiles = {
    {
        "bzip2/bzip2-1.0.6/",
        {
            "bzlib.h",
        }
    },
    {
        "libcurl/curl-7.85.0/include/",
        {
            "curl"
        }
    },
    {
        "fribidi/fribidi-1.0.12/lib/",
        {
            "fribidi-arabic.h",
            "fribidi-begindecls.h",
            "fribidi-bidi.h",
            "fribidi-bidi-types.h",
            "fribidi-bidi-types-list.h",
            "fribidi-common.h",
            "fribidi-char-sets.h",
            "fribidi-char-sets-list.h",
            "fribidi-deprecated.h",
            "fribidi-enddecls.h",
            "fribidi-flags.h",
            "fribidi-joining.h",
            "fribidi-joining-types.h",
            "fribidi-joining-types-list.h",
            "fribidi-mirroring.h",
            "fribidi-brackets.h",
            "fribidi-shape.h",
            "fribidi-types.h",
            "fribidi-unicode.h",
            "fribidi-unicode-version.h",
            "fribidi.h",
            "fribidi-config.h",
        },
        "fribidi/",
    },
    {
        "gif/giflib-5.2.1/",
        {
            "gif_hash.h",
            "gif_lib.h",
            "gif_lib_private.h",
        },
    },
    {
        "jpeg/jpeg-9e/",
        {
            "jconfig.h",
            "jpeglib.h",
            "jmorecfg.h",
            "jpegint.h",
            "jerror.h",
        },
    },
    {
        "png/lpng1637/",
        {
            "png.h",
            "pngconf.h",
            "pnglibconf.h",
        },
    },
    {
        "rxcpp/RxCpp-4.1.1/",
        {
            "Rx/v2/src/rxcpp",
        },
    },
    {
        "sqlite3/sqlite-amalgamation-3390200/",
        {
            "sqlite3.h",
            "sqlite3ext.h",
        },
    },
    {
        "tiff/tiff-4.4.0/libtiff/",
        {
            "tiff.h",
            "tiffio.h",
            "tiffvers.h",
            "tiffconf.h",
        },
    },
    {
        "unibreak/libunibreak-5.0/src/",
        {
            "linebreak.h",
            "unibreakbase.h",
        },
    },
    {
        "zlib/zlib-1.2.13/",
        {
            "zlib.h",
            "zconf.h",
        },
    },
    {
        "stb/stb-master/",
        {
            "*.h",
        },
        "stb/",
    },
    {
        "nanosvg/nanosvg-master/src/",
        {
            "*.h",
        },
        "nanosvg/",
    },
    {
        "expat/expat-2.4.8/",
        {
            "lib/expat.h",
            "lib/expat_external.h",
        },
    },
    {
        "portable-file-dialogs/portable-file-dialogs-main/",
        {
            "*.h",
        },
    },
}

for _, item in ipairs(headerFiles) do
    local target = includeDir.."/"
    if #item > 2 then
        target = target..item[3]
    end
    for _, f in ipairs(item[2]) do
        local source = os.scriptdir().."/"..item[1]..f
        if os.exists(source) or f == "*.h" then
            printf("cp %s %s\n", source, target)
            os.cp(source, target)
        end
    end
end
