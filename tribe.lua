-- feel free to tweak <3
local plr = game.Players.LocalPlayer
print("autoheal started")
local xhp = nil
local as = 76
local ae = true
local cam = workspace.CurrentCamera
local st = Drawing.new("Text")
st.Center = true
st.Outline = true
st.Visible = false
local function st1()
    local vp = cam.ViewportSize
    st.Position = Vector2.new(vp.X/2, vp.Y/2 - 80)

    if ae then
        st.Color = Color3.new(0,1,0)
        st.Text = "AUTOHEAL ENABLED"
    else
        st.Color = Color3.new(1,0,0)
        st.Text = "AUTOHEAL DISABLED"
    end

    st.Visible = true
    spawn(function()
        wait(1.5)
        st.Visible = false
    end)
end

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
        if iskeypressed(0x2E) then
            ae = not ae
            print("Autoheal:", ae)
            st1()
            wait(0.25)
        end
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
