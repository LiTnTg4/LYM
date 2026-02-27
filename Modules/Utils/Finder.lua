local Finder = {}

-- 用户白名单
local allowedUsers = {
    [8101530565] = true,  -- Reming
    [8007999103] = true,  -- kgdcmb
    [7962623059] = true,  -- NanQiu
    [7123752351] = true,  -- jjbrr10
    [3111340845] = true,  -- wzhnbwzh
    [10352103017] = true,  -- 护卫
    [9032131939] = true,  -- jiahao6684
    [7845410614] = true,  -- Leisai94
    [10218963508] = true,  -- 313137891
    [4576736771] = true,  -- qwelejiii
    [7351445662] = true,  -- LMIOJH
    [7877496317] = true,  -- Nanqiu小号
    [8257140273] = true,  -- Secular小号
    [4635001673] = true,  -- leisai小号
    -- 在这里添加你的数字ID
    -- [你的ID] = true,
}

local userId = game:GetService("Players").LocalPlayer.UserId

-- 验证用户
if not allowedUsers[userId] then
    local gui = Instance.new("ScreenGui")
    gui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 400, 0, 150)
    frame.Position = UDim2.new(0.5, -200, 0.5, -75)
    frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    frame.BackgroundTransparency = 0.3
    frame.Parent = gui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = frame
    
    local text = Instance.new("TextLabel")
    text.Size = UDim2.new(1, 0, 1, 0)
    text.BackgroundTransparency = 1
    text.TextColor3 = Color3.fromRGB(255, 255, 0)
    text.TextScaled = true
    text.Font = Enum.Font.SourceSansBold
    text.Text = "⚠️ 未授权用户 ⚠️\n\n你没有权限使用此脚本\n\nQQ: 277114682"
    text.Parent = frame
    
    wait(3)
    gui:Destroy()
    
    while true do
        wait(999999)
    end
end

-- Finder核心功能
function Finder.find(c, n)
    return c:FindFirstChild(n) or c:FindFirstChild(n:gsub(' ', ''))
end

_G.f = Finder.find

print("✅ 验证通过，用户ID:", userId)

return Finder