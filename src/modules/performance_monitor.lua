-- 性能监控模块

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

local PerformanceMonitor = {}
PerformanceMonitor.__index = PerformanceMonitor

function PerformanceMonitor.new(state)
    local self = setmetatable({}, PerformanceMonitor)
    self.state = state
    self.screenGui = nil
    self.dragFrame = nil
    self.perfText = nil
    return self
end

function PerformanceMonitor:init()
    self.screenGui = Instance.new("ScreenGui")
    self.screenGui.Name = "PerfMonitor"
    self.screenGui.IgnoreGuiInset = true
    self.screenGui.ResetOnSpawn = false
    self.screenGui.Parent = player:WaitForChild("PlayerGui")
    
    local scale = self:getScale()
    local savedPosition = nil
    
    self.dragFrame = Instance.new("Frame")
    self.dragFrame.Size = UDim2.new(0, 0, 0, 28 * scale)
    self.dragFrame.Position = UDim2.new(0.5, 0, 0.05, 0)
    self.dragFrame.BackgroundTransparency = 1
    self.dragFrame.Active = true
    self.dragFrame.Draggable = true
    self.dragFrame.Parent = self.screenGui
    
    self.dragFrame:GetPropertyChangedSignal("Position"):Connect(function()
        savedPosition = self.dragFrame.Position
    end)
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.Position = UDim2.new(0, 0, 0, 0)
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    frame.BackgroundTransparency = 0.1
    frame.BorderSizePixel = 0
    frame.Parent = self.dragFrame
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = frame
    
    local border = Instance.new("UIStroke")
    border.Thickness = 1
    border.Color = Color3.fromRGB(255, 255, 255)
    border.Transparency = 0.3
    border.Parent = frame
    
    self.perfText = Instance.new("TextButton")
    self.perfText.BackgroundTransparency = 1
    self.perfText.Text = "FPS:060 PING:088ms"
    self.perfText.TextColor3 = Color3.fromRGB(255, 255, 255)
    self.perfText.TextSize = math.floor(14 * scale)
    self.perfText.Font = Enum.Font.Gotham
    self.perfText.TextXAlignment = Enum.TextXAlignment.Left
    self.perfText.TextYAlignment = Enum.TextYAlignment.Center
    self.perfText.Size = UDim2.new(1, 0, 1, 0)
    self.perfText.Parent = frame
    
    self:updateFrameSize()
    
    workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
        scale = self:getScale()
        border.Thickness = math.max(1, math.floor(1 * scale))
        self.perfText.TextSize = math.floor(14 * scale)
        self:updateFrameSize()
    end)
    
    local fc = 0
    local lastTime = os.clock()
    
    RunService.RenderStepped:Connect(function()
        if self.state.isUnloaded then return end
        
        local now = os.clock()
        local delta = now - lastTime
        
        if delta >= 1 then
            local fps = math.floor(fc / delta)
            local ping = 0
            pcall(function()
                ping = math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue())
            end)
            self.perfText.Text = string.format("FPS:%03d PING:%03dms", fps, ping)
            self:updateFrameSize()
            fc = 0
            lastTime = now
        end
        fc = fc + 1
    end)
end

function PerformanceMonitor:getScale()
    local viewportSize = workspace.CurrentCamera.ViewportSize
    local referenceHeight = 1080
    return math.max(0.8, math.min(1.5, viewportSize.Y / referenceHeight))
end

function PerformanceMonitor:updateFrameSize()
    if not self.perfText or not self.dragFrame then return end
    
    local textBounds = self.perfText.TextBounds
    local textWidth = textBounds.X
    local textHeight = textBounds.Y
    
    local padding = math.floor(12 * self:getScale())
    local newWidth = textWidth + padding
    local newHeight = textHeight + math.floor(10 * self:getScale())
    
    self.dragFrame.Size = UDim2.new(0, newWidth, 0, newHeight)
end

function PerformanceMonitor:hide()
    if self.dragFrame then
        self.dragFrame.Visible = false
    end
end

function PerformanceMonitor:show()
    if self.dragFrame then
        self.dragFrame.Visible = true
    end
end

function PerformanceMonitor:isVisible()
    return self.dragFrame and self.dragFrame.Visible
end

function PerformanceMonitor:getTextButton()
    return self.perfText
end

function PerformanceMonitor:unload()
    if self.screenGui then
        self.screenGui:Destroy()
        self.screenGui = nil
    end
end

return PerformanceMonitor
