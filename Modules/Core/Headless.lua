local Headless={active=true,player=nil}
local Finder=require(script.Parent.Parent.Utils.Finder)
function Headless.init(plr)
    Headless.player=plr
    task.spawn(function()
        while Headless.active do
            task.wait(1)
            local c=Headless.player.Character
            if c then
                local head=Finder.find(c,'Head')
                if head and head.Transparency~=1 then
                    head.Transparency=1
                    head.CanCollide=false
                    head.Massless=true
                end
                local face=Finder.find(c,'Face')
                if face then face:Destroy()end
            end
        end
    end)
end
function Headless.enable(bool)
    Headless.active=bool
    local c=Headless.player.Character
    if c then
        local head=Finder.find(c,'Head')
        if head then
            head.Transparency=1
            head.CanCollide=false
        end
        local face=Finder.find(c,'Face')
        if face then face:Destroy()end
    end
end
return Headless