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
    fl.Size = UDim2.new(1, -ss(20, s), 0, ss(330, s))  -- 增加高度
    fl.Position = UDim2.new(0, ss(10, s), 0, ss(105, s))
    fl.BackgroundTransparency = 1
    fl.ScrollBarThickness = ss(2, s)
    fl.ScrollBarImageColor3 = Color3.fromRGB(60, 70, 100)
    fl.CanvasSize = UDim2.new(0, 0, 0, ss(360, s))  -- 增加画布大小
    fl.Parent = mf
    
    -- 功能按钮列表（包括卸载选项）
    local its = {
        {"R6断腿", "R6Leg", Color3.fromRGB(200, 120, 80)},
        {"R15断腿", "R15Leg", Color3.fromRGB(100, 150, 200)},
        {"画质优化", "Graphics", Color3.fromRGB(0, 150, 100)},
        {"隐藏饰品", "Hat", Color3.fromRGB(70, 110, 200)},
        {"🚨 卸载脚本", "Unload", Color3.fromRGB(200, 50, 50)},  -- 新增卸载选项
    }
    
    for i, v in ipairs(its) do
        local it = Instance.new("Frame")
        it.Size = UDim2.new(1, 0, 0, ss(60, s))  -- 稍微增加高度
        it.Position = UDim2.new(0, 0, 0, (i - 1) * ss(65, s))
        it.BackgroundColor3 = Color3.fromRGB(25, 27, 35)
        it.BackgroundTransparency = 0.3
        it.Parent = fl
        
        -- 如果是卸载选项，添加特殊样式
        if v[2] == "Unload" then
            it.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
            it.BackgroundTransparency = 0.1
            
            -- 添加发光边框
            local glow = Instance.new("ImageLabel")
            glow.Size = UDim2.new(1, 8, 1, 8)
            glow.Position = UDim2.new(0, -4, 0, -4)
            glow.BackgroundTransparency = 1
            glow.Image = "rbxassetid://1316045217"
            glow.ImageColor3 = Color3.fromRGB(255, 0, 0)
            glow.ImageTransparency = 0.5
            glow.ScaleType = Enum.ScaleType.Slice
            glow.SliceCenter = Rect.new(10, 10, 118, 118)
            glow.Parent = it
        end
        
        local itCorner = Instance.new("UICorner")
        itCorner.CornerRadius = UDim.new(0, 8)
        itCorner.Parent = it
        
        local nl = Instance.new("TextLabel")
        nl.Size = UDim2.new(0.7, -ss(15, s), 0, ss(25, s))
        nl.Position = UDim2.new(0, ss(15, s), 0, ss(8, s))
        nl.BackgroundTransparency = 1
        nl.Text = v[1]
        nl.TextColor3 = v[2] == "Unload" and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(230, 235, 255)
        nl.TextSize = v[2] == "Unload" and ss(16, s) or ss(15, s)
        nl.Font = v[2] == "Unload" and Enum.Font.GothamBlack or Enum.Font.GothamBold
        nl.TextXAlignment = Enum.TextXAlignment.Left
        nl.Parent = it
        
        -- 卸载选项的特殊提示
        if v[2] == "Unload" then
            local tip = Instance.new("TextLabel")
            tip.Size = UDim2.new(0.7, -ss(15, s), 0, ss(18, s))
            tip.Position = UDim2.new(0, ss(15, s), 0, ss(33, s))
            tip.BackgroundTransparency = 1
            tip.Text = "点击关闭所有功能并删除脚本"
            tip.TextColor3 = Color3.fromRGB(255, 200, 200)
            tip.TextSize = ss(11, s)
            tip.Font = Enum.Font.Gotham
            tip.TextXAlignment = Enum.TextXAlignment.Left
            tip.Parent = it
            
            -- 垃圾桶图标
            local trash = Instance.new("TextLabel")
            trash.Size = UDim2.new(0, 30, 0, 30)
            trash.Position = UDim2.new(1, -ss(45, s), 0.5, -15)
            trash.BackgroundTransparency = 1
            trash.Text = "🗑️"
            trash.TextColor3 = Color3.fromRGB(255, 255, 255)
            trash.TextSize = ss(25, s)
            trash.Font = Enum.Font.GothamBold
            trash.Parent = it
        else
            -- 普通功能的开关按钮
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
        
        -- 卸载按钮的点击事件
        if v[2] == "Unload" then
            local unloadBtn = Instance.new("TextButton")
            unloadBtn.Size = UDim2.new(1, 0, 1, 0)
            unloadBtn.BackgroundTransparency = 1
            unloadBtn.Text = ""
            unloadBtn.Parent = it
            
            unloadBtn.MouseButton1Click:Connect(function()
                print("🔴 卸载脚本")
                
                -- 关闭所有开启的功能
                if Menu.state.R6Leg then
                    pcall(function() modules.LegEffects.enableR6(false, player) end)
                end
                if Menu.state.R15Leg then
                    pcall(function() modules.LegEffects.enableR15(false, player) end)
                end
                if Menu.state.Graphics then
                    pcall(function() modules.Graphics.enable(false) end)
                end
                if Menu.state.Hat then
                    pcall(function() modules.HatHider.enable(false, player) end)
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
                
                print("✅ 已卸载")
            end)
        end
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