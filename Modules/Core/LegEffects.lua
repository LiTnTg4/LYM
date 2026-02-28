local LegEffects = {
    r6S = false,
    r15S = false,
    sR = {},
    lastCheck = 0
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

-- 强制隐藏R6腿部
local function forceHideR6(c)
    if not c then return end
    
    local upper = findPart(c, {"RightUpperLeg", "Right Leg"})
    local lower = findPart(c, {"RightLowerLeg"})
    local foot = findPart(c, {"RightFoot", "Right Foot"})
    
    if upper and upper.Transparency ~= 1 then
        upper.Transparency = 1
        upper.CanCollide = false
        upper.Material = Enum.Material.SmoothPlastic
    end
    if lower and lower.Transparency ~= 1 then
        lower.Transparency = 1
        lower.CanCollide = false
        lower.Material = Enum.Material.SmoothPlastic
    end
    if foot and foot.Transparency ~= 1 then
        foot.Transparency = 1
        foot.CanCollide = false
        foot.Material = Enum.Material.SmoothPlastic
    end
end

-- 强制显示R6腿部
local function forceShowR6(c)
    if not c then return end
    
    local upper = findPart(c, {"RightUpperLeg", "Right Leg"})
    local lower = findPart(c, {"RightLowerLeg"})
    local foot = findPart(c, {"RightFoot", "Right Foot"})
    
    if upper then
        upper.Transparency = 0
        upper.CanCollide = true
    end
    if lower then
        lower.Transparency = 0
        lower.CanCollide = true
    end
    if foot then
        foot.Transparency = 0
        foot.CanCollide = true
    end
end

-- 强制隐藏R15腿部
local function forceHideR15(c)
    if not c then return end
    
    local upper = findPart(c, {"RightUpperLeg"})
    local lower = findPart(c, {"RightLowerLeg"})
    local foot = findPart(c, {"RightFoot", "Right Foot"})
    
    if upper and upper.Transparency ~= 1 then
        LegEffects.sR[upper] = {Transparency = upper.Transparency}
        upper.Transparency = 1
    end
    if lower and lower.Transparency ~= 1 then
        LegEffects.sR[lower] = {Transparency = lower.Transparency}
        lower.Transparency = 1
    end
    if foot and foot.Transparency ~= 1 then
        LegEffects.sR[foot] = {Transparency = foot.Transparency}
        foot.Transparency = 1
    end
end

function LegEffects.enableR6(bool, player)
    LegEffects.r6S = bool
    if bool then
        if player and player.Character then
            createR6Leg()
            forceHideR6(player.Character)
            print("✅ R6断腿已开启")
        end
    else
        if r6Leg then
            r6Leg:Destroy()
            r6Leg = nil
        end
        if player and player.Character then
            forceShowR6(player.Character)
            print("✅ R6断腿已关闭")
        end
    end
end

function LegEffects.enableR15(bool, player)
    LegEffects.r15S = bool
    if bool then
        if player and player.Character then
            createR15Leg()
            forceHideR15(player.Character)
            print("✅ R15断腿已开启")
        end
    else
        for part, data in pairs(LegEffects.sR) do
            if part and part.Parent then
                part.Transparency = data.Transparency or 0
            end
        end
        LegEffects.sR = {}
        if r15Leg then
            r15Leg:Destroy()
            r15Leg = nil
        end
        print("✅ R15断腿已关闭")
    end
end

function LegEffects.update(player)
    if not player or not player.Character then return end
    local c = player.Character
    local now = tick()
    
    -- R6断腿更新和检测
    if LegEffects.r6S then
        -- 更新断腿模型位置
        if r6Leg then
            local upper = findPart(c, {"RightUpperLeg", "Right Leg"})
            if upper then
                r6Leg.CFrame = upper.CFrame * CFrame.new(0, 0.7, 0)
                r6Leg.Transparency = 0
            end
        end
        
        -- 每2秒强制检测一次R6腿部是否隐藏
        if now - LegEffects.lastCheck >= 2 then
            forceHideR6(c)
            LegEffects.lastCheck = now
        end
    end
    
    -- R15断腿更新
    if LegEffects.r15S then
        if r15Leg then
            local upper = findPart(c, {"RightUpperLeg"})
            if upper then
                r15Leg.CFrame = upper.CFrame * CFrame.new(0, 0.19, 0)
                r15Leg.Transparency = 0
            end
        end
    end
end

return LegEffects