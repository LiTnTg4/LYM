local LegEffects = {
    r6S = false,
    r15S = false,
    sR = {}
}

-- 断腿模型
local r6Leg = nil
local r15Leg = nil

-- 安全的查找函数
local function findPart(container, names)
    if not container then return nil end
    for _, name in ipairs(names) do
        local part = container:FindFirstChild(name)
        if part then return part end
    end
    return nil
end

-- 创建R6断腿模型
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

-- 创建R15断腿模型
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

-- R6启用
function LegEffects.enableR6(bool, player)
    LegEffects.r6S = bool
    
    if bool then
        if player and player.Character then
            createR6Leg()
            
            -- 隐藏R6右腿
            local c = player.Character
            local upper = findPart(c, {"RightUpperLeg", "Right Leg"})
            local lower = findPart(c, {"RightLowerLeg"})
            local foot = findPart(c, {"RightFoot", "Right Foot"})
            
            if upper then upper.Transparency = 1 end
            if lower then lower.Transparency = 1 end
            if foot then foot.Transparency = 1 end
        end
    else
        if r6Leg then
            r6Leg:Destroy()
            r6Leg = nil
        end
        
        -- 恢复R6右腿
        if player and player.Character then
            local c = player.Character
            local upper = findPart(c, {"RightUpperLeg", "Right Leg"})
            local lower = findPart(c, {"RightLowerLeg"})
            local foot = findPart(c, {"RightFoot", "Right Foot"})
            
            if upper then upper.Transparency = 0 end
            if lower then lower.Transparency = 0 end
            if foot then foot.Transparency = 0 end
        end
    end
end

-- R15启用
function LegEffects.enableR15(bool, player)
    LegEffects.r15S = bool
    
    if bool then
        if player and player.Character then
            createR15Leg()
            
            -- 隐藏R15右腿并保存信息
            local c = player.Character
            local upper = findPart(c, {"RightUpperLeg"})
            local lower = findPart(c, {"RightLowerLeg"})
            local foot = findPart(c, {"RightFoot", "Right Foot"})
            
            if upper then
                LegEffects.sR[upper] = {Transparency = upper.Transparency}
                upper.Transparency = 1
            end
            if lower then
                LegEffects.sR[lower] = {Transparency = lower.Transparency}
                lower.Transparency = 1
            end
            if foot then
                LegEffects.sR[foot] = {Transparency = foot.Transparency}
                foot.Transparency = 1
            end
        end
    else
        -- 恢复R15右腿
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
    end
end

-- 更新位置（每帧调用）
function LegEffects.update(player)
    if not player or not player.Character then return end
    
    local c = player.Character
    
    -- 更新R6断腿位置
    if LegEffects.r6S and r6Leg then
        local upper = findPart(c, {"RightUpperLeg", "Right Leg"})
        if upper then
            r6Leg.CFrame = upper.CFrame * CFrame.new(0, 0.7, 0)
            r6Leg.Transparency = 0
        end
    end
    
    -- 更新R15断腿位置
    if LegEffects.r15S and r15Leg then
        local upper = findPart(c, {"RightUpperLeg"})
        if upper then
            r15Leg.CFrame = upper.CFrame * CFrame.new(0, 0.19, 0)
            r15Leg.Transparency = 0
        end
    end
end

return LegEffects