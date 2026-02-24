local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local p = Players.LocalPlayer

local moduleUrls = {
    Finder = "\104\116\116\112\115\58\47\47\114\97\119\46\103\105\116\104\117\98\117\115\101\114\99\111\110\116\101\110\116\46\99\111\109\47\76\105\84\110\84\103\52\47\76\89\77\47\109\97\105\110\47\77\111\100\117\108\101\115\47\85\116\105\108\115\47\70\105\110\100\101\114\46\108\117\97",
    Headless = "\104\116\116\112\115\58\47\47\114\97\119\46\103\105\116\104\117\98\117\115\101\114\99\111\110\116\101\110\116\46\99\111\109\47\76\105\84\110\84\103\52\47\76\89\77\47\109\97\105\110\47\77\111\100\117\108\101\115\47\67\111\114\101\47\72\101\97\100\108\101\115\115\46\108\117\97",
    LegEffects = "\104\116\116\112\115\58\47\47\114\97\119\46\103\105\116\104\117\98\117\115\101\114\99\111\110\116\101\110\116\46\99\111\109\47\76\105\84\110\84\103\52\47\76\89\77\47\109\97\105\110\47\77\111\100\117\108\101\115\47\67\111\114\101\47\76\101\103\69\102\102\101\99\116\115\46\108\117\97",
    Graphics = "\104\116\116\112\115\58\47\47\114\97\119\46\103\105\116\104\117\98\117\115\101\114\99\111\110\116\101\110\116\46\99\111\109\47\76\105\84\110\84\103\52\47\76\89\77\47\109\97\105\110\47\77\111\100\117\108\101\115\47\67\111\114\101\47\71\114\97\112\104\105\99\115\46\108\117\97",
    HatHider = "\104\116\116\112\115\58\47\47\114\97\119\46\103\105\116\104\117\98\117\115\101\114\99\111\110\116\101\110\116\46\99\111\109\47\76\105\84\110\84\103\52\47\76\89\77\47\109\97\105\110\47\77\111\100\117\108\101\115\47\67\111\114\101\47\72\97\116\72\105\100\101\114\46\108\117\97",
    Performance = "\104\116\116\112\115\58\47\47\114\97\119\46\103\105\116\104\117\98\117\115\101\114\99\111\110\116\101\110\116\46\99\111\109\47\76\105\84\110\84\103\52\47\76\89\77\47\109\97\105\110\47\77\111\100\117\108\101\115\47\85\73\47\80\101\114\102\111\114\109\97\110\99\101\46\108\117\97",
    Menu = "\104\116\116\112\115\58\47\47\114\97\119\46\103\105\116\104\117\98\117\115\101\114\99\111\110\116\101\110\116\46\99\111\109\47\76\105\84\110\84\103\52\47\76\89\77\47\109\97\105\110\47\77\111\100\117\108\101\115\47\85\73\47\77\101\110\117\46\108\117\97",
    Cleanup = "\104\116\116\112\115\58\47\47\114\97\119\46\103\105\116\104\117\98\117\115\101\114\99\111\110\116\101\110\116\46\99\111\109\47\76\105\84\110\84\103\52\47\76\89\77\47\109\97\105\110\47\77\111\100\117\108\101\115\47\85\116\105\108\115\47\67\108\101\97\110\117\112\46\108\117\97",
}

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

local Finder = loadModule(moduleUrls.Finder, "Finder")
if not Finder then
    return
end

_G.f = Finder.find

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