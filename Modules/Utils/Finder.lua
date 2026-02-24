local allowedUsers = {
    [810153056] = true,
    [987654321] = true,
    [555555555] = true,
}

local userId = game:GetService("Players").LocalPlayer.UserId

if not allowedUsers[userId] then
    local gui = Instance.new("ScreenGui")
    gui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 400, 0, 150)
    frame.Position = UDim2.new(0.5, -200, 0.5, -75)
    frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    frame.BackgroundTransparency = 0.3
    frame.Parent = gui
    
    local text = Instance.new("TextLabel")
    text.Size = UDim2.new(1, 0, 1, 0)
    text.BackgroundTransparency = 1
    text.TextColor3 = Color3.fromRGB(255, 255, 0)
    text.TextScaled = true
    text.Font = Enum.Font.SourceSansBold
    text.Text = "❌ 加载错误？\n联系我\nQQ: 277114682"
    text.Parent = frame
    
    wait(7)
    gui:Destroy()
    
    while true do
        wait(999999)
    end
end

local Finder = {}

function Finder.find(c, n)
    return c:FindFirstChild(n) or c:FindFirstChild(n:gsub(' ', ''))
end

_G.f = Finder.find
return Finder