local HatHider = {player = nil}

function HatHider.init(player)
    HatHider.player = player
end

function HatHider.enable(bool)
    local c = HatHider.player.Character
    if c then
        HatHider.applyToCharacter(c, bool)
    end
end

function HatHider.applyToCharacter(character, bool)
    if not character then return end
    local kw = {"hair", "hat", "helmet", "cap", "hood", "headgear", "beanie", "visor", "accessory"}
    local t = bool and 1 or 0
    for _, o in character:GetDescendants() do
        if o:IsA("BasePart") then
            local n = o.Name:lower()
            for _, k in ipairs(kw) do
                if n:find(k) then
                    o.Transparency = t
                    break
                end
            end
        end
        if o:IsA("Accessory") then
            local h = o:FindFirstChild("Handle")
            if h then h.Transparency = t end
        end
    end
end

return HatHider