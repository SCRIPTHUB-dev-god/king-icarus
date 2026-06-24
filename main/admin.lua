local correctKey = {"icarus_0003", "dev"}
local enteredKey = ""

local HttpService = game:GetService("HttpService")

local KeyManager = {}
local FOLDER = "Icarus_ks"
local FILE = FOLDER.. "/key_icarus.json"

if not isfolder(FOLDER) then
    makefolder(FOLDER)
end

function KeyManager.Save(key)
    local data = { key = key, savedAt = os.time() }
    local ok, err = pcall(function()
        writefile(FILE, HttpService:JSONEncode(data))
    end)
    return ok
end

function KeyManager.Load()
    if not isfile(FILE) then
        return nil
    end
    local ok, content = pcall(readfile, FILE)
    if not ok then
        return nil
    end
    local ok2, data = pcall(function()
        return HttpService:JSONDecode(content)
    end)
    if ok2 and data and data.key then
        return data.key
    end
    return nil
end

function KeyManager.Delete()
    if isfile(FILE) then
        pcall(delfile, FILE)
    end
end

local function isValidKey(key)
    if not key or key == "" then return false end
    for _, v in ipairs(correctKey) do
        if key == v then
            return true
        end
    end
    return false
end

local function runMainScript()
    local ok, err = pcall(function()
        local code = game:HttpGet("https://pastefy.app/jjAvBFri/raw")
        loadstring(code)()
    end)
end

local isSabtu = (os.date("*t").wday == 7)
local savedKey = KeyManager.Load()
local isAutoLogin = isValidKey(savedKey)

if isSabtu then
    local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/Obsidian/refs/heads/main/Library.lua"))()
    Library:Notify("Saturday skip key", 2)
    task.wait(0.25)
    runMainScript()
    Library:Unload()
elseif isAutoLogin then
    local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/Obsidian/refs/heads/main/Library.lua"))()
    Library:Notify("Auto login work", 2)
    runMainScript()
    Library:Unload()
else
    local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/Obsidian/refs/heads/main/Library.lua"))()
    local Window = Library:CreateWindow({
        Title = "icarus key",
        Footer = "key for : admin",
        Icon = "star",
        NotifySide = "Right",
    })

    local Tab1 = Window:AddTab("get key", "key")

    local getkey = Tab1:AddLeftGroupbox("Input Key", "key")
    local linkkey = Tab1:AddRightGroupbox("Info", "key")

    getkey:AddDivider()
    getkey:AddLabel("paste your key in the input", true)
    getkey:AddDivider()

    getkey:AddInput("MyTextbox", {
        Default = "",
        Numeric = false,
        Finished = false,
        ClearTextOnFocus = false,
        Text = "paste key here",
        Callback = function(Value)
            enteredKey = Value
        end,
    })

    getkey:AddButton({
        Text = "Check Key",
        Func = function()
            Library:Notify("Check key", 1)
            task.wait(0.5)
            if isValidKey(enteredKey) then
                KeyManager.Save(enteredKey)
                Library:Notify("key valid", 2)
                task.wait(0.5)
                runMainScript()
                Library:Unload()
            else
                KeyManager.Delete()
                Library:Notify("Key invalid", 3)
            end
        end
    })
    getkey:AddDivider()

    linkkey:AddDivider()
    linkkey:AddLabel("get key", true)
    linkkey:AddDivider()

    linkkey:AddLabel("linkvertise (1 CP)", true)
    linkkey:AddButton({
        Text = "Get Key",
        Func = function()
            setclipboard("https://link-hub.net/4413475/QFUqQTpRrcoP")
            Library:Notify("Link has copy", 2)
        end
    })

    linkkey:AddLabel("rekonise (1 CP)", true)
    linkkey:AddButton({
        Text = "Get Key",
        Func = function()
            setclipboard("https://rekonise.com/get-key-icarus-admin-qbbdk")
            Library:Notify("Link has copy", 2)
        end
    })
    linkkey:AddDivider()
end

loadstring(game:HttpGet("https://raw.githubusercontent.com/SCRIPTHUB-dev-god/anti-system/refs/heads/main/anti-staff"))()
