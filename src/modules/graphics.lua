-- 画质优化模块

local Players = game:GetService("Players")
local player = Players.LocalPlayer

local GraphicsOptimizer = {}
GraphicsOptimizer.__index = GraphicsOptimizer

function GraphicsOptimizer.new(state)
    local self = setmetatable({}, GraphicsOptimizer)
    self.state = state
    self.graphicsMaterials = {}
    return self
end

function GraphicsOptimizer:enable(bool)
    self.state.functionState.graphics = bool
    
    if bool then
        self:optimizeGraphics()
    else
        self:restoreGraphics()
    end
end

function GraphicsOptimizer:optimizeGraphics()
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
    
    self.graphicsMaterials = {}
    for _, o in ipairs(workspace:GetDescendants()) do
        pcall(function()
            if o:IsA("BasePart") and o.Parent ~= player.Character then
                if not self.graphicsMaterials[o] then 
                    self.graphicsMaterials[o] = o.Material 
                end
                o.Material = Enum.Material.Plastic
            end
            if o:IsA("Texture") or o:IsA("Decal") then o:Destroy() end
            if o:IsA("ParticleEmitter") or o:IsA("Trail") or o:IsA("Beam") then 
                o:Destroy() 
            end
        end)
    end
end

function GraphicsOptimizer:restoreGraphics()
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
    
    for o, m in pairs(self.graphicsMaterials) do
        pcall(function() 
            if o and o.Parent then o.Material = m end 
        end)
    end
    self.graphicsMaterials = {}
end

function GraphicsOptimizer:onCharacterAdded(character)
    if self.state.functionState.graphics then
        self:enable(true)
    end
end

function GraphicsOptimizer:unload()
    self:restoreGraphics()
end

return GraphicsOptimizer
