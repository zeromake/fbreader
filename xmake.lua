add_rules("mode.debug", "mode.release")

set_languages("c17", "cxx20")

local VERSION = "0.14.0"
local SHAREDIR = "/share"
local IMAGEDIR = SHAREDIR.."/icons"

local SHAREDIR_MACRO = "~~\\\\share"
local IMAGEDIR_MACRO = SHAREDIR_MACRO.."\\\\icons"
local APPIMAGEDIR_MACRO = IMAGEDIR_MACRO
local INSTALLDIR_MACRO = ""

add_includedirs("3rd/.include")

add_defines(
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
        "_WIN32_IE=0x0501",
        "_WIN32_WINNT=0x0501",
        "WINVER=0x0500",
        "XMLCONFIGHOMEDIR=\"~\\\\..\"",
        "XMD_H",
        "FRIBIDI_LIB_STATIC",
        "CURL_STATICLIB",
        "PFD_HAS_IFILEDIALOG=0",
        "WIN32_USE_DRAW_TEXT"
    )
    -- add_ldflags("-mwindows")
    add_ldflags("-mconsole")
end

if is_plat("windows") then
    add_cxxflags("/utf-8")
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
    add_linkdirs("3rd/lib")
    add_includedirs("zlibrary/core/include", "3rd/include")
    for _, sub in ipairs(zlcoreSubDirs) do
        add_files(path.join("zlibrary/core", sub, "*.cpp"))
    end


target("zltext")
    set_kind("static")
    add_linkdirs("3rd/lib")
    add_includedirs("zlibrary/text/include", "zlibrary/core/include", "3rd/include")
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

if is_plat("windows", "mingw") then
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
end

target("zlui")
    set_kind("static")
    -- set_kind("shared")
    -- add_links("gdi32", "comctl32", "comdlg32")
    add_linkdirs("3rd/lib")
    add_includedirs("zlibrary/text/include", "zlibrary/core/include", "3rd/include")
    for _, sub in ipairs(zluiSubDirs) do
        add_files(path.join("zlibrary/ui", sub, "*.cpp"))
    end

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
    add_linkdirs("3rd/lib")
    add_includedirs("zlibrary/core/include", "zlibrary/text/include", "3rd/include")
    add_deps("zlcore", "zltext", "zlui")
    if is_plat("windows", "mingw") then
        add_links("png", "gif", "tiff", "jpeg")
        add_links("gdi32","comctl32", "comdlg32", "ws2_32", "crypt32", "wldap32")
        add_links("zlib")
        add_files("fbreader/win32/FBReader.rc")
    else
        add_links("z")
    end
    add_links("bzip2", "fribidi", "unibreak", "sqlite3", "curl", "expat")
    for _, sub in ipairs(fbreaderSubDirs) do
        add_files(path.join("fbreader", sub, "*.cpp"))
    end
