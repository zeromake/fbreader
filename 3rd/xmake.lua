add_rules("mode.debug", "mode.release")

set_languages("c17", "cxx20")

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

target("z")
    set_kind("static")
    on_config(function()
        local libconfig = path.join(os.scriptdir(), "zlib/zlib-1.2.12/zconf.h")
        if not os.exists(libconfig) then
            os.cp(path.join(os.scriptdir(), "zlib/zlib-1.2.12/zconf.h.in"), libconfig)
        end
    end)
    add_includedirs(path.join(os.scriptdir(), ".include"))
    for _, f in ipairs({
        "adler32.c",
        "crc32.c",
        "deflate.c",
        "infback.c",
        "inffast.c",
        "inflate.c",
        "inftrees.c",
        "trees.c",
        "zutil.c",
        "compress.c",
        "uncompr.c",
        "gzclose.c",
        "gzlib.c",
        "gzread.c",
        "gzwrite.c",
    }) do
        add_files(path.join(os.scriptdir(), "zlib/zlib-1.2.12", f))
    end

target("png")
    set_kind("static")
    add_deps("z")
    add_includedirs(path.join(os.scriptdir(), "zlib/zlib-1.2.12"))
    on_config(function()
        local libconfig = path.join(os.scriptdir(), "png/lpng1637/pnglibconf.h")
        if not os.exists(libconfig) then
            os.cp(path.join(os.scriptdir(), "pre/png/pnglibconf.h"), libconfig)
        end
    end)
    for _, f in ipairs({
        "png.c",
        "pngerror.c",
        "pngget.c",
        "pngmem.c",
        "pngpread.c",
        "pngread.c",
        "pngrio.c",
        "pngrtran.c",
        "pngrutil.c",
        "pngset.c",
        "pngtrans.c",
        "pngwio.c",
        "pngwrite.c",
        "pngwtran.c",
        "pngwutil.c",
    }) do
        add_files(path.join(os.scriptdir(), "png/lpng1637", f))
    end

    if is_arch("arm*") then
        for _, f in ipairs({
            "arm/arm_init.c",
            "arm/filter_neon.S",
            "arm/filter_neon_intrinsics.c",
            "arm/palette_neon_intrinsics.c",
        }) do
            add_files(path.join(os.scriptdir(), "png/lpng1637", f))
        end
    end

    if is_arch("mips*") then
        for _, f in ipairs({
            "mips/mips_init.c",
            "mips/filter_msa_intrinsics.c",
        }) do
            add_files(path.join(os.scriptdir(), "png/lpng1637", f))
        end
    end

    if is_arch("x86_64", "i386") then
        for _, f in ipairs({
            "intel/intel_init.c",
            "intel/filter_sse2_intrinsics.c",
        }) do
            add_files(path.join(os.scriptdir(), "png/lpng1637", f))
        end
    end

    if is_arch("powerpc*") then
        for _, f in ipairs({
            "powerpc/powerpc_init.c",
            "powerpc/filter_vsx_intrinsics.c",
        }) do
            add_files(path.join(os.scriptdir(), "png/lpng1637", f))
        end
    end

local tiffSourceDir = path.join(os.scriptdir(), "tiff/tiff-4.4.0/libtiff")
local jpegSourceDir = path.join(os.scriptdir(), "jpeg/jpeg-9e")

target("tiff")
    set_kind("static")
    -- set_kind("shared")
    add_deps("jpeg", "z")
    add_includedirs(path.join(os.scriptdir(), "zlib/zlib-1.2.12"))
    add_includedirs(jpegSourceDir)
    add_includedirs(path.join(os.scriptdir(), ".include"))
    on_config(function()
        local libconfig = path.join(tiffSourceDir, "tif_config.h")
        if not os.exists(libconfig) then
            os.cp(path.join(os.scriptdir(), "pre/tiff/tif_config.h"), libconfig)
            os.cp(path.join(os.scriptdir(), "pre/tiff/tiffconf.h"), path.join(tiffSourceDir, "tiffconf.h"))
        end
    end)
    for _, f in ipairs({
        "tif_aux.c",
        "tif_close.c",
        "tif_codec.c",
        "tif_color.c",
        "tif_compress.c",
        "tif_dir.c",
        "tif_dirinfo.c",
        "tif_dirread.c",
        "tif_dirwrite.c",
        "tif_dumpmode.c",
        "tif_error.c",
        "tif_extension.c",
        "tif_fax3.c",
        "tif_fax3sm.c",
        "tif_flush.c",
        "tif_getimage.c",
        "tif_jbig.c",
        "tif_jpeg.c",
        "tif_jpeg_12.c",
        "tif_lerc.c",
        "tif_luv.c",
        "tif_lzma.c",
        "tif_lzw.c",
        "tif_next.c",
        "tif_ojpeg.c",
        "tif_open.c",
        "tif_packbits.c",
        "tif_pixarlog.c",
        "tif_predict.c",
        "tif_print.c",
        "tif_read.c",
        "tif_strip.c",
        "tif_swab.c",
        "tif_thunder.c",
        "tif_tile.c",
        "tif_version.c",
        "tif_warning.c",
        "tif_webp.c",
        "tif_write.c",
        "tif_zip.c",
        "tif_zstd.c",
    }) do
        add_files(path.join(tiffSourceDir, f))
    end
    if is_plat("windows", "mingw") then
        add_defines("USE_WIN32_FILEIO=1", "HAVE_IO_H=1")
        add_files(path.join(tiffSourceDir, "tif_win32.c"))
    else
        add_files(path.join(tiffSourceDir, "tif_unix.c"))
    end



target("jpeg")
    set_kind("static")
    -- set_kind("shared")
    on_config(function ()
        local jconfig = path.join(jpegSourceDir, "jconfig.h")
        if not os.exists(jconfig) then
            local jconfigSource = path.join(jpegSourceDir,"jconfig.vc")
            if is_plat("macosx") then
                jconfigSource = path.join(os.scriptdir(), "pre/jpeg/jconfig.h")
            end
            os.cp(jconfigSource, jconfig)
        end
    end)
    for _, f in ipairs({
        "jaricom.c",
        "jcapimin.c",
        "jcapistd.c",
        "jcarith.c",
        "jccoefct.c",
        "jccolor.c",
        "jcdctmgr.c",
        "jchuff.c",
        "jcinit.c",
        "jcmainct.c",
        "jcmarker.c",
        "jcmaster.c",
        "jcomapi.c",
        "jcparam.c",
        "jcprepct.c",
        "jcsample.c",
        "jctrans.c",
        "jdapimin.c",
        "jdapistd.c",
        "jdarith.c",
        "jdatadst.c",
        "jdatasrc.c",
        "jdcoefct.c",
        "jdcolor.c",
        "jddctmgr.c",
        "jdhuff.c",
        "jdinput.c",
        "jdmainct.c",
        "jdmarker.c",
        "jdmaster.c",
        "jdmerge.c",
        "jdpostct.c",
        "jdsample.c",
        "jdtrans.c",
        "jerror.c",
        "jfdctflt.c",
        "jfdctfst.c",
        "jfdctint.c",
        "jidctflt.c",
        "jidctfst.c",
        "jidctint.c",
        "jquant1.c",
        "jquant2.c",
        "jutils.c",
        "jmemmgr.c",
        "jmemansi.c",
    }) do
        add_files(path.join(jpegSourceDir, f))
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
    if is_plat("mingw") then
        add_defines("HAVE_STRINGS_H=1")
    end
    add_includedirs(path.join(os.scriptdir(), "fribidi/fribidi-1.0.12/lib"))
    add_includedirs(path.join(os.scriptdir(), "fribidi/fribidi-1.0.12"))
    on_config(function ()
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

target("expat")
    set_kind("static")
    add_includedirs(path.join(os.scriptdir(), "pre/expat"))
    for _, f in ipairs({
        "lib/xmlparse.c",
        "lib/xmlrole.c",
        "lib/xmltok.c",
    }) do
        add_files(path.join(os.scriptdir(), "expat/expat-2.4.8", f))
    end
    -- if is_plat("windows", "mingw") then
    --     add_defines("VER_FILEVERSION=248")
    --     add_files(path.join(os.scriptdir(), "expat/expat-2.4.8", "win32/version.rc"))
    -- end

-- package("expat")
--     add_deps("cmake")
--     set_sourcedir(path.join(os.scriptdir(), "expat/expat-2.4.8"))
--     on_install(function (package)
--         local configs = {}
--         table.insert(configs, "-DCMAKE_BUILD_TYPE=" .. (package:debug() and "Debug" or "Release"))
--         table.insert(configs, "-DBUILD_SHARED_LIBS=" .. (package:config("shared") and "ON" or "OFF"))
--         import("package.tools.cmake").install(package, configs)
--     end)
-- package_end()

-- add_requires("expat")

target("wolfssl")
    set_kind("static")
    -- set_kind("shared")
    on_config(function ()
        local sourceConfig = path.join(os.scriptdir(), "wolfssl/wolfssl-5.5.0-stable/wolfssl/options.h.in")
        local targetConfig = path.join(os.scriptdir(), "wolfssl/wolfssl-5.5.0-stable/wolfssl/options.h")
        if not os.exists(targetConfig) then
            os.cp(sourceConfig, targetConfig)
        end
    end)
    add_defines("SIZEOF_LONG_LONG=8", "WOLFSSL_DES_ECB", "WOLFSSL_LIB", "WOLFSSL_USER_SETTINGS", "CYASSL_USER_SETTINGS")
    add_includedirs(
        path.join(os.scriptdir(), "wolfssl/wolfssl-5.5.0-stable"),
        path.join(os.scriptdir(), "wolfssl/wolfssl-5.5.0-stable/IDE/WIN"))
    add_links("ws2_32")
    for _, f in ipairs({
        "src/crl.c",
        "src/dtls13.c",
        "src/dtls.c",
        "src/internal.c",
        "src/wolfio.c",
        "src/keys.c",
        "src/ocsp.c",
        "src/ssl.c",
        "src/tls.c",
        "src/tls13.c",
        "wolfcrypt/src/aes.c",
        "wolfcrypt/src/arc4.c",
        "wolfcrypt/src/asn.c",
        "wolfcrypt/src/blake2b.c",
        "wolfcrypt/src/blake2s.c",
        "wolfcrypt/src/camellia.c",
        "wolfcrypt/src/chacha.c",
        "wolfcrypt/src/chacha20_poly1305.c",
        "wolfcrypt/src/cmac.c",
        "wolfcrypt/src/coding.c",
        "wolfcrypt/src/curve25519.c",
        "wolfcrypt/src/curve448.c",
        "wolfcrypt/src/cpuid.c",
        "wolfcrypt/src/des3.c",
        "wolfcrypt/src/dh.c",
        "wolfcrypt/src/dsa.c",
        "wolfcrypt/src/ecc.c",
        "wolfcrypt/src/ed25519.c",
        "wolfcrypt/src/ed448.c",
        "wolfcrypt/src/error.c",
        "wolfcrypt/src/fe_448.c",
        "wolfcrypt/src/fe_low_mem.c",
        "wolfcrypt/src/fe_operations.c",
        "wolfcrypt/src/ge_448.c",
        "wolfcrypt/src/ge_low_mem.c",
        "wolfcrypt/src/ge_operations.c",
        "wolfcrypt/src/hash.c",
        "wolfcrypt/src/hmac.c",
        "wolfcrypt/src/integer.c",
        "wolfcrypt/src/kdf.c",
        "wolfcrypt/src/logging.c",
        "wolfcrypt/src/md2.c",
        "wolfcrypt/src/md4.c",
        "wolfcrypt/src/md5.c",
        "wolfcrypt/src/memory.c",
        "wolfcrypt/src/pkcs7.c",
        "wolfcrypt/src/pkcs12.c",
        "wolfcrypt/src/poly1305.c",
        "wolfcrypt/src/pwdbased.c",
        "wolfcrypt/src/random.c",
        "wolfcrypt/src/rc2.c",
        "wolfcrypt/src/ripemd.c",
        "wolfcrypt/src/rsa.c",
        "wolfcrypt/src/sha.c",
        "wolfcrypt/src/sha256.c",
        "wolfcrypt/src/sha3.c",
        "wolfcrypt/src/sha512.c",
        "wolfcrypt/src/signature.c",
        "wolfcrypt/src/sp_c32.c",
        "wolfcrypt/src/sp_c64.c",
        "wolfcrypt/src/sp_int.c",
        "wolfcrypt/src/sp_x86_64.c",
        "wolfcrypt/src/srp.c",
        "wolfcrypt/src/tfm.c",
        "wolfcrypt/src/wc_encrypt.c",
        "wolfcrypt/src/wc_pkcs11.c",
        "wolfcrypt/src/wc_port.c",
        "wolfcrypt/src/wolfmath.c",
        "wolfcrypt/src/wolfevent.c",
    }) do
        add_files(path.join(os.scriptdir(), "wolfssl/wolfssl-5.5.0-stable", f))
    end
    if is_plat("windows") then
        add_links("advapi32")
        local list = {
            "wolfssl.rc",
        }
        if is_arch("x86_64") then
            table.join2(
                list,
                {
                    "wolfcrypt/src/aes_asm.asm",
                    "wolfcrypt/src/sp_x86_64_asm.asm",
                }
            )
        end
        for _, f in ipairs(list) do
            add_files(path.join(os.scriptdir(), "wolfssl/wolfssl-5.5.0-stable", f))
        end
    else
        for _, f in ipairs({
            "wolfcrypt/src/aes_asm.S",
            "wolfcrypt/src/sp_x86_64_asm.S",
        }) do
            add_files(path.join(os.scriptdir(), "wolfssl/wolfssl-5.5.0-stable", f))
        end
    end

local libcurlDir = "libcurl/curl-7.85.0"

target("curl")
    set_kind("static")
    -- set_kind("shared")
    -- add_cxflags("/D UNICODE")

    add_defines("SIZEOF_LONG_LONG=8", "WOLFSSL_DES_ECB", "WOLFSSL_LIB", "WOLFSSL_USER_SETTINGS", "CYASSL_USER_SETTINGS")
    add_files(path.join(os.scriptdir(), libcurlDir, "lib/*.c"))
    add_files(path.join(os.scriptdir(), libcurlDir, "lib/vtls/*.c"))
    add_files(path.join(os.scriptdir(), libcurlDir, "lib/vauth/*.c"))
    add_includedirs(
        path.join(os.scriptdir(), "wolfssl/wolfssl-5.5.0-stable"),
        path.join(os.scriptdir(), "wolfssl/wolfssl-5.5.0-stable/IDE/WIN"),
        path.join(os.scriptdir(), libcurlDir, "lib"),
        path.join(os.scriptdir(), libcurlDir, "include"),
        path.join(os.scriptdir(), "zlib/zlib-1.2.12")
    )
    -- add_defines("SIZEOF_LONG_LONG=8", "WOLFSSL_DES_ECB", "WOLFSSL_LIB","WOLFSSL_USER_SETTINGS","CYASSL_USER_SETTINGS","WOLFSSL_USER_SETTINGS")
    add_defines(
        "USE_WOLFSSL",
        "WIN32",
        "BUILDING_LIBCURL",
        "CURL_STATICLIB",
        "HAVE_LIBZ",
        "HAVE_ZLIB_H",
        -- "UNICODE",
        -- "_UNICODE",
        "USE_WIN32_LDAP"
    )
    add_links("ws2_32", "wldap32", "crypt32", "bcrypt")
    add_deps("wolfssl", "z")
