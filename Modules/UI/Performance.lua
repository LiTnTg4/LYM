local Performance={gui=nil,text=nil,fc=0,lu=0,callback=nil}
function Performance.init(player,runService)
    local pg=player:WaitForChild"PlayerGui"
    Performance.gui=Instance.new"ScreenGui"
    Performance.gui.Name="PerfMonitor"
    Performance.gui.IgnoreGuiInset=true
    Performance.gui.DisplayOrder=999
    Performance.gui.ResetOnSpawn=false
    Performance.gui.Parent=pg
    Performance.text=Instance.new"TextButton"
    Performance.text.Name="PerfText"
    Performance.text.Size=UDim2.new(0,200,0,20)
    Performance.text.Position=UDim2.new(0.5,-100,0.5,182)
    Performance.text.BackgroundColor3=Color3.fromRGB(0,0,0)
    Performance.text.BackgroundTransparency=0.3
    Performance.text.BorderSizePixel=0
    Performance.text.Text="FPS: 119 | Ping: 88ms"
    Performance.text.TextColor3=Color3.fromRGB(255,255,255)
    Performance.text.TextSize=16
    Performance.text.Font=Enum.Font.GothamBold
    Performance.text.Active=true
    Performance.text.Draggable=true
    Performance.text.Visible=true
    Performance.text.Parent=Performance.gui
    runService.RenderStepped:Connect(function()
        local t=os.clock()
        if t-Performance.lu>=1 then
            local fps=math.floor(Performance.fc/(t-Performance.lu))
            local ping=0
            pcall(function()ping=math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue())end)
            Performance.text.Text=string.format("FPS: %d | Ping: %dms",fps,ping)
            Performance.fc=0
            Performance.lu=t
        end
        Performance.fc=Performance.fc+1
    end)
    if Performance.callback then
        Performance.text.MouseButton1Click:Connect(Performance.callback)
    end
end
function Performance.show()
    if Performance.text then Performance.text.Visible=true end
end
function Performance.hide()
    if Performance.text then Performance.text.Visible=false end
end
function Performance.setClickCallback(cb)
    Performance.callback=cb
    if Performance.text then
        Performance.text.MouseButton1Click:Connect(cb)
    end
end
return Performance