-- 基础服务定义
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local StarterGui = game:GetService("StarterGui")
local VirtualUser = game:GetService("VirtualUser")
local LocalPlayer = Players.LocalPlayer
local CurrentCamera = Workspace.CurrentCamera

-- 加载 WindUI 库
local UI_Library_URL = "https://raw.githubusercontent.com/114514lzkill/ui/refs/heads/main/ui.lua"
local Library = loadstring(game:HttpGet(UI_Library_URL))()

-- 窗口创建（作者改为染偌）
local Window = Library:CreateWindow({
    ["Folder"] = "RanNuoHub",
    ["Title"] = "染偌多功能脚本",
    ["Author"] = "染偌",
    ["Icon"] = "rbxassetid://7734068321",
    HideSearchBar = false,
})

-- 启动欢迎通知
StarterGui:SetCore("SendNotification", {
    Title = "欢迎使用",
    Text = "染偌脚本永久免费，拒绝倒卖",
    Duration = 3,
    Icon = "layout-grid"
})
StarterGui:SetCore("SendNotification", {
    Title = "提示",
    Text = "所有功能适配WindUI原生控件",
    Duration = 2,
    Icon = "layout-grid"
})

-------------------------------------------------------------------------
-- Tab: 公告分页
-------------------------------------------------------------------------
local Tab_Notice = Window:Tab({
    ["Locked"] = false,
    ["Title"] = "公告",
    ["Icon"] = "rbxassetid://115466270141583",
})
Tab_Notice:Section({
    TextSize = 17,
    ["Title"] = "作者：染偌 | 脚本永久公益免费，禁止二改倒卖",
    TextXAlignment = "Left",
})
-- 玩家信息板块
local InfoSec = Tab_Notice:Section({Title = "玩家信息"})
InfoSec:Label("玩家名称：" .. LocalPlayer.Name)
InfoSec:Label("注入器：" .. identifyexecutor())
InfoSec:Label("玩家ID：" .. tostring(LocalPlayer.UserId))
InfoSec:Label("服务器ID：" .. tostring(game.PlaceId))
InfoSec:Label("地区：" .. game:GetService("LocalizationService").RobloxLocaleId)
InfoSec:Label("客户端ID：" .. game:GetService("RbxAnalyticsService"):GetClientId())

-------------------------------------------------------------------------
-- Tab: 通用分页（全部功能，滑块替换速度/跳跃，适配WindUI标准写法）
-------------------------------------------------------------------------
local Tab_General = Window:Tab({
    ["Locked"] = false,
    ["Title"] = "通用",
    ["Icon"] = "rbxassetid://18520370419",
})

-- 全局变量
local speedConn = nil
local jumpConn = nil
local noclipConn = nil
local noclipToggle = false
local autoInteractState = false
local WalkSpeed = 16
local JumpPower = 50

-- 1. 速度滑块 + 速度开关
Tab_General:Slider({
    ["Title"] = "移动速度",
    ["Desc"] = "调节人物移速大小",
    ["Step"] = 1,
    ["Value"] = {Min = 1, Default = 16, Max = 200},
    ["Callback"] = function(val)
        WalkSpeed = type(val) == "table" and val[1] or val
    end
})
Tab_General:Toggle({
    ["Title"] = "倍率移速",
    ["Desc"] = "开启后生效自定义移速",
    ["Default"] = false,
    ["Callback"] = function(state)
        if speedConn then speedConn:Disconnect() speedConn = nil end
        if state then
            speedConn = RunService.Heartbeat:Connect(function()
                local char = LocalPlayer.Character
                if char and char:FindFirstChild("Humanoid") then
                    local hum = char.Humanoid
                    if hum.MoveDirection.Magnitude > 0 then
                        char:TranslateBy(hum.MoveDirection * WalkSpeed / 10)
                    end
                end
            end)
        end
    end
})

-- 2. 跳跃高度滑块
Tab_General:Slider({
    ["Title"] = "跳跃高度",
    ["Desc"] = "修改人物跳力",
    ["Step"] = 2,
    ["Value"] = {Min = 20, Default = 50, Max = 250},
    ["Callback"] = function(val)
        JumpPower = type(val) == "table" and val[1] or val
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.JumpPower = JumpPower
        end
    end
})

-- 3. 穿墙 Toggle
Tab_General:Toggle({
    ["Title"] = "穿墙",
    ["Desc"] = "穿透所有实体方块",
    ["Default"] = false,
    ["Callback"] = function(state)
        noclipToggle = state
        if noclipConn then noclipConn:Disconnect() noclipConn = nil end
        if state then
            noclipConn = RunService.Stepped:Connect(function()
                if not noclipToggle then return end
                local char = workspace:FindFirstChild(LocalPlayer.Name)
                if char then
                    for _,part in pairs(char:GetChildren()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
            end)
        end
    end
})

-- 4. 夜视
Tab_General:Toggle({
    ["Title"] = "夜视",
    ["Desc"] = "全场景高亮",
    ["Default"] = false,
    ["Callback"] = function(state)
        game.Lighting.Ambient = state and Color3.new(1,1,1) or Color3.new(0,0,0)
    end
})

-- 5. 无限跳
Tab_General:Toggle({
    ["Title"] = "无限跳",
    ["Desc"] = "空中连续跳跃",
    ["Default"] = false,
    ["Callback"] = function(state)
        if jumpConn then jumpConn:Disconnect() jumpConn = nil end
        if state then
            jumpConn = game.UserInputService.JumpRequest:Connect(function()
                local char = LocalPlayer.Character
                if char and char:FindFirstChild("Humanoid") then
                    char.Humanoid:ChangeState("Jumping")
                end
            end)
        end
    end
})

-- 6. 人物固定（停止移动）
Tab_General:Toggle({
    ["Title"] = "固定人物",
    ["Desc"] = "人物完全静止不动",
    ["Default"] = false,
    ["Callback"] = function(state)
        local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        for _,obj in pairs(char:GetDescendants()) do
            if obj:IsA("BasePart") then
                obj.Anchored = state
            end
        end
    end
})

-- 7. 隐身【实用】
Tab_General:Toggle({
    ["Title"] = "隐身〖实用〗",
    ["Desc"] = "半透明隐形+卡位隐藏",
    ["Default"] = false,
    ["Callback"] = function(state)
        local char = LocalPlayer.Character
        if not char then return end
        if state then
            local saveCFrame = char.HumanoidRootPart.CFrame
            task.wait()
            char:MoveTo(Vector3.new(-25.95, 84, 3537.55))
            task.wait(0.15)
            local hideSeat = Instance.new("Seat", workspace)
            hideSeat.Name = "HideChair_RN"
            hideSeat.Anchored = false
            hideSeat.CanCollide = false
            hideSeat.Transparency = 1
            hideSeat.Position = Vector3.new(-25.95, 84, 3537.55)
            local weld = Instance.new("Weld", hideSeat)
            weld.Part0 = hideSeat
            weld.Part1 = char:FindFirstChild("Torso") or char.UpperTorso
            task.wait()
            hideSeat.CFrame = saveCFrame
            for _,part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") or part:IsA("Decal") then
                    part.Transparency = 0.5
                end
            end
        else
            local oldChair = workspace:FindFirstChild("HideChair_RN")
            if oldChair then oldChair:Destroy() end
            for _,part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") or part:IsA("Decal") then
                    part.Transparency = 0
                end
            end
        end
    end
})

-- 8. 自动互动（task.spawn 修复死循环UI卡顿）
Tab_General:Toggle({
    ["Title"] = "自动互动",
    ["Desc"] = "自动触发所有交互按钮",
    ["Default"] = false,
    ["Callback"] = function(state)
        autoInteractState = state
        task.spawn(function()
            while autoInteractState do
                for _,obj in pairs(workspace:GetDescendants()) do
                    if obj:IsA("ProximityPrompt") then
                        fireproximityprompt(obj)
                    end
                end
                task.wait(0.25)
            end
        end)
    end
})

-- 9. 快速交互总开关
Tab_General:Toggle({
    ["Title"] = "快速交互",
    ["Desc"] = "缩短交互触发延迟",
    ["Default"] = false,
    ["Callback"] = function(state)
        _G.FastInteract = state
    end
})

-- 按钮类功能（点击加载+弹窗通知，WindUI原生Button写法）
-- 染飞行
Tab_General:Button({
    ["Title"] = "染飞行",
    ["Desc"] = "R15通用飞行脚本",
    ["Callback"] = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/luoye123-hkzkm/-/refs/heads/main/%E9%A3%9E%E8%A1%8C.lua"))()
        StarterGui:SetCore("SendNotification", {
            Title = "通知",
            Text = "染飞行加载完成",
            Duration = 1,
            Icon = "layout-grid"
        })
    end
})

-- 踏空行走
Tab_General:Button({
    ["Title"] = "踏空行走",
    ["Desc"] = "无地面浮空行走",
    ["Callback"] = function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/GhostPlayer352/Test4/main/Float'))()
        StarterGui:SetCore("SendNotification", {
            Title = "通知",
            Text = "踏空行走加载完成",
            Duration = 1,
            Icon = "layout-grid"
        })
    end
})

-- 点击传送工具（已改名）
Tab_General:Button({
    ["Title"] = "点击传送工具",
    ["Desc"] = "鼠标点击位置瞬移",
    ["Callback"] = function()
        local mouse = LocalPlayer:GetMouse()
        local tpTool = Instance.new("Tool")
        tpTool.Name = "点击传送工具"
        tpTool.RequiresHandle = false
        tpTool.Activated:Connect(function()
            local targetPos = mouse.Hit.Position + Vector3.new(0, 2.5, 0)
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                char.HumanoidRootPart.CFrame = CFrame.new(targetPos)
            end
        end)
        tpTool.Parent = LocalPlayer.Backpack
        StarterGui:SetCore("SendNotification", {
            Title = "通知",
            Text = "传送工具已放入背包",
            Duration = 1,
            Icon = "layout-grid"
        })
    end
})

-- 快速互动（永久生效）
Tab_General:Button({
    ["Title"] = "快速互动",
    ["Desc"] = "移除长按交互限制",
    ["Callback"] = function()
        game.ProximityPromptService.PromptButtonHoldBegan:Connect(function(prompt)
            prompt.HoldDuration = 0
        end)
        StarterGui:SetCore("SendNotification", {
            Title = "通知",
            Text = "快速交互已开启",
            Duration = 1,
            Icon = "layout-grid"
        })
    end
})

-- 玩家进出提示
Tab_General:Button({
    ["Title"] = "玩家加入提示",
    ["Desc"] = "服务器进出弹窗提醒",
    ["Callback"] = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/boyscp/scriscriptsc/main/bbn.lua"))()
        StarterGui:SetCore("SendNotification", {
            Title = "通知",
            Text = "玩家提示系统加载成功",
            Duration = 1,
            Icon = "layout-grid"
        })
    end
})

-------------------------------------------------------------------------
-- Tab: 玩家透视ESP（完整保留，适配WindUI控件语法）
-------------------------------------------------------------------------
local ESPTab = Window:Tab({
    ["Locked"] = false,
    ["Title"] = "玩家透视",
    ["Icon"] = "rbxassetid://84830962019412",
})
local ESPSec = ESPTab:Section({["Title"] = "ESP系统", Collapsible = true})

local function GetPlayerWeapon(char)
    local tool = char:FindFirstChildOfClass("Tool")
    return tool and tool.Name or "无武器"
end
local function GetBackpackWeapons(plr)
    local list = {}
    if plr.Backpack then
        for _,tool in pairs(plr:GetChildren()) do
            if tool:IsA("Tool") then
                table.insert(list, tool.Name)
            end
        end
    end
    return #list > 0 and table.concat(list, ",") or "无道具"
end

local ESPConfig = {
    Enabled = false,
    ShowName = true, ShowHealth = false, ShowDistance = false, ShowWeapon = false, ShowTeam = false, ShowBackpack = false,
    FillTransparency = 0.5, OutlineTransparency = 0.2, TextSize = 14, TextOutline = true,
    TeammateColor = Color3.new(0, 1, 0), EnemyColor = Color3.new(1, 0.2, 0.2),
    MaxDistance = 2000, UseDistanceFade = true, TeamCheck = true, HighlightEnabled = true,
    BoxOutlineEnabled = true, WallhackEnabled = false, NameTagSize = 1, HealthBarEnabled = true, DistanceScale = true, UpdateRate = 30
}
local Camera = workspace.CurrentCamera
local ESPCache, LastUpdate = {}, 0

local function CalcVis(dis, max)
    if dis > max then return 0 end
    local fadeStart = max * 0.8
    return dis > fadeStart and 1 - ((dis - fadeStart) / (max - fadeStart)) or 1
end
local function GetEspColor(player)
    local sameTeam = ESPConfig.TeamCheck and player.Team == LocalPlayer.Team
    return sameTeam and ESPConfig.TeammateColor or ESPConfig.EnemyColor
end
local function WallCheck(char)
    if not ESPConfig.WallhackEnabled then return false end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return true end
    local ray = Ray.new(Camera.CFrame.Position, (hrp.Position - Camera.CFrame).Unit * 100)
    local hit = workspace:FindPartOnRayWithIgnoreList(ray, {Camera, LocalPlayer.Character, char})
    return hit ~= nil
end

local function CreateESP(char, plr)
    if ESPCache[char] or not char:FindFirstChild("HumanoidRootPart") then return end
    local hrp = char.HumanoidRootPart
    local espData = {Char = char, Player = plr, Conns = {}}

    local hl = Instance.new("Highlight", char)
    hl.FillTransparency = ESPConfig.FillTransparency
    hl.OutlineTransparency = ESPConfig.OutlineTransparency
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    hl.Enabled = ESPConfig.Enabled and ESPConfig.HighlightEnabled

    local bill = Instance.new("BillboardGui", hrp)
    bill.AlwaysOnTop = true
    bill.Size = UDim2.new(0, 200 * ESPConfig.NameTagSize, 0, 60 * ESPConfig.NameTagSize)
    bill.StudsOffset = Vector3.new(0, 3, 0)
    bill.MaxDistance = ESPConfig.MaxDistance
    bill.Enabled = ESPConfig.Enabled

    local label = Instance.new("TextLabel", bill)
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(1, 0, 1, 0)
    label.Font = Enum.Font.SourceSansBold
    label.TextSize = ESPConfig.TextSize * ESPConfig.NameTagSize
    label.TextStrokeTransparency = ESPConfig.TextOutline and 0.4 or 1

    local hpFrame, hpFill
    if ESPConfig.HealthBarEnabled then
        hpFrame = Instance.new("Frame", bill)
        hpFrame.Size = UDim2.new(1, 0, 0, 4 * ESPConfig.NameTagSize)
        hpFrame.Position = UDim2.new(0, 0, 1, 0)
        hpFrame.BackgroundColor3 = Color3.new(0.2,0.2,0.2)
        hpFill = Instance.new("Frame", hpFrame)
        hpFill.Size = UDim2.new(0,0,1,0)
    end

    espData.Highlight = hl
    espData.Billboard = bill
    espData.Label = label
    espData.HpBar = hpFill
    espData.Conns.Ancestry = char.AncestryChanged:Connect(function(_, parent)
        if not parent then
            task.spawn(function()
                ESPCache[char] = nil
                hl:Destroy() bill:Destroy()
            end)
        end
    end)
    ESPCache[char] = espData
end

local function UpdateESP()
    local now = tick()
    if now - LastUpdate < 1 / ESPConfig.UpdateRate then return end
    LastUpdate = now
    if not ESPConfig.Enabled then
        for _,v in pairs(ESPCache) do
            v.Highlight.Enabled = false
            v.Billboard.Enabled = false
        end
        return
    end
    for char, data in pairs(ESPCache) do
        if not char or not char.Parent then ESPCache[char] = nil continue end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum or hum.Health <= 0 then
            data.Highlight.Enabled = false
            data.Billboard.Enabled = false
            continue
        end
        local dist = (hrp.Position - Camera.CFrame.Position).Magnitude
        local vis = CalcVis(dist, ESPConfig.MaxDistance)
        if vis <= 0 then
            data.Highlight.Enabled = false
            data.Billboard.Enabled = false
            continue
        end
        local wallBlock = WallCheck(char)
        local textTable = {}
        local color = GetEspColor(data.Player)
        if ESPConfig.ShowName then table.insert(textTable, data.Player.Name) end
        if ESPConfig.ShowHealth then table.insert(textTable, string.format("HP:%d", math.floor(hum.Health))) end
        if ESPConfig.ShowDistance then table.insert(textTable, math.floor(dist).."m") end
        if ESPConfig.ShowWeapon then table.insert(textTable, GetPlayerWeapon(char)) end
        if ESPConfig.ShowBackpack then table.insert(textTable, GetBackpackWeapons(data.Player)) end
        if ESPConfig.ShowTeam then table.insert(textTable, data.Player.Team.Name) end
        if wallBlock and ESPConfig.WallhackEnabled then table.insert(textTable, "[隔墙]") end

        data.Label.Text = table.concat(textTable, " | ")
        data.Label.TextColor3 = color
        data.Label.TextTransparency = ESPConfig.UseDistanceFade and (0.3 * (1 - vis)) or 0
        data.Highlight.FillColor = color
        data.Highlight.FillTransparency = ESPConfig.FillTransparency + (0.3 * (1 - vis))
        data.Highlight.OutlineTransparency = ESPConfig.BoxOutlineEnabled and (ESPConfig.OutlineTransparency + (0.3 * (1 - vis))) or 1
        data.Highlight.Enabled = ESPConfig.HighlightEnabled and (not wallBlock or ESPConfig.WallhackEnabled)
        data.Billboard.Enabled = #textTable > 0 and (not wallBlock or ESPConfig.WallhackEnabled)
        if data.HpBar then
            local hpPercent = hum.Health / hum.MaxHealth
            data.HpBar.Size = UDim2.new(hpPercent, 0, 1, 0)
            data.HpBar.BackgroundColor3 = Color3.new(1 - hpPercent, hpPercent, 0)
        end
    end
end

local function ResetESP()
    for _,v in pairs(ESPCache) do
        v.Highlight:Destroy()
        v.Billboard:Destroy()
    end
    ESPCache = {}
    if ESPConfig.Enabled then
        for _,plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character then
                task.spawn(function() CreateESP(plr.Character, plr) end)
            end
        end
    end
end

local function InitPlayer(plr)
    if plr == LocalPlayer then return end
    local function OnCharAdd(char)
        task.wait(0.3)
        if ESPConfig.Enabled then CreateESP(char, plr) end
    end
    if plr.Character then task.spawn(OnCharAdd, plr.Character) end
    plr.CharacterAdded:Connect(OnCharAdd)
    plr.CharacterRemoving:Connect(function(c)
        if ESPCache[c] then
            ESPCache[c].Highlight:Destroy()
            ESPCache[c].Billboard:Destroy()
            ESPCache[c] = nil
        end
    end)
end

Players.PlayerAdded:Connect(InitPlayer)
RunService.Heartbeat:Connect(function()
    if LocalPlayer.Character then pcall(UpdateESP) end
end)

-- ESP设置控件
ESPSec:Toggle({["Title"] = "开启ESP透视", ["Default"] = false, ["Callback"] = function(v) ESPConfig.Enabled = v ResetESP() end})
ESPSec:Toggle({["Title"] = "内部发光框", ["Default"] = false, ["Callback"] = function(v) ESPConfig.HighlightEnabled = v end})
ESPSec:Toggle({["Title"] = "轮廓描边", ["Default"] = false, ["Callback"] = function(v) ESPConfig.BoxOutlineEnabled = v end})
ESPSec:Toggle({["Title"] = "显示玩家名", ["Default"] = false, ["Callback"] = function() UpdateESP() end})
ESPSec:Toggle({["Title"] = "显示血量", ["Default"] = false, ["Callback"] = function() UpdateESP() end})
ESPSec:Toggle({["Title"] = "显示距离", ["Default"] = false, ["Callback"] = function() UpdateESP() end})
ESPSec:Toggle({["Title"] = "显示武器", ["Default"] = false, ["Callback"] = function() UpdateESP() end})
ESPSec:Toggle({["Title"] = "显示背包道具", ["Default"] = false, ["Callback"] = function() UpdateESP() end})
ESPSec:Toggle({["Title"] = "显示队伍", ["Default"] = false, ["Callback"] = function() UpdateESP() end})
ESPSec:Toggle({["Title"] = "队伍区分颜色", ["Default"] = false, ["Callback"] = function() UpdateESP() end})
ESPSec:Toggle({["Title"] = "隔墙透视", ["Default"] = false, ["Callback"] = function() UpdateESP() end})
ESPSec:Toggle({["Title"] = "距离文字缩放", ["Default"] = false, ["Callback"] = function() UpdateESP() end})
ESPSec:ColorPicker({["Title"] = "队友颜色", ["Default"] = Color3.new(0, 255, 100), ["Callback"] = function(c) ESPConfig.TeammateColor = c UpdateESP() end})
ESPSec:ColorPicker({["Title"] = "敌人颜色", ["Default"] = Color3.new(255, 50, 50), ["Callback"] = function(c) ESPConfig.EnemyColor = c UpdateESP() end})

print("染偌多功能脚本加载完毕！")
