local env = getgenv or function() return _G end
local myEnv = env()

local function findSetFFlag()
    local candidates = {
        setfflag,
        myEnv.setfflag,
        _G.setfflag,
    }
    
    for _, func in ipairs(candidates) do
        if type(func) == "function" then
            local success = pcall(function()
                func("DebugSkyGray", "true")
            end)
            if success then
                return func
            end
        end
    end
    return nil
end

local setfflagFunc = findSetFFlag()

if not setfflagFunc then
    return
end

local success = pcall(function()
    setfflagFunc("TaskSchedulerTargetFps", "120")
end)

if not success then
    local variants = {
        "DFIntTaskSchedulerTargetFps",
        "FIntTaskSchedulerTargetFps",
        "taskschedulertargetfps",
        "TaskSchedulerTargetFps",
    }
    
    for _, name in ipairs(variants) do
        local ok = pcall(function()
            setfflagFunc(name, "120")
        end)
        if ok then
            break
        end
    end
end