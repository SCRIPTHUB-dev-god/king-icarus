-- Auto unload dupe + clear previous
if getgenv().TAS_Lib then
    pcall(function()
        if getgenv().TAS_Cleanup then getgenv().TAS_Cleanup() end
        getgenv().TAS_Lib:Unload()
    end)
end

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/Obsidian/refs/heads/main/Library.lua"))()
getgenv().TAS_Lib = Library

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
LocalPlayer.CameraMaxZoomDistance = 10000

local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HRP = Character:WaitForChild("HumanoidRootPart")
local Humanoid = Character:WaitForChild("Humanoid")
local Animator = Humanoid:FindFirstChildOfClass("Animator") or Instance.new("Animator", Humanoid)
local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

LocalPlayer.CharacterAdded:Connect(function(char)
    Character = char
    HRP = char:WaitForChild("HumanoidRootPart")
    Humanoid = char:WaitForChild("Humanoid")
    Animator = Humanoid:FindFirstChildOfClass("Animator") or Instance.new("Animator", Humanoid)
    Humanoid.WalkSpeed = WalkSpeed.Value
    Humanoid.JumpPower = JumpPower.Value
    LocalPlayer.CameraMaxZoomDistance = 10000
end)

local Window = Library:CreateWindow({
    Title = "Icarus T.A.S",
    Footer = "Tool Assisted Speedrun",
    ToggleKeybind = Enum.KeyCode.RightShift,
    Icon = "star",
    Center = true,
    AutoShow = true
})

local Tabs = {
    Support = Window:AddTab("Support", "info"),
    Main = Window:AddTab("Main", "joystick")
}

local SupportLeft = Tabs.Support:AddLeftGroupbox("Discord", "info")
local SupportRight = Tabs.Support:AddRightGroupbox("Game Info", "info")

local TASGroup = Tabs.Main:AddLeftGroupbox("T.A.S", "user")
local MiscGroup = Tabs.Main:AddRightGroupbox("Misc", "between-horizontal-end")

local FPS = 480
local FRAME_TIME = 1 / FPS

local TAS = {
    Recording = false,
    Running = false,
    ReverseRunning = false,
    Frames = {},
    Connection = nil,
    AnimCache = {},
    ActiveTracks = {},
    OldCamType = Camera.CameraType,
    OldSubject = Camera.CameraSubject,
    OldGravity = Workspace.Gravity
}

local InfiniteJump = { Enabled = false, Conn = nil }
local WalkSpeed = { Value = 16 }
local JumpPower = { Value = 50 }
local TASPrediction = { Value = 0.08 }
local ClickTP = { Enabled = false, Conns = {}, StartTime = 0, StartPos = Vector2.zero, Mode = "Instant" }

local Toggles = {}
local RecordGui = nil
local StartGui = nil
local ReverseGui = nil

-- Support Tab Content
SupportLeft:AddLabel("Join Discord")
SupportLeft:AddButton({
    Text = "Copy Discord Link",
    Func = function()
        setclipboard("https://discord.gg/ZjbhNqDH9U")
    end
})

local placeId = game.PlaceId
local deviceType = "Unknown"
if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled then
    deviceType = "Mobile"
elseif UserInputService.GamepadEnabled then
    deviceType = "Console"
else
    deviceType = "PC"
end

SupportRight:AddLabel("Place ID: "..placeId)
SupportRight:AddLabel("Device: "..deviceType)
SupportRight:AddDivider()
SupportRight:AddButton({
    Text = "Copy Place ID",
    Func = function()
        setclipboard(tostring(placeId))
    end
})

local FollowPart = Instance.new("Part")
FollowPart.Name = "TAS_FollowPart"
FollowPart.Size = Vector3.new(1,1,1)
FollowPart.Transparency = 1
FollowPart.CanCollide = false
FollowPart.Anchored = true
FollowPart.Parent = workspace

RunService.Heartbeat:Connect(function()
    if not HRP then return end
    local offset = Vector3.new(0, 3, 0)
    local predictedPos = HRP.Position
    if TAS.Running or TAS.ReverseRunning then
        predictedPos += HRP.AssemblyLinearVelocity * TASPrediction.Value
    end
    local targetCF = CFrame.new(predictedPos + offset, predictedPos + offset + Camera.CFrame.LookVector)
    FollowPart.CFrame = FollowPart.CFrame:Lerp(targetCF, 0.25)
end)

local function GetPlayingAnims()
    local anims = {}
    for _, track in ipairs(Humanoid:GetPlayingAnimationTracks()) do
        local anim = track.Animation
        if anim and anim.AnimationId ~= "" then
            table.insert(anims, {
                id = anim.AnimationId,
                time = track.TimePosition,
                speed = track.Speed,
                weight = track.WeightCurrent
            })
        end
    end
    return anims
end

local function GetOrCreateTrack(animId)
    if TAS.AnimCache[animId] then return TAS.AnimCache[animId] end
    local anim = Instance.new("Animation")
    anim.AnimationId = animId
    local track = Animator:LoadAnimation(anim)
    track.Priority = Enum.AnimationPriority.Action
    TAS.AnimCache[animId] = track
    return track
end

local function StopAllAnims()
    for _, track in pairs(TAS.ActiveTracks) do
        if track and track.IsPlaying then track:Stop(0.05) end
    end
    TAS.ActiveTracks = {}
end

local function UpdateAnimsStable(wantedAnims)
    local wantedIds = {}
    for _, data in ipairs(wantedAnims) do
        wantedIds[data.id] = true
        local track = GetOrCreateTrack(data.id)
        if not track.IsPlaying then
            track:Play(0.05, data.weight, data.speed)
        else
            track:AdjustWeight(data.weight)
            track:AdjustSpeed(data.speed)
        end
        if math.abs(track.TimePosition - data.time) > 0.03 then
            track.TimePosition = data.time
        end
        TAS.ActiveTracks[data.id] = track
    end
    for id, track in pairs(TAS.ActiveTracks) do
        if not wantedIds[id] then
            track:Stop(0.05)
            TAS.ActiveTracks[id] = nil
        end
    end
end

local function startCamToPart()
    TAS.OldCamType = Camera.CameraType
    TAS.OldSubject = Camera.CameraSubject
    Camera.CameraType = Enum.CameraType.Custom
    Camera.CameraSubject = FollowPart
    LocalPlayer.CameraMaxZoomDistance = 10000
end

local function stopCamToPart()
    Camera.CameraType = TAS.OldCamType or Enum.CameraType.Custom
    Camera.CameraSubject = TAS.OldSubject or Humanoid
end

local function enableZeroGravity()
    TAS.OldGravity = Workspace.Gravity
    Workspace.Gravity = 0
    if Humanoid then
        Humanoid.PlatformStand = true
        Humanoid.AutoRotate = false
    end
end

local function restoreGravity()
    Workspace.Gravity = TAS.OldGravity or 196.2
    if Humanoid then
        Humanoid.PlatformStand = false
        Humanoid.AutoRotate = true
        Humanoid.WalkSpeed = WalkSpeed.Value
        Humanoid.JumpPower = JumpPower.Value
    end
end

local function applySmoothTP(targetCF, velocity)
    if not HRP then return end
    HRP.CFrame = HRP.CFrame:Lerp(targetCF, 0.7)
    HRP.AssemblyLinearVelocity = velocity
end

local function safeTeleport(cf)
    if not HRP or not Humanoid then return end
    HRP.AssemblyLinearVelocity = Vector3.zero
    HRP.AssemblyAngularVelocity = Vector3.zero
    HRP.CFrame = cf
    Humanoid.PlatformStand = false
    Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
    task.delay(0.05, function()
        if Humanoid then Humanoid:ChangeState(Enum.HumanoidStateType.Running) end
    end)
end

local function tweenTeleport(targetCF)
    if not HRP then return end
    local dist = (HRP.Position - targetCF.Position).Magnitude
    local time = math.clamp(dist / 100, 0.2, 2)
    local tween = TweenService:Create(HRP, TweenInfo.new(time, Enum.EasingStyle.Linear), {CFrame = targetCF})
    tween:Play()
    tween.Completed:Wait()
end

local function createActionGui(name, text, color, callback)
    local gui = Instance.new("ScreenGui")
    gui.Name = name
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.Parent = PlayerGui

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 180, 0, 50)
    frame.Position = UDim2.new(0.5, -90, 0, 20)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    frame.BackgroundTransparency = 0.2
    frame.Parent = gui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = frame

    local stroke = Instance.new("UIStroke")
    stroke.Color = color
    stroke.Thickness = 2
    stroke.Parent = frame

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 1, -10)
    btn.Position = UDim2.new(0, 5, 0, 5)
    btn.BackgroundColor3 = color
    btn.TextColor3 = Color3.new(1,1,1)
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamBold
    btn.Text = text
    btn.AutoButtonColor = true
    btn.Parent = frame

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = btn

    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = color:Lerp(Color3.new(1,1,1), 0.2)}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = color}):Play()
    end)

    btn.MouseButton1Click:Connect(callback)
    return gui
end

local function destroyGui(guiRef)
    if guiRef and guiRef.Parent then guiRef:Destroy() end
end

Toggles.Record = TASGroup:AddToggle("TAS_Record", {
    Text = "Record TAS",
    Default = false,
    Risky = true,
    Callback = function(Value)
        TAS.Recording = Value
        if Value then
            Window:Toggle()
            if Toggles.Start then Toggles.Start:SetDisabled(true) end
            if Toggles.Reverse then Toggles.Reverse:SetDisabled(true) end
            TAS.Frames = {}
            TAS.AnimCache = {}
            StopAllAnims()
            RecordGui = createActionGui("TAS_RecordGui", "STOP RECORD", Color3.fromRGB(220,60,60), function()
                if Toggles.Record then Toggles.Record:SetValue(false) end
            end)
            local startTime = os.clock()
            local accumulator = 0
            if TAS.Connection then TAS.Connection:Disconnect() end
            TAS.Connection = RunService.Heartbeat:Connect(function(dt)
                if not HRP or not Humanoid then return end
                accumulator += dt
                while accumulator >= FRAME_TIME do
                    accumulator -= FRAME_TIME
                    table.insert(TAS.Frames, {
                        t = os.clock() - startTime,
                        CFrame = HRP.CFrame,
                        Velocity = HRP.AssemblyLinearVelocity,
                        Jumping = Humanoid.Jump,
                        Anims = GetPlayingAnims()
                    })
                end
            end)
        else
            Window:Toggle()
            destroyGui(RecordGui) RecordGui = nil
            if TAS.Connection then TAS.Connection:Disconnect() TAS.Connection = nil end
            if Toggles.Start then Toggles.Start:SetDisabled(false) end
            if Toggles.Reverse then Toggles.Reverse:SetDisabled(false) end
        end
    end
})

Toggles.Start = TASGroup:AddToggle("TAS_Start", {
    Text = "Start TAS",
    Default = false,
    Callback = function(Value)
        TAS.Running = Value
        if Value then
            if TAS.Recording or TAS.ReverseRunning or #TAS.Frames == 0 then
                Toggles.Start:SetValue(false)
                return
            end
            Window:Toggle()
            if Toggles.Record then Toggles.Record:SetDisabled(true) end
            if Toggles.Reverse then Toggles.Reverse:SetDisabled(true) end
            if Toggles.ClickTP then Toggles.ClickTP:SetDisabled(true) end
            startCamToPart()
            enableZeroGravity()
            StartGui = createActionGui("TAS_StartGui", "STOP PLAYBACK", Color3.fromRGB(60, 170, 220), function()
                if Toggles.Start then Toggles.Start:SetValue(false) end
            end)
            task.spawn(function()
                StopAllAnims()
                local playStart = os.clock()
                local idx = 1
                while TAS.Running and idx <= #TAS.Frames do
                    local frame = TAS.Frames[idx]
                    while TAS.Running and (os.clock() - playStart) < frame.t do
                        RunService.Heartbeat:Wait()
                    end
                    applySmoothTP(frame.CFrame, frame.Velocity)
                    if frame.Jumping then Humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end
                    UpdateAnimsStable(frame.Anims)
                    idx += 1
                end
                StopAllAnims()
                TAS.AnimCache = {}
                stopCamToPart()
                restoreGravity()
                if Toggles.Record then Toggles.Record:SetDisabled(false) end
                if Toggles.Reverse then Toggles.Reverse:SetDisabled(false) end
                if Toggles.ClickTP then Toggles.ClickTP:SetDisabled(false) end
                if TAS.Running then Toggles.Start:SetValue(false) end
            end)
        else
            Window:Toggle()
            destroyGui(StartGui) StartGui = nil
            StopAllAnims()
            stopCamToPart()
            restoreGravity()
            if Toggles.ClickTP then Toggles.ClickTP:SetDisabled(false) end
        end
    end
})

Toggles.Reverse = TASGroup:AddToggle("TAS_Reverse", {
    Text = "Reverse Start TAS",
    Default = false,
    Callback = function(Value)
        TAS.ReverseRunning = Value
        if Value then
            if TAS.Recording or TAS.Running or #TAS.Frames == 0 then
                Toggles.Reverse:SetValue(false)
                return
            end
            Window:Toggle()
            if Toggles.Record then Toggles.Record:SetDisabled(true) end
            if Toggles.Start then Toggles.Start:SetDisabled(true) end
            if Toggles.ClickTP then Toggles.ClickTP:SetDisabled(true) end
            startCamToPart()
            enableZeroGravity()
            ReverseGui = createActionGui("TAS_ReverseGui", "STOP REVERSE", Color3.fromRGB(220, 170, 60), function()
                if Toggles.Reverse then Toggles.Reverse:SetValue(false) end
            end)
            task.spawn(function()
                StopAllAnims()
                local totalTime = TAS.Frames[#TAS.Frames].t
                local playStart = os.clock()
                local idx = #TAS.Frames
                while TAS.ReverseRunning and idx >= 1 do
                    local frame = TAS.Frames[idx]
                    local revTime = totalTime - frame.t
                    while TAS.ReverseRunning and (os.clock() - playStart) < revTime do
                        RunService.Heartbeat:Wait()
                    end
                    applySmoothTP(frame.CFrame, -frame.Velocity)
                    if frame.Jumping then Humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end
                    UpdateAnimsStable(frame.Anims)
                    idx -= 1
                end
                StopAllAnims()
                TAS.AnimCache = {}
                stopCamToPart()
                restoreGravity()
                if Toggles.Record then Toggles.Record:SetDisabled(false) end
                if Toggles.Start then Toggles.Start:SetDisabled(false) end
                if Toggles.ClickTP then Toggles.ClickTP:SetDisabled(false) end
                if TAS.ReverseRunning then Toggles.Reverse:SetValue(false) end
            end)
        else
            Window:Toggle()
            destroyGui(ReverseGui) ReverseGui = nil
            StopAllAnims()
            stopCamToPart()
            restoreGravity()
            if Toggles.ClickTP then Toggles.ClickTP:SetDisabled(false) end
        end
    end
})

TASGroup:AddButton({
    Text = "Clear Recording",
    DoubleClick = true,
    Func = function()
        TAS.Frames = {}
        TAS.AnimCache = {}
        StopAllAnims()
    end
})

TASGroup:AddDivider()

local MainButton = TASGroup:AddButton({
    Text = "TP First",
    Func = function()
        if #TAS.Frames == 0 then return end
        safeTeleport(TAS.Frames[1].CFrame)
    end
})

MainButton:AddButton({
    Text = "TP Last",
    Func = function()
        if #TAS.Frames == 0 then return end
        safeTeleport(TAS.Frames[#TAS.Frames].CFrame)
    end
})

Toggles.InfiniteJump = MiscGroup:AddToggle("InfiniteJump_Toggle", {
    Text = "Infinite Jump",
    Default = false,
    Callback = function(Value)
        InfiniteJump.Enabled = Value
        if Value then
            Library:Notify("Infinite Jump ON", 2)
            InfiniteJump.Conn = UserInputService.JumpRequest:Connect(function()
                if Humanoid then Humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end
            end)
        else
            Library:Notify("Infinite Jump OFF", 2)
            if InfiniteJump.Conn then InfiniteJump.Conn:Disconnect() InfiniteJump.Conn = nil end
        end
    end
})

MiscGroup:AddSlider("WalkSpeed_Slider", {
    Text = "Walk Speed",
    Default = 16,
    Min = 16,
    Max = 200,
    Rounding = 0,
    Callback = function(Value)
        WalkSpeed.Value = Value
        if Humanoid then Humanoid.WalkSpeed = Value end
    end
})

MiscGroup:AddSlider("JumpPower_Slider", {
    Text = "Jump Power",
    Default = 50,
    Min = 50,
    Max = 200,
    Rounding = 0,
    Callback = function(Value)
        JumpPower.Value = Value
        if Humanoid then Humanoid.JumpPower = Value end
    end
})

MiscGroup:AddDivider()

Toggles.ClickTP = MiscGroup:AddToggle("ClickTP_Toggle", {
    Text = "Click TP",
    Default = false,
    Callback = function(Value)
        ClickTP.Enabled = Value
        if Value then
            Library:Notify("Click TP ON", 2)
            ClickTP.Conns = {}
            table.insert(ClickTP.Conns, Mouse.Button1Down:Connect(function()
                ClickTP.StartTime = tick()
                ClickTP.StartPos = Vector2.new(Mouse.X, Mouse.Y)
            end))
            table.insert(ClickTP.Conns, Mouse.Button1Up:Connect(function()
                if TAS.Running or TAS.ReverseRunning then return end
                if not HRP then return end
                local dt = tick() - ClickTP.StartTime
                local dist = (Vector2.new(Mouse.X, Mouse.Y) - ClickTP.StartPos).Magnitude
                if dt > 0.25 or dist > 10 then return end
                local unitRay = Camera:ScreenPointToRay(Mouse.X, Mouse.Y)
                local raycastParams = RaycastParams.new()
                raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
                raycastParams.FilterDescendantsInstances = {Character}
                local result = Workspace:Raycast(unitRay.Origin, unitRay.Direction * 10000, raycastParams)
                if result and result.Instance and result.Instance.CanCollide then
                    local hitPos = result.Position
                    local targetCF = CFrame.new(hitPos + Vector3.new(0, 3, 0), hitPos + Vector3.new(0, 3, 0) + Camera.CFrame.LookVector)
                    if ClickTP.Mode == "Instant" then
                        safeTeleport(targetCF)
                    elseif ClickTP.Mode == "Tween" then
                        tweenTeleport(targetCF)
                    end
                end
            end))
        else
            Library:Notify("Click TP OFF", 2)
            for _, conn in ipairs(ClickTP.Conns) do
                if conn then conn:Disconnect() end
            end
            ClickTP.Conns = {}
        end
    end
})

MiscGroup:AddDropdown("ClickTP_Mode", {
    Text = "Choose Mode TP",
    Values = {"Instant", "Tween"},
    Default = 1,
    Callback = function(Value)
        ClickTP.Mode = Value
    end
})

MiscGroup:AddSlider("TAS_Prediction_Slider", {
    Text = "Prediction",
    Default = 8,
    Min = 0,
    Max = 20,
    Rounding = 0,
    Callback = function(Value)
        TASPrediction.Value = Value / 100
    end
})

local InfoGroup = Tabs.Main:AddLeftGroupbox("Info", "info")
local StatusLabel = InfoGroup:AddLabel("Status: Idle")
local FramesLabel = InfoGroup:AddLabel("Frames: 0")
local SpeedLabel = InfoGroup:AddLabel("Speed: 16")

RunService.Heartbeat:Connect(function()
    local status = "Idle"
    if TAS.Recording then status = "Recording" end
    if TAS.Running then status = "Playing + 0G" end
    if TAS.ReverseRunning then status = "Reverse + 0G" end
    if InfiniteJump.Enabled then status = "Infinite Jump" end
    if ClickTP.Enabled then status = "Click TP" end
    StatusLabel:SetText("Status: "..status)
    FramesLabel:SetText("Frames: "..#TAS.Frames.." @ "..FPS.." FPS")
    SpeedLabel:SetText("Speed: "..WalkSpeed.Value.." | Jump: "..JumpPower.Value)
end)

getgenv().TAS_Cleanup = function()
    TAS.Running = false
    TAS.ReverseRunning = false
    TAS.Recording = false
    destroyGui(RecordGui) RecordGui = nil
    destroyGui(StartGui) StartGui = nil
    destroyGui(ReverseGui) ReverseGui = nil
    if TAS.Connection then TAS.Connection:Disconnect() end
    if InfiniteJump.Conn then InfiniteJump.Conn:Disconnect() end
    for _, conn in ipairs(ClickTP.Conns) do
        if conn then conn:Disconnect() end
    end
    restoreGravity()
    stopCamToPart()
    StopAllAnims()
    if FollowPart then FollowPart:Destroy() end
end

Library:OnUnload(function()
    if getgenv().TAS_Cleanup then getgenv().TAS_Cleanup() end
    getgenv().TAS_Lib = nil
    getgenv().TAS_Cleanup = nil
end)
