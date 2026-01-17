--[[
    ROBLOX CHEATS - PRO MENU
    Made by: grotekleuter
--]]

local Library = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local SubTitle = Instance.new("TextLabel")
local ToggleBtn = Instance.new("TextButton")
local Content = Instance.new("ScrollingFrame")
local UIListLayout = Instance.new("UIListLayout")

Library.Name = "RobloxCheats_v3"
Library.Parent = game.CoreGui
Library.ResetOnSpawn = false

-- + / - Toggle Knop
ToggleBtn.Parent = Library
ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
ToggleBtn.Position = UDim2.new(0.3, -35, 0.3, 0)
ToggleBtn.Size = UDim2.new(0, 30, 0, 30)
ToggleBtn.Text = "-"
ToggleBtn.TextColor3 = Color3.fromRGB(0,0,0)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextSize = 20

-- Main Frame
MainFrame.Parent = Library
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.Position = UDim2.new(0.3, 0, 0.3, 0)
MainFrame.Size = UDim2.new(0, 250, 0, 350)
MainFrame.Active = true
MainFrame.Draggable = true

local corner = Instance.new("UICorner")
corner.Parent = MainFrame

Title.Parent = MainFrame
Title.Text = "ROBLOX CHEATS"
Title.Size = UDim2.new(1, 0, 0, 40)
Title.TextColor3 = Color3.fromRGB(0, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20

SubTitle.Parent = MainFrame
SubTitle.Text = "Made by grotekleuter"
SubTitle.Position = UDim2.new(0, 0, 0, 35)
SubTitle.Size = UDim2.new(1, 0, 0, 20)
SubTitle.TextColor3 = Color3.fromRGB(200, 200, 200)
SubTitle.TextSize = 12

Content.Parent = MainFrame
Content.Position = UDim2.new(0.05, 0, 0.2, 0)
Content.Size = UDim2.new(0.9, 0, 0.75, 0)
Content.BackgroundTransparency = 1
Content.ScrollBarThickness = 2

UIListLayout.Parent = Content
UIListLayout.Padding = UDim.new(0, 10)

-- Variabelen voor de cheats
local speedEnabled = false
local jumpEnabled = false
local espEnabled = false
local speedValue = 100
local jumpValue = 150

-- Functie voor Input + Toggle rij
local function AddCheatRow(name, defaultValue, callback, toggleCallback)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 60)
    row.BackgroundTransparency = 1
    row.Parent = Content

    local label = Instance.new("TextLabel")
    label.Text = name
    label.Size = UDim2.new(0.6, 0, 0.4, 0)
    label.TextColor3 = Color3.fromRGB(255,255,255)
    label.BackgroundTransparency = 1
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = row

    local input = Instance.new("TextBox")
    input.PlaceholderText = "Val: " .. defaultValue
    input.Size = UDim2.new(0.3, 0, 0.4, 0)
    input.Position = UDim2.new(0.7, 0, 0, 0)
    input.BackgroundColor3 = Color3.fromRGB(40,40,40)
    input.TextColor3 = Color3.fromRGB(255,255,255)
    input.Parent = row
    
    local toggle = Instance.new("TextButton")
    toggle.Text = "OFF"
    toggle.Size = UDim2.new(1, 0, 0.4, 0)
    toggle.Position = UDim2.new(0, 0, 0.5, 0)
    toggle.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
    toggle.TextColor3 = Color3.fromRGB(255,255,255)
    toggle.Parent = row
    
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 4)
    c.Parent = toggle

    input.FocusLost:Connect(function()
        callback(tonumber(input.Text) or defaultValue)
    end)

    local active = false
    toggle.MouseButton1Click:Connect(function()
        active = not active
        toggle.Text = active and "ON" or "OFF"
        toggle.BackgroundColor3 = active and Color3.fromRGB(50, 150, 50) or Color3.fromRGB(150, 50, 50)
        toggleCallback(active)
    end)
end

-- Speed Setup
AddCheatRow("WalkSpeed", 16, function(v) speedValue = v end, function(state) speedEnabled = state end)

-- Jump Setup
AddCheatRow("JumpPower", 50, function(v) jumpValue = v end, function(state) jumpEnabled = state end)

-- ESP Setup
local activeHighlights = {}
AddCheatRow("Player ESP", 0, function() end, function(state) 
    espEnabled = state 
    if not state then
        for _, h in pairs(activeHighlights) do h:Destroy() end
        activeHighlights = {}
    end
end)

-- De "Loop" die alles laat werken (ook na respawn of anti-cheat resets)
game:GetService("RunService").RenderStepped:Connect(function()
    local char = game.Players.LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        if speedEnabled then
            char.Humanoid.WalkSpeed = speedValue
        end
        if jumpEnabled then
            char.Humanoid.UseJumpPower = true
            char.Humanoid.JumpPower = jumpValue
        end
    end
    
    if espEnabled then
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= game.Players.LocalPlayer and p.Character and not p.Character:FindFirstChild("ESPHighlight") then
                local hl = Instance.new("Highlight")
                hl.Name = "ESPHighlight"
                hl.Parent = p.Character
                hl.FillColor = Color3.fromRGB(0, 255, 255)
                table.insert(activeHighlights, hl)
            end
        end
    end
end)

-- Open/Sluit logic
ToggleBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
    ToggleBtn.Text = MainFrame.Visible and "-" or "+"
end)

-- Sync knop positie
MainFrame:GetPropertyChangedSignal("Position"):Connect(function()
    ToggleBtn.Position = UDim2.new(MainFrame.Position.X.Scale, MainFrame.Position.X.Offset - 35, MainFrame.Position.Y.Scale, MainFrame.Position.Y.Offset)
end)
