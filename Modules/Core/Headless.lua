local Headless = {active = true, player = nil}

function Headless.init(plr)
    Headless.player = plr
    task.spawn(function()
        while Headless.active do
            task.wait(1)
            local c = Headless.player.Character
            if c then
                local head = _G.f(c, "Head")
                if head and head.Transparency ~= 1 then
                    head.Transparency = 1
                    head.CanCollide = false
                    head.Massless = true
                end
                local face = _G.f(c, "Face")
                if face then face:Destroy() end
            end
        end
    end)
end

function Headless.enable(bool)
    Headless.active = bool
    local c = Headless.player.Character
    if c then
        local head = _G.f(c, "Head")
        if head then
            head.Transparency = 1
            head.CanCollide = false
        end
        local face = _G.f(c, "Face")
        if face then face:Destroy() end
    end
end

return Headless