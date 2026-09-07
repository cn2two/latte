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
-- - G3
-- - MP5
-- - Skorpion
-- - M249
--
-- Melee Weapons supported include:
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
local INVENTORY_LINE_HEIGHT = 16
local INVENTORY_PLAYER_GAP = 8

-- rarity colors
local GREEN = Color3.fromRGB(75, 220, 45)
local BLUE = Color3.fromRGB(65, 160, 255)
local EPIC = Color3.fromRGB(215, 70, 245)
local ORANGE = Color3.fromRGB(255, 165, 30)
local RED = Color3.fromRGB(255, 50, 75)

local DEFAULT_ESP_COLOR = RED

local ITEM_DATABASE = {
    -- weapons
    {
        meshPattern = "c9_cube",
        displayName = "C9",
        color = GREEN,
        isPrefix = true
    },

    {
        meshPattern = "glock_colt45",
        displayName = "Glock",
        color = BLUE,
        isPrefix = true
    },

    {
        meshPattern = "uzi_cube",
        displayName = "UZI",
        color = BLUE,
        isPrefix = true
    },

    {
        meshPattern = "m24_cube",
        displayName = "M24",
        color = EPIC,
        isPrefix = true
    },

    {
        meshPattern = "revolver anaconda_cube",
        displayName = "Anaconda",
        color = RED,
        isPrefix = true
    },

    {
        meshPattern = "mp5_cube",
        displayName = "MP5",
        color = ORANGE,
        isPrefix = true
    },

    {
        meshPattern = "firework launcher_cylinder",
        displayName = "FireworkL",
        color = EPIC,
        isPrefix = true
    },

    {
        meshPattern = "remington_cube",
        displayName = "RemingtonSG",
        color = ORANGE,
        isPrefix = true
    },

    {
        meshPattern = "double barrel shotgun_cube",
        displayName = "Double/Sawnoff",
        color = EPIC,
        isPrefix = true
    },

    {
        meshPattern = "rpg_cube",
        displayName = "RPG",
        color = ORANGE,
        isPrefix = true
    },

    {
        meshPattern = "p226_cube",
        displayName = "P226",
        color = BLUE,
        isPrefix = true
    },

    {
        meshPattern = "huntingrifle_cube",
        displayName = "HuntingR",
        color = BLUE,
        isPrefix = true
    },

    {
        meshPattern = "g3_cube",
        displayName = "G3",
        color = GREEN,
        isPrefix = true
    },

    {
        meshPattern = "draco_cube",
        displayName = "Draco",
        color = EPIC,
        isPrefix = true
    },

    {
        meshPattern = "ak47_cube",
        displayName = "AK47",
        color = ORANGE,
        isPrefix = true
    },

    {
        meshPattern = "crossbox_cube",
        displayName = "Crossbow",
        color = ORANGE,
        isPrefix = true
    },

    -- keep original AUG/M16 detection
    {
        meshPattern = "m16 aug_Cube",
        displayName = "Skorpion",
        color = EPIC,
        isPrefix = true
    },

    {
        meshPattern = "aug_Cube",
        displayName = "M16",
        color = ORANGE,
        isPrefix = true
    },

    -- M249
    {
        meshPattern = "m249_cube.030",
        displayName = "M249",
        color = ORANGE,
        isPrefix = true
    },

    {
        meshPattern = "m249cube030",
        displayName = "M249",
        color = ORANGE,
        isPrefix = true
    },

    -- melees
    {
        meshPattern = "new melees_cylinder.002",
        displayName = "Sledge Hammer",
        color = EPIC
    },

    {
        meshPattern = "weapon tools_cylinder.005",
        displayName = "Shovel",
        color = EPIC
    },

    {
        meshPattern = "weapon tools_cube.005",
        displayName = "Machete",
        color = EPIC
    },

    {
        meshPattern = "weapon tools_cylinder",
        displayName = "Crowbar",
        color = BLUE
    },

    {
        meshPattern = "new melees_plane.003",
        displayName = "Butcher Knife",
        color = BLUE
    },

    {
        meshPattern = "weapon tools_cube.001",
        displayName = "Wrench",
        color = BLUE
    },

    {
        meshPattern = "new melees_cylinder.004",
        displayName = "Tactical Shovel",
        color = ORANGE
    },

    {
        meshPattern = "new melees_plane.005",
        displayName = "Tactical Knife",
        color = ORANGE
    },

    {
        meshPattern = "new melees_plane",
        displayName = "Tactical Axe",
        color = ORANGE
    },

    {
        meshPattern = "weapon tools_cube.006",
        displayName = "Switchblade",
        color = BLUE
    },

    {
        meshPattern = "weapon tools_1.001",
        displayName = "Barbed Bat",
        color = EPIC
    },

    {
        meshPattern = "1a_Plane",
        displayName = "Combat Axe",
        color = EPIC,
        isPrefix = true
    }
}

local inventoryDrawings = {}
local activeItemDrawings = {}

local function createInventoryDrawing()
    local drawing = Drawing.new("Text")

    drawing.Visible = false
    drawing.Position = INVENTORY_TEXT_POSITION
    drawing.Color = INVENTORY_TEXT_COLOR
    drawing.Font = 2
    drawing.Size = 16
    drawing.Outline = true

    return drawing
end

local function getInventoryDrawing(key)
    local drawing = inventoryDrawings[key]

    if not drawing then
        drawing = createInventoryDrawing()
        inventoryDrawings[key] = drawing
    end

    return drawing
end

local function hideInventoryDrawings()
    for _, drawing in pairs(inventoryDrawings) do
        drawing.Visible = false
    end
end

local function refreshinventory()
    local localPlayer = game.Players.LocalPlayer

    if not localPlayer
        or not localPlayer.Character
        or not localPlayer.Character:FindFirstChild("HumanoidRootPart") then

        hideInventoryDrawings()
        return
    end

    local scansucceed, scanerror = pcall(function()
        local inventoryEntries = {}
        local activeKeys = {}

        local ALLPLAYERS = game.Players:GetChildren()

        table.sort(ALLPLAYERS, function(a, b)
            return string.lower(a.Name) < string.lower(b.Name)
        end)

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

                    if string.sub(
                        partnick,
                        1,
                        #meshesprefixing
                    ) == meshesprefixing then

                        local nameAfterPrefix = string.sub(
                            partnick,
                            #meshesprefixing + 1
                        )

                        local meshnamesearch = string.lower(
                            nameAfterPrefix
                        )

                        for _, itemEntry in ipairs(ITEM_DATABASE) do
                            local dbMeshPattern = string.lower(
                                itemEntry.meshPattern
                            )

                            local matched = false

                            if itemEntry.isPrefix then
                                if string.sub(
                                    meshnamesearch,
                                    1,
                                    #dbMeshPattern
                                ) == dbMeshPattern then

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

                                    table.insert(ITEMTODISPLAY, {
                                        name = itemEntry.displayName,
                                        color = itemEntry.color
                                    })
                                end

                                toolIdentified = true
                                break
                            end
                        end

                    elseif partnick == "Butt" then
                        if not SETITEMSFORPLAYER["Axe"] then
                            SETITEMSFORPLAYER["Axe"] = true

                            table.insert(ITEMTODISPLAY, {
                                name = "Axe",
                                color = BLUE
                            })
                        end

                        toolIdentified = true

                    elseif partnick == "Bat" then
                        if not SETITEMSFORPLAYER["Bat"] then
                            SETITEMSFORPLAYER["Bat"] = true

                            table.insert(ITEMTODISPLAY, {
                                name = "Bat",
                                color = BLUE
                            })
                        end

                        toolIdentified = true
                    end

                    if toolIdentified then
                        break
                    end
                end
            end

            if #ITEMTODISPLAY > 0 then
                table.sort(ITEMTODISPLAY, function(a, b)
                    return string.lower(a.name) < string.lower(b.name)
                end)

                table.insert(inventoryEntries, {
                    key = playerName .. ":header",
                    text = playerName .. ":",
                    color = INVENTORY_TEXT_COLOR,
                    header = true
                })

                for _, item in ipairs(ITEMTODISPLAY) do
                    table.insert(inventoryEntries, {
                        key = playerName .. ":" .. item.name,
                        text = "- " .. item.name,
                        color = item.color,
                        header = false
                    })
                end

                table.insert(inventoryEntries, {
                    key = playerName .. ":spacing",
                    text = " ",
                    color = INVENTORY_TEXT_COLOR,
                    spacing = true
                })
            end
        end

        local x = INVENTORY_TEXT_POSITION.X
        local y = INVENTORY_TEXT_POSITION.Y

        for _, entry in ipairs(inventoryEntries) do
            activeKeys[entry.key] = true

            local drawing = getInventoryDrawing(entry.key)

            drawing.Text = entry.text
            drawing.Color = entry.color
            drawing.Position = Vector2.new(x, y)
            drawing.Visible = true

            if entry.spacing then
                y = y + INVENTORY_PLAYER_GAP
            else
                y = y + INVENTORY_LINE_HEIGHT
            end
        end

        for key, drawing in pairs(inventoryDrawings) do
            if not activeKeys[key] then
                drawing:Remove()
                inventoryDrawings[key] = nil
            end
        end
    end)

    if not scansucceed then
        warn(
            "Inventory: ERROR during player/item scanning: "
                .. tostring(scanerror)
        )
    end
end

local function REFRESHDROPPEDITEMS()
    local localPlayer = game.Players.LocalPlayer

    if not localPlayer
        or not localPlayer.Character
        or not localPlayer.Character:FindFirstChild("HumanoidRootPart") then

        for modelInstance, textObject in pairs(activeItemDrawings) do
            textObject.Visible = false
        end

        return
    end

    local playerChar = localPlayer.Character

    local playerRootPart =
        playerChar:FindFirstChild("HumanoidRootPart")

    if not playerRootPart then
        return
    end

    local playerPos = playerRootPart.Position

    local ITEMSFOLDER =
        workspace:FindFirstChild("DroppedItems")

    local DROPPEDMODEL = {}

    if ITEMSFOLDER then
        for _, modelInstance in ipairs(
            ITEMSFOLDER:GetChildren()
        ) do
            DROPPEDMODEL[modelInstance] = true
        end
    end

    for modelInstance, textObject in pairs(
        activeItemDrawings
    ) do
        if not DROPPEDMODEL[modelInstance] then
            textObject:Remove()
            activeItemDrawings[modelInstance] = nil
        end
    end

    for modelInstance in pairs(DROPPEDMODEL) do
        local DISPLAYTHEITEM = false

        local iPos = nil
        local sPos = Vector2.new(0, 0)
        local oScn = false

        local pickUpZone =
            modelInstance:FindFirstChild("PickUpZone")

        if pickUpZone and pickUpZone.Position then
            iPos = pickUpZone.Position

            sPos, oScn =
                WorldToScreen(iPos)

            if oScn then
                DISPLAYTHEITEM = true
            end
        end

        if DISPLAYTHEITEM then
            local itemdisplay2 = nil
            local itemcolor2 = nil

            local modelName =
                modelInstance.Name

            if modelName == "HackToolPro" then
                itemdisplay2 = "HackTool Pro"

                itemcolor2 =
                    Color3.new(
                        51 / 255,
                        153 / 255,
                        255 / 255
                    )

            elseif modelName == "HackToolUltimate" then
                itemdisplay2 =
                    "HackTool Ultimate"

                itemcolor2 =
                    Color3.new(
                        255 / 255,
                        51 / 255,
                        51 / 255
                    )

            elseif modelName == "HackToolQuantum" then
                itemdisplay2 =
                    "HackTool Quantum"

                itemcolor2 =
                    Color3.new(
                        166 / 255,
                        166 / 255,
                        166 / 255
                    )
            end

            if not itemdisplay2 then
                local itemIdentified = false

                local modelChildren =
                    modelInstance:GetChildren()

                for _, partInstance in ipairs(
                    modelChildren
                ) do
                    local partnick =
                        partInstance.Name

                    local meshesprefixing =
                        "Meshes/"

                    if string.sub(
                        partnick,
                        1,
                        #meshesprefixing
                    ) == meshesprefixing then

                        local nameAfterPrefix =
                            string.sub(
                                partnick,
                                #meshesprefixing + 1
                            )

                        local meshnamesearch =
                            string.lower(
                                nameAfterPrefix
                            )

                        for _, dbEntry in ipairs(
                            ITEM_DATABASE
                        ) do
                            local dbMeshPattern =
                                string.lower(
                                    dbEntry.meshPattern
                                )

                            local matched = false

                            if dbEntry.isPrefix then
                                if string.sub(
                                    meshnamesearch,
                                    1,
                                    #dbMeshPattern
                                ) == dbMeshPattern then

                                    matched = true
                                end
                            else
                                if meshnamesearch
                                    == dbMeshPattern then

                                    matched = true
                                end
                            end

                            if matched then
                                itemdisplay2 =
                                    dbEntry.displayName

                                itemcolor2 =
                                    dbEntry.color

                                itemIdentified = true
                                break
                            end
                        end

                    elseif partnick == "Bat" then
                        itemdisplay2 = "Bat"
                        itemcolor2 = BLUE
                        itemIdentified = true

                    elseif partnick == "Butt" then
                        itemdisplay2 = "Axe"
                        itemcolor2 = BLUE
                        itemIdentified = true
                    end

                    if itemIdentified then
                        break
                    end
                end
            end

            if itemdisplay2 then
                local distanceText =
                    " (Dist Error)"

                local dX =
                    playerPos.X - iPos.X

                local dY =
                    playerPos.Y - iPos.Y

                local dZ =
                    playerPos.Z - iPos.Z

                local distance =
                    math.sqrt(
                        dX * dX
                            + dY * dY
                            + dZ * dZ
                    )

                distanceText =
                    string.format(
                        " (%.1fm)",
                        distance
                    )

                local itemInfoText =
                    itemdisplay2
                        .. distanceText

                local textColor =
                    itemcolor2
                        or DEFAULT_ESP_COLOR

                local textobjectcurrent =
                    activeItemDrawings[
                        modelInstance
                    ]

                if textobjectcurrent then
                    textobjectcurrent.Position =
                        sPos

                    textobjectcurrent.Text =
                        itemInfoText

                    textobjectcurrent.Color =
                        textColor

                    textobjectcurrent.Visible =
                        true
                else
                    local newTextObject =
                        Drawing.new("Text")

                    if newTextObject then
                        newTextObject.Text =
                            itemInfoText

                        newTextObject.Position =
                            sPos

                        newTextObject.Color =
                            textColor

                        newTextObject.Visible =
                            true

                        activeItemDrawings[
                            modelInstance
                        ] = newTextObject
                    end
                end
            else
                if activeItemDrawings[
                    modelInstance
                ] then

                    activeItemDrawings[
                        modelInstance
                    ].Visible = false
                end
            end
        else
            if activeItemDrawings[
                modelInstance
            ] then

                activeItemDrawings[
                    modelInstance
                ]:Remove()

                activeItemDrawings[
                    modelInstance
                ] = nil
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
