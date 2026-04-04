local Announcement = {}

-- ==================== 公告配置（直接在这里修改）====================
local CONFIG = {
    enabled = true,
    title = "",
    content = "Reming心情不怎么好 Reming要走了\n\n本次更新新加了这个公告 修改了ui\n\n下次更新添加灵敏度调节功能\n\n还有FF配置功能\n\n━━━━━━━━━━━━\n\n要记得Reming哦\n\n",
    align = "center",
    waitTime = 6,
}
-- ================================================================

local FONT_SIZES = {
    title = 24,
    content = 16,
    timer = 14,
    button = 18,
    icon = 20
}

local WINDOW_SIZE = {
    width = 520,
    height = 440
}

local function getScale()
    local viewportSize = workspace.CurrentCamera.ViewportSize
    local referenceHeight = 1080
    return math.min(1.3, math.max(0.7, viewportSize.Y / referenceHeight))
end

local function ss(value, scale)
    return math.floor(value * scale)
end

local function getFontSize(baseSize, scale)
    return math.floor(baseSize * scale)
end

function Announcement.show(player)
    if not CONFIG.enabled then return end
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "AnnouncementGui"
    screenGui.IgnoreGuiInset = true
    screenGui.ResetOnSpawn = false
    screenGui.Parent = player:WaitForChild("PlayerGui")
    
    local scale = getScale()
    local runService = game:GetService("RunService")
    local duration = CONFIG.waitTime
    
    local overlay = Instance.new("Frame")
    overlay.Size = UDim2.new(1, 0, 1, 0)
    overlay.BackgroundColor3 = Color3.fromRGB(20, 25, 35)
    overlay.BackgroundTransparency = 0.3
    overlay.BorderSizePixel = 0
    overlay.Parent = screenGui
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, ss(WINDOW_SIZE.width, scale), 0, ss(WINDOW_SIZE.height, scale))
    frame.Position = UDim2.new(0.5, -ss(WINDOW_SIZE.width, scale) / 2, 0.5, -ss(WINDOW_SIZE.height, scale) / 2)
    frame.BackgroundColor3 = Color3.fromRGB(30, 35, 50)
    frame.BackgroundTransparency = 0.1
    frame.BorderSizePixel = 0
    frame.Parent = screenGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 16)
    corner.Parent = frame
    
    local border = Instance.new("UIStroke")
    border.Thickness = 2
    border.Color = Color3.fromRGB(70, 90, 120)
    border.Transparency = 0.3
    border.Parent = frame
    
    -- 下雨效果
    local rainContainer = Instance.new("Frame")
    rainContainer.Size = UDim2.new(1, 0, 1, 0)
    rainContainer.BackgroundTransparency = 1
    rainContainer.ClipsDescendants = true
    rainContainer.Parent = frame
    
    local rainDrops = {}
    local rainCount = 70
    
    for i = 1, rainCount do
        local drop = Instance.new("Frame")
        drop.Size = UDim2.new(0, 2, 0, math.random(10, 18))
        drop.Position = UDim2.new(math.random() * 1, 0, math.random() * 1, 0)
        drop.BackgroundColor3 = Color3.fromRGB(100, 130, 180)
        drop.BackgroundTransparency = 0.5
        drop.BorderSizePixel = 0
        drop.Parent = rainContainer
        
        local speed = math.random(50, 90)
        table.insert(rainDrops, {frame = drop, speed = speed})
    end
    
    local rainConnection
    rainConnection = runService.Heartbeat:Connect(function(dt)
        for _, drop in ipairs(rainDrops) do
            local newY = drop.frame.Position.Y.Scale + (drop.speed * dt) / 100
            if newY > 1 then
                newY = -0.1
                drop.frame.Position = UDim2.new(math.random() * 1, 0, newY, 0)
            else
                drop.frame.Position = UDim2.new(drop.frame.Position.X.Scale, 0, newY, 0)
            end
        end
    end)
    
    -- 雾气效果
    local fog = Instance.new("Frame")
    fog.Size = UDim2.new(1, 0, 1, 0)
    fog.BackgroundColor3 = Color3.fromRGB(80, 100, 130)
    fog.BackgroundTransparency = 0.85
    fog.BorderSizePixel = 0
    fog.Parent = frame
    
    -- 标题
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -ss(20, scale), 0, ss(55, scale))
    titleLabel.Position = UDim2.new(0, ss(10, scale), 0, ss(10, scale))
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = CONFIG.title
    titleLabel.TextColor3 = Color3.fromRGB(160, 190, 220)
    titleLabel.TextSize = getFontSize(FONT_SIZES.title, scale)
    titleLabel.Font = Enum.Font.Gotham
    titleLabel.TextXAlignment = Enum.TextXAlignment.Center
    titleLabel.Parent = frame
    titleLabel.ZIndex = 2
    
    -- 分割线
    local divider = Instance.new("Frame")
    divider.Size = UDim2.new(1, -ss(20, scale), 0, 1)
    divider.Position = UDim2.new(0, ss(10, scale), 0, ss(65, scale))
    divider.BackgroundColor3 = Color3.fromRGB(70, 90, 120)
    divider.BackgroundTransparency = 0.5
    divider.BorderSizePixel = 0
    divider.Parent = frame
    divider.ZIndex = 2
    
    -- 内容
    local contentLabel = Instance.new("TextLabel")
    contentLabel.Size = UDim2.new(1, -ss(40, scale), 0, ss(190, scale))
    contentLabel.Position = UDim2.new(0, ss(20, scale), 0, ss(80, scale))
    contentLabel.BackgroundTransparency = 1
    contentLabel.Text = CONFIG.content
    contentLabel.TextColor3 = Color3.fromRGB(180, 190, 210)
    contentLabel.TextSize = getFontSize(FONT_SIZES.content, scale)
    contentLabel.Font = Enum.Font.Gotham
    contentLabel.LineHeight = 1.5
    contentLabel.Parent = frame
    contentLabel.ZIndex = 2
    
    if CONFIG.align == "center" then
        contentLabel.TextXAlignment = Enum.TextXAlignment.Center
        contentLabel.TextYAlignment = Enum.TextYAlignment.Center
    elseif CONFIG.align == "left" then
        contentLabel.TextXAlignment = Enum.TextXAlignment.Left
        contentLabel.TextYAlignment = Enum.TextYAlignment.Top
    elseif CONFIG.align == "right" then
        contentLabel.TextXAlignment = Enum.TextXAlignment.Right
        contentLabel.TextYAlignment = Enum.TextYAlignment.Top
    end
    
    -- 进度条
    local progressBg = Instance.new("Frame")
    progressBg.Size = UDim2.new(0, ss(280, scale), 0, ss(8, scale))
    progressBg.Position = UDim2.new(0.5, -ss(140, scale), 0, ss(295, scale))
    progressBg.BackgroundColor3 = Color3.fromRGB(40, 45, 60)
    progressBg.BorderSizePixel = 0
    progressBg.Parent = frame
    progressBg.ZIndex = 2
    
    local progressBgCorner = Instance.new("UICorner")
    progressBgCorner.CornerRadius = UDim.new(1, 0)
    progressBgCorner.Parent = progressBg
    
    local progressBar = Instance.new("Frame")
    progressBar.Size = UDim2.new(0, 0, 1, 0)
    progressBar.BackgroundColor3 = Color3.fromRGB(100, 150, 200)
    progressBar.BorderSizePixel = 0
    progressBar.Parent = progressBg
    
    local progressBarCorner = Instance.new("UICorner")
    progressBarCorner.CornerRadius = UDim.new(1, 0)
    progressBarCorner.Parent = progressBar
    
    -- 倒计时
    local timerLabel = Instance.new("TextLabel")
    timerLabel.Size = UDim2.new(1, 0, 0, ss(30, scale))
    timerLabel.Position = UDim2.new(0, 0, 0, ss(315, scale))
    timerLabel.BackgroundTransparency = 1
    timerLabel.Text = "等待 " .. duration .. " 秒"
    timerLabel.TextColor3 = Color3.fromRGB(130, 150, 180)
    timerLabel.TextSize = getFontSize(FONT_SIZES.timer, scale)
    timerLabel.Font = Enum.Font.Gotham
    timerLabel.TextXAlignment = Enum.TextXAlignment.Center
    timerLabel.Parent = frame
    timerLabel.ZIndex = 2
    
    -- 图标
    local tearIcon = Instance.new("TextLabel")
    tearIcon.Size = UDim2.new(0, ss(30, scale), 0, ss(30, scale))
    tearIcon.Position = UDim2.new(0.5, -ss(15, scale), 0, ss(355, scale))
    tearIcon.BackgroundTransparency = 1
    tearIcon.Text = "💧"
    tearIcon.TextColor3 = Color3.fromRGB(100, 150, 200)
    tearIcon.TextSize = getFontSize(FONT_SIZES.icon, scale)
    tearIcon.Font = Enum.Font.Gotham
    tearIcon.TextXAlignment = Enum.TextXAlignment.Center
    tearIcon.Parent = frame
    tearIcon.ZIndex = 2
    
    -- 确认按钮
    local confirmButton = Instance.new("TextButton")
    confirmButton.Size = UDim2.new(0, ss(140, scale), 0, ss(45, scale))
    confirmButton.Position = UDim2.new(0.5, -ss(70, scale), 0, ss(360, scale))
    confirmButton.BackgroundColor3 = Color3.fromRGB(50, 60, 80)
    confirmButton.BackgroundTransparency = 0
    confirmButton.Text = "确认"
    confirmButton.TextColor3 = Color3.fromRGB(150, 170, 200)
    confirmButton.TextSize = getFontSize(FONT_SIZES.button, scale)
    confirmButton.Font = Enum.Font.Gotham
    confirmButton.AutoButtonColor = false
    confirmButton.Parent = frame
    confirmButton.ZIndex = 2
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = confirmButton
    
    local btnBorder = Instance.new("UIStroke")
    btnBorder.Thickness = 1
    btnBorder.Color = Color3.fromRGB(100, 120, 150)
    btnBorder.Transparency = 0.5
    btnBorder.Parent = confirmButton
    
    -- 倒计时逻辑
    local startTime = os.time()
    
    local function updateProgress()
        local elapsed = os.time() - startTime
        local percent = math.min(1, elapsed / duration)
        local width = ss(280, scale) * percent
        progressBar:TweenSize(UDim2.new(0, width, 1, 0), "Out", "Linear", 0.1)
    end
    
    updateProgress()
    
    local timerConnection
    timerConnection = runService.Heartbeat:Connect(function()
        local elapsed = os.time() - startTime
        local remainingTime = duration - elapsed
        
        if remainingTime <= 0 then
            if timerConnection then timerConnection:Disconnect() end
            timerLabel.Text = "💧 可以确认了"
            timerLabel.TextColor3 = Color3.fromRGB(150, 200, 230)
            confirmButton.BackgroundColor3 = Color3.fromRGB(80, 100, 130)
            confirmButton.TextColor3 = Color3.fromRGB(200, 220, 250)
            progressBar.BackgroundColor3 = Color3.fromRGB(150, 200, 230)
            tearIcon.Text = "✓"
            tearIcon.TextColor3 = Color3.fromRGB(150, 200, 230)
        else
            local displayTime = math.ceil(remainingTime)
            timerLabel.Text = "等待 " .. displayTime .. " 秒"
            updateProgress()
        end
    end)
    
    confirmButton.MouseEnter:Connect(function()
        if os.time() - startTime >= duration then
            confirmButton.BackgroundColor3 = Color3.fromRGB(100, 120, 150)
            confirmButton.TextColor3 = Color3.fromRGB(220, 240, 255)
        end
    end)
    
    confirmButton.MouseLeave:Connect(function()
        if os.time() - startTime >= duration then
            confirmButton.BackgroundColor3 = Color3.fromRGB(80, 100, 130)
            confirmButton.TextColor3 = Color3.fromRGB(200, 220, 250)
        end
    end)
    
    confirmButton.MouseButton1Click:Connect(function()
        if os.time() - startTime >= duration then
            if timerConnection then timerConnection:Disconnect() end
            if rainConnection then rainConnection:Disconnect() end
            screenGui:Destroy()
        end
    end)
end

return Announcement