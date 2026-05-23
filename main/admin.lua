local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local ContextActionService = game:GetService("ContextActionService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local camera = workspace.CurrentCamera

local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

WindUI:AddTheme({
    Name = "My Theme",
    Accent = Color3.fromHex("#00d4ff"),
    Background = Color3.fromHex("#0a192f"),
    Outline = Color3.fromHex("#1e293b"),
    Text = Color3.fromHex("#f0f9ff"),
    Placeholder = Color3.fromHex("#94a3b8"),
    Button = Color3.fromHex("#1d4ed8"),
    Icon = Color3.fromHex("#38bdf8"),
})

local Window = WindUI:CreateWindow({
    Title = "Icarus admin | script panel",
    Icon = "star",
    Author = "by.icarus community",
    Theme = "My Theme",
    Size = UDim2.fromOffset(740, 500),
    Transparent = true,
    BackgroundImageTransparency = 0.73,
    HideSearchBar = false,
})

Window:DisableTopbarButtons({"Fullscreen"})
Window:Tag({ Title = "keyless", Icon = "key", Color = Color3.fromHex("#174aa3"), Radius = 0 })
Window:Tag({ Title = "V 1.1.6", Icon = "server", Color = Color3.fromHex("#fff200"), Radius = 1 })

Window:EditOpenButton({
    Title = "Icarus admin",
    Icon = "snowflake",
    CornerRadius = UDim.new(0,16),
    StrokeThickness = 2.25,
    Color = ColorSequence.new(Color3.fromHex("#3d87ff"), Color3.fromHex("#91bbff")),
    Enabled = true,
})

local TabSupport = Window:Tab({ Title = "Support", Icon = "info" })
TabSupport:Code({ Title = "Discord Link", Code = [[https://discord.gg/ZjbhNqDH9U]] })
Window:Divider()

local Section1 = Window:Section({
    Title = "Main Features",
    Icon = "star",
    Opened = true,
})

local TabExploits = Section1:Tab({ Title = "Exploits", Icon = "clipboard" })
local TabPartTP = Section1:Tab({ Title = "Part TP", Icon = "map-pin" })

local flyEnabled = false
local speed = 70
local bVelocity = nil
local bGyro = nil
local shiftLockConn = nil

local function setShiftLock(state)
    local char = player.Character or player.CharacterAdded:Wait()
    local humanoid = char:WaitForChild("Humanoid")
    local root = char:WaitForChild("HumanoidRootPart")
    player.DevEnableMouseLock = state
    if state then
        humanoid.AutoRotate = false
        UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
        UserInputService.MouseIconEnabled = false
        if shiftLockConn then shiftLockConn:Disconnect() end
        shiftLockConn = RunService.RenderStepped:Connect(function()
            if not root or not root.Parent then return end
            local camLook = camera.CFrame.LookVector
            local flatLook = Vector3.new(camLook.X, 0, camLook.Z).Unit
            root.CFrame = CFrame.new(root.Position, root.Position + flatLook)
        end)
    else
        humanoid.AutoRotate = true
        UserInputService.MouseBehavior = Enum.MouseBehavior.Default
        UserInputService.MouseIconEnabled = true
        if shiftLockConn then shiftLockConn:Disconnect() shiftLockConn = nil end
    end
end

local freecamPart = nil
local freecamConn = nil
local freecamSpeed = 2
local moveKeys = {W=false,A=false,S=false,D=false}

local function updateFreecamMovement()
    if not freecamPart then return end
    local char = player.Character
    if not char then return end
    local humanoid = char:FindFirstChild("Humanoid")
    if not humanoid then return end

    local camCF = camera.CFrame
    local moveDir = Vector3.zero

    if UserInputService.TouchEnabled then
        local moveVec = humanoid.MoveDirection
        if moveVec.Magnitude > 0 then
            local flatForward = Vector3.new(camCF.LookVector.X, 0, camCF.LookVector.Z).Unit
            local flatRight = Vector3.new(camCF.RightVector.X, 0, camCF.RightVector.Z).Unit
            local forwardInput = moveVec:Dot(flatForward)
            local rightInput = moveVec:Dot(flatRight)
            moveDir += camCF.LookVector * forwardInput
            moveDir += camCF.RightVector * rightInput
        end
    else
        if moveKeys.W then moveDir += camCF.LookVector end
        if moveKeys.S then moveDir -= camCF.LookVector end
        if moveKeys.D then moveDir += camCF.RightVector end
        if moveKeys.A then moveDir -= camCF.RightVector end
    end

    if moveDir.Magnitude > 0 then
        moveDir = moveDir.Unit * freecamSpeed
    end

    freecamPart.CFrame = freecamPart.CFrame + moveDir
end

local function handleFreecamInput(_, inputState, inputObj)
    local key = inputObj.KeyCode.Name
    if moveKeys[key] ~= nil then
        moveKeys[key] = inputState == Enum.UserInputState.Begin
        return Enum.ContextActionResult.Sink
    end
    return Enum.ContextActionResult.Pass
end

local function setFreecam(state)
    local char = player.Character or player.CharacterAdded:Wait()
    local humanoid = char:WaitForChild("Humanoid")
    local root = char:WaitForChild("HumanoidRootPart")

    if state then
        humanoid.WalkSpeed = 0
        humanoid.JumpPower = 0
        root.Anchored = true

        player.CameraMaxZoomDistance = 0
        player.CameraMinZoomDistance = 0
        player.CameraMode = Enum.CameraMode.LockFirstPerson

        freecamPart = Instance.new("Part")
        freecamPart.Name = "FreecamPart"
        freecamPart.Size = Vector3.new(1,1,1)
        freecamPart.Transparency = 1
        freecamPart.CanCollide = false
        freecamPart.Anchored = true
        freecamPart.CFrame = camera.CFrame
        freecamPart.Parent = workspace

        camera.CameraType = Enum.CameraType.Custom
        camera.CameraSubject = freecamPart

        ContextActionService:BindAction("FreecamMove", handleFreecamInput, false,
            Enum.KeyCode.W, Enum.KeyCode.A, Enum.KeyCode.S, Enum.KeyCode.D
        )

        if freecamConn then freecamConn:Disconnect() end
        freecamConn = RunService.RenderStepped:Connect(updateFreecamMovement)
    else
        humanoid.WalkSpeed = 16
        humanoid.JumpPower = 50
        root.Anchored = false

        player.CameraMaxZoomDistance = 400
        player.CameraMinZoomDistance = 0.5
        player.CameraMode = Enum.CameraMode.Classic

        camera.CameraType = Enum.CameraType.Custom
        camera.CameraSubject = humanoid

        ContextActionService:UnbindAction("FreecamMove")

        if freecamConn then freecamConn:Disconnect() freecamConn = nil end
        if freecamPart then freecamPart:Destroy() freecamPart = nil end
        for k in pairs(moveKeys) do moveKeys[k] = false end
    end
end

TabExploits:Toggle({ Title = "Fly", Callback = function(state)
    flyEnabled = state
    local char = player.Character
    local humanoid = char and char:FindFirstChildOfClass("Humanoid")
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if flyEnabled then
        if humanoid then humanoid.PlatformStand = true end
        if root then
            bVelocity = Instance.new("BodyVelocity")
            bVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            bVelocity.Velocity = Vector3.new(0, 0, 0)
            bVelocity.Parent = root
            
            bGyro = Instance.new("BodyGyro")
            bGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
            bGyro.CFrame = root.CFrame
            bGyro.Parent = root
        end
    else
        if humanoid then humanoid.PlatformStand = false end
        if bVelocity then bVelocity:Destroy() bVelocity = nil end
        if bGyro then bGyro:Destroy() bGyro = nil end
    end
end})

TabExploits:Input({ Title = "Fly Speed", Value = "70", Callback = function(input) if tonumber(input) then speed = tonumber(input) end end })
TabExploits:Divider()

TabExploits:Toggle({ Title = "Shift Lock", Callback = function(state)
    setShiftLock(state)
end})
TabExploits:Divider()

local noclipEnabled = false
TabExploits:Toggle({ Title = "Noclip", Callback = function(state) noclipEnabled = state end })
TabExploits:Divider()

local infJumpEnabled = false
TabExploits:Toggle({ Title = "Infinite Jump", Callback = function(state) infJumpEnabled = state end })
TabExploits:Divider()

local viewEnabled = false
local selectedTargetName = ""
local followPart = nil

local function getPlayerList()
    local list = {}
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player then table.insert(list, p.Name) end
    end
    return list
end

local DropdownView = TabExploits:Dropdown({ Title = "Select Player to View", Values = getPlayerList(), Callback = function(v) selectedTargetName = v end })

TabExploits:Button({ Title = "Refresh Player List", Color = Color3.fromHex("#3d87ff"), Callback = function()
    DropdownView:Refresh(getPlayerList())
end })

TabExploits:Toggle({ Title = "View Player", Callback = function(state)
    viewEnabled = state
    if viewEnabled then
        local target = Players:FindFirstChild(selectedTargetName)
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            followPart = Instance.new("Part")
            followPart.Size = Vector3.new(1, 1, 1)
            followPart.Transparency = 1
            followPart.CanCollide = false
            followPart.Anchored = true
            followPart.Parent = workspace
            camera.CameraSubject = target.Character:FindFirstChild("Humanoid")
        end
    else
        if followPart then followPart:Destroy() followPart = nil end
        camera.CameraSubject = player.Character and player.Character:FindFirstChild("Humanoid")
    end
end })

TabExploits:Divider()

TabExploits:Toggle({ Title = "Freecam", Callback = function(state)
    setFreecam(state)
end})

TabExploits:Slider({
    Title = "Freecam Speed",
    Step = 0.5,
    Value = { Min = 0.5, Max = 10, Default = 2 },
    Callback = function(value)
        freecamSpeed = value
    end
})
TabExploits:Divider()

local walkSpeedPower = 16
local jumpPower = 50
local speedEnabled = false
local jumpEnabled = false

TabExploits:Input({ Title = "WalkSpeed Power", Value = "16", Callback = function(val) walkSpeedPower = tonumber(val) or 16 end })
TabExploits:Toggle({ Title = "Speed Enabled", Callback = function(state) speedEnabled = state end})

TabExploits:Input({ Title = "JumpPower Power", Value = "50", Callback = function(val) jumpPower = tonumber(val) or 50 end })
TabExploits:Toggle({ Title = "Jump Enabled", Callback = function(state) jumpEnabled = state end})

TabExploits:Button({
    Title = "Reset Power Defaults",
    Color = Color3.fromHex("#ff3030"),
    Callback = function()
        walkSpeedPower = 16
        jumpPower = 50
        speedEnabled = false
        jumpEnabled = false
    end
})

local savedParts = {}
local selectedPartName = "None"
local tpMode = "Teleport"

local DropdownPart = TabPartTP:Dropdown({ Title = "Select locations", Values = {"None"}, Callback = function(v) selectedPartName = v end })
local DropdownMode = TabPartTP:Dropdown({ Title = "Mode", Values = {"Teleport", "Tween"}, Value = "Teleport", Callback = function(v) tpMode = v end })

TabPartTP:Button({ Title = "teleport location", Color = Color3.fromHex("#00d4ff"), Callback = function()
    local char = player.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local target = workspace:FindFirstChild(selectedPartName)
    if root and target then
        if tpMode == "Teleport" then root.CFrame = target.CFrame
        else TweenService:Create(root, TweenInfo.new(1), {CFrame = target.CFrame}):Play() end
    end
end})

TabPartTP:Button({ Title = "Create locations", Color = Color3.fromHex("#00d4ff"), Callback = function()
    local p = Instance.new("Part")
    p.Name = "go_location_".. #savedParts + 1
    p.Transparency = 1
    p.CanCollide = false
    p.Anchored = true
    p.Size = Vector3.new(4, 1, 4)
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then p.CFrame = player.Character.HumanoidRootPart.CFrame end
    p.Parent = workspace
    table.insert(savedParts, p.Name)
    DropdownPart:Refresh(savedParts)
end})

TabPartTP:Button({ Title = "Delete locations", Color = Color3.fromHex("#ff3030"), Callback = function()
    local target = workspace:FindFirstChild(selectedPartName)
    if target then
        target:Destroy()
        local newParts = {}
        for _, name in pairs(savedParts) do if name ~= selectedPartName then table.insert(newParts, name) end end
        savedParts = newParts
        DropdownPart:Refresh(savedParts)
    end
end})

TabPartTP:Divider()

local loopParts = {}
local loopTweenSpeed = 1
local loopTweenEnabled = false
local currentLoopIndex = 1
local currentTween = nil

local function startLoopTween()
    if not loopTweenEnabled or #loopParts == 0 then return end
    local char = player.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return end

    if currentLoopIndex > #loopParts then currentLoopIndex = 1 end

    local targetPart = loopParts[currentLoopIndex]
    if not targetPart or not targetPart.Parent then
        table.remove(loopParts, currentLoopIndex)
        startLoopTween()
        return
    end

    if loopTweenSpeed <= 0 then
        root.CFrame = targetPart.CFrame
        currentLoopIndex = currentLoopIndex + 1
        task.wait(0.05)
        startLoopTween()
    else
        currentTween = TweenService:Create(root, TweenInfo.new(loopTweenSpeed, Enum.EasingStyle.Linear), {CFrame = targetPart.CFrame})
        currentTween.Completed:Connect(function(state)
            if state == Enum.PlaybackState.Completed and loopTweenEnabled then
                currentLoopIndex = currentLoopIndex + 1
                startLoopTween()
            end
        end)
        currentTween:Play()
    end
end

TabPartTP:Input({ Title = "Tween Speed", Value = "1", Callback = function(val) loopTweenSpeed = tonumber(val) or 1 end })
TabPartTP:Toggle({ Title = "start", Callback = function(state)
    loopTweenEnabled = state
    if state then
        currentLoopIndex = 1
        startLoopTween()
    else
        if currentTween then currentTween:Cancel() currentTween = nil end
    end
end })

TabPartTP:Button({ Title = "Set location", Color = Color3.fromHex("#00d4ff"), Callback = function()
    local char = player.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if root then
        local p = Instance.new("Part")
        p.Name = "Loop_Part_".. (#loopParts + 1)
        p.Size = Vector3.new(4, 1, 4)
        p.CFrame = root.CFrame
        p.Anchored = true
        p.CanCollide = false
        p.Transparency = 0
        p.Material = Enum.Material.Neon
        p.Color = Color3.fromRGB(0, 212, 255)
        p.Parent = workspace
        table.insert(loopParts, p)
    end
end })

TabPartTP:Button({ Title = "Reset all locations", Color = Color3.fromHex("#ff3030"), Callback = function()
    loopTweenEnabled = false
    if currentTween then currentTween:Cancel() currentTween = nil end
    for _, p in pairs(loopParts) do if p then p:Destroy() end end
    loopParts = {}
    currentLoopIndex = 1
end })

UserInputService.JumpRequest:Connect(function()
    if infJumpEnabled then
        local char = player.Character
        local humanoid = char and char:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

RunService.Stepped:Connect(function()
    local char = player.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    local humanoid = char:FindFirstChildOfClass("Humanoid")

    if noclipEnabled and root then
        for _, part in pairs(char:GetDescendants()) do if part:IsA("BasePart") then part.CanCollide = false end end
    end

    if viewEnabled and followPart then
        local target = Players:FindFirstChild(selectedTargetName)
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            followPart.CFrame = target.Character.HumanoidRootPart.CFrame
        end
    end

    if humanoid then
        humanoid.WalkSpeed = speedEnabled and walkSpeedPower or 16
        humanoid.JumpPower = jumpEnabled and jumpPower or 50
    end

    if flyEnabled and humanoid and bVelocity and bGyro then
        humanoid.PlatformStand = true
        local moveDir = Vector3.new(0,0,0)
        if humanoid.MoveDirection.Magnitude > 0 then
            local rel = camera.CFrame:VectorToObjectSpace(humanoid.MoveDirection)
            moveDir = (camera.CFrame.LookVector * -rel.Z) + (camera.CFrame.RightVector * rel.X)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir += Vector3.new(0,1,0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveDir -= Vector3.new(0,1,0) end
        bVelocity.Velocity = moveDir.Magnitude > 0 and moveDir.Unit * speed or Vector3.new(0,0,0)
        bGyro.CFrame = CFrame.lookAt(root.Position, root.Position + camera.CFrame.LookVector)
    end
end)

Window:Divider()

local Tab4 = Window:Tab({
    Title = "setting",
    Icon = "settings", -- optional
    Locked = false,
})

local Button = Tab4:Button({
    Title = "refresh admin panel",
    Color = Color3.fromHex("#ff3030"),
    Justify = "Center",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/SCRIPTHUB-dev-god/king-icarus/refs/heads/script/main/admin.lua" ,true))()
        Window:Destroy()
    end
})

local TabPlayer = Section1:Tab({ Title = "Player", Icon = "user" })

-- State
local antiVoidEnabled = false
local lastSafeCFrame = nil
local autoVoidOffset = 50

local antiKnockbackEnabled = false
local knockbackConn = nil

local customGui = nil
local followerPart = nil
local targetY = 0
local showGuiActive = false

local holdUp = false
local holdDown = false
local moveSpeed = 25

-- Anti Void
TabPlayer:Toggle({
    Title = "Anti Void",
    Callback = function(state)
        antiVoidEnabled = state
    end
})

-- Anti Knockback
TabPlayer:Toggle({
    Title = "Anti Knockback",
    Callback = function(state)
        antiKnockbackEnabled = state
        local char = player.Character
        if not char then return end
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        local root = char:FindFirstChild("HumanoidRootPart")
        if not humanoid or not root then return end

        if state then
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
            humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
            if knockbackConn then knockbackConn:Disconnect() end
            knockbackConn = root.ChildAdded:Connect(function(child)
                if antiKnockbackEnabled and (child:IsA("BodyVelocity") or child:IsA("BodyGyro") or child:IsA("BodyForce") or child:IsA("VectorForce")) then
                    task.defer(function()
                        if child and child.Parent then child:Destroy() end
                    end)
                end
            end)
        else
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
            humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
            if knockbackConn then knockbackConn:Disconnect() knockbackConn = nil end
        end
    end
})

TabPlayer:Divider()

-- Show GUI
TabPlayer:Toggle({
    Title = "Show GUI",
    Callback = function(state)
        showGuiActive = state
        if state then
            local char = player.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            local startY = root and (root.Position.Y - 3.5) or 50
            targetY = startY

            if followerPart then followerPart:Destroy() end
            followerPart = Instance.new("Part")
            followerPart.Name = "FollowerPart"
            followerPart.Size = Vector3.new(6,1,6)
            followerPart.Anchored = true
            followerPart.CanCollide = true
            followerPart.Material = Enum.Material.Neon
            followerPart.Color = Color3.fromRGB(0,212,255)
            followerPart.Transparency = 0.2
            followerPart.TopSurface = Enum.SurfaceType.Smooth
            followerPart.BottomSurface = Enum.SurfaceType.Smooth
            if root then
                followerPart.CFrame = CFrame.new(root.Position.X, startY, root.Position.Z)
            end
            followerPart.Parent = workspace

            if customGui then customGui:Destroy() end
            customGui = Instance.new("ScreenGui")
            customGui.Name = "IcarusPlayerGUI"
            customGui.ResetOnSpawn = false
            customGui.Parent = playerGui

            local shadow = Instance.new("Frame")
            shadow.Name = "Shadow"
            shadow.Size = UDim2.fromOffset(140, 170)
            shadow.Position = UDim2.fromOffset(24, 24)
            shadow.BackgroundColor3 = Color3.fromRGB(0,0,0)
            shadow.BackgroundTransparency = 0.7
            shadow.BorderSizePixel = 0
            shadow.ZIndex = 0
            shadow.Parent = customGui

            local shadowCorner = Instance.new("UICorner")
            shadowCorner.CornerRadius = UDim.new(0,12)
            shadowCorner.Parent = shadow

            local frame = Instance.new("Frame")
            frame.Name = "Main"
            frame.Size = UDim2.fromOffset(140, 170)
            frame.Position = UDim2.fromOffset(20, 20)
            frame.BackgroundColor3 = Color3.fromHex("#0a192f")
            frame.BorderSizePixel = 0
            frame.Active = true
            frame.Parent = customGui

            local frameCorner = Instance.new("UICorner")
            frameCorner.CornerRadius = UDim.new(0,12)
            frameCorner.Parent = frame

            local stroke = Instance.new("UIStroke")
            stroke.Color = Color3.fromHex("#38bdf8")
            stroke.Thickness = 1.2
            stroke.Transparency = 0.3
            stroke.Parent = frame

            local gradient = Instance.new("UIGradient")
            gradient.Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0, Color3.fromHex("#0a192f")),
                ColorSequenceKeypoint.new(1, Color3.fromHex("#1e293b"))
            }
            gradient.Rotation = 90
            gradient.Parent = frame

            local title = Instance.new("TextLabel")
            title.Size = UDim2.new(1, -16, 0, 24)
            title.Position = UDim2.fromOffset(8, 8)
            title.BackgroundTransparency = 1
            title.Text = "Platform Control"
            title.TextColor3 = Color3.fromHex("#f0f9ff")
            title.TextSize = 15
            title.Font = Enum.Font.GothamBold
            title.TextXAlignment = Enum.TextXAlignment.Left
            title.Parent = frame

            local yLabel = Instance.new("TextLabel")
            yLabel.Name = "YLabel"
            yLabel.Size = UDim2.new(1, -16, 0, 18)
            yLabel.Position = UDim2.fromOffset(8, 30)
            yLabel.BackgroundTransparency = 1
            yLabel.Text = "Y: 0.0"
            yLabel.TextColor3 = Color3.fromHex("#94a3b8")
            yLabel.TextSize = 12
            yLabel.Font = Enum.Font.Gotham
            yLabel.TextXAlignment = Enum.TextXAlignment.Left
            yLabel.Parent = frame

            local upBtn = Instance.new("TextButton")
            upBtn.Name = "UpBtn"
            upBtn.Size = UDim2.fromOffset(50,50)
            upBtn.Position = UDim2.fromOffset(15, 55)
            upBtn.BackgroundColor3 = Color3.fromHex("#1d4ed8")
            upBtn.Text = "▲"
            upBtn.TextColor3 = Color3.fromHex("#f0f9ff")
            upBtn.TextScaled = true
            upBtn.Font = Enum.Font.GothamBlack
            upBtn.AutoButtonColor = false
            upBtn.Parent = frame

            local upCorner = Instance.new("UICorner")
            upCorner.CornerRadius = UDim.new(0,10)
            upCorner.Parent = upBtn

            local upStroke = Instance.new("UIStroke")
            upStroke.Color = Color3.fromHex("#38bdf8")
            upStroke.Thickness = 1
            upStroke.Parent = upBtn

            local upGrad = Instance.new("UIGradient")
            upGrad.Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0, Color3.fromHex("#3d87ff")),
                ColorSequenceKeypoint.new(1, Color3.fromHex("#1d4ed8"))
            }
            upGrad.Rotation = 90
            upGrad.Parent = upBtn

            local downBtn = Instance.new("TextButton")
            downBtn.Name = "DownBtn"
            downBtn.Size = UDim2.fromOffset(50,50)
            downBtn.Position = UDim2.fromOffset(75, 55)
            downBtn.BackgroundColor3 = Color3.fromHex("#1d4ed8")
            downBtn.Text = "▼"
            downBtn.TextColor3 = Color3.fromHex("#f0f9ff")
            downBtn.TextScaled = true
            downBtn.Font = Enum.Font.GothamBlack
            downBtn.AutoButtonColor = false
            downBtn.Parent = frame

            local downCorner = Instance.new("UICorner")
            downCorner.CornerRadius = UDim.new(0,10)
            downCorner.Parent = downBtn

            local downStroke = Instance.new("UIStroke")
            downStroke.Color = Color3.fromHex("#38bdf8")
            downStroke.Thickness = 1
            downStroke.Parent = downBtn

            local downGrad = Instance.new("UIGradient")
            downGrad.Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0, Color3.fromHex("#3d87ff")),
local TabPlayer = Section1:Tab({ Title = "Player", Icon = "user" })

-- State
local antiVoidEnabled = false
local lastSafeCFrame = nil
local autoVoidOffset = 50

local antiKnockbackEnabled = false
local knockbackConn = nil

local customGui = nil
local followerPart = nil
local targetY = 0
local showGuiActive = false

local holdUp = false
local holdDown = false
local moveSpeed = 25

-- Anti Void
TabPlayer:Toggle({
    Title = "Anti Void",
    Callback = function(state)
        antiVoidEnabled = state
    end
})

-- Anti Knockback
TabPlayer:Toggle({
    Title = "Anti Knockback",
    Callback = function(state)
        antiKnockbackEnabled = state
        local char = player.Character
        if not char then return end
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        local root = char:FindFirstChild("HumanoidRootPart")
        if not humanoid or not root then return end

        if state then
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
            humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
            if knockbackConn then knockbackConn:Disconnect() end
            knockbackConn = root.ChildAdded:Connect(function(child)
                if antiKnockbackEnabled and (child:IsA("BodyVelocity") or child:IsA("BodyGyro") or child:IsA("BodyForce") or child:IsA("VectorForce")) then
                    task.defer(function()
                        if child and child.Parent then child:Destroy() end
                    end)
                end
            end)
        else
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
            humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
            if knockbackConn then knockbackConn:Disconnect() knockbackConn = nil end
        end
    end
})

TabPlayer:Divider()

-- Show GUI
TabPlayer:Toggle({
    Title = "Show GUI",
    Callback = function(state)
        showGuiActive = state
        if state then
            local char = player.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            local startY = root and (root.Position.Y - 3.5) or 50
            targetY = startY

            if followerPart then followerPart:Destroy() end
            followerPart = Instance.new("Part")
            followerPart.Name = "FollowerPart"
            followerPart.Size = Vector3.new(6,1,6)
            followerPart.Anchored = true
            followerPart.CanCollide = true
            followerPart.Material = Enum.Material.Neon
            followerPart.Color = Color3.fromRGB(0,212,255)
            followerPart.Transparency = 0.2
            followerPart.TopSurface = Enum.SurfaceType.Smooth
            followerPart.BottomSurface = Enum.SurfaceType.Smooth
            if root then
                followerPart.CFrame = CFrame.new(root.Position.X, startY, root.Position.Z)
            end
            followerPart.Parent = workspace

            if customGui then customGui:Destroy() end
            customGui = Instance.new("ScreenGui")
            customGui.Name = "IcarusPlayerGUI"
            customGui.ResetOnSpawn = false
            customGui.Parent = playerGui

            local shadow = Instance.new("Frame")
            shadow.Name = "Shadow"
            shadow.Size = UDim2.fromOffset(110, 130)
            shadow.Position = UDim2.fromOffset(24, 24)
            shadow.BackgroundColor3 = Color3.fromRGB(0,0,0)
            shadow.BackgroundTransparency = 0.7
            shadow.BorderSizePixel = 0
            shadow.ZIndex = 0
            shadow.Parent = customGui

            local shadowCorner = Instance.new("UICorner")
            shadowCorner.CornerRadius = UDim.new(0,10)
            shadowCorner.Parent = shadow

            local frame = Instance.new("Frame")
            frame.Name = "Main"
            frame.Size = UDim2.fromOffset(110, 130)
            frame.Position = UDim2.fromOffset(20, 20)
            frame.BackgroundColor3 = Color3.fromHex("#0a192f")
            frame.BorderSizePixel = 0
            frame.Active = true
            frame.Parent = customGui

            local frameCorner = Instance.new("UICorner")
            frameCorner.CornerRadius = UDim.new(0,10)
            frameCorner.Parent = frame

            local stroke = Instance.new("UIStroke")
            stroke.Color = Color3.fromHex("#38bdf8")
            stroke.Thickness = 1
            stroke.Transparency = 0.3
            stroke.Parent = frame

            local gradient = Instance.new("UIGradient")
            gradient.Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0, Color3.fromHex("#0a192f")),
                ColorSequenceKeypoint.new(1, Color3.fromHex("#1e293b"))
            }
            gradient.Rotation = 90
            gradient.Parent = frame

            local title = Instance.new("TextLabel")
            title.Size = UDim2.new(1, -12, 0, 20)
            title.Position = UDim2.fromOffset(6, 6)
            title.BackgroundTransparency = 1
            title.Text = "Platform"
            title.TextColor3 = Color3.fromHex("#f0f9ff")
            title.TextSize = 13
            title.Font = Enum.Font.GothamBold
            title.TextXAlignment = Enum.TextXAlignment.Left
            title.Parent = frame

            local yLabel = Instance.new("TextLabel")
            yLabel.Name = "YLabel"
            yLabel.Size = UDim2.new(1, -12, 0, 14)
            yLabel.Position = UDim2.fromOffset(6, 24)
            yLabel.BackgroundTransparency = 1
            yLabel.Text = "Y: 0.0"
            yLabel.TextColor3 = Color3.fromHex("#94a3b8")
            yLabel.TextSize = 11
            yLabel.Font = Enum.Font.Gotham
            yLabel.TextXAlignment = Enum.TextXAlignment.Left
            yLabel.Parent = frame

            local upBtn = Instance.new("TextButton")
            upBtn.Name = "UpBtn"
            upBtn.Size = UDim2.fromOffset(40,40)
            upBtn.Position = UDim2.fromOffset(12, 42)
            upBtn.BackgroundColor3 = Color3.fromHex("#1d4ed8")
            upBtn.Text = "▲"
            upBtn.TextColor3 = Color3.fromHex("#f0f9ff")
            upBtn.TextScaled = true
            upBtn.Font = Enum.Font.GothamBlack
            upBtn.AutoButtonColor = false
            upBtn.Parent = frame

            local upCorner = Instance.new("UICorner")
            upCorner.CornerRadius = UDim.new(0,8)
            upCorner.Parent = upBtn

            local upStroke = Instance.new("UIStroke")
            upStroke.Color = Color3.fromHex("#38bdf8")
            upStroke.Thickness = 1
            upStroke.Parent = upBtn

            local upGrad = Instance.new("UIGradient")
            upGrad.Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0, Color3.fromHex("#3d87ff")),
                ColorSequenceKeypoint.new(1, Color3.fromHex("#1d4ed8"))
            }
            upGrad.Rotation = 90
            upGrad.Parent = upBtn

            local downBtn = Instance.new("TextButton")
            downBtn.Name = "DownBtn"
            downBtn.Size = UDim2.fromOffset(40,40)
            downBtn.Position = UDim2.fromOffset(58, 42)
            downBtn.BackgroundColor3 = Color3.fromHex("#1d4ed8")
            downBtn.Text = "▼"
            downBtn.TextColor3 = Color3.fromHex("#f0f9ff")
            downBtn.TextScaled = true
            downBtn.Font = Enum.Font.GothamBlack
            downBtn.AutoButtonColor = false
            downBtn.Parent = frame

            local downCorner = Instance.new("UICorner")
            downCorner.CornerRadius = UDim.new(0,8)
            downCorner.Parent = downBtn

            local downStroke = Instance.new("UIStroke")
            downStroke.Color = Color3.fromHex("#38bdf8")
            downStroke.Thickness = 1
            downStroke.Parent = downBtn

            local downGrad = Instance.new("UIGradient")
            downGrad.Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0, Color3.fromHex("#3d87ff")),
                ColorSequenceKeypoint.new(1, Color3.fromHex("#1d4ed8"))
            }
            downGrad.Rotation = 90
            downGrad.Parent = downBtn

            local resetBtn = Instance.new("TextButton")
            resetBtn.Name = "ResetBtn"
            resetBtn.Size = UDim2.new(1, -24, 0, 24)
            resetBtn.Position = UDim2.fromOffset(12, 90)
            resetBtn.BackgroundColor3 = Color3.fromHex("#0f172a")
            resetBtn.Text = "Reset"
            resetBtn.TextColor3 = Color3.fromHex("#f0f9ff")
            resetBtn.TextSize = 12
            resetBtn.Font = Enum.Font.GothamSemibold
            resetBtn.AutoButtonColor = true
            resetBtn.Parent = frame

            local resetCorner = Instance.new("UICorner")
            resetCorner.CornerRadius = UDim.new(0,6)
            resetCorner.Parent = resetBtn

            local resetStroke = Instance.new("UIStroke")
            resetStroke.Color = Color3.fromHex("#1e293b")
            resetStroke.Parent = resetBtn

            local dragging = false
            local dragStart, startPos
            frame.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = true
                    dragStart = input.Position
                    startPos = frame.Position
                    input.Changed:Connect(function()
                        if input.UserInputState == Enum.UserInputState.End then
                            dragging = false
                        end
                    end)
                end
            end)
            frame.InputChanged:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                    if dragging then
                        local delta = input.Position - dragStart
                        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
                        shadow.Position = frame.Position + UDim2.fromOffset(4,4)
                    end
                end
            end)

            upBtn.MouseButton1Down:Connect(function() holdUp = true end)
            upBtn.MouseButton1Up:Connect(function() holdUp = false end)
            upBtn.MouseLeave:Connect(function() holdUp = false end)

            downBtn.MouseButton1Down:Connect(function() holdDown = true end)
            downBtn.MouseButton1Up:Connect(function() holdDown = false end)
            downBtn.MouseLeave:Connect(function() holdDown = false end)

            resetBtn.MouseButton1Click:Connect(function()
                local r = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                if r then targetY = r.Position.Y - 3.5 end
            end)
        else
            holdUp = false
            holdDown = false
            if customGui then customGui:Destroy() customGui = nil end
            if followerPart then followerPart:Destroy() followerPart = nil end
        end
    end
})

-- Loop logic Tab Player
RunService.Stepped:Connect(function(_, dt)
    local char = player.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not root or not humanoid then return end

    local voidHeight = workspace.FallenPartsDestroyHeight + autoVoidOffset

    if root.Position.Y > voidHeight + 10 then
        if humanoid.FloorMaterial ~= Enum.Material.Air then
            lastSafeCFrame = root.CFrame
        end
    end

    if antiVoidEnabled and root.Position.Y < voidHeight then
        if lastSafeCFrame then
            root.CFrame = lastSafeCFrame + Vector3.new(0,3,0)
        else
            root.CFrame = CFrame.new(root.Position.X, voidHeight + 100, root.Position.Z)
        end
        root.AssemblyLinearVelocity = Vector3.zero
    end

    if antiKnockbackEnabled then
        if root.AssemblyLinearVelocity.Magnitude > 100 then
            root.AssemblyLinearVelocity = Vector3.new(
                root.AssemblyLinearVelocity.X * 0.2,
                root.AssemblyLinearVelocity.Y,
                root.AssemblyLinearVelocity.Z * 0.2
            )
        end
    end

    if showGuiActive and followerPart then
        if holdUp then targetY += moveSpeed * dt end
        if holdDown then targetY -= moveSpeed * dt end

        local targetPos = Vector3.new(root.Position.X, targetY, root.Position.Z)
        followerPart.CFrame = CFrame.new(targetPos)

        if customGui and customGui.Parent then
            local main = customGui:FindFirstChild("Main")
            if main then
                local yLabel = main:FindFirstChild("YLabel")
                if yLabel then
                    yLabel.Text = string.format("Y: %.1f", targetY)
                end
            end
        end
    end
end)
