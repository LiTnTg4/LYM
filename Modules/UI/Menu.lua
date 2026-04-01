local Menu = {}

function Menu.init(player, state, modules, tweenService)
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "WastelandMenu"
    screenGui.IgnoreGuiInset = true
    screenGui.ResetOnSpawn = false
    screenGui.Parent = player:WaitForChild("PlayerGui")
    
    local menuSize = 1.0
    local minSize = 0.6
    local maxSize = 1.5
    local menuFrame = nil
    local timerTextObj = nil
    local isAnimating = false
    local startTime = os.time()
    local minButton = nil
    local isUnloaded = false
    
    local BASE_WIDTH = 380
    local BASE_HEIGHT = 580
    
    local FONT_SIZES = {
        title = 15,
        button = 18,
        userName = 18,
        timer = 14,
        itemName = 20,
        status = 17,
        unload = 19,
        unloadTip = 12,
        footer = 12,
        flicker = 14
    }
    
    local function formatTime(seconds)
        local hours = math.floor(seconds / 3600)
        local minutes = math.floor((seconds % 3600) / 60)
        local secs = seconds % 60
        if hours > 0 then
            return string.format("%02d:%02d:%02d", hours, minutes, secs)
        else
            return string.format("%02d:%02d", minutes, secs)
        end
    end
    
    local function getUptimeString()
        local elapsed = os.time() - startTime
        return formatTime(elapsed)
    end
    
    local function getBaseScale()
        local viewportSize = workspace.CurrentCamera.ViewportSize
        return math.min(1.3, math.max(0.7, viewportSize.Y / 1080))
    end
    
    local function getScale()
        return getBaseScale() * menuSize
    end
    
    local function ss(value)
        return math.floor(value * getScale())
    end
    
    local function getFontSize(baseSize)
        return math.floor(baseSize * getScale())
    end
    
    local uiElements = {
        titleText = nil,
        zoomText = nil,
        zoomInBtn = nil,
        zoomOutBtn = nil,
        userName = nil,
        timerLabel = nil,
        itemFrames = {},
        unloadText = nil,
        unloadTip = nil,
        footerText = nil,
        flickerText = nil
    }
    
    local function updateAllUI()
        if not menuFrame then return end
        
        local s = getScale()
        local newWidth = ss(BASE_WIDTH)
        local newHeight = ss(BASE_HEIGHT)
        
        local oldCenterX = menuFrame.AbsolutePosition.X + menuFrame.AbsoluteSize.X / 2
        local oldCenterY = menuFrame.AbsolutePosition.Y + menuFrame.AbsoluteSize.Y / 2
        
        menuFrame.Size = UDim2.new(0, newWidth, 0, newHeight)
        
        local newPosX = oldCenterX - newWidth / 2
        local newPosY = oldCenterY - newHeight / 2
        menuFrame.Position = UDim2.new(0, newPosX, 0, newPosY)
        
        local titleBar = menuFrame:FindFirstChild("TitleBar")
        if titleBar then
            titleBar.Size = UDim2.new(1, 0, 0, ss(48))
            if uiElements.titleText then
                uiElements.titleText.TextSize = getFontSize(FONT_SIZES.title)
                uiElements.titleText.Size = UDim2.new(0.5, -ss(12), 1, 0)
                uiElements.titleText.Position = UDim2.new(0, ss(12), 0, 0)
            end
            
            local buttonContainer = titleBar:FindFirstChild("ButtonContainer")
            if buttonContainer then
                buttonContainer.Size = UDim2.new(0, ss(140), 1, 0)
                buttonContainer.Position = UDim2.new(1, -ss(150), 0, 0)
                
                if uiElements.zoomText then
                    uiElements.zoomText.Size = UDim2.new(0, ss(55), 1, 0)
                    uiElements.zoomText.Position = UDim2.new(1, -ss(108), 0, 0)
                    uiElements.zoomText.TextSize = getFontSize(14)
                end
                if uiElements.zoomInBtn then
                    uiElements.zoomInBtn.Size = UDim2.new(0, ss(38), 1, 0)
                    uiElements.zoomInBtn.Position = UDim2.new(1, -ss(156), 0, 0)
                    uiElements.zoomInBtn.TextSize = getFontSize(FONT_SIZES.button)
                end
                if uiElements.zoomOutBtn then
                    uiElements.zoomOutBtn.Size = UDim2.new(0, ss(38), 1, 0)
                    uiElements.zoomOutBtn.Position = UDim2.new(1, -ss(204), 0, 0)
                    uiElements.zoomOutBtn.TextSize = getFontSize(FONT_SIZES.button)
                end
            end
        end
        
        local userFrame = menuFrame:FindFirstChild("UserFrame")
        if userFrame then
            userFrame.Size = UDim2.new(1, -ss(20), 0, ss(64))
            userFrame.Position = UDim2.new(0, ss(10), 0, ss(56))
            if uiElements.userName then
                uiElements.userName.TextSize = getFontSize(FONT_SIZES.userName)
                uiElements.userName.Size = UDim2.new(1, -ss(10), 0, ss(28))
                uiElements.userName.Position = UDim2.new(0, ss(8), 0, ss(6))
            end
            if uiElements.timerLabel then
                uiElements.timerLabel.TextSize = getFontSize(FONT_SIZES.timer)
                uiElements.timerLabel.Size = UDim2.new(1, -ss(10), 0, ss(26))
                uiElements.timerLabel.Position = UDim2.new(0, ss(8), 0, ss(34))
            end
        end
        
        local scrollFrame = menuFrame:FindFirstChild("ScrollFrame")
        if scrollFrame then
            scrollFrame.Size = UDim2.new(1, -ss(20), 0, ss(350))
            scrollFrame.Position = UDim2.new(0, ss(10), 0, ss(128))
            scrollFrame.ScrollBarThickness = ss(4)
            
            for i, itemFrame in ipairs(uiElements.itemFrames) do
                if itemFrame then
                    itemFrame.Size = UDim2.new(1, 0, 0, ss(64))
                    itemFrame.Position = UDim2.new(0, 0, 0, (i - 1) * ss(68))
                    
                    local nl = itemFrame:FindFirstChild("ItemName")
                    if nl then
                        nl.TextSize = getFontSize(FONT_SIZES.itemName)
                        nl.Size = UDim2.new(0.65, -ss(10), 1, 0)
                        nl.Position = UDim2.new(0, ss(12), 0, 0)
                    end
                    
                    local status = itemFrame:FindFirstChild("StatusIndicator")
                    if status then
                        status.TextSize = getFontSize(FONT_SIZES.status)
                        status.Size = UDim2.new(0, ss(80), 1, 0)
                        status.Position = UDim2.new(1, -ss(90), 0, 0)
                    end
                end
            end
        end
        
        local unloadFrame = menuFrame:FindFirstChild("UnloadFrame")
        if unloadFrame then
            unloadFrame.Size = UDim2.new(1, -ss(20), 0, ss(64))
            unloadFrame.Position = UDim2.new(0, ss(10), 0, ss(460))
            if uiElements.unloadText then
                uiElements.unloadText.TextSize = getFontSize(FONT_SIZES.unload)
                uiElements.unloadText.Size = UDim2.new(1, -ss(15), 0, ss(32))
                uiElements.unloadText.Position = UDim2.new(0, ss(12), 0, ss(10))
            end
            if uiElements.unloadTip then
                uiElements.unloadTip.TextSize = getFontSize(FONT_SIZES.unloadTip)
                uiElements.unloadTip.Size = UDim2.new(1, -ss(15), 0, ss(22))
                uiElements.unloadTip.Position = UDim2.new(0, ss(12), 1, -ss(20))
            end
        end
        
        local footer = menuFrame:FindFirstChild("Footer")
        if footer then
            footer.Size = UDim2.new(1, -ss(20), 0, ss(32))
            footer.Position = UDim2.new(0, ss(10), 1, -ss(36))
            if uiElements.footerText then
                uiElements.footerText.TextSize = getFontSize(FONT_SIZES.footer)
                uiElements.footerText.Size = UDim2.new(1, -ss(10), 1, 0)
                uiElements.footerText.Position = UDim2.new(0, ss(5), 0, 0)
            end
        end
        
        if uiElements.flickerText then
            uiElements.flickerText.TextSize = getFontSize(FONT_SIZES.flicker)
            uiElements.flickerText.Size = UDim2.new(0, ss(30), 0, ss(22))
            uiElements.flickerText.Position = UDim2.new(0.5, ss(20), 0, ss(10))
        end
    end
    
    local function showMenu()
        if not menuFrame then return end
        if isAnimating then return end
        
        menuFrame.Visible = true
        isAnimating = true
        
        local targetSize = menuFrame.Size
        local targetPosition = menuFrame.Position
        local targetTransparency = menuFrame.BackgroundTransparency
        
        menuFrame.Size = UDim2.new(targetSize.X.Scale, targetSize.X.Offset * 0.7, targetSize.Y.Scale, targetSize.Y.Offset * 0.7)
        menuFrame.Position = targetPosition
        menuFrame.BackgroundTransparency = 0.5
        
        local tweenInfo = TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        local sizeTween = tweenService:Create(menuFrame, tweenInfo, {Size = targetSize})
        local transTween = tweenService:Create(menuFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = targetTransparency})
        
        sizeTween:Play()
        transTween:Play()
        
        sizeTween.Completed:Connect(function()
            isAnimating = false
        end)
    end
    
    local function hideMenu()
        if not menuFrame then return end
        if isAnimating then return end
        if not menuFrame.Visible then return end
        
        isAnimating = true
        
        local targetSize = menuFrame.Size
        local targetPosition = menuFrame.Position
        
        local tweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        local sizeTween = tweenService:Create(menuFrame, tweenInfo, {Size = UDim2.new(targetSize.X.Scale, targetSize.X.Offset * 0.7, targetSize.Y.Scale, targetSize.Y.Offset * 0.7)})
        local transTween = tweenService:Create(menuFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0.5})
        
        sizeTween:Play()
        transTween:Play()
        
        sizeTween.Completed:Connect(function()
            menuFrame.Visible = false
            menuFrame.Size = targetSize
            menuFrame.Position = targetPosition
            menuFrame.BackgroundTransparency = 0.05
            isAnimating = false
        end)
    end
    
    local function zoomMenu(delta)
        local newSize = menuSize + delta
        if newSize >= minSize and newSize <= maxSize then
            menuSize = newSize
            updateAllUI()
            if uiElements.zoomText then
                uiElements.zoomText.Text = string.format("%.0f%%", menuSize * 100)
            end
        end
    end
    
    local function buildMenu()
        local s = getScale()
        
        local mf = Instance.new("Frame")
        mf.Size = UDim2.new(0, ss(BASE_WIDTH), 0, ss(BASE_HEIGHT))
        mf.Position = UDim2.new(0.5, -ss(BASE_WIDTH) / 2, 0.5, -ss(BASE_HEIGHT) / 2)
        mf.BackgroundColor3 = Color3.fromRGB(15, 12, 8)
        mf.BackgroundTransparency = 0.05
        mf.Active = true
        mf.Draggable = true
        mf.Visible = false
        mf.Parent = screenGui
        
        local mainBorder = Instance.new("UIStroke")
        mainBorder.Thickness = 3
        mainBorder.Color = Color3.fromRGB(180, 100, 40)
        mainBorder.Transparency = 0.2
        mainBorder.Parent = mf
        
        local scanline = Instance.new("Frame")
        scanline.Name = "Scanline"
        scanline.Size = UDim2.new(1, 0, 0, 2)
        scanline.Position = UDim2.new(0, 0, 0, 0)
        scanline.BackgroundColor3 = Color3.fromRGB(255, 180, 80)
        scanline.BackgroundTransparency = 0.7
        scanline.BorderSizePixel = 0
        scanline.Parent = mf
        
        task.spawn(function()
            local y = 0
            while mf and mf.Parent do
                task.wait(0.03)
                y = y + ss(4)
                if y > ss(BASE_HEIGHT) then y = 0 end
                if scanline then scanline.Position = UDim2.new(0, 0, 0, y) end
            end
        end)
        
        local function addWastelandCorner(parent, x, y)
            local cornerGroup = Instance.new("Frame")
            cornerGroup.Size = UDim2.new(0, ss(20), 0, ss(20))
            cornerGroup.Position = UDim2.new(x, x == 0 and 0 or -ss(20), y, y == 0 and 0 or -ss(20))
            cornerGroup.BackgroundTransparency = 1
            cornerGroup.Parent = parent
            
            local line1 = Instance.new("Frame")
            line1.Size = UDim2.new(0, ss(15), 0, 2)
            line1.Position = UDim2.new(0, x == 0 and 0 or -ss(15), 0, y == 0 and 0 or ss(18))
            line1.BackgroundColor3 = Color3.fromRGB(180, 100, 40)
            line1.BackgroundTransparency = 0.4
            line1.BorderSizePixel = 0
            line1.Parent = cornerGroup
            
            local line2 = Instance.new("Frame")
            line2.Size = UDim2.new(0, 2, 0, ss(15))
            line2.Position = UDim2.new(0, x == 0 and ss(18) or -ss(20), 0, y == 0 and 0 or -ss(15))
            line2.BackgroundColor3 = Color3.fromRGB(180, 100, 40)
            line2.BackgroundTransparency = 0.4
            line2.BorderSizePixel = 0
            line2.Parent = cornerGroup
        end
        
        addWastelandCorner(mf, 0, 0)
        addWastelandCorner(mf, 1, 0)
        addWastelandCorner(mf, 0, 1)
        addWastelandCorner(mf, 1, 1)
        
        local titleBar = Instance.new("Frame")
        titleBar.Name = "TitleBar"
        titleBar.Size = UDim2.new(1, 0, 0, ss(48))
        titleBar.BackgroundColor3 = Color3.fromRGB(25, 18, 12)
        titleBar.BackgroundTransparency = 0.2
        titleBar.BorderSizePixel = 0
        titleBar.Parent = mf
        
        uiElements.titleText = Instance.new("TextLabel")
        uiElements.titleText.Text = "Reming祝大家天天开心❤️"
        uiElements.titleText.TextColor3 = Color3.fromRGB(255, 180, 80)
        uiElements.titleText.TextSize = getFontSize(FONT_SIZES.title)
        uiElements.titleText.Font = Enum.Font.Code
        uiElements.titleText.TextXAlignment = Enum.TextXAlignment.Left
        uiElements.titleText.TextYAlignment = Enum.TextYAlignment.Center
        uiElements.titleText.BackgroundTransparency = 1
        uiElements.titleText.Size = UDim2.new(0.5, -ss(12), 1, 0)
        uiElements.titleText.Position = UDim2.new(0, ss(12), 0, 0)
        uiElements.titleText.Parent = titleBar
        
        local buttonContainer = Instance.new("Frame")
        buttonContainer.Name = "ButtonContainer"
        buttonContainer.Size = UDim2.new(0, ss(140), 1, 0)
        buttonContainer.Position = UDim2.new(1, -ss(150), 0, 0)
        buttonContainer.BackgroundTransparency = 1
        buttonContainer.Parent = titleBar
        
        minButton = Instance.new("TextButton")
        minButton.Size = UDim2.new(0, ss(38), 1, 0)
        minButton.Position = UDim2.new(1, -ss(38), 0, 0)
        minButton.BackgroundTransparency = 1
        minButton.Text = "[-]"
        minButton.TextColor3 = Color3.fromRGB(255, 180, 80)
        minButton.TextSize = getFontSize(FONT_SIZES.button)
        minButton.Font = Enum.Font.Code
        minButton.Parent = buttonContainer
        
        uiElements.zoomText = Instance.new("TextLabel")
        uiElements.zoomText.Name = "ZoomText"
        uiElements.zoomText.Size = UDim2.new(0, ss(55), 1, 0)
        uiElements.zoomText.Position = UDim2.new(1, -ss(108), 0, 0)
        uiElements.zoomText.BackgroundTransparency = 1
        uiElements.zoomText.Text = string.format("%.0f%%", menuSize * 100)
        uiElements.zoomText.TextColor3 = Color3.fromRGB(200, 150, 80)
        uiElements.zoomText.TextSize = getFontSize(14)
        uiElements.zoomText.Font = Enum.Font.Code
        uiElements.zoomText.TextXAlignment = Enum.TextXAlignment.Center
        uiElements.zoomText.TextYAlignment = Enum.TextYAlignment.Center
        uiElements.zoomText.Parent = buttonContainer
        
        uiElements.zoomInBtn = Instance.new("TextButton")
        uiElements.zoomInBtn.Size = UDim2.new(0, ss(38), 1, 0)
        uiElements.zoomInBtn.Position = UDim2.new(1, -ss(156), 0, 0)
        uiElements.zoomInBtn.BackgroundTransparency = 1
        uiElements.zoomInBtn.Text = "[+]"
        uiElements.zoomInBtn.TextColor3 = Color3.fromRGB(255, 180, 80)
        uiElements.zoomInBtn.TextSize = getFontSize(FONT_SIZES.button)
        uiElements.zoomInBtn.Font = Enum.Font.Code
        uiElements.zoomInBtn.Parent = buttonContainer
        
        uiElements.zoomOutBtn = Instance.new("TextButton")
        uiElements.zoomOutBtn.Size = UDim2.new(0, ss(38), 1, 0)
        uiElements.zoomOutBtn.Position = UDim2.new(1, -ss(204), 0, 0)
        uiElements.zoomOutBtn.BackgroundTransparency = 1
        uiElements.zoomOutBtn.Text = "[-]"
        uiElements.zoomOutBtn.TextColor3 = Color3.fromRGB(255, 180, 80)
        uiElements.zoomOutBtn.TextSize = getFontSize(FONT_SIZES.button)
        uiElements.zoomOutBtn.Font = Enum.Font.Code
        uiElements.zoomOutBtn.Parent = buttonContainer
        
        local userFrame = Instance.new("Frame")
        userFrame.Name = "UserFrame"
        userFrame.Size = UDim2.new(1, -ss(20), 0, ss(64))
        userFrame.Position = UDim2.new(0, ss(10), 0, ss(56))
        userFrame.BackgroundColor3 = Color3.fromRGB(20, 15, 10)
        userFrame.BackgroundTransparency = 0.3
        userFrame.BorderSizePixel = 0
        userFrame.Parent = mf
        
        local function addRivet(parent, x, y)
            local rivet = Instance.new("Frame")
            rivet.Size = UDim2.new(0, ss(8), 0, ss(8))
            rivet.Position = UDim2.new(x, x == 0 and ss(5) or -ss(13), y, y == 0 and ss(5) or -ss(13))
            rivet.BackgroundColor3 = Color3.fromRGB(100, 60, 30)
            rivet.BorderSizePixel = 0
            local rivetCorner = Instance.new("UICorner")
            rivetCorner.CornerRadius = UDim.new(1, 0)
            rivetCorner.Parent = rivet
            rivet.Parent = parent
        end
        
        addRivet(userFrame, 0, 0)
        addRivet(userFrame, 1, 0)
        addRivet(userFrame, 0, 1)
        addRivet(userFrame, 1, 1)
        
        uiElements.userName = Instance.new("TextLabel")
        uiElements.userName.Text = "> 操作员: " .. player.Name
        uiElements.userName.TextColor3 = Color3.fromRGB(220, 170, 100)
        uiElements.userName.TextSize = getFontSize(FONT_SIZES.userName)
        uiElements.userName.Font = Enum.Font.Code
        uiElements.userName.TextXAlignment = Enum.TextXAlignment.Left
        uiElements.userName.TextYAlignment = Enum.TextYAlignment.Center
        uiElements.userName.BackgroundTransparency = 1
        uiElements.userName.Size = UDim2.new(1, -ss(10), 0, ss(28))
        uiElements.userName.Position = UDim2.new(0, ss(8), 0, ss(6))
        uiElements.userName.Parent = userFrame
        
        uiElements.timerLabel = Instance.new("TextLabel")
        uiElements.timerLabel.Text = "[系统运行: " .. getUptimeString() .. "]"
        uiElements.timerLabel.TextColor3 = Color3.fromRGB(180, 140, 80)
        uiElements.timerLabel.TextSize = getFontSize(FONT_SIZES.timer)
        uiElements.timerLabel.Font = Enum.Font.Code
        uiElements.timerLabel.TextXAlignment = Enum.TextXAlignment.Left
        uiElements.timerLabel.TextYAlignment = Enum.TextYAlignment.Center
        uiElements.timerLabel.BackgroundTransparency = 1
        uiElements.timerLabel.Size = UDim2.new(1, -ss(10), 0, ss(26))
        uiElements.timerLabel.Position = UDim2.new(0, ss(8), 0, ss(34))
        uiElements.timerLabel.Parent = userFrame
        timerTextObj = uiElements.timerLabel
        
        local scrollFrame = Instance.new("ScrollingFrame")
        scrollFrame.Name = "ScrollFrame"
        scrollFrame.Size = UDim2.new(1, -ss(20), 0, ss(350))
        scrollFrame.Position = UDim2.new(0, ss(10), 0, ss(128))
        scrollFrame.BackgroundTransparency = 1
        scrollFrame.ScrollBarThickness = ss(4)
        scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(180, 100, 40)
        scrollFrame.CanvasSize = UDim2.new(0, 0, 0, ss(440))
        scrollFrame.Parent = mf
        
        local items = {
            {name = "R6断腿", key = "R6Leg", offColor = Color3.fromRGB(25, 18, 12), onColor = Color3.fromRGB(60, 40, 20)},
            {name = "R15断腿", key = "R15Leg", offColor = Color3.fromRGB(25, 18, 12), onColor = Color3.fromRGB(55, 35, 18)},
            {name = "画质优化", key = "Graphics", offColor = Color3.fromRGB(25, 18, 12), onColor = Color3.fromRGB(55, 35, 18)},
            {name = "隐藏饰品", key = "Hat", offColor = Color3.fromRGB(25, 18, 12), onColor = Color3.fromRGB(55, 35, 18)},
        }
        
        for i, item in ipairs(items) do
            local itemFrame = Instance.new("TextButton")
            itemFrame.Size = UDim2.new(1, 0, 0, ss(64))
            itemFrame.Position = UDim2.new(0, 0, 0, (i - 1) * ss(68))
            itemFrame.BackgroundColor3 = item.offColor
            itemFrame.BackgroundTransparency = 0
            itemFrame.BorderSizePixel = 0
            itemFrame.Text = ""
            itemFrame.AutoButtonColor = false
            itemFrame.Parent = scrollFrame
            table.insert(uiElements.itemFrames, itemFrame)
            
            local itBorder = Instance.new("UIStroke")
            itBorder.Thickness = 1
            itBorder.Color = Color3.fromRGB(180, 100, 40)
            itBorder.Transparency = 0.5
            itBorder.Parent = itemFrame
            
            local nl = Instance.new("TextLabel")
            nl.Name = "ItemName"
            nl.Text = item.name
            nl.TextColor3 = Color3.fromRGB(200, 150, 90)
            nl.TextSize = getFontSize(FONT_SIZES.itemName)
            nl.Font = Enum.Font.Code
            nl.TextXAlignment = Enum.TextXAlignment.Left
            nl.BackgroundTransparency = 1
            nl.Size = UDim2.new(0.65, -ss(10), 1, 0)
            nl.Position = UDim2.new(0, ss(12), 0, 0)
            nl.Parent = itemFrame
            
            local statusIndicator = Instance.new("TextLabel")
            statusIndicator.Name = "StatusIndicator"
            statusIndicator.Text = "[关闭]"
            statusIndicator.TextSize = getFontSize(FONT_SIZES.status)
            statusIndicator.Font = Enum.Font.Code
            statusIndicator.TextColor3 = Color3.fromRGB(150, 80, 50)
            statusIndicator.BackgroundTransparency = 1
            statusIndicator.Size = UDim2.new(0, ss(80), 1, 0)
            statusIndicator.Position = UDim2.new(1, -ss(90), 0, 0)
            statusIndicator.TextXAlignment = Enum.TextXAlignment.Right
            statusIndicator.TextYAlignment = Enum.TextYAlignment.Center
            statusIndicator.Parent = itemFrame
            
            local isOn = false
            
            itemFrame.MouseButton1Click:Connect(function()
                isOn = not isOn
                if isOn then
                    itemFrame.BackgroundColor3 = item.onColor
                    nl.TextColor3 = Color3.fromRGB(255, 200, 120)
                    statusIndicator.Text = "[开启]"
                    statusIndicator.TextColor3 = Color3.fromRGB(255, 180, 80)
                    state[item.key] = true
                else
                    itemFrame.BackgroundColor3 = item.offColor
                    nl.TextColor3 = Color3.fromRGB(200, 150, 90)
                    statusIndicator.Text = "[关闭]"
                    statusIndicator.TextColor3 = Color3.fromRGB(150, 80, 50)
                    state[item.key] = false
                end
                
                if item.key == "R6Leg" then
                    modules.LegEffects.enableR6(isOn)
                elseif item.key == "R15Leg" then
                    modules.LegEffects.enableR15(isOn)
                elseif item.key == "Graphics" then
                    modules.Graphics.enable(isOn)
                elseif item.key == "Hat" then
                    modules.HatHider.enable(isOn)
                end
            end)
            
            itemFrame.MouseEnter:Connect(function()
                if not isOn then itemFrame.BackgroundColor3 = Color3.fromRGB(40, 28, 18) end
            end)
            
            itemFrame.MouseLeave:Connect(function()
                if not isOn then itemFrame.BackgroundColor3 = item.offColor end
            end)
        end
        
        local unloadFrame = Instance.new("Frame")
        unloadFrame.Name = "UnloadFrame"
        unloadFrame.Size = UDim2.new(1, -ss(20), 0, ss(64))
        unloadFrame.Position = UDim2.new(0, ss(10), 0, ss(460))
        unloadFrame.BackgroundColor3 = Color3.fromRGB(45, 20, 15)
        unloadFrame.BackgroundTransparency = 0
        unloadFrame.BorderSizePixel = 0
        unloadFrame.Parent = scrollFrame
        
        local unloadBorder = Instance.new("UIStroke")
        unloadBorder.Thickness = 1
        unloadBorder.Color = Color3.fromRGB(200, 80, 40)
        unloadBorder.Transparency = 0.3
        unloadBorder.Parent = unloadFrame
        
        uiElements.unloadText = Instance.new("TextLabel")
        uiElements.unloadText.Text = "> 卸载脚本"
        uiElements.unloadText.TextColor3 = Color3.fromRGB(255, 120, 60)
        uiElements.unloadText.TextSize = getFontSize(FONT_SIZES.unload)
        uiElements.unloadText.Font = Enum.Font.Code
        uiElements.unloadText.TextXAlignment = Enum.TextXAlignment.Left
        uiElements.unloadText.TextYAlignment = Enum.TextYAlignment.Center
        uiElements.unloadText.BackgroundTransparency = 1
        uiElements.unloadText.Size = UDim2.new(1, -ss(15), 0, ss(32))
        uiElements.unloadText.Position = UDim2.new(0, ss(12), 0, ss(10))
        uiElements.unloadText.Parent = unloadFrame
        
        uiElements.unloadTip = Instance.new("TextLabel")
        uiElements.unloadTip.Text = "关闭所有功能并删除脚本"
        uiElements.unloadTip.TextColor3 = Color3.fromRGB(150, 70, 40)
        uiElements.unloadTip.TextSize = getFontSize(FONT_SIZES.unloadTip)
        uiElements.unloadTip.Font = Enum.Font.Code
        uiElements.unloadTip.TextXAlignment = Enum.TextXAlignment.Left
        uiElements.unloadTip.TextYAlignment = Enum.TextYAlignment.Center
        uiElements.unloadTip.BackgroundTransparency = 1
        uiElements.unloadTip.Size = UDim2.new(1, -ss(15), 0, ss(22))
        uiElements.unloadTip.Position = UDim2.new(0, ss(12), 1, -ss(20))
        uiElements.unloadTip.Parent = unloadFrame
        
        local unloadButton = Instance.new("TextButton")
        unloadButton.Size = UDim2.new(1, 0, 1, 0)
        unloadButton.BackgroundTransparency = 1
        unloadButton.Text = ""
        unloadButton.Parent = unloadFrame
        
        unloadButton.MouseButton1Click:Connect(function()
            if state.R6Leg then modules.LegEffects.enableR6(false) end
            if state.R15Leg then modules.LegEffects.enableR15(false) end
            if state.Graphics then modules.Graphics.enable(false) end
            if state.Hat then modules.HatHider.enable(false) end
            
            local c = player.Character
            if c then
                local head = c:FindFirstChild("Head")
                if head then
                    head.Transparency = 0
                    head.CanCollide = true
                end
                local legParts = {"RightUpperLeg", "RightLowerLeg", "RightFoot", "LeftUpperLeg", "LeftLowerLeg", "LeftFoot", "Right Leg", "Left Leg"}
                for _, partName in ipairs(legParts) do
                    local part = c:FindFirstChild(partName)
                    if part then
                        part.Transparency = 0
                        part.Material = Enum.Material.SmoothPlastic
                    end
                end
            end
            
            isUnloaded = true
            screenGui:Destroy()
            local perfParent = player.PlayerGui:FindFirstChild("WastelandPerfMonitor")
            if perfParent then perfParent:Destroy() end
        end)
        
        unloadFrame.MouseEnter:Connect(function() unloadFrame.BackgroundColor3 = Color3.fromRGB(80, 35, 25) end)
        unloadFrame.MouseLeave:Connect(function() unloadFrame.BackgroundColor3 = Color3.fromRGB(45, 20, 15) end)
        
        local footer = Instance.new("Frame")
        footer.Name = "Footer"
        footer.Size = UDim2.new(1, -ss(20), 0, ss(32))
        footer.Position = UDim2.new(0, ss(10), 1, -ss(36))
        footer.BackgroundColor3 = Color3.fromRGB(20, 15, 10)
        footer.BackgroundTransparency = 0.3
        footer.BorderSizePixel = 0
        footer.Parent = mf
        
        uiElements.footerText = Instance.new("TextLabel")
        uiElements.footerText.Text = "> Reming V2.1 <"
        uiElements.footerText.TextColor3 = Color3.fromRGB(150, 100, 60)
        uiElements.footerText.TextSize = getFontSize(FONT_SIZES.footer)
        uiElements.footerText.Font = Enum.Font.Code
        uiElements.footerText.TextXAlignment = Enum.TextXAlignment.Center
        uiElements.footerText.TextYAlignment = Enum.TextYAlignment.Center
        uiElements.footerText.BackgroundTransparency = 1
        uiElements.footerText.Size = UDim2.new(1, -ss(10), 1, 0)
        uiElements.footerText.Position = UDim2.new(0, ss(5), 0, 0)
        uiElements.footerText.Parent = footer
        
        local flickerChars = {"█", "▒", "░", " "}
        uiElements.flickerText = Instance.new("TextLabel")
        uiElements.flickerText.Size = UDim2.new(0, ss(30), 0, ss(22))
        uiElements.flickerText.Position = UDim2.new(0.5, ss(20), 0, ss(10))
        uiElements.flickerText.BackgroundTransparency = 1
        uiElements.flickerText.Text = "▒"
        uiElements.flickerText.TextColor3 = Color3.fromRGB(180, 100, 40)
        uiElements.flickerText.TextSize = getFontSize(FONT_SIZES.flicker)
        uiElements.flickerText.Font = Enum.Font.Code
        uiElements.flickerText.Parent = mf
        
        task.spawn(function()
            while mf and mf.Parent do
                task.wait(0.2)
                if uiElements.flickerText and uiElements.flickerText.Parent then
                    uiElements.flickerText.Text = flickerChars[math.random(1, #flickerChars)]
                end
            end
        end)
        
        uiElements.zoomInBtn.MouseButton1Click:Connect(function()
            zoomMenu(0.1)
        end)
        
        uiElements.zoomOutBtn.MouseButton1Click:Connect(function()
            zoomMenu(-0.1)
        end)
        
        task.spawn(function()
            while mf and mf.Parent do
                task.wait(1)
                if timerTextObj and timerTextObj.Parent then
                    timerTextObj.Text = "[系统运行: " .. getUptimeString() .. "]"
                end
            end
        end)
        
        workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
            updateAllUI()
        end)
        
        return mf
    end
    
    menuFrame = buildMenu()
    
    return {
        show = showMenu,
        hide = hideMenu,
        isVisible = function() return menuFrame and menuFrame.Visible end,
        setMinButtonCallback = function(callback)
            if minButton then
                minButton.MouseButton1Click:Connect(callback)
            end
        end,
        isUnloaded = function() return isUnloaded end,
        setUnloaded = function(val) isUnloaded = val end
    }
end

return Menu