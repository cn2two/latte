
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
 --[[                                                                                                              
                                        hhhhhhh               iiii          tttt                                 
                                        h:::::h              i::::i      ttt:::t                                 
                                        h:::::h               iiii       t:::::t                                 
                                        h:::::h                          t:::::t                                 
wwwwwww           wwwww           wwwwwwwh::::h hhhhh       iiiiiiittttttt:::::ttttttt        eeeeeeeeeeee       
 w:::::w         w:::::w         w:::::w h::::hh:::::hhh    i:::::it:::::::::::::::::t      ee::::::::::::ee     
  w:::::w       w:::::::w       w:::::w  h::::::::::::::hh   i::::it:::::::::::::::::t     e::::::eeeee:::::ee   
   w:::::w     w:::::::::w     w:::::w   h:::::::hhh::::::h  i::::itttttt:::::::tttttt    e::::::e     e:::::e   
    w:::::w   w:::::w:::::w   w:::::w    h::::::h   h::::::h i::::i      t:::::t          e:::::::eeeee::::::e   
     w:::::w w:::::w w:::::w w:::::w     h:::::h     h:::::h i::::i      t:::::t          e:::::::::::::::::e    
      w:::::w:::::w   w:::::w:::::w      h:::::h     h:::::h i::::i      t:::::t          e::::::eeeeeeeeeee     
       w:::::::::w     w:::::::::w       h:::::h     h:::::h i::::i      t:::::t    tttttte:::::::e              
        w:::::::w       w:::::::w        h:::::h     h:::::hi::::::i     t::::::tttt:::::te::::::::e             
         w:::::w         w:::::w         h:::::h     h:::::hi::::::i     tt::::::::::::::t e::::::::eeeeeeee     
          w:::w           w:::w          h:::::h     h:::::hi::::::i       tt:::::::::::tt  ee:::::::::::::e     
           www             www           hhhhhhh     hhhhhhhiiiiiiii         ttttttttttt      eeeeeeeeeeeeee     
                                                                                                                 
                                                                                                                 
ppppp   ppppppppp      ooooooooooo wwwwwww           wwwww           wwwwwww eeeeeeeeeeee    rrrrr   rrrrrrrrr   
p::::ppp:::::::::p   oo:::::::::::oow:::::w         w:::::w         w:::::wee::::::::::::ee  r::::rrr:::::::::r  
p:::::::::::::::::p o:::::::::::::::ow:::::w       w:::::::w       w:::::we::::::eeeee:::::eer:::::::::::::::::r 
pp::::::ppppp::::::po:::::ooooo:::::o w:::::w     w:::::::::w     w:::::we::::::e     e:::::err::::::rrrrr::::::r
 p:::::p     p:::::po::::o     o::::o  w:::::w   w:::::w:::::w   w:::::w e:::::::eeeee::::::e r:::::r     r:::::r
 p:::::p     p:::::po::::o     o::::o   w:::::w w:::::w w:::::w w:::::w  e:::::::::::::::::e  r:::::r     rrrrrrr
 p:::::p     p:::::po::::o     o::::o    w:::::w:::::w   w:::::w:::::w   e::::::eeeeeeeeeee   r:::::r            
 p:::::p    p::::::po::::o     o::::o     w:::::::::w     w:::::::::w    e:::::::e            r:::::r            
 p:::::ppppp:::::::po:::::ooooo:::::o      w:::::::w       w:::::::w     e::::::::e           r:::::r            
 p::::::::::::::::p o:::::::::::::::o       w:::::w         w:::::w       e::::::::eeeeeeee   r:::::r            
 p::::::::::::::pp   oo:::::::::::oo         w:::w           w:::w         ee:::::::::::::e   r:::::r            
 p::::::pppppppp       ooooooooooo            www             www            eeeeeeeeeeeeee   rrrrrrr            
 p:::::p                                                                                                         
 p:::::p                                                                                                         
p:::::::p                                                                                                        
p:::::::p                                                                                                        
p:::::::p                                                                                                        
ppppppppp                                                                                                        
]]    
           
--[[
                     _        _                        ____  
 _ __ ___   __ _  __| | ___  | |__  _   _    ___ _ __ |___ \ 
| '_ ` _ \ / _` |/ _` |/ _ \ | '_ \| | | |  / __| '_ \  __) |
| | | | | | (_| | (_| |  __/ | |_) | |_| | | (__| | | |/ __/ 
|_| |_| |_|\__,_|\__,_|\___| |_.__/ \__, |  \___|_| |_|_____|
                                    |___/                    
                                    
         _   _   _     _       _    
        (_) | |_| |__ (_)_ __ | | __
 _____  | | | __| '_ \| | '_ \| |/ /
|_____| | | | |_| | | | | | | |   < 
        |_|  \__|_| |_|_|_| |_|_|\_\
                                    
    







 _   _                                     _     _      
(_) | | _____   _____  __      _____ _   _| |__ | | ___ 
| | | |/ _ \ \ / / _ \ \ \ /\ / / _ \ | | | '_ \| |/ _ \
| | | | (_) \ V /  __/  \ V  V /  __/ |_| | |_) | |  __/
|_| |_|\___/ \_/ \___|   \_/\_/ \___|\__, |_.__/|_|\___|
                                     |___/              



            __      _       __ 

            __               __                         ______      _                _            _ __  
  ___  ____/ /_  __(_)___  / /_  ____  / /____     _____/ /_____  ____     / __/ /_  __(_)___  ____ _   (_)___       (_) /_ 
 / _ \/ __  / / / / / __ \/ __ \/ __ \/ __/ _ \   / ___/ __/ __ \/ __ \   / /_/ / / / / / __ \/ __ `/  / / __ \     / / __ \
/  __/ /_/ / /_/ / / / / / /_/ / /_/ / /_/  __/  (__  ) /_/ /_/ / /_/ /  / __/ / /_/ / / / / / /_/ /  / / / / /    / / /_/ /
\___/\__,_/\__,_/_/_/ /_/_.___/\____/\__/\___/  /____/\__/\____/ .___/  /_/ /_/\__, /_/_/ /_/\__, /  /_/_/ /_/  __/ /_.___/ 
                                                              /_/             /____/        /____/             /___/        
                                     
                                     
                                     
                                     
                                                                                     
]]
_G.VKBIND = 0x70                                                             
loadstring(game:HttpGet("https://raw.githubusercontent.com/cn2two/latte/refs/heads/main/zes.lua"))()
local Window = UI:Window({
    Title = "Artorias Client",
    Size = Vector2.new(700, 500),
    Flags = {},
})
local uiVisible = true
spawn(function()
    local lastPressed = false
    while true do
        task.wait(0.05)
        local pressed = iskeypressed(_G.VKBIND) 
        if pressed and not lastPressed then
            lastPressed = true
            uiVisible = not uiVisible

            Window.Internal.Open = uiVisible
            if Window.Tabs then
                for _, tab in pairs(Window.Tabs) do
                    if tab.Sections then
                        for _, section in pairs(tab.Sections) do
                            if section.Children.Drawings then
                                for _, drawing in pairs(section.Children.Drawings) do
                                    drawing.Drawing.Visible = uiVisible
                                end
                            end
                            if section.Children.Widgets then
                                for _, widget in pairs(section.Children.Widgets) do
                                    if widget.Children.Drawings then
                                        for _, drawing in pairs(widget.Children.Drawings) do
                                            drawing.Drawing.Visible = uiVisible
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        elseif not pressed then
            lastPressed = false
        end
    end
end)

local MainTab = Window:Tab({ Title = "Jailbreak" })
local MainSection = MainTab:Section({ Title = "Exploits" })
local uiVisible = false
for _, tab in pairs(Window.Tabs or {}) do
    for _, sec in pairs(tab.Sections or {}) do
        if sec.Frame then
            sec.Frame.Visible = uiVisible
        end
    end
end
local uiToggleBind = 0x70
spawn(function()
    local last = false
    while true do
        task.wait(0.05)
        local pressed = iskeypressed(uiToggleBind)
        if pressed and not last then
            uiVisible = not uiVisible
            for _, tab in pairs(Window.Tabs or {}) do
                for _, sec in pairs(tab.Sections or {}) do
                    if sec.Frame then
                        sec.Frame.Visible = uiVisible
                    end
                end
            end
        end
        last = pressed
    end
end)
-- Force Reset
local killBind = 0x2E -- DEL
local health_offset = 0x194
local killEnabled = false
MainSection:Checkbox({ Title = "Force Reset / Bind DEL" }, function(state)
    killEnabled = state
end)
local Players = game:GetService("Players")
local player = Players.LocalPlayer

local function getHumanoid()
    if not player then return nil end
    local char = player.Character
    if not char then return nil end
    return char:FindFirstChildOfClass("Humanoid")
end
spawn(function()
    local last = false
    while true do
        task.wait(0.05)
        if killEnabled and isrbxactive() then
            local pressed = iskeypressed(killBind)
            if pressed and not last then
                local hum = getHumanoid()
                if hum and hum.Address then
                    memory_write("float", hum.Address + health_offset, -10)
                end
            end
            last = pressed
        else
            last = false
        end
    end
end)
-- NPC Hitbox Expander
local hitboxToggle = true
MainSection:Checkbox({ Title = "NPC Hitbox Expander", Default = false }, function(state)
    hitboxToggle = state
end)
local hbesize = Vector3.new(10,8,10)
local targets = {
    {Parent = workspace:FindFirstChild("MansionRobbery"), Models = {"GuardsFolder"}},
    {Parent = workspace:FindFirstChild("OilRig"), Models = {"GuardsFolder"}},
    {Parent = workspace:FindFirstChild("Drop"), Models = {"NPCs"}},
}
local function ceoHead(model)
    if not model or not model:IsA("Model") then return end
    local humanoid = model:FindFirstChildOfClass("Humanoid")
    local head = model:FindFirstChild("Head")
    if humanoid and head then
        head.Size = hbesize
        head.CanCollide = true
    end
end
local function loopAll(parent)
    if not parent then return end
    for _, child in pairs(parent:GetChildren()) do
        if child:IsA("Model") then
            ceoHead(child)
        elseif child:IsA("Folder") then
            loopAll(child)
        end
    end
end
-- Drop ESP
local dropToggle = true
MainSection:Checkbox({ Title = "Drop ESP", Default = false }, function(state)
    dropToggle = state
end)
local dropbox, dropoutline, droptext
local colorx = 2
spawn(function()
    while true do
        task.wait(0.01)
        if dropToggle then
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
                local ddd = {R = 255, G = 255, B = 255}
                if post then
                    local partColor = post.Color
                    ddd.R = math.min(255, math.floor(partColor.R * colorx))
                    ddd.G = math.min(255, math.floor(partColor.G * colorx))
                    ddd.B = math.min(255, math.floor(partColor.B * colorx))
                end
                dropbox.Color = Color3.fromRGB(ddd.R, ddd.G, ddd.B)
                droptext.Color = Color3.fromRGB(ddd.R, ddd.G, ddd.B)
                
                local top, on_screen1 = WorldToScreen(root.Position + Vector3.new(0,2,0))
                local bottom, on_screen2 = WorldToScreen(root.Position - Vector3.new(0,2,0))
                if on_screen1 and on_screen2 then
                    local h = math.abs(top.Y-bottom.Y)
                    local w = h
                    local x = top.X-w/2
                    local y = top.Y
                    dropbox.Position = Vector2.new(x,y)
                    dropbox.Size = Vector2.new(w,h)
                    dropoutline.Position = Vector2.new(x,y)
                    dropoutline.Size = Vector2.new(w,h)
                    droptext.Position = Vector2.new(top.X,y-16)
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
        elseif dropbox then
            dropbox.Visible = false
            dropoutline.Visible = false
            droptext.Visible = false
        end
    end
end)
-- Bounty ESP Highest Bounty
local bountyToggle = true
local minBounty = 0
MainSection:Checkbox({ Title = "Bounty ESP", Default = false }, function(state)
    bountyToggle = state
end)
MainSection:Slider({ Title = "Min Bounty", Min = 0, Max = 20000, Default = 0, Step = 100 }, function(value)
    minBounty = value
end)

local espTable = {}
local pp = game:GetService("Players")
local rs = game:GetService("ReplicatedStorage")
local bountydata = rs:WaitForChild("BountyData")

local function w2s(pos)
    return WorldToScreen(pos)
end
local function parseBounties()
    local raw = bountydata.Value
    if not raw or raw == "" then return {} end
    local bounties = {}
    for bounty, name, userid in raw:gmatch('{"Bounty":(%d+),"Name":"(.-)","UserId":(%d+)') do
        bounties[name] = tonumber(bounty)
    end
    return bounties
end
spawn(function()
    while true do
        task.wait(0.01)
        if not bountyToggle then
            for _, txt in pairs(espTable) do
                txt:Remove()
            end
            espTable = {}
            continue
        end
        local currentBounties = parseBounties()
        for name, txt in pairs(espTable) do
            local bounty = currentBounties[name]
            if not bounty or bounty < minBounty then
                txt:Remove()
                espTable[name] = nil
            end
        end
        for name, bounty in pairs(currentBounties) do
            if not bounty or bounty < minBounty then continue end
            local player = pp:FindFirstChild(name)
            local char = player and player.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            if not root then
                if espTable[name] then espTable[name].Visible = false end
                continue
            end
            if not espTable[name] then
                local text = Drawing.new("Text")
                text.Font = 2
                text.Size = 17
                text.Outline = true
                text.Center = true
                espTable[name] = text
            end
            local text = espTable[name]
            local scaled = math.clamp((bounty - 100) / (15000 - 100), 0, 1)
            text.Color = Color3.fromRGB(math.floor(255*(1-scaled)), math.floor(255*scaled),0)
            text.Text = "$"..bounty
            local ok, pos, isOnScreen = pcall(function() return w2s(root.Position - Vector3.new(0,2,0)) end)
            if ok and isOnScreen then
                text.Position = Vector2.new(pos.X, pos.Y+12)
                text.Visible = true
            else
                text.Visible = false
            end
        end
    end
end)
-- Highest Bounty Notification
local hbToggle = true
MainSection:Checkbox({ Title = "Notify Highest Bounty", Default = false }, function(state)
    hbToggle = state
end)
MainSection:Button({ Title = "Get Highest Bounty" }, function()
    local out = bountydata.Value
    if not out or out == "" then return end
    local name2, bounty2 = nil, 0
    for bounty, name in out:gmatch('{"Bounty":(%d+),"Name":"(.-)","UserId":(%d+)') do
        bounty = tonumber(bounty)
        if bounty > bounty2 then
            bounty2 = bounty
            name2 = name
        end
    end
    if name2 then
        notify("Artorias Client","$"..bounty2.." - "..name2,10)
    end
end)

spawn(function()
    while true do
        task.wait(10)
        if not hbToggle then continue end
        local out = bountydata.Value
        if not out or out == "" then continue end
        local name2, bounty2 = nil, 0
        for bounty, name in out:gmatch('{"Bounty":(%d+),"Name":"(.-)","UserId":(%d+)') do
            bounty = tonumber(bounty)
            if bounty > bounty2 then
                bounty2 = bounty
                name2 = name
            end
        end
        if name2 then
            notify("Artorias Client","$"..bounty2.." - "..name2,10)
        end
    end
end)
--- Casino Code
local function getCasinoCode(index)
    local location = workspace.Casino.RobberyDoor.Codes:GetChildren()[index]
    if not location then return nil end

    local parts = {}
    for _, part in ipairs(location:GetChildren()) do
        local sG = part:FindFirstChild("SurfaceGui")
        if sG then
            local label = sG:FindFirstChild("TextLabel")
            if label and label.Text and label.Text ~= "" then
                local text = tostring(label.Text)
                if text:match("^%d$") then
                    table.insert(parts, {digit = text, x = part.Position.X, y = part.Position.Y})
                end
            end
        end
    end

    if #parts == 0 then return nil end
    if index == 3 then
        table.sort(parts, function(a, b) return a.y < b.y end)
    else
        table.sort(parts, function(a, b) return a.x < b.x end)
    end

    local code = ""
    for _, data in ipairs(parts) do
        code = code .. data.digit
    end

    return code
end
MainSection:Button({ Title = "Get Casino Code" }, function()
    for i = 1, 5 do
        local code = getCasinoCode(i)
        if code and #code == 4 then
            notify("Artorias Client", "Casino Code is: " .. code, 10)
        end
    end
end)
-- reset
MainSection:Button({ Title = "Force Reset" }, function()
local health_offset = 0x194
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local function getHumanoid()
   if not player then return nil end
   local char = player.Character
   if not char then return nil end
   return char:FindFirstChildOfClass("Humanoid")
end
local hum = getHumanoid()
if hum and hum.Address then
    memory_write("float", hum.Address + health_offset, -10)
end
end)
spawn(function()
    while true do
        task.wait(0.5)
        if hitboxToggle then
            for _, target in ipairs(targets) do
                local parent = workspace:FindFirstChild(target.Parent and target.Parent.Name or "")
                if parent then
                    for _, modelName in ipairs(target.Models) do
                        local folder = parent:FindFirstChild(modelName)
                        if folder then
                            loopAll(folder)
                        end
                    end
                end
            end
        end
    end
end)
print("Artorias Initialized.")
