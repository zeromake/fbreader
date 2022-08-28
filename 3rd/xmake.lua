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
        import("package.tools.cmake").install(package, configs)
    end)
package_end()


package("ssh2")
    add_deps("cmake")
    set_sourcedir(path.join(os.scriptdir(), "ssh2/libssh2-1.10.0"))
    on_install(function (package)
        local configs = {}
        table.insert(configs, "-DCMAKE_BUILD_TYPE=" .. (package:debug() and "Debug" or "Release"))
        table.insert(configs, "-DBUILD_SHARED_LIBS=" .. (package:config("shared") and "ON" or "OFF"))
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

package("curl")
    add_deps("cmake")
    add_deps("ssh2")
    add_syslinks("bcrypt")
    add_links("bcrypt")
    set_sourcedir(path.join(os.scriptdir(), "curl/curl-7.84.0"))
    on_install(function (package)
        local configs = {}
        table.insert(configs, "-DCMAKE_BUILD_TYPE=" .. (package:debug() and "Debug" or "Release"))
        table.insert(configs, "-DBUILD_SHARED_LIBS=" .. (package:config("shared") and "ON" or "OFF"))
        import("package.tools.cmake").install(package, configs)
    end)
package_end()

add_requires("zlib", "png", "tiff", "ssh2")

target("jpeg")
    set_kind("static")
    on_load(function ()
        local jconfig = path.join(os.scriptdir(), "jpeg/jpeg-6b/jconfig.h")
        if not os.exists(jconfig) then
            local jconfigSource = "jconfig.mac"
            if is_plat("windows", "mingw") then
                jconfigSource = "jconfig.vc"
            end
            os.cp(path.join(os.scriptdir(), "jpeg/jpeg-6b"), jconfig)
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
        add_files(path.join(os.scriptdir(), "bzip/bzip2-1.0.6", f))
    end