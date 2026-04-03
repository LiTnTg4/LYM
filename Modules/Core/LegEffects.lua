local LegEffects = {
    r6S = false,
    r15S = false,
    sR = {},
    player = nil
}

local r6Leg = nil
local r15Leg = nil

local function findPart(container, names)
    if not container then return nil end
    for _, name in ipairs(names) do
        local part = container:FindFirstChild(name)
        if part then return part end
    end
    return nil
end

local function createR6Leg()
    if r6Leg and r6Leg.Parent then r6Leg:Destroy() end
    r6Leg = Instance.new("Part")
    r6Leg.Name = "R6BrokenLeg"
    r6Leg.Size = Vector3.new(0.832, 0.2496, 0.832)
    r6Leg.BrickColor = BrickColor.new("Medium stone grey")
    r6Leg.Material = Enum.Material.SmoothPlastic
    r6Leg.Transparency = 0
    r6Leg.Anchored = true
    r6Leg.CanCollide = false
    r6Leg.Parent = workspace
    
    local m = Instance.new("SpecialMesh")
    m.MeshId = "http://www.roblox.com/asset/?id=902942096"
    m.TextureId = "http://www.roblox.com/asset/?id=902843398"
    m.Scale = Vector3.new(0.936, 0.9984, 0.936)
    m.Parent = r6Leg
end

local function createR15Leg()
    if r15Leg and r15Leg.Parent then r15Leg:Destroy() end
    r15Leg = Instance.new("Part")
    r15Leg.Name = "R15BrokenLeg"
    r15Leg.Size = Vector3.new(0.832, 0.2496, 0.832)
    r15Leg.BrickColor = BrickColor.new("Medium stone grey")
    r15Leg.Material = Enum.Material.SmoothPlastic
    r15Leg.Transparency = 0
    r15Leg.Anchored = true
    r15Leg.CanCollide = false
    r15Leg.Parent = workspace
    
    local m = Instance.new("SpecialMesh")
    m.MeshId = "http://www.roblox.com/asset/?id=902942096"
    m.TextureId = "http://www.roblox.com/asset/?id=902843398"
    m.Scale = Vector3.new(0.936, 0.9984, 0.936)
    m.Parent = r15Leg
end

local function forceHideR6(c)
    if not c then return end
    local upper = findPart(c, {"RightUpperLeg", "Right Leg"})
    local lower = findPart(c, {"RightLowerLeg"})
    local foot = findPart(c, {"RightFoot", "Right Foot"})
    if upper then upper.Transparency = 1; upper.CanCollide = false end
    if lower then lower.Transparency = 1; lower.CanCollide = false end
    if foot then foot.Transparency = 1; foot.CanCollide = false end
end

local function forceShowR6(c)
    if not c then return end
    local upper = findPart(c, {"RightUpperLeg", "Right Leg"})
    local lower = findPart(c, {"RightLowerLeg"})
    local foot = findPart(c, {"RightFoot", "Right Foot"})
    if upper then upper.Transparency = 0; upper.CanCollide = true end
    if lower then lower.Transparency = 0; lower.CanCollide = true end
    if foot then foot.Transparency = 0; foot.CanCollide = true end
end

local function forceHideR15(c)
    if not c then return end
    local upper = findPart(c, {"RightUpperLeg"})
    local lower = findPart(c, {"RightLowerLeg"})
    local foot = findPart(c, {"RightFoot", "Right Foot"})
    if upper then LegEffects.sR[upper] = {Transparency = upper.Transparency}; upper.Transparency = 1 end
    if lower then LegEffects.sR[lower] = {Transparency = lower.Transparency}; lower.Transparency = 1 end
    if foot then LegEffects.sR[foot] = {Transparency = foot.Transparency}; foot.Transparency = 1 end
end

function LegEffects.init(player)
    LegEffects.player = player
end

function LegEffects.enableR6(bool)
    LegEffects.r6S = bool
    if bool then
        if LegEffects.player.Character then
            createR6Leg()
            forceHideR6(LegEffects.player.Character)
        end
    else
        if r6Leg then r6Leg:Destroy(); r6Leg = nil end
        if LegEffects.player.Character then forceShowR6(LegEffects.player.Character) end
    end
end

function LegEffects.enableR15(bool)
    LegEffects.r15S = bool
    if bool then
        if LegEffects.player.Character then
            createR15Leg()
            forceHideR15(LegEffects.player.Character)
        end
    else
        for part, data in pairs(LegEffects.sR) do
            if part and part.Parent then part.Transparency = data.Transparency or 0 end
        end
        LegEffects.sR = {}
        if r15Leg then r15Leg:Destroy(); r15Leg = nil end
    end
end

function LegEffects.update()
    local c = LegEffects.player.Character
    if not c then return end
    
    if LegEffects.r6S and r6Leg then
        local upper = findPart(c, {"RightUpperLeg", "Right Leg"})
        if upper then r6Leg.CFrame = upper.CFrame * CFrame.new(0, 0.7, 0) end
        forceHideR6(c)
    end
    
    if LegEffects.r15S and r15Leg then
        local upper = findPart(c, {"RightUpperLeg"})
        if upper then r15Leg.CFrame = upper.CFrame * CFrame.new(0, 0.19, 0) end
    end
end

function LegEffects.applyR6ToCharacter(character)
    if LegEffects.r6S then
        forceHideR6(character)
    end
end

function LegEffects.applyR15ToCharacter(character)
    if LegEffects.r15S then
        forceHideR15(character)
    end
end

return LegEffects