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
local VK_HOME = 0x24
local UNWALK_KEY = 0x22 -- PAGE DOWN
local running = false
local homeKeyDown = false
local originalPosition
local unwalkEnabled = false
local animateScript
local animator
local originalAnimateParent
local originalAnimatorParent
local lastUnwalkPress = false

local statusText = Drawing.new("Text")
statusText.Size = 17
statusText.Font = 2
statusText.Center = true
statusText.Outline = true
statusText.Visible = false

local counter = Drawing.new("Text")
counter.Visible = false
counter.Center = true
counter.Outline = true
counter.Font = 2
counter.Size = 20
counter.Color = Color3.fromRGB(0, 255, 200)
counter.Position = Vector2.new(Camera.ViewportSize.X / 2, 20)
counter.Text = ""

local function getAlivePlayers()
    local alive = {}
    for _, plr in ipairs(Players:GetChildren()) do
        if plr:IsA("Player") and plr ~= LocalPlayer and plr.Name ~= "iremsu123_gooo" then
            if plr:GetAttribute("Alive") == true then
                table.insert(alive, plr)
            end
        end
    end
    return alive
end

local function followBehind(plr)
    local myChar = workspace:FindFirstChild(LocalPlayer.Name)
    local targetChar = workspace:FindFirstChild(plr.Name)
    if not myChar or not targetChar then return end

    local myHRP = myChar:FindFirstChild("HumanoidRootPart")
    local targetHRP = targetChar:FindFirstChild("HumanoidRootPart")
    if not myHRP or not targetHRP then return end

    local dx = myHRP.Position.X - targetHRP.Position.X
    local dz = myHRP.Position.Z - targetHRP.Position.Z
    local mag = math.sqrt(dx * dx + dz * dz)
    if mag == 0 then return end

    dx = dx / mag
    dz = dz / mag
    myHRP.Position = Vector3.new(
        targetHRP.Position.X + dx * 3,
        targetHRP.Position.Y,
        targetHRP.Position.Z + dz * 3
    )
end

local function enableUnwalk()
    local char = LocalPlayer.Character
    if not char then return end

    printl("unwalk ON")

    animateScript = char:FindFirstChild("Animate")
    if animateScript then
        originalAnimateParent = animateScript.Parent
        animateScript.Parent = game
    end

    local humanoid = char:FindFirstChild("Humanoid")
    if humanoid then
        animator = humanoid:FindFirstChildOfClass("Animator")
        if animator then
            originalAnimatorParent = animator.Parent
            animator.Parent = game
        end
    end
end

local function disableUnwalk()
    printl("unwalk OFF")

    if animateScript and originalAnimateParent then
        animateScript.Parent = originalAnimateParent
    end

    if animator and originalAnimatorParent then
        animator.Parent = originalAnimatorParent
    end

    animateScript = nil
    animator = nil
    originalAnimateParent = nil
    originalAnimatorParent = nil
end

spawn(function()
    while true do
        wait(0.05)

        local pressed = iskeypressed(VK_HOME)
        if pressed and not homeKeyDown then
            homeKeyDown = true
            running = not running
            counter.Visible = running

            local myChar = workspace:FindFirstChild(LocalPlayer.Name)
            if myChar then
                local myHRP = myChar:FindFirstChild("HumanoidRootPart")
                if myHRP then
                    if running then
                        originalPosition = myHRP.Position
                    elseif originalPosition then
                        myHRP.Position = originalPosition
                    end
                end
            end

            if not running then
                counter.Text = ""
            end
        end

        if not pressed then
            homeKeyDown = false
        end

        if running then
            counter.Position = Vector2.new(Camera.ViewportSize.X / 2, 20)
            local alivePlayers = getAlivePlayers()
            counter.Text = "Alive: " .. #alivePlayers
            for _, plr in ipairs(alivePlayers) do
                followBehind(plr)
            end
        end
    end
end)

spawn(function()
    while true do
        local pressed = iskeypressed(UNWALK_KEY)

        if pressed and not lastUnwalkPress then
            unwalkEnabled = not unwalkEnabled
            if unwalkEnabled then
                enableUnwalk()
            else
                disableUnwalk()
            end
        end

        lastUnwalkPress = pressed
        wait(0.05)
    end
end)

printl("slender is a retarded terrorist")
printl("unwalk loaded (PAGE DOWN to toggle)")

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
