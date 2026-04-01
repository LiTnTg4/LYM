local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer

print("🔄 加载中... 0/7")

local function loadModule(url)
    local success, result = pcall(function()
        return game:HttpGet(url)
    end)
    if not success then return nil end
    local loadSuccess, module = pcall(function()
        return loadstring(result)()
    end)
    if not loadSuccess then return nil end
    return module
end

-- 模块链接
local moduleUrls = {
    Headless = "https://cdn.jsdelivr.net/gh/LiTnTg4/LYM@main/Modules/Core/Headless.lua",
    LegEffects = "https://cdn.jsdelivr.net/gh/LiTnTg4/LYM@main/Modules/Core/LegEffects.lua",
    Graphics = "https://cdn.jsdelivr.net/gh/LiTnTg4/LYM@main/Modules/Core/Graphics.lua",
    HatHider = "https://cdn.jsdelivr.net/gh/LiTnTg4/LYM@main/Modules/Core/HatHider.lua",
    PerfMonitor = "https://cdn.jsdelivr.net/gh/LiTnTg4/LYM@main/Modules/UI/PerfMonitor.lua",
    Menu = "https://cdn.jsdelivr.net/gh/LiTnTg4/LYM@main/Modules/UI/Menu.lua",
    Announcement = "https://cdn.jsdelivr.net/gh/LiTnTg4/LYM@main/Modules/Utils/Announcement.lua",
}

local loadedCount = 0
local totalModules = 7

local function updateProgress()
    loadedCount = loadedCount + 1
    print("🔄 加载中... " .. loadedCount .. "/" .. totalModules)
end

-- 加载模块
local Headless = loadModule(moduleUrls.Headless)
if Headless then updateProgress() else warn("Headless加载失败") end

local LegEffects = loadModule(moduleUrls.LegEffects)
if LegEffects then updateProgress() else warn("LegEffects加载失败") end

local Graphics = loadModule(moduleUrls.Graphics)
if Graphics then updateProgress() else warn("Graphics加载失败") end

local HatHider = loadModule(moduleUrls.HatHider)
if HatHider then updateProgress() else warn("HatHider加载失败") end

local PerfMonitor = loadModule(moduleUrls.PerfMonitor)
if PerfMonitor then updateProgress() else warn("PerfMonitor加载失败") end

local Menu = loadModule(moduleUrls.Menu)
if Menu then updateProgress() else warn("Menu加载失败") end

local Announcement = loadModule(moduleUrls.Announcement)
if Announcement then updateProgress() else warn("Announcement加载失败") end

-- 检查核心模块
if not Headless or not LegEffects or not Graphics then
    print("❌ 核心模块加载失败")
    return
end

print("✅ 加载完成")

-- 状态管理
local State = {
    Graphics = false,
    R6Leg = false,
    R15Leg = false,
    Hat = false
}

-- 初始化模块
if Headless then
    Headless.init(player)
    Headless.startLoop()
    Headless.enable(true)
end

if LegEffects then LegEffects.init(player) end
if Graphics then Graphics.init(player) end
if HatHider then HatHider.init(player) end

-- 初始化性能监控
local perf = PerfMonitor and PerfMonitor.init(player, RunService)

-- 初始化菜单（传入 Headless 以便卸载时停止）
local menuModules = {
    LegEffects = LegEffects,
    Graphics = Graphics,
    HatHider = HatHider,
    Headless = Headless
}

local menu = Menu and Menu.init(player, State, menuModules, TweenService)

if menu then
    menu.setMinButtonCallback(function()
        menu.hide()
    end)
end

-- 点击性能监控打开/关闭菜单
if perf and perf.textButton and menu then
    perf.textButton.MouseButton1Click:Connect(function()
        if menu.isVisible() then
            menu.hide()
        else
            menu.show()
        end
    end)
end

-- 显示公告
if Announcement then
    task.spawn(function()
        Announcement.show(player)
    end)
end

-- 移除脸部贴图线程
task.spawn(function()
    while true do
        task.wait(1)
        local c = player.Character
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

-- 更新断腿效果
if LegEffects then
    RunService.Heartbeat:Connect(function()
        LegEffects.update()
    end)
end

-- 角色重生恢复
player.CharacterAdded:Connect(function(c)
    task.wait(0.5)
    if State.Hat and HatHider then HatHider.enable(true) end
    if State.Graphics and Graphics then Graphics.enable(true) end
    if State.R6Leg and LegEffects then LegEffects.enableR6(true) end
    if State.R15Leg and LegEffects then LegEffects.enableR15(true) end
end)

print("✅ 废土终端已启动")