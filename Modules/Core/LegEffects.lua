local LegEffects = {dLeg = nil, r6S = false, r15S = false, sR = {}}

-- R6专用断腿模型
local r6Leg = nil
local r15Leg = nil

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

local function hR6(c)
    if not c then return end
    -- 使用 _G.f 或备选方案
    local find = _G.f or function(container, name)
        return container:FindFirstChild(name) or container:FindFirstChild(name:gsub(' ', ''))
    end
    
    local u = find(c, "RightUpperLeg") or find(c, "Right Leg")
    local l = find(c, "RightLowerLeg")
    local o = find(c, "RightFoot") or find(c, "Right Foot")
    
    local function h(p)
        if p and p.Transparency ~= 1 then
            p.Transparency = 1
            p.CanCollide = false
            p.Material = Enum.Material.SmoothPlastic
            for _, v in p:GetChildren() do
                if v:IsA("Attachment") then v.Visible = false end
                if v:IsA("MeshPart") then v.Transparency = 1 end
            end
        end
    end
    h(u) h(l) h(o)
end

local function sR6(c)
    if not c then return end
    local find = _G.f or function(container, name)
        return container:FindFirstChild(name) or container:FindFirstChild(name:gsub(' ', ''))
    end
    
    local u = find(c, "RightUpperLeg") or find(c, "Right Leg")
    local l = find(c, "RightLowerLeg")
    local o = find(c, "RightFoot") or find(c, "Right Foot")
    
    if u then u.Transparency = 0 end
    if l then l.Transparency = 0 end
    if o then o.Transparency = 0 end
end

local function hR15(c)
    if not c then return end
    local find = _G.f or function(container, name)
        return container:FindFirstChild(name) or container:FindFirstChild(name:gsub(' ', ''))
    end
    
    local m = c:FindFirstChildOfClass("Humanoid")
    if not m or m.RigType ~= Enum.HumanoidRigType.R15 then return end
    
    if not r15Leg or not r15Leg.Parent then
        createR15Leg()
    end
    
    local u = find(c, "RightUpperLeg")
    if u then
        LegEffects.sR[u] = {MeshId = u.MeshId, TextureId = u.TextureID, Transparency = u.Transparency}
        u.Transparency = 1
        if r15Leg then
            r15Leg.CFrame = u.CFrame * CFrame.new(0, 0.19, 0)
            r15Leg.Transparency = 0
        end
    end
    
    local l = find(c, "RightLowerLeg")
    if l then
        LegEffects.sR[l] = {MeshId = l.MeshId, Transparency = l.Transparency}
        l.Transparency = 1
    end
    
    local o = find(c, "RightFoot") or find(c, "Right Foot")
    if o then
        LegEffects.sR[o] = {MeshId = o.MeshId, Transparency = o.Transparency}
        o.Transparency = 1
    end
end

local function sR15(c)
    for p, s in pairs(LegEffects.sR) do
        if p and p.Parent then
            if s.MeshId ~= nil then pcall(function() p.MeshId = s.MeshId end) end
            if s.TextureId ~= nil then pcall(function() p.TextureID = s.TextureId end) end
            if s.Transparency ~= nil then p.Transparency = s.Transparency end
        end
    end
    LegEffects.sR = {}
    if r15Leg then
        r15Leg:Destroy()
        r15Leg = nil
    end
end

function LegEffects.enableR6(bool, player)
    LegEffects.r6S = bool
    if bool then
        if player.Character then
            createR6Leg()
            hR6(player.Character)
        end
    else
        if r6Leg then
            r6Leg:Destroy()
            r6Leg = nil
        end
        if not LegEffects.r15S then
            sR6(player.Character)
        end
    end
end

function LegEffects.enableR15(bool, player)
    LegEffects.r15S = bool
    if bool then
        if player.Character then 
            hR15(player.Character)
        end
    else
        if player.Character then 
            sR15(player.Character)
        end
    end
end

function LegEffects.update(player)
    local find = _G.f or function(container, name)
        return container:FindFirstChild(name) or container:FindFirstChild(name:gsub(' ', ''))
    end
    
    if LegEffects.r6S then
        local c = player.Character
        if c and r6Leg then
            local u = find(c, "RightUpperLeg") or find(c, "Right Leg")
            if u then
                r6Leg.Transparency = 0
                r6Leg.CFrame = u.CFrame * CFrame.new(0, 0.7, 0)
                hR6(c)
            end
        end
    elseif r6Leg then
        r6Leg.Transparency = 1
    end
    
    if LegEffects.r15S then
        local c = player.Character
        if c and r15Leg then
            local u = find(c, "RightUpperLeg")
            if u then
                r15Leg.CFrame = u.CFrame * CFrame.new(0, 0.19, 0)
                r15Leg.Transparency = 0
            end
        end
    elseif r15Leg then
        r15Leg.Transparency = 1
    end
end

return LegEffects