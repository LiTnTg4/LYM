-- 断腿效果模块

local Players = game:GetService("Players")
local player = Players.LocalPlayer

local LegBreak = {}
LegBreak.__index = LegBreak

function LegBreak.new(state)
    local self = setmetatable({}, LegBreak)
    self.state = state
    self.r6Leg = nil
    self.r15Leg = nil
    return self
end

local function findPart(container, names)
    if not container then return nil end
    for _, name in ipairs(names) do
        local part = container:FindFirstChild(name)
        if part then return part end
    end
    return nil
end

function LegBreak:createR6Leg()
    if self.r6Leg and self.r6Leg.Parent then self.r6Leg:Destroy() end
    self.r6Leg = Instance.new("Part")
    self.r6Leg.Name = "R6BrokenLeg"
    self.r6Leg.Size = Vector3.new(0.832, 0.2496, 0.832)
    self.r6Leg.BrickColor = BrickColor.new("Medium stone grey")
    self.r6Leg.Material = Enum.Material.SmoothPlastic
    self.r6Leg.Transparency = 0
    self.r6Leg.Anchored = true
    self.r6Leg.CanCollide = false
    self.r6Leg.Parent = workspace
    
    local m = Instance.new("SpecialMesh")
    m.MeshId = "http://www.roblox.com/asset/?id=902942096"
    m.TextureId = "http://www.roblox.com/asset/?id=902843398"
    m.Scale = Vector3.new(0.936, 0.9984, 0.936)
    m.Parent = self.r6Leg
end

function LegBreak:createR15Leg()
    if self.r15Leg and self.r15Leg.Parent then self.r15Leg:Destroy() end
    self.r15Leg = Instance.new("Part")
    self.r15Leg.Name = "R15BrokenLeg"
    self.r15Leg.Size = Vector3.new(0.832, 0.2496, 0.832)
    self.r15Leg.BrickColor = BrickColor.new("Medium stone grey")
    self.r15Leg.Material = Enum.Material.SmoothPlastic
    self.r15Leg.Transparency = 0
    self.r15Leg.Anchored = true
    self.r15Leg.CanCollide = false
    self.r15Leg.Parent = workspace
    
    local m = Instance.new("SpecialMesh")
    m.MeshId = "http://www.roblox.com/asset/?id=902942096"
    m.TextureId = "http://www.roblox.com/asset/?id=902843398"
    m.Scale = Vector3.new(0.936, 0.9984, 0.936)
    m.Parent = self.r15Leg
end

function LegBreak:forceHideR6(character)
    if not character then return end
    local upper = findPart(character, {"RightUpperLeg", "Right Leg"})
    local lower = findPart(character, {"RightLowerLeg"})
    local foot = findPart(character, {"RightFoot", "Right Foot"})
    if upper then upper.Transparency = 1; upper.CanCollide = false end
    if lower then lower.Transparency = 1; lower.CanCollide = false end
    if foot then foot.Transparency = 1; foot.CanCollide = false end
end

function LegBreak:forceShowR6(character)
    if not character then return end
    local upper = findPart(character, {"RightUpperLeg", "Right Leg"})
    local lower = findPart(character, {"RightLowerLeg"})
    local foot = findPart(character, {"RightFoot", "Right Foot"})
    if upper then upper.Transparency = 0; upper.CanCollide = true end
    if lower then lower.Transparency = 0; lower.CanCollide = true end
    if foot then foot.Transparency = 0; foot.CanCollide = true end
end

function LegBreak:forceHideR15(character)
    if not character then return end
    local upper = findPart(character, {"RightUpperLeg"})
    local lower = findPart(character, {"RightLowerLeg"})
    local foot = findPart(character, {"RightFoot", "Right Foot"})
    if upper then upper.Transparency = 1 end
    if lower then lower.Transparency = 1 end
    if foot then foot.Transparency = 1 end
end

function LegBreak:enableR6Leg(bool)
    self.state.functionState.r6Leg = bool
    if bool then
        if player.Character then
            self:createR6Leg()
            self:forceHideR6(player.Character)
        end
    else
        if self.r6Leg then self.r6Leg:Destroy(); self.r6Leg = nil end
        if player.Character then self:forceShowR6(player.Character) end
    end
end

function LegBreak:enableR15Leg(bool)
    self.state.functionState.r15Leg = bool
    if bool then
        if player.Character then
            self:createR15Leg()
            self:forceHideR15(player.Character)
        end
    else
        if self.r15Leg then self.r15Leg:Destroy(); self.r15Leg = nil end
    end
end

function LegBreak:update()
    local c = player.Character
    if not c then return end
    
    if self.state.functionState.r6Leg and self.r6Leg then
        local upper = findPart(c, {"RightUpperLeg", "Right Leg"})
        if upper then self.r6Leg.CFrame = upper.CFrame * CFrame.new(0, 0.7, 0) end
        self:forceHideR6(c)
    end
    
    if self.state.functionState.r15Leg and self.r15Leg then
        local upper = findPart(c, {"RightUpperLeg"})
        if upper then self.r15Leg.CFrame = upper.CFrame * CFrame.new(0, 0.19, 0) end
    end
end

function LegBreak:onCharacterAdded(character)
    if self.state.functionState.r6Leg then
        self:enableR6Leg(true)
    end
    if self.state.functionState.r15Leg then
        self:enableR15Leg(true)
    end
end

function LegBreak:unload()
    self:enableR6Leg(false)
    self:enableR15Leg(false)
end

return LegBreak
