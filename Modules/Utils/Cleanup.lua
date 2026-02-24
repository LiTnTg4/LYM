local Cleanup={lastClean=0,conn=nil}
function Cleanup.init(RunService,State)
    Cleanup.conn=RunService.Heartbeat:Connect(function()
        if State.Graphics then
            local t=tick()
            if t-Cleanup.lastClean>=5 then
                pcall(function()
                    for _,o in ipairs(workspace:GetDescendants())do
                        if o:IsA"ParticleEmitter"or o:IsA"Trail"or o:IsA"Beam"then o:Destroy()end
                    end
                end)
                Cleanup.lastClean=t
            end
        end
    end)
end
return Cleanup