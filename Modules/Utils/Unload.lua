local Unload = {
    button = nil,
    player = nil,
    modules = nil
}

function Unload.init(player, modules)
    Unload.player = player
    Unload.modules = modules
    
    -- 创建悬浮按钮
    Unload.createButton()
    
    print("✅ 卸载按钮已创建")
end

function Unload.createButton()
    local player = Unload.player
    
    -- 创建GUI
    local gui = Instance.new("ScreenGui")
    gui.Name = "UnloadButton"
    gui.IgnoreGuiInset = true
    gui.DisplayOrder = 9999
    gui.ResetOnSpawn = false
    gui.Parent = player:WaitForChild("PlayerGui")
    
    -- 按钮框架
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 70, 0, 70)
    frame.Position = UDim2.new(0, 20, 0.5, -35)
    frame.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
    frame.BackgroundTransparency = 0.1
    frame.Active = true
    frame.Draggable = true
    frame.Parent = gui
    
    -- 圆角
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 35)
    corner.Parent = frame
    
    -- 阴影
    local shadow = Instance.new("ImageLabel")
    shadow.Size = UDim2.new(1, 10, 1, 10)
    shadow.Position = UDim2.new(0, -5, 0, -5)
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxassetid://1316045217"
    shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    shadow.ImageTransparency = 0.5
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(10, 10, 118, 118)
    shadow.Parent = frame
    
    -- 垃圾桶图标
    local icon = Instance.new("TextLabel")
    icon.Size = UDim2.new(1, 0, 0.7, 0)
    icon.Position = UDim2.new(0, 0, 0, 10)
    icon.BackgroundTransparency = 1
    icon.Text = "🗑️"
    icon.TextColor3 = Color3.fromRGB(255, 255, 255)
    icon.TextSize = 35
    icon.Font = Enum.Font.GothamBold
    icon.Parent = frame
    
    -- 文字提示
    local text = Instance.new("TextLabel")
    text.Size = UDim2.new(1, 0, 0.3, 0)
    text.Position = UDim2.new(0, 0, 0.7, -5)
    text.BackgroundTransparency = 1
    text.Text = "卸载"
    text.TextColor3 = Color3.fromRGB(255, 255, 255)
    text.TextSize = 14
    text.Font = Enum.Font.GothamBold
    text.Parent = frame
    
    -- 点击按钮
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 1, 0)
    button.BackgroundTransparency = 1
    button.Text = ""
    button.Parent = frame
    
    -- 点击事件
    button.MouseButton1Click:Connect(function()
        Unload.execute()
    end)
    
    Unload.button = gui
end

function Unload.execute()
    print("🔴 开始卸载脚本...")
    
    local player = Unload.player
    local modules = Unload.modules
    
    -- 关闭所有功能
    if modules then
        if modules.LegEffects then
            pcall(function()
                if modules.LegEffects.enableR6 then modules.LegEffects.enableR6(false, player) end
                if modules.LegEffects.enableR15 then modules.LegEffects.enableR15(false, player) end
            end)
        end
        
        if modules.Graphics then
            pcall(function() modules.Graphics.enable(false) end)
        end
        
        if modules.HatHider then
            pcall(function() modules.HatHider.enable(false, player) end)
        end
    end
    
    -- 恢复头部
    local c = player.Character
    if c then
        local head = c:FindFirstChild("Head")
        if head then
            head.Transparency = 0
            head.CanCollide = true
        end
    end
    
    -- 删除所有GUI
    for _, gui in ipairs(player.PlayerGui:GetChildren()) do
        if gui.Name == "RE_Menu" or gui.Name == "PerfMonitor" or gui.Name == "LYM_Notification" or gui.Name == "UnloadButton" then
            gui:Destroy()
        end
    end
    
    -- 显示提示
    local hint = Instance.new("Hint")
    hint.Text = "✅ LYM脚本已卸载"
    hint.Parent = workspace
    
    task.delay(3, function()
        if hint and hint.Parent then
            hint:Destroy()
        end
    end)
    
    print("✅ LYM脚本已卸载")
end

return Unload