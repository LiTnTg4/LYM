local Headless = {}

function Headless.init(player, isUnloadedRef)
    Headless.player = player
    Headless.isUnloaded = isUnloadedRef or function() return false end
end

function Headless.enable(bool)
    if bool and not Headless.isUnloaded() then
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
        while not Headless.isUnloaded() do
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

function Headless.applyToCharacter(character)
    if not Headless.isUnloaded() then
        local head = character:FindFirstChild("Head")
        if head then
            head.Transparency = 1
            head.CanCollide = false
        end
    end
end

return Headless