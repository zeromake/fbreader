local subs = {"x64", "arm64"}

local outApp = "fbreader.app"
local binary = "FBReader"
local out = "dist"
local outSub = ""
local _sourceSub = nil
local exec = "lipo -create"
local count = 0

for _, sub in ipairs(subs) do
    local sourceSub = path.join(out, sub)
    if os.exists(sourceSub) then
        if outSub ~= "" then
            outSub = outSub.."-"
        end
        if sub == "x64" then
            outSub = outSub.."x86_64"
        else
            outSub = outSub..sub
        end
        if _sourceSub == nil then
            _sourceSub = sourceSub
        end
        exec = exec.." "..path.join(out, sub, outApp, "Contents/MacOS", binary)
        count = count + 1
    end
end

if count < 2 then
    return
end

local s = _sourceSub.."/*"
local t = out.."/"..outSub.."/"
printf("cp %s %s\n", s, t)
os.cp(s, t)

local targetPath = path.join(out, outSub, outApp)
exec = exec.." -output "..path.join(targetPath, "Contents/MacOS", binary)
print(exec)
os.exec(exec)

os.rm(path.join(targetPath, "Contents/_CodeSignature"))

exec = "codesign --force --timestamp=none --deep --sign - "..targetPath
print(exec)
os.exec(exec)


os.cd(path.join(out, outSub))
exec = "zip -r -o ../".."fbreader-darwin-"..outSub..".zip fbreader.app"
print(exec)
os.exec(exec)
os.cd("-")
