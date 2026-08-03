local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

local offsets = {
    workspaceWorld = 0x3F0,
    workspaceReadOnlyGravity = 0x9B0,
    worldGravity = 0x210,
    humanoidSit = 0x1DE
}

local originalGravity = 196.2
local gravityOk, exposedGravity = pcall(function()
    return Workspace.Gravity
end)
if gravityOk and type(exposedGravity) == "number" then
    originalGravity = exposedGravity
end

local state = {
    roles = false,
    gunDropEsp = false,
    gunGrab = false,
    killAll = false,
    predictionSilentAim = false,
    coinAura = false,
    visuals = false,
    debrisEnabled = false,
    debrisActive = false,
    originalGravity = originalGravity
}
local killAllWhitelist = {
    iremsu123_gooo = true,
    ezonunciki56 = true,
    weyblex = true,
    marybrogg = true
}

local visualStyle = {
    partColor = Color3.fromRGB(0, 119, 255),
    trailColor = Color3.fromRGB(255, 0, 0),
    linkColor = Color3.fromRGB(0, 119, 255),
    pathColor = Color3.fromRGB(255, 0, 0),
    boxThickness = 2,
    pathThickness = 2
}

local widgets = {}
local drawings = {
    boxes = {},
    pathLines = {}
}
local visualCache = {
    gunDrop = nil,
    murdererRoot = nil,
    objects = {},
    parts = {},
    trailParts = {}
}

local function safeRemove(drawing)
    if drawing then
        pcall(function()
            drawing.Visible = false
            drawing:Remove()
        end)
    end
end

local function setVisible(drawing, visible)
    if drawing then
        pcall(function()
            drawing.Visible = visible == true
        end)
    end
end

local function keybindActive(widget)
    if not widget or type(widget.IsEnabled) ~= "function" then
        return false
    end

    local ok, active = pcall(function()
        return widget:IsEnabled()
    end)
    return ok and active == true
end

local function addHotkey(widget, label, toggleId)
    if widget and type(widget.AddToHotkey) == "function" then
        pcall(function()
            widget:AddToHotkey(label, toggleId)
        end)
    end
end

local function getLocalHumanoid()
    local character = LocalPlayer and (LocalPlayer.Character or Workspace:FindFirstChild(LocalPlayer.Name))
    return character and character:FindFirstChildOfClass("Humanoid") or nil
end

local function setGravity(value)
    value = tonumber(value)
    if not value then
        return
    end

    pcall(function()
        Workspace.Gravity = value
    end)

    local addressOk, workspaceAddress = pcall(function()
        return Workspace.Address
    end)
    if not addressOk then
        return
    end
    if type(workspaceAddress) ~= "number" or workspaceAddress == 0 then
        return
    end

    pcall(function()
        memory_write("float", workspaceAddress + offsets.workspaceReadOnlyGravity, value)
    end)

    local world
    local readOk = pcall(function()
        world = memory_read("uintptr_t", workspaceAddress + offsets.workspaceWorld)
    end)
    if not readOk then
        pcall(function()
            world = memory_read("uintptr", workspaceAddress + offsets.workspaceWorld)
        end)
    end

    if type(world) == "number" and world ~= 0 then
        pcall(function()
            memory_write("float", world + offsets.worldGravity, value)
        end)
    end
end

local function setSit(enabled)
    local humanoid = getLocalHumanoid()
    if not humanoid then
        return
    end

    pcall(function()
        humanoid.Sit = enabled == true
    end)

    local addressOk, humanoidAddress = pcall(function()
        return humanoid.Address
    end)
    if not addressOk then
        return
    end
    if type(humanoidAddress) == "number" and humanoidAddress ~= 0 then
        pcall(function()
            memory_write("byte", humanoidAddress + offsets.humanoidSit, enabled and 1 or 0)
        end)
    end
end

local function setDebrisActive(enabled)
    enabled = enabled == true
    state.debrisActive = enabled
    if enabled then
        setGravity(0)
        setSit(true)
    else
        setGravity(state.originalGravity)
        setSit(false)
    end
end

local function newText(color, position)
    local drawing = Drawing.new("Text")
    drawing.Font = 2
    drawing.Size = 20
    drawing.Outline = true
    drawing.Color = color
    drawing.Position = position
    drawing.Visible = false
    return drawing
end

local function newLine(color, thickness)
    local drawing = Drawing.new("Line")
    drawing.Color = color
    drawing.Thickness = thickness
    drawing.Visible = false
    return drawing
end

local function newCircle(color)
    local drawing = Drawing.new("Circle")
    drawing.Color = color
    drawing.Radius = 4
    drawing.Filled = true
    drawing.Visible = false
    return drawing
end

drawings.murderer = newText(Color3.fromRGB(255, 70, 70), Vector2.new(10, 740))
drawings.sheriff = newText(Color3.fromRGB(50, 255, 255), Vector2.new(10, 770))
drawings.gunDrop = Drawing.new("Square")
drawings.gunDrop.Color = Color3.fromRGB(255, 230, 0)
drawings.gunDrop.Filled = false
drawings.gunDrop.Thickness = 2
drawings.gunDrop.Visible = false
drawings.trailLink = newLine(visualStyle.linkColor, 3)
drawings.pathStart = newCircle(Color3.fromRGB(80, 255, 120))
drawings.pathEnd = newCircle(Color3.fromRGB(255, 80, 80))
drawings.predictionPoint = newCircle(Color3.fromRGB(80, 255, 120))
drawings.predictionPoint.Radius = 6
drawings.predictionLead = newLine(Color3.fromRGB(255, 210, 40), 2)

local function findGunDrop()
    for _, object in ipairs(Workspace:GetChildren()) do
        local gunDrop = object:FindFirstChild("GunDrop")
        if gunDrop then
            return gunDrop
        end
    end
    return nil
end

local function updateRoles()
    if not state.roles then
        setVisible(drawings.murderer, false)
        setVisible(drawings.sheriff, false)
        return
    end

    local murdererName = "Unknown"
    local sheriffName = "Unknown"
    for _, targetPlayer in ipairs(Players:GetChildren()) do
        local backpack = targetPlayer:FindFirstChild("Backpack")
        local character = targetPlayer.Character or Workspace:FindFirstChild(targetPlayer.Name)
        if (backpack and backpack:FindFirstChild("Knife")) or (character and character:FindFirstChild("Knife")) then
            murdererName = targetPlayer.Name
        end
        if (backpack and backpack:FindFirstChild("Gun")) or (character and character:FindFirstChild("Gun")) then
            sheriffName = targetPlayer.Name
        end
    end

    drawings.murderer.Text = "Murderer: " .. murdererName
    drawings.sheriff.Text = "Sheriff: " .. sheriffName
    drawings.murderer.Visible = true
    drawings.sheriff.Visible = true
end

local function updateGunDropEsp()
    if not state.gunDropEsp then
        drawings.gunDrop.Visible = false
        return
    end

    local gunDrop = visualCache.gunDrop
    if not gunDrop or not gunDrop.Parent or not gunDrop:IsA("BasePart") then
        drawings.gunDrop.Visible = false
        return
    end

    local screenPosition, onScreen = WorldToScreen(gunDrop.Position)
    if screenPosition and onScreen then
        drawings.gunDrop.Position = Vector2.new(screenPosition.X - 10, screenPosition.Y - 10)
        drawings.gunDrop.Size = Vector2.new(20, 20)
        drawings.gunDrop.Visible = true
    else
        drawings.gunDrop.Visible = false
    end
end

local function grabGun()
    local gunDrop = findGunDrop()
    local character = LocalPlayer and (LocalPlayer.Character or Workspace:FindFirstChild(LocalPlayer.Name))
    local root = character and character:FindFirstChild("HumanoidRootPart")
    if not gunDrop or not root or not gunDrop:IsA("BasePart") then
        return
    end

    local returnPosition = root.Position
    root.Position = gunDrop.Position
    task.wait()
    root.Position = returnPosition
end

local function fireKillAll()
    local localCharacter = LocalPlayer and (LocalPlayer.Character or Workspace:FindFirstChild(LocalPlayer.Name))
    local knife = localCharacter and localCharacter:FindFirstChild("Knife")
    local events = knife and knife:FindFirstChild("Events")
    local handleTouched = events and events:FindFirstChild("HandleTouched")
    if not handleTouched then
        return 0
    end

    local fired = 0
    for _, targetPlayer in ipairs(Players:GetChildren()) do
        local whitelisted = killAllWhitelist[string.lower(tostring(targetPlayer.Name))] == true
        if targetPlayer ~= LocalPlayer and targetPlayer:IsA("Player") and not whitelisted then
            local targetCharacter = targetPlayer.Character or Workspace:FindFirstChild(targetPlayer.Name)
            local targetRoot = targetCharacter and targetCharacter:FindFirstChild("HumanoidRootPart")
            if targetRoot then
                local ok = pcall(function()
                    handleTouched:FireServer(targetRoot)
                end)
                if ok then
                    fired = fired + 1
                end
            end
        end
    end

    return fired
end

local function scanMurdererRoot()
    for _, targetPlayer in ipairs(Players:GetChildren()) do
        if targetPlayer ~= LocalPlayer and targetPlayer:IsA("Player") then
            local character = targetPlayer.Character or Workspace:FindFirstChild(targetPlayer.Name)
            local backpack = targetPlayer:FindFirstChild("Backpack")
            local hasKnife = (backpack and backpack:FindFirstChild("Knife"))
                or (character and character:FindFirstChild("Knife"))
            local root = character and character:FindFirstChild("HumanoidRootPart")
            if hasKnife and root and root:IsA("BasePart") then
                return root
            end
        end
    end

    return nil
end

local function getMurdererRoot()
    local root = visualCache.murdererRoot
    if root and root.Parent then
        return root
    end

    root = scanMurdererRoot()
    visualCache.murdererRoot = root
    return root
end

local function getTargetVelocity(root)
    local velocity
    local ok = pcall(function()
        velocity = root.AssemblyLinearVelocity
    end)
    if not ok or typeof(velocity) ~= "Vector3" then
        pcall(function()
            velocity = root.Velocity
        end)
    end

    if typeof(velocity) ~= "Vector3" then
        return Vector3.new(0, 0, 0)
    end
    return velocity
end

local function getPredictionSeconds()
    local pingMs = 0
    if type(GetPingValue) == "function" then
        local ok, value = pcall(GetPingValue)
        if ok then
            pingMs = tonumber(value) or 0
        end
    end

    -- The observed target and the outgoing shot together are about one RTT behind.
    return math.clamp(((pingMs / 1000) * 1.35) + 0.025, 0.025, 0.35)
end

local function getPredictedTargetPosition(targetRoot)
    local displacement = getTargetVelocity(targetRoot) * getPredictionSeconds()
    if displacement.Magnitude > 30 then
        displacement = displacement.Unit * 30
    end
    return targetRoot.Position + displacement
end

local function firePredictionSilentAim()
    local targetRoot = getMurdererRoot()
    local character = LocalPlayer and (LocalPlayer.Character or Workspace:FindFirstChild(LocalPlayer.Name))
    local characterRoot = character and character:FindFirstChild("HumanoidRootPart")
    local gun = character and character:FindFirstChild("Gun")
    local shoot = gun and gun:FindFirstChild("Shoot")
    local handle = gun and gun:FindFirstChild("Handle")
    if not targetRoot or not characterRoot or not shoot then
        return false
    end

    local origin = (handle and handle:IsA("BasePart")) and handle.Position or characterRoot.Position
    local predicted = getPredictedTargetPosition(targetRoot)
    return pcall(function()
        shoot:FireServer(
            CFrame.new(origin.X, origin.Y, origin.Z),
            CFrame.new(predicted.X, predicted.Y, predicted.Z)
        )
    end)
end

local function updateCoinAura()
    if not state.coinAura then
        return
    end

    local targetSize = Vector3.new(9, 9, 9)
    for _, map in ipairs(Workspace:GetChildren()) do
        local coinContainer = map:FindFirstChild("CoinContainer")
        if coinContainer then
            for _, coinServer in ipairs(coinContainer:GetChildren()) do
                if coinServer.Name == "Coin_Server" then
                    pcall(function()
                        coinServer.Size = targetSize
                    end)
                end
            end
        end
    end
end

local function objectKey(object)
    local ok, address = pcall(function()
        return object.Address
    end)
    if ok and address and address ~= 0 then
        return tostring(address)
    end
    return tostring(object)
end

local function project(position)
    local point, onScreen = WorldToScreen(position)
    if typeof(point) == "Vector2" then
        return point, onScreen ~= false
    end
    if typeof(point) == "Vector3" then
        return Vector2.new(point.X, point.Y), onScreen ~= false and point.Z > 0
    end
    return nil, false
end

local function updatePredictionMarker()
    if not state.predictionSilentAim then
        drawings.predictionPoint.Visible = false
        drawings.predictionLead.Visible = false
        return
    end

    local targetRoot = visualCache.murdererRoot
    if not targetRoot or not targetRoot.Parent then
        drawings.predictionPoint.Visible = false
        drawings.predictionLead.Visible = false
        return
    end

    local currentPoint, currentVisible = project(targetRoot.Position)
    local predictedPoint, predictedVisible = project(getPredictedTargetPosition(targetRoot))
    if predictedPoint and predictedVisible then
        drawings.predictionPoint.Position = predictedPoint
        drawings.predictionPoint.Visible = true
    else
        drawings.predictionPoint.Visible = false
    end

    if currentPoint and predictedPoint and currentVisible and predictedVisible then
        drawings.predictionLead.From = currentPoint
        drawings.predictionLead.To = predictedPoint
        drawings.predictionLead.Visible = true
    else
        drawings.predictionLead.Visible = false
    end
end

local function hideBox(lines)
    if lines then
        for i = 1, 4 do
            setVisible(lines[i], false)
        end
    end
end

local function removeBox(key)
    local lines = drawings.boxes[key]
    if lines then
        for i = 1, 4 do
            safeRemove(lines[i])
        end
    end
    drawings.boxes[key] = nil
end

local function ensureBox(key)
    local lines = drawings.boxes[key]
    if not lines then
        lines = {}
        for i = 1, 4 do
            lines[i] = newLine(visualStyle.partColor, visualStyle.boxThickness)
        end
        drawings.boxes[key] = lines
    end
    return lines
end

local function drawRectangle(lines, minX, minY, maxX, maxY, color, thickness)
    lines[1].From = Vector2.new(minX, minY)
    lines[1].To = Vector2.new(maxX, minY)
    lines[2].From = Vector2.new(maxX, minY)
    lines[2].To = Vector2.new(maxX, maxY)
    lines[3].From = Vector2.new(maxX, maxY)
    lines[3].To = Vector2.new(minX, maxY)
    lines[4].From = Vector2.new(minX, maxY)
    lines[4].To = Vector2.new(minX, minY)
    for i = 1, 4 do
        lines[i].Color = color
        lines[i].Thickness = thickness
        lines[i].Visible = true
    end
end

local function getObjectBoxOffsets(object)
    if object.Name == "TrailPart" then
        return nil
    end

    local half = object.Size * 0.5
    return {
        Vector3.new(-half.X, -half.Y, -half.Z), Vector3.new(-half.X, -half.Y, half.Z),
        Vector3.new(-half.X, half.Y, -half.Z), Vector3.new(-half.X, half.Y, half.Z),
        Vector3.new(half.X, -half.Y, -half.Z), Vector3.new(half.X, -half.Y, half.Z),
        Vector3.new(half.X, half.Y, -half.Z), Vector3.new(half.X, half.Y, half.Z)
    }
end

local function drawObjectBox(object, lines, offsets)
    if object.Name == "TrailPart" then
        local center, visible = project(object.Position)
        if not center or not visible then
            hideBox(lines)
            return
        end
        local half = 10
        drawRectangle(lines, center.X - half, center.Y - half, center.X + half, center.Y + half, visualStyle.trailColor, visualStyle.boxThickness)
        return
    end

    if not offsets then
        hideBox(lines)
        return
    end
    local minX, minY = math.huge, math.huge
    local maxX, maxY = -math.huge, -math.huge
    local visibleCount = 0
    for i = 1, #offsets do
        local point, visible = project(object.Position + offsets[i])
        if point and visible then
            visibleCount = visibleCount + 1
            minX = math.min(minX, point.X)
            minY = math.min(minY, point.Y)
            maxX = math.max(maxX, point.X)
            maxY = math.max(maxY, point.Y)
        end
    end

    if visibleCount >= 2 and maxX > minX and maxY > minY then
        drawRectangle(lines, minX, minY, maxX, maxY, visualStyle.partColor, visualStyle.boxThickness)
    else
        hideBox(lines)
    end
end

local function ensurePathLines(count)
    for i = 1, count do
        if not drawings.pathLines[i] then
            drawings.pathLines[i] = newLine(visualStyle.pathColor, visualStyle.pathThickness)
        end
    end
    for i = count + 1, #drawings.pathLines do
        drawings.pathLines[i].Visible = false
    end
end

local function updateTrailPath(trailParts)
    if #trailParts < 2
        or not trailParts[1].Parent
        or not trailParts[#trailParts].Parent then
        for i = 1, #drawings.pathLines do
            drawings.pathLines[i].Visible = false
        end
        drawings.pathStart.Visible = false
        drawings.pathEnd.Visible = false
        return
    end

    ensurePathLines(#trailParts - 1)
    for i = 1, #trailParts - 1 do
        local line = drawings.pathLines[i]
        local fromPart = trailParts[i]
        local toPart = trailParts[i + 1]
        if fromPart.Parent and toPart.Parent then
            local from, fromVisible = project(fromPart.Position)
            local to, toVisible = project(toPart.Position)
            line.Color = visualStyle.pathColor
            line.Thickness = visualStyle.pathThickness
            if from and to and fromVisible and toVisible then
                line.From = from
                line.To = to
                line.Visible = true
            else
                line.Visible = false
            end
        else
            line.Visible = false
        end
    end

    local startPoint, startVisible = project(trailParts[1].Position)
    local endPoint, endVisible = project(trailParts[#trailParts].Position)
    if startPoint and startVisible then
        drawings.pathStart.Position = startPoint
        drawings.pathStart.Visible = true
    else
        drawings.pathStart.Visible = false
    end
    if endPoint and endVisible then
        drawings.pathEnd.Position = endPoint
        drawings.pathEnd.Visible = true
    else
        drawings.pathEnd.Visible = false
    end
end

local function updateTrailLink(parts)
    if #parts < 2 or not parts[1].Parent or not parts[2].Parent then
        drawings.trailLink.Visible = false
        return
    end

    local firstPoint, firstVisible = project(parts[1].Position)
    local secondPoint, secondVisible = project(parts[2].Position)
    if firstPoint and secondPoint and firstVisible and secondVisible then
        drawings.trailLink.From = firstPoint
        drawings.trailLink.To = secondPoint
        drawings.trailLink.Color = visualStyle.linkColor
        drawings.trailLink.Visible = true
    else
        drawings.trailLink.Visible = false
    end
end

local function hideVisuals()
    for _, lines in pairs(drawings.boxes) do
        hideBox(lines)
    end
    drawings.trailLink.Visible = false
    drawings.pathStart.Visible = false
    drawings.pathEnd.Visible = false
    ensurePathLines(0)
end

local function updateVisuals()
    if not state.visuals then
        hideVisuals()
        return
    end

    for i = 1, #visualCache.objects do
        local entry = visualCache.objects[i]
        local object = entry.object
        local lines = drawings.boxes[entry.key]
        if object and object.Parent and lines then
            drawObjectBox(object, lines, entry.offsets)
        elseif lines then
            hideBox(lines)
        end
    end

    updateTrailLink(visualCache.parts)
    updateTrailPath(visualCache.trailParts)
end

local function refreshVisualCache()
    local workspaceChildren = nil
    if state.gunDropEsp or state.visuals then
        workspaceChildren = Workspace:GetChildren()
    end

    if state.gunDropEsp then
        local gunDrop = nil
        for _, object in ipairs(workspaceChildren) do
            gunDrop = object:FindFirstChild("GunDrop")
            if gunDrop then
                break
            end
        end
        visualCache.gunDrop = gunDrop
    else
        visualCache.gunDrop = nil
    end

    if state.predictionSilentAim then
        visualCache.murdererRoot = scanMurdererRoot()
    else
        visualCache.murdererRoot = nil
    end

    if not state.visuals then
        visualCache.objects = {}
        visualCache.parts = {}
        visualCache.trailParts = {}
        for key in pairs(drawings.boxes) do
            removeBox(key)
        end
        return
    end

    local live = {}
    local objects = {}
    local parts = {}
    local trailParts = {}
    for _, object in ipairs(workspaceChildren) do
        if object.Name == "Part" or object.Name == "TrailPart" then
            local key = objectKey(object)
            live[key] = true
            objects[#objects + 1] = {
                key = key,
                object = object,
                offsets = getObjectBoxOffsets(object)
            }
            ensureBox(key)

            if object.Name == "Part" then
                parts[#parts + 1] = object
            else
                trailParts[#trailParts + 1] = object
            end
        end
    end

    for key in pairs(drawings.boxes) do
        if not live[key] then
            removeBox(key)
        end
    end

    visualCache.objects = objects
    visualCache.parts = parts
    visualCache.trailParts = trailParts
    ensurePathLines(math.max(#trailParts - 1, 0))
end

UI.AddTab("Artorias", function(tab)
    local gameplay = tab:Section("Gameplay", "Left")
    gameplay:Toggle("mm2_coin_aura", "Coin Aura", false, function(value)
        state.coinAura = value == true
        if state.coinAura then
            updateCoinAura()
        end
    end)

    gameplay:Toggle("mm2_gun_grab", "Grab Dropped Gun", false, function(value)
        state.gunGrab = value == true
    end)
    widgets.gunGrab = gameplay:Keybind("mm2_gun_grab_key", 0x2E, "hold")
    addHotkey(widgets.gunGrab, "Grab Gun", "mm2_gun_grab")

    gameplay:Toggle("mm2_kill_all", "Kill All", false, function(value)
        state.killAll = value == true
    end)
    widgets.killAll = gameplay:Keybind("mm2_kill_all_key", 0x24, "hold")
    addHotkey(widgets.killAll, "Kill All", "mm2_kill_all")

    gameplay:Toggle("mm2_prediction_silent_aim", "Prediction Silent Aim", false, function(value)
        state.predictionSilentAim = value == true
        if state.predictionSilentAim then
            refreshVisualCache()
        end
    end)
    widgets.predictionSilentAim = gameplay:Keybind("mm2_prediction_silent_aim_key", 0x42, "hold")
    addHotkey(widgets.predictionSilentAim, "Prediction Silent Aim", "mm2_prediction_silent_aim")

    gameplay:Toggle("mm2_debris", "Become Debris", false, function(value)
        state.debrisEnabled = value == true
        if not state.debrisEnabled and state.debrisActive then
            setDebrisActive(false)
        end
    end)
    widgets.debris = gameplay:Keybind("mm2_debris_key", 0x73, "hold")
    addHotkey(widgets.debris, "Become Debris", "mm2_debris")

    local information = tab:Section("Information", "Left")
    information:Toggle("mm2_roles", "Murderer / Sheriff", false, function(value)
        state.roles = value == true
    end)

    local visuals = tab:Section("Visuals", "Right")
    visuals:Toggle("mm2_gun_drop_esp", "Dropped Gun ESP", false, function(value)
        state.gunDropEsp = value == true
        if state.gunDropEsp then
            refreshVisualCache()
        end
    end)
    visuals:Toggle("mm2_visuals", "Knife & Gun Visuals", false, function(value)
        state.visuals = value == true
        if state.visuals then
            refreshVisualCache()
        end
    end)
end)

task.spawn(function()
    local lastGunGrabActive = false
    local lastSilentAimActive = false
    local nextCoinAuraAt = 0
    local nextDebrisAt = 0
    local nextRoleCheckAt = 0
    local nextKillAllAt = 0

    while true do
        local now = os.clock()

        if now >= nextCoinAuraAt then
            if state.coinAura then
                updateCoinAura()
                nextCoinAuraAt = now + 0.75
            else
                nextCoinAuraAt = now + 1.5
            end
        end

        if now >= nextDebrisAt then
            local debrisActive = state.debrisEnabled and keybindActive(widgets.debris)
            if debrisActive ~= state.debrisActive then
                setDebrisActive(debrisActive)
            elseif debrisActive then
                setGravity(0)
                setSit(true)
            end
            nextDebrisAt = now + 0.15
        end

        if now >= nextRoleCheckAt then
            updateRoles()
            nextRoleCheckAt = now + 1.25
        end

        local gunGrabActive = state.gunGrab and keybindActive(widgets.gunGrab)
        if gunGrabActive and not lastGunGrabActive then
            grabGun()
        end
        lastGunGrabActive = gunGrabActive

        local killAllActive = state.killAll and keybindActive(widgets.killAll)
        if killAllActive and now >= nextKillAllAt then
            fireKillAll()
            nextKillAllAt = now + 0.25
        end

        local silentAimActive = state.predictionSilentAim and keybindActive(widgets.predictionSilentAim)
        if silentAimActive and not lastSilentAimActive then
            firePredictionSilentAim()
        end
        lastSilentAimActive = silentAimActive

        task.wait(0.05)
    end
end)

task.spawn(function()
    while true do
        refreshVisualCache()
        local active = state.gunDropEsp
            or state.visuals
            or state.predictionSilentAim
        task.wait(active and 0.5 or 1.5)
    end
end)

task.spawn(function()
    while true do
        local active = state.gunDropEsp
            or state.visuals
            or state.predictionSilentAim

        if active then
            updateGunDropEsp()
            updateVisuals()
            updatePredictionMarker()
            task.wait(0.01)
        else
            drawings.gunDrop.Visible = false
            drawings.predictionPoint.Visible = false
            drawings.predictionLead.Visible = false
            hideVisuals()
            task.wait(0.2)
        end
    end
end)

printl("Artorias initialized")
