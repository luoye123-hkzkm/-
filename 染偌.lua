local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")
local LocalPlayer = Players.LocalPlayer

local UI_Library_URL = "https://raw.githubusercontent.com/114514lzkill/ui/refs/heads/main/ui.lua"
local Library = loadstring(game:HttpGet(UI_Library_URL))()

local Window = Library:CreateWindow({
    ["Folder"] = "RanNuoHub",
    ["Title"] = "染偌多功能",
    ["Author"] = "染偌",
    ["Icon"] = "rbxassetid://7734068321",
    ["HideSearchBar"] = false
})

local function Notify(Title1, Text1, Time1)
    StarterGui:SetCore("SendNotification",{
        ["Title"] = Title1,
        ["Text"] = Text1,
        ["Duration"] = Time1
    })
end

Notify("欢迎使用染偌","作者：染偌",3)
Notify("永久免费","没有盈利",3)
Notify("拒绝跑路","拒绝倒卖",3)
Notify("启动完成","祝你玩的开心",5)

-- 公告分页 修复Label传参
local Tab_Notice = Window:Tab({
    ["Locked"] = false,
    ["Title"] = "公告",
    ["Icon"] = "rbxassetid://115466270141583"
})
Tab_Notice:Section({
    ["Title"] = "作者：染偌 | 公益脚本，禁止倒卖",
    ["TextSize"] = 17
})
local InfoSec = Tab_Notice:Section({["Title"] = "玩家信息"})
InfoSec:Label({["Text"] = "玩家名称："..LocalPlayer.Name})
InfoSec:Label({["Text"] = "注入器："..identifyexecutor()})
InfoSec:Label({["Text"] = "玩家ID："..tostring(LocalPlayer.UserId)})
InfoSec:Label({["Text"] = "服务器ID："..tostring(game.PlaceId)})
InfoSec:Label({["Text"] = "地区："..game:GetService("LocalizationService").RobloxLocaleId})
InfoSec:Label({["Text"] = "客户端ID："..game:GetService("RbxAnalyticsService"):GetClientId()})

-- 通用分页
local Tab_General = Window:Tab({
    ["Locked"] = false,
    ["Title"] = "通用",
    ["Icon"] = "rbxassetid://18520370419"
})
local GeneralSec = Tab_General:Section({["Title"] = "功能模块"})

local Conn = {
    Speed = nil,
    Noclip = nil,
    InfiniteJump = nil,
    AutoInteract = nil
}
local GlobalSpeed = 16
local GlobalJump = 50
local AutoInteractToggle = false

GeneralSec:Slider({
    ["Title"] = "移动速度",
    ["Desc"] = "自定义人物移速数值",
    ["Step"] = 1,
    ["Value"] = {Min = 1, Default = 16, Max = 200},
    ["Callback"] = function(Value)
        GlobalSpeed = type(Value)=="table" and Value[1] or Value
    end
})

GeneralSec:Toggle({
    ["Title"] = "倍率移速开启",
    ["Desc"] = "滑块数值生效开关",
    ["Default"] = false,
    ["Callback"] = function(State)
        if Conn.Speed then Conn.Speed:Disconnect() Conn.Speed = nil end
        if State then
            Conn.Speed = RunService.Heartbeat:Connect(function()
                local Char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
                local Hum = Char:FindFirstChildOfClass("Humanoid")
                if Hum and Hum.MoveDirection.Magnitude>0 then
                    Char:TranslateBy(Hum.MoveDirection * GlobalSpeed / 10)
                end
            end)
        end
    end
})

GeneralSec:Slider({
    ["Title"] = "跳跃高度",
    ["Desc"] = "修改人物跳跃力度",
    ["Step"] = 2,
    ["Value"] = {Min = 20, Default = 50, Max = 250},
    ["Callback"] = function(Value)
        GlobalJump = type(Value)=="table" and Value[1] or Value
        local Char = LocalPlayer.Character
        if Char and Char:FindFirstChildOfClass("Humanoid") then
            Char.Humanoid.JumpPower = GlobalJump
        end
        LocalPlayer.CharacterAdded:Connect(function(NewChar)
            task.wait(0.2)
            local Hum = NewChar:FindFirstChildOfClass("Humanoid")
            if Hum then Hum.JumpPower = GlobalJump end
        end)
    end
})

GeneralSec:Toggle({
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

GeneralSec:Toggle({
    ["Title"] = "夜视",
    ["Desc"] = "全地图高亮",
    ["Default"] = false,
    ["Callback"] = function(State)
        game.Lighting.Ambient = State and Color3.new(1,1,1) or Color3.new(0,0,0)
    end
})

GeneralSec:Toggle({
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

GeneralSec:Toggle({
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

GeneralSec:Toggle({
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
            Char:MoveTo(Vector3.new(-25.95,84,3537.55))
            task.wait(0.15)
            local Seat = Instance.new("Seat",workspace)
            Seat.Name = "RN_HideSeat"
            Seat.Anchored = false
            Seat.CanCollide = false
            Seat.Transparency = 1
            Seat.Position = Vector3.new(-25.95,84,3537.55)
            local Weld = Instance.new("Weld",Seat)
            Weld.Part0 = Seat
            Weld.Part1 = Char:FindFirstChild("Torso") or Char:FindFirstChild("UpperTorso")
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

GeneralSec:Toggle({
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

GeneralSec:Toggle({
    ["Title"] = "快速交互",
    ["Desc"] = "缩短交互延迟",
    ["Default"] = false,
    ["Callback"] = function(State)
        _G.FastInteract = State
    end
})

GeneralSec:Button({
    ["Title"] = "染飞行",
    ["Desc"] = "加载R15飞行脚本",
    ["Callback"] = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/luoye123-hkzkm/-/refs/heads/main/%E9%A3%9E%E8%A1%8C.lua"))()
        Notify("通知","飞行已加载",1)
    end
})

GeneralSec:Button({
    ["Title"] = "踏空行走",
    ["Desc"] = "无地面浮空行走",
    ["Callback"] = function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/GhostPlayer352/Test4/main/Float'))()
        Notify("通知","踏空行走已加载",1)
    end
})

GeneralSec:Button({
    ["Title"] = "点击传送工具",
    ["Desc"] = "鼠标点击位置传送",
    ["Callback"] = function()
        local Mouse = LocalPlayer:GetMouse()
        local Tool = Instance.new("Tool")
        Tool.RequiresHandle = false
        Tool.Name = "点击传送工具"
        Tool.Activated:Connect(function()
            local Pos = Mouse.Hit + Vector3.new(0,2.5,0)
            local Char = LocalPlayer.Character
            if Char and Char:FindFirstChild("HumanoidRootPart") then
                Char.HumanoidRootPart.CFrame = CFrame.new(Pos.X,Pos.Y,Pos.Z)
            end
        end)
        Tool.Parent = LocalPlayer.Backpack
        Notify("通知","传送工具放入背包",1)
    end
})

GeneralSec:Button({
    ["Title"] = "快速互动永久",
    ["Desc"] = "永久关闭长按交互",
    ["Callback"] = function()
        game:GetService("ProximityPromptService").PromptButtonHoldBegan:Connect(function(Prompt)
            Prompt.MaxActivationDistance = Prompt.MaxActivationDistance
            Prompt.HoldDuration = 0
        end)
        Notify("通知","永久快速交互开启",1)
    end
})

GeneralSec:Button({
    ["Title"] = "玩家加入提示",
    ["Desc"] = "玩家进出弹窗提醒",
    ["Callback"] = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/boyscp/scriscriptsc/main/bbn.lua"))()
        Notify("通知","玩家提示系统加载",1)
    end
})

-- ESP分页
local Tab_ESP = Window:Tab({
    ["Locked"] = false,
    ["Title"] = "玩家透视",
    ["Icon"] = "rbxassetid://84830962019412"
})
local ESPsec = Tab_ESP:Section({["Title"] = "ESP系统",["Collapsible"] = true})

local ESPConfig = {
    Enabled = false,
    ShowName = true,
    ShowHealth = false,
    ShowDistance = false,
    ShowWeapon = false,
    ShowBackpack = false,
    ShowTeam = false,
    FillTransparency = 0.5,
    OutlineTransparency = 0.2,
    TextSize = 14,
    TeammateColor = Color3.fromRGB(0,255,100),
    EnemyColor = Color3.fromRGB(255,50,50),
    MaxDrawDistance = 2000,
    UpdateRate = 30
}
local Camera = workspace.CurrentCamera
local ESPCache = {}
local LastESPUpdate = 0

local function GetWeapon(Char)
    local Tool = Char:FindFirstChildOfClass("Tool")
    return Tool and Tool.Name or "无武器"
end

local function GetBagWeapons(Player)
    local list = {}
    if Player:FindFirstChild("Backpack") then
        for _,v in ipairs(Player.Backpack:GetChildren()) do
            if v:IsA("Tool") then table.insert(list,v.Name) end
        end
    end
    return #list>0 and table.concat(list,", ") or "无武器"
end

local function CreateESPObj(Player,Char)
    if ESPCache[Char] then return end
    local HRP = Char:WaitForChild("HumanoidRootPart")
    local Highlight = Instance.new("Highlight")
    Highlight.Adornee = Char
    Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    Highlight.FillTransparency = ESPConfig.FillTransparency
    Highlight.OutlineTransparency = ESPConfig.OutlineTransparency
    Highlight.Enabled = ESPConfig.Enabled
    Highlight.Parent = Char
    ESPCache[Char] = {Player=Player,HL=Highlight}
end

local function ClearESP()
    for char,data in pairs(ESPCache) do
        if data.HL then data.HL:Destroy() end
    end
    table.clear(ESPCache)
end

local function RefreshESP()
    local now = tick()
    if now-LastESPUpdate < 1/ESPConfig.UpdateRate then return end
    LastESPUpdate = now
    for _,plr in ipairs(Players:GetPlayers()) do
        if plr==LocalPlayer then continue end
        local char = plr.Character
        if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChildOfClass("Humanoid") then
            if not ESPCache[char] then CreateESPObj(plr,char) end
            local cache = ESPCache[char]
            local sameTeam = plr.Team==LocalPlayer.Team
            cache.HL.FillColor = sameTeam and ESPConfig.TeammateColor or ESPConfig.EnemyColor
            cache.HL.OutlineColor = sameTeam and ESPConfig.TeammateColor or ESPConfig.EnemyColor
            cache.HL.Enabled = ESPConfig.Enabled
        else
            if ESPCache[char] then
                ESPCache[char].HL:Destroy()
                ESPCache[char]=nil
            end
        end
    end
end

ESPsec:Toggle({["Title"]="开启ESP透视",["Default"]=false,["Callback"]=function(v)
    ESPConfig.Enabled = v
    if not v then ClearESP() end
end})
ESPsec:Toggle({["Title"]="显示玩家名字",["Default"]=true,["Callback"]=function(v) ESPConfig.ShowName=v end})
ESPsec:Toggle({["Title"]="显示血量",["Default"]=false,["Callback"]=function(v) ESPConfig.ShowHealth=v end})
ESPsec:Toggle({["Title"]="显示距离",["Default"]=false,["Callback"]=function(v) ESPConfig.ShowDistance=v end})
ESPsec:Toggle({["Title"]="显示手持武器",["Default"]=false,["Callback"]=function(v) ESPConfig.ShowWeapon=v end})
ESPsec:Toggle({["Title"]="显示背包武器",["Default"]=false,["Callback"]=function(v) ESPConfig.ShowBackpack=v end})
ESPsec:Toggle({["Title"]="区分队伍颜色",["Default"]=false,["Callback"]=function(v) ESPConfig.ShowTeam=v end})
ESPsec:ColorPicker({["Title"]="队友颜色",["Default"]=Color3.fromRGB(0,255,100),["Callback"]=function(c) ESPConfig.TeammateColor=c end})
ESPsec:ColorPicker({["Title"]="敌人颜色",["Default"]=Color3.fromRGB(255,50,50),["Callback"]=function(c) ESPConfig.EnemyColor=c end})

RunService.RenderStepped:Connect(RefreshESP)

print("脚本全部加载完成")
