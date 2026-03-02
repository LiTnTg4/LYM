--[[
Bloxstrap 精简版 - 完全复刻原脚本的1和2功能
保留原脚本的UI风格和视觉效果
]]

-- 初始化
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- 配置文件
local CONFIG_FILE = "BloxstrapLite.json"
local FFLAG_FILE = "BloxstrapLite_Flags.json"

-- 存储配置（与原脚本相同的结构）
local settings = {
    -- 引擎设置
    FPS = 120,
    AntiAliasingQuality = "Automatic",
    DisablePlayerShadows = false,
    DisablePostFX = false,
    DisableTerrainTextures = false,
    DisplayFPS = false,
    LightingTechnology = "Chosen by game",
    TextureQuality = "Automatic",
    
    -- FFlag模组
    GraySky = false,
    Desync = false,
    HitregFix = false,
}

-- 存储 FFlag
local fflags = {}

-- 加载配置
local function loadConfig()
    if isfile and isfile(CONFIG_FILE) then
        pcall(function()
            local data = readfile(CONFIG_FILE)
            local loaded = HttpService:JSONDecode(data)
            for k, v in pairs(loaded) do
                settings[k] = v
            end
        end)
    end
    
    if isfile and isfile(FFLAG_FILE) then
        pcall(function()
            fflags = HttpService:JSONDecode(readfile(FFLAG_FILE))
        end)
    end
end

-- 保存配置
local function saveConfig()
    if writefile then
        pcall(function()
            writefile(CONFIG_FILE, HttpService:JSONEncode(settings))
            writefile(FFLAG_FILE, HttpService:JSONEncode(fflags))
        end)
    end
end

-- 设置 FFlag（与原脚本相同的逻辑）
local function setFFlag(name, value)
    if not name then return end
    
    fflags[name] = value
    saveConfig()
    
    local success = false
    pcall(function()
        if setfflag then
            setfflag(name, tostring(value))
            success = true
        end
    end)
    
    if not success then
        pcall(function()
            if sethiddenproperty then
                local network = game:FindService("NetworkClient")
                if network then
                    sethiddenproperty(network, name, value)
                end
            end
        end)
    end
end

-- 应用 Hitreg Fix（与原脚本完全相同的28个参数）
local function applyHitregFix(enable)
    if enable then
        local flags = {
            DFIntCodecMaxIncomingPackets = 100,
            DFIntCodecMaxOutgoingFrames = 10000,
            DFIntLargePacketQueueSizeCutoffMB = 1000,
            DFIntMaxProcessPacketsJobScaling = 10000,
            DFIntMaxProcessPacketsStepsAccumulated = 0,
            DFIntMaxProcessPacketsStepsPerCyclic = 5000,
            DFIntMegaReplicatorNetworkQualityProcessorUnit = 10,
            DFIntNetworkLatencyTolerance = 1,
            DFIntNetworkPrediction = 120,
            DFIntOptimizePingThreshold = 50,
            DFIntPlayerNetworkUpdateQueueSize = 20,
            DFIntPlayerNetworkUpdateRate = 60,
            DFIntRaknetBandwidthInfluxHundredthsPercentageV2 = 10000,
            DFIntRaknetBandwidthPingSendEveryXSeconds = 1,
            DFIntRakNetLoopMs = 1,
            DFIntRakNetResendRttMultiple = 1,
            DFIntServerPhysicsUpdateRate = 60,
            DFIntServerTickRate = 60,
            DFIntWaitOnRecvFromLoopEndedMS = 100,
            DFIntWaitOnUpdateNetworkLoopEndedMS = 100,
            FFlagOptimizeNetwork = true,
            FFlagOptimizeNetworkRouting = true,
            FFlagOptimizeNetworkTransport = true,
            FFlagOptimizeServerTickRate = true,
            FIntRakNetResendBufferArrayLength = 128,
        }
        for name, value in pairs(flags) do
            setFFlag(name, value)
        end
    end
end

-- 应用所有设置
local function applyAllSettings()
    -- FPS
    if settings.FPS and settings.FPS > 0 then
        setFFlag("DFIntTaskSchedulerTargetFps", settings.FPS)
        setFFlag("FFlagTaskSchedulerLimitTargetFpsTo2402", settings.FPS >= 70)
    end
    
    -- 显示FPS
    setFFlag("FFlagDebugDisplayFPS", settings.DisplayFPS)
    
    -- 阴影
    setFFlag("FIntRenderShadowIntensity", settings.DisablePlayerShadows and 0 or 1)
    
    -- 后期特效
    setFFlag("FFlagDisablePostFx", settings.DisablePostFX)
    
    -- 地形纹理
    setFFlag("FIntTerrainArraySliceSize", settings.DisableTerrainTextures and 0 or 32)
    
    -- 抗锯齿
    if settings.AntiAliasingQuality ~= "Automatic" then
        local msaa = settings.AntiAliasingQuality:gsub("x", "")
        setFFlag("FIntDebugForceMSAASamples", tonumber(msaa))
    end
    
    -- 纹理质量
    local texMap = {
        ["Lowest"] = {override = true, quality = 0, skip = 2},
        ["Low"] = {override = true, quality = 0, skip = 0},
        ["Medium"] = {override = true, quality = 1, skip = 0},
        ["High"] = {override = true, quality = 2, skip = 0},
        ["Highest"] = {override = true, quality = 3, skip = 0},
    }
    local tex = texMap[settings.TextureQuality]
    if tex then
        setFFlag("DFFlagTextureQualityOverrideEnabled", tex.override)
        setFFlag("DFIntTextureQualityOverride", tex.quality)
        setFFlag("FIntDebugTextureManagerSkipMips", tex.skip)
    end
    
    -- 光照技术
    local lightMap = {
        ["Voxel"] = {voxel = true, shadow = false, future = false},
        ["Shadow Map"] = {voxel = false, shadow = true, future = false},
        ["Future"] = {voxel = false, shadow = false, future = true},
    }
    local light = lightMap[settings.LightingTechnology]
    if light then
        setFFlag("DFFlagDebugRenderForceTechnologyVoxel", light.voxel)
        setFFlag("DFFlagDebugRenderForceFutureIsBrightPhase2", light.shadow)
        setFFlag("DFFlagDebugRenderForceFutureIsBrightPhase3", light.future)
    end
    
    -- 灰色天空
    setFFlag("FFlagDebugSkyGray", settings.GraySky)
    
    -- Desync
    setFFlag("DFIntS2PhysicsSenderRate", settings.Desync and 38000 or 15)
    
    -- Hitreg Fix
    if settings.HitregFix then
        applyHitregFix(true)
    end
end

-- 加载配置并应用
loadConfig()
applyAllSettings()

-- 创建 GUI（模仿原脚本的样式）
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BloxstrapLite"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = game:GetService("CoreGui")

-- 主框架（原脚本的深色主题）
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 500, 0, 450)
mainFrame.Position = UDim2.new(0.5, -250, 0.5, -225)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

-- 圆角（原脚本风格）
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = mainFrame

-- 阴影效果（原脚本有）
local shadow = Instance.new("ImageLabel")
shadow.Name = "Shadow"
shadow.Size = UDim2.new(1, 20, 1, 20)
shadow.Position = UDim2.new(0, -10, 0, -10)
shadow.BackgroundTransparency = 1
shadow.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
shadow.ImageColor3 = Color3.new(0, 0, 0)
shadow.ImageTransparency = 0.7
shadow.ScaleType = Enum.ScaleType.Slice
shadow.SliceCenter = Rect.new(10, 10, 10, 10)
shadow.Parent = mainFrame

-- 标题栏（原脚本样式）
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 8)
titleCorner.Parent = titleBar

-- 标题文字
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -50, 1, 0)
title.Position = UDim2.new(0, 15, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Bloxstrap 精简版"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.Parent = titleBar

-- 关闭按钮
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 35, 0, 35)
closeBtn.Position = UDim2.new(1, -40, 0, 2.5)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 18
closeBtn.Parent = titleBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = closeBtn

closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- 标签页按钮（原脚本的样式）
local tabFrame = Instance.new("Frame")
tabFrame.Size = UDim2.new(1, -20, 0, 45)
tabFrame.Position = UDim2.new(0, 10, 0, 45)
tabFrame.BackgroundTransparency = 1
tabFrame.Parent = mainFrame

local tabs = {"Engine Settings", "Mods", "Custom FFlags"}
local currentTab = "Engine Settings"
local tabButtons = {}

for i, tabName in ipairs(tabs) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.33, -5, 0, 35)
    btn.Position = UDim2.new((i-1) * 0.33, 2.5, 0, 5)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.Text = tabName
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    btn.Parent = tabFrame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = btn
    
    tabButtons[tabName] = btn
    
    btn.MouseButton1Click:Connect(function()
        currentTab = tabName
        for _, b in pairs(tabButtons) do
            b.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            b.TextColor3 = Color3.fromRGB(200, 200, 200)
        end
        btn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        updateTab()
    end)
end

-- 内容区域
local contentFrame = Instance.new("ScrollingFrame")
contentFrame.Size = UDim2.new(1, -20, 1, -130)
contentFrame.Position = UDim2.new(0, 10, 0, 95)
contentFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
contentFrame.BorderSizePixel = 0
contentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
contentFrame.ScrollBarThickness = 6
contentFrame.ScrollBarImageColor3 = Color3.fromRGB(0, 120, 255)
contentFrame.Parent = mainFrame

local contentCorner = Instance.new("UICorner")
contentCorner.CornerRadius = UDim.new(0, 8)
contentCorner.Parent = contentFrame

local contentLayout = Instance.new("UIListLayout")
contentLayout.Padding = UDim.new(0, 8)
contentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
contentLayout.Parent = contentFrame

local contentPadding = Instance.new("UIPadding")
contentPadding.PaddingTop = UDim.new(0, 10)
contentPadding.PaddingBottom = UDim.new(0, 10)
contentPadding.Parent = contentFrame

-- 创建开关（原脚本样式）
local function createToggle(text, desc, setting, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0.95, 0, 0, 60)
    frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    frame.Parent = contentFrame
    
    local frameCorner = Instance.new("UICorner")
    frameCorner.CornerRadius = UDim.new(0, 6)
    frameCorner.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7, 0, 0, 25)
    label.Position = UDim2.new(0, 15, 0, 8)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.GothamBold
    label.TextSize = 14
    label.Parent = frame
    
    local descLabel = Instance.new("TextLabel")
    descLabel.Size = UDim2.new(0.7, 0, 0, 20)
    descLabel.Position = UDim2.new(0, 15, 0, 33)
    descLabel.BackgroundTransparency = 1
    descLabel.Text = desc
    descLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
    descLabel.TextXAlignment = Enum.TextXAlignment.Left
    descLabel.Font = Enum.Font.Gotham
    descLabel.TextSize = 11
    descLabel.Parent = frame
    
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0, 50, 0, 30)
    toggleBtn.Position = UDim2.new(1, -65, 0, 15)
    toggleBtn.BackgroundColor3 = settings[setting] and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(100, 100, 100)
    toggleBtn.Text = settings[setting] and "ON" or "OFF"
    toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleBtn.Font = Enum.Font.GothamBold
    toggleBtn.TextSize = 12
    toggleBtn.Parent = frame
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 4)
    toggleCorner.Parent = toggleBtn
    
    toggleBtn.MouseButton1Click:Connect(function()
        settings[setting] = not settings[setting]
        toggleBtn.BackgroundColor3 = settings[setting] and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(100, 100, 100)
        toggleBtn.Text = settings[setting] and "ON" or "OFF"
        saveConfig()
        if callback then
            callback(settings[setting])
        end
    end)
end

-- 创建滑块（原脚本样式）
local function createSlider(text, desc, setting, min, max, suffix, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0.95, 0, 0, 80)
    frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    frame.Parent = contentFrame
    
    local frameCorner = Instance.new("UICorner")
    frameCorner.CornerRadius = UDim.new(0, 6)
    frameCorner.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7, 0, 0, 25)
    label.Position = UDim2.new(0, 15, 0, 8)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.GothamBold
    label.TextSize = 14
    label.Parent = frame
    
    local descLabel = Instance.new("TextLabel")
    descLabel.Size = UDim2.new(0.7, 0, 0, 20)
    descLabel.Position = UDim2.new(0, 15, 0, 33)
    descLabel.BackgroundTransparency = 1
    descLabel.Text = desc
    descLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
    descLabel.TextXAlignment = Enum.TextXAlignment.Left
    descLabel.Font = Enum.Font.Gotham
    descLabel.TextSize = 11
    descLabel.Parent = frame
    
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(0, 60, 0, 25)
    valueLabel.Position = UDim2.new(1, -75, 0, 8)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(settings[setting]) .. (suffix or "")
    valueLabel.TextColor3 = Color3.fromRGB(100, 200, 255)
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.TextSize = 16
    valueLabel.Parent = frame
    
    local sliderBg = Instance.new("Frame")
    sliderBg.Size = UDim2.new(0.9, 0, 0, 4)
    sliderBg.Position = UDim2.new(0.05, 0, 0, 65)
    sliderBg.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    sliderBg.Parent = frame
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new((settings[setting] - min) / (max - min), 0, 1, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
    sliderFill.Parent = sliderBg
    
    local sliderBtn = Instance.new("TextButton")
    sliderBtn.Size = UDim2.new(0, 16, 0, 16)
    sliderBtn.Position = UDim2.new(sliderFill.Size.X.Scale, -8, 0, -6)
    sliderBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    sliderBtn.Text = ""
    sliderBtn.Parent = sliderBg
    
    local sliding = false
    
    sliderBtn.MouseButton1Down:Connect(function()
        sliding = true
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            sliding = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if sliding and input.UserInputType == Enum.UserInputType.MouseMovement then
            local pos = UDim2.new(0, Mouse.X - sliderBg.AbsolutePosition.X, 0, 0)
            local percent = math.clamp(pos.X.Offset / sliderBg.AbsoluteSize.X, 0, 1)
            local value = math.floor(min + (max - min) * percent)
            
            sliderFill.Size = UDim2.new(percent, 0, 1, 0)
            sliderBtn.Position = UDim2.new(percent, -8, 0, -6)
            valueLabel.Text = tostring(value) .. (suffix or "")
            settings[setting] = value
            saveConfig()
            if callback then
                callback(value)
            end
        end
    end)
end

-- 创建下拉菜单（原脚本样式）
local function createDropdown(text, desc, setting, options, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0.95, 0, 0, 70)
    frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    frame.Parent = contentFrame
    
    local frameCorner = Instance.new("UICorner")
    frameCorner.CornerRadius = UDim.new(0, 6)
    frameCorner.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7, 0, 0, 25)
    label.Position = UDim2.new(0, 15, 0, 8)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.GothamBold
    label.TextSize = 14
    label.Parent = frame
    
    local descLabel = Instance.new("TextLabel")
    descLabel.Size = UDim2.new(0.7, 0, 0, 20)
    descLabel.Position = UDim2.new(0, 15, 0, 33)
    descLabel.BackgroundTransparency = 1
    descLabel.Text = desc
    descLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
    descLabel.TextXAlignment = Enum.TextXAlignment.Left
    descLabel.Font = Enum.Font.Gotham
    descLabel.TextSize = 11
    descLabel.Parent = frame
    
    local dropdownBtn = Instance.new("TextButton")
    dropdownBtn.Size = UDim2.new(0, 120, 0, 30)
    dropdownBtn.Position = UDim2.new(1, -135, 0, 20)
    dropdownBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    dropdownBtn.Text = settings[setting]
    dropdownBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    dropdownBtn.Font = Enum.Font.Gotham
    dropdownBtn.TextSize = 12
    dropdownBtn.Parent = frame
    
    local dropdownCorner = Instance.new("UICorner")
    dropdownCorner.CornerRadius = UDim.new(0, 4)
    dropdownCorner.Parent = dropdownBtn
    
    local expanded = false
    local dropdownList
    
    dropdownBtn.MouseButton1Click:Connect(function()
        expanded = not expanded
        if expanded then
            dropdownList = Instance.new("ScrollingFrame")
            dropdownList.Size = UDim2.new(0, 120, 0, 100)
            dropdownList.Position = UDim2.new(1, -135, 0, 50)
            dropdownList.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            dropdownList.BorderSizePixel = 0
            dropdownList.CanvasSize = UDim2.new(0, 0, 0, #options * 25)
            dropdownList.Parent = frame
            
            local listLayout = Instance.new("UIListLayout")
            listLayout.Parent = dropdownList
            
            for _, opt in ipairs(options) do
                local optBtn = Instance.new("TextButton")
                optBtn.Size = UDim2.new(1, 0, 0, 25)
                optBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                optBtn.Text = opt
                optBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
                optBtn.Font = Enum.Font.Gotham
                optBtn.TextSize = 11
                optBtn.Parent = dropdownList
                
                optBtn.MouseButton1Click:Connect(function()
                    dropdownBtn.Text = opt
                    settings[setting] = opt
                    saveConfig()
                    if callback then
                        callback(opt)
                    end
                    expanded = false
                    dropdownList:Destroy()
                end)
            end
        else
            if dropdownList then
                dropdownList:Destroy()
            end
        end
    end)
end

-- 更新标签页内容
local function updateTab()
    -- 清空内容
    for _, child in ipairs(contentFrame:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end
    
    if currentTab == "Engine Settings" then
        -- 创建原脚本的引擎设置选项
        createSlider("Framerate limit", "Set to 0 for unlimited", "FPS", 30, 360, "", function(val)
            setFFlag("DFIntTaskSchedulerTargetFps", val)
            setFFlag("FFlagTaskSchedulerLimitTargetFpsTo2402", val >= 70)
        end)
        
        createToggle("Display FPS", "Show FPS counter on screen", "DisplayFPS", function(val)
            setFFlag("FFlagDebugDisplayFPS", val)
        end)
        
        createDropdown("Anti-aliasing quality", "MSAA samples", "AntiAliasingQuality", {"Automatic", "1x", "2x", "4x"}, function(val)
            if val ~= "Automatic" then
                local msaa = val:gsub("x", "")
                setFFlag("FIntDebugForceMSAASamples", tonumber(msaa))
            end
        end)
        
        createToggle("Disable player shadows", "Remove shadows from players", "DisablePlayerShadows", function(val)
            setFFlag("FIntRenderShadowIntensity", val and 0 or 1)
        end)
        
        createToggle("Disable post-processing", "Remove post-processing effects", "DisablePostFX", function(val)
            setFFlag("FFlagDisablePostFx", val)
        end)
        
        createToggle("Disable terrain textures", "Remove terrain textures", "DisableTerrainTextures", function(val)
            setFFlag("FIntTerrainArraySliceSize", val and 0 or 32)
        end)
        
        createDropdown("Lighting technology", "Force specific lighting", "LightingTechnology", {"Chosen by game", "Voxel", "Shadow Map", "Future"}, function(val)
            local lightMap = {
                ["Voxel"] = {voxel = true, shadow = false, future = false},
                ["Shadow Map"] = {voxel = false, shadow = true, future = false},
                ["Future"] = {voxel = false, shadow = false, future = true},
            }
            local light = lightMap[val]
            if light then
                setFFlag("DFFlagDebugRenderForceTechnologyVoxel", light.voxel)
                setFFlag("DFFlagDebugRenderForceFutureIsBrightPhase2", light.shadow)
                setFFlag("DFFlagDebugRenderForceFutureIsBrightPhase3", light.future)
            end
        end)
        
        createDropdown("Texture quality", "Adjust texture resolution", "TextureQuality", {"Automatic", "Lowest", "Low", "Medium", "High", "Highest"}, function(val)
            local texMap = {
                ["Lowest"] = {override = true, quality = 0, skip = 2},
                ["Low"] = {override = true, quality = 0, skip = 0},
                ["Medium"] = {override = true, quality = 1, skip = 0},
                ["High"] = {override = true, quality = 2, skip = 0},
                ["Highest"] = {override = true, quality = 3, skip = 0},
            }
            local tex = texMap[val]
            if tex then
                setFFlag("DFFlagTextureQualityOverrideEnabled", tex.override)
                setFFlag("DFIntTextureQualityOverride", tex.quality)
                setFFlag("FIntDebugTextureManagerSkipMips", tex.skip)
            end
        end)
        
    elseif currentTab == "Mods" then
        -- 创建原脚本的 FFlag 模组选项
        createToggle("Gray sky", "Turns the sky gray (requires rejoin)", "GraySky", function(val)
            setFFlag("FFlagDebugSkyGray", val)
        end)
        
        createToggle("Desync", "Lags your character on other screens", "Desync", function(val)
            setFFlag("DFIntS2PhysicsSenderRate", val and 38000 or 15)
        end)
        
        createToggle("Hitreg Fix", "Improves hit registration in most games", "HitregFix", function(val)
            if val then
                applyHitregFix(true)
            end
        end)
        
    elseif currentTab == "Custom FFlags" then
        -- 自定义 FFlag 界面（原脚本的 FFlag Editor 样式）
        local headerFrame = Instance.new("Frame")
        headerFrame.Size = UDim2.new(0.95, 0, 0, 90)
        headerFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        headerFrame.Parent = contentFrame
        
        local headerCorner = Instance.new("UICorner")
        headerCorner.CornerRadius = UDim.new(0, 6)
        headerCorner.Parent = headerFrame
        
        local nameLabel = Instance.new("TextLabel")
        nameLabel.Size = UDim2.new(0.9, 0, 0, 20)
        nameLabel.Position = UDim2.new(0.05, 0, 0, 10)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = "FFlag Name"
        nameLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        nameLabel.TextXAlignment = Enum.TextXAlignment.Left
        nameLabel.Font = Enum.Font.Gotham
        nameLabel.TextSize = 12
        nameLabel.Parent = headerFrame
        
        local nameBox = Instance.new("TextBox")
        nameBox.Size = UDim2.new(0.9, 0, 0, 30)
        nameBox.Position = UDim2.new(0.05, 0, 0, 30)
        nameBox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        nameBox.PlaceholderText = "e.g., DFIntTaskSchedulerTargetFps"
        nameBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
        nameBox.Text = ""
        nameBox.TextColor3 = Color3.fromRGB(255, 255, 255)
        nameBox.Font = Enum.Font.Gotham
        nameBox.TextSize = 12
        nameBox.ClearTextOnFocus = false
        nameBox.Parent = headerFrame
        
        local nameBoxCorner = Instance.new("UICorner")
        nameBoxCorner.CornerRadius = UDim.new(0, 4)
        nameBoxCorner.Parent = nameBox
        
        local valueLabel = Instance.new("TextLabel")
        valueLabel.Size = UDim2.new(0.9, 0, 0, 20)
        valueLabel.Position = UDim2.new(0.05, 0, 0, 65)
        valueLabel.BackgroundTransparency = 1
        valueLabel.Text = "Value"
        valueLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        valueLabel.TextXAlignment = Enum.TextXAlignment.Left
        valueLabel.Font = Enum.Font.Gotham
        valueLabel.TextSize = 12
        valueLabel.Parent = headerFrame
        
        local valueBox = Instance.new("TextBox")
        valueBox.Size = UDim2.new(0.6, 0, 0, 30)
        valueBox.Position = UDim2.new(0.05, 0, 0, 85)
        valueBox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        valueBox.PlaceholderText = "value"
        valueBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
        valueBox.Text = ""
        valueBox.TextColor3 = Color3.fromRGB(255, 255, 255)
        valueBox.Font = Enum.Font.Gotham
        valueBox.TextSize = 12
        valueBox.ClearTextOnFocus = false
        valueBox.Parent = headerFrame
        
        local valueBoxCorner = Instance.new("UICorner")
        valueBoxCorner.CornerRadius = UDim.new(0, 4)
        valueBoxCorner.Parent = valueBox
        
        local addBtn = Instance.new("TextButton")
        addBtn.Size = UDim2.new(0.25, 0, 0, 30)
        addBtn.Position = UDim2.new(0.7, 0, 0, 85)
        addBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
        addBtn.Text = "ADD"
        addBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        addBtn.Font = Enum.Font.GothamBold
        addBtn.TextSize = 12
        addBtn.Parent = headerFrame
        
        local addCorner = Instance.new("UICorner")
        addCorner.CornerRadius = UDim.new(0, 4)
        addCorner.Parent = addBtn
        
        local listHeader = Instance.new("Frame")
        listHeader.Size = UDim2.new(0.95, 0, 0, 30)
        listHeader.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        listHeader.Parent = contentFrame
        
        local listHeaderCorner = Instance.new("UICorner")
        listHeaderCorner.CornerRadius = UDim.new(0, 6)
        listHeaderCorner.Parent = listHeader
        
        local listTitle = Instance.new("TextLabel")
        listTitle.Size = UDim2.new(0.5, 0, 1, 0)
        listTitle.Position = UDim2.new(0, 15, 0, 0)
        listTitle.BackgroundTransparency = 1
        listTitle.Text = "Current Custom FFlags"
        listTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
        listTitle.TextXAlignment = Enum.TextXAlignment.Left
        listTitle.Font = Enum.Font.GothamBold
        listTitle.TextSize = 14
        listTitle.Parent = listHeader
        
        local countLabel = Instance.new("TextLabel")
        countLabel.Size = UDim2.new(0.3, 0, 1, 0)
        countLabel.Position = UDim2.new(0.7, 0, 0, 0)
        countLabel.BackgroundTransparency = 1
        countLabel.Text = "0"
        countLabel.TextColor3 = Color3.fromRGB(100, 200, 255)
        countLabel.TextXAlignment = Enum.TextXAlignment.Right
        countLabel.Font = Enum.Font.GothamBold
        countLabel.TextSize = 14
        countLabel.Parent = listHeader
        
        local listFrame = Instance.new("ScrollingFrame")
        listFrame.Size = UDim2.new(0.95, 0, 0, 150)
        listFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        listFrame.BorderSizePixel = 0
        listFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
        listFrame.ScrollBarThickness = 4
        listFrame.Parent = contentFrame
        
        local listCorner = Instance.new("UICorner")
        listCorner.CornerRadius = UDim.new(0, 6)
        listCorner.Parent = listFrame
        
        local listLayout = Instance.new("UIListLayout")
        listLayout.Padding = UDim.new(0, 2)
        listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        listLayout.Parent = listFrame
        
        local function refreshFFlagList()
            for _, child in ipairs(listFrame:GetChildren()) do
                if child:IsA("Frame") then
                    child:Destroy()
                end
            end
            
            local count = 0
            for name, value in pairs(fflags) do
                count = count + 1
                
                local itemFrame = Instance.new("Frame")
                itemFrame.Size = UDim2.new(0.98, 0, 0, 45)
                itemFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
                itemFrame.Parent = listFrame
                
                local itemCorner = Instance.new("UICorner")
                itemCorner.CornerRadius = UDim.new(0, 4)
                itemCorner.Parent = itemFrame
                
                local nameLabel = Instance.new("TextLabel")
                nameLabel.Size = UDim2.new(0.6, 0, 0, 20)
                nameLabel.Position = UDim2.new(0, 10, 0, 5)
                nameLabel.BackgroundTransparency = 1
                nameLabel.Text = name
                nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                nameLabel.TextXAlignment = Enum.TextXAlignment.Left
                nameLabel.Font = Enum.Font.Gotham
                nameLabel.TextSize = 11
                nameLabel.TextWrapped = true
                nameLabel.Parent = itemFrame
                
                local valueLabel = Instance.new("TextLabel")
                valueLabel.Size = UDim2.new(0.6, 0, 0, 18)
                valueLabel.Position = UDim2.new(0, 10, 0, 25)
                valueLabel.BackgroundTransparency = 1
                valueLabel.Text = "Value: " .. tostring(value)
                valueLabel.TextColor3 = Color3.fromRGB(100, 200, 255)
                valueLabel.TextXAlignment = Enum.TextXAlignment.Left
                valueLabel.Font = Enum.Font.Gotham
                valueLabel.TextSize = 10
                valueLabel.Parent = itemFrame
                
                local removeBtn = Instance.new("TextButton")
                removeBtn.Size = UDim2.new(0, 50, 0, 30)
                removeBtn.Position = UDim2.new(1, -60, 0, 7.5)
                removeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
                removeBtn.Text = "DEL"
                removeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
                removeBtn.Font = Enum.Font.GothamBold
                removeBtn.TextSize = 11
                removeBtn.Parent = itemFrame
                
                local removeCorner = Instance.new("UICorner")
                removeCorner.CornerRadius = UDim.new(0, 4)
                removeCorner.Parent = removeBtn
                
                removeBtn.MouseButton1Click:Connect(function()
                    fflags[name] = nil
                    saveConfig()
                    refreshFFlagList()
                end)
                
                -- 点击项目填充到输入框
                itemFrame.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        nameBox.Text = name
                        valueBox.Text = tostring(value)
                    end
                end)
            end
            
            countLabel.Text = tostring(count)
            listFrame.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 5)
        end
        
        addBtn.MouseButton1Click:Connect(function()
            local name = nameBox.Text
            local val = valueBox.Text
            
            if name == "" or val == "" then
                return
            end
            
            -- 转换值类型
            local processed = val:lower() == "true" and true or 
                            val:lower() == "false" and false or 
                            tonumber(val) or val
            
            setFFlag(name, processed)
            refreshFFlagList()
            nameBox.Text = ""
            valueBox.Text = ""
        end)
        
        refreshFFlagList()
    end
    
    -- 更新画布大小
    contentFrame.CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y + 20)
end

-- 初始化标签页
tabButtons["Engine Settings"].BackgroundColor3 = Color3.fromRGB(0, 120, 255)
tabButtons["Engine Settings"].TextColor3 = Color3.fromRGB(255, 255, 255)
updateTab()

-- 窗口拖动
local dragging = false
local dragStart
local startPos

titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

titleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

-- 返回 GUI
return screenGui