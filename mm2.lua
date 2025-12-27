printl("Initializing")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local murderer = Drawing.new("Text")
murderer.Text = "Murderer: None"
murderer.Position = Vector2.new(10, 740)
murderer.Color = Color3.new(1, 0, 0)
murderer.Size = 24
murderer.Font = 2
murderer.Thickness = 4
murderer.Outline = true
murderer.Visible = true
local sheriff = Drawing.new("Text")
sheriff.Text = "Sheriff: None"
sheriff.Position = Vector2.new(10, 815)
sheriff.Color = Color3.fromRGB(0, 173, 255)
sheriff.Size = 24
sheriff.Font = 2
sheriff.Thickness = 4
sheriff.Outline = true
sheriff.Visible = true
local function checkPlayerTools()
    murderer.Text = "Murderer: None"
    sheriff.Text = "Sheriff: None"

    for _, player in ipairs(Players:GetChildren()) do
        if player ~= LocalPlayer then
            local backpack = player:FindFirstChild("Backpack")
            local character = player.Character

            if backpack then
                if backpack:FindFirstChild("Knife") then
                    murderer.Text = "Murderer: " .. player.Name
                end
                if backpack:FindFirstChild("Gun") then
                    sheriff.Text = "Sheriff: " .. player.Name
                end
            end

            if character then
                if character:FindFirstChild("Knife") then
                    murderer.Text = "Murderer: " .. player.Name
                end
                if character:FindFirstChild("Gun") then
                    sheriff.Text = "Sheriff: " .. player.Name
                end
            end
        end
    end
end

local function findGunDrop()
    for _, v in ipairs(workspace:GetChildren()) do
        local drop = v:FindFirstChild("GunDrop")
        if drop then
            return drop
        end
    end
    return nil
end
local gunDropESP = nil

local function updateGunDropESP()
    if gunDropESP then
        gunDropESP:Remove()
        gunDropESP = nil
    end

    local gunDrop = findGunDrop()
    if not gunDrop then return end

    local screenPos, onScreen = WorldToScreen(gunDrop.Position)
    if not onScreen or not screenPos then return end

    gunDropESP = Drawing.new("Square")
    gunDropESP.Position = Vector2.new(screenPos.X - 10, screenPos.Y - 10)
    gunDropESP.Size = Vector2.new(20, 20)
    gunDropESP.Color = Color3.new(1, 1, 0)
    gunDropESP.Filled = false
    gunDropESP.Thickness = 2
    gunDropESP.Visible = true
end
local DEL_KEY = 0x2E
local lastPosition = nil
local pressed = false

local function handleGunGrab()
    if not iskeydown(DEL_KEY) then
        pressed = false
        return
    end

    if pressed then return end
    pressed = true

    local gunDrop = findGunDrop()
    if not gunDrop then
        printl("Gun not found")
        return
    end

    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end

    lastPosition = char.HumanoidRootPart.Position
    char.HumanoidRootPart.Position = gunDrop.Position
    wait(0.01)
    char.HumanoidRootPart.Position = lastPosition
end
print("Initialized")
while true do
    checkPlayerTools()
    updateGunDropESP()
    handleGunGrab()
    wait(0.05)
end
