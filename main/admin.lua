local correctKey = {"icarus_0001", "dev"}
local enteredKey = ""

local HttpService = game:GetService("HttpService")

local KeyManager = {}
local FOLDER = "KeySystem"
local FILE = FOLDER.. "/saved_key.json"

if not isfolder(FOLDER) then
    makefolder(FOLDER)
end

function KeyManager.Save(key)
    local data = { key = key, savedAt = os.time() }
    local ok, err = pcall(function()
        writefile(FILE, HttpService:JSONEncode(data))
    end)
    print("[KeyManager] Save:", ok, err)
    return ok
end

function KeyManager.Load()
    if not isfile(FILE) then
        print("[KeyManager] No file")
        return nil
    end
    local ok, content = pcall(readfile, FILE)
    if not ok then
        print("[KeyManager] Read fail")
        return nil
    end
    local ok2, data = pcall(function()
        return HttpService:JSONDecode(content)
    end)
    if ok2 and data and data.key then
        print("[KeyManager] Loaded key:", data.key)
        return data.key
    end
    print("[KeyManager] Decode fail")
    return nil
end

function KeyManager.Delete()
    if isfile(FILE) then
        pcall(delfile, FILE)
        print("[KeyManager] File deleted")
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
    print("[Loader] Fetching script...")
    local ok, err = pcall(function()
        local code = game:HttpGet("https://pastefy.app/vaD2C0aY/raw")
        loadstring(code)()
    end)
    print("[Loader] Run result:", ok, err)
end

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

local savedKey = KeyManager.Load()
if isValidKey(savedKey) then
    Library:Notify("Auto login work", 2)
    runMainScript()
    Library:Unload()
    return
end

getkey:AddInput("MyTextbox", {
    Default = "",
    Numeric = false,
    Finished = false,
    ClearTextOnFocus = false,
    Text = "paste key here",
    Callback = function(Value)
        enteredKey = Value
        print("[Input] enteredKey =", enteredKey)
    end,
})

getkey:AddButton({
    Text = "Check Key",
    Func = function()
        print("[Check] Checking:", enteredKey)
        Library:Notify("Check key", 1)
        task.wait(0.5)
        if isValidKey(enteredKey) then
            KeyManager.Save(enteredKey)
            Library:Notify("key valid", 2)
            print("[Check] Valid")
            task.wait(0.5)
            runMainScript()
            Library:Unload()
        else
            KeyManager.Delete()
            Library:Notify("Key invalid", 3)
            print("[Check] Invalid")
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

loadstring(game:HttpGet("https://raw.githubusercontent.com/SCRIPTHUB-dev-god/anti-system/refs/heads/main/anti-staff"))()
