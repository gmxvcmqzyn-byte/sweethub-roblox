-- Save this as a .lua file and host it on a file server
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer

local gui = Instance.new("ScreenGui")
gui.Name = "SweetHub"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- SWEETHUB THEME
local C = {
    bg = Color3.fromRGB(15, 12, 20),
    primary = Color3.fromRGB(138, 43, 226),
    secondary = Color3.fromRGB(75, 0, 130),
    accent = Color3.fromRGB(255, 20, 147),
    card = Color3.fromRGB(30, 25, 45),
    field = Color3.fromRGB(20, 18, 30),
    text = Color3.fromRGB(240, 240, 250),
    textSecondary = Color3.fromRGB(180, 180, 200),
    green = Color3.fromRGB(76, 175, 80),
    red = Color3.fromRGB(244, 67, 54),
}

-- GUI Creation Functions
local function createButton(parent, text, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.fromOffset(260, 45)
    button.BackgroundColor3 = C.primary
    button.BorderSizePixel = 0
    button.Text = text
    button.TextColor3 = C.text
    button.TextSize = 14
    button.Font = Enum.Font.GothamBold
    button.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = button
    
    button.MouseButton1Click:Connect(callback)
    
    button.MouseEnter:Connect(function()
        local tween = TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = C.accent})
        tween:Play()
    end)
    
    button.MouseLeave:Connect(function()
        local tween = TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = C.primary})
        tween:Play()
    end)
    
    return button
end

local function createLabel(parent, text, size)
    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = C.text
    label.TextSize = size or 16
    label.Font = Enum.Font.GothamBold
    label.Parent = parent
    return label
end

-- Main Variables
local State = {
    NormalSpeed = 60,
    CarrySpeed = 30,
    InfiniteJump = false,
    AutoSteal = false,
    JumpPower = 50,
}

-- Speed Control
local function updateSpeed()
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid")
    humanoid.WalkSpeed = State.NormalSpeed
end

-- Jumping Mechanism
UIS.InputBegan:Connect(function(input, processed)
    if processed then return end
    if State.InfiniteJump and input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.Space then
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoid = character:WaitForChild("Humanoid")
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- Stealing Logic
local function autoSteal()
    if State.AutoSteal then
        print("Auto stealing items...")
    end
end

-- Main Container
local Main = Instance.new("Frame")
Main.BackgroundColor3 = C.bg
Main.Size = UDim2.fromOffset(320, 500)
Main.Position = UDim2.fromOffset(20, 20)
Main.BorderSizePixel = 0
Main.Parent = gui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = Main

-- Header
local header = Instance.new("Frame")
header.BackgroundColor3 = C.secondary
header.Size = UDim2.fromScale(1, 0.15)
header.BorderSizePixel = 0
header.Parent = Main

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 12)
headerCorner.Parent = header

local title = createLabel(header, "SWEETHUB", 20)
title.Size = UDim2.fromScale(1, 1)
title.TextScaled = false
title.Parent = header

-- Content Area
local content = Instance.new("Frame")
content.BackgroundTransparency = 1
content.Size = UDim2.new(1, -20, 1, -80)
content.Position = UDim2.fromOffset(10, 65)
content.Parent = Main

local contentList = Instance.new("UIListLayout")
contentList.Padding = UDim.new(0, 12)
contentList.Parent = content

-- Section Divider
local function createSection(text)
    local section = Instance.new("Frame")
    section.BackgroundTransparency = 1
    section.Size = UDim2.fromOffset(260, 30)
    section.Parent = content
    
    local label = createLabel(section, text, 12)
    label.Size = UDim2.fromScale(1, 1)
    label.TextColor3 = C.textSecondary
    label.Font = Enum.Font.GothamSemibold
    
    return section
end

-- Speed Controls Section
createSection("⚡ SPEED CONTROLS")

local speedButton = createButton(content, "Toggle Normal/Carry Speed", function()
    State.NormalSpeed, State.CarrySpeed = State.CarrySpeed, State.NormalSpeed
    updateSpeed()
    speedButton.Text = "Speed: " .. State.NormalSpeed .. " WalkSpeed"
end)

local updateButton = createButton(content, "Update Speed", function()
    updateSpeed()
    local tween = TweenService:Create(updateButton, TweenInfo.new(0.3), {BackgroundColor3 = C.green})
    tween:Play()
    wait(0.3)
    local tween2 = TweenService:Create(updateButton, TweenInfo.new(0.3), {BackgroundColor3 = C.primary})
    tween2:Play()
end)

-- Jump Section
createSection("🎮 JUMP CONTROLS")

local jumpButton = createButton(content, "Infinite Jump: OFF", function()
    State.InfiniteJump = not State.InfiniteJump
    jumpButton.BackgroundColor3 = State.InfiniteJump and C.green or C.primary
    jumpButton.Text = "Infinite Jump: " .. (State.InfiniteJump and "ON" or "OFF")
end)

-- Auto Features Section
createSection("🎯 AUTO FEATURES")

local stealButton = createButton(content, "Auto Steal: OFF", function()
    State.AutoSteal = not State.AutoSteal
    stealButton.BackgroundColor3 = State.AutoSteal and C.green or C.primary
    stealButton.Text = "Auto Steal: " .. (State.AutoSteal and "ON" or "OFF")
end)

-- Footer
local footer = Instance.new("Frame")
footer.BackgroundColor3 = C.card
footer.Size = UDim2.new(1, 0, 0, 40)
footer.Position = UDim2.new(0, 0, 1, -40)
footer.BorderSizePixel = 0
footer.Parent = Main

local footerCorner = Instance.new("UICorner")
footerCorner.CornerRadius = UDim.new(0, 12)
footerCorner.Parent = footer

local footerLabel = createLabel(footer, "SweetHub v1.0", 11)
footerLabel.Size = UDim2.fromScale(1, 1)
footerLabel.TextColor3 = C.textSecondary
footerLabel.Parent = footer

-- Main Loop
while true do
    wait(1)
    autoSteal()
end
