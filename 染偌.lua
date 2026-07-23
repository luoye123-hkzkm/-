local mt = getrawmetatable(game)
local old = mt.__newindex
local Value = {
	["Title of the library"] = "测试！！",
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

UniversalTab:AddSlider({
	Name = "速度设置",
	Min = 1,
	Max = 1000,
	Default = 1,
	Callback = function(v)
		Speed = v
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

UniversalTab:AddButton({
	Name = "点击传送工具",
	Callback = function()
mouse = game.Players.LocalPlayer:GetMouse() tool = Instance.new("Tool") tool.RequiresHandle = false tool.Name = "[FE] TELEPORT TOOL" tool.Activated:connect(function() local pos = mouse.Hit+Vector3.new(0,2.5,0) pos = CFrame.new(pos.X,pos.Y,pos.Z) game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = pos end) tool.Parent = game.Players.LocalPlayer.Backpack
	end
})

local Tab = Window:MakeTab({Name = "Tab 1", Icon = "rbxassetid://4483345998", PremiumOnly = false})
local Section = Tab:AddSection({Name = "Section"})

OrionLib:Init()
