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
    
    -- 主框架
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 320, 0, 80)
    frame.Position = UDim2.new(1, -340, 0, 20)
    frame.BackgroundColor3 = Color3.fromRGB(25, 27, 35)
    frame.BackgroundTransparency = 0.1
    frame.BorderSizePixel = 0
    frame.Parent = gui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame
    
    -- 左侧彩色条
    local colorBar = Instance.new("Frame")
    colorBar.Size = UDim2.new(0, 4, 1, 0)
    if type == "success" then
        colorBar.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
    elseif type == "info" then
        colorBar.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    elseif type == "warning" then
        colorBar.BackgroundColor3 = Color3.fromRGB(255, 170, 0)
    else
        colorBar.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
    end
    colorBar.BorderSizePixel = 0
    colorBar.Parent = frame
    
    -- 图标
    local icon = Instance.new("TextLabel")
    icon.Size = UDim2.new(0, 30, 0, 30)
    icon.Position = UDim2.new(0, 15, 0, 25)
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
    icon.TextSize = 24
    icon.Font = Enum.Font.GothamBold
    icon.Parent = frame
    
    -- 标题
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -60, 0, 25)
    titleLabel.Position = UDim2.new(0, 50, 0, 15)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextSize = 16
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = frame
    
    -- 消息
    local msgLabel = Instance.new("TextLabel")
    msgLabel.Size = UDim2.new(1, -60, 0, 20)
    msgLabel.Position = UDim2.new(0, 50, 0, 40)
    msgLabel.BackgroundTransparency = 1
    msgLabel.Text = message
    msgLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
    msgLabel.TextSize = 14
    msgLabel.Font = Enum.Font.Gotham
    msgLabel.TextXAlignment = Enum.TextXAlignment.Left
    msgLabel.Parent = frame
    
    -- 进度条
    local progressBar = Instance.new("Frame")
    progressBar.Size = UDim2.new(1, 0, 0, 2)
    progressBar.Position = UDim2.new(0, 0, 1, -2)
    progressBar.BackgroundColor3 = type == "success" and Color3.fromRGB(0, 200, 100) 
        or type == "info" and Color3.fromRGB(0, 150, 255)
        or type == "warning" and Color3.fromRGB(255, 170, 0)
        or Color3.fromRGB(255, 80, 80)
    progressBar.BorderSizePixel = 0
    progressBar.Parent = frame
    
    -- 入场动画
    frame.Position = UDim2.new(1, -340, 0, -100)
    frame:TweenPosition(UDim2.new(1, -340, 0, 20), "Out", "Quad", 0.3, true)
    
    progressBar.Size = UDim2.new(1, 0, 0, 2)
    progressBar:TweenSize(UDim2.new(0, 0, 0, 2), "In", "Linear", duration, true)
    
    task.wait(duration)
    
    frame:TweenPosition(UDim2.new(1, -340, 0, -100), "In", "Quad", 0.3, true)
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