local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local p = Players.LocalPlayer

print("🔥 LYM 脚本启动")

-- 模块加载函数
local function loadModule(url, name)
    print("📥 加载模块:", name)
    local success, moduleFn = pcall(function()
        return game:HttpGet(url)
    end)
    if not success or not moduleFn then
        warn("❌ 下载失败:", name)
        return nil
    end
    
    local success, result = pcall(function()
        return loadstring(moduleFn)()
    end)
    
    if not success then
        warn("❌ 编译失败:", name)
        return nil
    end
    print("✅ 加载成功:", name)
    return result
end

-- 使用jsDelivr加速
local GITHUB_BASE = "https://cdn.jsdelivr.net/gh/LiTnTg4/LYM@main/Modules/"

local moduleUrls = {
    Finder = GITHUB_BASE .. "Utils/Finder.lua",
    Notification = GITHUB_BASE .. "Utils/Notification.lua",  -- 新增
    Headless = GITHUB_BASE .. "Core/Headless.lua",
    LegEffects = GITHUB_BASE .. "Core/LegEffects.lua",
    Graphics = GITHUB_BASE .. "Core/Graphics.lua",
    HatHider = GITHUB_BASE .. "Core/HatHider.lua",
    Performance = GITHUB_BASE .. "UI/Performance.lua",
    Menu = GITHUB_BASE .. "UI/Menu.lua",
    Cleanup = GITHUB_BASE .. "Utils/Cleanup.lua",
}

-- 加载Finder（包含验证）
local Finder = loadModule(moduleUrls.Finder, "Finder")
if not Finder then 
    print("❌ Finder加载失败")
    return
end

-- 加载公告系统
local Notification = loadModule(moduleUrls.Notification, "Notification")

-- 显示欢迎公告
if Notification then
    Notification.show(
        "🚀 LYM 脚本注入成功",
        "欢迎 " .. p.Name .. " | 版本 2.0",
        4,
        "success"
    )
    
    -- 延迟显示第二个公告
    task.spawn(function()
        task.wait(1)
        Notification.info(
            "📢 公告",
            "无头效果已自动开启 | 点击FPS打开菜单",
            3
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
    print("❌ 核心模块加载失败")
    if Notification then
        Notification.error("加载失败", "核心模块加载失败", 3)
    end
    return
end

print("✅ 所有模块加载完成")

-- 显示模块加载完成公告
if Notification then
    Notification.success(
        "✅ 模块加载完成",
        "8个模块已就绪 | 功能菜单已准备",
        2
    )
end

-- 状态管理
local State = {Graphics = false, R6Leg = false, R15Leg = false, Hat = false}

-- 初始化函数
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
task.spawn(function()
    while true do
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
        task.wait(0.5)
        local c = p.Character
        if c and State and State.Hat and HatHider then
            HatHider.enable(true, p)
        end
    end
end)

-- 腿部效果更新
RunService.Heartbeat:Connect(function()
    if LegEffects and LegEffects.update then
        LegEffects.update(p)
    end
end)

-- 显示启动完成公告
if Notification then
    task.spawn(function()
        task.wait(2)
        Notification.show(
            "✨ 所有功能就绪",
            "点击FPS打开菜单 | 享受游戏",
            3,
            "success"
        )
    end)
end

print("\n")
print("======================================")
print("✅ 脚本加载完毕！")
print("======================================")
print("\n")