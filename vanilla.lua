local modules = {}
local function AddModule(m)
	table.insert(modules, m)
end

AddModule(function()
	local m = {}
	m.ModuleType = "MOVESET"
	m.Name = "Nothing"
	m.Description = "no anims? no problem\nJust a blank moveset I guess..."
	m.Assets = {}

	m.Config = function(parent: GuiBase2d)
	end

	m.Init = function(figure: Model)
	end
	m.Update = function(dt: number, figure: Model)
		local t = tick()
	end
	m.Destroy = function(figure: Model?)
	end
	return m
end)

AddModule(function()
	local m = {}
	m.ModuleType = "MOVESET"
	m.Name = "2007 Roblox"
	m.Description = "old roblox is retroslop.\nReject Motor6Ds, and return to Motors!"
	m.Assets = {}

	m.FPS30 = true
	m.Snap = true
	m.Config = function(parent: GuiBase2d)
		Util_CreateSwitch(parent, "30 FPS Cap", m.FPS30).Changed:Connect(function(val)
			m.FPS30 = val
		end)
		Util_CreateSwitch(parent, "Joint Snapping", m.Snap).Changed:Connect(function(val)
			m.Snap = val
		end)
	end

	local rcp = RaycastParams.new()
	rcp.FilterType = Enum.RaycastFilterType.Exclude
	rcp.RespectCanCollide = true
	rcp.IgnoreWater = true

	-- https://raw.githubusercontent.com/MaximumADHD/Super-Nostalgia-Zone/refs/heads/main/Player/RetroClimbing.client.lua
	local searchDepth = 0.7
	local maxClimbDist = 2.45
	local sampleSpacing = 1 / 7
	local lowLadderSearch = 2.7
	local ladderSearchDist = 2.0
	local function findPartInLadderZone(figure, root, hum)
		local cf = root.CFrame
		local top = -hum.HipHeight
		local bottom = -lowLadderSearch + top
		local radius = 0.5 * ladderSearchDist
		local center = cf.Position + (cf.LookVector * ladderSearchDist * 0.5)
		local min = Vector3.new(-radius, bottom, -radius)
		local max = Vector3.new(radius, top, radius)
		local extents = Region3.new(center + min, center + max)
		return #workspace:FindPartsInRegion3(extents, figure) > 0
	end
	local function findLadder(figure, root, hum)
		if not findPartInLadderZone(figure, root, hum) then
			return false
		end
		local torsoCoord = root.CFrame
		local torsoLook = torsoCoord.LookVector
		local firstSpace = 0
		local firstStep = 0
		local lookForSpace = true
		local lookForStep = false
		local topRay = math.floor(lowLadderSearch / sampleSpacing)
		for i = 1, topRay do
			local distFromBottom = i * sampleSpacing
			local originOnTorso = Vector3.new(0, -lowLadderSearch + distFromBottom, 0)
			local casterOrigin = torsoCoord.Position + originOnTorso
			local casterDirection = torsoLook * ladderSearchDist
			local hitPrim, hitLoc = nil, casterOrigin + casterDirection
			local hit = workspace:Raycast(casterOrigin, casterDirection, rcp)
			if hit then
				hitPrim, hitLoc = hit.Instance, hit.Position
			end
			-- make trusses climbable.
			if hitPrim and hitPrim:IsA("TrussPart") then
				return true
			end
			local mag = (hitLoc - casterOrigin).Magnitude
			if mag < searchDepth then
				if lookForSpace then
					firstSpace = distFromBottom
					lookForSpace = false
					lookForStep = true
				end
			elseif lookForStep then
				firstStep = distFromBottom - firstSpace
				lookForStep = false
			end
		end
		return firstSpace < maxClimbDist and firstStep > 0 and firstStep < maxClimbDist
	end

	local hstatechange, hrun = nil

	local lastpose = ""
	local pose = "Standing"
	local toolAnim = "None"
	local toolAnimTime = 0
	local canClimb = false

	local rng = Random.new(math.random(-65536, 65536))
	
	local sndpoint, climbforce = nil, nil

	local lastupdate = 0
	local rs, ls, rh, lh = {V = 0, D = 0, C = 0}, {V = 0, D = 0, C = 0}, {V = 0, D = 0, C = 0}, {V = 0, D = 0, C = 0}

	m.Init = function(figure: Model)
		local hum = figure:FindFirstChild("Humanoid")
		hum.AutoRotate = true
		hum.WalkSpeed = 16
		hum.JumpPower = 50
		hum:SetStateEnabled(Enum.HumanoidStateType.Climbing, false)
		hum:ChangeState(Enum.HumanoidStateType.Freefall)
		sndpoint = Instance.new("Attachment")
		sndpoint.Name = "oldrobloxsound"
		sndpoint.Parent = hum.Torso
		local function makesound(name, id)
			local sound = Instance.new("Sound")
			sound.SoundId = id
			sound.Parent = sndpoint
			sound.Volume = 5
			sound.Name = name
			return sound
		end
		makesound("Running", "rbxasset://sounds/bfsl-minifigfoots1.mp3").Looped = true
		makesound("Climbing", "rbxasset://sounds/bfsl-minifigfoots1.mp3").Looped = true
		makesound("GettingUp", "rbxasset://sounds/hit.wav")
		local f = makesound("Freefall", "rbxassetid://12222200")
		makesound("FallingDown", "rbxasset://sounds/splat.wav")
		local j = makesound("Jumping", "rbxasset://sounds/button.wav")
		j.Played:Connect(function()
			wait(0.1 + (math.random() / 10))
			j:Stop()
		end)
		hrun = hum.Running:Connect(function(speed)
			if speed > 0.2 then
				pose = "Running"
			else
				pose = "Standing"
			end
		end)
		hstatechange = hum.StateChanged:Connect(function(old, new)
			local state = new.Name
			if state == "Jumping" then
				pose = "Jumping"
				canClimb = true
				hum.AutoRotate = false
				hum.HipHeight = -1
			elseif state == "Freefall" then
				pose = "Freefall"
				canClimb = true
				hum.AutoRotate = false
				hum.HipHeight = -1
			elseif state == "Landed" then
				pose = "Freefall"
				canClimb = true
				local vel = hum.Torso.Velocity
				local power = -vel.Y / 2
				if power > 30 then
					hum.Torso.Velocity = Vector3.new(vel.X, power, vel.Z)
					hum.Torso.RotVelocity = rng:NextUnitVector() * power * 0.5
					if power > 100 then
						hum:ChangeState(Enum.HumanoidStateType.FallingDown)
					else
						hum:ChangeState(Enum.HumanoidStateType.Freefall)
					end
				end
				hum.AutoRotate = false
				hum.HipHeight = -1
				f:Play()
			elseif state == "Seated" then
				pose = "Seated"
				canClimb = false
			elseif state == "Swimming" then
				pose = "Running"
				canClimb = false
			elseif state == "Running" then
				canClimb = true
			elseif state == "PlatformStand" then
				pose = "Standing"
				canClimb = false
			elseif state == "GettingUp" then
				pose = "GettingUp"
				canClimb = false
				hum.AutoRotate = false
				hum.HipHeight = -1
			elseif state == "Ragdoll" then
				pose = "Running"
				canClimb = false
			elseif state == "FallingDown" then
				pose = "FallingDown"
				canClimb = false
			else
				pose = "Standing"
				canClimb = false
			end
		end)
		climbforce = Instance.new("BodyVelocity")
		climbforce.Name = "ClimbForce"
		climbforce.Parent = nil
	end
	m.Update = function(dt: number, figure: Model)
		local t = tick()

		rcp.FilterDescendantsInstances = {figure}

		local hum = figure:FindFirstChild("Humanoid")
		if not hum then return end
		local root = figure:FindFirstChild("HumanoidRootPart")
		if not root then return end
		local torso = figure:FindFirstChild("Torso")
		if not torso then return end

		if lastpose ~= pose then
			local snd1 = sndpoint:FindFirstChild(lastpose)
			local snd2 = sndpoint:FindFirstChild(pose)
			if snd1 and snd1.Looped then snd1:Stop() end
			if snd2 then
				if pose == "Freefall" then
					task.delay(0.15, snd2.Play, snd2)
				else
					snd2:Play()
				end
			end
			lastpose = pose
		end

		local function getTool()
			for _, kid in figure:GetChildren() do
				if kid.className == "Tool" then
					return kid
				end
			end
			return nil
		end

		local function getToolAnim(tool)
			for _, c in tool:GetChildren() do
				if c.Name == "toolanim" and c.ClassName == "StringValue" then
					return c
				end
			end
			return nil
		end

		local jumping = pose == "Jumping" or pose == "Freefall"
		local climbing = canClimb and findLadder(figure, root, hum)

		local climbforced = false
		local climbspeed = hum.WalkSpeed * 0.7
		if climbing then
			if hum.MoveDirection.Magnitude > 0 then
				climbforce.Velocity = Vector3.new(0, climbspeed, 0)
				climbforced = true
			elseif jumping then
				climbforce.Velocity = Vector3.new(0, -climbspeed, 0)
				climbforced = true
			end
		end
		if climbforced then
			climbforce.MaxForce = Vector3.new(climbspeed * 100, 10e6, climbspeed * 100)
			climbforce.Parent = root
		else
			climbforce.Parent = nil
		end

		if jumping or hum.HipHeight < -0.01 then
			if not jumping then
				hum.HipHeight *= math.exp(-16 * dt)
			end
			hum.JumpPower = 0
			rs.V = 0.5
			ls.V = 0.5
			rs.D = 3.14
			ls.D = -3.14
			rh.V = 0.5
			lh.V = 0.5
			rh.D = 0
			lh.D = 0
		elseif pose == "Seated" then
			rs.V = 0.15
			ls.V = 0.15
			rs.D = 1.57
			ls.D = -1.57
			rh.V = 0.15
			lh.V = 0.15
			rh.D = 1.57
			lh.D = -1.57
		else
			hum.AutoRotate = true
			hum.HipHeight = 0
			hum.JumpPower = 50

			local amplitude = 1
			local frequency = 9
			local climbFudge = 0

			if climbing then
				rs.V = 0.5
				ls.V = 0.5
				rh.V = 0.5
				lh.V = 0.5
				climbFudge = 3.14
			elseif pose == "Running" then
				rs.V = 0.15
				ls.V = 0.15
				rh.V = 0.15
				lh.V = 0.15
			else
				amplitude = 0.1
				frequency = 1
			end

			local desiredAngle = amplitude * math.sin(t * frequency)
			rs.D = desiredAngle + climbFudge
			ls.D = desiredAngle - climbFudge
			rh.D = -desiredAngle
			lh.D = -desiredAngle

			local tool = getTool()
			if tool and tool.RequiresHandle then
				local msg = getToolAnim(tool)
				if msg then
					toolAnim = msg.Value
					msg:Destroy()
					toolAnimTime = t + 0.3
				end
				if t > toolAnimTime then
					toolAnimTime = 0
					toolAnim = "None"
				end
				if toolAnim == "None" then
					rs.D = 1.57
				elseif toolAnim == "Slash" then
					rs.V = 0.5
					rs.D = 0
				elseif toolAnim == "Lunge" then
					rs.V = 0.5
					ls.V = 0.5
					rs.D = 1.57
					ls.D = 1
					rh.V = 0.5
					lh.V = 0.5
					rh.D = 1.57
					lh.D = 1
				end
			else
				toolAnim = "None"
				toolAnimTime = 0
			end
		end

		local rj = root:FindFirstChild("RootJoint")
		local nj = torso:FindFirstChild("Neck")
		local rsj = torso:FindFirstChild("Right Shoulder")
		local lsj = torso:FindFirstChild("Left Shoulder")
		local rhj = torso:FindFirstChild("Right Hip")
		local lhj = torso:FindFirstChild("Left Hip")

		local function stepjoint(a, b, c)
			local d = a.D - a.C
			if math.abs(d) < a.V then
				a.C = a.D
			elseif d > 0 then
				a.C += a.V * 30 * c
			else
				a.C -= a.V * 30 * c
			end
			local e = a.C
			if m.Snap then
				local snap = math.pi / 90
				e = math.round(a.C / snap) * snap
			end
			b.Transform = CFrame.Angles(0, 0, e)
		end

		local delta = 1 / 30
		if not m.FPS30 then
			lastupdate = 0
			delta = dt
		end

		if t - lastupdate > 1 / 30 then
			lastupdate = t
			rj.Transform = CFrame.identity
			nj.Transform = CFrame.identity
			stepjoint(rs, rsj, delta)
			stepjoint(ls, lsj, delta)
			stepjoint(rh, rhj, delta)
			stepjoint(lh, lhj, delta)
		end
	end
	m.Destroy = function(figure: Model?)
		hstatechange:Disconnect()
		hrun:Disconnect()
		sndpoint:Destroy()
		climbforce:Destroy()
	end
	return m
end)

AddModule(function()
	local m = {}
	m.ModuleType = "MOVESET"
	m.Name = "Sans Undertale"
	m.Description = "do u wanna have a bad TOM\ntom and jerry\nQ - dodge"
	m.Assets = {"SansMoveset1.anim"}

	m.RootPartOverride = true
	m.Config = function(parent: GuiBase2d)
		Util_CreateSwitch(parent, "RootPart Mode Override", m.RootPartOverride).Changed:Connect(function(val)
			m.RootPartOverride = val
		end)
	end

	local animator = nil

	local lastdodgestate = false
	local dodgetick = 0
	m.Init = function(figure: Model)
		local track = AnimLib.Track.fromfile(AssetGetPathFromFilename("SansMoveset1.anim"))
		animator = AnimLib.Animator.new()
		animator.rig = figure
		animator.track = track
		dodgetick = 0
		ContextActionService:BindAction("Uhhhhhh_SansDodge", function(actName, state, input)
			if state == Enum.UserInputState.Begin then
				dodgetick = tick()
			end
		end, true, Enum.KeyCode.Q)
		ContextActionService:SetTitle("Uhhhhhh_SansDodge", "Dodge")
		ContextActionService:SetPosition("Uhhhhhh_SansDodge", UDim2.new(1, -130, 1, -130))
	end
	m.Update = function(dt: number, figure: Model)
		local t = tick()
		local newdodgestate = false
		if t - dodgetick < 1.2 then
			newdodgestate = true
			animator:Step(1.3 + (t - dodgetick))
		else
			animator:Step(t % 1.2)
		end
		if lastdodgestate ~= newdodgestate then
			lastdodgestate = newdodgestate
			if m.RootPartOverride then
				if newdodgestate then
					LimbReanimator.Mode = 0
				else
					LimbReanimator.Mode = 2
				end
			end
		end
	end
	m.Destroy = function(figure: Model?)
		animator = nil
		ContextActionService:UnbindAction("Uhhhhhh_SansDodge")
	end
	return m
end)

AddModule(function()
	local m = {}
	m.ModuleType = "MOVESET"
	m.Name = "Ragdoll"
	m.Description = "ow\nR - toggle ragdoll"
	m.Assets = {}

	m.Config = function(parent: GuiBase2d)
	end

	local ragdoll = false
	m.Init = function(figure: Model)
		ragdoll = false
		ContextActionService:BindAction("Uhhhhhh_Ragdoll", function(actName, state, input)
			if state == Enum.UserInputState.Begin then
				ragdoll = not ragdoll
			end
		end, true, Enum.KeyCode.Q)
		ContextActionService:SetTitle("Uhhhhhh_Ragdoll", "Ragdoll")
		ContextActionService:SetPosition("Uhhhhhh_Ragdoll", UDim2.new(1, -130, 1, -130))
	end
	m.Update = function(dt: number, figure: Model)
		local t = tick()
	end
	m.Destroy = function(figure: Model?)
		ContextActionService:UnbindAction("Uhhhhhh_Ragdoll")
	end
	--return m
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
		SetOverrideMusic(AssetGetContentId("RatDance.mp3"), "Chess Type Beat Slowed", 1, NumberRange.new(2.13, 87.3))
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
		SetOverrideMusic(AssetGetContentId("Assumptions.mp3"), "Sam Gellaitry - Assumptions", 1, NumberRange.new(15.22, 76.19))
		animator = AnimLib.Animator.new()
		animator.rig = figure
		animator.track = AnimLib.Track.fromfile(AssetGetPathFromFilename("Assumptions.anim"))
		animator.looped = true
		animator.map = {{15.22, 76.19}, {0, 78.944}}
	end
	m.Update = function(dt: number, figure: Model)
		animator:Step(GetOverrideMusicTime())
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
		SetOverrideMusic(AssetGetContentId("Mesmerizer.mp3"), "Blue and Red Miku - Mesmerizer", 1, NumberRange.new(2.56, 67.435))
		animator = AnimLib.Animator.new()
		animator.rig = figure
		animator.track = AnimLib.Track.fromfile(AssetGetPathFromFilename("Mesmerizer.anim"))
		animator.looped = true
		animator.map = {{44.113, 54.456}, {0, 10.367}}
	end
	m.Update = function(dt: number, figure: Model)
		animator:Step(GetOverrideMusicTime())
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
		SetOverrideMusic(AssetGetContentId("Caramelldansen.mp3"), "Caramell - Caramella Girls", 1)
		animator = AnimLib.Animator.new()
		animator.rig = figure
		animator.track = AnimLib.Track.fromfile(AssetGetPathFromFilename("Caramelldansen.anim"))
		animator.looped = true
		animator.map = {{0, 46.683}, {0, 44.8}}
		lastlyricsindex = 0
	end
	m.Update = function(dt: number, figure: Model)
		local t = GetOverrideMusicTime()
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
	m.Description = "jujutsu shenanigans"
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
		SetOverrideMusic(AssetGetContentId("Hakari.mp3"), "TUCA DONKA", 1)
		animator = AnimLib.Animator.new()
		animator.rig = figure
		animator.track = AnimLib.Track.fromfile(AssetGetPathFromFilename("Hakari.anim"))
		animator.looped = true
		animator.map = {{0, 73.845}, {0, 75.6}}
		instances = {}
		if m.Effects then
			local root = figure:FindFirstChild("HumanoidRootPart")
			local SmokeLight = Instance.new("ParticleEmitter")
			SmokeLight.Parent = root
			SmokeLight.LightInfluence = 0
			SmokeLight.LightEmission = 1
			SmokeLight.Brightness = 1
			SmokeLight.ZOffset = -2
			SmokeLight.Color = ColorSequence.new(Color3.fromRGB(67, 255, 167))
			SmokeLight.Orientation = Enum.ParticleOrientation.FacingCamera
			SmokeLight.Size = NumberSequence.new(0.625, 8.5)
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
				NumberSequenceKeypoint.new(0, 0.0625, 0),
				NumberSequenceKeypoint.new(0.36, 0.437, 0.437),
				NumberSequenceKeypoint.new(1, 8.65, 0.0625),
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
		animator:Step(GetOverrideMusicTime())
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
	m.Description = "this was everywhere back in my day (2021)"
	m.Assets = {"CaliforniaGirls.anim", "CaliforniaGirls.mp3"}

	m.Config = function(parent: GuiBase2d)
	end

	local animator = nil
	local start = 0
	m.Init = function(figure: Model)
		SetOverrideMusic(AssetGetContentId("CaliforniaGirls.mp3"), "Katy Perry - California Girls", 1)
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
	m.Assets = {"SubjectThree.anim", "SubjectThree.mp3", "SubjectThreeDubmood.mp3"}

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
			animator.speed = 0.9867189
			SetOverrideMusic(AssetGetContentId("SubjectThreeDubmood.mp3"), "Dubmood - The Scene Is Dead 2024", 1)
		else
			start += 3.71
			animator.speed = 1.01034703
			SetOverrideMusic(AssetGetContentId("SubjectThree.mp3"), "Subject Three - Wen Ren Ting Shu", 1, NumberRange.new(3.71, 77.611))
		end
		animator.track = AnimLib.Track.fromfile(AssetGetPathFromFilename("SubjectThree.anim"))
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
		SetOverrideMusic(AssetGetContentId("MioHonda.mp3"), "Mio Honda - Step!", 1, NumberRange.new(45.311, 196.964))
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
		local t = GetOverrideMusicTime()
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
		SetOverrideMusic(AssetGetContentId("Static.mp3"), "FLAVOR FOLEY - Static", 1)
		animator = AnimLib.Animator.new()
		animator.rig = figure
		animator.track = AnimLib.Track.fromfile(AssetGetPathFromFilename("StaticV1.anim"))
		animator.looped = false
	end
	m.Update = function(dt: number, figure: Model)
		animator:Step(GetOverrideMusicTime())
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
		SetOverrideMusic(AssetGetContentId("Lagtrain.mp3"), "inabakumori - Lag Train", 1)
		animator = AnimLib.Animator.new()
		animator.rig = figure
		animator.track = AnimLib.Track.fromfile(AssetGetPathFromFilename("Lagtrain.anim"))
		animator.looped = false
		animator.map = {{0, 26.117}, {0, 25.53}}
	end
	m.Update = function(dt: number, figure: Model)
		animator:Step(GetOverrideMusicTime())
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
		SetOverrideMusic(AssetGetContentId("Gangnam.mp3"), "PSY - Gangnam Style", 1, NumberRange.new(1.505, 30.583))
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
		SetOverrideMusic(AssetGetContentId("Distraction.mp3"), "Dance Mr. Funnybones", 1, NumberRange.new(0, 1.833))
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
		animator:Step(GetOverrideMusicTime() + 0.67)
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
	m.Description = "Game Over!\n\"自分が3年C組14番だった事に気づいたので聞きに来ました-\""
	m.Assets = {"ClassC14.anim", "ClassC14.mp3"}

	m.Config = function(parent: GuiBase2d)
	end

	local animator = nil
	m.Init = function(figure: Model)
		SetOverrideMusic(AssetGetContentId("ClassC14.mp3"), "3rd Year Class C-14", 1, NumberRange.new(0.492, 29.169))
		animator = AnimLib.Animator.new()
		animator.rig = figure
		animator.track = AnimLib.Track.fromfile(AssetGetPathFromFilename("ClassC14.anim"))
		animator.looped = false
		animator.map = {{0.492, 29.169}, {0, 28.63}}
	end
	m.Update = function(dt: number, figure: Model)
		animator:Step(GetOverrideMusicTime())
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
		SetOverrideMusic(AssetGetContentId("ItBurns.mp3"), "Loco Loco - It Burns! Burns! Burns!", 1)
		animator = AnimLib.Animator.new()
		animator.rig = figure
		animator.track = AnimLib.Track.fromfile(AssetGetPathFromFilename("ItBurns.anim"))
		animator.looped = false
	end
	m.Update = function(dt: number, figure: Model)
		animator:Step(GetOverrideMusicTime())
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
	m.Description = "red miku is pear"
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
		SetOverrideMusic(AssetGetContentId("Igaku.mp3"), "Kasane Teto - Igaku", 1)
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
		animator:Step(GetOverrideMusicTime())
	end
	m.Destroy = function(figure: Model?)
		animator = nil
	end
	return m
end)

return modules