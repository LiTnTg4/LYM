-- UI 组件工具模块
-- 提供创建常用 UI 组件的便捷方法

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local Components = {}

-- 获取屏幕缩放比例
function Components.getScale()
    local viewportSize = workspace.CurrentCamera.ViewportSize
    local referenceHeight = 1080
    return math.max(0.8, math.min(1.5, viewportSize.Y / referenceHeight))
end

-- 创建圆角
function Components.createCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius)
    corner.Parent = parent
    return corner
end

-- 创建边框
function Components.createStroke(parent, thickness, color, transparency)
    local stroke = Instance.new("UIStroke")
    stroke.Thickness = thickness or 1
    stroke.Color = color or Color3.fromRGB(255, 255, 255)
    stroke.Transparency = transparency or 0.3
    stroke.Parent = parent
    return stroke
end

-- 创建按钮
function Components.createButton(parent, size, position, text, textColor, bgColor)
    local button = Instance.new("TextButton")
    button.Size = size
    button.Position = position
    button.Text = text or ""
    button.TextColor3 = textColor or Color3.fromRGB(200, 200, 200)
    button.TextSize = 13
    button.Font = Enum.Font.Gotham
    button.BackgroundColor3 = bgColor or Color3.fromRGB(30, 30, 30)
    button.BackgroundTransparency = 0
    button.BorderSizePixel = 0
    button.AutoButtonColor = false
    button.Parent = parent
    return button
end

-- 创建标签
function Components.createLabel(parent, size, position, text, textColor, fontSize)
    local label = Instance.new("TextLabel")
    label.Size = size
    label.Position = position
    label.BackgroundTransparency = 1
    label.Text = text or ""
    label.TextColor3 = textColor or Color3.fromRGB(255, 255, 255)
    label.TextSize = fontSize or 13
    label.Font = Enum.Font.Gotham
    label.Parent = parent
    return label
end

-- 创建帧
function Components.createFrame(parent, size, position, bgColor, transparency, borderSize)
    local frame = Instance.new("Frame")
    frame.Size = size
    frame.Position = position
    frame.BackgroundColor3 = bgColor or Color3.fromRGB(20, 20, 20)
    frame.BackgroundTransparency = transparency or 0
    frame.BorderSizePixel = borderSize or 0
    frame.Parent = parent
    return frame
end

-- 创建滚动帧
function Components.createScrollingFrame(parent, size, position, canvasSize, scrollBarColor)
    local sf = Instance.new("ScrollingFrame")
    sf.Size = size
    sf.Position = position
    sf.BackgroundTransparency = 1
    sf.ScrollBarThickness = 3
    sf.ScrollBarImageColor3 = scrollBarColor or Color3.fromRGB(150, 150, 150)
    sf.CanvasSize = canvasSize or UDim2.new(0, 0, 0, 400)
    sf.Parent = parent
    return sf
end

-- 创建标题栏
function Components.createTitleBar(parent, title, onMinimize)
    local scale = Components.getScale()
    
    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 38 * scale)
    titleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    titleBar.BackgroundTransparency = 0.3
    titleBar.BorderSizePixel = 0
    titleBar.Parent = parent
    
    Components.createCorner(titleBar, 12)
    
    -- 标题文本
    local titleText = Components.createLabel(
        titleBar,
        UDim2.new(0.7, 0, 1, 0),
        UDim2.new(0, 12 * scale, 0, 0),
        title or "废土终端",
        Color3.fromRGB(255, 255, 255),
        15
    )
    titleText.TextXAlignment = Enum.TextXAlignment.Left
    
    -- 最小化按钮
    if onMinimize then
        local minButton = Components.createButton(
            titleBar,
            UDim2.new(0, 32 * scale, 0, 28 * scale),
            UDim2.new(1, -40 * scale, 0.5, -14 * scale),
            "−",
            Color3.fromRGB(255, 255, 255),
            Color3.fromRGB(60, 60, 60)
        )
        minButton.TextSize = 18
        Components.createCorner(minButton, 6 * scale)
        minButton.MouseButton1Click:Connect(onMinimize)
    end
    
    return titleBar
end

-- 创建状态按钮（带 ON/OFF 状态显示）
function Components.createStatusButton(parent, size, position, text, callback)
    local scale = Components.getScale()
    
    local statusFrame = Components.createButton(
        parent,
        size,
        position,
        text,
        Color3.fromRGB(200, 200, 200),
        Color3.fromRGB(30, 30, 30)
    )
    statusFrame.TextXAlignment = Enum.TextXAlignment.Left
    Components.createCorner(statusFrame, 6 * scale)
    
    local statusLabel = Components.createLabel(
        statusFrame,
        UDim2.new(0, 45, 1, 0),
        UDim2.new(1, -50 * scale, 0, 0),
        "OFF",
        Color3.fromRGB(150, 150, 150),
        11
    )
    statusLabel.TextXAlignment = Enum.TextXAlignment.Right
    
    local isOn = false
    
    local function toggle(newState)
        if newState ~= nil then
            isOn = newState
        else
            isOn = not isOn
        end
        
        if isOn then
            statusFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            statusLabel.Text = "ON"
            statusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        else
            statusFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            statusLabel.Text = "OFF"
            statusLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
        end
        
        if callback then
            callback(isOn)
        end
    end
    
    statusFrame.MouseButton1Click:Connect(function()
        toggle()
    end)
    
    return {
        frame = statusFrame,
        toggle = toggle,
        isOn = function() return isOn end
    }
end

-- 创建调整大小手柄
function Components.createResizeHandles(parent, onResizeStart)
    local scale = Components.getScale()
    
    local handles = {}
    
    -- 右侧手柄
    local rightBar = Instance.new("Frame")
    rightBar.Size = UDim2.new(0, 8 * scale, 0, 50 * scale)
    rightBar.Position = UDim2.new(1, 5 * scale, 0.5, -25 * scale)
    rightBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    rightBar.BackgroundTransparency = 0.5
    rightBar.BorderSizePixel = 0
    rightBar.ZIndex = 10
    rightBar.Parent = parent
    Components.createCorner(rightBar, 2)
    
    -- 底部手柄
    local bottomBar = Instance.new("Frame")
    bottomBar.Size = UDim2.new(0, 50 * scale, 0, 8 * scale)
    bottomBar.Position = UDim2.new(0.5, -25 * scale, 1, 5 * scale)
    bottomBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    bottomBar.BackgroundTransparency = 0.5
    bottomBar.BorderSizePixel = 0
    bottomBar.ZIndex = 10
    bottomBar.Parent = parent
    Components.createCorner(bottomBar, 2)
    
    -- 鼠标悬停效果
    local function onEnter(bar)
        bar.BackgroundTransparency = 0.2
    end
    
    local function onLeave(bar)
        bar.BackgroundTransparency = 0.5
    end
    
    rightBar.MouseEnter:Connect(function() onEnter(rightBar) end)
    rightBar.MouseLeave:Connect(function() onLeave(rightBar) end)
    bottomBar.MouseEnter:Connect(function() onEnter(bottomBar) end)
    bottomBar.MouseLeave:Connect(function() onLeave(bottomBar) end)
    
    -- 输入事件
    rightBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            if onResizeStart then onResizeStart("right", input) end
        end
    end)
    
    bottomBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            if onResizeStart then onResizeStart("bottom", input) end
        end
    end)
    
    handles.right = rightBar
    handles.bottom = bottomBar
    handles.destroy = function()
        rightBar:Destroy()
        bottomBar:Destroy()
    end
    
    return handles
end

-- 创建弹入动画
function Components.playBounceIn(frame, callback)
    local targetSize = frame.Size
    local targetTransparency = frame.BackgroundTransparency
    
    -- 初始状态
    frame.Size = UDim2.new(
        targetSize.X.Scale, 
        targetSize.X.Offset * 0.7, 
        targetSize.Y.Scale, 
        targetSize.Y.Offset * 0.7
    )
    frame.BackgroundTransparency = 0.5
    
    -- 动画
    local sizeInfo = TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    local transInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    
    local sizeTween = TweenService:Create(frame, sizeInfo, {Size = targetSize})
    local transTween = TweenService:Create(frame, transInfo, {BackgroundTransparency = targetTransparency})
    
    sizeTween:Play()
    transTween:Play()
    
    if callback then
        sizeTween.Completed:Connect(callback)
    end
end

-- 创建弹出动画
function Components.playBounceOut(frame, hideAfter, callback)
    local targetSize = frame.Size
    
    local sizeInfo = TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.In)
    local transInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    
    local sizeTween = TweenService:Create(frame, sizeInfo, {
        Size = UDim2.new(
            targetSize.X.Scale, 
            targetSize.X.Offset * 0.7, 
            targetSize.Y.Scale, 
            targetSize.Y.Offset * 0.7
        )
    })
    local transTween = TweenService:Create(frame, transInfo, {BackgroundTransparency = 0.5})
    
    sizeTween:Play()
    transTween:Play()
    
    if hideAfter then
        sizeTween.Completed:Connect(function()
            frame.Visible = false
            frame.Size = targetSize
            if callback then callback() end
        end)
    elseif callback then
        sizeTween.Completed:Connect(callback)
    end
end

-- 创建提示文本
function Components.createHint(parent, size, position, text)
    return Components.createLabel(
        parent,
        size,
        position,
        text,
        Color3.fromRGB(120, 120, 140),
        10
    )
end

-- 创建危险按钮（红色样式，用于卸载等操作）
function Components.createDangerButton(parent, size, position, text, callback)
    local scale = Components.getScale()
    
    local container = Components.createFrame(
        parent,
        size,
        position,
        Color3.fromRGB(50, 30, 30),
        0
    )
    Components.createCorner(container, 6 * scale)
    
    local label = Components.createLabel(
        container,
        UDim2.new(1, 0, 1, 0),
        UDim2.new(0, 12 * scale, 0, 0),
        text or "卸载脚本",
        Color3.fromRGB(255, 120, 120),
        13
    )
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 1, 0)
    button.BackgroundTransparency = 1
    button.Text = ""
    button.Parent = container
    
    if callback then
        button.MouseButton1Click:Connect(callback)
    end
    
    return {
        container = container,
        button = button,
        label = label,
        setText = function(t) label.Text = t end
    }
end

return Components
