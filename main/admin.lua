local correctKey = "icarus_0001", "dev"
local enteredKey = ""

local HttpService = game:GetService("HttpService")

local KeyManager = {}
local FOLDER = "KeySystem"
local FILE = FOLDER.. "/saved_key.json"

if not isfolder(FOLDER) then
    makefolder(FOLDER)
end

function KeyManager.Save(key)
    local data = {
        key = key,
        savedAt = os.time()
    }
    local ok, err = pcall(function()
        writefile(FILE, HttpService:JSONEncode(data))
    end)
    if ok then
        return true
    else
        return false
    end
end

function KeyManager.Load()
    if not isfile(FILE) then return nil end
    local ok, content = pcall(readfile, FILE)
    if not ok then return nil end
    local ok2, data = pcall(function()
        return HttpService:JSONDecode(content)
    end)
    if ok2 and data and data.key then
        return data.key, data.savedAt
    end
    return nil
end

function KeyManager.Delete()
    if isfile(FILE) then
        delfile(FILE)
    end
end

function KeyManager.Has()
    return isfile(FILE)
end

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/Obsidian/refs/heads/main/Library.lua"))()

local Window = Library:CreateWindow({
    Title = "icarus key",
    Footer = "version: example",
    Icon = "star",
    NotifySide = "Right",
})

local Tab1 = Window:AddTab("get key", "key")

local getkey = Tab1:AddLeftGroupbox("Input Key", "key")
local linkkey = Tab1:AddRightGroupbox("Info", "key")

getkey:AddDivider()
getkey:AddLabel("paste your key in the input", true)
getkey:AddDivider()

local savedKey = KeyManager.Load()
if savedKey == correctKey then
    Library:Notify("Auto login work", 1)
    task.wait(2)
    loadstring(game:HttpGet("https://pastefy.app/vaD2C0aY/rawa"))()
    return
end

getkey:AddInput("MyTextbox", {
    Default = "",
    Numeric = true,
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
        if enteredKey == correctKey then
            Library:Notify("Check key", 1)
            task.wait(1)
            KeyManager.Save(enteredKey)
            Library:Notify("key valid", 2)
            task.wait(1)
            loadstring(game:HttpGet("https://pastefy.app/vaD2C0aY/rawa"))()
        else
            Library:Notify("Check key", 1)
            task.wait(1)
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
