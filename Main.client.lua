local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local p = Players.LocalPlayer

local function loadModule(url)
    return loadstring(game:HttpGet(url))()
end

-- 直接用raw链接加载所有模块
local Finder = loadModule("https://raw.githubusercontent.com/LiTnTg4/LYM/main/Modules/Utils/Finder.lua")
local Headless = loadModule("https://raw.githubusercontent.com/LiTnTg4/LYM/main/Modules/Core/Headless.lua")
local LegEffects = loadModule("https://raw.githubusercontent.com/LiTnTg4/LYM/main/Modules/Core/LegEffects.lua")
local Graphics = loadModule("https://raw.githubusercontent.com/LiTnTg4/LYM/main/Modules/Core/Graphics.lua")
local HatHider = loadModule("https://raw.githubusercontent.com/LiTnTg4/LYM/main/Modules/Core/HatHider.lua")
local Performance = loadModule("https://raw.githubusercontent.com/LiTnTg4/LYM/main/Modules/UI/Performance.lua")
local Menu = loadModule("https://raw.githubusercontent.com/LiTnTg4/LYM/main/Modules/UI/Menu.lua")
local Cleanup = loadModule("https://raw.githubusercontent.com/LiTnTg4/LYM/main/Modules/Utils/Cleanup.lua")

_G.f = Finder.find

local State = {Graphics = false, R6Leg = false, R15Leg = false, Hat = false}

local function init()
    Headless.init(p)
    Headless.enable(true)
    
    Performance.init(p, RunService)
    Performance.show()
    
    local menu = Menu.init(p, State, {
        LegEffects = LegEffects,
        Graphics = Graphics,
        HatHider = HatHider
    })
    
    Cleanup.init(RunService, State)
    
    p.CharacterAdded:Connect(function(c)
        task.wait(0.5)
        if State.Hat then HatHider.enable(true, p) end
        if State.Graphics then Graphics.enable(true) end
        if State.R6Leg then LegEffects.enableR6(true, p) end
        if State.R15Leg then LegEffects.enableR15(true, p) end
    end)
    
    Performance.setClickCallback(function()
        pcall(function() Performance.hide() end)
        pcall(function() menu.show() end)
    end)
    
    menu.setMinCallback(function()
        pcall(function() menu.hide() end)
        pcall(function() Performance.show() end)
    end)
end

task.spawn(init)