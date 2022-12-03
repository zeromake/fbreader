add_rules("mode.debug", "mode.release")

set_languages("cxx20")


local require_names = {
    "zlib",
    "bzip2",
    "expat",
    "fribidi",
    "unibreak",
    "sqlite3",
    "curl",
    "wolfssl",
}

for _, require_name in ipairs(require_names) do
    add_requires(require_name, {system=false})
end

if is_host("windows", "mingw") then
    local windows_require_names = {
        "png",
        "gif",
        "tiff",
        "jpeg"
    }
    for _, require_name in ipairs(windows_require_names) do
        add_requires(require_name, {system=false})
    end
end

local VERSION = os.getenv("VERSION") or "v0.0.0"
local SHAREDIR = "/share"
local IMAGEDIR = SHAREDIR.."/icons"

if VERSION:startswith("v") then
    VERSION = VERSION:sub(2)
end
local installDir = ""

local SHAREDIR_MACRO = nil
local IMAGEDIR_MACRO = nil
local APPIMAGEDIR_MACRO = nil

if is_host("macosx") then
    installDir = "/fbreader.app"
    SHAREDIR_MACRO = "~~/Contents/Share"
    IMAGEDIR_MACRO = SHAREDIR_MACRO.."/icons"
    APPIMAGEDIR_MACRO = SHAREDIR_MACRO.."/icons"
elseif is_host("windows", "mingw") then
    SHAREDIR_MACRO = "~~\\\\share"
    IMAGEDIR_MACRO = SHAREDIR_MACRO.."\\\\icons"
    APPIMAGEDIR_MACRO = IMAGEDIR_MACRO
    add_includedirs("3rd/.include")
end

local INSTALLDIR_MACRO = installDir
local arch = os.getenv("ARCH") or "x64"
local is32bit = arch ~= "x64" and arch ~= "arm64"
local isarm64 = arch == "arm64"

-- add_includedirs("3rd/include")

-- add_linkdirs("3rd/lib-"..arch)

add_defines(
    "XML_STATIC",
    "INSTALLDIR=\""..INSTALLDIR_MACRO.."\"",
    "BASEDIR=\""..SHAREDIR_MACRO.."\"",
    "LIBDIR=\"\"",
    "IMAGEDIR=\""..IMAGEDIR_MACRO.."\"",
    "APPIMAGEDIR=\""..APPIMAGEDIR_MACRO.."\"",
    "VERSION=\""..VERSION.."\""
)

if is_host("windows", "mingw") then
    add_defines(
        "UNICODE",
        "_UNICODE",
        "_WIN32_IE=0x0501",
        "_WIN32_WINNT=0x0501",
        "WINVER=0x0501",
        "XMD_H",
        "FRIBIDI_LIB_STATIC",
        "CURL_STATICLIB",
        "PFD_HAS_IFILEDIALOG=0",
        "WIN32_USE_DRAW_TEXT"
    )
end

if is_host("windows") then
    add_cxxflags("/utf-8", "/UNICODE")
    -- add_ldflags("/SUBSYSTEM:WINDOWS")
elseif is_host("mingw") then
	add_cxxflags("-municode")
	add_ldflags("-municode", {force = true})
	-- add_ldflags("-Wl,--subsystem,windows", {force = true})
    -- add_ldflags("-mwindows")
    add_defines("PFD_HAS_IFILEDIALOG=0", "PFD_HAS_DUPENV_S=0")
end

local zlcoreSubDirs = {
    "src/library",
    "src/typeId",
    "src/util",
    "src/constants",
    "src/logger",
    "src/filesystem",
    "src/filesystem/zip",
    "src/filesystem/bzip2",
    "src/filesystem/tar",
    "src/dialogs",
    "src/optionEntries",
    "src/application",
    "src/view",
    "src/encoding",
    "src/options",
    "src/message",
    "src/resources",
    "src/time",
    "src/xml",
    "src/xml/expat",
    "src/image",
    "src/language",
    "src/unix/time",
    "src/runnable",
    "src/network",
    "src/network/requests",
    "src/blockTreeView",
    "src/unix/curl",
}

if is_host("windows", "mingw") then
    table.join2(zlcoreSubDirs, {
        "src/desktop/application",
        "src/desktop/dialogs",
        "src/win32/encoding",
        "src/win32/filesystem",
        "src/win32/config",
    })
else
    table.join2(zlcoreSubDirs, {
        "src/unix/xmlconfig",
        "src/unix/filesystem",
        "src/unix/iconv",
        "src/unix/library",
    })
end

target("zlcore")
    set_kind("static")
    -- set_kind("shared")
    add_packages("zlib", "bzip2", "expat", "curl")
    add_includedirs("zlibrary/core/include")
    for _, sub in ipairs(zlcoreSubDirs) do
        add_files(path.join("zlibrary/core", sub, "*.cpp"))
    end


target("zltext")
    set_kind("static")
    add_packages("unibreak", "fribidi")
    add_includedirs("zlibrary/text/include", "zlibrary/core/include")
    for _, sub in ipairs({
        "src/model",
        "src/area",
        "src/view",
        "src/style",
        "src/styleOptions",
        "src/hyphenation",
    }) do
        add_files(path.join("zlibrary/text", sub, "*.cpp"))
    end

local zluiSubDirs = {}

if is_host("windows") then
    table.join2(zluiSubDirs, {
        "src/win32/application",
        "src/win32/dialogs",
        "src/win32/image",
        "src/win32/library",
        "src/win32/message",
        "src/win32/time",
        "src/win32/view",
        "src/win32/w32widgets",
    })
elseif is_host("macosx") then
    table.join2(zluiSubDirs, {
        "src/cocoa/application",
        "src/cocoa/dialogs",
        "src/cocoa/filesystem",
        "src/cocoa/image",
        "src/cocoa/library",
        "src/cocoa/message",
        "src/cocoa/time",
        "src/cocoa/util",
        "src/cocoa/view",
    })
end

target("zlui")
    set_kind("static")
    -- set_kind("shared")
    -- add_links("gdi32", "comctl32", "comdlg32")
    add_packages("curl")
    if is_host("windows", "mingw") then
        add_packages("gif", "png", "jpeg", "tiff")
    elseif is_host("macosx") then
        set_values("objc.build.arc", false)
        add_mxxflags("-fno-objc-arc")
    end
    add_includedirs("zlibrary/text/include", "zlibrary/core/include")
    for _, sub in ipairs(zluiSubDirs) do
        if is_host("macosx") then
            add_files(path.join("zlibrary/ui", sub, "*.mm"))
        else
            add_files(path.join("zlibrary/ui", sub, "*.cpp"))
        end
    end
    remove_files(
        "zlibrary/ui/src/cocoa/application/CocoaWindow.mm",
        "zlibrary/ui/src/cocoa/library/ZLCocoaAppDelegate.mm"
    )

local fbreaderSubDirs = {
    "src/database/sqldb",
    "src/database/sqldb/implsqlite",
    "src/database/booksdb",
    "src/database/booksdb/runnables",
    "src/migration",
    "src/options",
    "src/library",
    "src/bookmodel",
    "src/formats",
    "src/formats/fb2",
    "src/formats/css",
    "src/formats/html",
    "src/formats/pdb",
    "src/formats/txt",
    "src/formats/tcr",
    "src/formats/chm",
    "src/formats/xhtml",
    "src/formats/oeb",
    "src/formats/rtf",
    "src/formats/openreader",
    "src/formats/util",
    "src/external",
    "src/fbreader",
    "src/encodingOption",
    "src/network",
    "src/network/authentication",
    "src/network/authentication/basic",
    "src/network/atom",
    "src/network/opds",
    "src/network/authentication/litres",
    "src/blockTree",
    "src/libraryActions",
    "src/libraryTree",
    "src/networkActions",
    "src/networkTree",
    "src/optionsDialog",
    "src/optionsDialog/bookInfo",
    "src/optionsDialog/library",
    "src/optionsDialog/network",
    "src/optionsDialog/system",
    "src/optionsDialog/reading",
    "src/optionsDialog/lookAndFeel",
}

target("fbreader")
    set_kind("binary")
    add_includedirs("zlibrary/core/include", "zlibrary/text/include")
    add_deps("zlcore", "zltext", "zlui")
    -- 3rd link
    add_packages("zlib", "sqlite3", "wolfssl")
    if is_host("macosx") then
        set_values("objc.build.arc", false)
        add_mxxflags("-fno-objc-arc")
        add_frameworks("Cocoa")
        add_links("iconv", "stdc++")
        add_files(
            "zlibrary/ui/src/cocoa/application/CocoaWindow.mm",
            "zlibrary/ui/src/cocoa/library/ZLCocoaAppDelegate.mm"
        )
    end
    if is_host("windows", "mingw") then
        -- windows lib link
        add_syslinks("user32", "gdi32", "shell32", "comctl32", "comdlg32", "ws2_32", "crypt32", "advapi32", "wldap32", "bcrypt")
        -- windows rc
        add_files("fbreader/win32/FBReader.rc")
    end
    if is_host("windows") ~= true and is_host("windows") then
        add_ldflags("-static-libgcc", "-static-libstdc++")
    end
    for _, sub in ipairs(fbreaderSubDirs) do
        add_files(path.join("fbreader", sub, "*.cpp"))
    end

target("statisticsGenerator")
    set_kind("binary")
    add_deps("zlcore")
    add_includedirs("zlibrary/core/include", "zlibrary/core/src/language")
    add_files("tools/StatisticsGenerator/generator.cpp")
    add_files("tools/StatisticsGenerator/initLibrary.cpp")
    if is_host("windows") then
        add_includedirs("zlibrary/core/src/win32/filesystem")
    else
        add_includedirs("zlibrary/core/src/unix/filesystem")
    end
    add_syslinks("shell32")

target("languageDetector")
    set_kind("binary")
    add_deps("zlcore")
    add_includedirs("zlibrary/core/include", "zlibrary/core/src/language")
    add_files("tools/StatisticsGenerator/detector.cpp")
    add_files("tools/StatisticsGenerator/initLibrary.cpp")
    if is_host("windows") then
        add_includedirs("zlibrary/core/src/win32/filesystem")
    else
        add_includedirs("zlibrary/core/src/unix/filesystem")
    end
    add_syslinks("shell32")

target("patternGenerator")
    set_kind("binary")
    add_deps("zlcore")
    add_includedirs("zlibrary/core/include", "zlibrary/core/src/language")
    add_files("tools/StatisticsGenerator/pattern.cpp")
    add_files("tools/StatisticsGenerator/initLibrary.cpp")
    if is_host("windows") then
        add_includedirs("zlibrary/core/src/win32/filesystem")
    else
        add_includedirs("zlibrary/core/src/unix/filesystem")
    end
    add_syslinks("shell32")
