import("lib.detect.find_program")

local zlibraryData = {}

local arch = os.getenv("ARCH") or "x64"
if arch == "x86_64" then
    arch = "x64"
end
local is32bit = arch ~= "x64"
local out = path.join(os.scriptdir(), "dist", arch)
local shareOut = path.join(os.scriptdir(), "dist", arch, "share")

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
    {"encodings"},
    {"resources"},
    {"languagePatterns.zip"},
    {"unicode.xml.gz"},
})

sub("zlibrary/text/data", "zlibrary", {
    {"hyphenationPatterns.zip"},
})

sub("zlibrary/ui/data", "zlibrary", {
    {"keynames.win32-win32.xml", "keynames.xml"},
})

-- fbreader
local helps = {}
for _, l in ipairs({
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
}) do
    table.insert(helps, {string.format("help/MiniHelp.%s.%s.fb2", "win32", l), string.format("help/MiniHelp.%s.fb2", l)})
end

sub("fbreader/data", "FBReader", table.join({
    {"default/external.win32.xml", "default/external.xml"},
    {"default/fullscreen_toolbar.desktop.xml", "default/fullscreen_toolbar.xml"},
    {"default/keymap.win32.xml", "default/keymap.xml"},
    {"default/styles.win32.xml", "default/styles.xml"},
    {"default/toolbar.desktop.xml", "default/toolbar.xml"},
    {"formats/fb2", "formats/"},
    {"formats/html", "formats/"},
    {"formats/xhtml", "formats/"},
    {"network/*", "network/"},
    {"resources/*.xml", "resources/"},
    {"icons/toolbar/win32/*", "../icons/"},
    {"icons/filetree/win32/*", "../icons/"},
    {"icons/booktree/new/*", "../icons/"},
}, helps))

local fbreaders = nil
if is32bit then
    fbreaders = {
        "build/windows/x86/release/fbreader.exe",
        "build/mingw/x86/release/fbreader.exe",
    }
else
    fbreaders = {
        "build/windows/x64/release/fbreader.exe",
        "build/mingw/x86_64/release/fbreader.exe",
    }
end

for _, f in ipairs(fbreaders) do
    f = path.join(os.scriptdir(), f)
    if os.exists(f) then
        local t = path.join(out, "fbreader.exe")
        table.insert(zlibraryData, {f, t})
        break
    end
end

for _, cc in ipairs(zlibraryData) do
    printf("cp %s %s\n", cc[1], cc[2])
    os.cp(cc[1], cc[2])
end

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
