local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local VirtualUser = game:GetService("VirtualUser")
local TextService = game:GetService("TextService")

local player = Players.LocalPlayer
local userId = player.UserId
local thumbType = Enum.ThumbnailType.HeadShot
local thumbSize = Enum.ThumbnailSize.Size420x420
local content = Players:GetUserThumbnailAsync(userId, thumbType, thumbSize)

local gui = Instance.new("ScreenGui")
gui.Name = "TerminalPremiumUI"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = game:GetService("RunService"):IsStudio() and player:WaitForChild("PlayerGui") or CoreGui

local topbarBtn = Instance.new("ImageButton")
topbarBtn.Size = UDim2.new(0, 42, 0, 42)
topbarBtn.Position = UDim2.new(1, -50, 0, 20)
topbarBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
topbarBtn.BorderSizePixel = 0
topbarBtn.Parent = gui

local topbarCorner = Instance.new("UICorner")
topbarCorner.CornerRadius = UDim.new(1, 0)
topbarCorner.Parent = topbarBtn

local topbarStroke = Instance.new("UIStroke")
topbarStroke.Color = Color3.fromRGB(0, 229, 255)
topbarStroke.Thickness = 1.5
topbarStroke.Parent = topbarBtn

local terminalIcon = Instance.new("ImageLabel")
terminalIcon.Size = UDim2.new(0, 24, 0, 24)
terminalIcon.Position = UDim2.new(0.5, -12, 0.5, -12)
terminalIcon.BackgroundTransparency = 1
terminalIcon.Image = "rbxassetid://10734982144"
terminalIcon.ImageColor3 = Color3.fromRGB(0, 229, 255)
terminalIcon.Parent = topbarBtn

local mainGui = Instance.new("Frame")
mainGui.Size = UDim2.new(0, 380, 0, 260)
mainGui.Position = UDim2.new(0, -700, 0.5, -100)
mainGui.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
mainGui.BorderSizePixel = 0
mainGui.Parent = gui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = mainGui

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(0, 229, 255)
mainStroke.Thickness = 1
mainStroke.Parent = mainGui

local mainGlow = Instance.new("UIStroke")
mainGlow.Color = Color3.fromRGB(0, 229, 255)
mainGlow.Thickness = 1
mainGlow.Transparency = 0.6
mainGlow.Parent = mainGui

local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 40)
header.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
header.BorderSizePixel = 0
header.Parent = mainGui

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 12)
headerCorner.Parent = header

local headerHide = Instance.new("Frame")
headerHide.Size = UDim2.new(1, 0, 0, 10)
headerHide.Position = UDim2.new(0, 0, 1, -10)
headerHide.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
headerHide.BorderSizePixel = 0
headerHide.Parent = header

local brandName = Instance.new("TextLabel")
brandName.Size = UDim2.new(0, 160, 1, 0)
brandName.Position = UDim2.new(0, 12, 0, 0)
brandName.BackgroundTransparency = 1
brandName.Text = "ICARUS Executor Script"
brandName.TextColor3 = Color3.fromRGB(0, 229, 255)
brandName.Font = Enum.Font.GothamBold
brandName.TextSize = 14
brandName.TextXAlignment = Enum.TextXAlignment.Left
brandName.Parent = header

local playerLogo = Instance.new("ImageLabel")
playerLogo.Size = UDim2.new(0, 26, 0, 26)
playerLogo.Position = UDim2.new(1, -35, 0.5, -13)
playerLogo.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
playerLogo.Image = content
playerLogo.Parent = header

local logoCorner = Instance.new("UICorner")
logoCorner.CornerRadius = UDim.new(1, 0)
logoCorner.Parent = playerLogo

local logoStroke = Instance.new("UIStroke")
logoStroke.Color = Color3.fromRGB(0, 229, 255)
logoStroke.Thickness = 1
logoStroke.Parent = playerLogo

local playerName = Instance.new("TextLabel")
playerName.Size = UDim2.new(0, 120, 1, 0)
playerName.Position = UDim2.new(1, -165, 0, 0)
playerName.BackgroundTransparency = 1
playerName.Text = player.DisplayName
playerName.TextColor3 = Color3.fromRGB(255, 255, 255)
playerName.Font = Enum.Font.GothamSemibold
playerName.TextSize = 11
playerName.TextXAlignment = Enum.TextXAlignment.Right
playerName.Parent = header

local categoryContainer = Instance.new("Frame")
categoryContainer.Size = UDim2.new(0, 160, 0, 28)
categoryContainer.Position = UDim2.new(1, -172, 0, 45)
categoryContainer.BackgroundTransparency = 1
categoryContainer.Parent = mainGui

local categoryLayout = Instance.new("UIListLayout")
categoryLayout.FillDirection = Enum.FillDirection.Horizontal
categoryLayout.SortOrder = Enum.SortOrder.LayoutOrder
categoryLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
categoryLayout.Padding = UDim.new(0, 6)
categoryLayout.Parent = categoryContainer

local function createCategoryBtn(text, order)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 75, 1, 0)
    btn.BackgroundColor3 = Color3.fromRGB(16, 16, 20)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 11
    btn.LayoutOrder = order
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(30, 30, 35)
    stroke.Thickness = 1
    stroke.Parent = btn
    
    btn.Parent = categoryContainer
    return btn
end

local catEditorBtn = createCategoryBtn("Editor", 1)
local catSettingBtn = createCategoryBtn("Setting", 2)

local editorPage = Instance.new("Frame")
editorPage.Size = UDim2.new(1, 0, 1, -80)
editorPage.Position = UDim2.new(0, 0, 0, 80)
editorPage.BackgroundTransparency = 1
editorPage.Parent = mainGui

local settingPage = Instance.new("ScrollingFrame")
settingPage.Size = UDim2.new(1, -24, 1, -90)
settingPage.Position = UDim2.new(0, 12, 0, 80)
settingPage.BackgroundTransparency = 1
settingPage.ScrollBarThickness = 2
settingPage.ScrollBarImageColor3 = Color3.fromRGB(0, 229, 255)
settingPage.CanvasSize = UDim2.new(0, 0, 0, 0)
settingPage.Visible = false
settingPage.Parent = mainGui

local settingLayout = Instance.new("UIListLayout")
settingLayout.SortOrder = Enum.SortOrder.LayoutOrder
settingLayout.Padding = UDim.new(0, 8)
settingLayout.Parent = settingPage

local tabContainer = Instance.new("ScrollingFrame")
tabContainer.Size = UDim2.new(1, -210, 0, 26)
tabContainer.Position = UDim2.new(0, 12, 0, -35)
tabContainer.BackgroundTransparency = 1
tabContainer.ScrollBarThickness = 0
tabContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
tabContainer.Parent = editorPage

local tabLayout = Instance.new("UIListLayout")
tabLayout.FillDirection = Enum.FillDirection.Horizontal
tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
tabLayout.Padding = UDim.new(0, 6)
tabLayout.Parent = tabContainer

local addTabBtn = Instance.new("TextButton")
addTabBtn.Size = UDim2.new(0, 26, 0, 26)
addTabBtn.Position = UDim2.new(1, -202, 0, -35)
addTabBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
addTabBtn.Text = "+"
addTabBtn.TextColor3 = Color3.fromRGB(0, 229, 255)
addTabBtn.Font = Enum.Font.GothamBold
addTabBtn.TextSize = 15
addTabBtn.Parent = editorPage

local addTabCorner = Instance.new("UICorner")
addTabCorner.CornerRadius = UDim.new(0, 6)
addTabCorner.Parent = addTabBtn

local addTabStroke = Instance.new("UIStroke")
addTabStroke.Color = Color3.fromRGB(40, 40, 45)
addTabStroke.Thickness = 1
addTabStroke.Parent = addTabBtn

local editorContainer = Instance.new("Frame")
editorContainer.Size = UDim2.new(1, -24, 1, -45)
editorContainer.Position = UDim2.new(0, 12, 0, 5)
editorContainer.BackgroundTransparency = 1
editorContainer.Parent = editorPage

local buttonsContainer = Instance.new("Frame")
buttonsContainer.Size = UDim2.new(1, -24, 0, 28)
buttonsContainer.Position = UDim2.new(0, 12, 1, -34)
buttonsContainer.BackgroundTransparency = 1
buttonsContainer.Parent = editorPage

local btnLayout = Instance.new("UIListLayout")
btnLayout.FillDirection = Enum.FillDirection.Horizontal
btnLayout.SortOrder = Enum.SortOrder.LayoutOrder
btnLayout.Padding = UDim.new(0, 5)
btnLayout.Parent = buttonsContainer

local saveGui = Instance.new("Frame")
saveGui.Size = UDim2.new(0, 180, 0, 260)
saveGui.Position = UDim2.new(1, 40, 0.5, -100)
saveGui.BackgroundColor3 = Color3.fromRGB(12, 12, 15)
saveGui.BorderSizePixel = 0
saveGui.Parent = gui

local saveCorner = Instance.new("UICorner")
saveCorner.CornerRadius = UDim.new(0, 12)
saveCorner.Parent = saveGui

local saveStroke = Instance.new("UIStroke")
saveStroke.Color = Color3.fromRGB(0, 229, 255)
saveStroke.Thickness = 1
saveStroke.Parent = saveGui

local saveGlow = Instance.new("UIStroke")
saveGlow.Color = Color3.fromRGB(0, 229, 255)
saveGlow.Thickness = 1
saveGlow.Transparency = 0.6
saveGlow.Parent = saveGui

local saveHeader = Instance.new("TextLabel")
saveHeader.Size = UDim2.new(1, 0, 0, 40)
saveHeader.Position = UDim2.new(0, 0, 0, 0)
saveHeader.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
saveHeader.BorderSizePixel = 0
saveHeader.Text = "local Script"
saveHeader.TextColor3 = Color3.fromRGB(255, 255, 255)
saveHeader.Font = Enum.Font.GothamBold
saveHeader.TextSize = 12
saveHeader.Parent = saveGui

local saveHeaderCorner = Instance.new("UICorner")
saveHeaderCorner.CornerRadius = UDim.new(0, 12)
saveHeaderCorner.Parent = saveHeader

local saveHeaderHide = Instance.new("Frame")
saveHeaderHide.Size = UDim2.new(1, 0, 0, 10)
saveHeaderHide.Position = UDim2.new(0, 0, 1, -10)
saveHeaderHide.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
saveHeaderHide.BorderSizePixel = 0
saveHeaderHide.Parent = saveHeader

local saveList = Instance.new("ScrollingFrame")
saveList.Size = UDim2.new(1, -14, 1, -50)
saveList.Position = UDim2.new(0, 7, 0, 45)
saveList.BackgroundTransparency = 1
saveList.ScrollBarThickness = 2
saveList.ScrollBarImageColor3 = Color3.fromRGB(0, 229, 255)
saveList.CanvasSize = UDim2.new(0, 0, 0, 0)
saveList.Parent = saveGui

local saveListLayout = Instance.new("UIListLayout")
saveListLayout.SortOrder = Enum.SortOrder.LayoutOrder
saveListLayout.Padding = UDim.new(0, 6)
saveListLayout.Parent = saveList

local saveDialog = Instance.new("Frame")
saveDialog.Size = UDim2.new(0, 240, 0, 130)
saveDialog.Position = UDim2.new(0.5, -120, 0.5, -65)
saveDialog.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
saveDialog.BorderSizePixel = 0
saveDialog.Visible = false
saveDialog.ZIndex = 10
saveDialog.Parent = gui

local dialogCorner = Instance.new("UICorner")
dialogCorner.CornerRadius = UDim.new(0, 10)
dialogCorner.Parent = saveDialog

local dialogStroke = Instance.new("UIStroke")
dialogStroke.Color = Color3.fromRGB(0, 229, 255)
dialogStroke.Thickness = 1.5
dialogStroke.Parent = saveDialog

local dialogTitle = Instance.new("TextLabel")
dialogTitle.Size = UDim2.new(1, 0, 0, 32)
dialogTitle.BackgroundTransparency = 1
dialogTitle.Text = "Save Script As"
dialogTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
dialogTitle.Font = Enum.Font.GothamBold
dialogTitle.TextSize = 12
dialogTitle.ZIndex = 10
dialogTitle.Parent = saveDialog

local dialogInput = Instance.new("TextBox")
dialogInput.Size = UDim2.new(1, -20, 0, 30)
dialogInput.Position = UDim2.new(0, 10, 0, 36)
dialogInput.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
dialogInput.Text = ""
dialogInput.PlaceholderText = "Enter script name..."
dialogInput.TextColor3 = Color3.fromRGB(255, 255, 255)
dialogInput.PlaceholderColor3 = Color3.fromRGB(100, 100, 110)
dialogInput.Font = Enum.Font.Gotham
dialogInput.TextSize = 11
dialogInput.ClearTextOnFocus = true
dialogInput.ZIndex = 10
dialogInput.Parent = saveDialog

local dialogInputCorner = Instance.new("UICorner")
dialogInputCorner.CornerRadius = UDim.new(0, 6)
dialogInputCorner.Parent = dialogInput

local dialogInputStroke = Instance.new("UIStroke")
dialogInputStroke.Color = Color3.fromRGB(40, 40, 45)
dialogInputStroke.Thickness = 1
dialogInputStroke.Parent = dialogInput

local dialogSaveBtn = Instance.new("TextButton")
dialogSaveBtn.Size = UDim2.new(0, 100, 0, 28)
dialogSaveBtn.Position = UDim2.new(0, 10, 0, 85)
dialogSaveBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 200)
dialogSaveBtn.Text = "Save"
dialogSaveBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
dialogSaveBtn.Font = Enum.Font.GothamBold
dialogSaveBtn.TextSize = 11
dialogSaveBtn.ZIndex = 10
dialogSaveBtn.Parent = saveDialog

local dialogSaveCorner = Instance.new("UICorner")
dialogSaveCorner.CornerRadius = UDim.new(0, 6)
dialogSaveCorner.Parent = dialogSaveBtn

local dialogCancelBtn = Instance.new("TextButton")
dialogCancelBtn.Size = UDim2.new(0, 100, 0, 28)
dialogCancelBtn.Position = UDim2.new(1, -110, 0, 85)
dialogCancelBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
dialogCancelBtn.Text = "Cancel"
dialogCancelBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
dialogCancelBtn.Font = Enum.Font.GothamBold
dialogCancelBtn.TextSize = 11
dialogCancelBtn.ZIndex = 10
dialogCancelBtn.Parent = saveDialog

local dialogCancelCorner = Instance.new("UICorner")
dialogCancelCorner.CornerRadius = UDim.new(0, 6)
dialogCancelCorner.Parent = dialogCancelBtn

local function createBottomButton(text, sizeX, order)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, sizeX, 1, 0)
    btn.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 10
    btn.LayoutOrder = order
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(35, 35, 40)
    stroke.Thickness = 1
    stroke.Parent = btn
    
    btn.Parent = buttonsContainer
    return btn
end

local btnPaste = createBottomButton("Paste", 48, 1)
local btnExecClip = createBottomButton("Exec Clip", 64, 2)
local btnClear = createBottomButton("Clear", 48, 3)
local btnExecute = createBottomButton("Execute", 56, 4)
local btnSave = createBottomButton("Save", 48, 5)

local currentTheme = "Neon" 

local function applyTheme(themeName)
    currentTheme = themeName
    if themeName == "Neon" then
        mainStroke.Color = Color3.fromRGB(0, 229, 255)
        saveStroke.Color = Color3.fromRGB(0, 229, 255)
        topbarStroke.Color = Color3.fromRGB(0, 229, 255)
        terminalIcon.ImageColor3 = Color3.fromRGB(0, 229, 255)
        brandName.TextColor3 = Color3.fromRGB(0, 229, 255)
        logoStroke.Color = Color3.fromRGB(0, 229, 255)
        addTabBtn.TextColor3 = Color3.fromRGB(0, 229, 255)
        btnExecute.TextColor3 = Color3.fromRGB(0, 229, 255)
        btnExecute.UIStroke.Color = Color3.fromRGB(0, 150, 170)
        btnSave.TextColor3 = Color3.fromRGB(0, 229, 255)
        btnSave.UIStroke.Color = Color3.fromRGB(0, 150, 170)
        mainGlow.Color = Color3.fromRGB(0, 229, 255)
        saveGlow.Color = Color3.fromRGB(0, 229, 255)
        mainGlow.Enabled = true
        saveGlow.Enabled = true
        dialogStroke.Color = Color3.fromRGB(0, 229, 255)
    elseif themeName == "Dark" then
        mainStroke.Color = Color3.fromRGB(55, 55, 60)
        saveStroke.Color = Color3.fromRGB(55, 55, 60)
        topbarStroke.Color = Color3.fromRGB(55, 55, 60)
        terminalIcon.ImageColor3 = Color3.fromRGB(200, 200, 200)
        brandName.TextColor3 = Color3.fromRGB(230, 230, 235)
        logoStroke.Color = Color3.fromRGB(55, 55, 60)
        addTabBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
        btnExecute.TextColor3 = Color3.fromRGB(200, 200, 200)
        btnExecute.UIStroke.Color = Color3.fromRGB(55, 55, 60)
        btnSave.TextColor3 = Color3.fromRGB(200, 200, 200)
        btnSave.UIStroke.Color = Color3.fromRGB(55, 55, 60)
        mainGlow.Enabled = false
        saveGlow.Enabled = false
        dialogStroke.Color = Color3.fromRGB(55, 55, 60)
    elseif themeName == "Golden" then
        mainStroke.Color = Color3.fromRGB(255, 196, 0)
        saveStroke.Color = Color3.fromRGB(255, 196, 0)
        topbarStroke.Color = Color3.fromRGB(255, 196, 0)
        terminalIcon.ImageColor3 = Color3.fromRGB(255, 196, 0)
        brandName.TextColor3 = Color3.fromRGB(255, 196, 0)
        logoStroke.Color = Color3.fromRGB(255, 196, 0)
        addTabBtn.TextColor3 = Color3.fromRGB(255, 196, 0)
        btnExecute.TextColor3 = Color3.fromRGB(255, 196, 0)
        btnExecute.UIStroke.Color = Color3.fromRGB(180, 140, 0)
        btnSave.TextColor3 = Color3.fromRGB(255, 196, 0)
        btnSave.UIStroke.Color = Color3.fromRGB(180, 140, 0)
        mainGlow.Color = Color3.fromRGB(255, 196, 0)
        saveGlow.Color = Color3.fromRGB(255, 196, 0)
        mainGlow.Enabled = true
        saveGlow.Enabled = true
        dialogStroke.Color = Color3.fromRGB(255, 196, 0)
    end
end

local function updateUISize()
    local camera = workspace.CurrentCamera
    if camera then
        local screenSize = camera.ViewportSize
        if screenSize.X >= 1024 then
            mainGui.Size = UDim2.new(0, 550, 0, 380)
            saveGui.Size = UDim2.new(0, 200, 0, 380)
            categoryContainer.Position = UDim2.new(1, -172, 0, 45)
            tabContainer.Size = UDim2.new(1, -210, 0, 26)
            addTabBtn.Position = UDim2.new(1, -202, 0, -35)
            
            btnPaste.Size = UDim2.new(0, 70, 1, 0)
            btnExecClip.Size = UDim2.new(0, 90, 1, 0)
            btnClear.Size = UDim2.new(0, 70, 1, 0)
            btnExecute.Size = UDim2.new(0, 85, 1, 0)
            btnSave.Size = UDim2.new(0, 70, 1, 0)
        else
            mainGui.Size = UDim2.new(0, 380, 0, 260)
            saveGui.Size = UDim2.new(0, 180, 0, 260)
            categoryContainer.Position = UDim2.new(1, -172, 0, 45)
            tabContainer.Size = UDim2.new(1, -210, 0, 26)
            addTabBtn.Position = UDim2.new(1, -202, 0, -35)
            
            btnPaste.Size = UDim2.new(0, 48, 1, 0)
            btnExecClip.Size = UDim2.new(0, 64, 1, 0)
            btnClear.Size = UDim2.new(0, 48, 1, 0)
            btnExecute.Size = UDim2.new(0, 56, 1, 0)
            btnSave.Size = UDim2.new(0, 48, 1, 0)
        end
    end
end
updateUISize()
workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(updateUISize)

local function makeDraggable(element, handle)
    local dragging, dragInput, dragStart, startPos
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = element.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            element.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

makeDraggable(mainGui, header)

local isOpen = false
topbarBtn.MouseButton1Click:Connect(function()
    isOpen = not isOpen
    local mainTarget = isOpen and UDim2.new(0, 10, 0.5, -(mainGui.AbsoluteSize.Y/2) + 30) or UDim2.new(0, -600, 0.5, -(mainGui.AbsoluteSize.Y/2) + 30)
    local saveTarget = isOpen and UDim2.new(1, -(saveGui.AbsoluteSize.X + 10), 0.5, -(saveGui.AbsoluteSize.Y/2) + 30) or UDim2.new(1, 40, 0.5, -(saveGui.AbsoluteSize.Y/2) + 30)
    
    TweenService:Create(mainGui, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = mainTarget}):Play()
    TweenService:Create(saveGui, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = saveTarget}):Play()
end)

local function switchCategory(category)
    if category == "Editor" then
        catEditorBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
        catEditorBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        catSettingBtn.BackgroundColor3 = Color3.fromRGB(16, 16, 20)
        catSettingBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
        editorPage.Visible = true
        settingPage.Visible = false
    elseif category == "Setting" then
        catSettingBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
        catSettingBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        catEditorBtn.BackgroundColor3 = Color3.fromRGB(16, 16, 20)
        catEditorBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
        settingPage.Visible = true
        editorPage.Visible = false
    end
end

catEditorBtn.MouseButton1Click:Connect(function() switchCategory("Editor") end)
catSettingBtn.MouseButton1Click:Connect(function() switchCategory("Setting") end)
switchCategory("Editor")

local antiAfkEnabled = false
local isTransparentGUI = false
local globalAutoExecEnabled = true 
local transparencyValue = 0.27     
local syntaxHighlightEnabled = true
local lastInteractionTime = os.time()

local function createSettingToggle(text)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 32)
    frame.BackgroundTransparency = 1
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -60, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(230, 230, 235)
    label.Font = Enum.Font.GothamSemibold
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.new(0, 50, 0, 22)
    toggle.Position = UDim2.new(1, -50, 0.5, -11)
    toggle.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    toggle.Text = "OFF"
    toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggle.Font = Enum.Font.GothamBold
    toggle.TextSize = 10
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 4)
    corner.Parent = toggle
    
    toggle.Parent = frame
    frame.Parent = settingPage
    
    settingPage.CanvasSize = UDim2.new(0, 0, 0, settingLayout.AbsoluteContentSize.Y + 20)
    return toggle
end

local function createSettingInput(text, placeholder, defaultVal)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 32)
    frame.BackgroundTransparency = 1
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -70, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(230, 230, 235)
    label.Font = Enum.Font.GothamSemibold
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local txtBox = Instance.new("TextBox")
    txtBox.Size = UDim2.new(0, 60, 0, 22)
    txtBox.Position = UDim2.new(1, -60, 0.5, -11)
    txtBox.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    txtBox.Text = tostring(defaultVal or "")
    txtBox.PlaceholderText = placeholder
    txtBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    txtBox.Font = Enum.Font.GothamBold
    txtBox.TextSize = 11
    txtBox.ClearTextOnFocus = false
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 4)
    corner.Parent = txtBox
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(45, 45, 50)
    stroke.Thickness = 1
    stroke.Parent = txtBox
    
    txtBox.Parent = frame
    frame.Parent = settingPage
    
    settingPage.CanvasSize = UDim2.new(0, 0, 0, settingLayout.AbsoluteContentSize.Y + 20)
    return txtBox
end

local function createSettingDropdown(text, options, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 32)
    frame.BackgroundTransparency = 1
    frame.ClipsDescendants = false
    frame.Parent = settingPage

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0, 120, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(230, 230, 235)
    label.Font = Enum.Font.GothamSemibold
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local mainButton = Instance.new("TextButton")
    mainButton.Size = UDim2.new(1, -130, 0, 24)
    mainButton.Position = UDim2.new(0, 130, 0.5, -12)
    mainButton.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    mainButton.Text = options[1] or "Select..."
    mainButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    mainButton.Font = Enum.Font.GothamSemibold
    mainButton.TextSize = 11
    mainButton.ZIndex = 5
    mainButton.Parent = frame

    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 4)
    mainCorner.Parent = mainButton

    local mainStroke = Instance.new("UIStroke")
    mainStroke.Color = Color3.fromRGB(45, 45, 50)
    mainStroke.Thickness = 1
    mainStroke.Parent = mainButton

    local listFrame = Instance.new("Frame")
    listFrame.Size = UDim2.new(1, 0, 0, 0)
    listFrame.Position = UDim2.new(0, 0, 1, 2)
    listFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    listFrame.Visible = false
    listFrame.ZIndex = 6
    listFrame.Parent = mainButton

    local listCorner = Instance.new("UICorner")
    listCorner.CornerRadius = UDim.new(0, 4)
    listCorner.Parent = listFrame

    local listStroke = Instance.new("UIStroke")
    listStroke.Color = Color3.fromRGB(45, 45, 50)
    listStroke.Thickness = 1
    listStroke.Parent = listFrame

    local listLayout = Instance.new("UIListLayout")
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Parent = listFrame

    local dropOpen = false
    local function toggleDropdown()
        dropOpen = not dropOpen
        listFrame.Visible = dropOpen
        if dropOpen then
            listFrame.Size = UDim2.new(1, 0, 0, #options * 24)
            frame.ZIndex = 10
        else
            listFrame.Size = UDim2.new(1, 0, 0, 0)
            frame.ZIndex = 1
        end
    end

    mainButton.MouseButton1Click:Connect(toggleDropdown)

    for i, opt in ipairs(options) do
        local optBtn = Instance.new("TextButton")
        optBtn.Size = UDim2.new(1, 0, 0, 24)
        optBtn.BackgroundTransparency = 1
        optBtn.Text = opt
        optBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
        optBtn.Font = Enum.Font.Gotham
        optBtn.TextSize = 11
        optBtn.ZIndex = 7
        optBtn.Parent = listFrame

        optBtn.MouseEnter:Connect(function()
            optBtn.BackgroundTransparency = 0.9
            optBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        end)
        optBtn.MouseLeave:Connect(function()
            optBtn.BackgroundTransparency = 1
        end)

        optBtn.MouseButton1Click:Connect(function()
            mainButton.Text = opt
            toggleDropdown()
            callback(opt)
        end)
    end

    settingPage.CanvasSize = UDim2.new(0, 0, 0, settingLayout.AbsoluteContentSize.Y + 20)
    return mainButton
end

createSettingDropdown("Theme GUI", {"Neon", "Dark", "Golden"}, function(selected)
    applyTheme(selected)
end)

local toggleTransparent = createSettingToggle("Transparent GUI")
local inputTransparency = createSettingInput("Transparency Alpha", "0 - 1", transparencyValue)
local toggleAutoExec = createSettingToggle("Global Auto Execute")
local toggleAntiAfk = createSettingToggle("Anti AFK System")
local toggleSyntax = createSettingToggle("Lua Syntax Highlight")

toggleSyntax.BackgroundColor3 = Color3.fromRGB(0, 150, 100)
toggleSyntax.Text = "ON"

toggleAutoExec.BackgroundColor3 = Color3.fromRGB(0, 150, 100)
toggleAutoExec.Text = "ON"

local activeTabs = {}
local activeEditors = {}
local activeWrappers = {}
local currentActiveTab = nil
local savedScriptsData = {}

local function triggerAllSyntaxUpdate()
    for _, editor in pairs(activeEditors) do
        if editor and editor:FindFirstChild("SyntaxLabel") then
            editor.SyntaxLabel.Visible = syntaxHighlightEnabled
            if syntaxHighlightEnabled then
                editor.TextColor3 = Color3.fromRGB(230, 230, 235, 1) 
                editor.Text = editor.Text
            else
                editor.TextColor3 = Color3.fromRGB(230, 230, 235) 
                editor.SyntaxLabel.Text = ""
            end
        end
    end
end

toggleSyntax.MouseButton1Click:Connect(function()
    syntaxHighlightEnabled = not syntaxHighlightEnabled
    toggleSyntax.BackgroundColor3 = syntaxHighlightEnabled and Color3.fromRGB(0, 150, 100) or Color3.fromRGB(40, 40, 45)
    toggleSyntax.Text = syntaxHighlightEnabled and "ON" or "OFF"
    triggerAllSyntaxUpdate()
end)

local function updateTransparencyDisplay()
    local alpha = isTransparentGUI and transparencyValue or 0
    mainGui.BackgroundTransparency = alpha
    saveGui.BackgroundTransparency = alpha
    header.BackgroundTransparency = alpha
    saveHeader.BackgroundTransparency = alpha
    headerHide.BackgroundTransparency = alpha
    saveHeaderHide.BackgroundTransparency = alpha
end

toggleTransparent.MouseButton1Click:Connect(function()
    isTransparentGUI = not isTransparentGUI
    toggleTransparent.BackgroundColor3 = isTransparentGUI and Color3.fromRGB(0, 150, 100) or Color3.fromRGB(40, 40, 45)
    toggleTransparent.Text = isTransparentGUI and "ON" or "OFF"
    updateTransparencyDisplay()
end)

inputTransparency.FocusLost:Connect(function()
    local num = tonumber(inputTransparency.Text)
    if num then
        transparencyValue = math.clamp(num, 0, 1)
        inputTransparency.Text = tostring(transparencyValue)
        updateTransparencyDisplay()
    else
        inputTransparency.Text = tostring(transparencyValue)
    end
end)

toggleAutoExec.MouseButton1Click:Connect(function()
    globalAutoExecEnabled = not globalAutoExecEnabled
    toggleAutoExec.BackgroundColor3 = globalAutoExecEnabled and Color3.fromRGB(0, 150, 100) or Color3.fromRGB(40, 40, 45)
    toggleAutoExec.Text = globalAutoExecEnabled and "ON" or "OFF"
end)

toggleAntiAfk.MouseButton1Click:Connect(function()
    antiAfkEnabled = not antiAfkEnabled
    toggleAntiAfk.BackgroundColor3 = antiAfkEnabled and Color3.fromRGB(0, 150, 100) or Color3.fromRGB(40, 40, 45)
    toggleAntiAfk.Text = antiAfkEnabled and "ON" or "OFF"
    if antiAfkEnabled then
        lastInteractionTime = os.time()
    end
end)

UserInputService.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        lastInteractionTime = os.time()
    end
end)

task.spawn(function()
    while task.wait(1) do
        if antiAfkEnabled then
            if (os.time() - lastInteractionTime) >= (19 * 60) then
                lastInteractionTime = os.time()
                pcall(function()
                    VirtualUser:CaptureController()
                    VirtualUser:ClickButton1(Vector2.new(10, 10))
                end)
            end
        end
    end
end)

applyTheme("Neon")

local lua_keywords = {
    ["and"]=true, ["break"]=true, ["do"]=true, ["else"]=true, ["elseif"]=true, ["end"]=true,
    ["false"]=true, ["for"]=true, ["function"]=true, ["if"]=true, ["in"]=true, ["local"]=true,
    ["nil"]=true, ["not"]=true, ["or"]=true, ["repeat"]=true, ["return"]=true, ["then"]=true,
    ["true"]=true, ["until"]=true, ["while"]=true, ["continue"]=true, ["self"]=true
}

local lua_globals = {
    ["game"]=true, ["workspace"]=true, ["script"]=true, ["math"]=true, ["string"]=true,
    ["table"]=true, ["task"]=true, ["wait"]=true, ["spawn"]=true, ["print"]=true,
    ["warn"]=true, ["error"]=true, ["loadstring"]=true, ["pcall"]=true, ["xpcall"]=true,
    ["shared"]=true, ["_G"]=true, ["getgenv"]=true, ["getclipboard"]=true, ["writefile"]=true
}

local function highlight(text)
    text = text:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;")
    
    local lines = string.split(text, "\n")
    for i, line in ipairs(lines) do
        if line:find("%-%-") then
            local code, comment = line:match("(.-)(%-%-.*)")
            if comment then
                lines[i] = code .. '<font color="rgb(100,120,100)">' .. comment .. '</font>'
            end
        end
    end
    text = table.concat(lines, "\n")

    text = text:gsub('("[^"\n]*")', '<font color="rgb(255,190,100)">%1</font>')
    text = text:gsub("('[^'\n]*')", '<font color="rgb(255,190,100)">%1</font>')

    text = text:gsub("(%W)(%d+)(%W)", '%1<font color="rgb(255,120,120)">%2</font>%3')
    text = text:gsub("^(%d+)(%W)", '<font color="rgb(255,120,120)">%1</font>%2')

    text = text:gsub("([%a_][%w_]*)", function(word)
        if lua_keywords[word] then
            return '<font color="rgb(255,60,120)">' .. word .. '</font>'
        elseif lua_globals[word] then
            return '<font color="rgb(0,230,255)">' .. word .. '</font>'
        end
        return word
    end)

    return text
end

local function getNextTabIndex()
    local index = 1
    while activeTabs[index] do
        index = index + 1
    end
    return index
end

local function saveTabsState()
    pcall(function()
        if writefile then
            local state = {}
            for idx, editor in pairs(activeEditors) do
                state[tostring(idx)] = editor.Text
            end
            writefile("ICARUS_tabs_autosave.json", HttpService:JSONEncode(state))
        end
    end)
end

local function writeSavesToFile()
    pcall(function()
        if writefile then
            writefile("ICARUS_scripts_saves.json", HttpService:JSONEncode(savedScriptsData))
        end
    end)
end

local function switchTab(index)
    for idx, wrapper in pairs(activeWrappers) do
        wrapper.Visible = (idx == index)
    end
    for idx, tab in pairs(activeTabs) do
        if idx == index then
            tab.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
            tab.TextColor3 = Color3.fromRGB(255, 255, 255)
        else
            tab.BackgroundColor3 = Color3.fromRGB(16, 16, 20)
            tab.TextColor3 = Color3.fromRGB(200, 200, 200)
        end
    end
    currentActiveTab = index
end

local function createTab(initialText)
    local index = getNextTabIndex()
    
    local tabBtn = Instance.new("TextButton")
    tabBtn.Size = UDim2.new(0, 75, 1, 0)
    tabBtn.BackgroundColor3 = Color3.fromRGB(16, 16, 20)
    tabBtn.Text = "Tab " .. index
    tabBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    tabBtn.Font = Enum.Font.GothamSemibold
    tabBtn.TextSize = 11
    tabBtn.LayoutOrder = index
    tabBtn.Parent = tabContainer

    local tabCorner = Instance.new("UICorner")
    tabCorner.CornerRadius = UDim.new(0, 6)
    tabCorner.Parent = tabBtn

    local tabStroke = Instance.new("UIStroke")
    tabStroke.Color = Color3.fromRGB(30, 30, 35)
    tabStroke.Thickness = 1
    tabStroke.Parent = tabBtn

    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 14, 0, 14)
    closeBtn.Position = UDim2.new(1, -18, 0.5, -7)
    closeBtn.BackgroundTransparency = 1
    closeBtn.Text = "×"
    closeBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 12
    closeBtn.Parent = tabBtn

    local scrollFrame = Instance.new("ScrollingFrame")
    scrollFrame.Size = UDim2.new(1, 0, 1, 0)
    scrollFrame.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
    scrollFrame.BorderSizePixel = 0
    scrollFrame.ScrollBarThickness = 4
    scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(0, 229, 255)
    scrollFrame.ClipsDescendants = true
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    scrollFrame.Visible = false
    scrollFrame.Parent = editorContainer

    local scrollCorner = Instance.new("UICorner")
    scrollCorner.CornerRadius = UDim.new(0, 8)
    scrollCorner.Parent = scrollFrame

    local scrollStroke = Instance.new("UIStroke")
    scrollStroke.Color = Color3.fromRGB(25, 25, 30)
    scrollStroke.Thickness = 1
    scrollStroke.Parent = scrollFrame

    local editor = Instance.new("TextBox")
    editor.Size = UDim2.new(1, 0, 1, 0)
    editor.Position = UDim2.new(0, 0, 0, 0)
    editor.BackgroundTransparency = 1
    editor.Text = initialText or ""
    editor.TextColor3 = syntaxHighlightEnabled and Color3.fromRGB(230, 230, 235, 1) or Color3.fromRGB(230, 230, 235)
    editor.Font = Enum.Font.Code
    editor.TextSize = 11
    editor.TextXAlignment = Enum.TextXAlignment.Left
    editor.TextYAlignment = Enum.TextYAlignment.Top
    editor.ClearTextOnFocus = false
    editor.MultiLine = true
    editor.TextWrapped = false
    editor.Parent = scrollFrame

    local syntaxLabel = Instance.new("TextLabel")
    syntaxLabel.Name = "SyntaxLabel"
    syntaxLabel.Size = UDim2.new(1, 0, 1, 0)
    syntaxLabel.Position = UDim2.new(0, 0, 0, 0)
    syntaxLabel.BackgroundTransparency = 1
    syntaxLabel.Text = ""
    syntaxLabel.TextColor3 = Color3.fromRGB(230, 230, 235)
    syntaxLabel.Font = Enum.Font.Code
    syntaxLabel.TextSize = 11
    syntaxLabel.TextXAlignment = Enum.TextXAlignment.Left
    syntaxLabel.TextYAlignment = Enum.TextYAlignment.Top
    syntaxLabel.RichText = true
    syntaxLabel.Visible = syntaxHighlightEnabled
    syntaxLabel.ZIndex = editor.ZIndex - 1 
    syntaxLabel.Parent = editor

    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, 6)
    padding.PaddingBottom = UDim.new(0, 30)
    padding.PaddingLeft = UDim.new(0, 8)
    padding.PaddingRight = UDim.new(0, 50)
    padding.Parent = editor

    local labelPadding = padding:Clone()
    labelPadding.Parent = syntaxLabel

    local function updateCanvasSize()
        local lines = string.split(editor.Text, "\n")
        local maxWidth = 0
        
        for _, line in ipairs(lines) do
            local processedLine = line == "" and " " or line
            local size = TextService:GetTextSize(processedLine, editor.TextSize, editor.Font, Vector2.new(20000, 20000))
            if size.X > maxWidth then
                maxWidth = size.X
            end
        end
        
        local textHeight = #lines * (editor.TextSize + 3)
        local frameWidth = scrollFrame.AbsoluteSize.X
        local frameHeight = scrollFrame.AbsoluteSize.Y

        local finalWidth = math.max(maxWidth + 80, frameWidth)
        local finalHeight = math.max(textHeight + 50, frameHeight)

        editor.Size = UDim2.new(0, finalWidth, 0, finalHeight)
        syntaxLabel.Size = UDim2.new(0, finalWidth, 0, finalHeight)
        scrollFrame.CanvasSize = UDim2.new(0, finalWidth, 0, finalHeight)
    end

    editor:GetPropertyChangedSignal("Text"):Connect(function()
        saveTabsState()
        updateCanvasSize()
        if syntaxHighlightEnabled then
            editor.TextColor3 = Color3.fromRGB(230, 230, 235, 1) 
            syntaxLabel.Text = highlight(editor.Text)
        else
            editor.TextColor3 = Color3.fromRGB(230, 230, 235)
            syntaxLabel.Text = ""
        end
    end)
    
    scrollFrame:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateCanvasSize)

    activeTabs[index] = tabBtn
    activeEditors[index] = editor
    activeWrappers[index] = scrollFrame

    tabLayout:ApplyLayout()
    tabContainer.CanvasSize = UDim2.new(0, tabLayout.AbsoluteContentSize.X, 0, 0)

    tabBtn.MouseButton1Click:Connect(function()
        switchTab(index)
    end)

    closeBtn.MouseButton1Click:Connect(function()
        tabBtn:Destroy()
        activeWrappers[index]:Destroy()
        activeTabs[index] = nil
        activeEditors[index] = nil
        activeWrappers[index] = nil
        saveTabsState()
        
        if currentActiveTab == index then
            local nextAvailable = nil
            for i = 1, 200 do
                if activeTabs[i] then
                    nextAvailable = i
                    break
                end
            end
            if nextAvailable then
                switchTab(nextAvailable)
            else
                currentActiveTab = nil
            end
        end
        tabLayout:ApplyLayout()
        tabContainer.CanvasSize = UDim2.new(0, tabLayout.AbsoluteContentSize.X, 0, 0)
    end)

    switchTab(index)
    task.defer(function()
        updateCanvasSize()
        if syntaxHighlightEnabled then
            syntaxLabel.Text = highlight(editor.Text)
        end
    end)
end

addTabBtn.MouseButton1Click:Connect(function()
    createTab()
end)

local function renderSaveList()
    for _, item in pairs(saveList:GetChildren()) do
        if item:IsA("Frame") then
            item:Destroy()
        end
    end

    for name, data in pairs(savedScriptsData) do
        local itemFrame = Instance.new("Frame")
        itemFrame.Size = UDim2.new(1, -4, 0, 55)
        itemFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
        itemFrame.BorderSizePixel = 0
        itemFrame.Parent = saveList

        local itemCorner = Instance.new("UICorner")
        itemCorner.CornerRadius = UDim.new(0, 6)
        itemCorner.Parent = itemFrame

        local itemStroke = Instance.new("UIStroke")
        itemStroke.Color = Color3.fromRGB(30, 30, 35)
        itemStroke.Thickness = 1
        itemStroke.Parent = itemFrame

        local nameLabel = Instance.new("TextLabel")
        nameLabel.Size = UDim2.new(1, -50, 0, 18)
        nameLabel.Position = UDim2.new(0, 6, 0, 4)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = name
        nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        nameLabel.Font = Enum.Font.GothamSemibold
        nameLabel.TextSize = 10
        nameLabel.TextXAlignment = Enum.TextXAlignment.Left
        nameLabel.Parent = itemFrame

        local execBtn = Instance.new("TextButton")
        execBtn.Size = UDim2.new(0, 65, 0, 20)
        execBtn.Position = UDim2.new(0, 6, 0, 26)
        execBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
        execBtn.Text = "Execute"
        execBtn.TextColor3 = Color3.fromRGB(0, 229, 255)
        execBtn.Font = Enum.Font.GothamBold
        execBtn.TextSize = 9
        execBtn.Parent = itemFrame

        local execCorner = Instance.new("UICorner")
        execCorner.CornerRadius = UDim.new(0, 4)
        execCorner.Parent = execBtn

        local delBtn = Instance.new("TextButton")
        delBtn.Size = UDim2.new(0, 42, 0, 20)
        delBtn.Position = UDim2.new(0, 76, 0, 26)
        delBtn.BackgroundColor3 = Color3.fromRGB(35, 20, 20)
        delBtn.Text = "Delete"
        delBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
        delBtn.Font = Enum.Font.GothamBold
        delBtn.TextSize = 9
        delBtn.Parent = itemFrame

        local delCorner = Instance.new("UICorner")
        delCorner.CornerRadius = UDim.new(0, 4)
        delCorner.Parent = delBtn

        local autoToggle = Instance.new("TextButton")
        autoToggle.Size = UDim2.new(0, 38, 0, 18)
        autoToggle.Position = UDim2.new(1, -44, 0, 4)
        autoToggle.BackgroundColor3 = data.AutoExec and Color3.fromRGB(0, 150, 100) or Color3.fromRGB(40, 40, 45)
        autoToggle.Text = data.AutoExec and "A-On" or "A-Off"
        autoToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
        autoToggle.Font = Enum.Font.GothamSemibold
        autoToggle.TextSize = 8
        autoToggle.Parent = itemFrame

        local toggleCorner = Instance.new("UICorner")
        toggleCorner.CornerRadius = UDim.new(0, 4)
        toggleCorner.Parent = autoToggle

        execBtn.MouseButton1Click:Connect(function()
            local func = loadstring(data.Source)
            if func then
                task.spawn(func)
            end
        end)

        delBtn.MouseButton1Click:Connect(function()
            savedScriptsData[name] = nil
            writeSavesToFile()
            renderSaveList()
        end)

        autoToggle.MouseButton1Click:Connect(function()
            savedScriptsData[name].AutoExec = not savedScriptsData[name].AutoExec
            writeSavesToFile()
            renderSaveList()
        end)
    end
    saveList.CanvasSize = UDim2.new(0, 0, 0, saveListLayout.AbsoluteContentSize.Y)
end

btnSave.MouseButton1Click:Connect(function()
    if currentActiveTab and activeEditors[currentActiveTab] then
        saveDialog.Visible = true
        dialogInput.Text = ""
        dialogInput:CaptureFocus()
    end
end)

dialogSaveBtn.MouseButton1Click:Connect(function()
    local name = dialogInput.Text
    if name ~= "" and currentActiveTab and activeEditors[currentActiveTab] then
        savedScriptsData[name] = {
            Source = activeEditors[currentActiveTab].Text,
            AutoExec = false
        }
        writeSavesToFile()
        renderSaveList()
        saveDialog.Visible = false
    end
end)

dialogCancelBtn.MouseButton1Click:Connect(function()
    saveDialog.Visible = false
end)

btnExecute.MouseButton1Click:Connect(function()
    if currentActiveTab and activeEditors[currentActiveTab] then
        local func = loadstring(activeEditors[currentActiveTab].Text)
        if func then
            task.spawn(func)
        end
    end
end)

btnPaste.MouseButton1Click:Connect(function()
    if currentActiveTab and activeEditors[currentActiveTab] and getclipboard then
        activeEditors[currentActiveTab].Text = getclipboard()
    end
end)

btnExecClip.MouseButton1Click:Connect(function()
    if getclipboard then
        local func = loadstring(getclipboard())
        if func then
            task.spawn(func)
        end
    end
end)

btnClean = btnClear 
btnClear.MouseButton1Click:Connect(function()
    if currentActiveTab and activeEditors[currentActiveTab] then
        activeEditors[currentActiveTab].Text = ""
    end
end)

pcall(function()
    if readfile and isfile and isfile("ICARUS_scripts_saves.json") then
        savedScriptsData = HttpService:JSONDecode(readfile("ICARUS_scripts_saves.json"))
    end
end)

renderSaveList()

for name, data in pairs(savedScriptsData) do
    if data.AutoExec and globalAutoExecEnabled then
        task.spawn(function()
            local func = loadstring(data.Source)
            if func then
                func()
            end
        end)
    end
end

local hasAutosave = false
pcall(function()
    if readfile and isfile and isfile("ICARUS_tabs_autosave.json") then
        local state = HttpService:JSONDecode(readfile("ICARUS_tabs_autosave.json"))
        local indices = {}
        for k in pairs(state) do
            table.insert(indices, tonumber(k))
        end
        table.sort(indices)
        
        if #indices > 0 then
            hasAutosave = true
            for _, idx in ipairs(indices) do
                createTab(state[tostring(idx)])
            end
        end
    end
end)

if not hasAutosave then
    createTab()
end

loadstring(game:HttpGet("https://raw.githubusercontent.com/SCRIPTHUB-dev-god/anti-system/refs/heads/main/anti-staff"))()
