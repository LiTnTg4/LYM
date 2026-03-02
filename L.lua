--[[
Bloxstrap: Executor Edition
完全离线整合版 - 简化修复版
]]

local cloneref = cloneref or function(...) return ... end
local players = cloneref(game:GetService('Players'))
local lplr = players.LocalPlayer
local HttpService = cloneref(game:GetService("HttpService"))
local UserInputService = cloneref(game:GetService("UserInputService"))
local getgenv = getgenv or _G

local files = {}
local writefile = writefile or function(name, src) files[name] = src end
local readfile = readfile or function(name) return files[name] end
local isfile = isfile or function(name) return readfile(name) ~= nil end
local listfiles = listfiles or function(path) return {} end
local loadfile = loadfile or function(path) return loadstring(readfile(path))() end
local makefolder = makefolder or function() end

local function GetFFlagFunc(flag)
    if type(flag) ~= "string" then return end
    local FFlag = flag:gsub("DFInt", ""):gsub("DFFlag", ""):gsub("FFlag", ""):gsub("FInt", ""):gsub("DFString", ""):gsub("FString", "")
    local success, result = pcall(function() return getfflag(FFlag) end)
    return success and result or nil
end

local function ToggleFFlagFunc(flag, value)
    if type(flag) ~= "string" then return end
    local FFlag = flag:gsub("DFInt", ""):gsub("DFFlag", ""):gsub("FFlag", ""):gsub("FInt", ""):gsub("DFString", ""):gsub("FString", "")
    pcall(function() 
        if getfflag(FFlag) ~= nil then
            local fflagfile = {}
            pcall(function()
                if isfile("Bloxstrap/FFlags.json") then
                    fflagfile = HttpService:JSONDecode(readfile("Bloxstrap/FFlags.json"))
                end
            end)
            fflagfile[flag] = tostring(value)
            pcall(function() writefile("Bloxstrap/FFlags.json", HttpService:JSONEncode(fflagfile)) end)
            setfflag(FFlag, tostring(value))
        end
    end)
end

getgenv().Bloxstrap = {}
local Bloxstrap = getgenv().Bloxstrap
Bloxstrap.TouchEnabled = UserInputService.TouchEnabled

Bloxstrap.Config = setmetatable({
    OofSound = false, FPS = 120, AntiAliasingQuality = "Automatic",
    LightingTechnology = "Chosen by game", TextureQuality = "Automatic",
    DisablePlayerShadows = false, DisablePostFX = false, DisableTerrainTextures = false,
    GraySky = false, Desync = false, HitregFix = false, customfonttoggle = false,
    customfontroblox = '', customtopbar = false, CustomFont = '', CameraSensitivity = 1,
    CrosshairImage = '', TouchUiSize = 1, DeRendering = false, GUIScale = false,
    TouchUI = false, Crosshair = false, RotatingHotbar = false, DisplayFPS = false
}, { __index = function(s, i) s[i] = false return s[i] end })

local conf = Bloxstrap.Config
Bloxstrap.canUpdate = false

Bloxstrap.UpdateConfig = function(obj, val)
    if not Bloxstrap.canUpdate then Bloxstrap.Config = conf return end
    Bloxstrap.Config[obj] = val
end

Bloxstrap.SaveConfig = function()
    return pcall(function() 
        writefile("Bloxstrap/Main/Configs/Default.json", HttpService:JSONEncode(Bloxstrap.Config)) 
    end)
end

pcall(function()
    if isfile("Bloxstrap/Main/Configs/Default.json") then
        Bloxstrap.Config = HttpService:JSONDecode(readfile("Bloxstrap/Main/Configs/Default.json"))
        conf = Bloxstrap.Config
    end
end)

local function notif(a, b)
    pcall(function()
        cloneref(game:GetService("StarterGui")):SetCore("SendNotification", {
            Title = 'Bloxstrap', Text = a, Duration = b or 6
        })
    end)
end

Bloxstrap.error, Bloxstrap.success, Bloxstrap.info = notif, notif, notif
Bloxstrap.ToggleFFlag, Bloxstrap.GetFFlag = ToggleFFlagFunc, GetFFlagFunc

local MarketplaceService = game:GetService("MarketplaceService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Player = players.LocalPlayer
local PlayerMouse = Player:GetMouse()

local redzlib = {
    Themes = {
        Darker = {
            ["Color Hub 1"] = ColorSequence.new({
                ColorSequenceKeypoint.new(0.00, Color3.fromRGB(25, 25, 25)),
                ColorSequenceKeypoint.new(0.50, Color3.fromRGB(32.5, 32.5, 32.5)),
                ColorSequenceKeypoint.new(1.00, Color3.fromRGB(25, 25, 25))
            }),
            ["Color Hub 2"] = Color3.fromRGB(30, 30, 30),
            ["Color Stroke"] = Color3.fromRGB(40, 40, 40),
            ["Color Theme"] = Color3.fromRGB(88, 101, 242),
            ["Color Text"] = Color3.fromRGB(243, 243, 243),
            ["Color Dark Text"] = Color3.fromRGB(180, 180, 180)
        },
        Dark = {
            ["Color Hub 1"] = ColorSequence.new({
                ColorSequenceKeypoint.new(0.00, Color3.fromRGB(40, 40, 40)),
                ColorSequenceKeypoint.new(0.50, Color3.fromRGB(47.5, 47.5, 47.5)),
                ColorSequenceKeypoint.new(1.00, Color3.fromRGB(40, 40, 40))
            }),
            ["Color Hub 2"] = Color3.fromRGB(45, 45, 45),
            ["Color Stroke"] = Color3.fromRGB(65, 65, 65),
            ["Color Theme"] = Color3.fromRGB(65, 150, 255),
            ["Color Text"] = Color3.fromRGB(245, 245, 245),
            ["Color Dark Text"] = Color3.fromRGB(190, 190, 190)
        },
        Purple = {
            ["Color Hub 1"] = ColorSequence.new({
                ColorSequenceKeypoint.new(0.00, Color3.fromRGB(27.5, 25, 30)),
                ColorSequenceKeypoint.new(0.50, Color3.fromRGB(32.5, 32.5, 32.5)),
                ColorSequenceKeypoint.new(1.00, Color3.fromRGB(27.5, 25, 30))
            }),
            ["Color Hub 2"] = Color3.fromRGB(30, 30, 30),
            ["Color Stroke"] = Color3.fromRGB(40, 40, 40),
            ["Color Theme"] = Color3.fromRGB(150, 0, 255),
            ["Color Text"] = Color3.fromRGB(240, 240, 240),
            ["Color Dark Text"] = Color3.fromRGB(180, 180, 180)
        }
    },
    Info = { Version = "1.1.0" },
    Save = { UISize = {550, 380}, TabSize = 160, Theme = "Darker" },
    Settings = {}, Connection = {}, Instances = {}, Elements = {}, Options = {}, Flags = {}, Tabs = {}, Icons = {}
}

local ViewportSize = workspace.CurrentCamera.ViewportSize
local UIScale = ViewportSize.Y / 450
local Settings = redzlib.Settings
local Flags = redzlib.Flags

local function SetProps(Instance, Props) if Props then for prop, value in pairs(Props) do Instance[prop] = value end end return Instance end
local function SetChildren(Instance, Children) if Children then for _, Child in pairs(Children) do Child.Parent = Instance end end return Instance end
local function InsertTheme(Instance, Type) table.insert(redzlib.Instances, { Instance = Instance, Type = Type }) return Instance end

local function Create(...)
    local args = {...}
    local new = Instance.new(args[1])
    if type(args[2]) == "table" then
        SetProps(new, args[2])
        SetChildren(new, args[3])
    elseif typeof(args[2]) == "Instance" then
        new.Parent = args[2]
        SetProps(new, args[3])
        SetChildren(new, args[4])
    end
    return new
end

local function CreateTween(Configs)
    local Instance = Configs[1] or Configs.Instance
    local Prop = Configs[2] or Configs.Prop
    local NewVal = Configs[3] or Configs.NewVal
    local Time = Configs[4] or Configs.Time or 0.5
    local TweenWait = Configs[5] or Configs.wait or false
    local TweenInfo = TweenInfo.new(Time, Enum.EasingStyle.Quint)
    local Tween = TweenService:Create(Instance, TweenInfo, {[Prop] = NewVal})
    Tween:Play()
    if TweenWait then Tween.Completed:Wait() end
    return Tween
end

local ScreenGui = Create("ScreenGui", CoreGui, { Name = "redz Library V5" }, {
    Create("UIScale", { Scale = UIScale, Name = "Scale" })
})

local ScreenFind = CoreGui:FindFirstChild(ScreenGui.Name)
if ScreenFind and ScreenFind ~= ScreenGui then ScreenFind:Destroy() end

local Theme = redzlib.Themes[redzlib.Save.Theme]

function redzlib:MakeWindow(Configs)
    local WTitle = Configs[1] or Configs.Name or Configs.Title or "Bloxstrap"
    local WMiniText = Configs[2] or Configs.SubTitle or "Executor Edition"
    
    local UISizeX, UISizeY = unpack(redzlib.Save.UISize)
    local MainFrame = InsertTheme(Create("ImageButton", ScreenGui, {
        Size = UDim2.fromOffset(UISizeX, UISizeY),
        Position = UDim2.new(0.5, -UISizeX/2, 0.5, -UISizeY/2),
        BackgroundTransparency = 0.03, Name = "Hub", Active = true, Draggable = true
    }), "Main")
    
    local MainCorner = Create("UICorner", MainFrame)
    MainCorner.CornerRadius = UDim.new(0, 7)
    
    local Components = Create("Folder", MainFrame, { Name = "Components" })
    
    local TopBar = Create("Frame", Components, {
        Size = UDim2.new(1, 0, 0, 28), BackgroundTransparency = 1
    })
    
    local Title = InsertTheme(Create("TextLabel", TopBar, {
        Position = UDim2.new(0, 15, 0.5), AnchorPoint = Vector2.new(0, 0.5),
        AutomaticSize = "XY", Text = WTitle, TextXAlignment = "Left", TextSize = 12,
        TextColor3 = Theme["Color Text"], BackgroundTransparency = 1, Font = Enum.Font.GothamMedium
    }), "Text")
    
    local SubTitle = InsertTheme(Create("TextLabel", Title, {
        Size = UDim2.fromScale(0, 1), AutomaticSize = "X", AnchorPoint = Vector2.new(0, 1),
        Position = UDim2.new(1, 5, 0.9), Text = WMiniText, TextColor3 = Theme["Color Dark Text"],
        BackgroundTransparency = 1, TextXAlignment = "Left", TextYAlignment = "Bottom",
        TextSize = 8, Font = Enum.Font.Gotham
    }), "DarkText")
    
    local MainScroll = InsertTheme(Create("ScrollingFrame", Components, {
        Size = UDim2.new(0, redzlib.Save.TabSize, 1, -TopBar.Size.Y.Offset),
        ScrollBarImageColor3 = Theme["Color Theme"], Position = UDim2.new(0, 0, 1, 0),
        AnchorPoint = Vector2.new(0, 1), ScrollBarThickness = 1.5, BackgroundTransparency = 1,
        ScrollBarImageTransparency = 0.2, CanvasSize = UDim2.new(), AutomaticCanvasSize = "Y",
        ScrollingDirection = "Y", BorderSizePixel = 0
    }), "ScrollBar")
    
    local Containers = Create("Frame", Components, {
        Size = UDim2.new(1, -MainScroll.Size.X.Offset, 1, -TopBar.Size.Y.Offset),
        AnchorPoint = Vector2.new(1, 1), Position = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1, ClipsDescendants = true
    })
    
    local CloseButton = Create("ImageButton", TopBar, {
        Size = UDim2.new(0, 14, 0, 14), Position = UDim2.new(1, -10, 0.5),
        AnchorPoint = Vector2.new(1, 0.5), BackgroundTransparency = 1,
        Image = "rbxassetid://10747384394", AutoButtonColor = false
    })
    
    local MinimizeButton = Create("ImageButton", TopBar, {
        Size = UDim2.new(0, 14, 0, 14), Position = UDim2.new(1, -35, 0.5),
        AnchorPoint = Vector2.new(1, 0.5), BackgroundTransparency = 1,
        Image = "rbxassetid://10734896206", AutoButtonColor = false
    })
    
    local Window = {}
    function Window:Visible(bool) ScreenGui.Enabled = bool end
    function Window:CloseBtn() ScreenGui:Destroy() end
    function Window:MinimizeBtn() MainFrame.Visible = not MainFrame.Visible end
    function Window:Set(Val1, Val2)
        if Val1 and Val2 then Title.Text = Val1; SubTitle.Text = Val2
        elseif Val1 then Title.Text = Val1 end
    end
    
    CloseButton.Activated:Connect(Window.CloseBtn)
    MinimizeButton.Activated:Connect(Window.MinimizeBtn)
    
    local ContainerList = {}
    function Window:MakeTab(Configs)
        if type(Configs) == "table" then Configs = Configs end
        local TName = Configs[1] or Configs.Title or "Tab"
        
        local TabSelect = Create("TextButton", MainScroll, {
            Size = UDim2.new(1, 0, 0, 24), Text = "", BackgroundColor3 = Theme["Color Hub 2"],
            AutoButtonColor = false
        })
        local TabCorner = Create("UICorner", TabSelect)
        TabCorner.CornerRadius = UDim.new(0, 6)
        
        local LabelTitle = InsertTheme(Create("TextLabel", TabSelect, {
            Size = UDim2.new(1, -15, 1), Position = UDim2.fromOffset(15),
            BackgroundTransparency = 1, Font = Enum.Font.GothamMedium, Text = TName,
            TextColor3 = Theme["Color Text"], TextSize = 10, TextXAlignment = "Left"
        }), "Text")
        
        local Selected = InsertTheme(Create("Frame", TabSelect, {
            Size = UDim2.new(0, 4, 0, 4), Position = UDim2.new(0, 1, 0.5),
            AnchorPoint = Vector2.new(0, 0.5), BackgroundColor3 = Theme["Color Theme"],
            BackgroundTransparency = 1
        }), "Theme")
        local SelectedCorner = Create("UICorner", Selected)
        SelectedCorner.CornerRadius = UDim.new(0.5, 0)
        
        local Container = InsertTheme(Create("ScrollingFrame", {
            Size = UDim2.new(1, 0, 1, 0), Position = UDim2.new(0, 0, 1),
            AnchorPoint = Vector2.new(0, 1), ScrollBarThickness = 1.5, BackgroundTransparency = 1,
            ScrollBarImageColor3 = Theme["Color Theme"], AutomaticCanvasSize = "Y",
            ScrollingDirection = "Y", BorderSizePixel = 0
        }), "ScrollBar")
        
        table.insert(ContainerList, Container)
        
        local function SelectTab()
            for _, Frame in pairs(ContainerList) do if Frame ~= Container then Frame.Parent = nil end end
            Container.Parent = Containers
            CreateTween({Selected, "Size", UDim2.new(0, 4, 0, 13), 0.35})
            CreateTween({Selected, "BackgroundTransparency", 0, 0.35})
        end
        
        TabSelect.Activated:Connect(SelectTab)
        if #ContainerList == 1 then SelectTab() end
        
        local Tab = { Cont = Container }
        function Tab:AddSection(Configs)
            local SectionName = type(Configs) == "string" and Configs or Configs[1] or Configs.Name or Configs.Title
            local SectionFrame = Create("Frame", Container, {
                Size = UDim2.new(1, 0, 0, 20), BackgroundTransparency = 1
            })
            local SectionLabel = InsertTheme(Create("TextLabel", SectionFrame, {
                Font = Enum.Font.GothamBold, Text = SectionName, TextColor3 = Theme["Color Text"],
                Size = UDim2.new(1, -25, 1, 0), Position = UDim2.new(0, 5),
                BackgroundTransparency = 1, TextSize = 14, TextXAlignment = "Left"
            }), "Text")
            local Section = {}
            function Section:Set(New) if New then SectionLabel.Text = New end end
            return Section
        end
        
        function Tab:AddButton(Configs)
            local BName = Configs[1] or Configs.Name or Configs.Title or "Button"
            local Callback = Configs[2] or Configs.Callback or function() end
            
            local Button = Create("TextButton", Container, {
                Size = UDim2.new(1, 0, 0, 25), Text = "", BackgroundColor3 = Theme["Color Hub 2"],
                AutoButtonColor = false
            })
            local ButtonCorner = Create("UICorner", Button)
            ButtonCorner.CornerRadius = UDim.new(0, 6)
            
            local Label = InsertTheme(Create("TextLabel", Button, {
                Size = UDim2.new(1, -20, 1), Position = UDim2.new(0, 10, 0.5),
                AnchorPoint = Vector2.new(0, 0.5), BackgroundTransparency = 1,
                Font = Enum.Font.GothamMedium, Text = BName, TextColor3 = Theme["Color Text"],
                TextXAlignment = "Left", TextSize = 10
            }), "Text")
            
            Button.Activated:Connect(Callback)
            
            local Btn = {}
            function Btn:Set(New) if New then Label.Text = New end end
            return Btn
        end
        
        function Tab:AddToggle(Configs)
            local TName = Configs[1] or Configs.Name or Configs.Title or "Toggle"
            local Default = Configs[2] or Configs.Default or false
            local Callback = Configs[3] or Configs.Callback or function() end
            
            local Button = Create("TextButton", Container, {
                Size = UDim2.new(1, 0, 0, 25), Text = "", BackgroundColor3 = Theme["Color Hub 2"],
                AutoButtonColor = false
            })
            local ButtonCorner = Create("UICorner", Button)
            ButtonCorner.CornerRadius = UDim.new(0, 6)
            
            local Label = InsertTheme(Create("TextLabel", Button, {
                Size = UDim2.new(1, -38, 1), Position = UDim2.new(0, 10, 0.5),
                AnchorPoint = Vector2.new(0, 0.5), BackgroundTransparency = 1,
                Font = Enum.Font.GothamMedium, Text = TName, TextColor3 = Theme["Color Text"],
                TextXAlignment = "Left", TextSize = 10
            }), "Text")
            
            local ToggleHolder = Create("Frame", Button, {
                Size = UDim2.new(0, 35, 0, 18), Position = UDim2.new(1, -10, 0.5),
                AnchorPoint = Vector2.new(1, 0.5), BackgroundColor3 = Theme["Color Stroke"]
            })
            local HolderCorner = Create("UICorner", ToggleHolder)
            HolderCorner.CornerRadius = UDim.new(0.5, 0)
            
            local Toggle = InsertTheme(Create("Frame", ToggleHolder, {
                Size = UDim2.new(0, 12, 0, 12), Position = UDim2.new(Default and 1 or 0, 0, 0.5),
                AnchorPoint = Vector2.new(Default and 1 or 0, 0.5), BackgroundColor3 = Theme["Color Theme"],
                BackgroundTransparency = Default and 0 or 0.8
            }), "Theme")
            local ToggleCorner = Create("UICorner", Toggle)
            ToggleCorner.CornerRadius = UDim.new(0.5, 0)
            
            local State = Default
            Button.Activated:Connect(function()
                State = not State
                CreateTween({Toggle, "Position", UDim2.new(State and 1 or 0, 0, 0.5), 0.25})
                CreateTween({Toggle, "BackgroundTransparency", State and 0 or 0.8, 0.25})
                CreateTween({Toggle, "AnchorPoint", Vector2.new(State and 1 or 0, 0.5), 0.25})
                Callback(State)
                if Bloxstrap and Bloxstrap.canUpdate then
                    Bloxstrap.UpdateConfig(Configs.Flag or TName, State)
                    Bloxstrap.SaveConfig()
                end
            end)
            
            local Tgl = {}
            function Tgl:Toggle(val) State = val; Button.Activated:Fire() end
            return Tgl
        end
        
        function Tab:AddDropdown(Configs)
            local DName = Configs[1] or Configs.Name or Configs.Title or "Dropdown"
            local DOptions = Configs[2] or Configs.Options or {}
            local Callback = Configs[4] or Configs.Callback or function() end
            
            local Button = Create("TextButton", Container, {
                Size = UDim2.new(1, 0, 0, 25), Text = "", BackgroundColor3 = Theme["Color Hub 2"],
                AutoButtonColor = false
            })
            local ButtonCorner = Create("UICorner", Button)
            ButtonCorner.CornerRadius = UDim.new(0, 6)
            
            local Label = InsertTheme(Create("TextLabel", Button, {
                Size = UDim2.new(1, -180, 1), Position = UDim2.new(0, 10, 0.5),
                AnchorPoint = Vector2.new(0, 0.5), BackgroundTransparency = 1,
                Font = Enum.Font.GothamMedium, Text = DName, TextColor3 = Theme["Color Text"],
                TextXAlignment = "Left", TextSize = 10
            }), "Text")
            
            local SelectedFrame = Create("Frame", Button, {
                Size = UDim2.new(0, 150, 0, 18), Position = UDim2.new(1, -10, 0.5),
                AnchorPoint = Vector2.new(1, 0.5), BackgroundColor3 = Theme["Color Stroke"]
            })
            local FrameCorner = Create("UICorner", SelectedFrame)
            FrameCorner.CornerRadius = UDim.new(0, 4)
            
            local ActiveLabel = InsertTheme(Create("TextLabel", SelectedFrame, {
                Size = UDim2.new(0.85, 0, 0.85, 0), AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.new(0.5, 0, 0.5, 0), BackgroundTransparency = 1,
                Font = Enum.Font.GothamBold, TextScaled = true, TextColor3 = Theme["Color Text"],
                Text = "..."
            }), "Text")
            
            local Selected = DOptions[1] or "..."
            ActiveLabel.Text = Selected
            
            Button.Activated:Connect(function()
                local nextIndex = 1
                for i, v in ipairs(DOptions) do
                    if v == Selected then nextIndex = i % #DOptions + 1; break end
                end
                Selected = DOptions[nextIndex]
                ActiveLabel.Text = Selected
                Callback(Selected)
                if Bloxstrap and Bloxstrap.canUpdate then
                    Bloxstrap.UpdateConfig(Configs.Flag or DName, Selected)
                    Bloxstrap.SaveConfig()
                end
            end)
            
            local Drop = {}
            return Drop
        end
        
        function Tab:AddSlider(Configs)
            local SName = Configs[1] or Configs.Name or Configs.Title or "Slider"
            local Min = Configs[2] or Configs.Min or 10
            local Max = Configs[3] or Configs.Max or 100
            local Increase = Configs[4] or Configs.Increase or 1
            local Default = Configs[5] or Configs.Default or 25
            local Callback = Configs[6] or Configs.Callback or function() end
            
            local Button = Create("TextButton", Container, {
                Size = UDim2.new(1, 0, 0, 25), Text = "", BackgroundColor3 = Theme["Color Hub 2"],
                AutoButtonColor = false
            })
            local ButtonCorner = Create("UICorner", Button)
            ButtonCorner.CornerRadius = UDim.new(0, 6)
            
            local Label = InsertTheme(Create("TextLabel", Button, {
                Size = UDim2.new(1, -180, 1), Position = UDim2.new(0, 10, 0.5),
                AnchorPoint = Vector2.new(0, 0.5), BackgroundTransparency = 1,
                Font = Enum.Font.GothamMedium, Text = SName, TextColor3 = Theme["Color Text"],
                TextXAlignment = "Left", TextSize = 10
            }), "Text")
            
            local ValueLabel = InsertTheme(Create("TextLabel", Button, {
                Size = UDim2.new(0, 40, 0, 14), Position = UDim2.new(1, -50, 0.5),
                AnchorPoint = Vector2.new(1, 0.5), BackgroundTransparency = 1,
                Font = Enum.Font.FredokaOne, Text = tostring(Default), TextColor3 = Theme["Color Text"],
                TextSize = 12
            }), "Text")
            
            local Slider = {}
            function Slider:Set(val) ValueLabel.Text = tostring(val); Callback(val) end
            return Slider
        end
        
        function Tab:AddTextBox(Configs)
            local TName = Configs[1] or Configs.Name or Configs.Title or "Text Box"
            local Callback = Configs[4] or Configs.Callback or function() end
            
            local Button = Create("TextButton", Container, {
                Size = UDim2.new(1, 0, 0, 25), Text = "", BackgroundColor3 = Theme["Color Hub 2"],
                AutoButtonColor = false
            })
            local ButtonCorner = Create("UICorner", Button)
            ButtonCorner.CornerRadius = UDim.new(0, 6)
            
            local Label = InsertTheme(Create("TextLabel", Button, {
                Size = UDim2.new(1, -180, 1), Position = UDim2.new(0, 10, 0.5),
                AnchorPoint = Vector2.new(0, 0.5), BackgroundTransparency = 1,
                Font = Enum.Font.GothamMedium, Text = TName, TextColor3 = Theme["Color Text"],
                TextXAlignment = "Left", TextSize = 10
            }), "Text")
            
            local TextBox = {}
            return TextBox
        end
        
        return Tab
    end
    
    return Window
end

Bloxstrap.start = function(vis)
    vis = vis or true
    
    if not vis then
        setidentity(8)
        local coreGui = game:GetService('CoreGui')
        if coreGui["redz Library V5"] then coreGui["redz Library V5"].Enabled = false end
    end
    
    getgenv().errorlog = getgenv().errorlog or "Bloxstrap/Logs/crashlog"..HttpService:GenerateGUID(false)..".txt"
    
    local GUI = redzlib
    local main = GUI:MakeWindow({ Title = "Bloxstrap", SubTitle = "Executor Edition", SaveFolder = "Bloxstrap/Main/Configs" })
    main:Visible(vis)
    
    local Integrations = main:MakeTab({ "Integrations" })
    local FastFlags = main:MakeTab({ "Mods" })
    local EngineSettings = main:MakeTab({ "Engine Settings" })
    local Appearance = main:MakeTab({ "Appearance" })
    
    FastFlags:AddSection("Fast Flag Editor")
    FastFlags:AddTextBox({ Name = "Paste Fast Flags (json)", Description = "Paste JSON FFlags here", Callback = function(call)
        if call and call ~= "" then
            writefile("Bloxstrap/FFlags.json", call)
            local success, fflags = pcall(function() return HttpService:JSONDecode(call:gsub('"True"', "true"):gsub('"False"', "false")) end)
            if success and type(fflags) == "table" then for flag, value in pairs(fflags) do Bloxstrap.ToggleFFlag(flag, value) end end
        end
    end })
    
    FastFlags:AddSection("Presets")
    FastFlags:AddToggle({ Name = "Gray sky", Description = "Turns the sky gray", Default = Bloxstrap.Config.GraySky, Flag = "GraySky", Callback = function(call) Bloxstrap.ToggleFFlag("FFlagDebugSkyGray", call) end })
    FastFlags:AddToggle({ Name = "Desync", Description = "Lags your character behind", Default = Bloxstrap.Config.Desync, Flag = "Desync", Callback = function(call) Bloxstrap.ToggleFFlag("DFIntS2PhysicsSenderRate", call and 38000 or 15) end })
    
    EngineSettings:AddSection("Performance")
    EngineSettings:AddTextBox({ Name = "Framerate limit", Description = "Set FPS limit (0 = unlimited)", Default = tostring(Bloxstrap.Config.FPS), Callback = function(fps)
        fps = tonumber(fps) or 120
        Bloxstrap.UpdateConfig("FPS", fps)
        Bloxstrap.ToggleFFlag('FFlagTaskSchedulerLimitTargetFpsTo2402', fps >= 70)
        if fps > 0 then
            pcall(function() setfpscap(fps) end)
            Bloxstrap.ToggleFFlag("DFIntTaskSchedulerTargetFps", fps)
        else
            pcall(function() setfpscap(9e9) end)
        end
    end })
    
    EngineSettings:AddToggle({ Name = "Display FPS", Default = Bloxstrap.Config.DisplayFPS, Flag = "DisplayFPS", Callback = function(call) Bloxstrap.ToggleFFlag('FFlagDebugDisplayFPS', call) end })
    EngineSettings:AddSection("Graphics")
    EngineSettings:AddToggle({ Name = "Disable player shadows", Default = Bloxstrap.Config.DisablePlayerShadows, Flag = "DisablePlayerShadows", Callback = function(call) Bloxstrap.ToggleFFlag("FIntRenderShadowIntensity", call and 0 or 1) end })
    EngineSettings:AddToggle({ Name = "Disable post-processing", Default = Bloxstrap.Config.DisablePostFX, Flag = "DisablePostFX", Callback = function(call) Bloxstrap.ToggleFFlag("FFlagDisablePostFx", call) end })
    
    Appearance:AddSection("Player")
    Appearance:AddSlider({ Name = "Camera Sensitivity", Min = 1, Max = 7, Increase = 0.1, Default = Bloxstrap.Config.CameraSensitivity, Flag = "CameraSensitivity", Callback = function(val)
        Bloxstrap.UpdateConfig("CameraSensitivity", val)
        pcall(function()
            local camerascript = require(lplr.PlayerScripts.PlayerModule.CameraModule.CameraInput)
            if camerascript and camerascript.getRotation then
                local old = camerascript.getRotation
                camerascript.getRotation = function(...) return old(...) * val end
            end
        end)
    end })
    
    Appearance:AddSection("Customizations")
    Appearance:AddToggle({ Name = "Bloxstrap Topbars", Description = "Custom topbar style", Default = Bloxstrap.Config.customtopbar, Flag = "customtopbar" })
    Appearance:AddToggle({ Name = "Spin Hotbar", Description = "Spins the Roblox logo", Default = Bloxstrap.Config.RotatingHotbar, Flag = "RotatingHotbar" })
    
    EngineSettings:AddSection("Audio")
    EngineSettings:AddToggle({ Name = "Use old death sound", Description = "Bring back the classic 'oof'", Default = Bloxstrap.Config.OofSound, Flag = "OofSound", Callback = function(call)
        if call and lplr.Character and lplr.Character:FindFirstChild('Humanoid') then
            local humanoid = lplr.Character.Humanoid
            local connection
            connection = humanoid.HealthChanged:Connect(function()
                if humanoid.Health <= 0 then
                    pcall(function()
                        lplr.PlayerScripts.RbxCharacterSounds.Enabled = false
                        local sound = Instance.new("Sound", workspace)
                        sound.SoundId = isfile('Bloxstrap/oofsound.mp3') and getcustomasset('Bloxstrap/oofsound.mp3') or "rbxasset://sounds/uuhhh.mp3"
                        sound.PlayOnRemove = true
                        sound.Volume = 0.5
                        sound:Destroy()
                    end)
                    if connection then connection:Disconnect() end
                end
            end)
        end
    end })
    
    Bloxstrap.canUpdate = true
    notif("Bloxstrap loaded successfully!", 3)
end

return Bloxstrap