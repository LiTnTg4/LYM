local Notification = {}

function Notification.show(title, message, duration, type)
    duration = duration or 3
    type = type or "success"
    
    local p = game:GetService("Players").LocalPlayer
    local gui = Instance.new("ScreenGui")
    gui.Name = "LYM_Notification"
    gui.IgnoreGuiInset = true
    gui.DisplayOrder = 1000
    gui.Parent = p:WaitForChild("PlayerGui")
    
    -- 主框架 (右上角)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 340, 0, 90)
    frame.Position = UDim2.new(1, -360, 0, 20)
    frame.BackgroundColor3 = Color3.fromRGB(25, 27, 35)
    frame.BackgroundTransparency = 0.1
    frame.BorderSizePixel = 0
    frame.Parent = gui
    
    -- 圆角
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = frame
    
    -- 阴影
    local shadow = Instance.new("ImageLabel")
    shadow.Size = UDim2.new(1, 20, 1, 20)
    shadow.Position = UDim2.new(0, -10, 0, -10)
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxassetid://1316045217"
    shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    shadow.ImageTransparency = 0.5
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(10, 10, 118, 118)
    shadow.Parent = frame
    
    -- 左侧彩色条
    local colorBar = Instance.new("Frame")
    colorBar.Size = UDim2.new(0, 5, 1, -20)
    colorBar.Position = UDim2.new(0, 0, 0, 10)
    colorBar.BackgroundColor3 = type == "success" and Color3.fromRGB(0, 200, 100) 
        or type == "info" and Color3.fromRGB(0, 150, 255)
        or type == "warning" and Color3.fromRGB(255, 170, 0)
        or Color3.fromRGB(255, 80, 80)
    colorBar.BorderSizePixel = 0
    colorBar.Parent = frame
    
    -- 圆角
    local barCorner = Instance.new("UICorner")
    barCorner.CornerRadius = UDim.new(0, 5)
    barCorner.Parent = colorBar
    
    -- 图标
    local icon = Instance.new("TextLabel")
    icon.Size = UDim2.new(0, 40, 0, 40)
    icon.Position = UDim2.new(0, 20, 0, 25)
    icon.BackgroundTransparency = 1
    if type == "success" then
        icon.Text = "✓"
        icon.TextColor3 = Color3.fromRGB(0, 200, 100)
    elseif type == "info" then
        icon.Text = "ℹ"
        icon.TextColor3 = Color3.fromRGB(0, 150, 255)
    elseif type == "warning" then
        icon.Text = "⚠"
        icon.TextColor3 = Color3.fromRGB(255, 170, 0)
    else
        icon.Text = "✗"
        icon.TextColor3 = Color3.fromRGB(255, 80, 80)
    end
    icon.TextSize = 30
    icon.Font = Enum.Font.GothamBold
    icon.Parent = frame
    
    -- 标题
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -80, 0, 25)
    titleLabel.Position = UDim2.new(0, 70, 0, 20)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextSize = 18
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = frame
    
    -- 消息
    local msgLabel = Instance.new("TextLabel")
    msgLabel.Size = UDim2.new(1, -80, 0, 20)
    msgLabel.Position = UDim2.new(0, 70, 0, 45)
    msgLabel.BackgroundTransparency = 1
    msgLabel.Text = message
    msgLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    msgLabel.TextSize = 14
    msgLabel.Font = Enum.Font.Gotham
    msgLabel.TextXAlignment = Enum.TextXAlignment.Left
    msgLabel.Parent = frame
    
    -- 时间
    local timeLabel = Instance.new("TextLabel")
    timeLabel.Size = UDim2.new(1, -20, 0, 15)
    timeLabel.Position = UDim2.new(0, 15, 1, -20)
    timeLabel.BackgroundTransparency = 1
    timeLabel.Text = os.date("%H:%M:%S")
    timeLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
    timeLabel.TextSize = 11
    timeLabel.Font = Enum.Font.Gotham
    timeLabel.TextXAlignment = Enum.TextXAlignment.Left
    timeLabel.Parent = frame
    
    -- 进度条背景
    local progressBg = Instance.new("Frame")
    progressBg.Size = UDim2.new(1, -20, 0, 3)
    progressBg.Position = UDim2.new(0, 10, 1, -5)
    progressBg.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    progressBg.BorderSizePixel = 0
    progressBg.Parent = frame
    
    local progressCorner = Instance.new("UICorner")
    progressCorner.CornerRadius = UDim.new(0, 2)
    progressCorner.Parent = progressBg
    
    -- 进度条
    local progressBar = Instance.new("Frame")
    progressBar.Size = UDim2.new(1, 0, 1, 0)
    progressBar.BackgroundColor3 = type == "success" and Color3.fromRGB(0, 200, 100) 
        or type == "info" and Color3.fromRGB(0, 150, 255)
        or type == "warning" and Color3.fromRGB(255, 170, 0)
        or Color3.fromRGB(255, 80, 80)
    progressBar.BorderSizePixel = 0
    progressBar.Parent = progressBg
    
    local barCorner2 = Instance.new("UICorner")
    barCorner2.CornerRadius = UDim.new(0, 2)
    barCorner2.Parent = progressBar
    
    -- 入场动画
    frame.Position = UDim2.new(1, -360, 0, -100)
    frame:TweenPosition(UDim2.new(1, -360, 0, 20), "Out", "Back", 0.5, true)
    
    -- 进度条动画
    progressBar.Size = UDim2.new(1, 0, 1, 0)
    progressBar:TweenSize(UDim2.new(0, 0, 1, 0), "In", "Linear", duration, true)
    
    -- 自动消失
    task.wait(duration)
    
    frame:TweenPosition(UDim2.new(1, -360, 0, -100), "In", "Back", 0.3, true)
    task.wait(0.3)
    gui:Destroy()
end

-- 便捷方法
function Notification.success(title, message, duration)
    Notification.show(title, message, duration, "success")
end

function Notification.info(title, message, duration)
    Notification.show(title, message, duration, "info")
end

function Notification.warning(title, message, duration)
    Notification.show(title, message, duration, "warning")
end

function Notification.error(title, message, duration)
    Notification.show(title, message, duration, "error")
end

return Notification