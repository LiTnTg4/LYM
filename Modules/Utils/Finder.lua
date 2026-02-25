local allowedUsers = {
    [8101530565] = true,  -- Reming
    [8007999103] = true,  -- NX_Naturally
    [7962623059] = true,  -- NanQiu
    [7123752351] = true,  -- 我生来冷漠
    [3111340845] = true,  -- Whitecat
    [10352103017] = true,  -- joker
    [9032131939] = true,  -- Secular
    [7845410614] = true,  -- Leisai94
    [5555555555] = true,  -- 朋友5
    [6666666666] = true,  -- 朋友6
    [7777777777] = true,  -- 朋友7
    [8888888888] = true,  -- 朋友8
    [9999999999] = true,  -- 朋友9
    [1010101010] = true,  -- 朋友10
    [1212121212] = true,  -- 朋友11
    [1313131313] = true,  -- 朋友12
    [1414141414] = true,  -- 朋友13
    [1515151515] = true,  -- 朋友14
    [1616161616] = true,  -- 朋友15
    [1717171717] = true,  -- 朋友16
    [1818181818] = true,  -- 朋友17
    [1919191919] = true,  -- 朋友18
    [2020202020] = true,  -- 朋友19
    [4635001673] = true,  -- leisai小号
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
    text.Text = "加载错误？\n联系我\nQQ: 277114682"
    text.Parent = frame
    
    wait(3)
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