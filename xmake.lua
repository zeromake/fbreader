add_rules("mode.debug", "mode.release")

set_languages("cxx20")

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
elseif is_host("windows") then
    SHAREDIR_MACRO = "~~\\\\share"
    IMAGEDIR_MACRO = SHAREDIR_MACRO.."\\\\icons"
    APPIMAGEDIR_MACRO = IMAGEDIR_MACRO
    add_includedirs("3rd/.include")
end

local INSTALLDIR_MACRO = installDir
local is32bit = os.getenv("ARCH") == "x86"

add_includedirs("3rd/include")

if is32bit then
    add_linkdirs("3rd/lib32")
else
    add_linkdirs("3rd/lib")
end

add_defines(
    "XML_STATIC",
    "INSTALLDIR=\""..INSTALLDIR_MACRO.."\"",
    "BASEDIR=\""..SHAREDIR_MACRO.."\"",
    "LIBDIR=\"\"",
    "IMAGEDIR=\""..IMAGEDIR_MACRO.."\"",
    "APPIMAGEDIR=\""..APPIMAGEDIR_MACRO.."\"",
    "VERSION=\""..VERSION.."\""
)

if is_plat("windows", "mingw") then
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

if is_plat("windows") then
    add_cxxflags("/utf-8", "/UNICODE")
    add_ldflags("/SUBSYSTEM:WINDOWS")
elseif is_plat("mingw") then
	add_cxxflags("-municode")
	add_ldflags("-municode", {force = true})
	-- add_ldflags("-Wl,--subsystem,windows", {force = true})
    add_ldflags("-mwindows")
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

if is_plat("windows", "mingw") then
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
    -- add_links("zlib", "bzip2", "expat", "curl")
    add_includedirs("zlibrary/core/include")
    for _, sub in ipairs(zlcoreSubDirs) do
        add_files(path.join("zlibrary/core", sub, "*.cpp"))
    end


target("zltext")
    set_kind("static")
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
        "src/win32/view",
        "src/win32/w32widgets",
        "src/win32/dialogs",
        "src/win32/application",
        "src/win32/image",
        "src/win32/library",
        "src/win32/time",
        "src/win32/message",
    })
elseif is_host("macosx") then
    table.join2(zluiSubDirs, {
        "src/cocoa/application",
        "src/cocoa/filesystem",
        "src/cocoa/library",
        "src/cocoa/view",
        "src/cocoa/dialogs",
        "src/cocoa/image",
        "src/cocoa/time",
        "src/cocoa/util",
        "src/cocoa/message",
    })
end

target("zlui")
    set_kind("static")
    -- set_kind("shared")
    -- add_links("gdi32", "comctl32", "comdlg32")
    if is_host("macosx") then
        set_values("objc.build.arc", false)
        add_mxxflags("-fno-objc-arc")
    end
    add_includedirs("zlibrary/text/include", "zlibrary/core/include")
    for _, sub in ipairs(zluiSubDirs) do
        if is_host("macosx") then
            add_files(path.join("zlibrary/ui", sub, "*.M"))
        else
            add_files(path.join("zlibrary/ui", sub, "*.cpp"))
        end
    end
    remove_files(
        "zlibrary/ui/src/cocoa/application/CocoaWindow.M",
        "zlibrary/ui/src/cocoa/library/ZLCocoaAppDelegate.M"
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
    add_links("z", "bzip2", "expat", "fribidi", "unibreak", "sqlite3", "curl")
    if is_host("macosx") then
        set_values("objc.build.arc", false)
        add_mxxflags("-fno-objc-arc")
        add_frameworks("Cocoa")
        add_links("iconv", "stdc++")
        add_ldflags("-static-libstdc++")
        local buildMode = "debug"
        if is_mode("release") then
            buildMode = "release"
        end
        add_files(
            "zlibrary/ui/src/cocoa/application/CocoaWindow.M",
            "zlibrary/ui/src/cocoa/library/ZLCocoaAppDelegate.M"
        )
    end
    if is_plat("windows", "mingw") then
        add_links("wolfssl")
        -- windows lib link
        add_links("png", "gif", "tiff", "jpeg")
        add_links("user32", "gdi32", "shell32", "comctl32", "comdlg32", "ws2_32", "crypt32", "advapi32", "wldap32", "bcrypt")
        -- windows rc
        add_files("fbreader/win32/FBReader.rc")
    end
    if is_plat("windows") ~= true and is_host("windows") then
        add_ldflags("-static-libgcc", "-static-libstdc++")
    end
    for _, sub in ipairs(fbreaderSubDirs) do
        add_files(path.join("fbreader", sub, "*.cpp"))
    end
