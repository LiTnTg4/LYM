-- 工具函数模块

local Helpers = {}

-- 查找部件
function Helpers.findPart(container, names)
    if not container then return nil end
    for _, name in ipairs(names) do
        local part = container:FindFirstChild(name)
        if part then return part end
    end
    return nil
end

-- 检查是否是身体核心部件
function Helpers.isBodyCorePart(partName)
    local Constants = require(script.Parent.Parent.src.core.constants)
    local lowerName = partName:lower()
    for _, bodyPart in ipairs(Constants.BODY_CORE_PARTS) do
        if lowerName == bodyPart then
            return true
        end
    end
    return false
end

-- 获取视图缩放
function Helpers.getScale()
    local workspace = game:GetService("Workspace")
    local camera = workspace.CurrentCamera
    if not camera then return 1 end
    
    local viewportSize = camera.ViewportSize
    local referenceHeight = 1080
    return math.max(0.8, math.min(1.5, viewportSize.Y / referenceHeight))
end

-- 安全调用函数
function Helpers.safeCall(func, ...)
    local success, result = pcall(func, ...)
    if not success then
        warn("Error: ", result)
    end
    return result
end

-- 创建圆角
function Helpers.createCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius)
    corner.Parent = parent
    return corner
end

-- 创建边框
function Helpers.createStroke(parent, thickness, color, transparency)
    local stroke = Instance.new("UIStroke")
    stroke.Thickness = thickness or 1
    stroke.Color = color or Color3.fromRGB(255, 255, 255)
    stroke.Transparency = transparency or 0.3
    stroke.Parent = parent
    return stroke
end

return Helpers
