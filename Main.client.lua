local Players=game:GetService("Players")local RunService=game:GetService("RunService")local p=Players.LocalPlayer
local Modules=script:FindFirstChild("Modules")or script.Parent.Modules
local Finder=require(Modules.Utils.Finder)
local Headless=require(Modules.Core.Headless)
local LegEffects=require(Modules.Core.LegEffects)
local Graphics=require(Modules.Core.Graphics)
local HatHider=require(Modules.Core.HatHider)
local Performance=require(Modules.UI.Performance)
local Menu=require(Modules.UI.Menu)
local Cleanup=require(Modules.Utils.Cleanup)
local State={Graphics=false,R6Leg=false,R15Leg=false,Hat=false}
local function init()
    _G.f=Finder.find
    Headless.init(p)
    Headless.enable(true)
    Performance.init(p,RunService)
    Performance.show()
    local menu=Menu.init(p,State,{LegEffects=LegEffects,Graphics=Graphics,HatHider=HatHider})
    Cleanup.init(RunService,State)
    p.CharacterAdded:Connect(function(c)
        task.wait(0.5)
        if State.Hat then HatHider.enable(true,p)end
        if State.Graphics then Graphics.enable(true)end
        if State.R6Leg then LegEffects.enableR6(true,p)end
        if State.R15Leg then LegEffects.enableR15(true,p)end
    end)
    Performance.setClickCallback(function()
        pcall(function()Performance.hide()end)
        pcall(function()menu.show()end)
    end)
    menu.setMinCallback(function()
        pcall(function()menu.hide()end)
        pcall(function()Performance.show()end)
    end)
    if p.Character then task.wait(0.5)end
end
task.spawn(init)
