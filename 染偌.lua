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
local Value = {
	["Title of the library"] = "染偌",
	["Tab 1"] = "标签1",
	["Section"] = "部分"
}
setreadonly(mt, false)
mt.__newindex = newcclosure(function(tt, kk, v)
	if kk == "Text" and (tt:IsA("TextLabel") or tt:IsA("TextButton") or tt:IsA("TextBox")) then
		v = Value[v] or v
	end
	return old(tt, kk, v)
end)
setreadonly(mt, true)

local OrionLib = loadstring(game:HttpGet('https://raw.githubusercontent.com/jensonhirst/Orion/main/source'))()
local Window = OrionLib:MakeWindow({Name = "Title of the library", HidePremium = false, SaveConfig = true, ConfigFolder = "OrionTest"})
local winShow = true
UniversalTab:AddButton({
	Name = "展开/收起面板",
	Callback = function()
		winShow = not winShow
		Window.Instance.Visible = winShow
	end
})

local MainTab = Window:MakeTab({Name = "公告", Icon = "rbxassetid://4483345998", PremiumOnly = false})
local NoticeSec = MainTab:AddSection({Name = "公告内容"})
local NoticeText = NoticeSec:AddLabel("染偌制作 请勿二改 倒卖 永久公益免费 感谢大家的支持～")
task.spawn(function()
	local txt = NoticeText.Instance:FindFirstChildWhichIsA("TextLabel", true)
	local h = 0
	while task.wait(0.05) do
		h = (h + 0.012) % 1
		txt.TextColor3 = Color3.fromHSV(h, 1, 1)
	end
end)

local InfoSec = MainTab:AddSection({Name = "玩家信息"})
InfoSec:AddLabel("玩家名："..game.Players.LocalPlayer.Name)
InfoSec:AddLabel("注入器："..identifyexecutor())

local UniversalTab = Window:MakeTab({Name = "通用", Icon = "rbxassetid://4483345998", PremiumOnly = false})
local Speed = 1
local sudu = nil
local Jump = false
local JumpConn = nil

UniversalTab:AddToggle({
	Name = "速度 (开/关)",
	Default = false,
	Callback = function(v)
		if v == true then
			sudu = game:GetService("RunService").Heartbeat:Connect(function()
				if game:GetService("Players").LocalPlayer.Character and game:GetService("Players").LocalPlayer.Character.Humanoid and game:GetService("Players").LocalPlayer.Character.Humanoid.Parent then
					if game:GetService("Players").LocalPlayer.Character.Humanoid.MoveDirection.Magnitude > 0 then
						game:GetService("Players").LocalPlayer.Character:TranslateBy(game:GetService("Players").LocalPlayer.Character.Humanoid.MoveDirection * Speed / 10)
					end
				end
			end)
		elseif not v and sudu then
			sudu:Disconnect()
			sudu = nil
		end
	end
})

UniversalTab:AddTextbox({
	Name = "速度设置",
	Default = tostring(Speed),
	TextDisappear = false,
	Callback = function(v)
		local num = tonumber(v)
		if num then
			Speed = num
		end
	end
})

UniversalTab:AddTextbox({
	Name = "跳跃高度",
	Default = "",
	TextDisappear = true,
	Callback = function(Value)
		local char = game.Players.LocalPlayer.Character
		if char and char:FindFirstChild("Humanoid") then
			char.Humanoid.JumpPower = tonumber(Value) or 50
		end
	end
})

UniversalTab:AddToggle({
	Name = "穿墙",
	Default = false,
	Callback = function(Value)
		if Value then
		    Noclip = true
		    Stepped = game.RunService.Stepped:Connect(function()
			    if Noclip == true then
				    for a, b in pairs(game.Workspace:GetChildren()) do
                        if b.Name == game.Players.LocalPlayer.Name then
                            for i, v in pairs(game.Workspace[game.Players.LocalPlayer.Name]:GetChildren()) do
                                if v:IsA("BasePart") then
                                    v.CanCollide = false
                                end
                            end
                        end
                    end
			    else
				    Stepped:Disconnect()
			    end
		    end)
	    else
		    Noclip = false
	    end
	end
})

UniversalTab:AddToggle({
	Name = "夜视",
	Default = false,
	Callback = function(Value)
		if Value then
		    game.Lighting.Ambient = Color3.new(1, 1, 1)
		else
		    game.Lighting.Ambient = Color3.new(0, 0, 0)
		end
	end
})

UniversalTab:AddButton({
	Name = "染飞行",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/luoye123-hkzkm/-/refs/heads/main/%E9%A3%9E%E8%A1%8C.lua"))()
	end
})

UniversalTab:AddToggle({
	Name = "无限跳",
	Default = false,
	Callback = function(Value)
        Jump = Value
        if JumpConn then
            JumpConn:Disconnect()
            JumpConn = nil
        end
        if Jump then
            JumpConn = game.UserInputService.JumpRequest:Connect(function()
                if Jump and game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character.Humanoid then
                    game.Players.LocalPlayer.Character.Humanoid:ChangeState("Jumping")
                end
            end)
        end
    end
})

UniversalTab:AddToggle({
	Name = "停止移动",
	Default = false,
	Callback = function(enabled)
  		local localPlayer = game.Players.LocalPlayer
  		local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
  		if enabled then
    		for _, child in pairs(character:GetChildren()) do
      			if child:IsA("BasePart") then
        			child.Anchored = true
      			end
    		end
  		else
    		for _, child in pairs(character:GetChildren()) do
      			if child:IsA("BasePart") then
        			child.Anchored = false
      			end
    		end
  		end
	end
})

UniversalTab:AddButton({
	Name = "点击传送工具",
	Callback = function()
mouse = game.Players.LocalPlayer:GetMouse() tool = Instance.new("Tool") tool.RequiresHandle = false tool.Name = "[FE] TELEPORT TOOL" tool.Activated:connect(function() local pos = mouse.Hit+Vector3.new(0,2.5,0) pos = CFrame.new(pos.X,pos.Y,pos.Z) game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = pos end) tool.Parent = game.Players.LocalPlayer.Backpack
	end
})

local Tab = Window:MakeTab({Name = "Tab 1", Icon = "rbxassetid://4483345998", PremiumOnly = false})
local Section = Tab:AddSection({Name = "Section"})

OrionLib:Init()
