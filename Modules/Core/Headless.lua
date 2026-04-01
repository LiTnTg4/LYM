local Headless = {}

function Headless.init(player)
    Headless.player = player
    Headless.isUnloaded = false
end

function Headless.enable(bool)
    if bool and not Headless.isUnloaded then
        local c = Headless.player.Character
        if c then
            local head = c:FindFirstChild("Head")
            if head then
                head.Transparency = 1
                head.CanCollide = false
            end
            local face = c:FindFirstChild("Face")
            if face then face:Destroy() end
        end
    end
end

function Headless.startLoop()
    task.spawn(function()
        while not Headless.isUnloaded do
            task.wait(1)
            local c = Headless.player.Character
            if c then
                local head = c:FindFirstChild("Head")
                if head and head.Transparency ~= 1 then
                    head.Transparency = 1
                end
            end
        end
    end)
end

function Headless.stop()
    Headless.isUnloaded = true
    local c = Headless.player.Character
    if c then
        local head = c:FindFirstChild("Head")
        if head then
            head.Transparency = 0
            head.CanCollide = true
        end
    end
end

return Headless