printl("Initializing")

local murderer = Drawing.new("Text")
murderer.Text = "Murderer: None"
murderer.Position = Vector2.new(10, 740)
murderer.Color = Color3.new(1, 0, 0)
murderer.Size = 24
murderer.Font = 2
murderer.Thickness = 10 --increase if u want to see the text clear
murderer.Transparency = 1
murderer.Visible = true

local sheriff = Drawing.new("Text")
sheriff.Text = "Sheriff: None"
sheriff.Size = 24
sheriff.Font = 2
sheriff.Position = Vector2.new(10, 815)
sheriff.Color = Color3.new(0, 173, 265)
sheriff.Thickness = 10 --increase if u want to see the text clear
sheriff.Transparency = 1
sheriff.Visible = true

local function checkPlayerTools()
    local players = game:GetService("Players"):GetChildren()
    
    for _, player in ipairs(players) do
        local backpack = player:FindFirstChild("Backpack")
        if backpack then
            local knife = backpack:FindFirstChild("Knife")
            local gun = backpack:FindFirstChild("Gun")
            
            if knife then
                murderer.Text = "Murderer: " .. player.Name
            end
            
            if gun then
                sheriff.Text = "Sheriff: " .. player.Name
            end
        end
        
        local character = player:FindFirstChild("Character")
        if character then
            local knifeInHand = character:FindFirstChild("Knife")
            local gunInHand = character:FindFirstChild("Gun")
            
            if knifeInHand then
                murderer.Text = "Murderer: " .. player.Name
            end
            
            if gunInHand then
                sheriff.Text = "Sheriff: " .. player.Name
            end
        end
    end
end
local gunDropESP = nil

local function findGunDrop()
    for _, v in ipairs(workspace:GetChildren()) do
        local drop = v:FindFirstChild("GunDrop")
        if drop then
            return drop
        end
    end
    return nil
end

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
local pressed = false
local lastPosition = nil

local function handleGunGrab()
    if not iskeypressed(DEL_KEY) then
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

printl("Initialized")


while true do
    checkPlayerTools()
    updateGunDropESP()
    handleGunGrab()
    wait(0.05)
end
