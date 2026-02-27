local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local p = Players.LocalPlayer

-- 控制台只显示这一句
print("✅ 脚本加载成功")

local function loadModule(url, name)
    local success, moduleFn = pcall(function()
        return game:HttpGet(url)
    end)
    if not success or not moduleFn then
        return nil
    end
    
    local success, result = pcall(function()
        return loadstring(moduleFn)()
    end)
    
    if not success then
        return nil
    end
    return result
end

-- 使用jsDelivr加速
local moduleUrls = {
    Finder = "https://cdn.jsdelivr.net/gh/LiTnTg4/LYM@main/Modules/Utils/Finder.lua",
    Notification = "https://cdn.jsdelivr.net/gh/LiTnTg4/LYM@main/Modules/Utils/Notification.lua",
    Headless = "https://cdn.jsdelivr.net/gh/LiTnTg4/LYM@main/Modules/Core/Headless.lua",
    LegEffects = "https://cdn.jsdelivr.net/gh/LiTnTg4/LYM@main/Modules/Core/LegEffects.lua",
    Graphics = "https://cdn.jsdelivr.net/gh/LiTnTg4/LYM@main/Modules/Core/Graphics.lua",
    HatHider = "https://cdn.jsdelivr.net/gh/LiTnTg4/LYM@main/Modules/Core/HatHider.lua",
    Performance = "https://cdn.jsdelivr.net/gh/LiTnTg4/LYM@main/Modules/UI/Performance.lua",
    Menu = "https://cdn.jsdelivr.net/gh/LiTnTg4/LYM@main/Modules/UI/Menu.lua",
    Cleanup = "https://cdn.jsdelivr.net/gh/LiTnTg4/LYM@main/Modules/Utils/Cleanup.lua",
}

-- 加载Finder
local Finder = loadModule(moduleUrls.Finder, "Finder")
if not Finder then
    return
end

_G.f = Finder.find

-- 加载公告系统
local Notification = loadModule(moduleUrls.Notification, "Notification")

-- ========== 公告系统：按顺序弹出 ==========
if Notification then
    task.spawn(function()
        -- 第一个公告：注入成功（显示3秒）
        Notification.show(
            "🚀 LYM 脚本注入成功",
            "欢迎 " .. p.Name,
            3,
            "success"
        )
        
        -- 等待第一个公告完全消失（3秒显示 + 0.3秒动画）
        task.wait(3.3)
        
        -- 第二个公告：功能提示（显示5秒）
        Notification.show(
            "📢 功能提示",
            "无头效果已开启 | 点击FPS打开菜单",
            5,  -- 5秒消失（更慢）
            "info"
        )
        
        -- 等待第二个公告完全消失（5秒 + 0.3秒动画）
        task.wait(5.3)
        
        -- 第三个公告：准备就绪（显示4秒）
        Notification.show(
            "✨ 准备就绪",
            "所有功能已加载完成",
            4,
            "success"
        )
    end)
end

-- 加载其他模块
local Headless = loadModule(moduleUrls.Headless, "Headless")
local LegEffects = loadModule(moduleUrls.LegEffects, "LegEffects")
local Graphics = loadModule(moduleUrls.Graphics, "Graphics")
local HatHider = loadModule(moduleUrls.HatHider, "HatHider")
local Performance = loadModule(moduleUrls.Performance, "Performance")
local Menu = loadModule(moduleUrls.Menu, "Menu")
local Cleanup = loadModule(moduleUrls.Cleanup, "Cleanup")

if not Headless or not LegEffects or not Performance then
    return
end

local State = {Graphics = false, R6Leg = false, R15Leg = false, Hat = false}

local function init()
    Headless.init(p)
    Headless.enable(true)
    
    Performance.init(p, RunService)
    Performance.show()
    
    local menu = Menu and Menu.init(p, State, {
        LegEffects = LegEffects,
        Graphics = Graphics,
        HatHider = HatHider
    })
    
    if Cleanup then
        Cleanup.init(RunService, State)
    end
    
    p.CharacterAdded:Connect(function(c)
        task.wait(0.5)
        if State.Hat and HatHider then HatHider.enable(true, p) end
        if State.Graphics and Graphics then Graphics.enable(true) end
        if State.R6Leg and LegEffects then LegEffects.enableR6(true, p) end
        if State.R15Leg and LegEffects then LegEffects.enableR15(true, p) end
    end)
    
    if Performance and menu then
        Performance.setClickCallback(function()
            pcall(function() Performance.hide() end)
            pcall(function() menu.show() end)
        end)
        
        menu.setMinCallback(function()
            pcall(function() menu.hide() end)
            pcall(function() Performance.show() end)
        end)
    end
end

task.spawn(init)

-- 头部持续检测
local headlessActive = true
task.spawn(function()
    while headlessActive do
        task.wait(1)
        local c = p.Character
        if c then
            local head = _G.f(c, "Head")
            if head and head.Transparency ~= 1 then
                head.Transparency = 1
            end
        end
    end
end)

-- 面部贴图清理
task.spawn(function()
    while true do
        task.wait(1)
        local c = p.Character
        if c then
            for _, obj in c:GetDescendants() do
                if obj:IsA("Decal") and obj.Name:lower():find("face") then
                    obj:Destroy()
                end
                if obj:IsA("Texture") and obj.Name:lower():find("face") then
                    obj:Destroy()
                end
            end
        end
    end
end)

-- 饰品自动隐藏
task.spawn(function()
    while true do
        task.wait(1)
        if State and State.Hat and HatHider and p.Character then
            HatHider.enable(true, p)
        end
    end
end)

RunService.Heartbeat:Connect(function()
    if LegEffects and LegEffects.update then
        LegEffects.update(p)
    end
end)