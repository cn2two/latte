
--[[
    
⠀⠀⣀⣤⠤⠶⠶⠶⠶⠶⠶⢶⠶⠶⠦⣤⣄⣀⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣠⣤⣶⣦⣤⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⣀⣤⡤⣤⠶⠴⠶⠶⠶⣶⠶⠶⢤⣤⣀⡀
⣴⡏⠡⢒⡸⠋⠀⠐⣾⠉⠉⠭⢄⣠⢤⡷⠷⢾⣛⣿⠷⣶⣤⣄⡀⠀⠀⠐⢿⣟⢲⡁⠐⣾⠛⠃⠀⠀⢀⣠⡤⠶⠒⣛⣩⠝⢋⣠⣰⣂⣤⠴⠏⠉⠓⢺⡿⢁⣴⣮⢽⡟
⠙⠶⣞⣥⡴⠚⣩⣦⠨⣷⠋⠠⠤⠶⢲⡺⠢⣤⡼⠿⠛⠛⣻⣿⣿⠿⢶⣤⣿⣯⡾⠗⠾⣇⣙⣤⡶⢿⣯⡕⢖⣺⠋⣭⣤⣤⢤⡶⠖⠮⢷⡄⠛⠂⣠⣽⡟⢷⣬⡿⠋⠁
⠀⠀⠀⠈⠒⢿⣁⡴⠟⣊⣇⠠⣴⠞⣉⣤⣷⣤⠶⠿⢛⢛⠩⠌⠚⢁⣴⣿⠏⠀⣴⠀⢀⣦⠻⠻⣑⠢⢕⡋⢿⡿⣿⣷⢮⣤⣷⣬⣿⠷⠈⢁⣤⣾⡿⣽⡮⠋⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠈⠛⠷⣾⣋⣤⡾⠛⣁⡡⢤⡾⢤⡖⠋⠉⠀⠀⠀⠀⠀⢰⣿⡷⠺⠛⠐⡿⠃⠦⠤⠈⠉⠢⠄⠈⠁⠙⢿⣮⣿⢤⣶⣁⣀⣛⣿⣷⠼⠚⠁⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠉⠛⠙⠇⠀⣩⡥⠞⢗⣼⣧⠀⠀⠀⠀⠀⠀⠀⢈⣿⡇⢄⡤⠤⣧⠄⢀⡀⠀⠀⠀⠀⠀⠀⠀⢘⣿⡟⠺⣯⣽⡉⠉⠉⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣾⠇⣊⣭⢿⡛⠁⡅⠀⠀⠀⠀⠀⠀⠈⢻⡇⢘⣡⣀⡀⣏⠀⠃⠀⠀⠀⠀⠀⠀⠀⣸⡏⠈⢦⣶⣿⡟⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⢿⣥⡔⣫⠔⡀⡰⠀⠀⠀⠀⠀⠀⠀⢺⡇⠈⢰⠀⢹⠇⠀⡘⡄⠀⠀⠀⠀⠀⢠⣿⣄⢠⣾⣿⠟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠛⠷⠺⠘⠛⠛⠓⢂⠀⠀⠀⠀⠸⣧⠀⢺⠀⠊⠀⠰⠇⠘⢄⡀⠀⠰⠶⡛⠓⠟⠋⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢹⣆⠛⠒⠁⠀⠀⠀⠀⠀⠈⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠻⣆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠻⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀


 ]]


local defaultBind = 0x70
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local defaultVelocityCap = 150
local lockTime = 2
local binderEnable = false
local enabled = false
local lockHRP2 = 0
local lockHRP = nil
local velocityCap = defaultVelocityCap
local afWidget = nil
local fuckneoxi = Drawing.new("Text")
fuckneoxi.Size = 17
fuckneoxi.Font = 2
fuckneoxi.Center = true
fuckneoxi.Outline = true
fuckneoxi.Visible = false
local segments = 5
local radius2 = 0.1
local height1 = 0.05
local rollbackLines = {}
local rollbackOutlines = {}
for i = 1, segments do
    local outline = Drawing.new("Line")
    outline.Visible = false
    outline.Color = Color3.fromRGB(0, 0, 0)
    outline.Thickness = 3
    rollbackOutlines[i] = outline

    local line = Drawing.new("Line")
    line.Visible = false
    line.Color = Color3.fromRGB(0, 0, 0)
    line.Thickness = 2
    rollbackLines[i] = line
end
local function getRoot()
    local character = LocalPlayer and LocalPlayer.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    if root and root:IsA("BasePart") then
        return root
    end
    return nil
end
UI.AddTab("Anti Fling", function(tab)
    local main = tab:Section("Anti Fling", "Left")
    main:Toggle("antifling_enabled", "Enabled", false, function(value)
        binderEnable = value == true
        if not binderEnable then
            enabled = false
            lockHRP2 = 0
            lockHRP = nil
        end
    end)
    afWidget = main:Keybind("antifling_keybind", defaultBind, "toggle")
    afWidget:AddToHotkey("Anti Fling", "antifling_enabled")
    main:SliderInt("antifling_velocity_cap", "Velocity Cap", 25, 500, defaultVelocityCap, function(value)
        velocityCap = tonumber(value) or defaultVelocityCap
    end)
    main:SliderFloat("antifling_lock_time", "Lock Time", 0.1, 5.0, lockTime, "%.2f", function(value)
        lockTime = tonumber(value) or 2
    end)
end)

local function zerophysics(part)
    if not part or not part.Address then return end
    local primitive = memory_read("uintptr_t", part.Address + 0x148)
    if primitive and primitive ~= 0 then
        memory_write("float", primitive + 0xF0, 0)
        memory_write("float", primitive + 0xF4, 0)
        memory_write("float", primitive + 0xF8, 0)
        memory_write("float", primitive + 0xFC, 0)
        memory_write("float", primitive + 0x100, 0)
        memory_write("float", primitive + 0x104, 0)
    end
end
local function hidevisual()
    for i = 1, segments do
        rollbackLines[i].Visible = false
        rollbackOutlines[i].Visible = false
    end
end
local function URD()
    if not enabled or not lockHRP then
        hidevisual()
        return
    end
    local center = lockHRP + Vector3.new(0, height1, 0)
    local screenPoints = {}
    for i = 1, segments do
        local t = ((i - 1) / segments) * (math.pi * 2)
        local worldPoint = center + Vector3.new(math.cos(t) * radius2, 0, math.sin(t) * radius2)
        local a, b, c = WorldToScreen(worldPoint)
        local pos2d, onScreen, depth
        if typeof(a) == "Vector2" then
            pos2d = a
            onScreen = (b ~= false)
            depth = c
        elseif typeof(a) == "Vector3" then
            pos2d = Vector2.new(a.X, a.Y)
            onScreen = (b ~= false)
            depth = a.Z
        elseif type(a) == "number" and type(b) == "number" then
            pos2d = Vector2.new(a, b)
            onScreen = true
            depth = c
        end
        if not pos2d or not onScreen or (depth and depth <= 0) then
            hidevisual()
            return
        end
        screenPoints[i] = pos2d
    end
    for i = 1, segments do
        local nextI = (i % segments) + 1
        local p1, p2 = screenPoints[i], screenPoints[nextI]
        rollbackOutlines[i].From = p1
        rollbackOutlines[i].To = p2
        rollbackOutlines[i].Visible = true
        rollbackLines[i].From = p1
        rollbackLines[i].To = p2
        rollbackLines[i].Visible = true
    end
end
local function safestate(root)
    if not lockHRP then return end
    root.CFrame = CFrame.new(lockHRP.X, lockHRP.Y, lockHRP.Z)
    root.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
    zerophysics(root)
end
RunService.Heartbeat:Connect(function()
    local root = getRoot()
    local now = os.clock()
    local bindEnabled = false

    if binderEnable and afWidget and afWidget.IsEnabled then
        bindEnabled = afWidget:IsEnabled() == true
    end

    if enabled ~= bindEnabled then
        enabled = bindEnabled
        lockHRP2 = 0

        if enabled and root then
            lockHRP = root.Position
        else
            lockHRP = nil
        end
    end

    if enabled and root then
        local speed = root.AssemblyLinearVelocity.Magnitude
        if now >= lockHRP2 and speed <= velocityCap then
            lockHRP = root.Position
        end
        if speed > velocityCap then
            lockHRP2 = now + lockTime
        end
        if now < lockHRP2 then
            safestate(root)
        end
    elseif not root then
        lockHRP = nil
    end
end)
RunService.Heartbeat:Connect(function()
    local camera = workspace.CurrentCamera
    if camera and camera.ViewportSize then
        fuckneoxi.Position = Vector2.new(camera.ViewportSize.X / 2, 40)
    end
    if enabled then
        fuckneoxi.Visible = true
        if os.clock() < lockHRP2 then
            fuckneoxi.Text = "FLING BLOCKED"
            fuckneoxi.Color = Color3.fromRGB(255, 50, 50)
        else
            fuckneoxi.Text = " "
            fuckneoxi.Color = Color3.fromRGB(255, 255, 255)
        end
    else
        fuckneoxi.Visible = false
    end
    URD()
end)
