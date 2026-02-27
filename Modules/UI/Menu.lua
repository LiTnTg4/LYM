local Menu = {frame = nil, state = nil, modules = nil, minCallback = nil}

local function ss(base, scale)
    return math.floor(base * scale)
end

function Menu.init(player, state, modules)
    Menu.state = state
    Menu.modules = modules
    local pg = player:WaitForChild("PlayerGui")
    local vs = workspace.CurrentCamera.ViewportSize
    local s = math.min(1, vs.Y / 1080)
    
    local r = Instance.new("ScreenGui")
    r.Name = "RE_Menu"
    r.IgnoreGuiInset = true
    r.ResetOnSpawn = false
    r.DisplayOrder = 100
    r.Parent = pg
    
    local mf = Instance.new("Frame")
    mf.Size = UDim2.new(0, ss(280, s), 0, ss(520, s))  -- 增加高度给卸载按钮
    mf.Position = UDim2.new(0.5, -ss(140, s), 0.5, -ss(260, s))
    mf.BackgroundColor3 = Color3.fromRGB(20, 22, 28)
    mf.BackgroundTransparency = 0.05
    mf.Active = true
    mf.Draggable = true
    mf.Visible = false
    mf.Parent = r
    Menu.frame = mf
    
    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 12)
    mainCorner.Parent = mf
    
    -- 标题栏
    local tb = Instance.new("Frame")
    tb.Size = UDim2.new(1, 0, 0, ss(38, s))
    tb.BackgroundColor3 = Color3.fromRGB(28, 30, 38)
    tb.BackgroundTransparency = 0.1
    tb.Parent = mf
    
    local tbCorner = Instance.new("UICorner")
    tbCorner.CornerRadius = UDim.new(0, 12)
    tbCorner.Parent = tb
    
    local tt = Instance.new("TextLabel")
    tt.Text = "Reming祝大家天天开心"
    tt.TextColor3 = Color3.fromRGB(210, 215, 255)
    tt.TextSize = ss(15, s)
    tt.Font = Enum.Font.GothamBold
    tt.TextXAlignment = Enum.TextXAlignment.Left
    tt.BackgroundTransparency = 1
    tt.Size = UDim2.new(0.6, -ss(15, s), 1, 0)
    tt.Position = UDim2.new(0, ss(15, s), 0, 0)
    tt.Parent = tb
    
    -- 最小化按钮
    local mb = Instance.new("TextButton")
    mb.Text = "─"
    mb.TextSize = ss(20, s)
    mb.Font = Enum.Font.GothamBold
    mb.TextColor3 = Color3.fromRGB(170, 175, 210)
    mb.BackgroundTransparency = 1
    mb.Size = UDim2.new(0, ss(35, s), 1, 0)
    mb.Position = UDim2.new(1, -ss(35, s), 0, 0)
    mb.Parent = tb
    
    if Menu.minCallback then
        mb.MouseButton1Click:Connect(Menu.minCallback)
    end
    
    -- 用户信息栏
    local ub = Instance.new("Frame")
    ub.Size = UDim2.new(1, -ss(20, s), 0, ss(48, s))
    ub.Position = UDim2.new(0, ss(10, s), 0, ss(48, s))
    ub.BackgroundColor3 = Color3.fromRGB(30, 33, 42)
    ub.BackgroundTransparency = 0.2
    ub.Parent = mf
    
    local ubCorner = Instance.new("UICorner")
    ubCorner.CornerRadius = UDim.new(0, 8)
    ubCorner.Parent = ub
    
    local un = Instance.new("TextLabel")
    un.Text = player.Name
    un.TextColor3 = Color3.new(1, 1, 1)
    un.TextSize = ss(15, s)
    un.Font = Enum.Font.GothamBold
    un.TextXAlignment = Enum.TextXAlignment.Left
    un.BackgroundTransparency = 1
    un.Size = UDim2.new(0.5, -ss(10, s), 1, 0)
    un.Position = UDim2.new(0, ss(15, s), 0, 0)
    un.Parent = ub
    
    -- 功能列表滚动框
    local fl = Instance.new("ScrollingFrame")
    fl.Size = UDim2.new(1, -ss(20, s), 0, ss(280, s))
    fl.Position = UDim2.new(0, ss(10, s), 0, ss(105, s))
    fl.BackgroundTransparency = 1
    fl.ScrollBarThickness = ss(2, s)
    fl.ScrollBarImageColor3 = Color3.fromRGB(60, 70, 100)
    fl.CanvasSize = UDim2.new(0, 0, 0, ss(260, s))
    fl.Parent = mf
    
    -- 功能按钮列表
    local its = {
        {"R6断腿", "R6Leg", Color3.fromRGB(200, 120, 80)},
        {"R15断腿", "R15Leg", Color3.fromRGB(100, 150, 200)},
        {"画质优化", "Graphics", Color3.fromRGB(0, 150, 100)},
        {"隐藏饰品", "Hat", Color3.fromRGB(70, 110, 200)},
    }
    
    for i, v in ipairs(its) do
        local it = Instance.new("Frame")
        it.Size = UDim2.new(1, 0, 0, ss(55, s))
        it.Position = UDim2.new(0, 0, 0, (i - 1) * ss(60, s))
        it.BackgroundColor3 = Color3.fromRGB(25, 27, 35)
        it.BackgroundTransparency = 0.3
        it.Parent = fl
        
        local itCorner = Instance.new("UICorner")
        itCorner.CornerRadius = UDim.new(0, 8)
        itCorner.Parent = it
        
        local nl = Instance.new("TextLabel")
        nl.Text = v[1]
        nl.TextColor3 = Color3.fromRGB(230, 235, 255)
        nl.TextSize = ss(15, s)
        nl.Font = Enum.Font.GothamBold
        nl.TextXAlignment = Enum.TextXAlignment.Left
        nl.BackgroundTransparency = 1
        nl.Size = UDim2.new(0.6, -ss(15, s), 0, ss(25, s))
        nl.Position = UDim2.new(0, ss(15, s), 0, ss(6, s))
        nl.Parent = it
        
        local tg = Instance.new("TextButton")
        tg.Text = "关"
        tg.TextSize = ss(13, s)
        tg.Font = Enum.Font.GothamBold
        tg.TextColor3 = Color3.new(1, 1, 1)
        tg.BackgroundColor3 = Color3.fromRGB(65, 70, 90)
        tg.Size = UDim2.new(0, ss(50, s), 0, ss(26, s))
        tg.Position = UDim2.new(1, -ss(65, s), 0.5, -ss(13, s))
        tg.Parent = it
        
        local tgCorner = Instance.new("UICorner")
        tgCorner.CornerRadius = UDim.new(0, 13)
        tgCorner.Parent = tg
        
        local isOn = false
        
        tg.MouseButton1Click:Connect(function()
            isOn = not isOn
            tg.Text = isOn and "开" or "关"
            tg.BackgroundColor3 = isOn and v[3] or Color3.fromRGB(65, 70, 90)
            Menu.state[v[2]] = isOn
            if v[2] == "R6Leg" then
                modules.LegEffects.enableR6(isOn, player)
            elseif v[2] == "R15Leg" then
                modules.LegEffects.enableR15(isOn, player)
            elseif v[2] == "Graphics" then
                modules.Graphics.enable(isOn)
            elseif v[2] == "Hat" then
                modules.HatHider.enable(isOn, player)
            end
        end)
    end
    
    -- ========== 醒目的卸载按钮 ==========
    local unloadFrame = Instance.new("Frame")
    unloadFrame.Size = UDim2.new(1, -ss(20, s), 0, ss(70, s))
    unloadFrame.Position = UDim2.new(0, ss(10, s), 0, ss(395, s))  -- 放在功能列表下方
    unloadFrame.BackgroundColor3 = Color3.fromRGB(180, 40, 40)  -- 深红色背景
    unloadFrame.BackgroundTransparency = 0
    unloadFrame.BorderSizePixel = 0
    unloadFrame.Parent = mf
    
    -- 发光效果
    local glow = Instance.new("ImageLabel")
    glow.Size = UDim2.new(1, 10, 1, 10)
    glow.Position = UDim2.new(0, -5, 0, -5)
    glow.BackgroundTransparency = 1
    glow.Image = "rbxassetid://1316045217"
    glow.ImageColor3 = Color3.fromRGB(255, 0, 0)
    glow.ImageTransparency = 0.7
    glow.ScaleType = Enum.ScaleType.Slice
    glow.SliceCenter = Rect.new(10, 10, 118, 118)
    glow.Parent = unloadFrame
    
    local unloadCorner = Instance.new("UICorner")
    unloadCorner.CornerRadius = UDim.new(0, 12)
    unloadCorner.Parent = unloadFrame
    
    -- 警告图标
    local warnIcon = Instance.new("TextLabel")
    warnIcon.Size = UDim2.new(0, 40, 1, 0)
    warnIcon.Position = UDim2.new(0, ss(15, s), 0, 0)
    warnIcon.BackgroundTransparency = 1
    warnIcon.Text = "⚠️"
    warnIcon.TextColor3 = Color3.fromRGB(255, 255, 0)
    warnIcon.TextSize = ss(30, s)
    warnIcon.Font = Enum.Font.GothamBold
    warnIcon.Parent = unloadFrame
    
    -- 卸载文字
    local unloadText = Instance.new("TextLabel")
    unloadText.Size = UDim2.new(1, -120, 0, ss(30, s))
    unloadText.Position = UDim2.new(0, ss(60, s), 0, ss(10, s))
    unloadText.BackgroundTransparency = 1
    unloadText.Text = "卸载脚本"
    unloadText.TextColor3 = Color3.fromRGB(255, 255, 255)
    unloadText.TextSize = ss(20, s)
    unloadText.Font = Enum.Font.GothamBold
    unloadText.TextXAlignment = Enum.TextXAlignment.Left
    unloadText.Parent = unloadFrame
    
    -- 提示文字
    local unloadHint = Instance.new("TextLabel")
    unloadHint.Size = UDim2.new(1, -120, 0, ss(20, s))
    unloadHint.Position = UDim2.new(0, ss(60, s), 0, ss(40, s))
    unloadHint.BackgroundTransparency = 1
    unloadHint.Text = "点击关闭所有功能并删除脚本"
    unloadHint.TextColor3 = Color3.fromRGB(255, 200, 200)
    unloadHint.TextSize = ss(12, s)
    unloadHint.Font = Enum.Font.Gotham
    unloadHint.TextXAlignment = Enum.TextXAlignment.Left
    unloadHint.Parent = unloadFrame
    
    -- 垃圾桶图标
    local trashIcon = Instance.new("TextLabel")
    trashIcon.Size = UDim2.new(0, 40, 1, 0)
    trashIcon.Position = UDim2.new(1, -ss(50, s), 0, 0)
    trashIcon.BackgroundTransparency = 1
    trashIcon.Text = "🗑️"
    trashIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
    trashIcon.TextSize = ss(30, s)
    trashIcon.Font = Enum.Font.GothamBold
    trashIcon.Parent = unloadFrame
    
    -- 卸载按钮
    local unloadButton = Instance.new("TextButton")
    unloadButton.Size = UDim2.new(1, 0, 1, 0)
    unloadButton.BackgroundTransparency = 1
    unloadButton.Text = ""
    unloadButton.Parent = unloadFrame
    
    -- 卸载功能
    unloadButton.MouseButton1Click:Connect(function()
        print("🔴 卸载按钮被点击")
        
        -- 关闭所有开启的功能
        if Menu.state.R6Leg then
            pcall(function() modules.LegEffects.enableR6(false, player) end)
            Menu.state.R6Leg = false
        end
        if Menu.state.R15Leg then
            pcall(function() modules.LegEffects.enableR15(false, player) end)
            Menu.state.R15Leg = false
        end
        if Menu.state.Graphics then
            pcall(function() modules.Graphics.enable(false) end)
            Menu.state.Graphics = false
        end
        if Menu.state.Hat then
            pcall(function() modules.HatHider.enable(false, player) end)
            Menu.state.Hat = false
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
            if gui.Name == "RE_Menu" or gui.Name == "PerfMonitor" or gui.Name == "LYM_Notification" then
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
    end)
    
    -- 底部提示
    local ft = Instance.new("Frame")
    ft.Size = UDim2.new(1, -ss(20, s), 0, ss(48, s))
    ft.Position = UDim2.new(0, ss(10, s), 1, -ss(50, s))
    ft.BackgroundColor3 = Color3.fromRGB(28, 30, 38)
    ft.BackgroundTransparency = 0.2
    ft.Parent = mf
    
    local ftCorner = Instance.new("UICorner")
    ftCorner.CornerRadius = UDim.new(0, 8)
    ftCorner.Parent = ft
    
    local ftt = Instance.new("TextLabel")
    ftt.Size = UDim2.new(1, -ss(10, s), 1, 0)
    ftt.Position = UDim2.new(0, ss(5, s), 0, 0)
    ftt.Text = "【无头自启动】我一直在掉眼泪💧"
    ftt.TextColor3 = Color3.fromRGB(180, 190, 220)
    ftt.TextSize = ss(13, s)
    ftt.Font = Enum.Font.GothamBold
    ftt.BackgroundTransparency = 1
    ftt.Parent = ft
    
    return {
        show = function() mf.Visible = true end,
        hide = function() mf.Visible = false end,
        frame = mf,
        minButton = mb,
        setMinCallback = function(cb)
            Menu.minCallback = cb
            mb.MouseButton1Click:Connect(cb)
        end
    }
end

return Menu