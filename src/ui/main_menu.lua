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
               
