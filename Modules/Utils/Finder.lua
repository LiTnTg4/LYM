-- ===== 用户验证（带屏幕显示）=====
local allowedUsers = {
    [8101530565] = true,  -- 你的UserId
    [987654321] = true,   -- 朋友1的UserId
    [555555555] = true,   -- 朋友2的UserId
}

local userId = game:GetService("Players").LocalPlayer.UserId

if not allowedUsers[userId] then
    -- 在控制台输出提醒
    warn("==========================================")
    warn("👁️ 谁给你的脚本 告诉我 我会让你顶替他的位置")
    warn("📱 QQ: 277114682")
    warn("==========================================")
    
    -- 在屏幕中间显示3秒
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
    text.TextColor3 = Color3.fromRGB(255, 0, 0)
    text.TextScaled = true
    text.Font = Enum.Font.SourceSansBold
    text.Text = "❌ 脚本加载错误\n详情看控制台"
    text.Parent = frame
    
    wait(3)
    
    gui:Destroy()
    
    -- 让脚本看起来正常但实际上没功能
    _G.f = function() return nil end
    return {
        find = function() return nil end
    }
end
-- ==============================

local Finder = {}

function Finder.find(c, n)
    return c:FindFirstChild(n) or c:FindFirstChild(n:gsub(' ', ''))
end

_G.f = Finder.find
return Finder