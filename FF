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

-- ===== 帧率最大化 =====
pcall(function() setfflagFunc("TaskSchedulerTargetFps", "999999") end)
pcall(function() setfflagFunc("DFIntTaskSchedulerTargetFps", "999999") end)
pcall(function() setfflagFunc("TaskSchedulerLimitTargetFpsTo2402", "true") end)
pcall(function() setfflagFunc("FFlagTaskSchedulerLimitTargetFpsTo2402", "true") end)

-- ===== 画质最低 =====
-- 纹理模糊 (16最模糊)
pcall(function() setfflagFunc("DebugTextureManagerSkipMips", "16") end)
pcall(function() setfflagFunc("FIntDebugTextureManagerSkipMips", "16") end)

-- 纹理质量最低 (0)
pcall(function() setfflagFunc("TextureQualityOverride", "0") end)
pcall(function() setfflagFunc("DFIntTextureQualityOverride", "0") end)
pcall(function() setfflagFunc("DFFlagTextureQualityOverrideEnabled", "true") end)

-- 灰天空
pcall(function() setfflagFunc("DebugSkyGray", "true") end)
pcall(function() setfflagFunc("FFlagDebugSkyGray", "true") end)

-- 草地距离最小 (0)
pcall(function() setfflagFunc("FRMMaxGrassDistance", "0") end)
pcall(function() setfflagFunc("FIntFRMMaxGrassDistance", "0") end)
pcall(function() setfflagFunc("FRMMinGrassDistance", "0") end)
pcall(function() setfflagFunc("FIntFRMMinGrassDistance", "0") end)

-- UI模糊最大 (100)
pcall(function() setfflagFunc("RobloxGuiBlurIntensity", "100") end)
pcall(function() setfflagFunc("FIntRobloxGuiBlurIntensity", "100") end)

-- 地形最小 (0)
pcall(function() setfflagFunc("TerrainArraySliceSize", "0") end)
pcall(function() setfflagFunc("FIntTerrainArraySliceSize", "0") end)

-- 抗锯齿关闭 (0)
pcall(function() setfflagFunc("DebugForceMSAASamples", "0") end)
pcall(function() setfflagFunc("FIntDebugForceMSAASamples", "0") end)

-- ===== 渲染底层优化 =====
pcall(function() setfflagFunc("DebugFRMQualityLevelOverride", "0") end)
pcall(function() setfflagFunc("DFIntDebugFRMQualityLevelOverride", "0") end)
pcall(function() setfflagFunc("RenderGpuTextureCompressor", "false") end)
pcall(function() setfflagFunc("FFlagRenderGpuTextureCompressor", "false") end)
pcall(function() setfflagFunc("DebugGraphicsPreferD3D11", "true") end)
pcall(function() setfflagFunc("FFlagDebugGraphicsPreferD3D11", "true") end)
pcall(function() setfflagFunc("FastGPULightCulling3", "false") end)
pcall(function() setfflagFunc("FFlagFastGPULightCulling3", "false") end)

-- ===== 网络优化 (暴力) =====
pcall(function() setfflagFunc("S2PhysicsSenderRate", "38000") end)
pcall(function() setfflagFunc("DFIntS2PhysicsSenderRate", "38000") end)
pcall(function() setfflagFunc("RakNetLoopMs", "1") end)
pcall(function() setfflagFunc("DFIntRakNetLoopMs", "1") end)
pcall(function() setfflagFunc("RakNetResendBufferArrayLength", "512") end)
pcall(function() setfflagFunc("FIntRakNetResendBufferArrayLength", "512") end)
pcall(function() setfflagFunc("ConnectionMTUSize", "1490") end)
pcall(function() setfflagFunc("DFIntConnectionMTUSize", "1490") end)
pcall(function() setfflagFunc("RakNetResendRttMultiple", "1") end)
pcall(function() setfflagFunc("DFIntRakNetResendRttMultiple", "1") end)
pcall(function() setfflagFunc("DataSenderRate", "100000") end)
pcall(function() setfflagFunc("DFIntDataSenderRate", "100000") end)
pcall(function() setfflagFunc("DataSenderMaxBandwidthBpsMultiplier", "1000") end)
pcall(function() setfflagFunc("DFIntDataSenderMaxBandwidthBpsMultiplier", "1000") end)
pcall(function() setfflagFunc("MaxFrameBufferSize", "1") end)
pcall(function() setfflagFunc("DFIntMaxFrameBufferSize", "1") end)
pcall(function() setfflagFunc("NumAssetsMaxToPreload", "2147483647") end)
pcall(function() setfflagFunc("DFIntNumAssetsMaxToPreload", "2147483647") end)
pcall(function() setfflagFunc("ClientPacketMaxDelayMs", "1") end)
pcall(function() setfflagFunc("DFIntClientPacketMaxDelayMs", "1") end)
pcall(function() setfflagFunc("ClientPacketMinMicroseconds", "100") end)
pcall(function() setfflagFunc("DFIntClientPacketMinMicroseconds", "100") end)

-- ===== 物理优化 =====
pcall(function() setfflagFunc("Physics", "1") end)
pcall(function() setfflagFunc("DFIntPhysics", "1") end)

-- ===== 遥测禁用 =====
pcall(function() setfflagFunc("FFlagDebugDisableTelemetryEphemeralStat", "True") end)
pcall(function() setfflagFunc("FFlagDebugDisableTelemetryPoint", "True") end)
pcall(function() setfflagFunc("FFlagDebugDisableTelemetryV2Event", "True") end)
pcall(function() setfflagFunc("FFlagDebugDisableTelemetryV2Counter", "True") end)
pcall(function() setfflagFunc("FFlagDebugDisableTelemetryV2Stat", "True") end)
pcall(function() setfflagFunc("FFlagDebugDisableTelemetryEventIngest", "True") end)
pcall(function() setfflagFunc("FFlagDebugDisableTelemetryEphemeralCounter", "True") end)
pcall(function() setfflagFunc("FFlagAdServiceEnabled", "false") end)