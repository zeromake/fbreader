add_rules("mode.debug", "mode.release")

target("gif")
    set_kind("static")
    add_includedirs(path.join(os.scriptdir(),".include"))
    for _, f in ipairs({
        "dgif_lib.c",
        "egif_lib.c",
        "gifalloc.c",
        "gif_err.c",
        "gif_font.c",
	    "gif_hash.c",
        "openbsd-reallocarray.c",
    }) do
        add_files(path.join(os.scriptdir(), "gif/giflib-5.2.1", f))
    end


package("zlib")
    add_deps("cmake")
    set_sourcedir(path.join(os.scriptdir(), "zlib/zlib-1.2.12"))
    on_install(function (package)
        local configs = {}
        table.insert(configs, "-DCMAKE_BUILD_TYPE=" .. (package:debug() and "Debug" or "Release"))
        table.insert(configs, "-DBUILD_SHARED_LIBS=" .. (package:config("shared") and "ON" or "OFF"))
        import("package.tools.cmake").install(package, configs)
    end)
package_end()

package("png")
    add_deps("cmake")
    add_deps("zlib")
    set_sourcedir(path.join(os.scriptdir(), "png/lpng1637"))
    on_install(function (package)
        local configs = {}
        table.insert(configs, "-DCMAKE_BUILD_TYPE=" .. (package:debug() and "Debug" or "Release"))
        table.insert(configs, "-DBUILD_SHARED_LIBS=" .. (package:config("shared") and "ON" or "OFF"))
        import("package.tools.cmake").install(package, configs)
    end)
package_end()


package("tiff")
    add_deps("cmake")
    set_sourcedir(path.join(os.scriptdir(), "tiff/tiff-4.4.0"))
    on_install(function (package)
        local configs = {}
        table.insert(configs, "-DCMAKE_BUILD_TYPE=" .. (package:debug() and "Debug" or "Release"))
        table.insert(configs, "-DBUILD_SHARED_LIBS=" .. (package:config("shared") and "ON" or "OFF"))
        table.insert(configs, "-UJPEG_SUPPORT")
        table.insert(configs, "-UWEBP_SUPPORT")
        table.insert(configs, "-UZSTD_SUPPORT")
        import("package.tools.cmake").install(package, configs)
    end)
package_end()

package("jpeg-turbo")
    add_deps("cmake")
    set_sourcedir(path.join(os.scriptdir(), "jpeg-turbo/libjpeg-turbo-2.1.4"))
    on_install(function (package)
        local configs = {}
        table.insert(configs, "-DCMAKE_BUILD_TYPE=" .. (package:debug() and "Debug" or "Release"))
        table.insert(configs, "-DBUILD_SHARED_LIBS=" .. (package:config("shared") and "ON" or "OFF"))
        import("package.tools.cmake").install(package, configs)
    end)
package_end()

package("expat")
    add_deps("cmake")
    set_sourcedir(path.join(os.scriptdir(), "expat/expat-2.4.8"))
    on_install(function (package)
        local configs = {}
        table.insert(configs, "-DCMAKE_BUILD_TYPE=" .. (package:debug() and "Debug" or "Release"))
        table.insert(configs, "-DBUILD_SHARED_LIBS=" .. (package:config("shared") and "ON" or "OFF"))
        import("package.tools.cmake").install(package, configs)
    end)
package_end()

add_requires("zlib", "png", "tiff", "expat")

target("jpeg")
    set_kind("static")
    on_load(function ()
        local jconfig = path.join(os.scriptdir(), "jpeg/jpeg-6b/jconfig.h")
        if not os.exists(jconfig) then
            local jconfigSource = "jconfig.vc"
            if is_plat("macosx", "mingw") then
                jconfigSource = "jconfig.mac"
            end
            os.cp(path.join(os.scriptdir(), "jpeg/jpeg-6b", jconfigSource), jconfig)
        end
    end)
    for _, f in ipairs({
        "jcapimin.c",
        "jcapistd.c",
        "jctrans.c",
        "jcparam.c",
        "jdatadst.c",
        "jcinit.c",
        "jcmaster.c",
        "jcmarker.c",
        "jcmainct.c",
        "jcprepct.c",
        "jccoefct.c",
        "jccolor.c",
        "jcsample.c",
        "jchuff.c",
        "jcphuff.c",
        "jcdctmgr.c",
        "jfdctfst.c",
        "jfdctflt.c",
        "jfdctint.c",
        "jdapimin.c",
        "jdapistd.c",
        "jdtrans.c",
        "jdatasrc.c",
        "jdmaster.c",
        "jdinput.c",
        "jdmarker.c",
        "jdhuff.c",
        "jdphuff.c",
        "jdmainct.c",
        "jdcoefct.c",
        "jdpostct.c",
        "jddctmgr.c",
        "jidctfst.c",
        "jidctflt.c",
        "jidctint.c",
        "jidctred.c",
        "jdsample.c",
        "jdcolor.c",
        "jquant1.c",
        "jquant2.c",
        "jdmerge.c",
        "jcomapi.c",
        "jutils.c",
        "jerror.c",
        "jmemmgr.c",
        "jmemnobs.c",
    }) do
        add_files(path.join(os.scriptdir(), "jpeg/jpeg-6b", f))
    end

target("bzip2")
    set_kind("static")
    for _, f in ipairs({
        "blocksort.c",
        "huffman.c",
        "crctable.c",
        "randtable.c",
        "compress.c",
        "decompress.c",
        "bzlib.c",
    }) do
        add_files(path.join(os.scriptdir(), "bzip2/bzip2-1.0.6", f))
    end


target("unibreak")
    set_kind("static")
    for _, f in ipairs({
        "linebreak.c",
        "linebreakdata.c",
        "linebreakdef.c",
        "wordbreak.c",
        "graphemebreak.c",
        "emojidef.c",
        "unibreakbase.c",
        "unibreakdef.c",
    }) do
        add_files(path.join(os.scriptdir(), "unibreak/libunibreak-5.0/src", f))
    end

target("fribidi")
    set_kind("static")
    add_defines("FRIBIDI_BUILD", "FRIBIDI_LIB_STATIC", "HAVE_CONFIG_H")
    add_includedirs(path.join(os.scriptdir(), "fribidi/fribidi-1.0.12/lib"))
    add_includedirs(path.join(os.scriptdir(), "fribidi/fribidi-1.0.12"))
    on_load(function ()
        local config = path.join(os.scriptdir(), "fribidi/fribidi-1.0.12/config.h")
        local libconfig = path.join(os.scriptdir(), "fribidi/fribidi-1.0.12/lib/fribidi-config.h")
        if not os.exists(config) then
            local configContext = [[
#define HAVE_INTTYPES_H 1
#define HAVE_MEMMOVE 1
#define HAVE_MEMORY_H 1
#define HAVE_MEMSET 1
#define HAVE_STDINT_H 1
#define HAVE_STDLIB_H 1
#define HAVE_STRDUP 1
#define HAVE_STRINGIZE 1
#define HAVE_STRINGS_H 1
#define HAVE_STRING_H 1
#define HAVE_SYS_STAT_H 1
#define HAVE_SYS_TYPES_H 1
#define HAVE_UNISTD_H 1
#define HAVE_WCHAR_H 1
#define LT_OBJDIR ".libs/"
#define PACKAGE_BUGREPORT "https://github.com/fribidi/fribidi/issues/new"
#define PACKAGE_NAME "GNU FriBidi"
#define PACKAGE_STRING "GNU FriBidi 1.0.12"
#define PACKAGE_TARNAME "fribidi"
#define PACKAGE_URL "http://fribidi.org/"
#define PACKAGE_VERSION "1.0.12"
#define RETSIGTYPE void
#define SIZEOF_INT 4
#define SIZEOF_SHORT 2
#define SIZEOF_VOID_P 8
#define SIZEOF_WCHAR_T 2
#define STDC_HEADERS 1]]
            io.writefile(config, configContext)
        end
        
        if not os.exists(libconfig) then
            libconfigContext = [[
#ifndef FRIBIDI_CONFIG_H
#define FRIBIDI_CONFIG_H
#define FRIBIDI "fribidi"
#define FRIBIDI_NAME "GNU FriBidi"
#define FRIBIDI_BUGREPORT "https://github.com/fribidi/fribidi/issues/new"
#define FRIBIDI_VERSION "1.0.12"
#define FRIBIDI_MAJOR_VERSION 1
#define FRIBIDI_MINOR_VERSION 0
#define FRIBIDI_MICRO_VERSION 12
#define FRIBIDI_INTERFACE_VERSION 4
#define FRIBIDI_INTERFACE_VERSION_STRING "4"
#define FRIBIDI_SIZEOF_INT 4
#define FRIBIDI_BUILT_WITH_MSVC
#endif /* FRIBIDI_CONFIG_H */]]
            io.writefile(libconfig, libconfigContext)
        end
    end)
    for _, f in ipairs({
        'fribidi.c',
        'fribidi-arabic.c',
        'fribidi-bidi.c',
        'fribidi-bidi-types.c',
        'fribidi-char-sets.c',
        'fribidi-char-sets-cap-rtl.c',
        'fribidi-char-sets-cp1255.c',
        'fribidi-char-sets-cp1256.c',
        'fribidi-char-sets-iso8859-6.c',
        'fribidi-char-sets-iso8859-8.c',
        'fribidi-char-sets-utf8.c',
        'fribidi-deprecated.c',
        'fribidi-joining.c',
        'fribidi-joining-types.c',
        'fribidi-mirroring.c',
        'fribidi-brackets.c',
        'fribidi-run.c',
        'fribidi-shape.c',
    }) do
        add_files(path.join(os.scriptdir(), "fribidi/fribidi-1.0.12/lib", f))
    end

target("sqlite3")
    set_kind("static")
    for _, f in ipairs({
        "sqlite3.c",
    }) do
        add_files(path.join(os.scriptdir(), "sqlite3/sqlite-amalgamation-3390200", f))
    end