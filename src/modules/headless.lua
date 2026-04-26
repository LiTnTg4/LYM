-- 无头效果模块

local Players = game:GetService("Players")
local player = Players.LocalPlayer

local HeadlessManager = {}
HeadlessManager.__index = HeadlessManager

function HeadlessManager.new(state)
    local self = setmetatable({}, HeadlessManager)
    self.state = state
    self.running = true
    return self
end

function HeadlessManager:enable()
    self.running = true
    task.spawn(function()
        while self.running and not self.state.isUnloaded do
            task.wait(1)
            local c = player.Character
            if c then
                local head = c:FindFirstChild("Head")
                if head and head.Transparency ~= 1 then
                    head.Transparency = 1
                    head.CanCollide = false
                end
                local face = c:FindFirstChild("Face")
                if face then face:Destroy() end
            end
        end
    end)
end

function HeadlessManager:removeFaceDecals()
    task.spawn(function()
        while self.running and not self.state.isUnloaded do
            task.wait(1)
            local c = player.Character
            if c then
                for _, obj in c:GetDescendants() do
                    if obj:IsA("Decal") and obj.Name:lower():find("face") then
                        obj:Destroy()
                    end
                    if obj:IsA("Texture") and obj.Name:lower():find("face") then
                        obj:Destroy()
                    end
                end
            end
        end
    end)
end

function HeadlessManager:init()
    self:enable()
    self:removeFaceDecals()
end

function HeadlessManager:onCharacterAdded(character)
    task.wait(0.5)
    if not self.state.isUnloaded then
        local head = character:FindFirstChild("Head")
        if head then
            head.Transparency = 1
            head.CanCollide = false
        end
    end
end

function HeadlessManager:unload()
    self.running = false
    local c = player.Character
    if c then
        local head = c:FindFirstChild("Head")
        if head then 
            head.Transparency = 0
            head.CanCollide = true 
        end
    end
end

return HeadlessManager
