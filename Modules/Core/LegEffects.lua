local LegEffects = {dLeg = nil, r6S = false, r15S = false, sR = {}}
local Finder = require(script.Parent.Parent.Utils.Finder)

-- R6专用断腿模型
local r6Leg = nil

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

-- R15专用断腿模型
local r15Leg = nil

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
    local u = Finder.find(c, "RightUpperLeg") or Finder.find(c, "Right Leg")
    local l = Finder.find(c, "RightLowerLeg")
    local o = Finder.find(c, "RightFoot") or Finder.find(c, "Right Foot")
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
    local u = Finder.find(c, "RightUpperLeg") or Finder.find(c, "Right Leg")
    local l = Finder.find(c, "RightLowerLeg")
    local o = Finder.find(c, "RightFoot") or Finder.find(c, "Right Foot")
    if u then u.Transparency = 0 end
    if l then l.Transparency = 0 end
    if o then o.Transparency = 0 end
end

-- ==== R15断腿（完全独立，不共享）====
local function hR15(c)
    if not c then return end
    local m = c:FindFirstChildOfClass("Humanoid")
    if not m or m.RigType ~= Enum.HumanoidRigType.R15 then return end
    
    -- 创建R15专用断腿模型
    if not r15Leg or not r15Leg.Parent then
        createR15Leg()
    end
    
    local u = Finder.find(c, "RightUpperLeg")
    if u then
        -- 保存原腿信息
        LegEffects.sR[u] = {MeshId = u.MeshId, TextureId = u.TextureID, Transparency = u.Transparency}
        
        -- 隐藏原腿
        u.Transparency = 1
        
        -- 设置断腿模型位置（向上偏移0.19）
        if r15Leg then
            r15Leg.CFrame = u.CFrame * CFrame.new(0, 0.19, 0)
            r15Leg.Transparency = 0
        end
    end
    
    -- 隐藏小腿
    local l = Finder.find(c, "RightLowerLeg")
    if l then
        LegEffects.sR[l] = {MeshId = l.MeshId, Transparency = l.Transparency}
        l.Transparency = 1
    end
    
    -- 隐藏脚
    local o = Finder.find(c, "RightFoot") or Finder.find(c, "Right Foot")
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
    
    -- 删除R15断腿模型
    if r15Leg then
        r15Leg:Destroy()
        r15Leg = nil
    end
end

function LegEffects.enableR6(bool, player)
    LegEffects.r6S = bool
    getgenv().PhantomR6Leg = bool
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
        if not getgenv().PhantomR15Leg then
            sR6(player.Character)
        end
    end
end

function LegEffects.enableR15(bool, player)
    LegEffects.r15S = bool
    getgenv().PhantomR15Leg = bool
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
    -- R6断腿更新（独立）
    if LegEffects.r6S then
        local c = player.Character
        if c and r6Leg then
            local u = Finder.find(c, "RightUpperLeg") or Finder.find(c, "Right Leg")
            if u then
                r6Leg.Transparency = 0
                r6Leg.CFrame = u.CFrame * CFrame.new(0, 0.7, 0)
                hR6(c)  -- 确保原腿隐藏
            end
        end
    elseif r6Leg then
        r6Leg.Transparency = 1
    end
    
    -- R15断腿更新（独立，每帧保持偏移0.19）
    if LegEffects.r15S then
        local c = player.Character
        if c and r15Leg then
            local u = Finder.find(c, "RightUpperLeg")
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