-- 下拉菜单模块
-- 用于选择要隐藏的饰品部位

local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

local DropdownMenu = {}
DropdownMenu.__index = DropdownMenu

function DropdownMenu.new(state)
    local self = setmetatable({}, DropdownMenu)
    self.state = state
    self.dropdownFrame = nil
    self.isOpen = false
    self.onUpdateCallback = nil
    return self
end

function DropdownMenu:getScale()
    local viewportSize = workspace.CurrentCamera.ViewportSize
    local referenceHeight = 1080
    return math.max(0.8, math.min(1.5, viewportSize.Y / referenceHeight))
end

function DropdownMenu:setUpdateCallback(callback)
    self.onUpdateCallback = callback
end

function DropdownMenu:open(position)
    -- 如果已经打开，先关闭
    if self.isOpen then
        self:close()
        return
    end
    
    self.isOpen = true
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "DetailMenu"
    screenGui.IgnoreGuiInset = true
    screenGui.ResetOnSpawn = false
    screenGui.Parent = player:WaitForChild("PlayerGui")
    self.dropdownFrame = screenGui
    
    local scale = self:getScale()
    local menuWidth = 210
    local itemHeight = 38
    local itemCount = 7
    
    local contentHeight = itemCount * (itemHeight + 4) * scale
    local panelHeight = math.min(contentHeight + 40 * scale, 320 * scale)
    
    -- 主面板
    local panel = Instance.new("Frame")
    panel.Size = UDim2.new(0, menuWidth * scale * 0.7, 0, panelHeight * 0.7)
    panel.Position = UDim2.new(0, position.X + menuWidth * scale * 0.15, 0, position.Y + 40 * scale)
    panel.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    panel.BackgroundTransparency = 0.5
    panel.BorderSizePixel = 0
    panel.Parent = screenGui
    
    -- 圆角和边框
    local panelCorner = Instance.new("UICorner")
    panelCorner.CornerRadius = UDim.new(0, 8)
    panelCorner.Parent = panel
    
    local panelBorder = Instance.new("UIStroke")
    panelBorder.Thickness = 1
    panelBorder.Color = Color3.fromRGB(255, 255, 255)
    panelBorder.Transparency = 0.3
    panelBorder.Parent = panel
    
    -- 标题栏
    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 32 * scale)
    titleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    titleBar.BackgroundTransparency = 0.3
    titleBar.BorderSizePixel = 0
    titleBar.Parent = panel
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 8)
    titleCorner.Parent = titleBar
    
    -- 标题文本
    local titleText = Instance.new("TextLabel")
    titleText.Size = UDim2.new(0.8, 0, 1, 0)
    titleText.Position = UDim2.new(0, 10 * scale, 0, 0)
    titleText.BackgroundTransparency = 1
    titleText.Text = "选择要隐藏的部位"
    titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleText.TextSize = 12 * scale
    titleText.Font = Enum.Font.Gotham
    titleText.TextXAlignment = Enum.TextXAlignment.Left
    titleText.Parent = titleBar
    
    -- 关闭按钮
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 24 * scale, 0, 24 * scale)
    closeBtn.Position = UDim2.new(1, -28 * scale, 0.5, -12 * scale)
    closeBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.TextSize = 12 * scale
    closeBtn.Font = Enum.Font.Gotham
    closeBtn.Parent = titleBar
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 4)
    closeCorner.Parent = closeBtn
    
    closeBtn.MouseButton1Click:Connect(function()
        self:close()
    end)
    
    -- 滚动帧
    local scrollFrame = Instance.new("ScrollingFrame")
    scrollFrame.Size = UDim2.new(1, -4 * scale, 0, panelHeight - 40 * scale)
    scrollFrame.Position = UDim2.new(0, 2 * scale, 0, 32 * scale)
    scrollFrame.BackgroundTransparency = 1
    scrollFrame.ScrollBarThickness = 3
    scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(150, 150, 150)
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, contentHeight)
    scrollFrame.Parent = panel
    
    -- 部位列表
    local hatTypes = {"头部", "表情", "颈部", "背面", "腰部", "肩部", "正面"}
    
    for i, hatType in ipairs(hatTypes) do
        self:createMenuItem(scrollFrame, i, hatType, itemHeight, scale)
    end
    
    -- 入场动画
    local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    local sizeTween = TweenService:Create(panel, tweenInfo, {
        Size = UDim2.new(0, menuWidth * scale, 0, panelHeight)
    })
    local posTween = TweenService:Create(panel, tweenInfo, {
        Position = UDim2.new(0, position.X, 0, position.Y + 40 * scale)
    })
    local transTween = TweenService:Create(panel, TweenInfo.new(0.15), {
        BackgroundTransparency = 0.05
    })
    
    sizeTween:Play()
    posTween:Play()
    transTween:Play()
end

function DropdownMenu:createMenuItem(parent, index, hatType, itemHeight, scale)
    local isOn = self.state.hatSettings[hatType] or false
    
    -- 项目按钮
    local itemBtn = Instance.new("TextButton")
    itemBtn.Size = UDim2.new(1, -8 * scale, 0, itemHeight * scale)
    itemBtn.Position = UDim2.new(0, 4 * scale, 0, (index - 1) * (itemHeight + 4) * scale)
    itemBtn.BackgroundColor3 = isOn and Color3.fromRGB(65, 65, 65) or Color3.fromRGB(35, 35, 35)
    itemBtn.BackgroundTransparency = 0
    itemBtn.BorderSizePixel = 0
    itemBtn.Text = ""
    itemBtn.AutoButtonColor = false
    itemBtn.Parent = parent
    
    local itemCorner = Instance.new("UICorner")
    itemCorner.CornerRadius = UDim.new(0, 6)
    itemCorner.Parent = itemBtn
    
    -- 名称标签
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.6, -8 * scale, 1, 0)
    label.Position = UDim2.new(0, 12 * scale, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = hatType
    label.TextColor3 = isOn and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(180, 180, 180)
    label.TextSize = 12 * scale
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = itemBtn
    
    -- 状态指示灯
    local statusLight = Instance.new("Frame")
    statusLight.Size = UDim2.new(0, 8 * scale, 0, 8 * scale)
    statusLight.Position = UDim2.new(1, -18 * scale, 0.5, -4 * scale)
    statusLight.BackgroundColor3 = isOn and Color3.fromRGB(80, 200, 80) or Color3.fromRGB(60, 60, 60)
    statusLight.BackgroundTransparency = 0
    statusLight.BorderSizePixel = 0
    statusLight.Parent = itemBtn
    
    local statusCorner = Instance.new("UICorner")
    statusCorner.CornerRadius = UDim.new(1, 0)
    statusCorner.Parent = statusLight
    
    -- 状态文本
    local statusText = Instance.new("TextLabel")
    statusText.Size = UDim2.new(0, 40 * scale, 1, 0)
    statusText.Position = UDim2.new(1, -58 * scale, 0, 0)
    statusText.BackgroundTransparency = 1
    statusText.Text = isOn and "ON" or "OFF"
    statusText.TextColor3 = isOn and Color3.fromRGB(80, 200, 80) or Color3.fromRGB(150, 150, 150)
    statusText.TextSize = 11 * scale
    statusText.Font = Enum.Font.Gotham
    statusText.TextXAlignment = Enum.TextXAlignment.Right
    statusText.Parent = itemBtn
    
    -- 更新 UI 状态的函数
    local function updateUI(newState)
        itemBtn.BackgroundColor3 = newState and Color3.fromRGB(65, 65, 65) or Color3.fromRGB(35, 35, 35)
        label.TextColor3 = newState and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(180, 180, 180)
        statusLight.BackgroundColor3 = newState and Color3.fromRGB(80, 200, 80) or Color3.fromRGB(60, 60, 60)
        statusText.Text = newState and "ON" or "OFF"
        statusText.TextColor3 = newState and Color3.fromRGB(80, 200, 80) or Color3.fromRGB(150, 150, 150)
    end
    
    -- 点击事件：切换状态
    itemBtn.MouseButton1Click:Connect(function()
        self.state.hatSettings[hatType] = not self.state.hatSettings[hatType]
        local newState = self.state.hatSettings[hatType]
        updateUI(newState)
        
        -- 如果总开关开启，立即更新隐藏效果
        if self.onUpdateCallback then
            self.onUpdateCallback()
        end
    end)
    
    -- 悬停效果
    itemBtn.MouseEnter:Connect(function()
        if not self.state.hatSettings[hatType] then
            itemBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        end
    end)
    
    itemBtn.MouseLeave:Connect(function()
        if self.state.hatSettings[hatType] then
            itemBtn.BackgroundColor3 = Color3.fromRGB(65, 65, 65)
        else
            itemBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        end
    end)
end

function DropdownMenu:close()
    if self.dropdownFrame then
        self.dropdownFrame:Destroy()
        self.dropdownFrame = nil
    end
    self.isOpen = false
end

function DropdownMenu:toggle(position)
    if self.isOpen then
        self:close()
    else
        self:open(position)
    end
end

function DropdownMenu:unload()
    self:close()
end

return DropdownMenu
