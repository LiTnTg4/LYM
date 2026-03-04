-- ===== Bloxstrap 诊断工具 =====
print("\n" .. string.rep("=", 50))
print("🔧 Bloxstrap 诊断工具")
print(string.rep("=", 50))

-- 1. 检查执行器
print("\n1️⃣ 检查执行器环境")
print("Delta版本: " .. (Delta and "Detected" or "Unknown"))
print("getgenv存在: " .. tostring(getgenv ~= nil))

-- 2. 检查关键函数
print("\n2️⃣ 检查关键函数")
local functions = {
    "setfflag", "getfflag", "cloneref",
    "writefile", "readfile", "isfile", "makefolder"
}

for _, funcName in ipairs(functions) do
    local status = _G[funcName] and "✅ 存在" or "❌ 不存在"
    print("  " .. funcName .. ": " .. status)
end

-- 3. 测试setfflag
print("\n3️⃣ 测试setfflag")
if setfflag then
    local success, err = pcall(function()
        setfflag("DFIntTaskSchedulerTargetFps", "999")
    end)
    if success then
        print("✅ setfflag 测试成功")
    else
        print("❌ setfflag 测试失败: " .. tostring(err))
    end
else
    print("❌ setfflag 不存在，无法测试")
end

-- 4. 测试文件系统
print("\n4️⃣ 测试文件系统")
local folderTest = pcall(function()
    makefolder("BloxstrapTest")
    writefile("BloxstrapTest/test.txt", "test")
    local content = readfile("BloxstrapTest/test.txt")
    print("  读写测试: " .. (content == "test" and "✅成功" or "❌失败"))
    delfile("BloxstrapTest/test.txt")
    -- 注意：有些执行器没有delfolder
end)

-- 5. 最终诊断
print("\n" .. string.rep("=", 50))
print("📊 诊断结果")

if not setfflag then
    print("❌ 主要问题：setfflag 不存在")
    print("   你的Delta版本不支持FFlag修改")
    print("   解决方案：")
    print("   - 更新Delta到最新版")
    print("   - 换其他支持FFlag的执行器")
elseif not isfolder then
    print("⚠️ 文件系统可能不完整")
    print("   但FFlag修改应该能用")
else
    print("✅ 环境正常，可以运行Bloxstrap")
end

print(string.rep("=", 50))