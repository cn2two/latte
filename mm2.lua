printl("Initializing")

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local murderer = Drawing.new("Text")
murderer.Text = "Murderer:"
murderer.Position = Vector2.new(10, 740)
murderer.Color = Color3.new(1, 0, 0)
murderer.Size = 24
murderer.Font = 2
murderer.Thickness = 10
murderer.Transparency = 1
murderer.Visible = true

local sheriff = Drawing.new("Text")
sheriff.Text = "Sheriff:"
sheriff.Position = Vector2.new(10, 815)
sheriff.Color = Color3.new(0, 1, 1)
sheriff.Size = 24
sheriff.Font = 2
sheriff.Thickness = 10
sheriff.Transparency = 1
sheriff.Visible = true

local function checkPlayerTools()
    for _, player in ipairs(Players:GetChildren()) do
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

local gunDropESP = nil

local function findGunDrop()
    for _, v in ipairs(workspace:GetChildren()) do
        if v:FindFirstChild("GunDrop") then
            return v.GunDrop
        end
    end
end

local function updateGunDropESP()
    if gunDropESP then
        gunDropESP:Remove()
        gunDropESP = nil
    end

    local gunDrop = findGunDrop()
    if not gunDrop then return end

    local pos, onScreen = WorldToScreen(gunDrop.Position)
    if not onScreen then return end

    gunDropESP = Drawing.new("Square")
    gunDropESP.Position = Vector2.new(pos.X - 10, pos.Y - 10)
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

local FREEZE_KEY = 0x23 -- END
local freezing = false
local wasDown = false
local safePos = nil

local statusText = Drawing.new("Text")
statusText.Size = 17
statusText.Font = 2
statusText.Center = true
statusText.Outline = true
statusText.Visible = false

printl("slender is a retarded terrorist")

local lastRoleCheck = 0

while true do
    local char = LocalPlayer.Character
    local keyDown = iskeypressed(FREEZE_KEY)

    if wasDown and not keyDown then
        freezing = not freezing
        safePos = nil
    end
    wasDown = keyDown

    statusText.Position = Vector2.new(Camera.ViewportSize.X / 2, 40)
    if freezing then
        statusText.Text = "ANTI-FLING ENABLED"
        statusText.Color = Color3.fromRGB(0, 255, 0)
        statusText.Visible = true
    else
        statusText.Visible = false
    end

    if freezing and char then
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then
            local vel = hrp.AssemblyLinearVelocity
            if math.abs(vel.X) < 100
                and math.abs(vel.Y) < 100
                and math.abs(vel.Z) < 100 then
                safePos = hrp.Position
            elseif safePos then
                hrp.Position = safePos
                hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
            end
        end
    end

    if os.clock() - lastRoleCheck >= 1 then
        checkPlayerTools()
        lastRoleCheck = os.clock()
    end

    updateGunDropESP()
    handleGunGrab()
    task.wait(0.03)
end
