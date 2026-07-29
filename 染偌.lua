function Notify(Title1, Text1, Icon1, Time1)
  game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = Title1,
    Text = Text1,
    Icon = Icon1,
    Duration = Time1,
  })
end
Notify("欢迎使用染偌", "作者染偌", "rbxassetid://17360377302", 3)
Notify("永久免费", "没有盈利","rbxassetid://17360377302",3)
Notify("拒绝跑路", "拒绝倒卖","rbxassetid://17360377302",3)
Notify("启动完成", "祝你玩的开心","rbxassetid://17360377302",5)

local mt = getrawmetatable(game)
local old = mt.__newindex
local Value = {["Title of the library"] = "染偌",["Tab 1"] = "标签1",["Section"] = "部分"}
setreadonly(mt, false)
mt.__newindex = newcclosure(function(tt, kk, v)
	if kk == "Text" and (tt:IsA("TextLabel") or tt:IsA("TextButton") or tt:IsA("TextBox")) then v = Value[v] or v end
	return old(tt, kk, v)
end)
setreadonly(mt, true)

local OrionLib = loadstring(game:HttpGet('https://raw.githubusercontent.com/jensonhirst/Orion/main/source'))()
local Window = OrionLib:MakeWindow({Name = "Title of the library", HidePremium = false, SaveConfig = true, ConfigFolder = "OrionTest"})

local MainTab = Window:MakeTab({Name = "公告", Icon = "rbxassetid://4483345998", PremiumOnly = false})
local NoticeSec = MainTab:AddSection({Name = "公告内容"})
local NoticeText = NoticeSec:AddLabel("染偌制作 请勿二改 倒卖 永久公益免费 感谢大家的支持～")
task.spawn(function()
	local txt = NoticeText.Instance:FindFirstChildWhichIsA("TextLabel", true)
	local h = 0
	while task.wait(0.05) do h = (h + 0.012) % 1 txt.TextColor3 = Color3.fromHSV(h, 1, 1) end
end)

local InfoSec = MainTab:AddSection({Name = "玩家信息"})
InfoSec:AddLabel("玩家名："..game.Players.LocalPlayer.Name)
InfoSec:AddLabel("注入器："..identifyexecutor())
InfoSec:AddLabel("玩家ID:" .. tostring(game.Players.LocalPlayer.UserId))
InfoSec:AddLabel("服务器ID:"..tostring(game.GameId))
InfoSec:AddLabel("地区：" .. game:GetService("LocalizationService").RobloxLocaleId)
InfoSec:AddLabel("客户端ID:" .. game:GetService("RbxAnalyticsService"):GetClientId())

local UniversalTab = Window:MakeTab({Name = "通用", Icon = "rbxassetid://4483345998", PremiumOnly = false})
local Speed = 1
local sudu = nil
local Jump = nil
local autoInteract = false

UniversalTab:AddToggle({Name = "速度 (开/关)",Default = false,Callback = function(v)
	if v then
		sudu = game:GetService("RunService").Heartbeat:Connect(function()
			local lp = game.Players.LocalPlayer
			if lp.Character and lp.Character:FindFirstChild("Humanoid") then
				local hum = lp.Character.Humanoid
				if hum.MoveDirection.Magnitude > 0 then lp.Character:TranslateBy(hum.MoveDirection * Speed / 10) end
			end
		end)
	elseif sudu then sudu:Disconnect() sudu = nil end
end})

UniversalTab:AddTextbox({Name = "速度设置",Default = tostring(Speed),TextDisappear = false,Callback = function(v) local num = tonumber(v) if num then Speed = num end end})
UniversalTab:AddTextbox({Name = "跳跃高度",Default = "",TextDisappear = true,Callback = function(v) local c = game.Players.LocalPlayer.Character if c and c:FindFirstChild("Humanoid") then c.Humanoid.JumpPower = tonumber(v) or 50 end end})

local Noclip,Stepped
UniversalTab:AddToggle({Name = "穿墙",Default = false,Callback = function(v)
	if v then
		Noclip = true
		Stepped = game:GetService("RunService").Stepped:Connect(function()
			if Noclip then
				local plr = game.Players.LocalPlayer.Name
				if workspace:FindFirstChild(plr) then
					for _,part in pairs(workspace[plr]:GetChildren()) do if part:IsA("BasePart") then part.CanCollide = false end end
				end
			end
		end)
	else
		Noclip = false if Stepped then Stepped:Disconnect() end
	end
end})

UniversalTab:AddToggle({Name = "夜视",Default = false,Callback = function(v) game.Lighting.Ambient = v and Color3.new(1,1,1) or Color3.new(0,0,0) end})
UniversalTab:AddButton({Name = "染飞行",Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/luoye123-hkzkm/-/refs/heads/main/%E9%A3%9E%E8%A1%8C.lua"))() end})

UniversalTab:AddToggle({Name = "无限跳",Default = false,Callback = function(v)
	if Jump then Jump:Disconnect() Jump = nil end
	if v then Jump = game.UserInputService.JumpRequest:Connect(function() local c = game.Players.LocalPlayer.Character if c and c:FindFirstChild("Humanoid") then c.Humanoid:ChangeState("Jumping") end end) end
end})

UniversalTab:AddToggle({Name = "停止移动",Default = false,Callback = function(enabled)
	local lp = game.Players.LocalPlayer
	local char = lp.Character or lp.CharacterAdded:Wait()
	for _,obj in pairs(char:GetChildren()) do if obj:IsA("BasePart") then obj.Anchored = enabled end end
end})

UniversalTab:AddButton({Name = "踏空行走",Callback = function() loadstring(game:HttpGet('https://raw.githubusercontent.com/GhostPlayer352/Test4/main/Float'))() end})
UniversalTab:AddButton({Name = "点击传送工具",Callback = function()
local mouse = game.Players.LocalPlayer:GetMouse()
local tool = Instance.new("Tool")
tool.RequiresHandle = false
tool.Name = "点击传送工具"
tool.Activated:Connect(function()
	local pos = mouse.Hit+Vector3.new(0,2.5,0)
	game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(pos.X,pos.Y,pos.Z)
end)
tool.Parent = game.Players.LocalPlayer.Backpack
end})

UniversalTab:AddToggle({Name="隐身〖实用〗",Default=false,Callback=function(state)
    if state then
        local savedpos = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
        task.wait()
        game.Players.LocalPlayer.Character:MoveTo(Vector3.new(-25.95, 84, 3537.55))
        task.wait(.15)
        local Seat = Instance.new('Seat', workspace)
        Seat.Anchored = false
        Seat.CanCollide = false
        Seat.Name = 'invischair'
        Seat.Transparency = 1
        Seat.Position = Vector3.new(-25.95, 84, 3537.55)
        local Weld = Instance.new("Weld", Seat)
        Weld.Part0 = Seat
        Weld.Part1 = game.Players.LocalPlayer.Character:FindFirstChild("Torso") or game.Players.LocalPlayer.Character.UpperTorso
        task.wait()
        Seat.CFrame = savedpos
        for _, part in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") or part:IsA("Decal") then
                part.Transparency = 0.5
            end
        end
    else
        local invisChair = workspace:FindFirstChild('invischair')
        if invisChair then
            invisChair:Destroy()
        end
        for _, part in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") or part:IsA("Decal") then
                part.Transparency = 0
            end
        end
    end
end})

UniversalTab:AddToggle({Name="自动互动",Default=false,Callback=function(state)
    if state then
        autoInteract = true
        task.spawn(function()
            while autoInteract do
                for _,descendant in pairs(workspace:GetDescendants()) do
                    if descendant:IsA("ProximityPrompt") then
                        fireproximityprompt(descendant)
                    end
                end
                task.wait(0.25)
            end
        end)
    else
        autoInteract = false
    end
end})

UniversalTab:AddButton({Name="快速互动",Callback=function() 
    game.ProximityPromptService.PromptButtonHoldBegan:Connect(function(prompt)
        prompt.HoldDuration = 0
    end)
end})

UniversalTab:AddToggle({Name="快速交互",Default=false,Callback=function(Fast)
    Faster = Fast
end})

UniversalTab:AddButton({Name="玩家加入提示",Callback=function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/boyscp/scriscriptsc/main/bbn.lua"))()
end})

local ESPTab = Window:MakeTab({Name = "玩家透视",Icon = "rbxassetid://84830962019412",PremiumOnly = false})
local ESPSec = ESPTab:AddSection({Name = "ESP系统※",Collapsible = true})

local function GetPlayerWeapon(char) local t = char:FindFirstChildOfClass("Tool") return t and t.Name or "没武器" end
local function GetBackpackWeapons(plr)
	local list = {}
	if plr.Backpack then for _,tool in pairs(plr.Backpack:GetChildren()) do if tool:IsA("Tool") then table.insert(list,tool.Name) end end end
	return #list>0 and table.concat(list,", ") or "没武器"
end

local ESPConfig = {Enabled=false,ShowName=true,ShowHealth=false,ShowDistance=false,ShowWeapon=false,ShowTeam=false,ShowBackpack=false,FillTransparency=0.5,OutlineTransparency=0.2,TextSize=14,TextOutline=true,TeammateColor=Color3.fromRGB(0,255,100),EnemyColor=Color3.fromRGB(255,50,50),MaxDistance=2000,UseDistanceFade=true,TeamCheck=true,HighlightEnabled=true,BoxOutlineEnabled=true,WallhackEnabled=false,NameTagSize=1,HealthBarEnabled=true,DistanceScale=true,UpdateRate=30}
local Players,Camera,RunService = game:GetService("Players"),workspace.CurrentCamera,game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local ESPCache,LastUpdateTime = {},0

local function CalcVis(dis,maxd) if dis>maxd then return 0 end local fs = maxd*0.8 if dis>fs then return 1-((dis-fs)/(maxd-fs)) end return 1 end
local function GetColor(esp) local tm = ESPConfig.TeamCheck and esp.Player.Team==LocalPlayer.Team return tm and ESPConfig.TeammateColor or ESPConfig.EnemyColor end
local function WallCheck(char) if not ESPConfig.WallhackEnabled then return false end local hrp = char:FindFirstChild("HumanoidRootPart") if not hrp then return true end local ray = Ray.new(Camera.CFrame.Position,(hrp.Position-Camera.CFrame.Position).Unit*100) local hit = workspace:FindPartOnRayWithIgnoreList(ray,{Camera,LocalPlayer.Character,char}) return hit~=nil end

local function CreateESP(char,plr)
	if not char or ESPCache[char] then return end
	local hrp = char:FindFirstChild("HumanoidRootPart") if not hrp then return end
	local esp = {Character=char,Player=plr,Connections={}}
	local hl = Instance.new("Highlight")
	hl.FillColor = Color3.new(1,1,1) hl.OutlineColor = Color3.new(0,0,0) hl.FillTransparency = ESPConfig.FillTransparency
	hl.OutlineTransparency = ESPConfig.OutlineTransparency hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop hl.Enabled = ESPConfig.Enabled and ESPConfig.HighlightEnabled hl.Parent = char
	local bill = Instance.new("BillboardGui")
	bill.AlwaysOnTop = true bill.Size = UDim2.new(0,200*ESPConfig.NameTagSize,0,60*ESPConfig.NameTagSize) bill.StudsOffset = Vector3.new(0,3,0) bill.Adornee = hrp bill.Enabled = ESPConfig.Enabled bill.MaxDistance = ESPConfig.MaxDistance bill.Parent = char
	local txt = Instance.new("TextLabel")
	txt.BackgroundTransparency = 1 txt.Size = UDim2.new(1,0,1,0) txt.TextColor3 = Color3.new(1,1,1) txt.TextSize = ESPConfig.TextSize*ESPConfig.NameTagSize
	txt.Font = Enum.Font.SourceSansBold txt.TextStrokeTransparency = ESPConfig.TextOutline and 0.5 or 1 txt.TextStrokeColor3 = Color3.new(0,0,0) txt.Parent = bill
	local hpFill
	if ESPConfig.HealthBarEnabled then
		local hpBar = Instance.new("Frame") hpBar.BackgroundColor3 = Color3.new(0.2,0.2,0.2) hpBar.BorderSizePixel = 0 hpBar.Size = UDim2.new(1,0,0,4*ESPConfig.NameTagSize) hpBar.Position = UDim2.new(0,0,1,0) hpBar.Parent = bill
		hpFill = Instance.new("Frame") hpFill.BackgroundColor3 = Color3.new(0,1,0) hpFill.BorderSizePixel = 0 hpFill.Size = UDim2.new(1,0,1,0) hpFill.Parent = hpBar
	end
	esp.Highlight,esp.Billboard,esp.TextLabel,esp.HealthBar = hl,bill,txt,hpFill
	esp.Connections.Ancestry = char.AncestryChanged:Connect(function(_,p) if not p then task.spawn(function() ESPCache[char]=nil hl:Destroy() bill:Destroy() end) end end)
	ESPCache[char]=esp
end

local function UpdateESP()
	local now = tick() if now-LastUpdateTime < 1/ESPConfig.UpdateRate then return end LastUpdateTime=now
	if not ESPConfig.Enabled then for _,esp in pairs(ESPCache) do esp.Highlight.Enabled=false esp.Billboard.Enabled=false end return end
	for char,esp in pairs(ESPCache) do
		if not char or not char.Parent then ESPCache[char]=nil continue end
		local hrp = char:FindFirstChild("HumanoidRootPart") if not hrp then continue end
		local hum = char:FindFirstChildOfClass("Humanoid") if not hum or hum.Health<=0 then esp.Highlight.Enabled=false esp.Billboard.Enabled=false continue end
		local dis = (hrp.Position-Camera.CFrame.Position).Magnitude local vis = CalcVis(dis,ESPConfig.MaxDistance) if vis<=0 then esp.Highlight.Enabled=false esp.Billboard.Enabled=false continue end
		local col = GetColor(esp) local walled = WallCheck(char)
		esp.Highlight.FillColor = col esp.Highlight.FillTransparency = ESPConfig.FillTransparency + (0.3*(1-vis))
		esp.Highlight.OutlineTransparency = ESPConfig.BoxOutlineEnabled and (ESPConfig.OutlineTransparency + (0.3*(1-vis))) or 1
		esp.Highlight.Enabled = ESPConfig.HighlightEnabled and (not walled or ESPConfig.WallhackEnabled)
		local txtTab = {}
		if ESPConfig.ShowName then table.insert(txtTab,esp.Player.Name) end
		if ESPConfig.ShowHealth then table.insert(txtTab,string.format("HP:%d/%d",math.floor(hum.Health),math.floor(hum.MaxHealth))) end
		if ESPConfig.ShowDistance then table.insert(txtTab,math.floor(dis).."m") end
		if ESPConfig.ShowWeapon then table.insert(txtTab,GetPlayerWeapon(char)) end
		if ESPConfig.ShowBackpack then local bw = GetBackpackWeapons(esp.Player) if bw~="没武器" then table.insert(txtTab,"背包:"..bw) end end
		if ESPConfig.ShowTeam then local tm = ESPConfig.TeamCheck and esp.Player.Team==LocalPlayer.Team table.insert(txtTab,tm and "队友" or "敌人") end
		if walled and ESPConfig.WallhackEnabled then table.insert(txtTab,"[墙内☠️]") end
		esp.TextLabel.Text = table.concat(txtTab," | ")
		esp.TextLabel.TextColor3 = col
		esp.TextLabel.TextTransparency = ESPConfig.UseDistanceFade and (0.3*(1-vis)) or 0
		esp.TextLabel.TextSize = ESPConfig.TextSize * (ESPConfig.DistanceScale and math.clamp(1.5-(dis/1000)*0.5,0.8,1.5) or 1)*ESPConfig.NameTagSize
		esp.Billboard.Enabled = #txtTab>0 and (not walled or ESPConfig.WallhackEnabled)
		if esp.HealthBar then local pct = hum.Health/hum.MaxHealth esp.HealthBar.Size = UDim2.new(pct,0,1,0) esp.HealthBar.BackgroundColor3 = Color3.new(1-pct,pct,0) end
	end
end

local function ResetESP()
	for _,esp in pairs(ESPCache) do esp.Highlight:Destroy() esp.Billboard:Destroy() end ESPCache={}
	if ESPConfig.Enabled then for _,plr in pairs(Players:GetPlayers()) do if plr~=LocalPlayer and plr.Character then CreateESP(plr.Character,plr) end end end
end

local function InitPlayer(plr)
	if plr==LocalPlayer then return end
	local function CharAdd(char) task.wait(0.3) if ESPConfig.Enabled then CreateESP(char,plr) end end
	if plr.Character then task.spawn(CharAdd,plr.Character) end
	plr.CharacterAdded:Connect(CharAdd)
	plr.CharacterRemoving:Connect(function(c) if ESPCache[c] then ESPCache[c].Highlight:Destroy() ESPCache[c].Billboard:Destroy() ESPCache[c]=nil end end)
end

RunService.Heartbeat:Connect(function() if LocalPlayer.Character then pcall(UpdateESP) end end)
Players.PlayerAdded:Connect(InitPlayer)

ESPSec:AddToggle({Name="开启ESP",Default=false,Callback=function(state)
	ESPConfig.Enabled = state ResetESP()
end})
ESPSec:AddToggle({Name="内部发光",Default=false,Callback=function(v) ESPConfig.HighlightEnabled=v end})
ESPSec:AddToggle({Name="方框描边",Default=false,Callback=function(v) ESPConfig.BoxOutlineEnabled=v end})
ESPSec:AddToggle({Name="显示玩家名字",Default=false,Callback=function() UpdateESP() end})
ESPSec:AddColorPicker({Name="队友颜色",Default=Color3.fromRGB(0,255,100),Callback=function(c) ESPConfig.TeammateColor=c UpdateESP() end})
ESPSec:AddToggle({Name="显示血量",Default=false,Callback=function() UpdateESP() end})
ESPSec:AddToggle({Name="显示距离",Default=false,Callback=function() UpdateESP() end})
ESPSec:AddToggle({Name="显示武器",Default=false,Callback=function() UpdateESP() end})
ESPSec:AddToggle({Name="显示背包",Default=false,Callback=function() UpdateESP() end})
ESPSec:AddColorPicker({Name="敌人颜色",Default=Color3.fromRGB(255,50,50),Callback=function(c) ESPConfig.EnemyColor=c UpdateESP() end})
ESPSec:AddToggle({Name="显示队伍",Default=false,Callback=function() UpdateESP() end})
ESPSec:AddToggle({Name="队伍检测",Default=false,Callback=function() UpdateESP() end})
ESPSec:AddToggle({Name="穿墙显示",Default=false,Callback=function() UpdateESP() end})
ESPSec:AddToggle({Name="距离缩放",Default=false,Callback=function() UpdateESP() end})

local Tab = Window:MakeTab({Name = "Tab 1", Icon = "rbxassetid://4483345998", PremiumOnly = false})
local Section = Tab:AddSection({Name = "Section"})

OrionLib:Init()
