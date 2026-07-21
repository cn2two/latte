
_G.enabled= not _G.enabled
while _G.enabled do
    local c = game:GetService("Players").LocalPlayer.Character
    local t = c and (
        c:FindFirstChild("primary")
        or c:FindFirstChild("secondary")
    )
    local e = t
        and t:FindFirstChild("WeaponData")
        and t.WeaponData:FindFirstChild("Essentials")

    if e then
        local n = e.MaxAmmo.Value
        e.Ammo.Value = n
        e.ReplicatedAmmo.Value = n
    end
    task.wait(0.1)
end
