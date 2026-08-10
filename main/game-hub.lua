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

local Window = Library:CreateWindow({
    Title = "ICARUS",
    Footer = "universal script/version 1.1.5",
    Center = true,
    AutoShow = false,
    TabPadding = 8,
    MenuFadeTime = 0.2,
    CornerRadius = 4,
    Icon = "snowflake"
})

-- Draggable Label
local DraggableLabel = Library:AddDraggableLabel("Obsidian")
DraggableLabel:SetVisible(true)

-- FPS Counter
local FrameTimer = tick()
local FrameCounter = 0
local FPS = 60

game:GetService("RunService").RenderStepped:Connect(function()
    FrameCounter += 1

    if (tick() - FrameTimer) >= 1 then
        FPS = FrameCounter
        FrameTimer = tick()
        FrameCounter = 0
    end

    -- Hours : Minutes
    local CurrentTime = os.date("%H:%M")

    DraggableLabel:SetText(
        ("ICARUS | FPS: %s | %s"):format(
            math.floor(FPS),
            CurrentTime
        )
    )
end)

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

local Tab = Window:AddTab({
    Name = "info",
    Description = "discord and info game",
    Icon = "info"
})

local infoGroupBox = Tab:AddLeftGroupbox("info", "info")

local Label = infoGroupBox:AddLabel("support my discord")

infoGroupBox:AddButton({
    Text = "Copy Discord",
    Func = function()
        local link = "https://discord.gg/dbE59H6grJ"

        if setclipboard then
            setclipboard(link)
        elseif toclipboard then
            toclipboard(link)
        end
    end
})

local gameid = Tab:AddRightGroupbox("game id", "info")

--// Services
local UserInputService = game:GetService("UserInputService")

--// IDs
local PlaceId = game.PlaceId

--// Platform Detect
local Platform = UserInputService.TouchEnabled and "Mobile" or "PC"

--// Labels
gameid:AddLabel("Place ID : " .. tostring(PlaceId))
gameid:AddLabel("Platform : " .. Platform)

--// Copy Function
local function CopyToClipboard(text)
    if setclipboard then
        setclipboard(text)
    end
end

--// Buttons
gameid:AddButton({
    Text = "Copy Place ID",
    Func = function()
        CopyToClipboard(PlaceId)
    end
})

local Tab1 = Window:AddTab({
    Name = "Main",
    Description = "search script",
    Icon = "joystick"
})
local LeftTabBox = Tab1:AddLeftTabbox("Left Tabbox")
local SubTab1 = LeftTabBox:AddTab("", "star")
local SubTab2 = LeftTabBox:AddTab("", "sprout")
local SubTab3 = LeftTabBox:AddTab("", "apple")
local SubTab4 = LeftTabBox:AddTab("", "sailboat")
local SubTab5 = LeftTabBox:AddTab("", "sport-shoe")
local SubTab7 = LeftTabBox:AddTab("", "bird")
local SubTab10 = LeftTabBox:AddTab("", "sprout")
local SubTab11 = LeftTabBox:AddTab("", "moon")

local RightTabBox = Tab1:AddRightTabbox("Right Tabbox")
local SubTab8 = RightTabBox:AddTab("", "shield")
local SubTab9 = RightTabBox:AddTab("", "swords")

local list = {
    {name = "speed hub x", url = "https://raw.githubusercontent.com/AhmadV99/Speed-Hub-X/main/Speed%20Hub%20X.lua", auto_execute = false},
    {name = "chiyo hub", url = "https://raw.githubusercontent.com/kaisenlmao/loader/refs/heads/main/chiyo.lua", auto_execute = false},
    {name = "solix hub", url = "https://raw.githubusercontent.com/bao8jl/solixhub/main/loader", auto_execute = false},
    {name = "lunor hub", url = "https://lunor.dev/loader", auto_execute = false},
    {name = "lumin hub", url = "http://luminon.top/loader.lua", auto_execute = false},
}

local list1 = {
    {name = "speed hub x ", url = "https://raw.githubusercontent.com/AhmadV99/Speed-Hub-X/main/Speed%20Hub%20X.lua", auto_execute = false},
    {name = "wish hub x", url = "https://raw.githubusercontent.com/dy1zn4t/WisHubX/refs/heads/main/loader", auto_execute = false},
    {name = "lumin hub", url = "http://luminon.top/loader.lua", auto_execute = false},
    {name = "lunor hub ", url = "https://lunor.dev/loader", auto_execute = false},
    {name = "thunderz hub", url = "https://raw.githubusercontent.com/ThundarZ/Welcome/refs/heads/main/Main/GaG/Main.lua", auto_execute = false},
}

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
    {name = "quantum hub", url = "https://raw.githubusercontent.com/Trustmenotcondom/QTONYX/refs/heads/main/QuantumOnyx.lua", auto_execute = false},
    {name = "Meo Lazy hub", url = "https://raw.githubusercontent.com/MeoLazy/Script/refs/heads/main/V1.lua", auto_execute = false},
    {name = "turbo lite hub", url = "https://raw.githubusercontent.com/TurboLite/Script/refs/heads/main/MainV2.lua", auto_execute = false},
}

local list4 = {
    {name = "Yin Yang Hub", url = "https://raw.githubusercontent.com/yesimsoul/Yin-Yang-Hub/refs/heads/main/evade", auto_execute = false},
    {name = "event evade", url = "https://raw.githubusercontent.com/gumanba/Scripts/main/EvadeEvent", auto_execute = false},
    {name = "kaitun evade", url = "https://raw.githubusercontent.com/SCRIPTHUB-dev-god/king-icarus/refs/heads/script/main/kaitun.lua", auto_execute = false},
}

local list3 = {
    {name = "luau.pro", url = "https://raw.githubusercontent.com/TheRealAsu/Luau.pro-utils/main/Loader", auto_execute = false},
    {name = "kaitun babft", url = "https://raw.githubusercontent.com/SCRIPTHUB-dev-god/king-icarus/refs/heads/script/main/kaitun.lua", auto_execute = false},
}

local list6 = {
    {name = "atlas hub", url = "https://rawscripts.net/raw/Bee-Swarm-Simulator-Atlas-49277", auto_execute = false},
    {name = "ronix hub", url = "https://api.luarmor.net/files/v3/loaders/fda9babd071d6b536a745774b6bc681c.lua", auto_execute = false},
}

local list7 = {
    {name = "infinite yield", url = "https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source", auto_execute = false},
    {name = "Nameless Admin", url = "https://raw.githubusercontent.com/ltseverydayyou/Nameless-Admin/main/Source.lua", auto_execute = false},
    {name = "Icarus admin", url = "https://raw.githubusercontent.com/SCRIPTHUB-dev-god/king-icarus/refs/heads/script/main/admin.lua", auto_execute = false},
    {name = "vape v4", url = "https://raw.githubusercontent.com/7GrandDadPGN/VapeV4ForRoblox/main/NewMainScript.lua", auto_execute = false},
    {name = "dex explorer", url = "https://rawscripts.net/raw/Universal-Script-Dex-Explorer-DPP-73687", auto_execute = false},
    {name = "AK ADMIN", url = "https://absent.wtf/AKADMIN.lua", auto_execute = false},
}

local list8 = {
    {name = "aimbot pro", url = "https://raw.githubusercontent.com/SCRIPTHUB-dev-god/aimbot/refs/heads/main/aimbot.lua", auto_execute = false},
    {name = "aimbot mobile", url = "https://raw.githubusercontent.com/DanielHubll/DanielHubll/refs/heads/main/Aimbot%20Mobile", auto_execute = false},
}

local list9 = {
    {name = "chiyo hub", url = "https://raw.githubusercontent.com/kaisenlmao/loader/refs/heads/main/chiyo.lua", auto_execute = false},
    {name = "Speed Hub X", url = "https://raw.githubusercontent.com/AhmadV99/Speed-Hub-X/main/Speed%20Hub%20X.lua", auto_execute = false},
    {name = "alchemy hub", url = "https://raw.githubusercontent.com/x2neptunereal/Alchemy/main/gateway.luau", auto_execute = false},
    {name = "lumin hub", url = "http://luminon.top/loader.lua", auto_execute = false},
    {name = "air flow hub", url = "https://airflowscript.com/loader", auto_execute = false},
    {name = "foxname hub", url = "https://foxname.top/loader", auto_execute = false},
}

local list10 = {
    {name = "voidware", url = "https://files.vapevoidware.xyz/VapeVoidware/VW-Add/main/loader.lua", auto_execute = false},
    {name = "foxname hub", url = "https://foxname.top/loader", auto_execute = false},
}

-- bests hub
SubTab1:AddLabel("• bests hub")

SubTab1:AddDivider()

for i, item in ipairs(list) do
    local toggleName = "AutoExec_" .. item.name
    local isAutoExec = SavedData[toggleName] or false

    SubTab1:AddLabel(item.name)

    SubTab1:AddButton({
        Text = "Load Script",
        Func = function()
            if item.url:sub(1, 4) == "http" then
                loadstring(game:HttpGet(item.url))()
                Library:Notify("Script is Execute", 4)
            else
                loadstring(item.url)()
            end
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
                if item.url:sub(1, 4) == "http" then
                    loadstring(game:HttpGet(item.url))()
                else
                    loadstring(item.url)()
                end
            end)
        end)
    end

    SubTab1:AddDivider()
end

-- grow a garden
SubTab2:AddLabel("• grow a garden hub")

SubTab2:AddDivider()

for i, item in ipairs(list1) do
    local toggleName = "AutoExec_" .. item.name
    local isAutoExec = SavedData[toggleName] or false

    SubTab2:AddLabel(item.name)

    SubTab2:AddButton({
        Text = "Load Script",
        Func = function()
            if item.url:sub(1, 4) == "http" then
                loadstring(game:HttpGet(item.url))()
                Library:Notify("Script is Execute", 4)
            else
                loadstring(item.url)()
            end
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
                if item.url:sub(1, 4) == "http" then
                    loadstring(game:HttpGet(item.url))()
                else
                    loadstring(item.url)()
                end
            end)
        end)
    end

    SubTab2:AddDivider()
end

-- Blox Fruit hub
SubTab3:AddLabel("• Blox Fruit hub")

SubTab3:AddDivider()

for i, item in ipairs(list2) do
    local toggleName = "AutoExec_" .. item.name
    local isAutoExec = SavedData[toggleName] or false

    SubTab3:AddLabel(item.name)

    SubTab3:AddButton({
        Text = "Load Script",
        Func = function()
            if item.url:sub(1, 4) == "http" then
                loadstring(game:HttpGet(item.url))()
                Library:Notify("Script is Execute", 4)
            else
                loadstring(item.url)()
            end
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
                if item.url:sub(1, 4) == "http" then
                    loadstring(game:HttpGet(item.url))()
                else
                    loadstring(item.url)()
                end
            end)
        end)
    end

    SubTab3:AddDivider()
end

-- babft hub
SubTab4:AddLabel("• build a boat hub")

SubTab4:AddDivider()

for i, item in ipairs(list3) do
    local toggleName = "AutoExec_" .. item.name
    local isAutoExec = SavedData[toggleName] or false

    SubTab4:AddLabel(item.name)

    SubTab4:AddButton({
        Text = "Load Script",
        Func = function()
            if item.url:sub(1, 4) == "http" then
                loadstring(game:HttpGet(item.url))()
                Library:Notify("Script is Execute", 4)
            else
                loadstring(item.url)()
            end
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
                if item.url:sub(1, 4) == "http" then
                    loadstring(game:HttpGet(item.url))()
                else
                    loadstring(item.url)()
                end
            end)
        end)
    end

    SubTab4:AddDivider()
end

-- evade hub
SubTab5:AddLabel("• evade hub")

SubTab5:AddDivider()

for i, item in ipairs(list4) do
    local toggleName = "AutoExec_" .. item.name
    local isAutoExec = SavedData[toggleName] or false

    SubTab5:AddLabel(item.name)

    SubTab5:AddButton({
        Text = "Load Script",
        Func = function()
            if item.url:sub(1, 4) == "http" then
                loadstring(game:HttpGet(item.url))()
                Library:Notify("Script is Execute", 4)
            else
                loadstring(item.url)()
            end
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
                if item.url:sub(1, 4) == "http" then
                    loadstring(game:HttpGet(item.url))()
                else
                    loadstring(item.url)()
                end
            end)
        end)
    end

    SubTab5:AddDivider()
end

-- bss hub
SubTab7:AddLabel("• Bee Swarm Simulator hub")

SubTab7:AddDivider()

for i, item in ipairs(list6) do
    local toggleName = "AutoExec_" .. item.name
    local isAutoExec = SavedData[toggleName] or false

    SubTab7:AddLabel(item.name)

    SubTab7:AddButton({
        Text = "Load Script",
        Func = function()
            if item.url:sub(1, 4) == "http" then
                loadstring(game:HttpGet(item.url))()
                Library:Notify("Script is Execute", 4)
            else
                loadstring(item.url)()
            end
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
                if item.url:sub(1, 4) == "http" then
                    loadstring(game:HttpGet(item.url))()
                else
                    loadstring(item.url)()
                end
            end)
        end)
    end

    SubTab7:AddDivider()
end

-- admin panel
SubTab8:AddLabel("• admin Script")

SubTab8:AddDivider()

for i, item in ipairs(list7) do
    local toggleName = "AutoExec_" .. item.name
    local isAutoExec = SavedData[toggleName] or false

    SubTab8:AddLabel(item.name)

    SubTab8:AddButton({
        Text = "Load Script",
        Func = function()
            if item.url:sub(1, 4) == "http" then
                loadstring(game:HttpGet(item.url))()
                Library:Notify("Script is Execute", 4)
            else
                loadstring(item.url)()
            end
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
                if item.url:sub(1, 4) == "http" then
                    loadstring(game:HttpGet(item.url))()
                else
                    loadstring(item.url)()
                end
            end)
        end)
    end

    SubTab8:AddDivider()
end

-- aimbot
SubTab9:AddLabel("• aimbot Script")

SubTab9:AddDivider()

for i, item in ipairs(list8) do
    local toggleName = "AutoExec_" .. item.name
    local isAutoExec = SavedData[toggleName] or false

    SubTab9:AddLabel(item.name)

    SubTab9:AddButton({
        Text = "Load Script",
        Func = function()
            if item.url:sub(1, 4) == "http" then
                loadstring(game:HttpGet(item.url))()
                Library:Notify("Script is Execute", 4)
            else
                loadstring(item.url)()
            end
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
                if item.url:sub(1, 4) == "http" then
                    loadstring(game:HttpGet(item.url))()
                else
                    loadstring(item.url)()
                end
            end)
        end)
    end

    SubTab9:AddDivider()
end

-- grow a garden 2
SubTab10:AddLabel("• grow a garden 2 hub")

SubTab10:AddDivider()

for i, item in ipairs(list9) do
    local toggleName = "AutoExec_" .. item.name
    local isAutoExec = SavedData[toggleName] or false

    SubTab10:AddLabel(item.name)

    SubTab10:AddButton({
        Text = "Load Script",
        Func = function()
            if item.url:sub(1, 4) == "http" then
                loadstring(game:HttpGet(item.url))()
                Library:Notify("Script is Execute", 4)
            else
                loadstring(item.url)()
            end
        end
    })

    local MyToggle = SubTab10:AddToggle(toggleName, {
        Text = "Auto Execute",
        Default = isAutoExec
    })

    MyToggle:OnChanged(function()
        SaveConfig(toggleName, MyToggle.Value)
    end)

    if isAutoExec then
        task.spawn(function()
            pcall(function()
                if item.url:sub(1, 4) == "http" then
                    loadstring(game:HttpGet(item.url))()
                else
                    loadstring(item.url)()
                end
            end)
        end)
    end

    SubTab10:AddDivider()
end

-- 99 night in the forest
SubTab11:AddLabel("• 99 nitf hub")

SubTab11:AddDivider()

for i, item in ipairs(list10) do
    local toggleName = "AutoExec_" .. item.name
    local isAutoExec = SavedData[toggleName] or false

    SubTab11:AddLabel(item.name)

    SubTab11:AddButton({
        Text = "Load Script",
        Func = function()
            if item.url:sub(1, 4) == "http" then
                loadstring(game:HttpGet(item.url))()
                Library:Notify("Script is Execute", 4)
            else
                loadstring(item.url)()
            end
        end
    })

    local MyToggle = SubTab11:AddToggle(toggleName, {
        Text = "Auto Execute",
        Default = isAutoExec
    })

    MyToggle:OnChanged(function()
        SaveConfig(toggleName, MyToggle.Value)
    end)

    if isAutoExec then
        task.spawn(function()
            pcall(function()
                if item.url:sub(1, 4) == "http" then
                    loadstring(game:HttpGet(item.url))()
                else
                    loadstring(item.url)()
                end
            end)
        end)
    end

    SubTab11:AddDivider()
end

local Tab2 = Window:AddTab({
    Name = "Setting",
    Description = "Setting ui",
    Icon = "settings"
})

local setGroupBox = Tab2:AddLeftGroupbox("Setting", "settings")

setGroupBox:AddLabel("setting ui")

setGroupBox:AddButton({
    Text = "restart ui",
    Func = function()
        if Library then Library:Unload() end
        task.spawn(function()
            task.wait()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/SCRIPTHUB-dev-god/king-icarus/refs/heads/script/main/game.lua",true))()
        end)
    end
})

setGroupBox:AddButton({
    Text = "delete ui",
    Func = function()
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

setGroupBox:AddButton({
    Text = "Server Hop",
    Func = doServerHop
})

setGroupBox:AddButton({
    Text = "Rejoin",
    Func = doRejoin
})

local seGroupBox = Tab2:AddRightGroupbox("credits", "clipboard")

seGroupBox:AddLabel("credits by")

seGroupBox:AddLabel("• ICARUS hub")
seGroupBox:AddLabel("• mspaint")
seGroupBox:AddLabel("• others")

seGroupBox:AddDivider()

seGroupBox:AddLabel("logs update")

seGroupBox:AddLabel("• new game support")
seGroupBox:AddLabel("• new 2 script")
seGroupBox:AddLabel("• add Notify Execute script")
