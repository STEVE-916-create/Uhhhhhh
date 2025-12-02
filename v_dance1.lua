local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local TextService = game:GetService("TextService")
local TextChatService = game:GetService("TextChatService")
local ContextActionService = game:GetService("ContextActionService")
local Debris = game:GetService("Debris")

local Player = Players.LocalPlayer

local modules = {}
local function AddModule(m)
	table.insert(modules, m)
end

AddModule(function()
	local m = {}
	m.ModuleType = "DANCE"
	m.Name = "Ragdoll"
	m.Description = "faint, or die\nAnimation-less, physics based, real and istic ragdoll."
	m.InternalName = "RAGDOLL"
	m.Assets = {}

	m.Mode = 0
	m.Config = function(parent: GuiBase2d)
		Util_CreateDropdown(parent, "Label", {"Normal", "Jointless", "CFrame Bug"}, m.Mode + 1).Changed:Connect(function(val)
			m.Mode = val - 1
		end)
	end
	m.LoadConfig = function(save: any)
		m.Mode = save.Mode or m.Mode
	end
	m.SaveConfig = function()
		return {
			Mode = m.Mode
		}
	end

	local motors = {}
	local joints = {}
	local teleporthack = nil
	local selmode = 0
	m.Init = function(figure: Model)
		table.clear(motors)
		table.clear(joints)
		if teleporthack then teleporthack:Disconnect() end
		
		local root = figure:FindFirstChild("HumanoidRootPart")
		if not root then return end
		local torso = figure:FindFirstChild("Torso")
		if not torso then return end
		
		selmode = m.Mode
		
		local scale = figure:GetScale()
		
		local rj = root:FindFirstChild("RootJoint")
		local nj = torso:FindFirstChild("Neck")
		local rsj = torso:FindFirstChild("Right Shoulder")
		local lsj = torso:FindFirstChild("Left Shoulder")
		local rhj = torso:FindFirstChild("Right Hip")
		local lhj = torso:FindFirstChild("Left Hip")
		
		local function createNoCollide(p0, p1)
			local nocoll = Instance.new("NoCollisionConstraint")
			nocoll.Name = p0.Name .. " To " .. p1.Name
			nocoll.Part0, nocoll.Part1 = p0, p1
			nocoll.Parent = p0
			table.insert(joints, nocoll)
		end
		local function createJoint(motor, c0, c1)
			motor.Enabled = false
			local att0 = Instance.new("Attachment")
			att0.Name = motor.Part0.Name .. "C0"
			att0.CFrame = c0 + c0.Position * (scale - 1)
			att0.Parent = motor.Part0
			local att1 = Instance.new("Attachment")
			att1.Name = motor.Part1.Name .. "C1"
			att1.CFrame = c1 + c1.Position * (scale - 1)
			att1.Parent = motor.Part1
			local joint = Instance.new("BallSocketConstraint")
			joint.Name = motor.Name
			joint.Attachment0, joint.Attachment1 = att0, att1
			joint.Parent = motor.Parent
			joint.LimitsEnabled = true
			joint.TwistLimitsEnabled = true
			joint.UpperAngle = 90
			joint.TwistLowerAngle = -170
			joint.TwistUpperAngle = 170
			createNoCollide(motor.Part0, motor.Part1)
			table.insert(motors, motor)
			table.insert(joints, att0)
			table.insert(joints, att1)
			table.insert(joints, joint)
		end
		
		if selmode == 1 then
			rj.Enabled = false
			nj.Enabled = false
			rsj.Enabled = false
			lsj.Enabled = false
			rhj.Enabled = false
			lhj.Enabled = false
			table.insert(motors, rj)
			table.insert(motors, nj)
			table.insert(motors, rsj)
			table.insert(motors, lsj)
			table.insert(motors, rhj)
			table.insert(motors, lhj)
		else
			root.CFrame = torso.CFrame
			rj.Enabled = false
			table.insert(motors, rj)
			local weld = Instance.new("Weld")
			weld.C0 = rj.C0
			weld.Part0 = rj.Part0
			weld.C1 = rj.C1
			weld.Part1 = rj.Part1
			weld.Parent = rj.Parent
			table.insert(joints, weld)
			createJoint(nj, CFrame.new(0, 1, 0) * CFrame.Angles(0, 0, 1.57), CFrame.new(0, -0.5, 0) * CFrame.Angles(0, 0, 1.57))
			createJoint(rsj, CFrame.new(1.5, 0.5, 0) * CFrame.Angles(0, 0, 3.14), CFrame.new(0, 0.5, 0) * CFrame.Angles(0, 0, 3.14))
			createJoint(lsj, CFrame.new(-1.5, 0.5, 0) * CFrame.Angles(0, 0, 0), CFrame.new(0, 0.5, 0) * CFrame.Angles(0, 0, 0))
			createJoint(rhj, CFrame.new(0.5, -1, 0) * CFrame.Angles(0, 0, -1.57), CFrame.new(0, 1, 0) * CFrame.Angles(0, 0, -1.57))
			createJoint(lhj, CFrame.new(-0.5, -1, 0) * CFrame.Angles(0, 0, -1.57), CFrame.new(0, 1, 0) * CFrame.Angles(0, 0, -1.57))
			createNoCollide(rsj.Part1, nj.Part1)
			createNoCollide(lsj.Part1, nj.Part1)
			createNoCollide(rsj.Part1, rhj.Part1)
			createNoCollide(lsj.Part1, lhj.Part1)
			createNoCollide(lhj.Part1, rhj.Part1)
			createNoCollide(root, nj.Part1)
			createNoCollide(root, rsj.Part1)
			createNoCollide(root, lsj.Part1)
			createNoCollide(root, rhj.Part1)
			createNoCollide(root, lhj.Part1)
			teleporthack = root:GetPropertyChangedSignal("CFrame"):Connect(function()
				local cf = root.CFrame
				for _,v in {nj, rsj, lsj, rhj, lhj} do
					if (v.Part1.Position - cf.Position).Magnitude > 10 * figure:GetScale() then
						v.Part1.CFrame = cf
					end
				end
			end)
		end
	end
	m.Update = function(dt: number, figure: Model)
		local t = tick()
		local hum = figure:FindFirstChild("Humanoid")
		if not hum then return end
		local root = figure:FindFirstChild("HumanoidRootPart")
		if not root then return end
		hum.PlatformStand = true
		if hum.MoveDirection.Magnitude > 0 or hum.Jump then
			root.Velocity = hum.MoveDirection * 50
			if hum.Jump then
				root.Velocity += Vector3.new(0, 50, 0)
			end
		end
		if selmode == 2 then
			local he = figure:FindFirstChild("Head")
			local la = figure:FindFirstChild("Left Arm")
			local ra = figure:FindFirstChild("Right Arm")
			local ll = figure:FindFirstChild("Left Leg")
			local rl = figure:FindFirstChild("Right Leg")
			RunService.PreSimulation:Once(function()
				he.CFrame, la.CFrame, ra.CFrame, ll.CFrame, rl.CFrame = root.CFrame, root.CFrame, root.CFrame, root.CFrame, root.CFrame
			end)
		end
	end
	m.Destroy = function(figure: Model?)
		for _,v in motors do
			v.Enabled = true
		end
		for _,v in joints do
			v:Destroy()
		end
		if teleporthack then teleporthack:Disconnect() teleporthack = nil end
		if not figure then return end
		local hum = figure:FindFirstChild("Humanoid")
		if not hum then return end
		hum.PlatformStand = false
	end
	return m
end)

AddModule(function()
	local m = {}
	m.ModuleType = "DANCE"
	m.Name = "Rat Dance"
	m.Description = "sourced from a tiktok trend"
	m.Assets = {"RatDance.anim", "RatDance2.anim", "RatDance.mp3"}

	m.Alternative = false
	m.Config = function(parent: GuiBase2d)
		Util_CreateSwitch(parent, "Alt. Version", m.Alternative).Changed:Connect(function(val)
			m.Alternative = val
		end)
	end
	m.LoadConfig = function(save: any)
		m.Alternative = not not save.Alternative
	end
	m.SaveConfig = function()
		return {
			Alternative = m.Alternative
		}
	end

	local animator = nil
	local start = 0
	m.Init = function(figure: Model)
		SetOverrideDanceMusic(AssetGetContentId("RatDance.mp3"), "Chess Type Beat Slowed", 1, NumberRange.new(2.13, 87.3))
		start = tick()
		animator = AnimLib.Animator.new()
		animator.rig = figure
		animator.looped = true
		animator.speed = 1.127157
		if m.Alternative then
			animator.track = AnimLib.Track.fromfile(AssetGetPathFromFilename("RatDance2.anim"))
		else
			animator.track = AnimLib.Track.fromfile(AssetGetPathFromFilename("RatDance.anim"))
		end
	end
	m.Update = function(dt: number, figure: Model)
		local t = tick()
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
	m.Name = "Assumptions"
	m.Description = "if its the love that you want\nill give my everything\nand if i made the right assumption\ndo you feel the same"
	m.Assets = {"Assumptions.anim", "Assumptions.mp3"}

	m.Config = function(parent: GuiBase2d)
	end

	local animator = nil
	m.Init = function(figure: Model)
		SetOverrideDanceMusic(AssetGetContentId("Assumptions.mp3"), "Sam Gellaitry - Assumptions", 1, NumberRange.new(15.22, 76.19))
		animator = AnimLib.Animator.new()
		animator.rig = figure
		animator.track = AnimLib.Track.fromfile(AssetGetPathFromFilename("Assumptions.anim"))
		animator.looped = true
		animator.map = {{15.22, 76.19}, {0, 78.944}}
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
	m.Name = "Mesmerizer"
	m.Description = "fall asleep fall asleep fall asleep\nwheres yellow miku\nand green miku"
	m.Assets = {"Mesmerizer.anim", "Mesmerizer.mp3"}

	m.Config = function(parent: GuiBase2d)
	end

	local animator = nil
	m.Init = function(figure: Model)
		SetOverrideDanceMusic(AssetGetContentId("Mesmerizer.mp3"), "Blue and Red Miku - Mesmerizer", 1, NumberRange.new(2.56, 67.435))
		animator = AnimLib.Animator.new()
		animator.rig = figure
		animator.track = AnimLib.Track.fromfile(AssetGetPathFromFilename("Mesmerizer.anim"))
		animator.looped = true
		animator.map = {{44.113, 54.456}, {0, 10.367}}
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
	m.Name = "Caramelldansen"
	m.Description = "Oh wa oh wa ah!\ndance on my balls\nkoopa in a handbag\nyours only yours\nim on a single dance band\nits no lie\nlisa in the crowd said\n\"Look! Harry had a-\""
	m.Assets = {"Caramelldansen.anim", "Caramelldansen.mp3"}

	local lyricsdelay = 1.4569375 / 8
	local lyrics = {
		"Oh wah oh wah ah!",
		nil, nil, nil, nil, nil, nil, nil,
		"Dansa med oss, klappa era hander",
		nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil,
		"Gor som vi gor, ta nagra steg at vanster",
		nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil,
		"Lyssna och lar, missa inte chansen",
		nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil,
		"Nu ar vi har med",
		nil, nil, nil, nil, nil, nil,
		"Caramelldansen",
		nil, nil, nil, nil, nil, nil, nil, nil,
		"Oo oo oowah oowah",
		nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil,
		"Oo oo oowah oowah ah",
		nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil,
		"Oo oo oowah oowah",
		nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil,
		"Oo oo oowah oowah ah",
		nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil,
		"Det blir en sensation overallt forstas",
		nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil,
		"Pa fester kommer alla att slappa loss",
		nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil,
		"Kom igen, Nu tar vi stegen om igen",
		nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 
		"Oh wah oh wah oh",
		nil, nil, nil, nil, nil,
		"Sa ror pa era fotter, wa ah ah!",
		nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil,
		"Och vicka era hofter, oo la la la!",
		nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil,
		"Gor som vi, till denna melodi",
		nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 
	}
	local lastlyricsindex = 0
	m.Lyrics = false
	m.Config = function(parent: GuiBase2d)
		Util_CreateSwitch(parent, "Lyrics", m.Lyrics).Changed:Connect(function(val)
			m.Lyrics = val
		end)
	end
	m.LoadConfig = function(save: any)
		m.Lyrics = not not save.Lyrics
	end
	m.SaveConfig = function()
		return {
			Lyrics = m.Lyrics
		}
	end

	local animator = nil
	m.Init = function(figure: Model)
		SetOverrideDanceMusic(AssetGetContentId("Caramelldansen.mp3"), "Caramell - Caramella Girls", 1)
		animator = AnimLib.Animator.new()
		animator.rig = figure
		animator.track = AnimLib.Track.fromfile(AssetGetPathFromFilename("Caramelldansen.anim"))
		animator.looped = true
		animator.map = {{0, 46.683}, {0, 44.8}}
		lastlyricsindex = 0
	end
	m.Update = function(dt: number, figure: Model)
		local t = GetOverrideDanceMusicTime()
		animator:Step(t)
		local curlyricsindex = (t // lyricsdelay) + 1
		if lastlyricsindex ~= curlyricsindex then
			lastlyricsindex = curlyricsindex
			local lyric = lyrics[curlyricsindex]
			if lyric and m.Lyrics then
				ProtectedChat(lyric)
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
	m.Name = "Hakari's Dance"
	m.Description = "jujutsu shenanigans\nlets go gambling\naw dang it\naw dang it\naw dang it\naw dang it\naw dang it"
	m.InternalName = "TUKATUKADONKDONK"
	m.Assets = {"Hakari.anim", "Hakari.mp3"}

	m.Effects = false
	m.Config = function(parent: GuiBase2d)
		Util_CreateSwitch(parent, "Effects", m.Effects).Changed:Connect(function(val)
			m.Effects = val
		end)
	end
	m.LoadConfig = function(save: any)
		m.Effects = not not save.Effects
	end
	m.SaveConfig = function()
		return {
			Effects = m.Effects
		}
	end

	local animator = nil
	local instances = {}
	m.Init = function(figure: Model)
		SetOverrideDanceMusic(AssetGetContentId("Hakari.mp3"), "TUCA DONKA", 1)
		animator = AnimLib.Animator.new()
		animator.rig = figure
		animator.track = AnimLib.Track.fromfile(AssetGetPathFromFilename("Hakari.anim"))
		animator.looped = true
		animator.map = {{0, 73.845}, {0, 75.6}}
		instances = {}
		if m.Effects then
			local scale = figure:GetScale()
			local root = figure:FindFirstChild("HumanoidRootPart")
			local SmokeLight = Instance.new("ParticleEmitter")
			SmokeLight.Parent = root
			SmokeLight.LightInfluence = 0
			SmokeLight.LightEmission = 1
			SmokeLight.Brightness = 1
			SmokeLight.ZOffset = -2
			SmokeLight.Color = ColorSequence.new(Color3.fromRGB(67, 255, 167))
			SmokeLight.Orientation = Enum.ParticleOrientation.FacingCamera
			SmokeLight.Size = NumberSequence.new(0.625 * scale, 8.5 * scale)
			SmokeLight.Squash = NumberSequence.new(0)
			SmokeLight.Transparency = NumberSequence.new({
				NumberSequenceKeypoint.new(0, 1),
				NumberSequenceKeypoint.new(0.4, 0.0625),
				NumberSequenceKeypoint.new(0.5, 0),
				NumberSequenceKeypoint.new(0.625, 0.0625),
				NumberSequenceKeypoint.new(0.75, 0.2),
				NumberSequenceKeypoint.new(0.875, 0.4),
				NumberSequenceKeypoint.new(0.95, 0.65),
				NumberSequenceKeypoint.new(1, 1),
			})
			SmokeLight.Texture = "rbxassetid://12585595946"
			SmokeLight.FlipbookLayout = Enum.ParticleFlipbookLayout.Grid4x4
			SmokeLight.FlipbookMode = Enum.ParticleFlipbookMode.Loop
			SmokeLight.FlipbookFramerate = NumberRange.new(25)
			SmokeLight.FlipbookStartRandom = true
			SmokeLight.Lifetime = NumberRange.new(0.4, 0.7)
			SmokeLight.Rate = 25
			SmokeLight.Rotation = NumberRange.new(0, 360)
			SmokeLight.RotSpeed = NumberRange.new(-20, 20)
			SmokeLight.Speed = NumberRange.new(0)
			SmokeLight.Enabled = true
			SmokeLight.LockedToPart = true
			local SmokeThick = Instance.new("ParticleEmitter")
			SmokeThick.Parent = root
			SmokeThick.LightInfluence = 0
			SmokeThick.LightEmission = 1
			SmokeThick.Brightness = 1
			SmokeThick.ZOffset = -2
			SmokeThick.Color = ColorSequence.new(Color3.fromRGB(67, 255, 167))
			SmokeThick.Orientation = Enum.ParticleOrientation.FacingCamera
			SmokeThick.Size = NumberSequence.new({
				NumberSequenceKeypoint.new(0, 0.0625 * scale, 0),
				NumberSequenceKeypoint.new(0.36, 0.437 * scale, 0.437 * scale),
				NumberSequenceKeypoint.new(1, 8.65 * scale, 0.0625 * scale),
			})
			SmokeThick.Squash = NumberSequence.new(0)
			SmokeThick.Transparency = NumberSequence.new(0)
			SmokeThick.Texture = "rbxassetid://13681590856"
			SmokeThick.FlipbookLayout = Enum.ParticleFlipbookLayout.Grid4x4
			SmokeThick.FlipbookMode = Enum.ParticleFlipbookMode.OneShot
			SmokeThick.FlipbookStartRandom = false
			SmokeThick.Lifetime = NumberRange.new(0.4, 0.8)
			SmokeThick.Rate = 50
			SmokeThick.Rotation = NumberRange.new(0, 360)
			SmokeThick.RotSpeed = NumberRange.new(0)
			SmokeThick.Speed = NumberRange.new(0)
			SmokeThick.Enabled = true
			SmokeThick.LockedToPart = true
			instances = {SmokeLight, SmokeThick}
		end
	end
	m.Update = function(dt: number, figure: Model)
		local t = GetOverrideDanceMusicTime()
		animator:Step(t)
		local t2 = t / 0.461
		for _,v in instances do
			v.TimeScale = 0.7 + 0.3 * math.cos(t2 * math.pi * 2)
		end
	end
	m.Destroy = function(figure: Model?)
		animator = nil
		for _,v in instances do v:Destroy() end
		instances = {}
	end
	return m
end)

AddModule(function()
	local m = {}
	m.ModuleType = "DANCE"
	m.Name = "California Girls"
	m.Description = "this was everywhere back in my day (2021)\nanimation sourced from gmod"
	m.Assets = {"CaliforniaGirls.anim", "CaliforniaGirls.mp3"}

	m.Config = function(parent: GuiBase2d)
	end

	local animator = nil
	local start = 0
	m.Init = function(figure: Model)
		SetOverrideDanceMusic(AssetGetContentId("CaliforniaGirls.mp3"), "Katy Perry - California Girls", 1)
		start = tick()
		animator = AnimLib.Animator.new()
		animator.rig = figure
		animator.looped = true
		animator.speed = 1.010493
		animator.track = AnimLib.Track.fromfile(AssetGetPathFromFilename("CaliforniaGirls.anim"))
	end
	m.Update = function(dt: number, figure: Model)
		local t = tick()
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
	m.Name = "科目三 (Subject Three)"
	m.Description = "剑起江湖恩怨 拂袖罩明月\n西風葉落花謝 枕刀劍難眠\n汝为山河过客 却总长叹伤离别\n鬓如霜一杯浓烈"
	m.InternalName = "KEMUSAN"
	m.Assets = {"SubjectThree.anim", "SubjectThreeForsaken.anim", "SubjectThree.mp3", "SubjectThreeDubmood.mp3"}

	m.Alternative = false
	m.Config = function(parent: GuiBase2d)
		Util_CreateSwitch(parent, "Forsaken", m.Alternative).Changed:Connect(function(val)
			m.Alternative = val
		end)
	end
	m.LoadConfig = function(save: any)
		m.Alternative = not not save.Alternative
	end
	m.SaveConfig = function()
		return {
			Alternative = m.Alternative
		}
	end

	local animator = nil
	local start = 0
	m.Init = function(figure: Model)
		start = tick()
		animator = AnimLib.Animator.new()
		animator.rig = figure
		animator.looped = true
		if m.Alternative then
			--animator.speed = 0.9867189
			animator.speed = 1
			animator.track = AnimLib.Track.fromfile(AssetGetPathFromFilename("SubjectThreeForsaken.anim"))
			SetOverrideDanceMusic(AssetGetContentId("SubjectThreeDubmood.mp3"), "Dubmood - The Scene Is Dead 2024", 1)
		else
			start += 3.71
			animator.speed = 1.01034703
			animator.track = AnimLib.Track.fromfile(AssetGetPathFromFilename("SubjectThree.anim"))
			SetOverrideDanceMusic(AssetGetContentId("SubjectThree.mp3"), "Subject Three - Wen Ren Ting Shu", 1, NumberRange.new(3.71, 77.611))
		end
	end
	m.Update = function(dt: number, figure: Model)
		local t = tick()
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
	m.Name = "Mio Honda - Step!"
	m.Description = "yeah lets dash towards tomorrow\nwhat a nice intro i sure hope this doesnt have suicide\nYour opinion is not OK so please just shut up and never speak again!"
	m.Assets = {"MioHonda.anim", "MioHondaStep.anim", "MioHonda.mp3"}

	m.Alternative = false
	m.Config = function(parent: GuiBase2d)
		Util_CreateSwitch(parent, "Walk Only", m.Alternative).Changed:Connect(function(val)
			m.Alternative = val
		end)
	end
	m.LoadConfig = function(save: any)
		m.Alternative = not not save.Alternative
	end
	m.SaveConfig = function()
		return {
			Alternative = m.Alternative
		}
	end

	local animator1 = nil
	local animator2 = nil
	m.Init = function(figure: Model)
		SetOverrideDanceMusic(AssetGetContentId("MioHonda.mp3"), "Mio Honda - Step!", 1, NumberRange.new(45.311, 196.964))
		animator1 = AnimLib.Animator.new()
		animator1.rig = figure
		animator1.track = AnimLib.Track.fromfile(AssetGetPathFromFilename("MioHonda.anim"))
		animator1.looped = false
		animator1.map = {{0, 36.253}, {0, 36}}
		animator2 = AnimLib.Animator.new()
		animator2.rig = figure
		animator2.track = AnimLib.Track.fromfile(AssetGetPathFromFilename("MioHondaStep.anim"))
		animator2.looped = true
		animator2.map = {{0, 196.964}, {0, 197.142}}
	end
	m.Update = function(dt: number, figure: Model)
		local t = GetOverrideDanceMusicTime()
		local t2 = t
		if t2 >= 151.702 then
			t2 -= 151.702
		elseif t2 >= 74.734 then
			t2 -= 74.734
		end
		if t2 < 36.253 and not m.Alternative then
			animator1:Step(t2)
		else
			animator2:Step(t)
		end
	end
	m.Destroy = function(figure: Model?)
		animator1 = nil
		animator2 = nil
	end
	return m
end)

AddModule(function()
	local m = {}
	m.ModuleType = "DANCE"
	m.Name = "Static"
	m.Description = "new obsession found\nbasically tenna\n\nthe world you know always changing so fast\nthis song has a point\ndont touch that dial cuz its tv time"
	m.Assets = {"StaticV1.anim", "Static.mp3"}

	m.Config = function(parent: GuiBase2d)
	end

	local animator = nil
	m.Init = function(figure: Model)
		SetOverrideDanceMusic(AssetGetContentId("Static.mp3"), "FLAVOR FOLEY - Static", 1)
		animator = AnimLib.Animator.new()
		animator.rig = figure
		animator.track = AnimLib.Track.fromfile(AssetGetPathFromFilename("StaticV1.anim"))
		animator.looped = false
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
	m.Name = "Lag Train"
	m.Description = "bro i cant play dead rails im lagging\nwhen im in a train and i sleep because its raining\nand then the train stop and i wake up"
	m.Assets = {"Lagtrain.anim", "Lagtrain.mp3"}

	m.Config = function(parent: GuiBase2d)
	end

	local animator = nil
	m.Init = function(figure: Model)
		SetOverrideDanceMusic(AssetGetContentId("Lagtrain.mp3"), "inabakumori - Lag Train", 1)
		animator = AnimLib.Animator.new()
		animator.rig = figure
		animator.track = AnimLib.Track.fromfile(AssetGetPathFromFilename("Lagtrain.anim"))
		animator.looped = false
		animator.map = {{0, 26.117}, {0, 25.53}}
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
	m.Name = "Gangnam Style"
	m.Description = "oppa gangnam style\nuhngh..~"
	m.Assets = {"Gangnam.anim", "Gangnam.mp3"}

	m.Config = function(parent: GuiBase2d)
	end

	local animator = nil
	local start = 0
	m.Init = function(figure: Model)
		start = tick() + 1.505
		SetOverrideDanceMusic(AssetGetContentId("Gangnam.mp3"), "PSY - Gangnam Style", 1, NumberRange.new(1.505, 30.583))
		animator = AnimLib.Animator.new()
		animator.rig = figure
		animator.track = AnimLib.Track.fromfile(AssetGetPathFromFilename("Gangnam.anim"))
		animator.looped = true
		animator.speed = 1.01795171
	end
	m.Update = function(dt: number, figure: Model)
		local t = tick()
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
	m.Name = "Distraction"
	m.Description = "best choice in the whole game\nI... Wh... I just... Whaat."
	m.Assets = {"Distraction.anim", "DistractionFlipped.anim", "Distraction.mp3"}

	m.Alternative = false
	m.Config = function(parent: GuiBase2d)
		Util_CreateSwitch(parent, "Flipped", m.Alternative).Changed:Connect(function(val)
			m.Alternative = val
		end)
	end
	m.LoadConfig = function(save: any)
		m.Alternative = not not save.Alternative
	end
	m.SaveConfig = function()
		return {
			Alternative = m.Alternative
		}
	end

	local animator = nil
	m.Init = function(figure: Model)
		SetOverrideDanceMusic(AssetGetContentId("Distraction.mp3"), "Dance Mr. Funnybones", 1, NumberRange.new(0, 1.833))
		animator = AnimLib.Animator.new()
		animator.rig = figure
		animator.looped = true
		if m.Alternative then
			animator.track = AnimLib.Track.fromfile(AssetGetPathFromFilename("DistractionFlipped.anim"))
		else
			animator.track = AnimLib.Track.fromfile(AssetGetPathFromFilename("Distraction.anim"))
		end
	end
	m.Update = function(dt: number, figure: Model)
		animator:Step(GetOverrideDanceMusicTime() + 0.67)
	end
	m.Destroy = function(figure: Model?)
		animator = nil
	end
	return m
end)

AddModule(function()
	local m = {}
	m.ModuleType = "DANCE"
	m.Name = "3年C組14番窪園チヨコの入閣"
	m.Description = "Game Over!\n\"自分が3年C組14番だった事に気づいたので聞きに来ました-\"\n(I noticed I'm in 3rd year Class C-14 so I came to ask-)\nWords for Seeker: C14, Year 3"
	m.InternalName = "ClassC14"
	m.Assets = {"ClassC14.anim", "ClassC14.mp3"}

	m.Config = function(parent: GuiBase2d)
	end

	local animator = nil
	m.Init = function(figure: Model)
		SetOverrideDanceMusic(AssetGetContentId("ClassC14.mp3"), "3rd Year Class C-14", 1, NumberRange.new(0.492, 29.169))
		animator = AnimLib.Animator.new()
		animator.rig = figure
		animator.track = AnimLib.Track.fromfile(AssetGetPathFromFilename("ClassC14.anim"))
		animator.looped = false
		animator.map = {{0.492, 29.169}, {0, 28.63}}
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
	m.Name = "It Burns! Burns! Burns!"
	m.Description = "my racha food is very good\nbut the indian cook misunderstood\nit burns burns burns\nindian curry is so hot\nit burns burns burns\nburns like fire oh my god"
	m.Assets = {"ItBurns.anim", "ItBurns.mp3"}

	m.Config = function(parent: GuiBase2d)
	end

	local animator = nil
	m.Init = function(figure: Model)
		SetOverrideDanceMusic(AssetGetContentId("ItBurns.mp3"), "Loco Loco - It Burns! Burns! Burns!", 1)
		animator = AnimLib.Animator.new()
		animator.rig = figure
		animator.track = AnimLib.Track.fromfile(AssetGetPathFromFilename("ItBurns.anim"))
		animator.looped = false
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
	m.Name = "Kasane Teto - Igaku"
	m.Description = "red miku is pear\nand dancing teto blob"
	m.Assets = {"Igaku.anim", "IgakuSutibu.anim", "Igaku.mp3"}

	m.VeryOriginal = true
	m.Config = function(parent: GuiBase2d)
		Util_CreateSwitch(parent, "STEVE's Version", m.VeryOriginal).Changed:Connect(function(val)
			m.VeryOriginal = val
		end)
	end
	m.LoadConfig = function(save: any)
		m.VeryOriginal = not not save.VeryOriginal
	end
	m.SaveConfig = function()
		return {
			VeryOriginal = m.VeryOriginal
		}
	end

	local animator = nil
	m.Init = function(figure: Model)
		SetOverrideDanceMusic(AssetGetContentId("Igaku.mp3"), "Kasane Teto - Igaku", 1)
		animator = AnimLib.Animator.new()
		animator.rig = figure
		animator.looped = true
		if m.VeryOriginal then
			animator.track = AnimLib.Track.fromfile(AssetGetPathFromFilename("IgakuSutibu.anim"))
			animator.map = {{0, 22.572}, {0, 19.2}}
		else
			animator.track = AnimLib.Track.fromfile(AssetGetPathFromFilename("Igaku.anim"))
			animator.map = {{0, 22.572}, {0, 22.4}}
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
	m.Name = "Kai Cenat and Speed jumping"
	m.Description = "adventures of luigi and mario\nW SPEED\n\nthis uses no keyframes"
	m.InternalName = "SpeedAndKaiCenat"
	m.Assets = {"SpeedJumping.mp3"}

	m.Intro = true
	m.DifferentTiming = false
	m.LegFix = false
	m.CorrectFlipping = false
	m.PoseToTheFans = true
	m.Config = function(parent: GuiBase2d)
		Util_CreateSwitch(parent, "Intro", m.Intro).Changed:Connect(function(val)
			m.Intro = val
		end)
		Util_CreateDropdown(parent, "Variant", {"Speed", "Kai Cenat"}, m.DifferentTiming and 2 or 1).Changed:Connect(function(val)
			m.DifferentTiming = val == 2
		end)
		Util_CreateSwitch(parent, "Correct Jumping", m.LegFix).Changed:Connect(function(val)
			m.LegFix = val
		end)
		Util_CreateSwitch(parent, "Correct Flipping", m.CorrectFlipping).Changed:Connect(function(val)
			m.CorrectFlipping = val
		end)
		Util_CreateSwitch(parent, "Pose for the fans", m.PoseToTheFans).Changed:Connect(function(val)
			m.PoseToTheFans = val
		end)
	end
	m.LoadConfig = function(save: any)
		m.Intro = not not save.Intro
		m.DifferentTiming = not not save.KaiCenat
		m.LegFix = not not save.LegFix
		m.CorrectFlipping = not not save.CorrectFlipping
		m.PoseToTheFans = not save.DontPose
	end
	m.SaveConfig = function()
		return {
			Intro = m.Intro,
			KaiCenat = m.DifferentTiming,
			LegFix = m.LegFix,
			CorrectFlipping = m.CorrectFlipping,
			DontPose = not m.PoseToTheFans
		}
	end

	m.Init = function(figure: Model)
		SetOverrideDanceMusic(AssetGetContentId("SpeedJumping.mp3"), "BABY LAUGH JERSEY FUNK", 1, NumberRange.new(5.516, 19.726))
		if not m.Intro then
			SetOverrideDanceMusicTime(5.516)
		end
	end
	m.Update = function(dt: number, figure: Model)
		local t = GetOverrideDanceMusicTime()

		local hum = figure:FindFirstChild("Humanoid")
		if not hum then return end
		local root = figure:FindFirstChild("HumanoidRootPart")
		if not root then return end
		local torso = figure:FindFirstChild("Torso")
		if not torso then return end

		local scale = figure:GetScale()

		local rj = root:FindFirstChild("RootJoint")
		local nj = torso:FindFirstChild("Neck")
		local rsj = torso:FindFirstChild("Right Shoulder")
		local lsj = torso:FindFirstChild("Left Shoulder")
		local rhj = torso:FindFirstChild("Right Hip")
		local lhj = torso:FindFirstChild("Left Hip")

		if t < 5.516 then
			local dur = 0.5
			if t > 2.695 then
				dur = 5
			end
			if t > 3.593 then
				dur = 0.25
			end
			if t > 4.333 then
				dur = 0.05
			end
			local sine = math.sin((t / dur) * math.pi * 2)
			rj.Transform = CFrame.new(0, 0, -2.5 * scale) * CFrame.Angles(math.rad(-90), 0, math.rad(sine * 10))
			nj.Transform = CFrame.identity
			rsj.Transform = CFrame.Angles(0, 0, sine)
			lsj.Transform = CFrame.Angles(0, 0, sine)
			rhj.Transform = CFrame.Angles(0, 0, -sine)
			lhj.Transform = CFrame.Angles(0, 0, -sine)
		else
			local animt = ((t - 5.516) / 7.105) % 1
			local beat = animt * 16 -- 16 jumps
			local beat2 = beat
			local xaxis = animt * 4
			if m.DifferentTiming then
				beat2 -= 0.1 + math.sin(((beat + 1) / 4) * math.pi * 2) * 0.1
				xaxis += 0.67
			end
			local height = 1 - math.pow(1 - math.abs(math.sin(beat2 * math.pi)), 2)
			local yspint, zspint = beat2 % 8, (beat2 + 4) % 8
			if m.CorrectFlipping then
				if m.DifferentTiming then
					yspint, zspint = (beat2 + 1) % 4, 0
				else
					yspint, zspint = 0, beat2 % 4
				end
			end
			local yspin, zspin = math.pow(1 - math.min(yspint, 1), 2) * math.pi * 2, math.pow(1 - math.min(zspint, 1), 4) * math.pi * 2
			if m.CorrectFlipping then
				if not m.DifferentTiming then
					zspin = -zspin
				end
			elseif beat >= 8 then
				yspin, zspin = -yspin, -zspin
			end
			local armssine = 1 - math.pow(1 - math.abs(math.sin(math.pow(beat2 % 1, 3) * math.pi)), 2)
			local arms = math.rad(-75 * armssine)
			local legs = math.rad(-30 * math.abs(math.sin(beat2 * math.pi)))
			if m.LegFix then
				local alpha = 1 - height
				arms = math.rad(-75 * alpha)
				legs = math.rad(-30 * alpha)
			end
			rj.Transform = CFrame.new(math.sin(xaxis * math.pi) * 6.7 * scale, 0, height * 4.1 * scale) * CFrame.Angles(0, zspin, yspin)
			nj.Transform = CFrame.identity
			rsj.Transform = CFrame.Angles(arms, 0, 0)
			lsj.Transform = CFrame.Angles(arms, 0, 0)
			rhj.Transform = CFrame.Angles(legs, 0, 0)
			lhj.Transform = CFrame.Angles(legs, 0, 0)
			if m.PoseToTheFans and beat >= 15 then
				local a = math.sin((beat - 15) * math.pi)
				local b = 1 - a
				if m.DifferentTiming then
					rj.Transform = rj.Transform:Lerp(CFrame.new(0, -3 * scale, 3 * scale) * CFrame.Angles(math.rad(-10), math.rad(-10), 0), a)
					rsj.Transform = CFrame.Angles(arms * b, 0, 3.14 * a)
					lsj.Transform = CFrame.Angles(arms * b, 0, -3.14 * a)
					rhj.Transform = CFrame.Angles(legs * b, 0, 0)
					lhj.Transform = CFrame.Angles(legs * b, 0, 0)
				else
					rj.Transform = rj.Transform:Lerp(CFrame.new(0, -5 * scale, 2 * scale) * CFrame.Angles(math.rad(-10), math.rad(10), 0), a)
					rsj.Transform = CFrame.Angles(arms * b, 0, 1.57 * a)
					lsj.Transform = CFrame.Angles(arms * b, 0, 1 * a)
					rhj.Transform = CFrame.Angles(legs * b, 0, 1 * a)
					lhj.Transform = CFrame.Angles(legs * b, 0, 1.57 * a)
				end
			end
		end
	end
	m.Destroy = function(figure: Model?)
	end
	return m
end)

AddModule(function()
	local m = {}
	m.ModuleType = "DANCE"
	m.Name = "Smug Dance"
	m.Description = "Portal music seems to fit\nIncludes:\n- GladOS's Console\n- Tune from 85.2 FM\n- Dark Mode"
	m.Assets = {"SmugDance.anim", "SmugDance.mp3", "SmugDance2.mp3"}

	m.Deltarolled = false
	m.Config = function(parent: GuiBase2d)
		Util_CreateSwitch(parent, "Dark mode", m.Deltarolled).Changed:Connect(function(val)
			m.Deltarolled = val
		end)
	end
	m.LoadConfig = function(save: any)
		m.Deltarolled = not not save.Deltarolled
	end
	m.SaveConfig = function()
		return {
			Deltarolled = m.Deltarolled
		}
	end

	local animator = nil
	local start = 0
	local lasttime = 0
	local portalgui = {}
	local darkmode = false
	local consolelogs = {
		[false] = {
			{2.5, "##### Console Log Entry start"},
			{3.5, "[Glad log] This was a triumph!"},
			{5.5, "[Glad log] Making a note here..."},
			{6.5, "[Note] \"Huge Success!\""},
			{8.0, "[Glad log] It's hard to overstate my satis-"},
			{10.0, "[ERROR] Oh... the syllables do not fit."},
			{11.4, "[Glad log] Apeture Science."},
			{13.0, "[Apeture Science] What?"},
			{13.4, "[Glad log] Do what we must, because we can."},
			{15.5, "[Apeture Science] Okay?"},
			{16.0, "[Glad log] For the good of all of us..."},
			{18.0, "[Glad log] Except"},
			{18.7, "[Glad log] for"},
			{19.3, "[Glad log] the"},
			{19.6, "[Glad log] ones"},
			{20.0, "[Glad log] who"},
			{20.3, "[Glad log] are"},
			{20.7, "[Glad log] already"},
			{21.7, "[Glad log] dead"},
		},
		[true] = {
			{2.5, "##### Console Log Entry start"},
			{3.5, "[Delta log] When the light is running low."},
			{5.5, "[Delta log] And the shadows start to grow."},
			{7.8, "[Delta log] And the places that you know."},
			{9.5, "[Delta log] Seems like fantasy."},
			{11.5, "[Delta log] There's a light inside your soul."},
			{13.6, "[Delta log] That's still shining in the cold."},
			{15.8, "[Delta log] With the truth."},
			{16.7, "[Delta log] The promise in our-"},
			{18.0, "[Delta log] Don't"},
			{18.5, "[Delta log] Forget"},
			{19.5, "[Delta log] That I am"},
			{20.0, "[Delta log] With"},
			{20.3, "[Delta log] You"},
			{20.7, "[Delta log] In the"},
			{21.7, "[Delta log] Dark"},
		},
	}
	local function setmusic()
		if math.random(10) == 1 or m.Deltarolled then
			darkmode = true
			SetOverrideDanceMusic(AssetGetContentId("SmugDance2.mp3"), "Portal Radio", 1)
		else
			darkmode = false
			SetOverrideDanceMusic(AssetGetContentId("SmugDance.mp3"), "Portal Radio", 1)
		end
	end
	m.Init = function(figure: Model)
		start = tick()
		setmusic()
		animator = AnimLib.Animator.new()
		animator.rig = figure
		animator.looped = true
		animator.track = AnimLib.Track.fromfile(AssetGetPathFromFilename("SmugDance.anim"))
		animator.speed = 1.152266177
		for _,v in portalgui do v:Destroy() end
		local float = Instance.new("Part")
		float.Color = Color3.new(0, 0, 0)
		float.Transparency = 0.5
		float.Anchored = true
		float.CanCollide = false
		float.CanTouch = false
		float.CanQuery = false
		float.Name = "PortalGui"
		float.Size = Vector3.new(5, 4, 0) * figure:GetScale()
		local sgui = Instance.new("SurfaceGui")
		sgui.LightInfluence = 0
		sgui.Brightness = 5
		sgui.AlwaysOnTop = false
		sgui.MaxDistance = 100
		sgui.SizingMode = Enum.SurfaceGuiSizingMode.FixedSize
		sgui.CanvasSize = Vector2.new(150, 120)
		sgui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
		local frame = Instance.new("Frame")
		frame.Position = UDim2.new(0, 0, 0, 0)
		frame.Size = UDim2.new(1, 0, 1, 0)
		frame.BackgroundColor3 = Color3.new(0, 0, 0)
		frame.BackgroundTransparency = 0.5
		frame.BorderColor3 = Color3.new(1, 0.5, 0)
		frame.BorderSizePixel = 1
		frame.BorderMode = Enum.BorderMode.Inset
		frame.ClipsDescendants = true
		local text = Instance.new("TextLabel")
		text.AnchorPoint = Vector2.new(0, 1)
		text.Position = UDim2.new(0, 2, 1, -2)
		text.Size = UDim2.new(1, -4, 3, 0)
		text.BackgroundTransparency = 1
		text.ClipsDescendants = true
		text.FontFace = Font.fromId(12187371840)
		text.TextColor3 = Color3.new(1, 0.5, 0)
		text.TextXAlignment = Enum.TextXAlignment.Left
		text.TextYAlignment = Enum.TextYAlignment.Bottom
		text.TextWrapped = true
		text.TextSize = 8
		text.Text = ""
		text.Parent = frame
		frame.Parent = sgui
		sgui.Parent = float
		float.Parent = figure
		portalgui = {text, frame, sgui, float}
		local root = figure:FindFirstChild("HumanoidRootPart")
		if not root then return end
		float.CFrame = root.CFrame
	end
	m.Update = function(dt: number, figure: Model)
		local t = GetOverrideDanceMusicTime()
		if lasttime > t then
			setmusic()
			SetOverrideDanceMusicTime(t)
		end
		lasttime = t
		local t2 = tick() - start
		animator:Step(t2)
		local root = figure:FindFirstChild("HumanoidRootPart")
		if not root then return end
		t2 += 60
		local scale = figure:GetScale()
		local tcf = root.CFrame * CFrame.new(3 * scale, (1 + math.sin(t2 * 0.89)) * scale, 2 * scale) * CFrame.Angles(math.rad(10 + 10 * math.sin(t2 * 1.12)), math.rad(10 + 10 * math.sin(t2 * 0.98)), math.rad(20 * math.sin(t2)))
		local float, text = portalgui[4], portalgui[1]
		if float then
			if (tcf.Position - float.Position).Magnitude > 20 * scale then
				float.CFrame = root.CFrame
			end
			float.CFrame = tcf:Lerp(float.CFrame, math.exp(-24 * dt))
		end
		if text then
			local str = ""
			local arr = consolelogs[darkmode]
			for i=1, #arr do
				if arr[i][1] <= t then
					str ..= "\n" .. arr[i][2]
				end
			end
			text.Text = str
		end
	end
	m.Destroy = function(figure: Model?)
		animator = nil
		for _,v in portalgui do v:Destroy() end
		portalgui = {}
	end
	return m
end)

AddModule(function()
	local m = {}
	m.ModuleType = "DANCE"
	m.Name = "INTERNET ANGEL"
	m.Description = "Needy Girl Overdose\n\nthe 67th angel of evangelion\nonly way to beat it is use a fire wall"
	m.Assets = {"InternetAngel.anim", "InternetAngelEva.anim", "InternetAngelNeedy.anim", "InternetAngel.mp3"}

	m.FullVersion = false
	m.Effects = true
	m.Config = function(parent: GuiBase2d)
		Util_CreateSwitch(parent, "Effects", m.Effects).Changed:Connect(function(val)
			m.Effects = val
		end)
		Util_CreateSwitch(parent, "Complete", m.FullVersion).Changed:Connect(function(val)
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
	local animator3 = nil
	local textsandstuff = nil
	m.Init = function(figure: Model)
		start = tick()
		if m.FullVersion then
			SetOverrideDanceMusic(AssetGetContentId("InternetAngel.mp3"), "NEEDY GIRL OVERDOSE - INTERNET ANGEL", 1)
		else
			SetOverrideDanceMusic(AssetGetContentId("InternetAngel.mp3"), "NEEDY GIRL OVERDOSE - INTERNET ANGEL", 1, NumberRange.new(36, 60))
			SetOverrideDanceMusicTime(36)
		end
		animator1 = AnimLib.Animator.new()
		animator1.rig = figure
		animator1.looped = true
		animator1.track = AnimLib.Track.fromfile(AssetGetPathFromFilename("InternetAngel.anim"))
		animator1.map = {{36, 60}, {0, 23.72}}
		animator2 = AnimLib.Animator.new()
		animator2.rig = figure
		animator2.looped = true
		animator2.track = AnimLib.Track.fromfile(AssetGetPathFromFilename("InternetAngelNeedy.anim"))
		animator2.map = {{0, 0.75}, {0, 0.8}}
		animator3 = AnimLib.Animator.new()
		animator3.rig = figure
		animator3.looped = false
		animator3.track = AnimLib.Track.fromfile(AssetGetPathFromFilename("InternetAngelEva.anim"))
		animator3.map = {{0, 13.5}, {0, 14.37}}
		if textsandstuff then textsandstuff:Destroy() end
		if m.Effects then
			textsandstuff = Instance.new("Part")
			textsandstuff.Transparency = 1
			textsandstuff.Anchored = true
			textsandstuff.CanCollide = false
			textsandstuff.CanTouch = false
			textsandstuff.CanQuery = false
			textsandstuff.Name = "INTERNETANGEL"
			textsandstuff.Size = Vector3.new(12, 6, 0) * figure:GetScale()
			local sgui = Instance.new("SurfaceGui")
			sgui.LightInfluence = 0
			sgui.Brightness = 1
			sgui.AlwaysOnTop = false
			sgui.MaxDistance = 1000
			sgui.SizingMode = Enum.SurfaceGuiSizingMode.FixedSize
			sgui.CanvasSize = Vector2.new(360, 180)
			sgui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
			sgui.Name = "UI"
			sgui.Parent = textsandstuff
			local id = 0
			local function addtext(t, x, y, sx, sy, align)
				local text = Instance.new("TextLabel")
				text.Position = UDim2.new(0, x, 0, y)
				text.Size = UDim2.new(0, sx, 0, sy)
				text.BackgroundTransparency = 1
				text.ClipsDescendants = true
				text.FontFace = Font.fromId(12187371840)
				text.TextColor3 = Color3.new(1, 1, 1)
				text.TextXAlignment = align
				text.TextYAlignment = Enum.TextYAlignment.Center
				text.TextScaled = true
				text.Text = t
				text.Name = tostring(id)
				text.Parent = sgui
				id += 1
			end
			addtext("NEEDY", 20, 65, 320, 50, 0) -- 0
			addtext("GIRL", 20, 65, 320, 50, 1) -- 1
			addtext("NEEDY", 180, 45, 180, 30, 2) -- 2
			addtext("GIRL", 0, 105, 180, 30, 2) -- 3
			addtext("A N G E L", 0, 0, 360, 60, 2) -- 4
			addtext("\n\nn e e d y\n\ng i r l\n\no v e r d o s e", 0, 45, 360, 45, 2) -- 5
			addtext("\n\nn e e d y\n\ng i r l\n\no v e r d o s e", 0, 90, 360, 45, 2) -- 6
			addtext("\n\nn e e d y\n\ng i r l\n\no v e r d o s e", 0, 135, 360, 45, 2) -- 7
			addtext("INTERNET", 20, 40, 320, 40, 0) -- 8
			addtext("INTERNET", 20, 40, 320, 40, 2) -- 9
			addtext("INTERNET", 20, 40, 320, 40, 1) -- 10
			addtext("INTERNET", 20, 70, 320, 40, 0) -- 11
			addtext("INTERNET", 20, 70, 320, 40, 2) -- 12
			addtext("INTERNET", 20, 70, 320, 40, 1) -- 13
			addtext("INTERNET", 20, 100, 320, 40, 0) -- 14
			addtext("INTERNET", 20, 100, 320, 40, 2) -- 15
			addtext("INTERNET", 20, 100, 320, 40, 1) -- 16
			addtext("ANGEL", 0, 0, 360, 180, 2) -- 17
			addtext("INTERNET", 20, 80, 320, 20, 2) -- 18
			addtext("INTERNET", 20, 85, 320, 10, 2) -- 19
			addtext("P A T T E R N   B L U E", 60, 80, 240, 10, 1) -- 20
			addtext("A N G E L", 60, 100, 240, 10, 2) -- 21
			addtext("NEEDY GIRL", 20, 65, 320, 50, 0) -- 22
			addtext("NEEDY GIRL", 20, 65, 320, 50, 1) -- 23
			addtext("\"I-N-TE-RU-NE-TO\"", 0, 160, 360, 10, 2) -- 24
			addtext("\"ANGEL\"", 0, 160, 360, 10, 2) -- 25
			addtext("\"NEEDY GIRL\"", 0, 160, 360, 10, 2) -- 26
			textsandstuff.Parent = figure
		end
	end
	m.Update = function(dt: number, figure: Model)
		local t = GetOverrideDanceMusicTime()
		local textvis = {}
		if t < 10.5 then
			animator2:Step(t)
			local needy = t % 6
			if needy < 1.5 then
				textvis[0] = true
			elseif needy < 3 then
				textvis[1] = true
			else
				textvis[2] = true
				textvis[3] = true
			end
		elseif t < 24 then
			animator3:Step(t - 10.5)
			if t < 12 then
				if t % 0.75 < 0.375 then
					textvis[4] = true
				end
				if (t + 0.000) % 1 < 0.7 then textvis[5] = true end
				if (t + 0.333) % 1 < 0.7 then textvis[6] = true end
				if (t + 0.667) % 1 < 0.7 then textvis[7] = true end
			else
				local eva = (t - 12) / 0.75
				if eva % 4 < 3 then
					textvis[24] = true
				else
					textvis[25] = true
				end
				if eva < 1 then
					textvis[8] = true
				elseif eva < 2 then
					textvis[16] = true
				elseif eva < 3 then
					textvis[12] = true
				elseif eva < 4 then
					textvis[17] = true
				elseif eva < 5 then
					textvis[12] = true
				elseif eva < 6 then
					textvis[18] = true
				elseif eva < 7 then
					textvis[19] = true
				elseif eva < 7.5 then
					textvis[17] = true
				elseif eva < 7.625 then
					textvis[8] = true
				elseif eva < 7.75 then
					textvis[10] = true
				elseif eva < 7.875 then
					textvis[14] = true
				elseif eva < 8 then
					textvis[16] = true
				elseif eva < 9 then
					textvis[14] = true
				elseif eva < 10 then
					textvis[10] = true
					textvis[20] = true
				elseif eva < 11 then
					textvis[18] = true
					textvis[21] = true
				elseif eva < 12 then
					textvis[21] = true
				elseif eva < 13 then
					textvis[13] = true
				elseif eva < 14 then
					textvis[11] = true
				elseif eva < 15 then
					textvis[16] = true
				else
					textvis[20] = true
					textvis[7] = true
				end
			end
		elseif t < 34.5 then
			local needy = t % 6
			if needy < 4.5 then
				animator2:Step(t)
			else
				animator3:Step(needy - 3)
			end
			if needy < 0.75 then
			elseif needy < 1.5 then
				textvis[22] = true
				textvis[26] = true
			elseif needy < 2.25 then
			elseif needy < 3 then
				textvis[23] = true
				textvis[26] = true
			elseif needy < 3.75 then
				textvis[2] = true
				textvis[3] = true
			elseif needy < 4.5 then
				textvis[2] = true
				textvis[3] = true
				textvis[26] = true
			elseif needy < 5.25 then
				textvis[18] = true
				textvis[21] = true
				textvis[7] = true
				textvis[24] = true
			else
				textvis[18] = true
				textvis[21] = true
				textvis[7] = true
				textvis[25] = true
			end
		elseif t < 36 then
			animator3:Step(t - 34.5)
			for i=1, 23 do textvis[i] = math.random(3) == 1 end
		else
			local eva = (t - 36) / 0.75
			if t < 48 then
				if eva % 4 < 3 then
					textvis[24] = true
				else
					textvis[25] = true
				end
			else
				local needy = t % 6
				if needy < 0.75 then
				elseif needy < 1.5 then
					textvis[26] = true
				elseif needy < 2.25 then
				elseif needy < 3 then
					textvis[26] = true
				elseif needy < 3.75 then
				elseif needy < 4.5 then
					textvis[26] = true
				elseif needy < 5.25 then
					textvis[24] = true
				else
					textvis[25] = true
				end
			end
			animator1:Step(t - 36)
		end
		local root = figure:FindFirstChild("HumanoidRootPart")
		if not root then return end
		local scale = figure:GetScale()
		if textsandstuff then
			textsandstuff.CFrame = root.CFrame * CFrame.new(0, 0, -2 * scale)
			local ui = textsandstuff:FindFirstChild("UI")
			if ui then
				for _,v in ui:GetChildren() do
					if v:IsA("TextLabel") and tonumber(v.Name) then
						v.Visible = not not textvis[tonumber(v.Name)]
					end
				end
			end
		end
	end
	m.Destroy = function(figure: Model?)
		animator1 = nil
		animator2 = nil
		animator3 = nil
		if textsandstuff then textsandstuff:Destroy() textsandstuff = nil end
	end
	return m
end)

AddModule(function()
	local m = {}
	m.ModuleType = "DANCE"
	m.Name = "Stocks"
	m.Description = "the graph is pointing UP!\n\nthanks to the consultant\notherwise itll be pointing DOWN\n(this is a pencilmation reference)"
	m.Assets = {"StockDance.anim", "StockDance.mp3"}

	m.Config = function(parent: GuiBase2d)
	end

	local animator = nil
	m.Init = function(figure: Model)
		SetOverrideDanceMusic(AssetGetContentId("StockDance.mp3"), "Lights, Camera, Action! - Sonic Mania", 1)
		animator = AnimLib.Animator.new()
		animator.rig = figure
		animator.track = AnimLib.Track.fromfile(AssetGetPathFromFilename("StockDance.anim"))
		animator.looped = false
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
	m.Name = "DO THE FLOP"
	m.Description = "Don't jump! You have so much to live for!\nEVERYBODY DO THE FLOP! *FLOP*\n*SPLAT*"
	m.Assets = {"DoTheFlop.anim", "DoTheFlop.mp3"}

	m.Once = false
	m.Config = function(parent: GuiBase2d)
		Util_CreateSwitch(parent, "Not looped", m.Once).Changed:Connect(function(val)
			m.Once = val
		end)
	end
	m.LoadConfig = function(save: any)
		m.Once = not not save.Once
	end
	m.SaveConfig = function()
		return {
			Once = m.Once
		}
	end

	local animator = nil
	m.Init = function(figure: Model)
		if m.Once then
			SetOverrideDanceMusic(AssetGetContentId("DoTheFlop.mp3"), "asdfmovie - Do The Flop", 1, NumberRange.new(16.592, 16.593))
			SetOverrideDanceMusicTime(14.746)
		else
			SetOverrideDanceMusic(AssetGetContentId("DoTheFlop.mp3"), "asdfmovie - Do The Flop", 1)
		end
		animator = AnimLib.Animator.new()
		animator.rig = figure
		animator.track = AnimLib.Track.fromfile(AssetGetPathFromFilename("DoTheFlop.anim"))
		animator.looped = false
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
	m.Name = "INTERNET YAMERO"
	m.Description = "me when i lag in tsb\n\"STOP LAGGING ME INTERNET\""
	m.Assets = {"InternetYamero.anim", "InternetYameroSickTock.anim", "InternetYamero.mp3"}

	m.FullVersion = false
	m.Config = function(parent: GuiBase2d)
		Util_CreateSwitch(parent, "Complete", m.FullVersion).Changed:Connect(function(val)
			m.FullVersion = val
		end)
	end
	m.LoadConfig = function(save: any)
		m.FullVersion = not not save.FullVersion
	end
	m.SaveConfig = function()
		return {
			FullVersion = m.FullVersion
		}
	end

	local animator1 = nil
	local animator2 = nil
	m.Init = function(figure: Model)
		if m.FullVersion then
			SetOverrideDanceMusic(AssetGetContentId("InternetYamero.mp3"), "NEEDY GIRL OVERDOSE - INTERNET YAMERO", 1)
		else
			SetOverrideDanceMusic(AssetGetContentId("InternetYamero.mp3"), "NEEDY GIRL OVERDOSE - INTERNET YAMERO", 1, NumberRange.new(21.394, 62.94))
			SetOverrideDanceMusicTime(21.394)
		end
		animator1 = AnimLib.Animator.new()
		animator1.rig = figure
		animator1.track = AnimLib.Track.fromfile(AssetGetPathFromFilename("InternetYameroSickTock.anim"))
		animator1.looped = false
		animator2 = AnimLib.Animator.new()
		animator2.rig = figure
		animator2.track = AnimLib.Track.fromfile(AssetGetPathFromFilename("InternetYamero.anim"))
		animator2.looped = true
		animator2.map = {{11, 62.944}, {0, 53.33333}}
	end
	m.Update = function(dt: number, figure: Model)
		local t = GetOverrideDanceMusicTime()
		if t < 11 then
			animator1:Step(t)
		elseif t < 18.667 then
			animator2:Step(t)
		elseif t < 19.333 then
			animator2:Step(math.min((t - 18.667) / 0.1, 1.2))
		elseif t < 20 then
			animator2:Step(math.min((t - 19.333) / 0.1, 1.34))
		elseif t < 21.333 then
			animator2:Step(t * 100)
		else
			animator2:Step(t)
		end
	end
	m.Destroy = function(figure: Model?)
		animator1 = nil
		animator2 = nil
	end
	return m
end)

AddModule(function()
	local m = {}
	m.ModuleType = "DANCE"
	m.Name = "Tenna Cabbage Dance"
	m.Description = "try not to do this dance wrong challenge\ndifficulty: impossible"
	m.Assets = {"TennaCabbage.anim", "TennaBaciPerugina.mp3"}

	m.Config = function(parent: GuiBase2d)
	end

	local animator = nil
	local start = 0
	m.Init = function(figure: Model)
		SetOverrideDanceMusic(AssetGetContentId("TennaBaciPerugina.mp3"), "Deltarune - TV TIME", 1)
		start = tick()
		animator = AnimLib.Animator.new()
		animator.rig = figure
		animator.looped = true
		animator.speed = 0.9 + 0.2 * math.random()
		animator.track = AnimLib.Track.fromfile(AssetGetPathFromFilename("TennaCabbage.anim"))
	end
	m.Update = function(dt: number, figure: Model)
		local t = tick()
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
	m.Name = "Tenna Swingy Dance"
	m.Description = "r6"
	m.Assets = {"TennaSwing.anim", "TennaBaciPerugina.mp3"}

	m.Config = function(parent: GuiBase2d)
	end

	local animator = nil
	local start = 0
	m.Init = function(figure: Model)
		SetOverrideDanceMusic(AssetGetContentId("TennaBaciPerugina.mp3"), "Deltarune - TV TIME", 1)
		start = tick()
		animator = AnimLib.Animator.new()
		animator.rig = figure
		animator.looped = true
		animator.speed = 0.9 + 0.2 * math.random()
		animator.track = AnimLib.Track.fromfile(AssetGetPathFromFilename("TennaSwing.anim"))
	end
	m.Update = function(dt: number, figure: Model)
		local t = tick()
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
	m.Name = "Squidward Yell"
	m.Description = "erm what the stick ma\nthis is the best animation library benchmarker\nthe second variant's original \"animation file\" was 10MB. it has been magically reduced to 1MB using C struct magic. (STEVE's KeyframeSequence file format)\nits also optimised down to 3714 keyframes\nthe third variant was reduced from 16MB to 2MB, and trimmed to 5742 keyframes.\nthe first, 9MB to 1MB, trimmed to 3216 keyframes."
	m.Assets = {"SquidwardYell1.anim", "SquidwardYell1.mp3", "SquidwardYell2.anim", "SquidwardYell2.mp3", "SquidwardYell3.anim", "SquidwardYell3.mp3"}

	m.Variant = 1
	m.Config = function(parent: GuiBase2d)
		Util_CreateDropdown(parent, "Variant", {"Second", "Third", "First"}, m.Variant).Changed:Connect(function(val)
			m.Variant = val
		end)
	end
	m.LoadConfig = function(save: any)
		m.Variant = save.Variant or m.Variant
	end
	m.SaveConfig = function()
		return {
			Variant = m.Variant
		}
	end

	local animator = nil
	m.Init = function(figure: Model)
		animator = AnimLib.Animator.new()
		animator.rig = figure
		animator.looped = false
		if m.Variant == 1 then
			SetOverrideDanceMusic(AssetGetContentId("SquidwardYell1.mp3"), "Zivixius - Squidward Yell 2", 1)
			animator.track = AnimLib.Track.fromfile(AssetGetPathFromFilename("SquidwardYell1.anim"))
		end
		if m.Variant == 2 then
			SetOverrideDanceMusic(AssetGetContentId("SquidwardYell2.mp3"), "Zivixius - Squidward Yell 3", 1)
			animator.track = AnimLib.Track.fromfile(AssetGetPathFromFilename("SquidwardYell2.anim"))
		end
		if m.Variant == 3 then
			SetOverrideDanceMusic(AssetGetContentId("SquidwardYell3.mp3"), "Zivixius - Squidward Yell", 1)
			animator.track = AnimLib.Track.fromfile(AssetGetPathFromFilename("SquidwardYell3.anim"))
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
	m.Name = "Take The L"
	m.Description = "accept the loss man\njust accept the loss\ncmon\ngood boy~ <33"
	m.Assets = {"TakeTheL.anim", "TakeTheLDubmood.mp3"}

	m.Config = function(parent: GuiBase2d)
	end

	local animator = nil
	local start = 0
	m.Init = function(figure: Model)
		start = tick()
		animator = AnimLib.Animator.new()
		animator.rig = figure
		animator.looped = true
		SetOverrideDanceMusic(AssetGetContentId("TakeTheLDubmood.mp3"), "Dubmood+Zabutom+Ogge - Razor Comeback Intro", 1)
		animator.track = AnimLib.Track.fromfile(AssetGetPathFromFilename("TakeTheL.anim"))
	end
	m.Update = function(dt: number, figure: Model)
		animator:Step(tick() - start)
	end
	m.Destroy = function(figure: Model?)
		animator = nil
	end
	return m
end)

AddModule(function()
	local m = {}
	m.ModuleType = "DANCE"
	m.Name = "Torture Dance"
	m.Description = "im gonna put a magnifying glass on ur eyes\nand dance while your eyes burn\nitll feel like a burning sunlight"
	m.Assets = {"TortureDance1.anim", "TortureDance2.anim", "TortureDance.mp3"}

	local animator = nil
	local start = 0
	m.Init = function(figure: Model)
		start = tick()
		animator = AnimLib.Animator.new()
		animator.rig = figure
		animator.looped = true
		SetOverrideDanceMusic(AssetGetContentId("TortureDance.mp3"), "JoJo's Bizzare Adventure - Torture Dance", 1, NumberRange.new(1.234, 140.28))
		if math.random() < 0.5 then
			animator.track = AnimLib.Track.fromfile(AssetGetPathFromFilename("TortureDance1.anim"))
		else
			animator.track = AnimLib.Track.fromfile(AssetGetPathFromFilename("TortureDance2.anim"))
		end
	end
	m.Update = function(dt: number, figure: Model)
		animator:Step(tick() - start)
	end
	m.Destroy = function(figure: Model?)
		animator = nil
	end
	return m
end)

AddModule(function()
	local m = {}
	m.ModuleType = "DANCE"
	m.Name = "Kazotsky Kick+"
	m.Description = "the + is for the variants\null see why"
	m.Assets = {"Kazotsky.anim", "KazotskyDemoman.anim", "KazotskyEngineer.anim", "KazotskyHeavy.anim", "KazotskyMedic.anim", "KazotskyPyro.anim", "KazotskyScout.anim", "KazotskySniper.anim", "KazotskySoldier.anim", "KazotskySpy.anim", "Kazotsky.mp3"}

	m.Variant = 1
	m.Config = function(parent: GuiBase2d)
		Util_CreateDropdown(parent, "Variant", {"Regular", "TF2 Demoman", "TF2 Engineerman", "TF2 Heavyman", "TF2 Medicman", "TF2 Pyroman", "TF2 Scout", "TF2 Sniperman", "TF2 Soldierman", "TF2 Spyman", "Gordon Freeman"}, m.Variant).Changed:Connect(function(val)
			m.Variant = val
		end)
	end
	m.LoadConfig = function(save: any)
		m.Variant = save.Variant or m.Variant
	end
	m.SaveConfig = function()
		return {
			Variant = m.Variant
		}
	end

	local animator = nil
	local start = 0
	m.Init = function(figure: Model)
		start = tick()
		animator = AnimLib.Animator.new()
		animator.rig = figure
		animator.looped = true
		SetOverrideDanceMusic(AssetGetContentId("Kazotsky.mp3"), "some russian music idk", 1)
		local variants = {"", "Demoman", "Engineer", "Heavy", "Medic", "Pyro", "Scout", "Sniper", "Soldier", "Spy"}
		animator.track = AnimLib.Track.fromfile(AssetGetPathFromFilename("Kazotsky" .. (variants[m.Variant] or "") .. ".anim"))
	end
	m.Update = function(dt: number, figure: Model)
		animator:Step(tick() - start)
	end
	m.Destroy = function(figure: Model?)
		animator = nil
	end
	return m
end)

AddModule(function()
	local m = {}
	m.ModuleType = "DANCE"
	m.Name = "Doodle"
	m.Description = "its for the small hitbox trust\n\nthis tune is fuhhing :3333"
	m.Assets = {"Doodle.anim", "Doodle.mp3", "Doodle2.mp3"}

	m.Config = function(parent: GuiBase2d)
	end

	local animator = nil
	local start = 0
	m.Init = function(figure: Model)
		start = tick()
		animator = AnimLib.Animator.new()
		animator.rig = figure
		animator.looped = true
		animator.track = AnimLib.Track.fromfile(AssetGetPathFromFilename("Doodle.anim"))
		if math.random() < 0.75 then
			SetOverrideDanceMusic(AssetGetContentId("Doodle.mp3"), "Zachz Winner - doodle", 1)
		else
			SetOverrideDanceMusic(AssetGetContentId("Doodle2.mp3"), "reconstructed doodle", 1)
		end
	end
	m.Update = function(dt: number, figure: Model)
		animator:Step(tick() - start)
	end
	m.Destroy = function(figure: Model?)
		animator = nil
	end
	return m
end)

AddModule(function()
	local m = {}
	m.ModuleType = "DANCE"
	m.Name = "Brain"
	m.Description = "bendy and the ink machine ass beat\npick your poison: garou or gojo"
	m.Assets = {"Brain.anim", "Brain.mp3"}

	m.Alternative = false
	m.Config = function(parent: GuiBase2d)
		Util_CreateSwitch(parent, "Garou slide", m.Alternative).Changed:Connect(function(val)
			m.Alternative = val
		end)
	end
	m.LoadConfig = function(save: any)
		m.Alternative = not not save.Alternative
	end
	m.SaveConfig = function()
		return {
			Alternative = m.Alternative
		}
	end

	local animator = nil
	m.Init = function(figure: Model)
		SetOverrideDanceMusic(AssetGetContentId("Brain.mp3"), "Kanaria - BRAIN", 1)
		animator = AnimLib.Animator.new()
		animator.rig = figure
		animator.looped = true
		animator.map = {{0, 66.527}, {0, 65.52}}
		animator.track = AnimLib.Track.fromfile(AssetGetPathFromFilename("Brain.anim"))
	end
	m.Update = function(dt: number, figure: Model)
		if m.Alternative then
			animator:Step(0.267)
		else
			animator:Step(GetOverrideDanceMusicTime())
		end
		local hum = figure:FindFirstChild("Humanoid")
		if not hum then return end
		hum.WalkSpeed = 8 * figure:GetScale()
	end
	m.Destroy = function(figure: Model?)
		animator = nil
		if not figure then return end
		local hum = figure:FindFirstChild("Humanoid")
		if not hum then return end
		hum.WalkSpeed = 16 * figure:GetScale()
	end
	return m
end)

AddModule(function()
	local m = {}
	m.ModuleType = "DANCE"
	m.Name = "Left Right Left Right"
	m.Description = "up down up down\nburger king, burger throne\n:3 :3 :3 :3 :3"
	m.Assets = {"LeftRight.anim", "LeftRight.mp3"}

	m.Config = function(parent: GuiBase2d)
	end

	local animator = nil
	local start = 0
	m.Init = function(figure: Model)
		SetOverrideDanceMusic(AssetGetContentId("LeftRight.mp3"), "idk this tune", 1)
		animator = AnimLib.Animator.new()
		animator.rig = figure
		animator.looped = true
		animator.track = AnimLib.Track.fromfile(AssetGetPathFromFilename("LeftRight.anim"))
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
	m.Name = "Silly Billy"
	m.Description = "bro that shit aint 'me' :wilted_rose:"
	m.Assets = {"Billy.anim", "Billy2.anim", "Billy.mp3"}

	m.Effects = true
	m.Alternative = false
	m.Config = function(parent: GuiBase2d)
		Util_CreateSwitch(parent, "Effects", m.Effects).Changed:Connect(function(val)
			m.Effects = val
		end)
		Util_CreateSwitch(parent, "Alt. Version", m.Alternative).Changed:Connect(function(val)
			m.Alternative = val
		end)
	end
	m.LoadConfig = function(save: any)
		m.Alternative = not not save.Alternative
		m.Effects = not save.NoEffects
	end
	m.SaveConfig = function()
		return {
			Alternative = m.Alternative,
			NoEffects = not m.Effects
		}
	end

	local animator = nil
	local effects = nil
	local shardsoffset = {}
	for _=1, 8 do table.insert(shardsoffset, math.random() * 0.3) end
	m.Init = function(figure: Model)
		SetOverrideDanceMusic(AssetGetContentId("Billy.mp3"), "FNF VS Yourself mod", 1)
		animator = AnimLib.Animator.new()
		animator.rig = figure
		animator.looped = false
		if m.Alternative then
			animator.track = AnimLib.Track.fromfile(AssetGetPathFromFilename("Billy2.anim"))
		else
			animator.track = AnimLib.Track.fromfile(AssetGetPathFromFilename("Billy.anim"))
		end
		if m.Effects then
			local scale = figure:GetScale()
			effects = Instance.new("Model")
			effects.Name = "SillyBilly"
			local arm = figure:FindFirstChild("Left Arm")
			if arm then
				local handle = Instance.new("Part")
				handle.Name = "MicHandle"
				handle.Color = Color3.new(0, 0, 0)
				handle.Anchored = false
				handle.CanCollide = false
				handle.CanTouch = false
				handle.CanQuery = false
				handle.Size = Vector3.new(1, 0.5, 0.5) * scale
				handle.Shape = "Cylinder"
				handle.Parent = effects
				local grip = Instance.new("Weld")
				grip.Name = "MicGrip"
				grip.Part0 = arm
				grip.Part1 = handle
				grip.C0 = CFrame.new(0, -1 * scale, 0, 0, 0, 1, 0, 1, 0, -1, 0, 0)
				grip.Parent = effects
				local casing = Instance.new("Part")
				casing.Name = "MicRoundThing"
				casing.Color = Color3.new(0, 0, 0)
				casing.Anchored = false
				casing.CanCollide = false
				casing.CanTouch = false
				casing.CanQuery = false
				casing.Size = Vector3.new(1, 1, 1) * scale
				casing.Shape = "Ball"
				casing.Parent = effects
				local weld = Instance.new("Weld")
				weld.Name = "MicWeld"
				weld.Part0 = handle
				weld.Part1 = casing
				weld.C0 = CFrame.new(0.875 * scale, 0, 0)
				weld.Parent = effects
			end
			local function makepart(name, color, mater, size, tra)
				local part = Instance.new("Part")
				part.Name = name
				part.Color = color
				part.Material = mater
				part.Transparency = tra
				part.Anchored = true
				part.CanCollide = false
				part.CanTouch = false
				part.CanQuery = false
				part.Size = size * scale
				part.Parent = effects
			end
			makepart("Glass", Color3.fromRGB(111, 130, 255), Enum.Material.SmoothPlastic, Vector3.new(6, 9, 0.2), 0)
			makepart("Pillar1", Color3.fromRGB(52, 61, 120), Enum.Material.Concrete, Vector3.new(1, 9, 1), 0)
			makepart("Pillar2", Color3.fromRGB(52, 61, 120), Enum.Material.Concrete, Vector3.new(1, 9, 1), 0)
			makepart("Pillar3", Color3.fromRGB(52, 61, 120), Enum.Material.Concrete, Vector3.new(2.5, 1, 2.5), 0)
			makepart("Pillar4", Color3.fromRGB(52, 61, 120), Enum.Material.Concrete, Vector3.new(2.5, 1, 2.5), 0)
			local flash = Instance.new("Highlight")
			flash.Name = "Flash"
			flash.DepthMode = "Occluded"
			flash.Enabled = true
			flash.FillColor = Color3.new(1, 1, 1)
			flash.FillTransparency = 1
			flash.OutlineTransparency = 1
			flash.Parent = effects
			makepart("Particles", Color3.new(0, 0, 0), Enum.Material.Plastic, Vector3.zero, 0, 1)
			local star1 = Instance.new("ParticleEmitter")
			star1.Name = "Star1"
			star1.Enabled = true
			star1.Texture = "rbxasset://textures/particles/sparkles_main.dds"
			star1.Color = ColorSequence.new(Color3.fromRGB(30, 64, 255))
			star1.LightInfluence = 0
			star1.LightEmission = 0
			star1.Brightness = 2
			star1.Size = NumberSequence.new(0)
			star1.Transparency = NumberSequence.new(0.5)
			star1.Orientation = "VelocityPerpendicular"
			star1.EmissionDirection = "Front"
			star1.Lifetime = NumberRange.new(1)
			star1.Rate = 10
			star1.Rotation = NumberRange.new(0)
			star1.RotSpeed = NumberRange.new(-180)
			star1.Speed = NumberRange.new(0.001)
			star1.LockedToPart = true
			star1.ZOffset = 0
			star1.Parent = effects.Particles
			local star2 = star1:Clone()
			star2.Name = "Star2"
			star2.Color = ColorSequence.new(Color3.fromRGB(148, 138, 255))
			star2.Rate = 3
			star2.ZOffset = 1
			star2.Parent = effects.Particles
			for i=1, 8 do
				local shard = Instance.new("WedgePart")
				shard.Name = "Shard" .. i
				shard.Color = Color3.fromRGB(111, 130, 255)
				shard.Material = Enum.Material.SmoothPlastic
				shard.Anchored = true
				shard.CanCollide = false
				shard.CanTouch = false
				shard.CanQuery = false
				shard.Size = Vector3.new(0.2, 4.5, 3)
				shard.Parent = effects
			end
			effects.Parent = figure
		end
	end
	m.Update = function(dt: number, figure: Model)
		local t = GetOverrideDanceMusicTime()
		animator:Step(t)
		local root = figure:FindFirstChild("HumanoidRootPart")
		if not root then return end
		if effects then
			local scale = figure:GetScale()
			local group1t = 1 - math.pow(1 - math.clamp(t - 11, 0, 1), 3)
			group1t -= math.max(0, t - 44.537)
			local glass = effects:FindFirstChild("Glass")
			local pillar1 = effects:FindFirstChild("Pillar1")
			local pillar2 = effects:FindFirstChild("Pillar2")
			local pillar3 = effects:FindFirstChild("Pillar3")
			local pillar4 = effects:FindFirstChild("Pillar4")
			local flash = effects:FindFirstChild("Flash")
			local pcles = effects:FindFirstChild("Particles")
			if glass then
				glass.CFrame = root.CFrame * CFrame.new(Vector3.new(0, 1.5, 2 - group1t) * scale)
				if t < 6.9 or t > 30 then
					glass.Transparency = 0.2 + 0.8 * group1t
				else
					glass.Transparency = 1
				end
			end
			for i=1, 8 do
				local j = i - 1
				local shard = effects:FindFirstChild("Shard" .. i)
				if shard then
					local cf = CFrame.new((CFrame.Angles(0, 0, (j // 2) * math.pi * 0.5) * Vector3.new(1, 1, 0) * scale) * Vector3.new(1.5, 2.25, 0)) * CFrame.Angles(0, -math.pi / 2, 0)
					if (j // 2) % 2 == 0 then
						cf *= CFrame.Angles(0, math.pi, 0)
					end
					if j % 2 == 0 then
						cf *= CFrame.Angles(math.pi, 0, 0)
					end
					shard.CFrame = root.CFrame * CFrame.new(0, 1.5 * scale, (2 - group1t + shardsoffset[i]) * scale) * cf
					shard.Size = Vector3.new(0.2, 4.5, 3) * scale
					if t < 6.9 or t > 30 then
						shard.Transparency = 1
					else
						shard.Transparency = 0.2 + 0.8 * group1t
					end
				end
			end
			if pillar1 then
				pillar1.CFrame = root.CFrame * CFrame.new(Vector3.new(3.5, 1.5, 2 - group1t) * scale)
				pillar1.Transparency = group1t
			end
			if pillar2 then
				pillar2.CFrame = root.CFrame * CFrame.new(Vector3.new(-3.5, 1.5, 2 - group1t) * scale)
				pillar2.Transparency = group1t
			end
			if pillar3 then
				pillar3.CFrame = root.CFrame * CFrame.new(Vector3.new(3.5, -2.5, 2 - group1t) * scale)
				pillar3.Transparency = group1t
			end
			if pillar4 then
				pillar4.CFrame = root.CFrame * CFrame.new(Vector3.new(-3.5, -2.5, 2 - group1t) * scale)
				pillar4.Transparency = group1t
			end
			if flash then
				if t < 6.9 then
					flash.FillTransparency = 1
				else
					flash.FillTransparency = 0.5 + 0.5 * math.min(t - 6.9, 1)
				end
			end
			if pcles then
				pcles.CFrame = root.CFrame * CFrame.new(Vector3.new(0, 0.25, 3) * scale)
				local starflash = 2
				if t < 18.05 then
					starflash = 2
				elseif t < 23.6 then
					starflash = 2 + 5 * (1 - math.min(t - 18.05, 5) / 5)
				else
					starflash = 5
				end
				local star1 = pcles:FindFirstChild("Star1")
				local star2 = pcles:FindFirstChild("Star2")
				if star1 then
					star1.Size = NumberSequence.new({
						NumberSequenceKeypoint.new(0, 8 * group1t * scale, 2 * group1t * scale),
						NumberSequenceKeypoint.new(1, 8 * group1t * scale, 2 * group1t * scale),
					})
					star1.Brightness = starflash
				end
				if star2 then
					star2.Size = NumberSequence.new(5 * group1t * scale)
					star2.Brightness = starflash
				end
			end
		end
	end
	m.Destroy = function(figure: Model?)
		animator = nil
		if effects then
			effects:Destroy()
			effects = nil
		end
	end
	return m
end)

AddModule(function()
	local m = {}
	m.ModuleType = "DANCE"
	m.Name = "Skipping"
	m.Description = ":D"
	m.Assets = {"SkippingHappily.anim", "SkippingHappily.mp3"}

	m.Config = function(parent: GuiBase2d)
	end

	local animator = nil
	local start = 0
	m.Init = function(figure: Model)
		SetOverrideDanceMusic(AssetGetContentId("SkippingHappily.mp3"), "idk this tune", 1)
		start = tick()
		animator = AnimLib.Animator.new()
		animator.rig = figure
		animator.looped = true
		animator.track = AnimLib.Track.fromfile(AssetGetPathFromFilename("SkippingHappily.anim"))
	end
	m.Update = function(dt: number, figure: Model)
		animator:Step(tick() - start)
		local hum = figure:FindFirstChild("Humanoid")
		if not hum then return end
		hum.WalkSpeed = 8 * figure:GetScale()
	end
	m.Destroy = function(figure: Model?)
		animator = nil
		if not figure then return end
		local hum = figure:FindFirstChild("Humanoid")
		if not hum then return end
		hum.WalkSpeed = 16 * figure:GetScale()
	end
	return m
end)

AddModule(function()
	local m = {}
	m.ModuleType = "DANCE"
	m.Name = "Backflips"
	m.Description = "dance like you have 62 seconds left!\n\n(this is an evangelion reference ofc)"
	m.Assets = {"Backflips.anim", "Backflips.mp3"}

	m.Config = function(parent: GuiBase2d)
	end

	local animator = nil
	local start = 0
	local force = nil
	m.Init = function(figure: Model)
		SetOverrideDanceMusic(AssetGetContentId("Backflips.mp3"), "Both Of You, Dance Like You Want To Win", 1)
		start = tick()
		animator = AnimLib.Animator.new()
		animator.rig = figure
		animator.looped = true
		animator.track = AnimLib.Track.fromfile(AssetGetPathFromFilename("Backflips.anim"))
		force = Instance.new("BodyVelocity")
		force.P = 9e4
		force.MaxForce = Vector3.new(math.huge, 0, math.huge)
		force.Parent = figure.HumanoidRootPart
	end
	m.Update = function(dt: number, figure: Model)
		animator:Step(tick() - start)
		local hum = figure:FindFirstChild("Humanoid")
		if not hum or not hum.RootPart then return end
		hum.WalkSpeed = 0.05
		if hum.MoveDirection.Magnitude > 0 then
			-- move backwards
			force.Velocity = Vector3.new(
				hum.MoveDirection.X * -8 * figure:GetScale(),
				0,
				hum.MoveDirection.Z * -8 * figure:GetScale()
			)
		else
			force.Velocity = Vector3.zero
		end
	end
	m.Destroy = function(figure: Model?)
		animator = nil
		force:Destroy()
		if not figure then return end
		local hum = figure:FindFirstChild("Humanoid")
		if not hum or not hum.RootPart then return end
		hum.WalkSpeed = 16 * figure:GetScale()
	end
	return m
end)

AddModule(function()
	local m = {}
	m.ModuleType = "DANCE"
	m.Name = "Headlock"
	m.Description = "bakas bakas bakas bakas baka sekao"
	m.Assets = {"Headlock.anim", "Headlock.mp3"}

	m.Config = function(parent: GuiBase2d)
	end

	local animator = nil
	m.Init = function(figure: Model)
		SetOverrideDanceMusic(AssetGetContentId("Headlock.mp3"), "Nakama - DIA DELICIA", 1, NumberRange.new(0, 73.866))
		animator = AnimLib.Animator.new()
		animator.rig = figure
		animator.looped = true
		animator.map = {{0, 73.866}, {0, 73.8}}
		animator.track = AnimLib.Track.fromfile(AssetGetPathFromFilename("Headlock.anim"))
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
	m.Name = "Cat Dance"
	m.Description = "colonthreespam\nthe smallest dance in the whole nekocollection\n\ngarou slide is still smaller-"
	m.Assets = {"CatDance.anim"}

	m.Config = function(parent: GuiBase2d)
	end

	local animator = nil
	local start = 0
	m.Init = function(figure: Model)
		start = tick()
		SetOverrideDanceMusic("rbxassetid://9039445224", "8 Bitty Kitty Underscore", 1)
		animator = AnimLib.Animator.new()
		animator.rig = figure
		animator.looped = true
		animator.track = AnimLib.Track.fromfile(AssetGetPathFromFilename("CatDance.anim"))
	end
	m.Update = function(dt: number, figure: Model)
		animator:Step(tick() - start)
	end
	m.Destroy = function(figure: Model?)
		animator = nil
	end
	return m
end)

AddModule(function()
	local m = {}
	m.ModuleType = "DANCE"
	m.Name = "Default Dance"
	m.Description = "FORTY NIGHTY LA PABAJI\npabaji\nPABAJI LA EKES BOKES SERES EKES\npabaji\nPABAJI LA BALESTESHONFAIV\nbalesteshon... faiv...\nBALESTESHONFAIVI LA LUKITIK\nlukitik\nLUKITIKI LA HAYBAR EKES EKES EKES EKES\nhaybar ekes ekes ekes ekes\nHAYBAR EKES EKES EKES EKES E LA GIRANDIFIFDORIGINI\ngirandfifdoridini"
	m.Assets = {"Fortnite.anim", "Fortnite.mp3"}

	m.Config = function(parent: GuiBase2d)
	end

	local animator = nil
	m.Init = function(figure: Model)
		SetOverrideDanceMusic(AssetGetContentId("Fortnite.mp3"), "fortnight default dance", 1)
		animator = AnimLib.Animator.new()
		animator.rig = figure
		animator.speed = 0.875
		animator.track = AnimLib.Track.fromfile(AssetGetPathFromFilename("Fortnite.anim"))
	end
	m.Update = function(dt: number, figure: Model)
		animator:Step(GetOverrideDanceMusicTime())
	end
	m.Destroy = function(figure: Model?)
		animator = nil
	end
	return m
end)

return modules