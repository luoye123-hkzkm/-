-- 基础服务定义（和示例源码格式对齐）
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local StarterGui = game:GetService("StarterGui")
local VirtualUser = game:GetService("VirtualUser")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local CurrentCamera = Workspace.CurrentCamera

-- 加载WindUI（原链接不变）
local UI_Library_URL = "https://raw.githubusercontent.com/114514lzkill/ui/refs/heads/main/ui.lua"
local Library = loadstring(game:HttpGet(UI_Library_URL))()

-- 创建窗口 作者改为染偌 完全参照示例CreateWindow参数格式
local Window = Library:CreateWindow({
    ["Folder"] = "RanNuoHub",
    ["Title"] = "染偌多功能",
    ["Author"] = "染偌",
    ["Icon"] = "rbxassetid://7734068321",
    HideSearchBar = false,
})

-- 启动欢迎通知（注入自动弹出）
StarterGui:SetCore("SendNotification", {
    ["Title"] = "欢迎",
    ["Text"] = "染偌脚本永久免费，禁止倒卖二改",
    ["Duration"] = 3,
})
StarterGui:SetCore("SendNotification", {
    ["Title"] = "加载完成",
    ["Text"] = "所有功能适配WindUI原生控件",
    ["Duration"] = 2,
})

-------------------------------------------------------------------------
-- Tab: 公告 【完全对标示例Tab/Section/Label写法】
-------------------------------------------------------------------------
local Tab_Notice = Window:Tab({
    ["Locked"] = false,
    ["Title"] = "公告",
    ["Icon"] = "rbxassetid://115466270141583",
})
Tab_Notice:Section({
    TextSize = 17,
    ["Title"] = "作者：染偌 | 公益脚本，禁止倒卖",
    TextXAlignment = "Left",
})
-- 玩家信息区块
local InfoSec = Tab_Notice:Section({
    ["Title"] = "玩家信息",
})
InfoSec:Label("玩家名称："..LocalPlayer.Name)
InfoSec:Label("注入器："..identifyexecutor())
InfoSec:Label("玩家ID："..tostring(LocalPlayer.UserId))
InfoSec:Label("服务器ID："..tostring(game.PlaceId))
InfoSec:Label("地区："..game:GetService("LocalizationService").RobloxLocaleId)
InfoSec:Label("客户端ID："..game:GetService("RbxAnalyticsService"):GetClientId())

-------------------------------------------------------------------------
-- Tab: 通用 【1:1复刻示例分页、Slider/Toggle/Button结构】
-------------------------------------------------------------------------
local Tab_General = Window:Tab({
    ["Locked"] = false,
    ["Title"] = "通用",
    ["Icon"] = "rbxassetid://18520370419",
})

-- 全局线程存储（修复多开、关不掉循环bug）
local Conn = {
    Speed = nil,
    Noclip = nil,
    InfiniteJump = nil,
    AutoInteract = nil
}
local GlobalSpeed = 16
local GlobalJump = 50
local AutoInteractToggle = false

-- 1. 移动速度滑块（完全复刻示例Slider格式）
Tab_General:Slider({
    ["Title"] = "移动速度",
    ["Desc"] = "自定义人物移速数值",
    ["Step"] = 1,
    ["Value"] = {Min = 1, Default = 16, Max = 200},
    ["Callback"] = function(Value)
        GlobalSpeed = type(Value) == "table" and Value[1] or Value
    end
})
-- 移速开关
Tab_General:Toggle({
    ["Title"] = "倍率移速开启",
    ["Desc"] = "滑块数值生效开关",
    ["Default"] = false,
    ["Callback"] = function(State)
        if Conn.Speed then Conn.Speed:Disconnect() Conn.Speed = nil end
        if State then
            Conn.Speed = RunService.Heartbeat:Connect(function()
                local Char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
                local Hum = Char:FindFirstChildOfClass("Humanoid")
                if Hum and Hum.MoveDirection.Magnitude > 0 then
                    Char:TranslateBy(Hum.MoveDirection * GlobalSpeed / 10)
                end
            end)
        end
    end
})

-- 2. 跳跃高度滑块（标准示例Slider结构）
Tab_General:Slider({
    ["Title"] = "跳跃高度",
    ["Desc"] = "修改人物跳跃力度",
    ["Step"] = 2,
    ["Value"] = {Min = 20, Default = 50, Max = 250},
    ["Callback"] = function(Value)
        GlobalJump = type(Value) == "table" and Value[1] or Value
        local Char = LocalPlayer.Character
        if Char and Char:FindFirstChildOfClass("Humanoid") then
            Char.Humanoid.JumpPower = GlobalJump
        end
        -- 人物重生自动适配跳力
        LocalPlayer.CharacterAdded:Connect(function(NewChar)
            task.wait(0.2)
            local Hum = NewChar:FindFirstChildOfClass("Humanoid")
            if Hum then Hum.JumpPower = GlobalJump end
        end)
    end
})

-- 3. 穿墙Toggle
Tab_General:Toggle({
    ["Title"] = "穿墙",
    ["Desc"] = "关闭碰撞穿透方块",
    ["Default"] = false,
    ["Callback"] = function(State)
        if Conn.Noclip then Conn.Noclip:Disconnect() Conn.Noclip = nil end
        if State then
            Conn.Noclip = RunService.Stepped:Connect(function()
                local Char = workspace:FindFirstChild(LocalPlayer.Name)
                if not Char then return end
                for _,Part in pairs(Char:GetChildren()) do
                    if Part:IsA("BasePart") then Part.CanCollide = false end
                end
            end)
        end
    end
})

-- 4. 夜视
Tab_General:Toggle({
    ["Title"] = "夜视",
    ["Desc"] = "全地图高亮",
    ["Default"] = false,
    ["Callback"] = function(State)
        game.Lighting.Ambient = State and Color3.new(1,1,1) or Color3.new(0,0,0)
    end
})

-- 5. 无限跳
Tab_General:Toggle({
    ["Title"] = "无限跳",
    ["Desc"] = "空中连续跳跃",
    ["Default"] = false,
    ["Callback"] = function(State)
        if Conn.InfiniteJump then Conn.InfiniteJump:Disconnect() Conn.InfiniteJump = nil end
        if State then
            Conn.InfiniteJump = UserInputService.JumpRequest:Connect(function()
                local Char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
                local Hum = Char:FindFirstChildOfClass("Humanoid")
                if Hum then Hum:ChangeState(Enum.HumanoidStateType.Jumping) end
            end)
        end
    end
})

-- 6. 固定人物（停止移动）
Tab_General:Toggle({
    ["Title"] = "固定人物",
    ["Desc"] = "全部部件锚定无法移动",
    ["Default"] = false,
    ["Callback"] = function(State)
        local Char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        for _,Obj in pairs(Char:GetDescendants()) do
            if Obj:IsA("BasePart") then Obj.Anchored = State end
        end
    end
})

-- 7. 隐身〖实用〗
Tab_General:Toggle({
    ["Title"] = "隐身〖实用〗",
    ["Desc"] = "半透明+座椅卡位隐形",
    ["Default"] = false,
    ["Callback"] = function(State)
        local Char = LocalPlayer.Character
        if not Char then return end
        local HideChair = workspace:FindFirstChild("RN_HideSeat")
        if State then
            local SaveCFrame = Char.HumanoidRootPart.CFrame
            task.wait()
            Char:MoveTo(Vector3.new(-25.95, 84, 3537.55))
            task.wait(0.15)
            local Seat = Instance.new("Seat", workspace)
            Seat.Name = "RN_HideSeat"
            Seat.Anchored = false
            Seat.CanCollide = false
            Seat.Transparency = 1
            Seat.Position = Vector3.new(-25.95, 84, 3537.55)
            local Weld = Instance.new("Weld", Seat)
            Weld.Part0 = Seat
            Weld.Part1 = Char:FindFirstChild("Torso") or Char.UpperTorso
            task.wait()
            Seat.CFrame = SaveCFrame
            for _,Part in pairs(Char:GetDescendants()) do
                if Part:IsA("BasePart") or Part:IsA("Decal") then
                    Part.Transparency = 0.5
                end
            end
        else
            if HideChair then HideChair:Destroy() end
            for _,Part in pairs(Char:GetDescendants()) do
                if Part:IsA("BasePart") or Part:IsA("Decal") then
                    Part.Transparency = 0
                end
            end
        end
    end
})

-- 8. 自动互动 task.spawn隔离线程 修复UI卡死
Tab_General:Toggle({
    ["Title"] = "自动互动",
    ["Desc"] = "自动触发所有交互按钮",
    ["Default"] = false,
    ["Callback"] = function(State)
        AutoInteractToggle = State
        task.spawn(function()
            while AutoInteractToggle do
                for _,Obj in pairs(workspace:GetDescendants()) do
                    if Obj:IsA("ProximityPrompt") then
                        fireproximityprompt(Obj)
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
    ["Desc"] = "缩短交互延迟",
    ["Default"] = false,
    ["Callback"] = function(State)
        _G.FastInteract = State
    end
})

-- 按钮类功能 全部带["Desc"] 完全对标示例Button写法
-- 染飞行
Tab_General:Button({
    ["Title"] = "染飞行",
    ["Desc"] = "加载R15通用飞行脚本",
    ["Callback"] = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/luoye123-hkzkm/-/refs/heads/main/%E9%A3%9E%E8%A1%8C.lua"))()
        StarterGui:SetCore("SendNotification", {["Title"]="通知",["Text"]="染飞行加载成功",["Duration"]=1})
    end
})

-- 踏空行走
Tab_General:Button({
    ["Title"] = "踏空行走",
    ["Desc"] = "无地面浮空行走",
    ["Callback"] = function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/GhostPlayer352/Test4/main/Float'))()
        StarterGui:SetCore("SendNotification", {["Title"]="通知",["Text"]="踏空行走加载成功",["Duration"]=1})
    end
})

-- 点击传送工具（按要求命名）
Tab_General:Button({
    ["Title"] = "点击传送工具",
    ["Desc"] = "鼠标点击位置瞬移",
    ["Callback"] = function()
        local Mouse = LocalPlayer:GetMouse()
        local Tool = Instance.new("Tool")
        Tool.RequiresHandle = false
        Tool.Name = "点击传送工具"
        Tool.Activated:Connect(function()
            local TargetPos = Mouse.Hit.Position + Vector3.new(0,2.5,0)
            local Char = LocalPlayer.Character
            if Char and Char:FindFirstChild("HumanoidRootPart") then
                Char.HumanoidRootPart.CFrame = CFrame.new(TargetPos)
            end
        end)
        Tool.Parent = LocalPlayer.Backpack
        StarterGui:SetCore("SendNotification", {["Title"]="通知",["Text"]="传送工具已放入背包",["Duration"]=1})
    end
})

-- 快速互动（永久移除长按）
Tab_General:Button({
    ["Title"] = "快速互动",
    ["Desc"] = "永久取消交互长按限制",
    ["Callback"] = function()
        game.ProximityPromptService.PromptButtonHoldBegan:Connect(function(Prompt)
            Prompt.HoldDuration = 0
        end)
        StarterGui:SetCore("SendNotification", {["Title"]="通知",["Text"]="快速交互已开启",["Duration"]=1})
    end
})

-- 玩家加入提示
Tab_General:Button({
    ["Title"] = "玩家加入提示",
    ["Desc"] = "服务器进出弹窗提醒",
    ["Callback"] = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/boyscp/scriscriptsc/main/bbn.lua"))()
        StarterGui:SetCore("SendNotification", {["Title"]="通知",["Text"]="玩家提示系统加载成功",["Duration"]=1})
    end
})

-------------------------------------------------------------------------
-- Tab: 玩家透视ESP 控件语法统一WindUI标准
-------------------------------------------------------------------------
local ESPTab = Window:Tab({
    ["Locked"] = false,
    ["Title"] = "玩家透视",
    ["Icon"] = "rbxassetid://84830962019412",
})
local ESPSec = ESPTab:Section({
    ["Title"] = "ESP系统",
    Collapsible = true,
})

local ESPConfig = {
    Enabled = false,
    ShowName = true, ShowHealth = false, ShowDistance = false, ShowWeapon = false, ShowTeam = false, ShowBackpack = false,
    FillTransparency = 0.5, OutlineTransparency = 0.2, TextSize = 14, TextOutline = true,
    TeammateColor = Color3.fromRGB(0,255,100), EnemyColor = Color3.fromRGB(255,50,50),
    MaxDistance = 2000, UseDistanceFade = true, TeamCheck = true, HighlightEnabled = true,
    BoxOutlineEnabled = true, WallhackEnabled = false, NameTagSize = 1, HealthBarEnabled = true, UpdateRate = 30
}
local Camera = Workspace.CurrentCamera
local ESPCache = {}
local LastUpdate = 0

local function GetPlayerWeapon(Char)
    local Tool = Char:FindFirstChildOfClass("Tool")
    return Tool and Tool.Name or "无武器"
end
local function GetBackpackWeapons(Player)
    local List = {}
    if Player.Backpack then
        for _,Tool in pairs(Player.Backpack:GetChildren()) do
            if Tool:IsA("Tool") then table.insert(List,Tool.Name) end
        end
    end
    return #List > 0 and table.concat(List, ", ") or "无道具"
end
local function CalcVis(Dist,MaxDist)
    if Dist > MaxDist then return 0 end
    local FadePoint = MaxDist * 0.8
    return Dist > FadePoint and 1 - ((Dist-FadePoint)/(MaxDist-FadePoint)) or 1
end
local function WallCheck(Char)
    if not ESPConfig.WallhackEnabled then return false end
    local HRP = Char:FindFirstChild("HumanoidRootPart")
    if not HRP then return true end
    local Ray = Ray.new(Camera.CFrame.Position, (HRP.Position - Camera.CFrame).Unit * 100)
    local Hit = Workspace:FindPartOnRayWithIgnoreList(Ray, {Camera, LocalPlayer, Char})
    return Hit ~= nil
end
local function CreateESP(Char,Plr)
    if ESPCache[Char] or not Char:FindFirstChild("HumanoidRootPart") then return end
    local HRP = Char.HumanoidRootPart
    local Data = {}
    local Highlight = Instance.new("Highlight", Char)
    Highlight.FillTransparency = ESPConfig.FillTransparency
    Highlight.OutlineTransparency = ESPConfig.OutlineTransparency
    Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    Highlight.Enabled = ESPConfig.Enabled and ESPConfig.HighlightEnabled

    local Billboard = Instance.new("BillboardGui", HRP)
    Billboard.AlwaysOnTop = true
    Billboard.Size = UDim2.new(0, 200*ESPConfig.NameTagSize, 0, 60*ESPConfig.NameTagSize)
    Billboard.StudsOffset = Vector3.new(0,3,0)
    Billboard.MaxDistance = ESPConfig.MaxDistance
    Billboard.Enabled = ESPConfig.Enabled

    local Label = Instance.new("TextLabel", Billboard)
    Label.BackgroundTransparency = 1
    Label.Size = UDim2.new(1,0,1,0)
    Label.Font = Enum.Font.SourceSansBold
    Label.TextSize = ESPConfig.TextSize * ESPConfig.NameTagSize
    Label.TextStrokeTransparency = ESPConfig.TextOutline and 0.4 or 1

    local HPFrame,HPFill
    if ESPConfig.HealthBarEnabled then
        HPFrame = Instance.new("Frame", Billboard)
        HPFrame.Size = UDim2.new(1,0,0,4*ESPConfig.NameTagSize)
        HPFrame.Position = UDim2.new(0,0,1,0)
        HPFrame.BackgroundColor3 = Color3.new(0.2,0.2,0.2)
        HPFill = Instance.new("Frame", HPFrame)
        HPFill.Size = UDim2.new(0,0,1,0)
    end

    Data.Highlight = Highlight
    Data.Billboard = Billboard
    Data.Label = Label
    Data.HP = HPFill
    Data.Player = Plr
    Data.Connect = Char.AncestryChanged:Connect(function(_,Parent)
        if not Parent then
            task.spawn(function()
                Highlight:Destroy()
                Billboard:Destroy()
                ESPCache[Char] = nil
            end)
        end
    end)
    ESPCache[Char] = Data
end
local function UpdateESP()
    local Now = tick()
    if Now - LastUpdate < 1/ESPConfig.UpdateRate then return end
    LastUpdate = Now
    if not ESPConfig.Enabled then
        for _,Data in pairs(ESPCache) do
            Data.Highlight.Enabled = false
            Data.Billboard.Enabled = false
        end
        return
    end
    for Char,Data in pairs(ESPCache) do
        if not Char or not Char.Parent then ESPCache[Char] = nil continue end
        local HRP = Char:FindFirstChild("HumanoidRootPart")
        local Hum = Char:FindFirstChildOfClass("Humanoid")
        if not HRP or not Hum or Hum.Health <= 0 then
            Data.Highlight.Enabled = false
            Data.Billboard.Enabled = false
            continue
        end
        local Dist = (HRP.Position - Camera.CFrame.Position).Magnitude
        local Vis = CalcVis(Dist, ESPConfig.MaxDistance)
        if Vis <= 0 then
            Data.Highlight.Enabled = false
            Data.Billboard.Enabled = false
            continue
        end
        local SameTeam = ESPConfig.TeamCheck and Data.Player.Team == LocalPlayer.Team
        local Color = SameTeam and ESPConfig.TeammateColor or ESPConfig.EnemyColor
        local BlockWall = WallCheck(Char)
        local TextArr = {}
        if ESPConfig.ShowName then table.insert(TextArr, Data.Player.Name) end
        if ESPConfig.ShowHealth then table.insert(TextArr, "HP:"..math.floor(Hum.Health)) end
        if ESPConfig.ShowDistance then table.insert(TextArr, math.floor(Dist).."m") end
        if ESPConfig.ShowWeapon then table.insert(TextArr, GetPlayerWeapon(Char)) end
        if ESPConfig.ShowBackpack then table.insert(TextArr, GetBackpackWeapons(Data.Player)) end
        if ESPConfig.ShowTeam then table.insert(TextArr, SameTeam and "队友" or "敌人") end
        if BlockWall and ESPConfig.WallhackEnabled then table.insert(TextArr, "[隔墙]") end
        Data.Label.Text = table.concat(TextArr, " | ")
        Data.Label.TextColor3 = Color
        Data.Label.TextTransparency = ESPConfig.UseDistanceFade and (0.3*(1-Vis)) or 0
        Data.Highlight.FillColor = Color
        Data.Highlight.FillTransparency = ESPConfig.FillTransparency + (0.3*(1-Vis))
        Data.Highlight.OutlineTransparency = ESPConfig.BoxOutlineEnabled and (ESPConfig.OutlineTransparency + (0.3*(1-Vis))) or 1
        Data.Highlight.Enabled = ESPConfig.HighlightEnabled and (not BlockWall or ESPConfig.WallhackEnabled)
        Data.Billboard.Enabled = #TextArr > 0 and (not BlockWall or ESPConfig.WallhackEnabled)
        if Data.HP then
            local Percent = Hum.Health / Hum.MaxHealth
            Data.HP.Size = UDim2.new(Percent,0,1,0)
            Data.HP.BackgroundColor3 = Color3.new(1-Percent, Percent, 0)
        end
    end
end
local function ResetESP()
    for _,Data in pairs(ESPCache) do
        Data.Highlight:Destroy()
        Data.Billboard:Destroy()
    end
    ESPCache = {}
    if ESPConfig.Enabled then
        for _,Plr in pairs(Players:GetPlayers()) do
            if Plr ~= LocalPlayer and Plr.Character then
                CreateESP(Plr.Character, Plr)
            end
        end
    end
end
local function InitPlayer(Plr)
    if Plr == LocalPlayer then return end
    local function OnCharSpawn(Char)
        task.wait(0.3)
        if ESPConfig.Enabled then CreateESP(Char, Plr) end
    end
    if Plr.Character then task.spawn(OnCharSpawn, Plr.Character) end
    Plr.CharacterAdded:Connect(OnCharSpawn)
    Plr.CharacterRemoving:Connect(function(C)
        if ESPCache[C] then
            ESPCache[C].Highlight:Destroy()
            ESPCache[C].Billboard:Destroy()
            ESPCache[C] = nil
        end
    end)
end
Players.PlayerAdded:Connect(InitPlayer)
RunService.Heartbeat:Connect(function()
    if LocalPlayer.Character then pcall(UpdateESP) end
end)

-- ESP设置控件（全部WindUI标准格式）
ESPSec:Toggle({["Title"]="开启ESP透视",["Default"]=false,["Callback"]=function(V) ESPConfig.Enabled=V ResetESP() end})
ESPSec:Toggle({["Title"]="内部发光框",["Default"]=false,["Callback"]=function(V) ESPConfig.HighlightEnabled=V end})
ESPSec:Toggle({["Title"]="轮廓描边",["Default"]=false,["Callback"]=function(V) ESPConfig.BoxOutlineEnabled=V end})
ESPSec:Toggle({["Title"]="显示玩家名字",["Default"]=false,["Callback"]=function() UpdateESP() end})
ESPSec:Toggle({["Title"]="显示血量",["Default"]=false,["Callback"]=function() UpdateESP() end})
ESPSec:Toggle({["Title"]="显示距离",["Default"]=false,["Callback"]=function() UpdateESP() end})
ESPSec:Toggle({["Title"]="显示武器",["Default"]=false,["Callback"]=function() UpdateESP() end})
ESPSec:Toggle({["Title"]="显示背包道具",["Default"]=false,["Callback"]=function() UpdateESP() end})
ESPSec:Toggle({["Title"]="显示队伍",["Default"]=false,["Callback"]=function() UpdateESP() end})
ESPSec:Toggle({["Title"]="队伍区分颜色",["Default"]=false,["Callback"]=function() UpdateESP() end})
ESPSec:Toggle({["Title"]="隔墙透视",["Default"]=false,["Callback"]=function() UpdateESP() end})
ESPSec:Toggle({["Title"]="距离文字缩放",["Default"]=false,["Callback"]=function() UpdateESP() end})
ESPSec:ColorPicker({["Title"]="队友颜色",["Default"]=Color3.fromRGB(0,255,100),["Callback"]=function(C) ESPConfig.TeammateColor=C UpdateESP() end})
ESPSec:ColorPicker({["Title"]="敌人颜色",["Default"]=Color3.fromRGB(255,50,50),["Callback"]=function(C) ESPConfig.EnemyColor=C UpdateESP() end})

print("染偌多功能脚本加载完毕！")
