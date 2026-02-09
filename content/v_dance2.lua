-- update force 2

cloneref = cloneref or function(o) return o end

local Debris = cloneref(game:GetService("Debris"))
local Players = cloneref(game:GetService("Players"))
local RunService = cloneref(game:GetService("RunService"))
local StarterGui = cloneref(game:GetService("StarterGui"))
local HttpService = cloneref(game:GetService("HttpService"))
local TextService = cloneref(game:GetService("TextService"))
local TweenService = cloneref(game:GetService("TweenService"))
local TextChatService = cloneref(game:GetService("TextChatService"))
local UserInputService = cloneref(game:GetService("UserInputService"))
local ContextActionService = cloneref(game:GetService("ContextActionService"))

local Player = Players.LocalPlayer

local modules = {}
local function AddModule(m)
	table.insert(modules, m)
end

AddModule(function()
	local m = {}
	m.ModuleType = "DANCE"
	m.Name = "It's Going Down"
	m.Description = "first dance in v_dance2.lua"
	m.Assets = {"GoingDown.anim", "GoingDown.mp3"}

	m.Config = function(parent: GuiBase2d)
	end

	local animator = nil
	m.Init = function(figure: Model)
		SetOverrideDanceMusic(AssetGetContentId("GoingDown.mp3"), "IT'S GOING DOWN", 1)
		animator = AnimLib.Animator.new()
		animator.rig = figure
		animator.looped = true
		animator.track = AnimLib.Track.fromfile(AssetGetPathFromFilename("GoingDown.anim"))
	end
	m.Update = function(dt: number, figure: Model)
		animator:Step(GetOverrideDanceMusicTime())
	end
	m.Destroy = function(figure: Model?)
		animator = nil
	end
	return m
end)

AddModule(function()
	local m = {}
	m.ModuleType = "DANCE"
	m.Name = "Results"
	m.Description = "real ones know ts from pizza tower\neffortless upload"
	m.Assets = {"Results.anim", "Results.mp3"}

	m.Config = function(parent: GuiBase2d)
	end

	local animator = nil
	m.Init = function(figure: Model)
		SetOverrideDanceMusic(AssetGetContentId("Results.mp3"), "Results! - PT Sugary Spire OST", 1)
		animator = AnimLib.Animator.new()
		animator.rig = figure
		animator.looped = false
		animator.track = AnimLib.Track.fromfile(AssetGetPathFromFilename("Results.anim"))
	end
	m.Update = function(dt: number, figure: Model)
		animator:Step(GetOverrideDanceMusicTime())
	end
	m.Destroy = function(figure: Model?)
		animator = nil
	end
	return m
end)

AddModule(function()
	local m = {}
	m.ModuleType = "DANCE"
	m.Name = "Birdbrain"
	m.Description = "hey teto you should wish that you could\nc- c- c- c- c- CUHHHH\nFAHHHHHH\n\nSo... ####!!"
	m.Assets = {"Birdbrain.anim", "BirdbrainLaggy.anim", "Birdbrain.mp3", "BirdbrainAlt.mp3"}

	m.Lag = false
	m.Config = function(parent: GuiBase2d)
		Util_CreateSwitch(parent, "Make it laggy", m.Lag).Changed:Connect(function(val)
			m.Lag = val
		end)
	end
	m.LoadConfig = function(save: any)
		m.Lag = not not save.Lag
	end
	m.SaveConfig = function()
		return {
			Lag = m.Lag
		}
	end

	local animator = nil
	m.Init = function(figure: Model)
		if math.random() < 0.1 then
			SetOverrideDanceMusic(AssetGetContentId("BirdbrainAlt.mp3"), "BIRDBRAIN ft. Kasane Teto", 1)
		else
			SetOverrideDanceMusic(AssetGetContentId("Birdbrain.mp3"), "BIRDBRAIN ft. Kasane Teto", 1)
		end
		animator = AnimLib.Animator.new()
		animator.rig = figure
		animator.looped = false
		if m.Lag then
			animator.track = AnimLib.Track.fromfile(AssetGetPathFromFilename("BirdbrainLaggy.anim"))
		else
			animator.track = AnimLib.Track.fromfile(AssetGetPathFromFilename("Birdbrain.anim"))
		end
	end
	m.Update = function(dt: number, figure: Model)
		animator:Step(GetOverrideDanceMusicTime())
	end
	m.Destroy = function(figure: Model?)
		animator = nil
	end
	return m
end)

AddModule(function()
	local m = {}
	m.ModuleType = "DANCE"
	m.Name = "Terraria Swing dance"
	m.Description = "enjoy enjoy enjoy enjoy enjoy enjoy\nenjoy enjoy enjoy enjoy\nenjoy enjoy enjoy enjoy\n\nthis is my first \"linearish\" animation"
	m.Assets = {"BusetA.anim", "BusetB.anim", "Buset.mp3"}

	m.MoveForward = false
	m.Config = function(parent: GuiBase2d)
		Util_CreateSwitch(parent, "Move Forward", m.MoveForward).Changed:Connect(function(val)
			m.MoveForward = val
		end)
	end
	m.LoadConfig = function(save: any)
		m.MoveForward = not not save.MoveForward
	end
	m.SaveConfig = function()
		return {
			MoveForward = m.MoveForward
		}
	end

	local allbusets = {{9, 27.216}, {31.945, 49.95}, {54.557, 72.494}, {77.534, 95.14}}

	local animator1, animator2 = nil, nil
	m.Init = function(figure: Model)
		SetOverrideDanceMusic(AssetGetContentId("Buset.mp3"), "MONTAGEM VOZES TALENTINHO", 1)
		animator1 = AnimLib.Animator.new()
		animator1.rig = figure
		animator1.looped = true
		animator1.track = AnimLib.Track.fromfile(AssetGetPathFromFilename("BusetA.anim"))
		animator2 = AnimLib.Animator.new()
		animator2.rig = figure
		animator2.looped = false
		animator2.track = AnimLib.Track.fromfile(AssetGetPathFromFilename("BusetB.anim"))
	end
	m.Update = function(dt: number, figure: Model)
		local t = GetOverrideDanceMusicTime()
		local s, e = 6767, 6768
		for i=1, #allbusets do
			if t < allbusets[i][2] then
				s, e = allbusets[i][1], allbusets[i][2]
				break
			end
		end
		local m2 = (e - s) / 32
		local t2 = ((t - s) / m2) + 0.28
		if t2 < -8 then
			animator1:Step(t)
		elseif t2 < 0 then
			if t2 < -2 and m.MoveForward then
				local root = figure:FindFirstChild("HumanoidRootPart")
				root.CFrame *= CFrame.new(0, 0, -dt * 3.5 * figure:GetScale())
			end
			animator2:Step(4.8 * (1 - (t2 / -8)))
		else
			animator2:Step(4.8 + (t2 % 1) * 0.57)
		end
	end
	m.Destroy = function(figure: Model?)
		animator = nil
	end
	return m
end)

AddModule(function()
	local m = {}
	m.ModuleType = "DANCE"
	m.Name = "Thriller"
	m.Description = "the moonwalk guy apparently danced this"
	m.Assets = {"Thriller.anim", "Thriller.mp3"}

	m.Config = function(parent: GuiBase2d)
	end

	local animator = nil
	local start = 0
	m.Init = function(figure: Model)
		SetOverrideDanceMusic(AssetGetContentId("Thriller.mp3"), "Michael Jackson - Thriller", 1)
		start = os.clock()
		animator = AnimLib.Animator.new()
		animator.rig = figure
		animator.looped = true
		animator.speed = 1
		animator.track = AnimLib.Track.fromfile(AssetGetPathFromFilename("Thriller.anim"))
	end
	m.Update = function(dt: number, figure: Model)
		local t = os.clock()
		animator:Step(t - start)
	end
	m.Destroy = function(figure: Model?)
		animator = nil
	end
	return m
end)

AddModule(function()
	local m = {}
	m.ModuleType = "DANCE"
	m.Name = "Monster Mash"
	m.Description = "drink the potion that makes you dance!"
	m.Assets = {"RetroMonsterMash.anim"}

	m.Config = function(parent: GuiBase2d)
	end

	local animator = nil
	local start = 0
	m.Init = function(figure: Model)
		SetOverrideDanceMusic("rbxassetid://35930009", "where did this even come from", 1)
		start = os.clock()
		animator = AnimLib.Animator.new()
		animator.rig = figure
		animator.looped = true
		animator.speed = 1
		animator.track = AnimLib.Track.fromfile(AssetGetPathFromFilename("RetroMonsterMash.anim"))
	end
	m.Update = function(dt: number, figure: Model)
		local t = os.clock()
		animator:Step(t - start)
	end
	m.Destroy = function(figure: Model?)
		animator = nil
	end
	return m
end)

AddModule(function()
	local m = {}
	m.ModuleType = "DANCE"
	m.Name = "So Retro"
	m.Description = "forsakened\n\nnear at the end there is the literal super mario world tune lol"
	m.Assets = {"RetroSoRetro.anim", "RetroSoRetro.mp3"}

	m.Config = function(parent: GuiBase2d)
	end

	local animator = nil
	local start = 0
	m.Init = function(figure: Model)
		SetOverrideDanceMusic(AssetGetContentId("RetroSoRetro.mp3"), "so retro", 1)
		start = os.clock()
		animator = AnimLib.Animator.new()
		animator.rig = figure
		animator.looped = true
		animator.speed = 1
		animator.track = AnimLib.Track.fromfile(AssetGetPathFromFilename("RetroSoRetro.anim"))
	end
	m.Update = function(dt: number, figure: Model)
		local t = os.clock()
		animator:Step(t - start)
	end
	m.Destroy = function(figure: Model?)
		animator = nil
	end
	return m
end)

AddModule(function()
	local m = {}
	m.ModuleType = "DANCE"
	m.Name = "Lux"
	m.Description = "help me find what tune this is\n\nnot cuz i like it\ni actually hate it"
	m.Assets = {"Lux.anim", "Lux.mp3"}

	m.Config = function(parent: GuiBase2d)
	end

	local animator = nil
	m.Init = function(figure: Model)
		SetOverrideDanceMusic(AssetGetContentId("Lux.mp3"), "idk this one", 1, NumberRange.new(0, 5.88))
		animator = AnimLib.Animator.new()
		animator.rig = figure
		animator.looped = false
		animator.map = {{0, 5.88}, {0, 5.69999}}
		animator.track = AnimLib.Track.fromfile(AssetGetPathFromFilename("Lux.anim"))
	end
	m.Update = function(dt: number, figure: Model)
		animator:Step(GetOverrideDanceMusicTime())
	end
	m.Destroy = function(figure: Model?)
		animator = nil
	end
	return m
end)

AddModule(function()
	local m = {}
	m.ModuleType = "DANCE"
	m.Name = "Jitterbug"
	m.Description = "animator: @maybewasangery\nno hes not the Animator instance\ni meant a literal animator\nguy who makes animation"
	m.Assets = {"Jitterbug.anim", "Jitterbug1.mp3", "Jitterbug2.mp3"}

	m.TobyFox = false
	m.MoveSideToSide = false
	m.Config = function(parent: GuiBase2d)
		Util_CreateSwitch(parent, "Toby Fox", m.TobyFox).Changed:Connect(function(val)
			m.TobyFox = val
		end)
		Util_CreateSwitch(parent, "left right", m.MoveSideToSide).Changed:Connect(function(val)
			m.MoveSideToSide = val
		end)
	end
	m.LoadConfig = function(save: any)
		m.TobyFox = not not save.TobyFox
		m.MoveSideToSide = not not save.MoveSideToSide
	end
	m.SaveConfig = function()
		return {
			TobyFox = m.TobyFox,
			MoveSideToSide = m.MoveSideToSide
		}
	end

	local animator = nil
	local start = 0
	m.Init = function(figure: Model)
		if m.TobyFox then
			SetOverrideDanceMusic(AssetGetContentId("Jitterbug2.mp3"), "Deltarune - The 'Ol Jitterbug", 1)
		else
			SetOverrideDanceMusic(AssetGetContentId("Jitterbug1.mp3"), "very original tune", 1)
		end
		start = os.clock()
		animator = AnimLib.Animator.new()
		animator.rig = figure
		animator.looped = true
		animator.speed = 1
		animator.track = AnimLib.Track.fromfile(AssetGetPathFromFilename("Jitterbug.anim"))
	end
	m.Update = function(dt: number, figure: Model)
		local t = os.clock()
		animator:Step(t - start)
		local rj = figure:FindFirstChild("HumanoidRootPart") and figure.HumanoidRootPart:FindFirstChild("RootJoint")
		if rj then
			if m.MoveSideToSide then
				rj.Transform += Vector3.new(math.sin((t - start) * 5), 0, 0) * figure:GetScale()
			end
		end
	end
	m.Destroy = function(figure: Model?)
		animator = nil
	end
	return m
end)

AddModule(function()
	local m = {}
	m.ModuleType = "DANCE"
	m.Name = "hacking full roblox"
	m.Description = "animator: @maybewasangery\nreference: ████████████\nyes i dont wanna mention him so"
	m.Assets = {"HackFullRoblox.anim"}

	m.Config = function(parent: GuiBase2d)
	end

	local animator = nil
	local start = 0
	local robloxwalk = nil
	m.Init = function(figure: Model)
		SetOverrideDanceMusic("", "Roblox walk", 0)
		start = os.clock()
		animator = AnimLib.Animator.new()
		animator.rig = figure
		animator.looped = false
		animator.speed = 1
		animator.track = AnimLib.Track.fromfile(AssetGetPathFromFilename("HackFullRoblox.anim"))
		robloxwalk = Instance.new("Sound")
		robloxwalk.SoundId = "rbxasset://sounds/action_footsteps_plastic.mp3"
		robloxwalk.Looped = true
		robloxwalk.Pitch = 1.85
		robloxwalk.Volume = 1.5
		robloxwalk.Playing = true
		robloxwalk.Parent = figure
	end
	m.Update = function(dt: number, figure: Model)
		local t = os.clock()
		animator:Step((t - start) % 2)
	end
	m.Destroy = function(figure: Model?)
		animator = nil
		robloxwalk:Destroy()
	end
	return m
end)

AddModule(function()
	local m = {}
	m.ModuleType = "DANCE"
	m.Name = "Egypt"
	m.Description = "imagine getting banned here\nimproved now"
	m.Assets = {"Egypt.anim", "Egypt.mp3"}

	m.Config = function(parent: GuiBase2d)
	end

	local animator = nil
	local start = 0
	m.Init = function(figure: Model)
		SetOverrideDanceMusic(AssetGetContentId("Egypt.mp3"), "Mofe. - Prince of Egypt", 1, NumberRange.new(0, 24.481))
		start = os.clock()
		animator = AnimLib.Animator.new()
		animator.rig = figure
		animator.looped = true
		animator.speed = 1
		animator.map = {{0, 24.481}, {0, 24}}
		animator.track = AnimLib.Track.fromfile(AssetGetPathFromFilename("Egypt.anim"))
	end
	m.Update = function(dt: number, figure: Model)
		local t = os.clock()
		animator:Step(GetOverrideDanceMusicTime())
	end
	m.Destroy = function(figure: Model?)
		animator = nil
	end
	return m
end)

AddModule(function()
	local m = {}
	m.ModuleType = "DANCE"
	m.Name = "Rambunctious"
	m.Description = "rare forty nighty emote\ngot me feelin rambunctious!!!"
	m.Assets = {"Rambunctious.anim", "Rambunctious.mp3"}

	m.Config = function(parent: GuiBase2d)
	end

	local animator = nil
	local start = 0
	m.Init = function(figure: Model)
		SetOverrideDanceMusic(AssetGetContentId("Rambunctious.mp3"), "PatQuinnMusic - Rambunctious", 1, NumberRange.new(0, 7.341))
		start = os.clock()
		animator = AnimLib.Animator.new()
		animator.rig = figure
		animator.looped = true
		animator.speed = 1
		animator.map = {{0, 7.341}, {0, 3.67 * 2}}
		animator.track = AnimLib.Track.fromfile(AssetGetPathFromFilename("Rambunctious.anim"))
	end
	m.Update = function(dt: number, figure: Model)
		local t = os.clock()
		animator:Step(GetOverrideDanceMusicTime())
	end
	m.Destroy = function(figure: Model?)
		animator = nil
	end
	return m
end)

if game.Players.LocalPlayer.Name == "STEVETheReal916" then return modules end

AddModule(function()
	local m = {}
	m.ModuleType = "DANCE"
	m.Name = "FNAF Remix"
	m.Description = "most violent jumpscare ive ever seen btw :sob:"
	m.Assets = {"FNAFFreddy.anim", "FNAFFreddyIdle.anim", "FNAFFreddy.mp3"}

	m.FullVersion = false
	m.Effects = true
	m.Config = function(parent: GuiBase2d)
		Util_CreateSwitch(parent, "Effects", m.Effects).Changed:Connect(function(val)
			m.Effects = val
		end)
		Util_CreateSwitch(parent, "Idled", m.FullVersion).Changed:Connect(function(val)
			m.FullVersion = val
		end)
	end
	m.LoadConfig = function(save: any)
		m.FullVersion = not not save.FullVersion
		m.Effects = not save.NoEffects
	end
	m.SaveConfig = function()
		return {
			FullVersion = m.FullVersion,
			NoEffects = not m.Effects
		}
	end

	local animator1 = nil
	local animator2 = nil
	m.Init = function(figure: Model)
		if m.FullVersion then
			SetOverrideDanceMusic(AssetGetContentId("FNAFFreddy.mp3"), "i found this on instagram", 1)
		else
			SetOverrideDanceMusic(AssetGetContentId("FNAFFreddy.mp3"), "i found this on instagram", 1, NumberRange.new(87.258, 110.875))
			SetOverrideDanceMusicTime(87.258)
		end
		animator1 = AnimLib.Animator.new()
		animator1.rig = figure
		animator1.looped = true
		animator1.track = AnimLib.Track.fromfile(AssetGetPathFromFilename("FNAFFreddy.anim"))
		animator1.map = {{87.258, 110.875}, {0, 5.87 * 2}}
		animator2 = AnimLib.Animator.new()
		animator2.rig = figure
		animator2.looped = false
		animator2.track = AnimLib.Track.fromfile(AssetGetPathFromFilename("FNAFFreddyIdle.anim"))
		if textsandstuff then textsandstuff:Destroy() end
		if m.Effects then
			textsandstuff = Instance.new("Part")
			textsandstuff.Transparency = 1
			textsandstuff.Anchored = true
			textsandstuff.CanCollide = false
			textsandstuff.CanTouch = false
			textsandstuff.CanQuery = false
			textsandstuff.Name = "INTERNETANGEL"
			textsandstuff.Size = Vector3.new(10, 6, 0) * figure:GetScale()
			local sgui = Instance.new("SurfaceGui")
			sgui.LightInfluence = 0
			sgui.Brightness = 1
			sgui.AlwaysOnTop = false
			sgui.MaxDistance = 1000
			sgui.SizingMode = Enum.SurfaceGuiSizingMode.FixedSize
			sgui.CanvasSize = Vector2.new(300, 120)
			sgui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
			sgui.Name = "UI"
			sgui.Parent = textsandstuff
			local text = Instance.new("TextLabel")
			text.Position = UDim2.new(0, 0, 0, 0)
			text.Size = UDim2.new(0.5, 0, 0.5, 0)
			text.BackgroundTransparency = 1
			text.ClipsDescendants = true
			text.Font = Enum.Font.Code
			text.TextColor3 = Color3.new(1, 1, 1)
			text.TextXAlignment = Enum.TextXAlignment.Left
			text.TextYAlignment = Enum.TextYAlignment.Center
			text.TextScaled = true
			text.Text = "Five\nNights\nat\nFreddy's"
			text.Name = tostring(id)
			text.Parent = sgui
		end
	end
	m.Update = function(dt: number, figure: Model)
		local t = GetOverrideDanceMusicTime()
		if t >= 87.258 and t <= 110.875 then
			animator1:Step(t)
		else
			animator2:Step(t)
		end
		local root = figure:FindFirstChild("HumanoidRootPart")
		if not root then return end
		local scale = figure:GetScale()
		if textsandstuff then
			textsandstuff.CFrame = root.CFrame * CFrame.new(0, 0, -1 * scale)
		end
	end
	m.Destroy = function(figure: Model?)
		animator1 = nil
		animator2 = nil
		if textsandstuff then textsandstuff:Destroy() textsandstuff = nil end
	end
	return m
end)

AddModule(function()
	local m = {}
	m.ModuleType = "DANCE"
	m.Name = "Looping The Rooms"
	m.Description = "is there really an escape in this world\nim trapped help\nfah"
	m.Assets = {"LoopingTheRooms.anim", "LoopingTheRooms.mp3"}

	m.Config = function(parent: GuiBase2d)
	end

	local animator = nil
	m.Init = function(figure: Model)
		SetOverrideDanceMusic(AssetGetContentId("LoopingTheRooms.mp3"), "rusino - Looping the Rooms ft. Blue Teto", 1)
		animator = AnimLib.Animator.new()
		animator.rig = figure
		animator.looped = false
		animator.speed = 1
		animator.track = AnimLib.Track.fromfile(AssetGetPathFromFilename("LoopingTheRooms.anim"))
	end
	m.Update = function(dt: number, figure: Model)
		local t = GetOverrideDanceMusicTime()
		animator:Step(t)
		local rj = figure:FindFirstChild("HumanoidRootPart") and figure.HumanoidRootPart:FindFirstChild("RootJoint")
		if rj then
			if t >= 0.617 and t < 6.55 then
				rj.Transform -= Vector3.new(18.265 / 2, 0, 0) * figure:GetScale()
			end
			if t >= 6.55 and t < 12.517 then
				rj.Transform -= Vector3.new(12.631 / 2, 0, 0) * figure:GetScale()
			end
			if t >= 18.45 and t < 24.43 then
				rj.Transform -= Vector3.new(12.631 / 2, 0, 0) * figure:GetScale()
			end
		end
	end
	m.Destroy = function(figure: Model?)
		animator = nil
	end
	return m
end)

AddModule(function()
	local m = {}
	m.ModuleType = "DANCE"
	m.Name = "Popipo"
	m.Description = "i know you want my vegetable juice"
	m.Assets = {"PopipoDance.anim", "PopipoShake.anim", "Popipo.rbxm", "Popipo.mp3"}

	m.Effects = true
	m.Config = function(parent: GuiBase2d)
		Util_CreateSwitch(parent, "Effects", m.Effects).Changed:Connect(function(val)
			m.Effects = val
		end)
	end
	m.LoadConfig = function(save: any)
		m.Effects = not save.NoEffects
	end
	m.SaveConfig = function()
		return {
			NoEffects = not m.Effects
		}
	end

	local animator1 = nil
	local animator2 = nil
	local instances = {}
	m.Init = function(figure: Model)
		SetOverrideDanceMusic(AssetGetContentId("Popipo.mp3"), "po pi po pi po po pi po", 1)
		animator1 = AnimLib.Animator.new()
		animator1.rig = figure
		animator1.looped = true
		animator1.track = AnimLib.Track.fromfile(AssetGetPathFromFilename("PopipoDance.anim"))
		animator1.map = {{87.258, 110.875}, {0, 5.87 * 2}}
		animator2 = AnimLib.Animator.new()
		animator2.rig = figure
		animator2.looped = false
		animator2.track = AnimLib.Track.fromfile(AssetGetPathFromFilename("PopipoShake.anim"))
		for _,v in instances do v:Destroy() end
		if m.Effects then
		end
	end
	m.Update = function(dt: number, figure: Model)
		local t = GetOverrideDanceMusicTime()
		if t >= 87.258 and t <= 110.875 then
			animator1:Step(t)
		else
			animator2:Step(t)
		end
		local root = figure:FindFirstChild("HumanoidRootPart")
		if not root then return end
		local scale = figure:GetScale()
		if textsandstuff then
			textsandstuff.CFrame = root.CFrame * CFrame.new(0, 0, -1 * scale)
		end
	end
	m.Destroy = function(figure: Model?)
		animator1 = nil
		animator2 = nil
		for _,v in instances do v:Destroy() end
	end
	return m
end)

return modules