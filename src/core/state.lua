-- 全局状态管理模块

local State = {}
State.__index = State

function State.new()
    local self = setmetatable({}, State)
    
    -- 卸载状态
    self.isUnloaded = false
    
    -- 饰品配置（默认所有部位都关闭 - 不隐藏）
    self.hatSettings = {
        ["头部"] = false,
        ["表情"] = false,
        ["颈部"] = false,
        ["背面"] = false,
        ["腰部"] = false,
        ["肩部"] = false,
        ["正面"] = false,
    }
    
    -- 功能状态（所有功能默认关闭）
    self.functionState = {
        r6Leg = false,
        r15Leg = false,
        graphics = false,
        hat = false,
    }
    
    -- 保存原始透明度
    self.originalTransparencies = {}
    
    -- 连接器
    self._connections = {}
    self._listeners = {}
    
    return self
end

function State:createSignal()
    local connections = {}
    local signal = {}
    
    function signal:Connect(callback)
        local connection = { callback = callback, connected = true }
        table.insert(connections, connection)
        return {
            Disconnect = function()
                connection.connected = false
            end
        }
    end
    
    function signal:Fire(...)
        for i = #connections, 1, -1 do
            local conn = connections[i]
            if conn.connected then
                conn.callback(...)
            else
                table.remove(connections, i)
            end
        end
    end
    
    function signal:Destroy()
        for _, conn in ipairs(connections) do
            conn.connected = false
        end
        connections = {}
    end
    
    return signal
end

State.onUnload = State:createSignal()

function State:unload()
    self.isUnloaded = true
    self.onUnload:Fire()
end

return State
