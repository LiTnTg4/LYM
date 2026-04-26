-- 主菜单模块
-- 废土终端的主要用户界面

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

local DropdownMenu = loadstring(game:HttpGet("https://raw.githubusercontent.com/YOUR_USERNAME/wasteland-terminal/main/src/ui/dropdown_menu.lua"))()

local MainMenu = {}
MainMenu.__index = MainMenu

function MainMenu.new(state)
    local self = setmetatable({}, MainMenu)
    self.state = state
    self.screenGui = nil
    self.mainFrame = nil
    self.isVisible = false
    self.dropdownMenu = DropdownMenu.new(state)
    
    -- 菜单尺寸相关
    self.menuWidth = 300
    self.menuHeight = 460
    self.minWidth = 200
    self.maxWidth = 600
    self.minHeight = 350
    self.maxHeight = 700
    self.menuLeft = nil
    self.menuTop = nil
    
    -- 调整大小相关
    self.isResizing = false
    self.resizeType = nil
    self.resizeStartPos = nil
    self.resizeStartWidth = nil
    self.resizeStartHeight = nil
    self.resizeStartLeft = nil
    self.resizeStartTop = nil
    self.resizeConnection = nil
    
    -- UI 元素引用
    self.hatToggleButton = nil
    self.hatStatus = nil
    self.detailButton = nil
    
    -- 模块回调
    self.onR6Toggle = nil
    self.onR15Toggle = nil
    self.onGraphicsToggle = nil
    self.onHatToggle = nil
    self.onUnload = nil
    self.onMinimize = nil
    self.onHatUpdate = nil
    
    return self
end

function MainMenu:getScale()
    local viewportSize = workspace.CurrentCamera.ViewportSize
    local referenceHeight = 1080
    return math.max(0.8, math.min(1.5, viewportSize.Y / referenceHeight))
end

-- 设置模块回调
function MainMenu:setCallbacks(callbacks)
    if callbacks.onR6Toggle then self.onR6Toggle = callbacks.onR6Toggle end
    if callbacks.onR15Toggle then self.onR15Toggle = callbacks.onR15Toggle end
    if callbacks.onGraphicsToggle then self.onGraphicsToggle = callbacks.onGraphicsToggle end
    if callbacks.onHatToggle then self.onHatToggle = callbacks.onHatToggle end
    if callbacks.onUnload then self.onUnload = callbacks.onUnload end
    if callbacks.onMinimize then self.onMinimize = callbacks.onMinimize end
    if callbacks.onHatUpdate then 
        self.onHatUpdate = callbacks.onHatUpdate
        self.dropdownMenu:setUpdateCallback(callbacks.onHatUpdate)
    end
end

function MainMenu:init()
    self.screenGui = Instance.new("ScreenGui")
    self.screenGui.Name = "DemoMenu"
    self.screenGui.IgnoreGuiInset = true
    self.screenGui.ResetOnSpawn = false
    self.screenGui.Parent = player:WaitForChild("PlayerGui")
    
    self:createMainFrame()
    self:createResizeHandles()
end

function MainMenu:createMainFrame()
    local scale = self:getScale()
    
    self.mainFrame = Instance.new("Frame")
    self.mainFrame.Size = UDim2.new(0, self.menuWidth, 0, self.menuHeight)
    
    local centerX = workspace.CurrentCamera.ViewportSize.X / 2
    local centerY = workspace.CurrentCamera.ViewportSize.Y / 2
    self.mainFrame.Position = UDim2.new(0, centerX - self.menuWidth/2, 0, centerY - self.menuHeight/2)
    self.mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    self.mainFrame.BackgroundTransparency = 0.05
    self.mainFrame.Active = true
    self.mainFrame.Draggable = true
    self.mainFrame.Visible = false
    self.mainFrame.Parent = self.screenGui
    
    self.menuLeft = self.mainFrame.Position.X.Offset
    self.menuTop = self.mainFrame.Position.Y.Offset
    
    -- 圆角和边框
    self:createCorner(self.mainFrame, 12)
    self:createStroke(self.mainFrame, 1, Color3.fromRGB(255, 255, 255), 0.3)
    
    -- 监听位置变化
    self.mainFrame:GetPropertyChangedSignal("Position"):Connect(function()
        if not self.isResizing then
            self.menuLeft = self.mainFrame.Position.X.Offset
            self.menuTop = self.mainFrame.Position.Y.Offset
        end
    end)
    
    -- 创建标题栏
    self:createTitleBar()
    
    -- 创建滚动框架
    local scrollFrame = Instance.new("ScrollingFrame")
    scrollFrame.Name = "ScrollFrame"
    scrollFrame.Size = UDim2.new(1, -16, 0, self.menuHeight - 95)
    scrollFrame.Position = UDim2.new(0, 8, 0, 46)
    scrollFrame.BackgroundTransparency = 1
    scrollFrame.ScrollBarThickness = 3
    scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(150, 150, 150)
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 400)
    scrollFrame.Parent = self.mainFrame
    
    -- 创建功能按钮
    self:createR6Button(scrollFrame, scale)
    self:createR15Button(scrollFrame, scale)
    self:createGraphicsButton(scrollFrame, scale)
    self:createHatToggleButton(scrollFrame, scale)
    self:createDetailButton(scrollFrame, scale)
    self:createHintLabel(scrollFrame, scale)
    self:createUnloadButton(scrollFrame, scale)
end

function MainMenu:createTitleBar()
    local scale = self:getScale()
    
    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 38 * scale)
    titleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    titleBar.BackgroundTransparency = 0.3
    titleBar.BorderSizePixel = 0
    titleBar.Parent = self.mainFrame
    
    self:createCorner(titleBar, 12)
    
    -- 标题文本
    local titleText = Instance.new("TextLabel")
    titleText.Size = UDim2.new(0.6, 0, 1, 0)
    titleText.Position = UDim2.new(0, 12 * scale, 0, 0)
    titleText.BackgroundTransparency = 1
    titleText.Text = "废土终端"
    titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleText.TextSize = 15
    titleText.Font = Enum.Font.Gotham
    titleText.TextXAlignment = Enum.TextXAlignment.Left
    titleText.Parent = titleBar
    
    -- 最小化按钮
    local minButton = Instance.new("TextButton")
    minButton.Size = UDim2.new(0, 32 * scale, 0, 28 * scale)
    minButton.Position = UDim2.new(1, -40 * scale, 0.5, -14 * scale)
    minButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    minButton.Text = "−"
    minButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    minButton.TextSize = 18
    minButton.Font = Enum.Font.Gotham
    minButton.Parent = titleBar
    
    self:createCorner(minButton, 6)
    
    minButton.MouseButton1Click:Connect(function()
        if self.onMinimize then
            self.onMinimize()
        end
    end)
end

function MainMenu:createR6Button(parent, scale)
    local r6Frame = Instance.new("TextButton")
    r6Frame.Size = UDim2.new(1, 0, 0, 42 * scale)
    r6Frame.Position = UDim2.new(0, 0, 0, 0)
    r6Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    r6Frame.BackgroundTransparency = 0
    r6Frame.BorderSizePixel = 0
    r6Frame.Text = "R6断腿"
    r6Frame.TextColor3 = Color3.fromRGB(200, 200, 200)
    r6Frame.TextSize = 13
    r6Frame.Font = Enum.Font.Gotham
    r6Frame.TextXAlignment = Enum.TextXAlignment.Left
    r6Frame.AutoButtonColor = false
    r6Frame.Parent = parent
    
    self:createCorner(r6Frame, 6)
    
    local r6Status = Instance.new("TextLabel")
    r6Status.Size = UDim2.new(0, 45, 1, 0)
    r6Status.Position = UDim2.new(1, -50, 0, 0)
    r6Status.BackgroundTransparency = 1
    r6Status.Text = "OFF"
    r6Status.TextColor3 = Color3.fromRGB(150, 150, 150)
    r6Status.TextSize = 11
    r6Status.Font = Enum.Font.Gotham
    r6Status.TextXAlignment = Enum.TextXAlignment.Right
    r6Status.Parent = r6Frame
    
    r6Frame.MouseButton1Click:Connect(function()
        if self.onR6Toggle then
            self.onR6Toggle()
            -- 更新按钮 UI
            local isOn = self.state.functionState.r6Leg
            if isOn then
                r6Frame.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                r6Status.Text = "ON"
                r6Status.TextColor3 = Color3.fromRGB(255, 255, 255)
            else
                r6Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                r6Status.Text = "OFF"
                r6Status.TextColor3 = Color3.fromRGB(150, 150, 150)
            end
        end
    end)
end

function MainMenu:createR15Button(parent, scale)
    local r15Frame = Instance.new("TextButton")
    r15Frame.Size = UDim2.new(1, 0, 0, 42 * scale)
    r15Frame.Position = UDim2.new(0, 0, 0, 46 * scale)
    r15Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    r15Frame.BackgroundTransparency = 0
    r15Frame.BorderSizePixel = 0
    r15Frame.Text = "R15断腿"
    r15Frame.TextColor3 = Color3.fromRGB(200, 200, 200)
    r15Frame.TextSize = 13
    r15Frame.Font = Enum.Font.Gotham
    r15Frame.TextXAlignment = Enum.TextXAlignment.Left
    r15Frame.AutoButtonColor = false
    r15Frame.Parent = parent
    
    self:createCorner(r15Frame, 6)
    
    local r15Status = Instance.new("TextLabel")
    r15Status.Size = UDim2.new(0, 45, 1, 0)
    r15Status.Position = UDim2.new(1, -50, 0, 0)
    r15Status.BackgroundTransparency = 1
    r15Status.Text = "OFF"
    r15Status.TextColor3 = Color3.fromRGB(150, 150, 150)
    r15Status.TextSize = 11
    r15Status.Font = Enum.Font.Gotham
    r15Status.TextXAlignment = Enum.TextXAlignment.Right
    r15Status.Parent = r15Frame
    
    r15Frame.MouseButton1Click:Connect(function()
        if self.onR15Toggle then
            self.onR15Toggle()
            local isOn = self.state.functionState.r15Leg
            if isOn then
                r15Frame.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                r15Status.Text = "ON"
                r15Status.TextColor3 = Color3.fromRGB(255, 255, 255)
            else
                r15Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                r15Status.Text = "OFF"
                r15Status.TextColor3 = Color3.fromRGB(150, 150, 150)
            end
        end
    end)
end

function MainMenu:createGraphicsButton(parent, scale)
    local gfxFrame = Instance.new("TextButton")
    gfxFrame.Size = UDim2.new(1, 0, 0, 42 * scale)
    gfxFrame.Position = UDim2.new(0, 0, 0, 92 * scale)
    gfxFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    gfxFrame.BackgroundTransparency = 0
    gfxFrame.BorderSizePixel = 0
    gfxFrame.Text = "画质优化"
    gfxFrame.TextColor3 = Color3.fromRGB(200, 200, 200)
    gfxFrame.TextSize = 13
    gfxFrame.Font = Enum.Font.Gotham
    gfxFrame.TextXAlignment = Enum.TextXAlignment.Left
    gfxFrame.AutoButtonColor = false
    gfxFrame.Parent = parent
    
    self:createCorner(gfxFrame, 6)
    
    local gfxStatus = Instance.new("TextLabel")
    gfxStatus.Size = UDim2.new(0, 45, 1, 0)
    gfxStatus.Position = UDim2.new(1, -50, 0, 0)
    gfxStatus.BackgroundTransparency = 1
    gfxStatus.Text = "OFF"
    gfxStatus.TextColor3 = Color3.fromRGB(150, 150, 150)
    gfxStatus.TextSize = 11
    gfxStatus.Font = Enum.Font.Gotham
    gfxStatus.TextXAlignment = Enum.TextXAlignment.Right
    gfxStatus.Parent = gfxFrame
    
    gfxFrame.MouseButton1Click:Connect(function()
        if self.onGraphicsToggle then
            self.onGraphicsToggle()
            local isOn = self.state.functionState.graphics
            if isOn then
                gfxFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                gfxStatus.Text = "ON"
                gfxStatus.TextColor3 = Color3.fromRGB(255, 255, 255)
            else
                gfxFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                gfxStatus.Text = "OFF"
                gfxStatus.TextColor3 = Color3.fromRGB(150, 150, 150)
            end
        end
    end)
end

function MainMenu:createHatToggleButton(parent, scale)
    self.hatToggleButton = Instance.new("TextButton")
    self.hatToggleButton.Size = UDim2.new(1, 0, 0, 42 * scale)
    self.hatToggleButton.Position = UDim2.new(0, 0, 0, 138 * scale)
    self.hatToggleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    self.hatToggleButton.BackgroundTransparency = 0
    self.hatToggleButton.BorderSizePixel = 0
    self.hatToggleButton.Text = "隐藏饰品"
    self.hatToggleButton.TextColor3 = Color3.fromRGB(200, 200, 200)
    self.hatToggleButton.TextSize = 13
    self.hatToggleButton.Font = Enum.Font.Gotham
    self.hatToggleButton.TextXAlignment = Enum.TextXAlignment.Left
    self.hatToggleButton.AutoButtonColor = false
    self.hatToggleButton.Parent = parent
    
    self:createCorner(self.hatToggleButton, 6)
    
    self.hatStatus = Instance.new("TextLabel")
    self.hatStatus.Size = UDim2.new(0, 45, 1, 0)
    self.hatStatus.Position = UDim2.new(1, -50, 0, 0)
    self.hatStatus.BackgroundTransparency = 1
    self.hatStatus.Text = "OFF"
    self.hatStatus.TextColor3 = Color3.fromRGB(150, 150, 150)
    self.hatStatus.TextSize = 11
    self.hatStatus.Font = Enum.Font.Gotham
    self.hatStatus.TextXAlignment = Enum.TextXAlignment.Right
    self.hatStatus.Parent = self.hatToggleButton
    
    self.hatToggleButton.MouseButton1Click:Connect(function()
        if self.onHatToggle then
            self.onHatToggle()
            self:updateHatButtonUI()
        end
    end)
end

function MainMenu:createDetailButton(parent, scale)
    self.detailButton = Instance.new("TextButton")
    self.detailButton.Size = UDim2.new(1, 0, 0, 36 * scale)
    self.detailButton.Position = UDim2.new(0, 0, 0, 184 * scale)
    self.detailButton.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    self.detailButton.BackgroundTransparency = 0
    self.detailButton.BorderSizePixel = 0
    self.detailButton.Text = "▼ 详细设置（选择部位）"
    self.detailButton.TextColor3 = Color3.fromRGB(180, 180, 200)
    self.detailButton.TextSize = 12
    self.detailButton.Font = Enum.Font.Gotham
    self.detailButton.AutoButtonColor = false
    self.detailButton.Parent = parent
    
    self:createCorner(self.detailButton, 6)
    
    self.detailButton.MouseButton1Click:Connect(function()
        local absPos = self.detailButton.AbsolutePosition
        self.dropdownMenu:open(Vector2.new(absPos.X + 10, absPos.Y))
    end)
end

function MainMenu:createHintLabel(parent, scale)
    local hintLabel = Instance.new("TextLabel")
    hintLabel.Size = UDim2.new(1, -10, 0, 45 * scale)
    hintLabel.Position = UDim2.new(0, 5, 0, 224 * scale)
    hintLabel.BackgroundTransparency = 1
    hintLabel.Text = "提示：开启总开关后，在详细设置中选择要隐藏的部位\n肩部：只隐藏肩甲/肩垫等饰品，不会隐藏手臂"
    hintLabel.TextColor3 = Color3.fromRGB(120, 120, 140)
    hintLabel.TextSize = 10
    hintLabel.Font = Enum.Font.Gotham
    hintLabel.TextXAlignment = Enum.TextXAlignment.Left
    hintLabel.Parent = parent
end

function MainMenu:createUnloadButton(parent, scale)
    local unloadFrame = Instance.new("Frame")
    unloadFrame.Size = UDim2.new(1, -10, 0, 42 * scale)
    unloadFrame.Position = UDim2.new(0, 5, 0, 350 * scale)
    unloadFrame.BackgroundColor3 = Color3.fromRGB(50, 30, 30)
    unloadFrame.BackgroundTransparency = 0
    unloadFrame.BorderSizePixel = 0
    unloadFrame.Parent = parent
    
    self:createCorner(unloadFrame, 6)
    
    local unloadText = Instance.new("TextLabel")
    unloadText.Size = UDim2.new(1, 0, 1, 0)
    unloadText.Position = UDim2.new(0, 12, 0, 0)
    unloadText.BackgroundTransparency = 1
    unloadText.Text = "卸载脚本"
    unloadText.TextColor3 = Color3.fromRGB(255, 120, 120)
    unloadText.TextSize = 13
    unloadText.Font = Enum.Font.Gotham
    unloadText.TextXAlignment = Enum.TextXAlignment.Left
    unloadText.Parent = unloadFrame
    
    local unloadButton = Instance.new("TextButton")
    unloadButton.Size = UDim2.new(1, 0, 1, 0)
    unloadButton.BackgroundTransparency = 1
    unloadButton.Text = ""
    unloadButton.Parent = unloadFrame
    
    unloadButton.MouseButton1Click:Connect(function()
        if self.onUnload then
            self.onUnload()
        end
    end)
end

function MainMenu:createResizeHandles()
    local scale = self:getScale()
    
    -- 右侧手柄
    local rightBar = Instance.new("Frame")
    rightBar.Size = UDim2.new(0, 8, 0, 50)
    rightBar.Position = UDim2.new(1, 5, 0.5, -25)
    rightBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    rightBar.BackgroundTransparency = 0.5
    rightBar.BorderSizePixel = 0
    rightBar.ZIndex = 10
    rightBar.Parent = self.mainFrame
    
    self:createCorner(rightBar, 2)
    
    -- 底部手柄
    local bottomBar = Instance.new("Frame")
    bottomBar.Size = UDim2.new(0, 50, 0, 8)
    bottomBar.Position = UDim2.new(0.5, -25, 1, 5)
    bottomBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    bottomBar.BackgroundTransparency = 0.5
    bottomBar.BorderSizePixel = 0
    bottomBar.ZIndex = 10
    bottomBar.Parent = self.mainFrame
    
    self:createCorner(bottomBar, 2)
    
    -- 悬停效果
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
    
    -- 调整大小逻辑
    rightBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            self:startResize("right", input)
        end
    end)
    
    bottomBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            self:startResize("bottom", input)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            self:stopResize()
        end
    end)
end

function MainMenu:startResize(type, input)
    self.isResizing = true
    self.resizeType = type
    self.resizeStartPos = Vector2.new(input.Position.X, input.Position.Y)
    self.resizeStartWidth = self.menuWidth
    self.resizeStartHeight = self.menuHeight
    self.resizeStartLeft = self.menuLeft
    self.resizeStartTop = self.menuTop
    
    if self.resizeConnection then 
        self.resizeConnection:Disconnect() 
    end
    
    self.resizeConnection = RunService.RenderStepped:Connect(function()
        if not self.isResizing then return end
        
        local currentPos = UserInputService:GetMouseLocation()
        local delta = currentPos - self.resizeStartPos
        
        if self.resizeType == "right" then
            local newWidth = math.clamp(
                self.resizeStartWidth + delta.X, 
                self.minWidth, 
                self.maxWidth
            )
            if newWidth ~= self.menuWidth then
                self.menuWidth = newWidth
                self.menuLeft = self.resizeStartLeft
                self:updateSize()
            end
        elseif self.resizeType == "bottom" then
            local newHeight = math.clamp(
                self.resizeStartHeight + delta.Y, 
                self.minHeight, 
                self.maxHeight
            )
            if newHeight ~= self.menuHeight then
                self.menuHeight = newHeight
                self.menuTop = self.resizeStartTop
                self:updateSize()
            end
        end
    end)
end

function MainMenu:stopResize()
    self.isResizing = false
    if self.resizeConnection then
        self.resizeConnection:Disconnect()
        self.resizeConnection = nil
    end
end

function MainMenu:updateSize()
    self.mainFrame.Size = UDim2.new(0, self.menuWidth, 0, self.menuHeight)
    self.mainFrame.Position = UDim2.new(0, self.menuLeft, 0, self.menuTop)
    
    local scrollFrame = self.mainFrame:FindFirstChild("ScrollFrame")
    if scrollFrame then
        scrollFrame.Size = UDim2.new(1, -16, 0, self.menuHeight - 95)
    end
end

function MainMenu:show()
    self.mainFrame.Visible = true
    self.isVisible = true
    
    local targetSize = self.mainFrame.Size
    local targetTransparency = self.mainFrame.BackgroundTransparency
    
    self.mainFrame.Size = UDim2.new(
        targetSize.X.Scale, 
        targetSize.X.Offset * 0.7, 
        targetSize.Y.Scale, 
        targetSize.Y.Offset * 0.7
    )
    self.mainFrame.BackgroundTransparency = 0.5
    
    local sizeInfo = TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    local transInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    
    local sizeTween = TweenService:Create(self.mainFrame, sizeInfo, {Size = targetSize})
    local transTween = TweenService:Create(
        self.mainFrame, 
        transInfo, 
        {BackgroundTransparency = targetTransparency}
    )
    
    sizeTween:Play()
    transTween:Play()
end

function MainMenu:hide(callback)
    if not self.mainFrame.Visible then
        if callback then callback() end
        return
    end
    
    local targetSize = self.mainFrame.Size
    
    local sizeInfo = TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.In)
    local transInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    
    local sizeTween = TweenService:Create(self.mainFrame, sizeInfo, {
        Size = UDim2.new(
            targetSize.X.Scale, 
            targetSize.X.Offset * 0.7, 
            targetSize.Y.Scale, 
            targetSize.Y.Offset * 0.7
        )
    })
    local transTween = TweenService:Create(
        self.mainFrame, 
        transInfo, 
        {BackgroundTransparency = 0.5}
    )
    
    sizeTween:Play()
    transTween:Play()
    
    sizeTween.Completed:Connect(function()
        self.mainFrame.Visible = false
        self.isVisible = false
        self.mainFrame.Size = targetSize
        self.mainFrame.BackgroundTransparency = 0.05
        if callback then callback() end
    end)
end

function MainMenu:isMenuVisible()
    return self.isVisible
end

function MainMenu:updateHatButtonUI()
    if self.hatStatus and self.hatToggleButton then
        if self.state.functionState.hat then
            self.hatStatus.Text = "ON"
            self.hatStatus.TextColor3 = Color3.fromRGB(255, 255, 255)
            self.hatToggleButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        else
            self.hatStatus.Text = "OFF"
            self.hatStatus.TextColor3 = Color3.fromRGB(150, 150, 150)
            self.hatToggleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        end
    end
end

function MainMenu:createCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius)
    corner.Parent = parent
    return corner
end

function MainMenu:createStroke(parent, thickness, color, transparency)
    local stroke = Instance.new("UIStroke")
    stroke.Thickness = thickness or 1
    stroke.Color = color or Color3.fromRGB(255, 255, 255)
    stroke.Transparency = transparency or 0.3
    stroke.Parent = parent
    return stroke
end

function MainMenu:unload()
    self.dropdownMenu:unload()
    if self.screenGui then
        self.screenGui:Destroy()
        self.screenGui = nil
    end
end

return MainMenu
