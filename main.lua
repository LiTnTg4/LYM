-- 废土终端 - 主入口文件
-- 适用于 Roblox 开发者控制台(F9)运行

local BASE_URL = "https://raw.githubusercontent.com/LiTnTg4/LYM/main"

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- 加载模块
local Helpers = loadstring(game:HttpGet(BASE_URL .. "/src/utils/helpers.lua"))()
local Constants = loadstring(game:HttpGet(BASE_URL .. "/src/core/constants.lua"))()
local State = loadstring(game:HttpGet(BASE_URL .. "/src/core/state.lua"))()
local LegBreak = loadstring(game:HttpGet(BASE_URL .. "/src/modules/leg_break.lua"))()
local GraphicsOptimizer = loadstring(game:HttpGet(BASE_URL .. "/src/modules/graphics.lua"))()
local HatHider = loadstring(game:HttpGet(BASE_URL .. "/src/modules/hat_hider.lua"))()
local HeadlessManager = loadstring(game:HttpGet(BASE_URL .. "/src/modules/headless.lua"))()
local PerformanceMonitor = loadstring(game:HttpGet(BASE_URL .. "/src/modules/performance_monitor.lua"))()
local MainMenu = loadstring(game:HttpGet(BASE_URL .. "/src/ui/main_menu.lua"))()

-- 初始化所有模块
local function init()
    local state = State.new()
    
    -- 创建模块实例，注入依赖
    local modules = {
        legBreak = LegBreak.new(state, Helpers),
        graphics = GraphicsOptimizer.new(state),
        hatHider = HatHider.new(state, Constants, Helpers),
        headless = HeadlessManager.new(state),
        perfMonitor = PerformanceMonitor.new(state),
        mainMenu = MainMenu.new(state)
    }
    
    -- 设置主菜单回调
    modules.mainMenu:setCallbacks({
        onR6Toggle = function()
            local newState = not state.functionState.r6Leg
            modules.legBreak:enableR6Leg(newState)
        end,
        onR15Toggle = function()
            local newState = not state.functionState.r15Leg
            modules.legBreak:enableR15Leg(newState)
        end,
        onGraphicsToggle = function()
            local newState = not state.functionState.graphics
            modules.graphics:enable(newState)
        end,
        onHatToggle = function()
            local newState = not state.functionState.hat
            modules.hatHider:enable(newState)
        end,
        onUnload = function()
            state:unload()
        end,
        onMinimize = function()
            modules.mainMenu:hide(function()
                modules.perfMonitor:show()
            end)
        end,
        onHatUpdate = function()
            modules.hatHider:update()
        end
    })
    
    -- 初始化 UI
    modules.mainMenu:init()
    
    -- 启动功能模块
    modules.headless:init()
    modules.hatHider:init()
    modules.perfMonitor:init()
    
    -- 角色加载检测
    player.CharacterAdded:Connect(function(character)
        task.wait(0.5)
        if state.isUnloaded then return end
        
        modules.headless:onCharacterAdded(character)
        modules.legBreak:onCharacterAdded(character)
        modules.graphics:onCharacterAdded(character)
        modules.hatHider:onCharacterAdded(character)
    end)
    
    -- 实时更新循环
    RunService.Heartbeat:Connect(function()
        modules.legBreak:update()
    end)
    
    -- 实时隐藏循环
    task.spawn(function()
        while not state.isUnloaded do
            if state.functionState.hat then
                local c = player.Character
                if c then
                    modules.hatHider:hideAccessories(c)
                end
            end
            task.wait(0.1)
        end
    end)
    
    -- 监听卸载事件
    state.onUnload:Connect(function()
        for name, module in pairs(modules) do
            if module.unload then
                module:unload()
            end
        end
        
        -- 清理 UI
        Helpers.safeCall(function()
            local perfParent = player.PlayerGui:FindFirstChild("PerfMonitor")
            if perfParent then perfParent:Destroy() end
            local dropdown = player.PlayerGui:FindFirstChild("DetailMenu")
            if dropdown then dropdown:Destroy() end
        end)
    end)
    
    -- 性能监控点击切换菜单
    modules.perfMonitor:show()
    
    local perfButton = modules.perfMonitor:getTextButton()
    if perfButton then
        perfButton.MouseButton1Click:Connect(function()
            if modules.mainMenu:isMenuVisible() then
                modules.mainMenu:hide(function()
                    modules.perfMonitor:show()
                end)
            else
                modules.perfMonitor:hide()
                modules.mainMenu:show()
            end
        end)
    end
    
    print("✅ 废土终端已启动 - 所有功能默认关闭")
end

init()
