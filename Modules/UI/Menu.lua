local Menu = {frame = nil, state = nil, modules = nil, minCallback = nil}

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

function Menu.init(player, state, modules, tweenService)
    Menu.state = state
    Menu.modules = modules
    
    local startTime = os.time()
    local menuSize = 1.0
    local minSize = 0.6
    local maxSize = 1.8
    local isMenuVisible = false
    local currentAnim = nil
    local menuFrame = nil
    local originalSize = nil
    local originalPosition = nil
    local originalTransparency = nil
    local savedMenuPosition = nil
    local timerTextObj = nil
    local scanline = nil
    
    local function getBaseScale()
        local viewportSize = workspace.CurrentCamera.ViewportSize
        return math.min(1.5, math.max(0.8, viewportSize.Y / 1080))
    end
    
    local function getScale()
        return getBaseScale() * menuSize
    end
    
    local function ss(value)
        return math.floor(value * getScale())
    end
    
    local function getUptimeString()
        local elapsed = os.time() - startTime
        return formatTime(elapsed)
    end
    
    local function animateShow()
        if not menuFrame then return end
        if currentAnim then currentAnim:Cancel() end
        
        menuFrame.Visible = true
        isMenuVisible = true
        
        local targetSize = originalSize
        local targetPosition = savedMenuPosition or originalPosition
        local targetTransparency = originalTransparency
        
        menuFrame.Size = UDim2.new(targetSize.X.Scale, targetSize.X.Offset * 0.7, targetSize.Y.Scale, targetSize.Y.Offset * 0.7)
        menuFrame.Position = UDim2.new(targetPosition.X.Scale, targetPosition.X.Offset + (targetSize.X.Offset * 0.15), targetPosition.Y.Scale, targetPosition.Y.Offset + (targetSize.Y.Offset * 0.15))
        menuFrame.BackgroundTransparency = 0.5
        
        local tweenInfo = TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        local sizeTween = tweenService:Create(menuFrame, tweenInfo, {Size = targetSize})
        local posTween = tweenService:Create(menuFrame, tweenInfo, {Position = targetPosition})
        local transTween = tweenService:Create(menuFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = targetTransparency})
        
        sizeTween:Play()
        posTween:Play()
        transTween:Play()
        
        currentAnim = sizeTween
    end
    
    local function animateHide(callback)
        if not menuFrame then return end
        if currentAnim then currentAnim:Cancel() end
        
        savedMenuPosition = menuFrame.Position
        
        local targetSize = UDim2.new(originalSize.X.Scale, originalSize.X.Offset * 0.7, originalSize.Y.Scale, originalSize.Y.Offset * 0.7)
        local targetPosition = UDim2.new(originalPosition.X.Scale, originalPosition.X.Offset + (originalSize.X.Offset * 0.15), originalPosition.Y.Scale, originalPosition.Y.Offset + (originalSize.Y.Offset * 0.15))
        
        local tweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        local sizeTween = tweenService:Create(menuFrame, tweenInfo, {Size = targetSize})
        local posTween = tweenService:Create(menuFrame, tweenInfo, {Position = targetPosition})
        local transTween = tweenService:Create(menuFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0.5})
        
        sizeTween:Play()
        posTween:Play()
        transTween:Play()
        
        sizeTween.Completed:Connect(function()
            menuFrame.Visible = false
            isMenuVisible = false
            menuFrame.Size = originalSize
            menuFrame.Position = savedMenuPosition or originalPosition
            menuFrame.BackgroundTransparency = originalTransparency
            if callback then callback() end
        end)
        
        currentAnim = sizeTween
    end
    
    local function buildMenu()
        local s = getScale()
        
        local pg = player:WaitForChild("PlayerGui")
        local r = Instance.new("ScreenGui")
        r.Name = "RE_Menu"
        r.IgnoreGuiInset = true
        r.ResetOnSpawn = false
        r.DisplayOrder = 100
        r.Parent = pg
        
        local mf = Instance.new("Frame")
        mf.Size = UDim2.new(0, ss(550), 0, ss(820))
        mf.Position = savedMenuPosition or UDim2.new(0.5, -ss(275), 0.5, -ss(410))
        mf.BackgroundColor3 = Color3.fromRGB(15, 12, 8)
        mf.BackgroundTransparency = 0.05
        mf.Active = true
        mf.Draggable = true
        mf.Visible = false
        mf.Parent = r
        Menu.frame = mf
        
        mf:GetPropertyChangedSignal("Position"):Connect(function()
            if mf.Visible then savedMenuPosition = mf.Position end
        end)
        
        originalSize = mf.Size
        originalPosition = mf.Position
        originalTransparency = mf.BackgroundTransparency
        
        local mainBorder = Instance.new("UIStroke")
        mainBorder.Thickness = 4
        mainBorder.Color = Color3.fromRGB(180, 100, 40)
        mainBorder.Transparency = 0.2
        mainBorder.Parent = mf
        
        scanline = Instance.new("Frame")
        scanline.Size = UDim2.new(1, 0, 0, 3)
        scanline.Position = UDim2.new(0, 0, 0, 0)
        scanline.BackgroundColor3 = Color3.fromRGB(255, 180, 80)
        scanline.BackgroundTransparency = 0.7
        scanline.BorderSizePixel = 0
        scanline.Parent = mf
        
        task.spawn(function()
            local y = 0
            while mf and mf.Parent do
                task.wait(0.03)
                y = y + ss(6)
                if y > ss(820) then y = 0 end
                if scanline then scanline.Position = UDim2.new(0, 0, 0, y) end
            end
        end)
        
        local function addWastelandCorner(parent, x, y)
            local cornerGroup = Instance.new("Frame")
            cornerGroup.Size = UDim2.new(0, ss(28), 0, ss(28))
            cornerGroup.Position = UDim2.new(x, x == 0 and 0 or -ss(28), y, y == 0 and 0 or -ss(28))
            cornerGroup.BackgroundTransparency = 1
            cornerGroup.Parent = parent
            
            local line1 = Instance.new("Frame")
            line1.Size = UDim2.new(0, ss(22), 0, 3)
            line1.Position = UDim2.new(0, x == 0 and 0 or -ss(22), 0, y == 0 and 0 or ss(25))
            line1.BackgroundColor3 = Color3.fromRGB(180, 100, 40)
            line1.BackgroundTransparency = 0.4
            line1.BorderSizePixel = 0
            line1.Parent = cornerGroup
            
            local line2 = Instance.new("Frame")
            line2.Size = UDim2.new(0, 3, 0, ss(22))
            line2.Position = UDim2.new(0, x == 0 and ss(25) or -ss(28), 0, y == 0 and 0 or -ss(22))
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
        titleBar.Size = UDim2.new(1, 0, 0, ss(72))
        titleBar.BackgroundColor3 = Color3.fromRGB(25, 18, 12)
        titleBar.BackgroundTransparency = 0.2
        titleBar.BorderSizePixel = 0
        titleBar.Parent = mf
        
        local titleText = Instance.new("TextLabel")
        titleText.Size = UDim2.new(0.5, -ss(15), 1, 0)
        titleText.Position = UDim2.new(0, ss(18), 0, 0)
        titleText.BackgroundTransparency = 1
        titleText.Text = "废土终端 v1.0"
        titleText.TextColor3 = Color3.fromRGB(255, 180, 80)
        titleText.TextSize = ss(28)
        titleText.Font = Enum.Font.Code
        titleText.TextXAlignment = Enum.TextXAlignment.Left
        titleText.TextYAlignment = Enum.TextYAlignment.Center
        titleText.Parent = titleBar
        
        local buttonContainer = Instance.new("Frame")
        buttonContainer.Size = UDim2.new(0, ss(190), 1, 0)
        buttonContainer.Position = UDim2.new(1, -ss(200), 0, 0)
        buttonContainer.BackgroundTransparency = 1
        buttonContainer.Parent = titleBar
        
        local minButton = Instance.new("TextButton")
        minButton.Size = UDim2.new(0, ss(52), 1, 0)
        minButton.Position = UDim2.new(1, -ss(52), 0, 0)
        minButton.BackgroundTransparency = 1
        minButton.Text = "[-]"
        minButton.TextColor3 = Color3.fromRGB(255, 180, 80)
        minButton.TextSize = ss(26)
        minButton.Font = Enum.Font.Code
        minButton.Parent = buttonContainer
        
        local zoomText = Instance.new("TextLabel")
        zoomText.Size = UDim2.new(0, ss(90), 1, 0)
        zoomText.Position = UDim2.new(1, -ss(152), 0, 0)
        zoomText.BackgroundTransparency = 1
        zoomText.Text = string.format("%.0f%%", menuSize * 100)
        zoomText.TextColor3 = Color3.fromRGB(200, 150, 80)
        zoomText.TextSize = ss(20)
        zoomText.Font = Enum.Font.Code
        zoomText.TextXAlignment = Enum.TextXAlignment.Center
        zoomText.TextYAlignment = Enum.TextYAlignment.Center
        zoomText.Parent = buttonContainer
        
        local zoomInBtn = Instance.new("TextButton")
        zoomInBtn.Size = UDim2.new(0, ss(52), 1, 0)
        zoomInBtn.Position = UDim2.new(1, -ss(214), 0, 0)
        zoomInBtn.BackgroundTransparency = 1
        zoomInBtn.Text = "[+]"
        zoomInBtn.TextColor3 = Color3.fromRGB(255, 180, 80)
        zoomInBtn.TextSize = ss(26)
        zoomInBtn.Font = Enum.Font.Code
        zoomInBtn.Parent = buttonContainer
        
        local zoomOutBtn = Instance.new("TextButton")
        zoomOutBtn.Size = UDim2.new(0, ss(52), 1, 0)
        zoomOutBtn.Position = UDim2.new(1, -ss(266), 0, 0)
        zoomOutBtn.BackgroundTransparency = 1
        zoomOutBtn.Text = "[-]"
        zoomOutBtn.TextColor3 = Color3.fromRGB(255, 180, 80)
        zoomOutBtn.TextSize = ss(26)
        zoomOutBtn.Font = Enum.Font.Code
        zoomOutBtn.Parent = buttonContainer
        
        local userFrame = Instance.new("Frame")
        userFrame.Size = UDim2.new(1, -ss(30), 0, ss(96))
        userFrame.Position = UDim2.new(0, ss(15), 0, ss(80))
        userFrame.BackgroundColor3 = Color3.fromRGB(20, 15, 10)
        userFrame.BackgroundTransparency = 0.3
        userFrame.BorderSizePixel = 0
        userFrame.Parent = mf
        
        local function addRivet(parent, x, y)
            local rivet = Instance.new("Frame")
            rivet.Size = UDim2.new(0, ss(12), 0, ss(12))
            rivet.Position = UDim2.new(x, x == 0 and ss(8) or -ss(20), y, y == 0 and ss(8) or -ss(20))
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
        
        local userName = Instance.new("TextLabel")
        userName.Size = UDim2.new(1, -ss(15), 0, ss(40))
        userName.Position = UDim2.new(0, ss(12), 0, ss(12))
        userName.BackgroundTransparency = 1
        userName.Text = "> 操作员: " .. player.Name
        userName.TextColor3 = Color3.fromRGB(220, 170, 100)
        userName.TextSize = ss(24)
        userName.Font = Enum.Font.Code
        userName.TextXAlignment = Enum.TextXAlignment.Left
        userName.TextYAlignment = Enum.TextYAlignment.Center
        userName.Parent = userFrame
        
        local timerLabel = Instance.new("TextLabel")
        timerLabel.Size = UDim2.new(1, -ss(15), 0, ss(36))
        timerLabel.Position = UDim2.new(0, ss(12), 0, ss(52))
        timerLabel.BackgroundTransparency = 1
        timerLabel.Text = "[系统运行: " .. getUptimeString() .. "]"
        timerLabel.TextColor3 = Color3.fromRGB(180, 140, 80)
        timerLabel.TextSize = ss(20)
        timerLabel.Font = Enum.Font.Code
        timerLabel.TextXAlignment = Enum.TextXAlignment.Left
        timerLabel.TextYAlignment = Enum.TextYAlignment.Center
        timerLabel.Parent = userFrame
        timerTextObj = timerLabel
        
        local scrollFrame = Instance.new("ScrollingFrame")
        scrollFrame.Size = UDim2.new(1, -ss(30), 0, ss(500))
        scrollFrame.Position = UDim2.new(0, ss(15), 0, ss(184))
        scrollFrame.BackgroundTransparency = 1
        scrollFrame.ScrollBarThickness = ss(6)
        scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(180, 100, 40)
        scrollFrame.CanvasSize = UDim2.new(0, 0, 0, ss(720))
        scrollFrame.Parent = mf
        
        local items = {
            {name = "R6断腿", key = "R6Leg", offColor = Color3.fromRGB(25, 18, 12), onColor = Color3.fromRGB(60, 40, 20)},
            {name = "R15断腿", key = "R15Leg", offColor = Color3.fromRGB(25, 18, 12), onColor = Color3.fromRGB(55, 35, 18)},
            {name = "画质优化", key = "Graphics", offColor = Color3.fromRGB(25, 18, 12), onColor = Color3.fromRGB(55, 35, 18)},
            {name = "隐藏饰品", key = "Hat", offColor = Color3.fromRGB(25, 18, 12), onColor = Color3.fromRGB(55, 35, 18)},
        }
        
        for i, item in ipairs(items) do
            local itemFrame = Instance.new("TextButton")
            itemFrame.Size = UDim2.new(1, 0, 0, ss(96))
            itemFrame.Position = UDim2.new(0, 0, 0, (i - 1) * ss(100))
            itemFrame.BackgroundColor3 = item.offColor
            itemFrame.BackgroundTransparency = 0
            itemFrame.BorderSizePixel = 0
            itemFrame.Text = ""
            itemFrame.AutoButtonColor = false
            itemFrame.Parent = scrollFrame
            
            local itBorder = Instance.new("UIStroke")
            itBorder.Thickness = 2
            itBorder.Color = Color3.fromRGB(180, 100, 40)
            itBorder.Transparency = 0.5
            itBorder.Parent = itemFrame
            
            local nl = Instance.new("TextLabel")
            nl.Text = item.name
            nl.TextColor3 = Color3.fromRGB(200, 150, 90)
            nl.TextSize = ss(28)
            nl.Font = Enum.Font.Code
            nl.TextXAlignment = Enum.TextXAlignment.Left
            nl.BackgroundTransparency = 1
            nl.Size = UDim2.new(0.65, -ss(15), 1, 0)
            nl.Position = UDim2.new(0, ss(20), 0, 0)
            nl.Parent = itemFrame
            
            local statusIndicator = Instance.new("TextLabel")
            statusIndicator.Text = "[关闭]"
            statusIndicator.TextSize = ss(24)
            statusIndicator.Font = Enum.Font.Code
            statusIndicator.TextColor3 = Color3.fromRGB(150, 80, 50)
            statusIndicator.BackgroundTransparency = 1
            statusIndicator.Size = UDim2.new(0, ss(120), 1, 0)
            statusIndicator.Position = UDim2.new(1, -ss(130), 0, 0)
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
                else
                    itemFrame.BackgroundColor3 = item.offColor
                    nl.TextColor3 = Color3.fromRGB(200, 150, 90)
                    statusIndicator.Text = "[关闭]"
                    statusIndicator.TextColor3 = Color3.fromRGB(150, 80, 50)
                end
                Menu.state[item.key] = isOn
                if item.key == "R6Leg" then
                    modules.LegEffects.enableR6(isOn, player)
                elseif item.key == "R15Leg" then
                    modules.LegEffects.enableR15(isOn, player)
                elseif item.key == "Graphics" then
                    modules.Graphics.enable(isOn)
                elseif item.key == "Hat" then
                    modules.HatHider.enable(isOn, player)
                end
            end)
            
            itemFrame.MouseEnter:Connect(function()
                if not isOn then itemFrame.BackgroundColor3 = Color3.fromRGB(40, 28, 18) end
            end)
            
            itemFrame.MouseLeave:Connect(function()
                if not isOn then itemFrame.BackgroundColor3 = item.offColor end
            end)
        end
        
        local unloadFrame = Instance.new("TextButton")
        unloadFrame.Size = UDim2.new(1, -ss(30), 0, ss(96))
        unloadFrame.Position = UDim2.new(0, ss(15), 0, ss(660))
        unloadFrame.BackgroundColor3 = Color3.fromRGB(45, 20, 15)
        unloadFrame.BackgroundTransparency = 0
        unloadFrame.BorderSizePixel = 0
        unloadFrame.Text = ""
        unloadFrame.AutoButtonColor = false
        unloadFrame.Parent = scrollFrame
        
        local unloadBorder = Instance.new("UIStroke")
        unloadBorder.Thickness = 2
        unloadBorder.Color = Color3.fromRGB(200, 80, 40)
        unloadBorder.Transparency = 0.3
        unloadBorder.Parent = unloadFrame
        
        local unloadText = Instance.new("TextLabel")
        unloadText.Size = UDim2.new(1, -ss(20), 0, ss(48))
        unloadText.Position = UDim2.new(0, ss(18), 0, ss(16))
        unloadText.BackgroundTransparency = 1
        unloadText.Text = "> 卸载脚本"
        unloadText.TextColor3 = Color3.fromRGB(255, 120, 60)
        unloadText.TextSize = ss(28)
        unloadText.Font = Enum.Font.Code
        unloadText.TextXAlignment = Enum.TextXAlignment.Left
        unloadText.TextYAlignment = Enum.TextYAlignment.Center
        unloadText.Parent = unloadFrame
        
        local unloadTip = Instance.new("TextLabel")
        unloadTip.Size = UDim2.new(1, -ss(20), 0, ss(30))
        unloadTip.Position = UDim2.new(0, ss(18), 1, -ss(28))
        unloadTip.BackgroundTransparency = 1
        unloadTip.Text = "关闭所有功能并删除脚本"
        unloadTip.TextColor3 = Color3.fromRGB(150, 70, 40)
        unloadTip.TextSize = ss(16)
        unloadTip.Font = Enum.Font.Code
        unloadTip.TextXAlignment = Enum.TextXAlignment.Left
        unloadTip.Parent = unloadFrame
        
        unloadFrame.MouseButton1Click:Connect(function()
            if modules and modules.LegEffects then
                if Menu.state.R6Leg then pcall(function() modules.LegEffects.enableR6(false, player) end) end
                if Menu.state.R15Leg then pcall(function() modules.LegEffects.enableR15(false, player) end) end
            end
            if Menu.state.Graphics then pcall(function() modules.Graphics.enable(false) end) end
            if Menu.state.Hat then pcall(function() modules.HatHider.enable(false, player) end) end
            task.wait(0.5)
            local c = player.Character
            if c then
                local head = c:FindFirstChild("Head")
                if head then head.Transparency = 0; head.CanCollide = true end
                local legParts = {"RightUpperLeg", "RightLowerLeg", "RightFoot", "LeftUpperLeg", "LeftLowerLeg", "LeftFoot", "Right Leg", "Left Leg"}
                for _, partName in ipairs(legParts) do
                    local part = c:FindFirstChild(partName)
                    if part then part.Transparency = 0; part.Material = Enum.Material.SmoothPlastic end
                end
            end
            for _, gui in ipairs(player.PlayerGui:GetChildren()) do
                if gui.Name == "RE_Menu" or gui.Name == "WastelandPerfMonitor" then
                    gui:Destroy()
                end
            end
            local hint = Instance.new("Hint")
            hint.Text = "✅ 脚本已卸载"
            hint.Parent = workspace
            task.delay(3, function() if hint and hint.Parent then hint:Destroy() end end)
        end)
        
        unloadFrame.MouseEnter:Connect(function() unloadFrame.BackgroundColor3 = Color3.fromRGB(80, 35, 25) end)
        unloadFrame.MouseLeave:Connect(function() unloadFrame.BackgroundColor3 = Color3.fromRGB(45, 20, 15) end)
        
        local footer = Instance.new("Frame")
        footer.Size = UDim2.new(1, -ss(30), 0, ss(48))
        footer.Position = UDim2.new(0, ss(15), 1, -ss(54))
        footer.BackgroundColor3 = Color3.fromRGB(20, 15, 10)
        footer.BackgroundTransparency = 0.3
        footer.BorderSizePixel = 0
        footer.Parent = mf
        
        local footerText = Instance.new("TextLabel")
        footerText.Size = UDim2.new(1, -ss(15), 1, 0)
        footerText.Position = UDim2.new(0, ss(8), 0, 0)
        footerText.BackgroundTransparency = 1
        footerText.Text = "> 废土终端模式 <"
        footerText.TextColor3 = Color3.fromRGB(150, 100, 60)
        footerText.TextSize = ss(16)
        footerText.Font = Enum.Font.Code
        footerText.TextXAlignment = Enum.TextXAlignment.Center
        footerText.Parent = footer
        
        local flickerChars = {"█", "▒", "░", " "}
        local flickerText = Instance.new("TextLabel")
        flickerText.Size = UDim2.new(0, ss(50), 0, ss(32))
        flickerText.Position = UDim2.new(0.5, ss(30), 0, ss(15))
        flickerText.BackgroundTransparency = 1
        flickerText.Text = "▒"
        flickerText.TextColor3 = Color3.fromRGB(180, 100, 40)
        flickerText.TextSize = ss(20)
        flickerText.Font = Enum.Font.Code
        flickerText.Parent = mf
        
        task.spawn(function()
            while mf and mf.Parent do
                task.wait(0.2)
                if flickerText and flickerText.Parent then
                    flickerText.Text = flickerChars[math.random(1, #flickerChars)]
                end
            end
        end)
        
        local function updateMenuSize()
            if not menuFrame then return end
            local wasVisible = menuFrame.Visible
            local savedPos = savedMenuPosition
            menuFrame:Destroy()
            menuFrame = buildMenu()
            originalSize = menuFrame.Size
            originalPosition = menuFrame.Position
            originalTransparency = menuFrame.BackgroundTransparency
            if wasVisible then menuFrame.Visible = true end
            if savedPos then savedMenuPosition = savedPos; menuFrame.Position = savedPos end
        end
        
        zoomInBtn.MouseButton1Click:Connect(function()
            if menuSize < maxSize then
                menuSize = math.min(maxSize, menuSize + 0.1)
                zoomText.Text = string.format("%.0f%%", menuSize * 100)
                updateMenuSize()
            end
        end)
        
        zoomOutBtn.MouseButton1Click:Connect(function()
            if menuSize > minSize then
                menuSize = math.max(minSize, menuSize - 0.1)
                zoomText.Text = string.format("%.0f%%", menuSize * 100)
                updateMenuSize()
            end
        end)
        
        task.spawn(function()
            while r.Parent do
                task.wait(1)
                if timerTextObj and timerTextObj.Parent then
                    timerTextObj.Text = "[系统运行: " .. getUptimeString() .. "]"
                end
            end
        end)
        
        workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
            updateMenuSize()
        end)
        
        return {mf = mf, minButton = minButton}
    end
    
    local built = buildMenu()
    menuFrame = built.mf
    
    return {
        show = function() if menuFrame and not menuFrame.Visible then animateShow() end end,
        hide = function(callback) if menuFrame and menuFrame.Visible then animateHide(callback) end end,
        getFrame = function() return menuFrame end,
        setMinCallback = function(cb)
            if built.minButton then
                built.minButton.MouseButton1Click:Connect(cb)
            end
        end
    }
end

return Menu