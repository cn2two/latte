
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

while true do
    checkPlayerTools()
    wait(0.2)
end
printl("ESP Loaded")

local gunDropESP = nil

local function findGunDrop()
    for _, child in ipairs(workspace:GetChildren()) do
        local drop = child:FindFirstChild("GunDrop")
        if drop then

            return drop
        end
    end
    return nil
end

while true do
    -- Remove old ESP if exists
    if gunDropESP then
        gunDropESP:Remove()
        gunDropESP = nil
    end

    local gunDrop = findGunDrop()
    if gunDrop then
        local pos = gunDrop.Position


        local screenPos, onScreen = WorldToScreen(pos)


        if screenPos then
            local sx = screenPos.X or screenPos.x
            local sy = screenPos.Y or screenPos.y

            if sx and sy then
                local square = Drawing.new("Square")
                square.Position = Vector2.new(sx, sy)
                square.Size = Vector2.new(20, 20)
                square.Color = Color3.new(1, 1, 0)
                square.Filled = false
                square.Visible = true

                gunDropESP = square

            else
            
            end
        else
            printl("nil")
        end
    else

    end

    wait(0.02)
end
printl("Gun Drop ESP Loaded")


local position = nil
local DEL_KEY = 0x2E -- Delete key

local function findGunDrop()
    for _, child in ipairs(workspace:GetChildren()) do
        local drop = child:FindFirstChild("GunDrop")
        if drop then
            printl("GunDrop found in:", child.Name)
            return drop
        end
    end
    return nil
end

local function guntp(gunDrop)
    local player = game.Players.LocalPlayer
    local character = player.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        position = character.HumanoidRootPart.Position
        character.HumanoidRootPart.Position = gunDrop.Position
    end
end

local function teleportBackToLastPosition()
    local player = game.Players.LocalPlayer
    local character = player.Character
    if character and character:FindFirstChild("HumanoidRootPart") and position then
        character.HumanoidRootPart.Position = position
    end
end

local pressed = false

while true do
    if iskeydown(DEL_KEY) then
        if not pressed then
            pressed = true

            local gunDrop = findGunDrop()
            if gunDrop then
                guntp(gunDrop)
                wait(0.01)
                teleportBackToLastPosition()
            else
                printl("Gun not found")
            end
        end
    else
        pressed = false
    end

    wait(0.05)
end
printl("Gun grabber loaded")

