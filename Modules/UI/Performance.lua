local PerfMonitor = {}

function PerfMonitor.init(player, runService)
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "WastelandPerfMonitor"
    screenGui.IgnoreGuiInset = true
    screenGui.ResetOnSpawn = false
    screenGui.Parent = player:WaitForChild("PlayerGui")
    
    local function getScale()
        local viewportSize = workspace.CurrentCamera.ViewportSize
        local referenceHeight = 1080
        return math.max(0.8, math.min(1.5, viewportSize.Y / referenceHeight))
    end
    
    local scale = getScale()
    local savedPosition = nil
    
    local dragFrame = Instance.new("Frame")
    dragFrame.Size = UDim2.new(0, 0, 0, 21 * scale)
    dragFrame.Position = UDim2.new(0.5, 0, 0.05, 0)
    dragFrame.BackgroundTransparency = 1
    dragFrame.Active = true
    dragFrame.Draggable = true
    dragFrame.Parent = screenGui
    
    dragFrame:GetPropertyChangedSignal("Position"):Connect(function()
        savedPosition = dragFrame.Position
    end)
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.Position = UDim2.new(0, 0, 0, 0)
    frame.BackgroundColor3 = Color3.fromRGB(20, 15, 10)
    frame.BackgroundTransparency = 0.1
    frame.BorderSizePixel = 0
    frame.Parent = dragFrame
    
    local border = Instance.new("UIStroke")
    border.Thickness = 2
    border.Color = Color3.fromRGB(180, 100, 40)
    border.Transparency = 0.3
    border.Parent = frame
    
    local function addCorner(parent, x, y)
        local corner = Instance.new("Frame")
        corner.Size = UDim2.new(0, 5, 0, 5)
        corner.Position = UDim2.new(x, x == 0 and 0 or -5, y, y == 0 and 0