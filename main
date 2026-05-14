local HttpService = game:GetService("HttpService")
local ConfigFile = "king_icarus.json"

local function LoadConfig()
    if isfile and isfile(ConfigFile) then
        local success, content = pcall(readfile, ConfigFile)
        if success then
            return HttpService:JSONDecode(content)
        end
    end
    return {}
end

local function SaveConfig(name, state)
    local currentConfig = LoadConfig()
    currentConfig[name] = state
    writefile(ConfigFile, HttpService:JSONEncode(currentConfig))
end

local SavedData = LoadConfig()

local success, Library = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/Obsidian/refs/heads/main/Library.lua"))()
end)

if not success then return end

local Loading = Library:CreateLoading({
    Title = "Icarus game hub",
    TotalSteps = 4,
})
 
-- Loading...
Loading:SetMessage("Initializing...")
Loading:SetDescription("Waiting for game to load...")
task.wait(1)
 
Loading:SetCurrentStep(1)
Loading:SetDescription("Loading configuration...")
task.wait(1)
 
-- Show sidebar with information
Loading:SetCurrentStep(2)
Loading:ShowSidebarPage(true)
Loading.Sidebar:AddLabel("wellcome to Icarus game hub")
Loading.Sidebar:AddLabel("credit by")
Loading.Sidebar:AddLabel("• mspaint")
Loading.Sidebar:AddLabel("• Icarus community")
Loading.Sidebar:AddLabel("• others")
Loading.Sidebar:AddLabel("-- version Icarus game hub --")
Loading.Sidebar:AddLabel("version : 1.0.5")
task.wait(1)
 
Loading:SetCurrentStep(3)
Loading:SetDescription("Ready to start!")
task.wait(1)
 
Loading:SetCurrentStep(4)
Loading:Continue()

local Window = Library:CreateWindow({
    Title = "ICARUS",
    Footer = "universal script/version 1.1.0",
    Center = true,
    AutoShow = false,
    TabPadding = 8,
    MenuFadeTime = 0.2,
    CornerRadius = 4,
    Icon = "star"
})

Window:AddDialog("EmptyDialogueIdx", {
    Title = "wellcome to ICARUS games hub",
    Description = "thanks you for Execute this script",
    AutoDismiss = true,
    OutsideClickDismiss = true,
    FooterButtons = {
        Confirm = {
            Title = "Okay",
            Variant = "Primary",
            Callback = function() end
        }
    }
})

local Tab = Window:AddTab("support", "info")

local infoGroupBox = Tab:AddLeftGroupbox("info", "info")

local Label = infoGroupBox:AddLabel("support my discord")

infoGroupBox:AddButton("Copy Discord", function()
    local link = "https://discord.gg/mjhqEMRr"
    
    if setclipboard then
        setclipboard(link)
    elseif toclipboard then
        toclipboard(link)
    end
end)

local Tab = Window:AddTab("Main", "joystick")
local LeftTabBox = Tab:AddLeftTabbox()
local SubTab1 = LeftTabBox:AddTab("", "star")
local SubTab2 = LeftTabBox:AddTab("", "sprout")
local SubTab3 = LeftTabBox:AddTab("", "apple")
local SubTab4 = LeftTabBox:AddTab("", "sailboat")
local SubTab5 = LeftTabBox:AddTab("", "sport-shoe")
local SubTab6 = LeftTabBox:AddTab("", "sailboat")
local SubTab7 = LeftTabBox:AddTab("", "bird")

local RightTabBox = Tab:AddRightTabbox()
local SubTab8 = RightTabBox:AddTab("", "shield")
local SubTab9 = RightTabBox:AddTab("", "swords")

local list = {
    {name = "speed hub x", url = "https://raw.githubusercontent.com/AhmadV99/Speed-Hub-X/main/Speed%20Hub%20X.lua", auto_execute = false},
    {name = "chiyo hub", url = "https://raw.githubusercontent.com/kaisenlmao/loader/refs/heads/main/chiyo.lua", auto_execute = false},
    {name = "solix hub", url = "https://raw.githubusercontent.com/bao8jl/solixhub/main/loader", auto_execute = false},
    {name = "lunor hub", url = "https://lunor.dev/loader", auto_execute = false},
    {name = "lumin hub", url = "http://luminon.top/loader.lua", auto_execute = false},
}

SubTab1:AddLabel("• bests hub")

SubTab1:AddDivider()

for i, item in ipairs(list) do
    local toggleName = "AutoExec_" .. item.name
    local isAutoExec = SavedData[toggleName] or false

    SubTab1:AddLabel(item.name)
    
    SubTab1:AddButton({
        Text = "Load Script",
        Func = function()
            loadstring(game:HttpGet(item.url))()
        end
    })

    local MyToggle = SubTab1:AddToggle(toggleName, {
        Text = "Auto Execute",
        Default = isAutoExec
    })

    MyToggle:OnChanged(function()
        SaveConfig(toggleName, MyToggle.Value)
    end)

    if isAutoExec then
        task.spawn(function()
            pcall(function()
                loadstring(game:HttpGet(item.url))()
            end)
        end)
    end

    SubTab1:AddDivider()
end

local list1 = {
    {name = "speed hub x ", url = "https://raw.githubusercontent.com/AhmadV99/Speed-Hub-X/main/Speed%20Hub%20X.lua", auto_execute = false},
    {name = "wish hub x", url = "https://raw.githubusercontent.com/dy1zn4t/WisHubX/refs/heads/main/loader", auto_execute = false},
    {name = "lumin hub", url = "http://luminon.top/loader.lua", auto_execute = false},
    {name = "lunor hub ", url = "https://lunor.dev/loader", auto_execute = false},
    {name = "thunderz hub", url = "https://raw.githubusercontent.com/ThundarZ/Welcome/refs/heads/main/Main/GaG/Main.lua", auto_execute = false},
}

SubTab2:AddLabel("• grow a garden hub")

SubTab2:AddDivider()

for i, item in ipairs(list1) do
    local toggleName = "AutoExec_" .. item.name
    local isAutoExec = SavedData[toggleName] or false

    SubTab2:AddLabel(item.name)
    
    SubTab2:AddButton({
        Text = "Load Script",
        Func = function()
            loadstring(game:HttpGet(item.url))()
        end
    })

    local MyToggle = SubTab2:AddToggle(toggleName, {
        Text = "Auto Execute",
        Default = isAutoExec
    })

    MyToggle:OnChanged(function()
        SaveConfig(toggleName, MyToggle.Value)
    end)

    if isAutoExec then
        task.spawn(function()
            pcall(function()
                loadstring(game:HttpGet(item.url))()
            end)
        end)
    end

    SubTab2:AddDivider()
end

local list2 = {
    {
        name = "blue x hub", 
        url = [[_G.SaveConfig = true; loadstring(game:HttpGet("https://raw.githubusercontent.com/Dev-BlueX/BlueX-Hub/refs/heads/main/Main.lua"))()]], 
        auto_execute = false
    },
    {
        name = "kaitun Blue X Hub", 
        url = [[
            getgenv().Config = {
                ["Setting"] = {
                    ["UiCheckItem"] = false,
                    ["White Screen"] = false
                },       
                ["Quest"] = {
                    ["Race V2-V3"] = true,
                    ["Haki Rainbow"] = true
                },
                ["Webhook"] = {
                    ["Enable"] = false,
                    ["UrlWebhook"] = ""
                }
            }
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Dev-BlueX/BlueX-Hub/refs/heads/main/KaitunBloxFruits.lua"))()
        ]], 
        auto_execute = false
    },
    {name = "gravity hub", url = "https://raw.githubusercontent.com/Dev-GravityHub/BloxFruit/refs/heads/main/Main.lua", auto_execute = false},
    {name = "moonlight hub", url = "https://raw.githubusercontent.com/Dev-Moonlight/Moonlight/refs/heads/main/Main", auto_execute = false},
}

SubTab3:AddLabel("• Blox Fruit hub")

SubTab3:AddDivider()

for i, item in ipairs(list2) do
    local toggleName = "AutoExec_" .. item.name
    local isAutoExec = SavedData[toggleName] or false

    SubTab3:AddLabel(item.name)
    
    SubTab3:AddButton({
        Text = "Load Script",
        Func = function()
            loadstring(game:HttpGet(item.url))()
        end
    })

    local MyToggle = SubTab3:AddToggle(toggleName, {
        Text = "Auto Execute",
        Default = isAutoExec
    })

    MyToggle:OnChanged(function()
        SaveConfig(toggleName, MyToggle.Value)
    end)

    if isAutoExec then
        task.spawn(function()
            pcall(function()
                loadstring(game:HttpGet(item.url))()
            end)
        end)
    end

    SubTab3:AddDivider()
end

local list3 = {
    {name = "luau.pro", url = "https://raw.githubusercontent.com/TheRealAsu/Luau.pro-utils/main/Loader", auto_execute = false},
    {name = "kaitun babft", url = "https://raw.githubusercontent.com/SCRIPTHUB-dev-god/kaitun/refs/heads/main/game", auto_execute = false},
}

SubTab4:AddLabel("• build a boat hub")

SubTab4:AddDivider()

for i, item in ipairs(list3) do
    local toggleName = "AutoExec_" .. item.name
    local isAutoExec = SavedData[toggleName] or false

    SubTab4:AddLabel(item.name)
    
    SubTab4:AddButton({
        Text = "Load Script",
        Func = function()
            loadstring(game:HttpGet(item.url))()
        end
    })

    local MyToggle = SubTab4:AddToggle(toggleName, {
        Text = "Auto Execute",
        Default = isAutoExec
    })

    MyToggle:OnChanged(function()
        SaveConfig(toggleName, MyToggle.Value)
    end)

    if isAutoExec then
        task.spawn(function()
            pcall(function()
                loadstring(game:HttpGet(item.url))()
            end)
        end)
    end

    SubTab4:AddDivider()
end

local list4 = {
    {name = "Yin Yang Hub", url = "https://raw.githubusercontent.com/yesimsoul/Yin-Yang-Hub/refs/heads/main/evade", auto_execute = false},
    {name = "event evade", url = "https://raw.githubusercontent.com/gumanba/Scripts/main/EvadeEvent", auto_execute = false},
    {name = "kaitun evade", url = "https://raw.githubusercontent.com/SCRIPTHUB-dev-god/kaitun/refs/heads/main/game", auto_execute = false},
}

SubTab5:AddLabel("• evade hub")

SubTab5:AddDivider()

for i, item in ipairs(list4) do
    local toggleName = "AutoExec_" .. item.name
    local isAutoExec = SavedData[toggleName] or false

    SubTab5:AddLabel(item.name)
    
    SubTab5:AddButton({
        Text = "Load Script",
        Func = function()
            loadstring(game:HttpGet(item.url))()
        end
    })

    local MyToggle = SubTab5:AddToggle(toggleName, {
        Text = "Auto Execute",
        Default = isAutoExec
    })

    MyToggle:OnChanged(function()
        SaveConfig(toggleName, MyToggle.Value)
    end)

    if isAutoExec then
        task.spawn(function()
            pcall(function()
                loadstring(game:HttpGet(item.url))()
            end)
        end)
    end

    SubTab5:AddDivider()
end

local list5 = {
    {name = "solix hub", url = "https://raw.githubusercontent.com/bao8jl/solixhub/main/loader", auto_execute = false},
    {name = "chiyo hub", url = "https://raw.githubusercontent.com/kaisenlmao/loader/refs/heads/main/chiyo.lua", auto_execute = false},
    {name = "lumin hub", url = "http://luminon.top/loader.lua", auto_execute = false},
}

SubTab6:AddLabel("• sailor piece hub")

SubTab6:AddDivider()

for i, item in ipairs(list5) do
    local toggleName = "AutoExec_" .. item.name
    local isAutoExec = SavedData[toggleName] or false

    SubTab6:AddLabel(item.name)
    
    SubTab6:AddButton({
        Text = "Load Script",
        Func = function()
            loadstring(game:HttpGet(item.url))()
        end
    })

    local MyToggle = SubTab6:AddToggle(toggleName, {
        Text = "Auto Execute",
        Default = isAutoExec
    })

    MyToggle:OnChanged(function()
        SaveConfig(toggleName, MyToggle.Value)
    end)

    if isAutoExec then
        task.spawn(function()
            pcall(function()
                loadstring(game:HttpGet(item.url))()
            end)
        end)
    end

    SubTab6:AddDivider()
end

local list6 = {
    {name = "atlas hub", url = "https://rawscripts.net/raw/Bee-Swarm-Simulator-Atlas-49277", auto_execute = false},
    {name = "ronix hub", url = "https://api.luarmor.net/files/v3/loaders/fda9babd071d6b536a745774b6bc681c.lua", auto_execute = false},
}

SubTab7:AddLabel("• Bee Swarm Simulator hub")

SubTab7:AddDivider()

for i, item in ipairs(list6) do
    local toggleName = "AutoExec_" .. item.name
    local isAutoExec = SavedData[toggleName] or false

    SubTab7:AddLabel(item.name)
    
    SubTab7:AddButton({
        Text = "Load Script",
        Func = function()
            loadstring(game:HttpGet(item.url))()
        end
    })

    local MyToggle = SubTab7:AddToggle(toggleName, {
        Text = "Auto Execute",
        Default = isAutoExec
    })

    MyToggle:OnChanged(function()
        SaveConfig(toggleName, MyToggle.Value)
    end)

    if isAutoExec then
        task.spawn(function()
            pcall(function()
                loadstring(game:HttpGet(item.url))()
            end)
        end)
    end

    SubTab7:AddDivider()
end

local list7 = {
    {name = "infinite yield", url = "https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source", auto_execute = false},
    {name = "Nameless Admin", url = "https://raw.githubusercontent.com/ltseverydayyou/Nameless-Admin/main/Source.lua", auto_execute = false},
    {name = "vape v4", url = "https://raw.githubusercontent.com/7GrandDadPGN/VapeV4ForRoblox/main/NewMainScript.lua", auto_execute = false},
    {name = "dex explorer", url = "https://rawscripts.net/raw/Universal-Script-Dex-Explorer-DPP-73687", auto_execute = false},
    {name = "AK ADMIN", url = "https://absent.wtf/AKADMIN.lua", auto_execute = false},
}

SubTab8:AddLabel("• admin Script")

SubTab8:AddDivider()

for i, item in ipairs(list7) do
    local toggleName = "AutoExec_" .. item.name
    local isAutoExec = SavedData[toggleName] or false

    SubTab8:AddLabel(item.name)
    
    SubTab8:AddButton({
        Text = "Load Script",
        Func = function()
            loadstring(game:HttpGet(item.url))()
        end
    })

    local MyToggle = SubTab8:AddToggle(toggleName, {
        Text = "Auto Execute",
        Default = isAutoExec
    })

    MyToggle:OnChanged(function()
        SaveConfig(toggleName, MyToggle.Value)
    end)

    if isAutoExec then
        task.spawn(function()
            pcall(function()
                loadstring(game:HttpGet(item.url))()
            end)
        end)
    end

    SubTab8:AddDivider()
end

local list8 = {
    {name = "aimbot pro", url = "https://raw.githubusercontent.com/SCRIPTHUB-dev-god/aimbot/refs/heads/main/main", auto_execute = false},
    {name = "aimbot mobile", url = "https://raw.githubusercontent.com/DanielHubll/DanielHubll/refs/heads/main/Aimbot%20Mobile", auto_execute = false},
}

SubTab9:AddLabel("• aimbot Script")

SubTab9:AddDivider()

for i, item in ipairs(list8) do
    local toggleName = "AutoExec_" .. item.name
    local isAutoExec = SavedData[toggleName] or false

    SubTab9:AddLabel(item.name)
    
    SubTab9:AddButton({
        Text = "Load Script",
        Func = function()
            loadstring(game:HttpGet(item.url))()
        end
    })

    local MyToggle = SubTab9:AddToggle(toggleName, {
        Text = "Auto Execute",
        Default = isAutoExec
    })

    MyToggle:OnChanged(function()
        SaveConfig(toggleName, MyToggle.Value)
    end)

    if isAutoExec then
        task.spawn(function()
            pcall(function()
                loadstring(game:HttpGet(item.url))()
            end)
        end)
    end

    SubTab9:AddDivider()
end

local Tab = Window:AddTab("Setting", "settings")

local setGroupBox = Tab:AddLeftGroupbox("Setting", "settings")

setGroupBox:AddLabel("restart ui")

setGroupBox:AddButton({
    Text = "restart",
    Func = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/SCRIPTHUB-dev-god/king-icarus/refs/heads/main/main",true))()
        Library:Unload()
    end
})

setGroupBox:AddDivider()

setGroupBox:AddLabel("server")

local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

local function doServerHop()
    local placeId = game.PlaceId
    local jobId = game.JobId
    local servers = {}
    
    local success, result = pcall(function()
        local url = "https://games.roblox.com/v1/games/"..placeId.."/servers/Public?sortOrder=Asc&limit=100"
        return HttpService:JSONDecode(game:HttpGet(url))
    end)
    
    if success and result and result.data then
        for _, s in ipairs(result.data) do
            if type(s) == "table" and s.playing < s.maxPlayers and s.id ~= jobId then
                table.insert(servers, s.id)
            end
        end
    end
    
    if #servers > 0 then
        local serverId = servers[math.random(1, #servers)]
        TeleportService:TeleportToPlaceInstance(placeId, serverId, player)
    else
        warn("Server Hop: tidak ada server lain")
    end
end

local function doRejoin()
    TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, player)
end

-- dua tombol terpisah, bukan bertumpuk
setGroupBox:AddButton({
    Text = "Server Hop",
    Func = doServerHop
})

setGroupBox:AddButton({
    Text = "Rejoin",
    Func = doRejoin
})

local seGroupBox = Tab:AddRightGroupbox("credits", "clipboard")

seGroupBox:AddLabel("credits by")

seGroupBox:AddLabel("• ICARUS hub")

seGroupBox:AddLabel("• mspaint")

seGroupBox:AddLabel("• others")

seGroupBox:AddDivider()

seGroupBox:AddLabel("logs update")

seGroupBox:AddLabel("• upgrade group box")

seGroupBox:AddLabel("• new code")
