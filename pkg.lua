import("lib.detect.find_program")

local zlibraryData = {}

local arch = os.getenv("ARCH") or "x64"
if arch == "x86_64" then
    arch = "x64"
end
local is32bit = arch ~= "x64" and arch ~= "arm64"
local isarm64 = arch == "arm64"
local out = path.join(os.scriptdir(), "dist", arch)
local shareOut = path.join(os.scriptdir(), "dist", arch, "share")

local localization = nil

if is_host("windows") then
    localization = {
        keyname = "win32-win32",
        help = "win32",
        fullscreen_toolbar = "desktop",
        core_config = "win32",
        config = "win32",
        external = "win32",
        keymap = "win32",
        styles = "win32",
        toolbar = "desktop",
        icon = "win32",
    }
elseif is_host("macosx") then
    localization = {
        keyname = "macosx-cocoa",
        help = "desktop",
        fullscreen_toolbar = "macosx",
        core_config = "macosx",
        config = "macosx",
        external = "macosx",
        keymap = "macosx",
        styles = "desktop",
        toolbar = "macosx",
        icon = "desktop",
    }
    out = path.join(os.scriptdir(), "dist", arch, "fbreader.app")
    shareOut = path.join(out, "Contents/Share")
end

local function sub(dir, out, items)
    for _, f in ipairs(items) do
        local target = f[1]
        if #f > 1 then
            target = f[2]
        end
        local hasLast = target:endswith("/")
        local targetPath = path.join(shareOut, out, target)
        if hasLast then
            targetPath = targetPath.."/"
        end
        local item = {path.join(os.scriptdir(), dir, f[1]), targetPath}
        table.insert(zlibraryData, item)
    end
end

sub("zlibrary/core/data", "zlibrary", {
    {"encodings/*", "encodings/"},
    {"resources/*", "resources/"},
    {"languagePatterns.zip"},
    {"unicode.xml.gz"},
})

sub("zlibrary/text/data", "zlibrary", {
    {"hyphenationPatterns.zip"},
})

sub("zlibrary/ui/data", "zlibrary", {
    {format("keynames.%s.xml", localization["keyname"]), "keynames.xml"},
})

-- fbreader
local helps = {}
local langs = nil
if is_host("windows") then
    langs = {
        "bg",
        "cs",
        "de",
        "en",
        "eo",
        "es",
        "fi",
        "hu",
        "id",
        "it",
        "lt",
        "pl",
        "sv",
        "uk",
        "vi",
        "zh",
    }
elseif is_host("macosx") then
    langs = {
        "bg",
        "cs",
        "de",
        "en",
        "es",
        "fi",
        "hu",
        "id",
        "it",
        "lt",
        "sv",
        "uk",
        "vi",
        "zh",
    }
end
for _, l in ipairs(langs) do
    table.insert(helps, {string.format("help/MiniHelp.%s.%s.fb2", localization["help"], l), string.format("help/MiniHelp.%s.fb2", l)})
end

local coreConfig = path.join(os.scriptdir(), "zlibrary/core/data/default", format("config.%s.xml", localization["core_config"]))
if os.exists(coreConfig) then
    table.insert(zlibraryData, {coreConfig, path.join(shareOut, "zlibrary/default/config.xml")})
end

local fbreaderConfig = path.join(os.scriptdir(), "fbreader/data/default", format("config.%s.xml", localization["config"]))
if os.exists(fbreaderConfig) then
    table.insert(zlibraryData, {fbreaderConfig, path.join(shareOut, "FBReader/default/config.xml")})
end

local fullscreenToolbar = path.join(os.scriptdir(), "fbreader/data/default", format("fullscreen_toolbar.%s.xml", localization["fullscreen_toolbar"]))
if os.exists(fullscreenToolbar) then
    table.insert(zlibraryData, {fullscreenToolbar, path.join(shareOut, "FBReader/default/fullscreen_toolbar.xml")})
end

sub("fbreader/data", "FBReader", table.join({
    {format("default/external.%s.xml", localization["external"]), "default/external.xml"},
    {format("default/keymap.%s.xml", localization["keymap"]), "default/keymap.xml"},
    {format("default/styles.%s.xml", localization["styles"]), "default/styles.xml"},
    {format("default/toolbar.%s.xml", localization["toolbar"]), "default/toolbar.xml"},
    {"formats/fb2", "formats/"},
    {"formats/html", "formats/"},
    {"formats/xhtml", "formats/"},
    {"network/*", "network/"},
    {"resources/*.xml", "resources/"},
    {format("icons/toolbar/%s/*", localization["icon"]), "../icons/"},
    {format("icons/filetree/%s/*", localization["icon"]), "../icons/"},
    {"icons/booktree/new/*", "../icons/"},
}, helps))


local fbreaders = nil
if is32bit then
    fbreaders = {
        "build/windows/x86/release/fbreader.exe",
        "build/mingw/x86/release/fbreader.exe",
        "build/windows/x86/debug/fbreader.exe",
        "build/mingw/x86/debug/fbreader.exe",
    }
else
    fbreaders = {
        "build/windows/x64/release/fbreader.exe",
        "build/mingw/x86_64/release/fbreader.exe",
        "build/windows/x64/debug/fbreader.exe",
        "build/mingw/x86_64/debug/fbreader.exe",
    }
end

if is_host("windows") then
    for _, f in ipairs(fbreaders) do
        f = path.join(os.scriptdir(), f)
        if os.exists(f) then
            local t = path.join(out, "fbreader.exe")
            table.insert(zlibraryData, {f, t})
            break
        end
    end
elseif is_host("macosx") then
    local bins = {}
    if isarm64 then
        bins = {
            "build/macosx/arm64/release/fbreader",
            "build/macosx/arm64/debug/fbreader",
        }
    else
        bins = {
            "build/macosx/x86_64/release/fbreader",
            "build/macosx/x86_64/debug/fbreader",
        }
    end
    for _, f in ipairs(bins) do
        f = path.join(os.scriptdir(), f)
        if os.exists(f) then
            local t = path.join(out, "Contents/MacOS/FBReader")
            table.insert(zlibraryData, {f, t})
            break
        end
    end
    table.insert(zlibraryData, {
        path.join(os.scriptdir(), "fbreader/macosx/Info.plist"),
        path.join(out, "Contents/"),
    })
    table.insert(zlibraryData, {
        path.join(os.scriptdir(), "fbreader/macosx/Base.lproj/*"),
        path.join(out, "Contents/Resources/Base.lproj/").."/",
    })
    table.insert(zlibraryData, {
        path.join(os.scriptdir(), "fbreader/data/icons/application/FBReader.icns"),
        path.join(out, "Contents/Resources/"),
    })
    table.insert(zlibraryData, {
        path.join(os.scriptdir(), "fbreader/data/icons/application/FBReaderDocument.icns"),
        path.join(out, "Contents/Resources/"),
    })
end

for _, cc in ipairs(zlibraryData) do
    printf("cp %s %s\n", cc[1], cc[2])
    os.cp(cc[1], cc[2])
end

if is_host("windows") then
    local NSIS = os.getenv("NSIS") or ""
    NSIS = NSIS.."\\makensis.exe"
    local zipExe = path.join(os.scriptdir(), "3rd/minizip/minizip.exe")
    local hasZip = os.exists(zipExe)

    local USERPROFILE = os.getenv("USERPROFILE") or ""
    local scoopNsis = USERPROFILE.."/scoop/shims/makensis.exe"

    local makensis = {
        NSIS,
        scoopNsis,
    }

    local makensisPath = nil

    for _, f in ipairs(makensis) do
        if os.exists(f) then
            makensisPath = f
        end
    end
    if makensisPath == nil and find_program("makensis") ~= nil then
        makensisPath = "makensis"
    end

    if makensisPath ~= nil then
        local nsi = "fbreader-windows-x86_64-setup.nsi"
        if is32bit then
            nsi = "fbreader-windows-x86-setup.nsi"
        end
        os.cd(out)
        os.rm(nsi)
        local exec = "cmd /c mklink "..nsi.." ..\\..\\distributions\\nsi\\win32\\control.nsi"
        print(exec)
        os.exec(exec)
        if is32bit then
            exec = '"'..makensisPath..'" /DLANGDISPLAY '..nsi
        else
            exec = '"'..makensisPath..'" /DX64 /DLANGDISPLAY '..nsi
        end
        print(exec)
        os.exec(exec)
        os.rm(nsi)
        os.cd("-")
    end

    if hasZip then
        os.cd(out)
        if is32bit then
            exec = "../../"..zipExe.." -i -o -m fbreader-windows-x86.zip fbreader.exe share/"
        else
            exec = "../../"..zipExe.." -i -o -m fbreader-windows-x86_64.zip fbreader.exe share/"
        end
        print(exec)
        os.exec(exec)
        os.cd("-")
    end
elseif is_host("macosx") then
    local exec = "ibtool --errors --warnings --notices --output-format human-readable-text --compile "..out.."/Contents/Resources/Base.lproj/MainMenu.nib "..out.."/Contents/Resources/Base.lproj/MainMenu.xib"
    print(exec)
    os.exec(exec)
    io.writefile(path.join(out, "Contents/PkgInfo"), "APPL????\n")
    exec = "codesign --force --timestamp=none --deep --sign - "..out
    print(exec)
    os.exec(exec)
    os.cd(out.."/..")
    local zipOut = "fbreader-darwin-x86_64.zip"
    if isarm64 then
        zipOut = "fbreader-darwin-arm64.zip"
    end
    exec = "zip -r -o ../"..zipOut.." fbreader.app"
    print(exec)
    os.exec(exec)
    os.cd("-")
end
