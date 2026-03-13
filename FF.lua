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

-- MSAA抗锯齿设置为4x
pcall(function() setfflagFunc("DebugForceMSAASamples", "4") end)
pcall(function() setfflagFunc("FIntDebugForceMSAASamples", "4") end)

-- 暂停体素化（调试用）
pcall(function() setfflagFunc("DebugPauseVoxelizer", "True") end)
pcall(function() setfflagFunc("DFFlagDebugPauseVoxelizer", "True") end)

-- 阴影强度设为0（完全关闭）
pcall(function() setfflagFunc("RenderShadowIntensity", "0") end)
pcall(function() setfflagFunc("FIntRenderShadowIntensity", "0") end)

-- 阴影贴图偏差设为-1
pcall(function() setfflagFunc("RenderShadowmapBias", "-1") end)
pcall(function() setfflagFunc("FIntRenderShadowmapBias", "-1") end)

-- 草地最大距离设为0（完全禁用）
pcall(function() setfflagFunc("FRMMaxGrassDistance", "0") end)
pcall(function() setfflagFunc("FIntFRMMaxGrassDistance", "0") end)

-- 草地细节股数设为0
pcall(function() setfflagFunc("RenderGrassDetailStrands", "0") end)
pcall(function() setfflagFunc("FIntRenderGrassDetailStrands", "0") end)

-- 草地最小距离设为0
pcall(function() setfflagFunc("FRMMinGrassDistance", "0") end)
pcall(function() setfflagFunc("FIntFRMMinGrassDistance", "0") end)

-- 启用统一光照12
pcall(function() setfflagFunc("RenderUnifiedLighting12", "True") end)
pcall(function() setfflagFunc("FFlagRenderUnifiedLighting12", "True") end)

-- UI模糊强度设为0（关闭）
pcall(function() setfflagFunc("RobloxGuiBlurIntensity", "0") end)
pcall(function() setfflagFunc("FIntRobloxGuiBlurIntensity", "0") end)

-- 显示FPS计数器
pcall(function() setfflagFunc("DebugDisplayFPS", "True") end)
pcall(function() setfflagFunc("FFlagDebugDisplayFPS", "True") end)

-- 启用首选文字大小缩放
pcall(function() setfflagFunc("EnablePreferredTextSizeScale", "True") end)
pcall(function() setfflagFunc("FFlagEnablePreferredTextSizeScale", "True") end)

-- 在菜单中启用首选文字大小设置
pcall(function() setfflagFunc("EnablePreferredTextSizeSettingInMenus2", "True") end)
pcall(function() setfflagFunc("FFlagEnablePreferredTextSizeSettingInMenus2", "True") end)

-- 带宽管理器默认bps
pcall(function() setfflagFunc("BandwidthManagerApplicationDefaultBps", "96000") end)
pcall(function() setfflagFunc("DFIntBandwidthManagerApplicationDefaultBps", "96000") end)

-- 带宽管理器数据发送器最大追赶时间
pcall(function() setfflagFunc("BandwidthManagerDataSenderMaxWorkCatchupMs", "50") end)
pcall(function() setfflagFunc("DFIntBandwidthManagerDataSenderMaxWorkCatchupMs", "50") end)

-- 资源预加载数量（最大值）
pcall(function() setfflagFunc("AssetPreloading", "2147483647") end)
pcall(function() setfflagFunc("DFIntAssetPreloading", "2147483647") end)

-- 最大预加载资源数（最大值）
pcall(function() setfflagFunc("NumAssetsMaxToPreload", "2147483647") end)
pcall(function() setfflagFunc("DFIntNumAssetsMaxToPreload", "2147483647") end)

-- 获取玩家图片默认超时时间
pcall(function() setfflagFunc("GetPlayerImageDefaultTimeout", "1") end)
pcall(function() setfflagFunc("FStringGetPlayerImageDefaultTimeout", "1") end)

-- 打印数据Ping详细信息（调试用）
pcall(function() setfflagFunc("DebugPrintDataPingBreakDown", "True") end)
pcall(function() setfflagFunc("DFFlagDebugPrintDataPingBreakDown", "True") end)