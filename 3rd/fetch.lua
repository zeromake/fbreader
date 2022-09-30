import("net.http")
import("utils.archive")
import("lib.detect.find_program")

local downloads = {
    {
        "zlib",
        "https://zlib.net/zlib1212.zip",
    },
    {
        "png",
        "https://download.sourceforge.net/libpng/lpng1637.zip",
    },
    {
        "jpeg",
        "http://www.ijg.org/files/jpegsr9e.zip",
    },
    {
        "jpeg-turbo",
        "https://github.com/libjpeg-turbo/libjpeg-turbo/archive/refs/tags/2.1.4.zip",
        "jpeg-turbo-2.1.4.zip",
    },
    {
        "gif",
        "https://udomain.dl.sourceforge.net/project/giflib/giflib-5.2.1.tar.gz",
    },
    {
        "tiff",
        "http://download.osgeo.org/libtiff/tiff-4.4.0.zip",
    },
    {
        "bzip2",
        "https://nchc.dl.sourceforge.net/project/bzip2/bzip2-1.0.6.tar.gz",
    },
    {
        "unibreak",
        "https://github.com/adah1972/libunibreak/releases/download/libunibreak_5_0/libunibreak-5.0.tar.gz",
    },
    {
        "expat",
        "https://github.com/libexpat/libexpat/releases/download/R_2_4_8/expat-2.4.8.tar.gz",
    },
    {
        "fribidi",
        "https://github.com/fribidi/fribidi/releases/download/v1.0.12/fribidi-1.0.12.tar.xz"
    },
    {
        "sqlite3",
        "https://www.sqlite.org/2022/sqlite-amalgamation-3390200.zip",
    },
    {
        "rxcpp",
        "https://github.com/ReactiveX/RxCpp/archive/refs/tags/v4.1.1.zip",
        "rxcpp-4.1.1.zip",
    },
    {
        "stb",
        "https://github.com/nothings/stb/archive/refs/heads/master.zip",
        "stb.zip",
    },
    {
        "nanosvg",
        "https://github.com/memononen/nanosvg/archive/refs/heads/master.zip",
        "nanosvg.zip",
    },
    {
        "wolfssl",
        "https://github.com/wolfSSL/wolfssl/archive/refs/tags/v5.5.0-stable.tar.gz",
    },
    {
        "libcurl",
        "https://curl.se/download/curl-7.85.0.zip",
    },
    {
        "portable-file-dialogs",
        "https://github.com/samhocevar/portable-file-dialogs/archive/refs/heads/main.zip",
        "portable-file-dialogs.zip",
    },
}

local downloadDir = path.join(os.scriptdir(), "download")
local curlBin = find_program("curl")
local proxyUrl = nil --"socks5://127.0.0.1:10800"

local function curlDowload(url, f)
    local argv = {"-L", "-o", f}
    if proxyUrl ~= nil then
        table.insert(argv, "-x")
        table.insert(argv, proxyUrl)
    end
    table.insert(argv, url)
    os.execv("curl", argv)
end

for _, item in ipairs(downloads) do
    local f = path.join(downloadDir, path.filename(item[2]))
    if #item > 2 then
        f = path.join(downloadDir, item[3])
    end
    if not os.exists(f) then
        print("download "..f.." ing")
        if curlBin ~= nil then
            curlDowload(item[2], f)
        else
            http.download(item[2], f)
        end
        print("download "..f.." done")
    end
    local target = path.join(os.scriptdir(), item[1])
    if not os.exists(target) then
        if item[2]:endswith(".h") then
            os.mkdir(target)
            os.cp(f, target.."/")
        else
            archive.extract(f, target)
        end
    end
end
