local Players = game:GetService("Players")
local player = Players.LocalPlayer
local UNWALK_KEY = 0x23 
local HUM_KEY    = 0x2E
local airdropEnabled = true
local dropbox, dropoutline, droptext
local ddd = {R = 255, G = 255, B = 255}
local colorx = 2

spawn(function()
    while true do
        if airdropEnabled then
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
                    dropbox.Filled = false

                    droptext = Drawing.new("Text")
                    droptext.Font = 2
                    droptext.Size = 17
                    droptext.Text = "Airdrop"
                    droptext.Outline = true
                    droptext.Center = true
                end
                if post then
                    local c = post.Color
                    ddd.R = math.min(255, math.floor(c.R * colorx))
                    ddd.G = math.min(255, math.floor(c.G * colorx))
                    ddd.B = math.min(255, math.floor(c.B * colorx))
                end
                dropbox.Color = Color3.fromRGB(ddd.R, ddd.G, ddd.B)
                droptext.Color = dropbox.Color

                local top, s1 = WorldToScreen(root.Position + Vector3.new(0,2,0))
                local bottom, s2 = WorldToScreen(root.Position - Vector3.new(0,2,0))

                if s1 and s2 then
                    local h = math.abs(top.Y - bottom.Y)
                    local w = h
                    local x = top.X - w/2
                    local y = top.Y

                    dropbox.Position = Vector2.new(x,y)
                    dropbox.Size = Vector2.new(w,h)

                    dropoutline.Position = dropbox.Position
                    dropoutline.Size = dropbox.Size

                    droptext.Position = Vector2.new(top.X, y - 16)

                    dropbox.Visible = true
                    dropoutline.Visible = true
                    droptext.Visible = true
                else
                    dropbox.Visible = false
                    dropoutline.Visible = false
                    droptext.Visible = false
                end
            else
                if dropbox then
                    dropbox.Visible = false
                    dropoutline.Visible = false
                    droptext.Visible = false
                end
            end
        end
        wait(0.01)
    end
end)
local unwalkEnabled = false
local animateScript, animator
local animateParent, animatorParent
local lastUnwalkPress = false
local function enableUnwalk()
    local char = player.Character
    if not char then return end

    animateScript = char:FindFirstChild("Animate")
    if animateScript then
        animateParent = animateScript.Parent
        animateScript.Parent = game
    end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        animator = hum:FindFirstChildOfClass("Animator")
        if animator then
            animatorParent = animator.Parent
            animator.Parent = game
        end
    end
end
local function disableUnwalk()
    if animateScript and animateParent then
        animateScript.Parent = animateParent
    end
    if animator and animatorParent then
        animator.Parent = animatorParent
    end
    animateScript, animator = nil, nil
end
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
local hitboxsize = Vector3.new(12,8,12)
local hitboxEnabled = true
local Targets = {
    {Parent = "MansionRobbery", Models = {"GuardsFolder"}},
    {Parent = "OilRig", Models = {"GuardsFolder"}},
    {Parent = "Drop", Models = {"NPCs"}},
}
local function expandHead(model)
    local hum = model:FindFirstChildOfClass("Humanoid")
    local head = model:FindFirstChild("Head")
    if hum and head then
        head.Size = hitboxsize
        head.CanCollide = true
    end
end
local function scanFolder(folder)
    for _, v in ipairs(folder:GetChildren()) do
        if v:IsA("Model") then
            expandHead(v)
        elseif v:IsA("Folder") then
            scanFolder(v)
        end
    end
end
spawn(function()
    while true do
        if hitboxEnabled then
            local mansion = workspace:FindFirstChild("MansionRobbery")
            if mansion then
                local boss = mansion:FindFirstChild("ActiveBoss")
                if boss then expandHead(boss) end
            end

            for _, t in ipairs(Targets) do
                local parent = workspace:FindFirstChild(t.Parent)
                if parent then
                    for _, fname in ipairs(t.Models) do
                        local f = parent:FindFirstChild(fname)
                        if f then scanFolder(f) end
                    end
                end
            end
        end
        wait(0.5)
    end
end)
local HUM_OFFSET = 0x194
local lastHumPress = false
local function getHumanoid()
    local char = player.Character
    if not char then return end
    return char:FindFirstChildOfClass("Humanoid")
end
spawn(function()
    while true do
        if isrbxactive() then
            local pressed = iskeypressed(HUM_KEY)
            if pressed and not lastHumPress then
                local hum = getHumanoid()
                if hum and hum.Address then
                    memory_write("float", hum.Address + HUM_OFFSET, -10)
                end
            end
            lastHumPress = pressed
        else
            lastHumPress = false
        end
        wait(0.03)
    end
end)
print("cn2 might be allah")
