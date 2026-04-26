-- 隐藏饰品模块

local Players = game:GetService("Players")
local player = Players.LocalPlayer

local HatHider = {}
HatHider.__index = HatHider

-- 关键词定义
local HEAD_KEYWORDS = {
    "hat", "helmet", "cap", "hood", "beanie", "visor", "headband", "bandana",
    "hair", "wig", "hairstyle", "ponytail", "bun", "bangs", "mohawk", "bald",
    "longhair", "shorthair", "curly", "straighthair",
    "mask", "glasses", "goggles", "sunglasses", "eyewear", "spectacles", 
    "crown", "tiara", "halo", "horn", "antler", "headpiece", "headdress", 
    "veil", "bonnet", "beret", "fedora", "top hat", "headphones", "earmuffs",
    "head", "skull", "brain", "ear", "ears"
}

local NECK_KEYWORDS = {
    "necklace", "choker", "pendant", "collar", "scarf", "tie", "cravat", "bowtie"
}

local SHOULDER_KEYWORDS = {
    "shoulder", "pauldron", "epaulette", "shoulderpad", "mantle", "spaulder"
}

local BACK_KEYWORDS = {
    "back", "wing", "cloak", "cape", "pack", "quiver", "backpack", "tail"
}

local WAIST_KEYWORDS = {
    "waist", "belt", "hip", "buckle", "sash"
}

local CHEST_KEYWORDS = {
    "chest", "front", "badge", "brooch", "ribbon", "medal", "breast", "armor", "vest"
}

local FACE_KEYWORDS = {
    "face", "emotion", "smile", "mouth", "eye", "brow", "eyebrow", "expression", "beard", "mustache"
}

local BODY_CORE_PARTS = {
    "head", "torso", "humanoidrootpart", "neck", 
    "leftarm", "rightarm", "leftleg", "rightleg",
    "upperleg", "lowerleg", "leftfoot", "rightfoot"
}

function HatHider.new(state)
    local self = setmetatable({}, HatHider)
    self.state = state
    return self
end

function HatHider:isBodyCorePart(partName)
    local lowerName = partName:lower()
    for _, bodyPart in ipairs(BODY_CORE_PARTS) do
        if lowerName == bodyPart then
            return true
        end
    end
    return false
end

function HatHider:getHiddenKeywords()
    local keywords = {}
    local settings = self.state.hatSettings
    
    if settings["头部"] then
        for _, kw in ipairs(HEAD_KEYWORDS) do
            table.insert(keywords, kw:lower())
        end
    end
    if settings["表情"] then
        for _, kw in ipairs(FACE_KEYWORDS) do
            table.insert(keywords, kw:lower())
        end
    end
    if settings["颈部"] then
        for _, kw in ipairs(NECK_KEYWORDS) do
            table.insert(keywords, kw:lower())
        end
    end
    if settings["背面"] then
        for _, kw in ipairs(BACK_KEYWORDS) do
            table.insert(keywords, kw:lower())
        end
    end
    if settings["腰部"] then
        for _, kw in ipairs(WAIST_KEYWORDS) do
            table.insert(keywords, kw:lower())
        end
    end
    if settings["正面"] then
        for _, kw in ipairs(CHEST_KEYWORDS) do
            table.insert(keywords, kw:lower())
        end
    end
    
    return keywords
end

function HatHider:saveOriginalTransparency(character)
    if not character then return end
    for _, obj in character:GetDescendants() do
        if obj:IsA("BasePart") then
            if not self:isBodyCorePart(obj.Name) then
                local key = tostring(obj)
                if not self.state.originalTransparencies[key] then
                    self.state.originalTransparencies[key] = obj.Transparency
                end
            end
        end
        if obj:IsA("Accessory") then
            local handle = obj:FindFirstChild("Handle")
            if handle then
                local key = tostring(handle)
                if not self.state.originalTransparencies[key] then
                    self.state.originalTransparencies[key] = handle.Transparency
                end
            end
        end
    end
end

function HatHider:restoreAllAccessories(character)
    if not character then return end
    for _, obj in character:GetDescendants() do
        if obj:IsA("BasePart") then
            if not self:isBodyCorePart(obj.Name) then
                local key = tostring(obj)
                if self.state.originalTransparencies[key] then
                    obj.Transparency = self.state.originalTransparencies[key]
                else
                    obj.Transparency = 0
                end
            end
        end
        if obj:IsA("Accessory") then
            local handle = obj:FindFirstChild("Handle")
            if handle then
                local key = tostring(handle)
                if self.state.originalTransparencies[key] then
                    handle.Transparency = self.state.originalTransparencies[key]
                else
                    handle.Transparency = 0
                end
            end
        end
    end
end

function HatHider:hideAccessories(character)
    if not character then return end
    if not self.state.functionState.hat then return end
    
    local keywords = self:getHiddenKeywords()
    local settings = self.state.hatSettings
    
    for _, obj in character:GetDescendants() do
        -- 处理 Accessory（标准饰品）
        if obj:IsA("Accessory") then
            local name = obj.Name:lower()
            local handle = obj:FindFirstChild("Handle")
            
            -- 检查是否是肩部饰品
            local isShoulder = false
            if settings["肩部"] then
                for _, kw in ipairs(SHOULDER_KEYWORDS) do
                    if name:find(kw) then
                        isShoulder = true
                        break
                    end
                end
            end
            
            -- 检查其他部位
            local shouldHide = false
            if not isShoulder then
                for _, kw in ipairs(keywords) do
                    if name:find(kw) then
                        shouldHide = true
                        break
                    end
                end
            end
            
            if (isShoulder or shouldHide) and handle then
                handle.Transparency = 1
            end
        end
        
        -- 处理 BasePart（只隐藏非身体部件）
        if obj:IsA("BasePart") then
            if not self:isBodyCorePart(obj.Name) then
                local name = obj.Name:lower()
                local shouldHide = false
                
                if settings["肩部"] then
                    for _, kw in ipairs(SHOULDER_KEYWORDS) do
                        if name:find(kw) then
                            shouldHide = true
                            break
                        end
                    end
                end
                
                if not shouldHide then
                    for _, kw in ipairs(keywords) do
                        if name:find(kw) then
                            shouldHide = true
                            break
                        end
                    end
                end
                
                if shouldHide then
                    obj.Transparency = 1
                end
            end
        end
    end
end

function HatHider:enable(bool)
    self.state.functionState.hat = bool
    local c = player.Character
    
    if c then
        if bool then
            self:saveOriginalTransparency(c)
            self:hideAccessories(c)
        else
            self:restoreAllAccessories(c)
        end
    end
end

function HatHider:update()
    if self.state.functionState.hat then
        local c = player.Character
        if c then
            self:restoreAllAccessories(c)
            self:hideAccessories(c)
        end
    end
end

function HatHider:init()
    local c = player.Character
    if c then
        self:saveOriginalTransparency(c)
    end
end

function HatHider:onCharacterAdded(character)
    if self.state.functionState.hat then
        self:saveOriginalTransparency(character)
    end
end

function HatHider:unload()
    self:enable(false)
end

return HatHider
