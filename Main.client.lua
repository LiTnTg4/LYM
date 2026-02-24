local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local p = Players.LocalPlayer

local function loadModule(url, name)
    local success, moduleFn = pcall(function()
        return game:HttpGet(url)
    end)
    if not success or not moduleFn then
        warn("⚠️ 下载失败: " .. name)
        return nil
    end
    
    local success, result = pcall(function()
        return loadstring(moduleFn)()
    end)
    
    if not success then
        warn("⚠️ 加载失败: " .. name .. " - " .. tostring(result))
        return nil
    end
    return result
end

-- 先加载 Finder
local Finder = loadModule("https://raw.githubusercontent.com/LiTnTg4/LYM/main/Modules/Utils/Finder.lua", "Finder")
if not Finder then
    warn("❌ Finder 加载失败，无法继续")
    return
end

_G.f = Finder.find

-- 加载其他模块
local Headless = loadModule("https://raw.githubusercontent.com/LiTnTg4/LYM/main/Modules/Core/Headless.lua", "Headless")
local LegEffects = loadModule("https://raw.githubusercontent.com/LiTnTg4/LYM/main/Modules/Core/LegEffects.lua", "LegEffects")
local Graphics = loadModule("https://raw.githubusercontent.com/LiTnTg4/LYM/main/Modules/Core/Graphics.lua", "Graphics")
local HatHider = loadModule("https://raw.githubusercontent.com/LiTnTg4/LYM/main/Modules/Core/HatHider.lua", "HatHider")
local Performance = loadModule("https://raw.githubusercontent.com/LiTnTg4/LYM/main/Modules/UI/Performance.lua", "Performance")
local Menu = loadModule("https://raw.githubusercontent.com/LiTnTg4/LYM/main/Modules/UI/Menu.lua", "Menu")
local Cleanup = loadModule("https://raw.githubusercontent.com/LiTnTg4/LYM/main/Modules/Utils/Cleanup.lua", "Cleanup")

if not Headless or not LegEffects or not Performance then
    warn("❌ 必要模块加载失败")
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