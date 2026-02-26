local LegEffects = {dLeg = nil, r6S = false, r15S = false, sR = {}}
local Finder = require(script.Parent.Parent.Utils.Finder)

local function cL()
    if LegEffects.dLeg and LegEffects.dLeg.Parent then LegEffects.dLeg:Destroy() end
    LegEffects.dLeg = Instance.new("Part")
    LegEffects.dLeg.Name = "BrokenLeg"
    LegEffects.dLeg.Size = Vector3.new(0.832, 0.2496, 0.832)
    LegEffects.dLeg.BrickColor = BrickColor.new("Medium stone grey")
    LegEffects.dLeg.Material = Enum.Material.SmoothPlastic
    LegEffects.dLeg.Transparency = 0
    LegEffects.dLeg.Anchored = true
    LegEffects.dLeg.CanCollide = false
    LegEffects.dLeg.Parent = workspace
    local m = Instance.new("SpecialMesh")
    m.MeshId = "http://www.roblox.com/asset/?id=902942096"
    m.TextureId = "http://www.roblox.com/asset/?id=902843398"
    m.Scale = Vector3.new(0.936, 0.9984, 0.936)
    m.Parent = LegEffects.dLeg
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

-- ==== 修改重点：R15断腿位置偏移0.19 ====
local function hR15(c)
    if not c then return end
    local m = c:FindFirstChildOfClass("Humanoid")
    if not m or m.RigType ~= Enum.HumanoidRigType.R15 then return end
    local u = Finder.find(c, "RightUpperLeg")
    if u then
        LegEffects.sR[u] = {MeshId = u.MeshId, TextureId = u.TextureID, Transparency = u.Transparency}
        u.MeshId = "http://www.roblox.com/asset/?id=902942096"
        u.TextureID = "http://www.roblox.com/asset/?id=902843398"
        u.Transparency = 0
        -- 向上偏移0.19格（经过多次测试的最佳位置）
        u.CFrame = u.CFrame * CFrame.new(0, 0.19, 0)
    end
    local l = Finder.find(c, "RightLowerLeg")
    if l then
        LegEffects.sR[l] = {MeshId = l.MeshId, Transparency = l.Transparency}
        l.MeshId = "http://www.roblox.com/asset/?id=902942093"
        l.Transparency = 1
    end
    local o = Finder.find(c, "RightFoot") or Finder.find(c, "Right Foot")
    if o then
        LegEffects.sR[o] = {MeshId = o.MeshId, Transparency = o.Transparency}
        o.MeshId = "http://www.roblox.com/asset/?id=902942089"
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
end

function LegEffects.enableR6(bool, player)
    LegEffects.r6S = bool
    getgenv().PhantomR6Leg = bool
    if bool then
        if player.Character then
            cL()
            hR6(player.Character)
        end
    else
        if LegEffects.dLeg then
            LegEffects.dLeg:Destroy()
            LegEffects.dLeg = nil
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
        if player.Character then hR15(player.Character) end
    else
        if player.Character then sR15(player.Character) end
    end
end

function LegEffects.update(player)
    if not LegEffects.r6S then
        if LegEffects.dLeg then
            LegEffects.dLeg.Transparency = 1
        end
        return
    end
    local c = player.Character
    if not c then return end
    local u = Finder.find(c, "RightUpperLeg") or Finder.find(c, "Right Leg")
    if not u then return end
    if not LegEffects.dLeg or not LegEffects.dLeg.Parent then
        cL()
    end
    hR6(c)
    if LegEffects.dLeg then
        LegEffects.dLeg.Transparency = 0
        LegEffects.dLeg.CFrame = u.CFrame * CFrame.new(0, 0.7, 0)
    end
end

return LegEffects