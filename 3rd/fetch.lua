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
        "https://download.sourceforge.net/project/libjpeg/libjpeg/6b/jpegsr6.zip",
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
        "openssl",
        "https://www.openssl.org/source/openssl-3.0.5.tar.gz",
    },
    {
        "ssh2",
        "https://www.libssh2.org/download/libssh2-1.10.0.tar.gz",
    },
    {
        "curl",
        "https://curl.se/download/curl-7.84.0.zip",
    }
}

local downloadDir = path.join(os.scriptdir(), "dowload")
local curlBin = find_program("curl")
local proxyUrl = "socks5://127.0.0.1:10800"

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
    if not os.exists(item[1]) then
        archive.extract(f, path.join(os.scriptdir(), item[1]))
    end
end
