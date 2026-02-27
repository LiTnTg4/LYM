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
    mf.Size = UDim2.new(0, ss(280, s), 0, ss(460, s))
    mf.Position = UDim2.new(0.5, -ss(140, s), 0.5, -ss(230, s))
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
    
    -- 标题文字
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
    mb.Name = "MinimizeButton"
    mb.Text = "─"
    mb.TextSize = ss(20, s)
    mb.Font = Enum.Font.GothamBold
    mb.TextColor3 = Color3.fromRGB(170, 175, 210)
    mb.BackgroundTransparency = 1
    mb.Size = UDim2.new(0, ss(35, s), 1, 0)
    mb.Position = UDim2.new(1, -ss(70, s), 0, 0)  -- 左移给删除按钮让位
    mb.ZIndex = 10
    mb.Parent = tb
    
    if Menu.minCallback then
        mb.MouseButton1Click:Connect(Menu.minCallback)
    end
    
    -- 删除按钮
    local db = Instance.new("TextButton")
    db.Name = "DeleteButton"
    db.Text = "✕"
    db.TextSize = ss(18, s)
    db.Font = Enum.Font.GothamBold
    db.TextColor3 = Color3.fromRGB(255, 80, 80)
    db.BackgroundTransparency = 1
    db.Size = UDim2.new(0, ss(35, s), 1, 0)
    db.Position = UDim2.new(1, -ss(35, s), 0, 0)  -- 最右侧
    db.ZIndex = 10
    db.Parent = tb
    
    -- 删除功能
    db.MouseButton1Click:Connect(function()
        -- 关闭所有开启的功能
        if Menu.state.R6Leg then
            modules.LegEffects.enableR6(false, player)
            Menu.state.R6Leg = false
        end
        if Menu.state.R15Leg then
            modules.LegEffects.enableR15(false, player)
            Menu.state.R15Leg = false
        end
        if Menu.state.Graphics then
            modules.Graphics.enable(false)
            Menu.state.Graphics = false
        end
        if Menu.state.Hat then
            modules.HatHider.enable(false, player)
            Menu.state.Hat = false
        end
        
        -- 恢复头部透明度
        local c = player.Character
        if c then
            local head = _G.f and _G.f(c, "Head") or c:FindFirstChild("Head")
            if head then
                head.Transparency = 0
                head.CanCollide = true
            end
        end
        
        -- 删除所有本脚本创建的GUI
        for _, gui in ipairs(player.PlayerGui:GetChildren()) do
            if gui.Name == "RE_Menu" or gui.Name == "PerfMonitor" or gui.Name == "LYM_Notification" then
                gui:Destroy()
            end
        end
        
        -- 显示提示
        local hint = Instance.new("Hint")
        hint.Text = "✅ LYM脚本已卸载，所有功能已关闭"
        hint.Parent = workspace
        
        task.spawn(function()
            task.wait(3)
            if hint and hint.Parent then
                hint:Destroy()
            end
        end)
        
        print("✅ LYM脚本已卸载")
    end)
    
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
    
    -- 功能列表
    local fl = Instance.new("ScrollingFrame")
    fl.Size = UDim2.new(1, -ss(20, s), 0, ss(280, s))
    fl.Position = UDim2.new(0, ss(10, s), 0, ss(105, s))
    fl.BackgroundTransparency = 1
    fl.ScrollBarThickness = ss(2, s)
    fl.ScrollBarImageColor3 = Color3.fromRGB(60, 70, 100)
    fl.CanvasSize = UDim2.new(0, 0, 0, ss(260, s))
    fl.Parent = mf
    
    local its = {
        {"R6断腿", "R6Leg", Color3.fromRGB(200, 120, 80)},
        {"R15断腿", "R15Leg", Color3.fromRGB(100, 150, 200)},
        {"画质优化", "Graphics", Color3.fromRGB(0, 150, 100)},
        {"隐藏饰品", "Hat", Color3.fromRGB(70, 110, 200)}
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