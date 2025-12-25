local plr = game.Players.LocalPlayer
local cam = workspace.CurrentCamera
local running = true
local xhp = nil
local as = 76
local ae = true
local st = Drawing.new("Text")
st.Center = true
st.Outline = true
st.Visible = false
st.Size = 24        
st.Font = 2         
st.Color = Color3.new(0,1,0)
local stTimer = 0
local lastToggle = false
local function st1()
    st.Position = Vector2.new(cam.ViewportSize.X/2, 350)
    st.Text = "Autoheal: " .. (ae and "True" or "False")
    st.Color = ae and Color3.fromRGB(0,255,0) or Color3.fromRGB(255,0,0)
    st.Visible = true
    stTimer = os.clock() + 1.5
end
spawn(function()
    while true do
        if st.Visible and os.clock() >= stTimer then
            st.Visible = false
        end
        wait(0.01)
    end
end)
local function h1()
    keypress(0x51)
    wait(0.1)
    mouse1click()
    keyrelease(0x51)
end

local function h2()
    h1()
    wait(0.11)
    h1()
end
spawn(function()
    while true do
        local toggleKey = _G.AutoHeal_Bind
        local keyState = toggleKey and iskeypressed(toggleKey) or false
        if keyState and not lastToggle then
            ae = not ae
            print("Autoheal:", ae)
            st1()
        end
        lastToggle = keyState
        wait(0.01)
    end
end)
spawn(function()
    while true do
        if isrbxactive() then
            setrobloxinput(true)
        else
            setrobloxinput(false)
        end
        wait(0.1)
    end
end)
while true do
    if ae then
        if plr and plr.Character then
            local hum = plr.Character:FindFirstChildOfClass("Humanoid")
            if hum then
                local hp = hum.Health
                local maxhp = hum.MaxHealth
                if hp >= 2 then
                    if xhp and hp < xhp then
                        local dmg = xhp - hp
                        if dmg >= as then
                            h2()
                        end
                    end
                    if hp <= (maxhp - 12) then
                        h1()
                    end
                end
                xhp = hp
            end
        end
    end
    wait(0.001)
end
