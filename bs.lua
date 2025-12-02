-- =====================================   BLOCKSPIN  ==================================================
-- =====================================================================================================
--
-- THE SUPPORTED WEAPONS ARE LISTED BELOW
-- - Uzi 
-- - P226  
-- - Remington  
-- - RPG  
-- - Firework Launcher  
-- - M24  
-- - Hunting Rifle  
-- - Glock  
-- - Crossbow
-- - C9  
-- - Sawnoff  
-- - Anaconda  
-- - Draco  
-- - Double Barrel  
-- - AK47  
-- - M16  
-- G3 
-- -MP5  
-- Skorpion 
--
--  Melee Weapons supported include:
-- - Barbed Baseball Bat
-- - Combat Axe              
-- - Valuable Knife
-- - Tactical Shovel
-- - Metal Baseball Bat      
-- - Tactical Knife
-- - Axe                     
-- - Tactical Axe
-- - Butcher Knife
-- - Baseball Bat            
-- =====================================================================================================

local UPDATE_INTERVAL = 0.1 
local INVENTORY_TEXT_POSITION = Vector2.new(10, 355)
local INVENTORY_TEXT_COLOR = Color3.new(1, 1, 1) 
local DEFAULT_ESP_COLOR = Color3.new(1, 0, 0) 

local ITEM_DATABASE = {
    -- weapons (uses meshpart matching)
    {meshPattern = "c9_cube", displayName = "C9", color = DEFAULT_ESP_COLOR, isPrefix = true},
    {meshPattern = "glock_colt45", displayName = "Glock", color = DEFAULT_ESP_COLOR, isPrefix = true},
    {meshPattern = "uzi_cube", displayName = "UZI", color = DEFAULT_ESP_COLOR, isPrefix = true},
    {meshPattern = "m24_cube", displayName = "M24", color = DEFAULT_ESP_COLOR, isPrefix = true},
    {meshPattern = "revolver anaconda_cube", displayName = "Anaconda", color = DEFAULT_ESP_COLOR, isPrefix = true},
    {meshPattern = "mp5_cube", displayName = "MP5", color = DEFAULT_ESP_COLOR, isPrefix = true},
    {meshPattern = "firework launcher_cylinder", displayName = "FireworkL", color = DEFAULT_ESP_COLOR, isPrefix = true},
    {meshPattern = "remington_cube", displayName = "RemingtonSG", color = DEFAULT_ESP_COLOR, isPrefix = true},
    {meshPattern = "double barrel shotgun_cube", displayName = "Double/Sawnoff", color = DEFAULT_ESP_COLOR, isPrefix = true},
    {meshPattern = "rpg_cube", displayName = "RPG", color = DEFAULT_ESP_COLOR, isPrefix = true},
    {meshPattern = "p226_cube", displayName = "P226", color = DEFAULT_ESP_COLOR, isPrefix = true},
    {meshPattern = "huntingrifle_cube", displayName = "HuntingR", color = DEFAULT_ESP_COLOR, isPrefix = true},
    {meshPattern = "g3_cube", displayName = "G3", color = DEFAULT_ESP_COLOR, isPrefix = true},
    {meshPattern = "draco_cube", displayName = "Draco", color = DEFAULT_ESP_COLOR, isPrefix = true},
    {meshPattern = "ak47_cube", displayName = "AK47", color = DEFAULT_ESP_COLOR, isPrefix = true},
    {meshPattern = "crossbox_cube", displayName = "Crossbow", color = DEFAULT_ESP_COLOR, isPrefix = true},
    {meshPattern = "m16 aug_Cube", displayName = "Skorpion", color = DEFAULT_ESP_COLOR, isPrefix = true},
    {meshPattern = "aug_Cube", displayName = "M16", color = DEFAULT_ESP_COLOR, isPrefix = true},

	-- melees (uses meshpart matching)
    {meshPattern = "new melees_cylinder.002", displayName = "Sledge Hammer", color = Color3.new(1, 165/255, 0)},
    {meshPattern = "weapon tools_cylinder.005", displayName = "Shovel", color = Color3.new(1, 165/255, 0)},
    {meshPattern = "weapon tools_cube.005", displayName = "Machete", color = Color3.new(1, 165/255, 0)},
    {meshPattern = "weapon tools_cylinder", displayName = "Crowbar", color = Color3.new(1, 165/255, 0)},
    {meshPattern = "new melees_plane.003", displayName = "Butcher Knife", color = Color3.new(1, 165/255, 0)},
    {meshPattern = "weapon tools_cube.001", displayName = "Wrench", color = Color3.new(1, 165/255, 0)},
    {meshPattern = "new melees_cylinder.004", displayName = "Tactical Shovel", color = Color3.new(1, 1, 0)},
    {meshPattern = "new melees_plane.005", displayName = "Tactical Knife", color = Color3.new(1, 1, 0)},
    {meshPattern = "new melees_plane", displayName = "Tactical Axe", color = Color3.new(1, 1, 0)},
    {meshPattern = "weapon tools_cube.006", displayName = "Switchblade", color = Color3.new(1, 165/255, 0)},
    {meshPattern = "weapon tools_1.001", displayName = "Barbed Bat", color = Color3.new(1, 0, 0)}, 
    {meshPattern = "1a_Plane", displayName = "Combat Axe", color = Color3.new(1, 0, 0), isPrefix = true}
}

local displaytextinv = nil
local activeItemDrawings = {} 

local function refreshinventory()
    local localPlayer = game.Players.LocalPlayer
    if not localPlayer or not localPlayer.Character or not localPlayer.Character:FindFirstChild("HumanoidRootPart") then
        if displaytextinv then
            displaytextinv.Text = "Waiting for player character"
        end
        return
    end

    if not displaytextinv then
        local success, err = pcall(function()
            displaytextinv = Drawing.new("Text")
            if not displaytextinv then
                warn("Drawing.new(\"Text\") returned nil or invalid object.")
            end
            displaytextinv.Visible = true
            displaytextinv.Position = INVENTORY_TEXT_POSITION
            displaytextinv.Color = INVENTORY_TEXT_COLOR
        end)

        if not success then
            warn("Inventory: creating/setting Drawing object: " .. err)
            displaytextinv = nil
            return
        end
    end

    local scansucceed, scanerror = pcall(function()
        local DISPLAYENTRIES = {}
        local ALLPLAYERS = game.Players:GetChildren()
       

        for _, instance in ipairs(ALLPLAYERS) do
            if not instance:IsA("Player") then
                continue
            end
            local player = instance
            local playerName = player.Name
            local SETITEMSFORPLAYER = {}
            local ITEMTODISPLAY = {}

            local ITEMTOCHECK = {}

            local backpack = player:FindFirstChild("Backpack")
            if backpack then
                for _, tool in ipairs(backpack:GetChildren()) do
                    if tool:IsA("Tool") then
                        table.insert(ITEMTOCHECK, tool)
                    end
                end
            end

            local character = player.Character
            if character then
                for _, child in ipairs(character:GetChildren()) do
                    if child:IsA("Tool") then
                        table.insert(ITEMTOCHECK, child)
                    end
                end
            end

            for _, tool in ipairs(ITEMTOCHECK) do
                local toolIdentified = false

                for _, potentialpart in ipairs(tool:GetChildren()) do
                    local partnick = potentialpart.Name
                    local meshesprefixing = "Meshes/"

                    if string.sub(partnick, 1, #meshesprefixing) == meshesprefixing then
                        local nameAfterPrefix = string.sub(partnick, #meshesprefixing + 1)
                        local meshnamesearch = string.lower(nameAfterPrefix)

                        for _, itemEntry in ipairs(ITEM_DATABASE) do
                            local dbMeshPattern = string.lower(itemEntry.meshPattern)
                            local matched = false

                            if itemEntry.isPrefix then
                                if string.sub(meshnamesearch, 1, #dbMeshPattern) == dbMeshPattern then
                                    matched = true
                                end
                            else
                                if meshnamesearch == dbMeshPattern then
                                    matched = true
                                end
                            end

                            if matched then
                                if not SETITEMSFORPLAYER[itemEntry.displayName] then
                                    SETITEMSFORPLAYER[itemEntry.displayName] = true
                                    table.insert(ITEMTODISPLAY, "- " .. itemEntry.displayName)
                                end
                                toolIdentified = true
                                break 
                            end
                        end
                    elseif partnick == "Butt" then
                        if not SETITEMSFORPLAYER["Axe"] then
                            SETITEMSFORPLAYER["Axe"] = true
                            table.insert(ITEMTODISPLAY, "- Axe")
                        end
                        toolIdentified = true
                    elseif partnick == "Bat" then
                        if not SETITEMSFORPLAYER["Bat"] then
                            SETITEMSFORPLAYER["Bat"] = true
                            table.insert(ITEMTODISPLAY, "- Bat")
                        end
                        toolIdentified = true
                    end

                    if toolIdentified then
                        break
                    end
                end
            end

            if #ITEMTODISPLAY > 0 then
                table.insert(DISPLAYENTRIES, playerName .. ":\n" .. table.concat(ITEMTODISPLAY, "\n"))
            end
        end

        local fullDisplayString = table.concat(DISPLAYENTRIES, "\n\n")
        if displaytextinv then
            if fullDisplayString == "" then
                displaytextinv.Text = " "
            else
                displaytextinv.Text = fullDisplayString
            end
        else
            warn("Inventory: displaytextinv is nil, cannot set text after scan.")
        end
    end)

    if not scansucceed then
        warn("Inventory: ERROR during player/item scanning: " .. scanerror)
        if displaytextinv then
            displaytextinv.Text = "Error scanning inventory: " .. scanerror
        end
    end
end

local function REFRESHDROPPEDITEMS()
    local localPlayer = game.Players.LocalPlayer
    if not localPlayer or not localPlayer.Character or not localPlayer.Character:FindFirstChild("HumanoidRootPart") then
        for modelInstance, textObject in pairs(activeItemDrawings) do
            textObject.Visible = false
        end
        return
    end

    local playerChar = localPlayer.Character
    local playerRootPart = playerChar:FindFirstChild("HumanoidRootPart")
    if not playerRootPart then return end

    local playerPos = playerRootPart.Position

    local ITEMSFOLDER = workspace:FindFirstChild("DroppedItems")
    local DROPPEDMODEL = {}

    if ITEMSFOLDER then
        for _, modelInstance in ipairs(ITEMSFOLDER:GetChildren()) do
            DROPPEDMODEL[modelInstance] = true
        end
    end

    for modelInstance, textObject in pairs(activeItemDrawings) do
        if not DROPPEDMODEL[modelInstance] then
            textObject:Remove()
            activeItemDrawings[modelInstance] = nil
        end
    end

    for modelInstance in pairs(DROPPEDMODEL) do
        local DISPLAYTHEITEM = false
        local iPos = nil
        local sPos = Vector2.new(0,0)
        local oScn = false

        local pickUpZone = modelInstance:FindFirstChild("PickUpZone")
        if pickUpZone and pickUpZone.Position then
            iPos = pickUpZone.Position
            sPos, oScn = WorldToScreen(iPos)
            if oScn then
                DISPLAYTHEITEM = true
            end
        end

        if DISPLAYTHEITEM then
            local itemdisplay2 = nil
            local itemcolor2 = nil
            local modelName = modelInstance.Name

            if modelName == "HackToolPro" then
                itemdisplay2 = "HackTool Pro"
                itemcolor2 = Color3.new(51/255, 153/255, 255/255)
            elseif modelName == "HackToolUltimate" then
                itemdisplay2 = "HackTool Ultimate"
                itemcolor2 = Color3.new(255/255, 51/255, 51/255)
            elseif modelName == "HackToolQuantum" then
                itemdisplay2 = "HackTool Quantum"
                itemcolor2 = Color3.new(166/255, 166/255, 166/255)
            end

            if not itemdisplay2 then
                local itemIdentified = false
                local modelChildren = modelInstance:GetChildren()
                for _, partInstance in ipairs(modelChildren) do
                    local partnick = partInstance.Name
                    local meshesprefixing = "Meshes/"

                    if string.sub(partnick, 1, #meshesprefixing) == meshesprefixing then
                        local nameAfterPrefix = string.sub(partnick, #meshesprefixing + 1)
                        local meshnamesearch = string.lower(nameAfterPrefix)

                        for _, dbEntry in ipairs(ITEM_DATABASE) do
                            local dbMeshPattern = string.lower(dbEntry.meshPattern)
                            local matched = false

                            if dbEntry.isPrefix then
                                if string.sub(meshnamesearch, 1, #dbMeshPattern) == dbMeshPattern then
                                    matched = true
                                end
                            else
                                if meshnamesearch == dbMeshPattern then
                                    matched = true
                                end
                            end

                            if matched then
                                itemdisplay2 = dbEntry.displayName
                                itemcolor2 = dbEntry.color
                                itemIdentified = true
                                break
                            end
                        end
                    elseif partnick == "Bat" then
                        itemdisplay2 = "Bat"
                        itemcolor2 = DEFAULT_ESP_COLOR
                        itemIdentified = true
                    elseif partnick == "Butt" then
                        itemdisplay2 = "Axe"
                        itemcolor2 = Color3.new(1, 0, 0) 
                        itemIdentified = true
                    end

                    if itemIdentified then
                        break 
                    end
                end
            end

            if itemdisplay2 then
                local distanceText = " (Dist Error)"
                local dX, dY, dZ = playerPos.X - iPos.X, playerPos.Y - iPos.Y, playerPos.Z - iPos.Z
                local distance = math.sqrt(dX*dX + dY*dY + dZ*dZ)
                distanceText = string.format(" (%.1fm)", distance)

                local itemInfoText = itemdisplay2 .. distanceText
                local textColor = itemcolor2 or DEFAULT_ESP_COLOR

                local textobjectcurrent = activeItemDrawings[modelInstance]
                if textobjectcurrent then
                    textobjectcurrent.Position = sPos
                    textobjectcurrent.Text = itemInfoText
                    textobjectcurrent.Color = textColor
                    textobjectcurrent.Visible = true
                else
                    local newTextObject = Drawing.new("Text")
                    if newTextObject then
                        newTextObject.Text = itemInfoText
                        newTextObject.Position = sPos
                        newTextObject.Color = textColor
                        newTextObject.Visible = true
                        activeItemDrawings[modelInstance] = newTextObject
                    end
                end
            else
                if activeItemDrawings[modelInstance] then
                    activeItemDrawings[modelInstance].Visible = false
                end
            end
        else
            if activeItemDrawings[modelInstance] then
                activeItemDrawings[modelInstance]:Remove()
                activeItemDrawings[modelInstance] = nil
            end
        end
    end
end

local function main()
    wait(1)

    while true do
        pcall(refreshinventory)
        pcall(REFRESHDROPPEDITEMS)
        wait(UPDATE_INTERVAL)
    end
end

main()
