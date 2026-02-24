local Graphics = {active = false, materials = {}}

function Graphics.enable(bool)
    Graphics.active = bool
    if bool then
        pcall(function()
            local L = game:GetService("Lighting")
            L.GlobalShadows = false
            L.FogEnabled = false
            for _, v in L:GetChildren() do
                if v:IsA("PostEffect") then v.Enabled = false end
            end
        end)
        pcall(function()
            local U = game:GetService("UserSettings")
            local u = U:GetService("UserGameSettings")
            u.GraphicsQuality = Enum.GraphicsQuality.Level01
            u.RenderScale = 0.2
            u.Shadows = false
            u.TextureQuality = Enum.TextureQuality.Level01
        end)
        for _, o in ipairs(workspace:GetDescendants()) do
            pcall(function()
                if o:IsA("BasePart") and o.Parent ~= game:GetService("Players").LocalPlayer.Character then
                    if not Graphics.materials[o] then Graphics.materials[o] = o.Material end
                    o.Material = Enum.Material.Plastic
                end
                if o:IsA("Texture") or o:IsA("Decal") then o:Destroy() end
                if o:IsA("ParticleEmitter") or o:IsA("Trail") or o:IsA("Beam") then o:Destroy() end
            end)
        end
    else
        pcall(function()
            local L = game:GetService("Lighting")
            L.GlobalShadows = true
            L.FogEnabled = true
        end)
        pcall(function()
            local U = game:GetService("UserSettings")
            local u = U:GetService("UserGameSettings")
            u.GraphicsQuality = Enum.GraphicsQuality.Automatic
            u.RenderScale = 1
            u.Shadows = true
            u.TextureQuality = Enum.TextureQuality.Automatic
        end)
        for o, m in pairs(Graphics.materials) do
            pcall(function() if o and o.Parent then o.Material = m end end)
        end
        Graphics.materials = {}
    end
end

return Graphics