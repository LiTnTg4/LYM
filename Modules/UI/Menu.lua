unloadButton.MouseButton1Click:Connect(function()
    -- 1. 关闭所有功能
    if state.R6Leg then modules.LegEffects.enableR6(false) end
    if state.R15Leg then modules.LegEffects.enableR15(false) end
    if state.Graphics then modules.Graphics.enable(false) end
    if state.Hat then modules.HatHider.enable(false) end
    
    -- 2. 恢复角色头部和身体
    local c = player.Character
    if c then
        local head = c:FindFirstChild("Head")
        if head then
            head.Transparency = 0
            head.CanCollide = true
        end
        local legParts = {"RightUpperLeg", "RightLowerLeg", "RightFoot", "LeftUpperLeg", "LeftLowerLeg", "LeftFoot", "Right Leg", "Left Leg"}
        for _, partName in ipairs(legParts) do
            local part = c:FindFirstChild(partName)
            if part then
                part.Transparency = 0
                part.Material = Enum.Material.SmoothPlastic
            end
        end
    end
    
    -- 3. 设置卸载标志（如果 Headless 模块支持）
    if modules and modules.Headless then
        modules.Headless.isUnloaded = true
    end
    
    -- 4. 删除菜单 GUI
    screenGui:Destroy()
    
    -- 5. 删除性能监控 GUI
    local perfGui = player.PlayerGui:FindFirstChild("WastelandPerfMonitor")
    if perfGui then perfGui:Destroy() end
    
    -- 6. 删除公告 GUI
    local annoGui = player.PlayerGui:FindFirstChild("AnnouncementGui")
    if annoGui then annoGui:Destroy() end
    
    print("✅ 脚本已卸载")
end)