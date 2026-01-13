-- AIRDROP ESP
local fuckweyble2 = true 
local dropbox, dropoutline, droptext
local ddd = {R = 255, G = 255, B = 255}
local colorx = 2

spawn(function()
    while true do
        wait(0.01)
        if fuckweyble2 then
            local drop = workspace:FindFirstChild("Drop")
            if drop and drop:FindFirstChild("Root") then
                local root = drop.Root
                local post = drop:FindFirstChild("Post")

                if not dropbox then
                    dropoutline = Drawing.new("Square")
                    dropoutline.Thickness = 3
                    dropoutline.Color = Color3.fromRGB(0,0,0)
                    dropoutline.Filled = false

                    dropbox = Drawing.new("Square")
                    dropbox.Thickness = 1
                    dropbox.Color = Color3.fromRGB(255,255,255)
                    dropbox.Filled = false

                    droptext = Drawing.new("Text")
                    droptext.Font = 2
                    droptext.Size = 17
                    droptext.Text = "Airdrop"
                    droptext.Color = Color3.fromRGB(255,255,255)
                    droptext.Outline = true
                    droptext.Center = true
                end

                if post then
                    local partColor = post.Color
                    ddd.R = math.min(255, math.floor(partColor.R * colorx))
                    ddd.G = math.min(255, math.floor(partColor.G * colorx))
                    ddd.B = math.min(255, math.floor(partColor.B * colorx))
                end

                dropbox.Color = Color3.fromRGB(ddd.R, ddd.G, ddd.B)
                droptext.Color = Color3.fromRGB(ddd.R, ddd.G, ddd.B)

                local top, on1 = WorldToScreen(root.Position + Vector3.new(0,2,0))
                local bottom, on2 = WorldToScreen(root.Position - Vector3.new(0,2,0))

                if on1 and on2 then
                    local h = math.abs(top.Y - bottom.Y)
                    local w = h
                    local x = top.X - w/2
                    local y = top.Y

                    dropbox.Position = Vector2.new(x,y)
                    dropbox.Size = Vector2.new(w,h)

                    dropoutline.Position = Vector2.new(x,y)
                    dropoutline.Size = Vector2.new(w,h)

                    droptext.Position = Vector2.new(top.X, y - 16)

                    dropbox.Visible = true
                    dropoutline.Visible = true
                    droptext.Visible = true
                else
                    dropbox.Visible = false
                    dropoutline.Visible = false
                    droptext.Visible = false
                end
            elseif dropbox then
                dropbox.Visible = false
                dropoutline.Visible = false
                droptext.Visible = false
            end
        end
    end
end)

-- HITBOX
local hitboxsize = Vector3.new(12,8,12)
local fuckweyble = true

local Targets = {
    {Parent = workspace:FindFirstChild("MansionRobbery"), Models = {"GuardsFolder"}},
    {Parent = workspace:FindFirstChild("OilRig"), Models = {"GuardsFolder"}},
    {Parent = workspace:FindFirstChild("Drop"), Models = {"NPCs"}},
}

local function headmansion(model)
    if not model or not model:IsA("Model") then return end
    local humanoid = model:FindFirstChildOfClass("Humanoid")
    local head = model:FindFirstChild("Head")
    if humanoid and head then
        head.Size = hitboxsize
        head.CanCollide = true
    end
end

local function loopall(parent)
    if not parent then return end
    for _, child in pairs(parent:GetChildren()) do
        if child:IsA("Model") then
            headmansion(child)
        elseif child:IsA("Folder") then
            loopall(child)
        end
    end
end

spawn(function()
    while true do
        if fuckweyble then
            local mansion = workspace:FindFirstChild("MansionRobbery")
            if mansion then
                local boss = mansion:FindFirstChild("ActiveBoss")
                if boss then
                    headmansion(boss)
                end
            end

            for _, target in ipairs(Targets) do
                local parent = workspace:FindFirstChild(target.Parent and target.Parent.Name or "")
                if parent then
                    for _, modelName in ipairs(target.Models) do
                        local folder = parent:FindFirstChild(modelName)
                        if folder then
                            loopall(folder)
                        end
                    end
                end
            end
        end
        wait(0.5)
    end
end)

-- FORCE RESET (DEL)
local RESET_KEY = 0x2E
local HUM_OFFSET = 0x194

local Players = game:GetService("Players")
local player = Players.LocalPlayer

local function getHumanoid()
    if not player then return end
    local char = player.Character
    if not char then return end
    return char:FindFirstChildOfClass("Humanoid")
end

spawn(function()
    local last = false
    while true do
        if isrbxactive() then
            local pressed = iskeypressed(RESET_KEY)
            if pressed and not last then
                local hum = getHumanoid()
                if hum and hum.Address then
                    memory_write("float", hum.Address + HUM_OFFSET, -10)
                end
            end
            last = pressed
        else
            last = false
        end
        wait(0.03)
    end
end)

-- UNWALK (DEL)
local UNWALK_KEY = 0x23
local enabled = false
local animateScript
local animator
local originalAnimateParent
local originalAnimatorParent
local lastPress = false

local function enableUnwalk()
    local char = player.Character
    if not char then return end

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
        local pressed = iskeypressed(UNWALK_KEY)
        if pressed and not lastPress then
            enabled = not enabled
            if enabled then
                enableUnwalk()
            else
                disableUnwalk()
            end
        end
        lastPress = pressed
        wait(0.05)
    end
end)
