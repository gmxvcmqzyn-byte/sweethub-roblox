local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer

local gui = Instance.new("ScreenGui")
gui.Name = "SweetHub"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- THEME
local C = {
    bg = Color3.fromRGB(18, 14, 22),
    panel = Color3.fromRGB(30, 24, 35),
    row = Color3.fromRGB(34, 31, 38),
    field = Color3.fromRGB(20, 20, 25),
    pink = Color3.fromRGB(255, 105, 180),
    pink2 = Color3.fromRGB(255, 185, 225),
    green = Color3.fromRGB(55, 190, 120),
    blue = Color3.fromRGB(80, 125, 255),
    white = Color3.fromRGB(245, 245, 250),
}

-- GUI Creation Functions
local function createButton(parent, text, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.fromOffset(140, 50)
    button.BackgroundColor3 = C.blue
    button.Text = text
    button.TextColor3 = C.white
    button.Parent = parent
    button.MouseButton1Click:Connect(callback)
    return button
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
        -- Implement stealing logic here (e.g. collecting nearby items)
        print("Auto stealing items...")
    end
end

-- Connect UI Elements
local Main = Instance.new("Frame")
Main.BackgroundColor3 = C.bg
Main.Size = UDim2.fromOffset(300, 400)
Main.Parent = gui

local speedButton = createButton(Main, "Toggle Normal/Carry Speed", function()
    State.NormalSpeed, State.CarrySpeed = State.CarrySpeed, State.NormalSpeed
    updateSpeed()
end)

local jumpButton = createButton(Main, "Toggle Infinite Jump", function()
    State.InfiniteJump = not State.InfiniteJump
    jumpButton.Text = "Infinite Jump: " .. (State.InfiniteJump and "ON" or "OFF")
end)

local stealButton = createButton(Main, "Toggle Auto Steal", function()
    State.AutoSteal = not State.AutoSteal
    stealButton.Text = "Auto Steal: " .. (State.AutoSteal and "ON" or "OFF")
end)

local updateButton = createButton(Main, "Update Speed", function()
    updateSpeed()
end)

while true do
    wait(1)
    autoSteal() -- Check for auto stealing every second
end
