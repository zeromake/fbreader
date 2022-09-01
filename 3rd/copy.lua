os.mkdir("include")
os.mkdir("lib")

os.cp("build/mingw/x86_64/release/*.a", "lib/")


for _, dir in ipairs(os.dirs("build/.packages/**/include")) do
    local d = path.directory(dir)
    os.cp(path.join(dir, "*.h"), "include/")
    os.cp(path.join(d, "lib/*.a"), "lib/")
end

os.cp("curl/curl-7.83.1_2-win64-mingw/lib/*.a", "lib/")

local headerFiles = {
    {
        "bzip2/bzip2-1.0.6/",
        {
            "bzlib.h",
        }
    },
    {
        "curl/curl-7.83.1_2-win64-mingw/include/",
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
        "zlib/zlib-1.2.12/",
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
    }
}

for _, item in ipairs(headerFiles) do
    local target = "include/"
    if #item > 2 then
        target = target..item[3]
    end
    for _, f in ipairs(item[2]) do
        os.cp(item[1]..f, target)
    end
end
