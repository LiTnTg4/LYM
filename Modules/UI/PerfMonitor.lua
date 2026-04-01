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
        corner.Position = UDim2.new(x, x == 0 and 0 or -5, y, y == 0 and 0 or -5)
        corner.BackgroundColor3 = Color3.fromRGB(180, 100, 40)
        corner.BackgroundTransparency = 0.5
        corner.BorderSizePixel = 0
        corner.Parent = parent
    end
    
    task.defer(function()
        addCorner(frame, 0, 0)
        addCorner(frame, 1, 0)
        addCorner(frame, 0, 1)
        addCorner(frame, 1, 1)
    end)
    
    local perfText = Instance.new("TextButton")
    perfText.Name = "PerfText"
    perfText.BackgroundTransparency = 1
    perfText.Text = "FPS:060 PING:088ms"
    perfText.TextColor3 = Color3.fromRGB(255, 180, 80)
    perfText.TextSize = math.floor(16 * scale)
    perfText.Font = Enum.Font.Code
    perfText.TextXAlignment = Enum.TextXAlignment.Left
    perfText.TextYAlignment = Enum.TextYAlignment.Center
    perfText.Active = false
    perfText.Draggable = false
    perfText.Visible = true
    perfText.Parent = frame
    
    local cursor = Instance.new("TextLabel")
    cursor.Size = UDim2.new(0, 10, 1, 0)
    cursor.Position = UDim2.new(1, -12, 0, 0)
    cursor.BackgroundTransparency = 1
    cursor.Text = "_"
    cursor.TextColor3 = Color3.fromRGB(255, 180, 80)
    cursor.TextSize = math.floor(16 * scale)
    cursor.Font = Enum.Font.Code
    cursor.TextYAlignment = Enum.TextYAlignment.Center
    cursor.Parent = perfText
    
    task.spawn(function()
        while screenGui.Parent do
            task.wait(0.5)
            cursor.Text = cursor.Text == "_" and " " or "_"
        end
    end)
    
    local function updateFrameSize()
        local textBounds = perfText.TextBounds
        local textWidth = textBounds.X
        local textHeight = textBounds.Y
        
        local padding = math.floor(10 * scale)
        local newWidth = textWidth + padding
        local newHeight = textHeight + math.floor(8 * scale)
        
        dragFrame.Size = UDim2.new(0, newWidth, 0, newHeight)
        
        if savedPosition then
            dragFrame.Position = savedPosition
        else
            dragFrame.Position = UDim2.new(0.5, -newWidth / 2, 0.05, 0)
        end
        
        frame.Size = UDim2.new(1, 0, 1, 0)
        perfText.Size = UDim2.new(1, -padding, 1, 0)
        perfText.Position = UDim2.new(0, padding/2, 0, 0)
    end
    
    workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
        scale = getScale()
        border.Thickness = math.max(1, math.floor(2 * scale))
        perfText.TextSize = math.floor(16 * scale)
        cursor.TextSize = math.floor(16 * scale)
        updateFrameSize()
    end)
    
    updateFrameSize()
    
    local fc = 0
    local lastTime = os.clock()
    
    runService.RenderStepped:Connect(function()
        local now = os.clock()
        local delta = now - lastTime
        
        if delta >= 1 then
            local fps = math.floor(fc / delta)
            local ping = 0
            pcall(function()
                ping = math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue())
            end)
            perfText.Text = string.format("FPS:%03d PING:%03dms", fps, ping)
            updateFrameSize()
            fc = 0
            lastTime = now
        end
        fc = fc + 1
    end)
    
    return {
        textButton = perfText
    }
end

return PerfMonitor