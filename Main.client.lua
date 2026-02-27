local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local p = Players.LocalPlayer

print("🔄 加载中... 0/9")

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

local moduleUrls = {
    Finder = "https://raw.githubusercontent.com/LiTnTg4/LYM/main/Modules/Utils/Finder.lua",
    Notification = "https://raw.githubusercontent.com/LiTnTg4/LYM/main/Modules/Utils/Notification.lua",
    Headless = "https://raw.githubusercontent.com/LiTnTg4/LYM/main/Modules/Core/Headless.lua",
    LegEffects = "https://raw.githubusercontent.com/LiTnTg4/LYM/main/Modules/Core/LegEffects.lua",
    Graphics = "https://raw.githubusercontent.com/LiTnTg4/LYM/main/Modules/Core/Graphics.lua",
    HatHider = "https://raw.githubusercontent.com/LiTnTg4/LYM/main/Modules/Core/HatHider.lua",
    Performance = "https://raw.githubusercontent.com/LiTnTg4/LYM/main/Modules/UI/Performance.lua",
    Menu = "https://raw.githubusercontent.com/LiTnTg4/LYM/main/Modules/UI/Menu.lua",
    Cleanup = "https://raw.githubusercontent.com/LiTnTg4/LYM/main/Modules/Utils/Cleanup.lua",
}

local loadedCount = 0
local totalModules = 9

local function updateProgress()
    loadedCount = loadedCount + 1
    print("🔄 加载中... " .. loadedCount .. "/" .. totalModules)
end

local Finder = loadModule(moduleUrls.Finder, "Finder")
if not Finder then 
    print("❌ Finder加载失败")
    return 
end
_G.f = Finder.find
updateProgress()

local Notification = loadModule(moduleUrls.Notification, "Notification")
updateProgress()

local Headless = loadModule(moduleUrls.Headless, "Headless")
updateProgress()

local LegEffects = loadModule(moduleUrls.LegEffects, "LegEffects")
updateProgress()

local Graphics = loadModule(moduleUrls.Graphics, "Graphics")
updateProgress()

local HatHider = loadModule(moduleUrls.HatHider, "HatHider")
updateProgress()

local Performance = loadModule(moduleUrls.Performance, "Performance")
updateProgress()

local Menu = loadModule(moduleUrls.Menu, "Menu")
updateProgress()

local Cleanup = loadModule(moduleUrls.Cleanup, "Cleanup")
updateProgress()

if not Headless or not LegEffects or not Performance then
    print("❌ 核心模块加载失败")
    return
end

print("✅ 加载完成")

local State = {Graphics = false, R6Leg = false, R15Leg = false, Hat = false}

local function init()
    Headless.init(p)
    Headless.enable(true)
    
    if Notification then
        task.spawn(function()
            Notification.show(
                "🚀 LYM 脚本注入成功",
                "欢迎 " .. p.Name,
                3,
                "success"
            )
            task.wait(3.8)
            
            Notification.show(
                "📢 功能提示",
                "无头效果已开启 | 点击FPS打开菜单",
                4,
                "info"
            )
            task.wait(4.8)
            
            -- 第三个通知已删除
            
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
        end)
    end
end

task.spawn(init)

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