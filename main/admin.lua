local HttpService = game:GetService("HttpService")

local FOLDER = "Icarus_ks"
local FILE = FOLDER.. "/key_icarus.json"
if not isfolder(FOLDER) then makefolder(FOLDER) end

local KeyManager = {}
function KeyManager.LoadData()
    if not isfile(FILE) then return {} end
    local ok, content = pcall(readfile, FILE)
    if not ok then return {} end
    local ok2, data = pcall(function() return HttpService:JSONDecode(content) end)
    return ok2 and type(data)=="table" and data or {}
end
function KeyManager.SaveData(data)
    pcall(function() writefile(FILE, HttpService:JSONEncode(data)) end)
end
function KeyManager.Save(key)
    local data = KeyManager.LoadData()
    data.key = key
    data.savedAt = os.time()
    KeyManager.SaveData(data)
end
function KeyManager.Load()
    local data = KeyManager.LoadData()
    return data.key
end
function KeyManager.Delete()
    if isfile(FILE) then pcall(delfile, FILE) end
end

-- === KEY PER DEVICE DENGAN WRAP ===
local function getDevice()
    local d = KeyManager.LoadData()
    d.icarus_counter = d.icarus_counter or 1
    d.premium_counter = d.premium_counter or 1
    d.icarus_last = d.icarus_last or os.time()
    d.premium_last = d.premium_last or os.time()
    return d
end

local function getCurrentIcarusKey()
    local d = getDevice()
    local now = os.time()
    if now - d.icarus_last >= 86400 then
        local add = math.floor((now - d.icarus_last) / 86400)
        d.icarus_counter = ((d.icarus_counter - 1 + add) % 99999) + 1
        d.icarus_last = d.icarus_last + (add * 86400)
        KeyManager.SaveData(d)
    end
    return string.format("icarus_%05d", d.icarus_counter)
end

local function getCurrentPremiumKey()
    local d = getDevice()
    local nowT = os.date("*t")
    local lastT = os.date("*t", d.premium_last)
    local monthsDiff = (nowT.year - lastT.year) * 12 + (nowT.month - lastT.month)
    if monthsDiff > 0 then
        d.premium_counter = ((d.premium_counter - 1 + monthsDiff) % 99999) + 1
        d.premium_last = os.time()
        KeyManager.SaveData(d)
    end
    return string.format("premium_%05d", d.premium_counter)
end

local function isValidKey(key)
    if not key or key == "" then return false end
    if key == "dev" then return true end
    if key == getCurrentIcarusKey() then return true end
    if key == getCurrentPremiumKey() then return true end
    return false
end

local function runMainScript()
    pcall(function()
        local code = game:HttpGet("https://pastefy.app/jjAvBFri/raw")
        loadstring(code)()
    end)
end

local isSabtu = (os.date("*t").wday == 7)
local savedKey = KeyManager.Load()
local isAutoLogin = isValidKey(savedKey)

local enteredKey = ""
local hasClickedGetKey = false

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
            if enteredKey:match("^icarus_") and not hasClickedGetKey then
                Library:Notify("Klik Get Key dulu!", 3)
                return
            end
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
            hasClickedGetKey = true
            Library:Notify("Link has copy", 2)
        end
    })

    linkkey:AddLabel("rekonise (1 CP)", true)
    linkkey:AddButton({
        Text = "Get Key",
        Func = function()
            setclipboard("https://rekonise.com/get-key-icarus-admin-qbbdk")
            hasClickedGetKey = true
            Library:Notify("Link has copy", 2)
        end
    })
    linkkey:AddDivider()
end

loadstring(game:HttpGet("https://raw.githubusercontent.com/SCRIPTHUB-dev-god/anti-system/refs/heads/main/anti-staff"))()
