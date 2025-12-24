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

-- utils
local function ResetC0C1Joints(rj, nj, rsj, lsj, rhj, lhj)
	rj.C0 = CFrame.new(0, 0, 0, -1, 0, 0, 0, 0, 1, 0, 1, 0)
	rj.C1 = CFrame.new(0, 0, 0, -1, 0, 0, 0, 0, 1, 0, 1, 0)
	nj.C0 = CFrame.new(0, 1, 0, -1, 0, 0, 0, 0, 1, 0, 1, 0)
	nj.C1 = CFrame.new(0, -0.5, 0, -1, 0, 0, 0, 0, 1, 0, 1, 0)
	rsj.C0 = CFrame.new(-1, 0.5, 0, 0, 0, -1, 0, 1, 0, 1, 0, 0)
	rsj.C1 = CFrame.new(0.5, 0.5, 0, 0, 0, -1, 0, 1, 0, 1, 0, 0)
	lsj.C0 = CFrame.new(1, 0.5, 0, 0, 0, 1, 0, 1, 0, -1, 0, 0)
	lsj.C1 = CFrame.new(-0.5, 0.5, 0, 0, 0, 1, 0, 1, 0, -1, 0, 0)
	rhj.C0 = CFrame.new(-1, 1, 0, 0, 0, -1, 0, 1, 0, 1, 0, 0)
	rhj.C1 = CFrame.new(-0.5, 1, 0, 0, 0, -1, 0, 1, 0, 1, 0, 0)
	lhj.C0 = CFrame.new(1, 1, 0, 0, 0, 1, 0, 1, 0, -1, 0, 0)
	lhj.C1 = CFrame.new(0.5, 1, 0, 0, 0, 1, 0, 1, 0, -1, 0, 0)
end
local function SetC0C1Joint(j, c0, c1, scale)
	local t = c0 * c1:Inverse()
	t += t.Position * (scale - 1)
	t = j.C0:Inverse() * t * j.C1
	j.Transform = t
end

local modules = {}
local function AddModule(m)
	table.insert(modules, m)
end

-- best to start with this!
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
		local t = os.clock()
	end
	m.Destroy = function(figure: Model?)
	end
	return m
end)

AddModule(function()
	local m = {}
	m.ModuleType = "MOVESET"
	m.Name = "2007 Roblox"
	m.Description = "old roblox is retroslop.\nVery accurate recreation of the old Roblox physics!\nReject Motor6Ds, and return to Motors!"
	m.InternalName = "RETROSLOP"
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
	m.LoadConfig = function(save: any)
		m.FPS30 = not save.FPSUnlock
		m.Snap = not save.NoSnap
	end
	m.SaveConfig = function()
		return {
			FPSUnlock = not m.FPS30,
			NoSnap = not m.Snap
		}
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
		local scale = figure:GetScale()
		searchDepth = 0.7 * scale
		maxClimbDist = 2.45 * scale
		sampleSpacing = scale / 7
		lowLadderSearch = 2.7 * scale
		ladderSearchDist = 2.0 * scale
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
	local hipHeight = 0

	local rng = Random.new(math.random(-65536, 65536))
	
	local sndpoint, climbforce = nil, nil

	local lastupdate = 0
	local rs, ls, rh, lh = {V = 0, D = 0, C = 0}, {V = 0, D = 0, C = 0}, {V = 0, D = 0, C = 0}, {V = 0, D = 0, C = 0}

	m.Init = function(figure: Model)
		local hum = figure:FindFirstChild("Humanoid")
		hum.AutoRotate = true
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
			task.wait(0.12 + math.random() * 0.08)
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
				hipHeight = -1
			elseif state == "Freefall" then
				pose = "Freefall"
				canClimb = true
				hum.AutoRotate = false
				hipHeight = -1
			elseif state == "Landed" then
				pose = "Freefall"
				canClimb = true
				local vel = hum.Torso.Velocity
				local power = -vel.Y / 2
				if power > 30 then
					hum.Torso.Velocity = Vector3.new(vel.X, power, vel.Z)
					hum.Torso.RotVelocity = rng:NextUnitVector() * power * 0.5
					if power > 100 then
						hum:ChangeState(Enum.HumanoidStateType.Ragdoll)
					else
						hum:ChangeState(Enum.HumanoidStateType.Freefall)
					end
				end
				hum.AutoRotate = false
				hipHeight = -1
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
		local t = os.clock()

		rcp.FilterDescendantsInstances = {figure}

		local scale = figure:GetScale()

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

		local climbing = canClimb and findLadder(figure, root, hum)
		local jumping = pose == "Jumping" or pose == "Freefall"

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

		if not climbing and (jumping or hipHeight < -0.01) then
			if not jumping then
				hipHeight *= math.exp(-16 * dt)
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
			hum.JumpPower = 50

			local amplitude = 1
			local frequency = 9
			local climbFudge = 0

			if climbing then
				rs.V = 0.5
				ls.V = 0.5
				rh.V = 0.1
				lh.V = 0.1
				climbFudge = 3.14
			elseif pose == "Running" then
				rs.V = 0.15
				ls.V = 0.15
				rh.V = 0.1
				lh.V = 0.1
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
		hum.HipHeight = hipHeight * scale

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
	m.InternalName = "NESS"
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
				dodgetick = os.clock()
			end
		end, true, Enum.KeyCode.Q)
		ContextActionService:SetTitle("Uhhhhhh_SansDodge", "Dodge")
		ContextActionService:SetPosition("Uhhhhhh_SansDodge", UDim2.new(1, -130, 1, -130))
	end
	m.Update = function(dt: number, figure: Model)
		local t = os.clock()
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
	m.Name = "Immortality Lord"
	m.Description = "il but he chill\nF - Toggle flight\nZ - \"Attack\""
	m.InternalName = "ImmortalityBored"
	m.Assets = {"ImmortalityLordTheme.mp3", "ImmortalityLordTheme2.mp3", "ImmortalityLordTheme3.mp3"}

	m.Bee = false
	m.NeckSnap = true
	m.FixNeckSnapReplicate = true
	m.Notifications = true
	m.FlySpeed = 2
	m.HitboxScale = 1
	m.HitboxDebug = true
	m.Config = function(parent: GuiBase2d)
		Util_CreateSwitch(parent, "Neck Snapping", m.NeckSnap).Changed:Connect(function(val)
			m.NeckSnap = val
		end)
		Util_CreateSwitch(parent, "Neck Snap Replication Fix", m.FixNeckSnapReplicate).Changed:Connect(function(val)
			m.FixNeckSnapReplicate = val
		end)
		Util_CreateSwitch(parent, "Bee Wings", m.Bee).Changed:Connect(function(val)
			m.Bee = val
		end)
		Util_CreateSwitch(parent, "Text thing", m.Notifications).Changed:Connect(function(val)
			m.Notifications = val
		end)
		Util_CreateSlider(parent, "Fly Speed", m.FlySpeed, 1, 8, 1).Changed:Connect(function(val)
			m.FlySpeed = val
		end)
		Util_CreateSlider(parent, "Hitbox Scale", m.HitboxScale, 1, 4, 1).Changed:Connect(function(val)
			m.HitboxScale = val
		end)
		Util_CreateSwitch(parent, "Hitbox Visual", m.HitboxDebug).Changed:Connect(function(val)
			m.HitboxDebug = val
		end)
	end
	m.LoadConfig = function(save: any)
		m.Bee = not not save.Bee
		m.NeckSnap = not save.NoNeckSnap
		m.FixNeckSnapReplicate = not save.DontFixNeckSnapReplicate
		m.Notifications = not save.NoTextType
		m.FlySpeed = save.FlySpeed or m.FlySpeed
		m.HitboxScale = save.HitboxScale or m.HitboxScale
		m.HitboxDebug = not save.NoHitbox
	end
	m.SaveConfig = function()
		return {
			Bee = m.Bee,
			NoNeckSnap = not m.NeckSnap,
			DontFixNeckSnapReplicate = not m.FixNeckSnapReplicate,
			NoTextType = not m.Notifications,
			FlySpeed = m.FlySpeed,
			HitboxScale = m.HitboxScale,
			NoHitbox = not m.HitboxDebug,
		}
	end

	local function notify(message)
		if not m.Notifications then return end
		local prefix = "[Immortality Lord]: "
		local text = Instance.new("TextLabel")
		text.Name = RandomString()
		text.Position = UDim2.new(0, 0, 0.95, 0)
		text.Size = UDim2.new(1, 0, 0.05, 0)
		text.BackgroundTransparency = 1
		text.Text = prefix
		text.Font = Enum.Font.SpecialElite
		text.TextScaled = true
		text.TextColor3 = Color3.new(1, 1, 1)
		text.TextStrokeTransparency = 0
		text.TextXAlignment = Enum.TextXAlignment.Left
		text.Parent = HiddenGui
		task.spawn(function()
			local cps = 30
			local t = os.clock()
			local ll = 0
			repeat
				task.wait()
				local l = math.floor((os.clock() - t) * cps)
				if l > ll then
					ll = l
					local snd = Instance.new("Sound")
					snd.Volume = 1
					snd.SoundId = "rbxassetid://4681278859"
					snd.TimePosition = 0.07
					snd.Playing = true
					snd.Parent = text
				end
				text.Text = prefix .. string.sub(message, 1, l)
			until ll >= #message
			text.Text = prefix .. message
			task.wait(1)
			TweenService:Create(text, TweenInfo.new(1, Enum.EasingStyle.Linear),{TextTransparency = 1, TextStrokeTransparency = 1}):Play()
			task.wait(1)
			text:Destroy()
		end)
	end

	local flight = false
	local start = 0
	local necksnap = 0
	local necksnapcf = CFrame.identity
	local attack = -999
	local attackcount = 0
	local attackdegrees = 90
	local lastattackside = false
	local joints = {
		r = CFrame.identity,
		n = CFrame.identity,
		rs = CFrame.identity,
		ls = CFrame.identity,
		rh = CFrame.identity,
		lh = CFrame.identity,
		sw = CFrame.identity,
	}
	local leftwing = {}
	local rightwing = {}
	local sword = {}
	local flyv, flyg = nil, nil
	local chatconn = nil
	local dancereact = {}
	local hitboxhits = 0
	local lasthitreact = -99999
	local function Attack(position, radius)
		if m.HitboxDebug then
			local hitvis = Instance.new("Part")
			hitvis.Name = RandomString() -- built into Uhhhhhh
			hitvis.CastShadow = false
			hitvis.Material = Enum.Material.ForceField
			hitvis.Anchored = true
			hitvis.CanCollide = false
			hitvis.CanTouch = false
			hitvis.CanQuery = false
			hitvis.Shape = Enum.PartType.Ball
			hitvis.Color = Color3.new(0, 0, 0)
			hitvis.Size = Vector3.one * radius * 2
			hitvis.CFrame = CFrame.new(position)
			hitvis.Parent = workspace
			Debris:AddItem(hitvis, 1)
		end
		local hitamount = 0
		local parts = workspace:GetPartBoundsInRadius(position, radius)
		for _,part in parts do
			if part.Parent then
				local hum = part.Parent:FindFirstChildOfClass("Humanoid")
				if hum and hum.RootPart and not hum.RootPart:IsGrounded() then
					if ReanimateFling(part.Parent) then
						hitboxhits += 1
						hitamount += 1
						task.delay(5, function()
							hitboxhits -= 1
						end)
					end
				end
			end
		end
		local t = os.clock()
		if t > lasthitreact then
			lasthitreact = t + 20
			if not HatReanimator.Running then
				if hitamount >= 1 then
					if math.random(2) == 1 then
						task.delay(1, notify, "HMMM...")
					else
						task.delay(1, notify, "okay what else")
					end
				end
			elseif not HatReanimator.HatCollide then
				if math.random(2) == 1 then
					notify("all it takes to KILL ONE is to RESPAWN")
					task.delay(4, notify, "(why didnt you turn on 'hat collide')")
				else
					notify("now lets FLING them after TWO DAYS")
				end
			elseif hitamount >= 8 then
				if math.random(2) == 1 then
					notify("that is so SATISFYING, and YOU know it")
				else
					notify("take THAT, lightning cannon! " .. hitamount .. " in ONE MELEE SWING")
					task.delay(5, notify, "bet you CANNOT do THAT cuz you are STUCK in RANGED")
				end
			elseif hitboxhits >= 8 then
				if math.random(2) == 1 then
					notify("THEY ALL MET THEIR FATE.")
				else
					notify("YES!! KILL SPREE KILL SPREE")
				end
			elseif hitamount == 2 and hitboxhits == 2 then
				if math.random(3) == 1 then
					notify("BOTH SCREAMED YET UNHEARD.")
				elseif math.random(2) == 1 then
					notify("NEVER SEEN AGAIN.")
				else
					notify("NOBODY NEEDED THEM.")
				end
			elseif hitamount == 1 and hitboxhits == 1 then
				if math.random(5) == 1 then
					notify("ANOTHER ONE BITES THE DUST.")
				elseif math.random(4) == 1 then
					notify("HES GONE NOW.")
				elseif math.random(3) == 1 then
					notify("POOR GUY.")
				elseif math.random(2) == 1 then
					notify("NEVER SEEN AGAIN.")
				else
					notify("HE HAD NO LAST WORDS.")
				end
			else
				lasthitreact = t
			end
		end
	end
	local musictime = 0
	local function changesong()
		SetOverrideMovesetMusic(AssetGetContentId("ImmortalityLordTheme.mp3"), "In Aisles (IL's Theme)", 1)
		if math.random(3) == 1 then return end
		SetOverrideMovesetMusic(AssetGetContentId("ImmortalityLordTheme2.mp3"), "Human Artifacts Found Underwater (IL's Theme)", 1)
		if math.random(2) == 1 then return end
		SetOverrideMovesetMusic(AssetGetContentId("ImmortalityLordTheme3.mp3"), "Sprawling Idiot Effigy (IL's Theme)", 1)
	end
	m.Init = function(figure: Model)
		start = os.clock()
		flight = false
		dancereact = {}
		attack = -999
		necksnap = 0
		musictime = 0
		SetOverrideMovesetMusic(AssetGetContentId("ImmortalityLordTheme.mp3"), "In Aisles (IL's Theme)", 1)
		leftwing = {
			Group = "LeftWing",
			Limb = "Torso", Offset = CFrame.new(-0.15, 0, 0)
		}
		rightwing = {
			Group = "RightWing",
			Limb = "Torso", Offset = CFrame.new(0.15, 0, 0)
		}
		sword = {
			Group = "Sword",
			Limb = "Right Arm",
			Offset = CFrame.identity
		}
		table.insert(HatReanimator.HatCFrameOverride, leftwing)
		table.insert(HatReanimator.HatCFrameOverride, rightwing)
		table.insert(HatReanimator.HatCFrameOverride, sword)
		flyv = Instance.new("BodyVelocity")
		flyv.Name = "FlightBodyMover"
		flyv.P = 90000
		flyv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
		flyv.Parent = nil
		flyg = Instance.new("BodyGyro")
		flyg.Name = "FlightBodyMover"
		flyg.P = 3000
		flyg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
		flyg.Parent = nil
		ContextActionService:BindAction("Uhhhhhh_ILFlight", function(_, state, _)
			if state == Enum.UserInputState.Begin then
				flight = not flight
				if math.random(15) == 1 then
					if figure:GetAttribute("IsDancing") then
						local name = figure:GetAttribute("DanceInternalName")
						if name == "RAGDOLL" then
							if flight then
								if math.random(2) == 1 then
									notify("PUT ME DOWN PUT ME DOWN")
								else
									notify("DONT YOU DARE DONT YOU DARE DONT YOU DARE")
								end
							else
								if math.random(2) == 1 then
									notify("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA")
								else
									notify("OOOHHH GOOOOOODDDDD")
								end
							end
						else
							if not flight then
								notify("dancing is BETTER on the GROUND")
							end
						end
					else
						if m.FlySpeed >= 3 and math.random(2) == 1 then
							if flight then
								task.delay(1, notify, "this view is BORING")
							end
						else
							if flight then
								notify("im a bird")
								task.delay(3, notify, "GOVERNMENT DRONE")
							else
								notify("this does NOT mean im TIRED of flying")
							end
						end
					end
				end
			end
		end, true, Enum.KeyCode.F)
		ContextActionService:SetTitle("Uhhhhhh_ILFlight", "F")
		ContextActionService:SetPosition("Uhhhhhh_ILFlight", UDim2.new(1, -130, 1, -130))
		ContextActionService:BindAction("Uhhhhhh_ILAttack", function(_, state, _)
			if state == Enum.UserInputState.Begin then
				if not figure:GetAttribute("IsDancing") then
					attackcount += 1
					local t = os.clock() - start
					if t - attack >= 0.75 then
						attackcount = 0
						lastattackside = true
						if math.random(30) == 1 then
							notify("my blade CUTS through AIR")
						elseif math.random(29) == 1 then
							notify("RAAHH im MINING this part")
						end
					end
					if attackcount == 10 then
						if math.random(10) == 1 then
							notify("im FAST as FRICK, boii")
						elseif math.random(9) == 1 then
							notify("i play Minecraft BEDROCK edition")
						end
					end
					if attackcount == 50 then
						notify("STOP RIGHT THIS INSTANT " .. Player.Name:upper())
					end
					attack = t
					if flight then
						attackdegrees = 80
					else
						local camcf = CFrame.identity
						if workspace.CurrentCamera then
							camcf = workspace.CurrentCamera.CFrame
						end
						local angle,_,_ = camcf:ToEulerAngles(Enum.RotationOrder.YXZ)
						angle += math.pi * 0.5
						attackdegrees = math.abs(math.deg(angle))
					end
				end
			end
		end, true, Enum.KeyCode.Z)
		ContextActionService:SetTitle("Uhhhhhh_ILAttack", "Z")
		ContextActionService:SetPosition("Uhhhhhh_ILAttack", UDim2.new(1, -180, 1, -130))
		ContextActionService:BindAction("Uhhhhhh_ILTeleport", function(_, state, _)
			if state == Enum.UserInputState.Begin then
				notify("i'd rather WALK.")
			end
		end, false, Enum.KeyCode.X)
		ContextActionService:BindAction("Uhhhhhh_ILDestroy", function(_, state, _)
			if state == Enum.UserInputState.Begin then
				notify("magic is BORING.")
			end
		end, false, Enum.KeyCode.C)
		ContextActionService:BindAction("Uhhhhhh_ILMusic", function(_, state, _)
			if state == Enum.UserInputState.Begin then
				musictime = 0
				changesong()
			end
		end, true, Enum.KeyCode.M)
		ContextActionService:SetTitle("Uhhhhhh_ILMusic", "M")
		ContextActionService:SetPosition("Uhhhhhh_ILMusic", UDim2.new(1, -130, 1, -180))
		task.delay(0, notify, "im BORED!!")
		local lines = {
			"theres NOTHING really FUN for me to do since 2022",
			"i can kill ANYTHING, whats the FUN in THAT?",
			"lightning cannon is an IDIOT! cant he READ my NAME??",
			"the wiki says i cant SPEAK. NOT FUN.",
			"PLEASE turn ME into a moveset",
			"MORE BORED than viewport Immortality Lord",
			string.reverse("so bored, i would talk in reverse"),
			"im POWERFUL, how is that FUN?",
			"you know what they say, OVERPOWERED is ABSOLUTELY LAME",
			"NOT because im no longer IMMORTAL for real",
			"SO BORED, i would LOVE to use a NOOB skin",
			"lets hope " .. Player.Name:lower() .. " is NOT BORING",
			"last time things were FUN for me was FIGHTING LIGHTNING CANNON",
			"i don't think seeing Lightning Cannon will cure THIS boredom",
			"server, tune up In Aisles for me.",
			"and its NOT because i HACK my stats in EVERY GAME i play", -- headcanon
			"does ANYONE have a copy of Paper Mario for the Gamecube?", -- yet another headcanon
			"what has changed anyway?",
			"what is changed anyway?", -- "Immortality Lord has not yet heard of Changed."
		}
		task.delay(3, notify, lines[math.random(1, #lines)])
		if chatconn then
			chatconn:Disconnect()
		end
		chatconn = OnPlayerChatted.Event:Connect(function(plr, msg)
			if plr == Player then
				notify(msg)
			end
		end)
	end
	m.Update = function(dt: number, figure: Model)
		local t = os.clock() - start
		
		local mt = GetOverrideMovesetMusicTime()
		if musictime > mt then
			changesong()
		end
		musictime = mt
		
		local scale = figure:GetScale()
		local isdancing = figure:GetAttribute("IsDancing")
		
		-- get vii
		local hum = figure:FindFirstChild("Humanoid")
		if not hum then return end
		local root = figure:FindFirstChild("HumanoidRootPart")
		if not root then return end
		local torso = figure:FindFirstChild("Torso")
		if not torso then return end
		
		-- fly
		if flight then
			hum.PlatformStand = true
			flyv.Parent = root
			flyg.Parent = root
			local camcf = CFrame.identity
			if workspace.CurrentCamera then
				camcf = workspace.CurrentCamera.CFrame
			end
			local _,angle,_ = camcf:ToEulerAngles(Enum.RotationOrder.YXZ)
			local movedir = CFrame.Angles(0, angle, 0):VectorToObjectSpace(hum.MoveDirection)
			flyv.Velocity = camcf:VectorToWorldSpace(movedir) * hum.WalkSpeed * m.FlySpeed
			flyg.CFrame = camcf.Rotation
		else
			hum.PlatformStand = false
			flyv.Parent = nil
			flyg.Parent = nil
		end
		
		-- jump fly
		if hum.Jump then
			hum:ChangeState(Enum.HumanoidStateType.Jumping)
		end
		
		-- float if not dancing
		if isdancing then
			hum.HipHeight = 0
		else
			hum.HipHeight = 2.5 * scale
		end
		
		-- joints
		local rt, nt, rst, lst, rht, lht = CFrame.identity, CFrame.identity, CFrame.identity, CFrame.identity, CFrame.identity, CFrame.identity
		local swordoff = CFrame.identity
		
		local timingsine = t * 60 -- timing from patchma's il
		local onground = hum:GetState() == Enum.HumanoidStateType.Running
		
		-- animations
		rt = CFrame.new(0, 0, math.sin(timingsine / 25) * 0.5) * CFrame.Angles(math.rad(20), 0, 0)
		lst = CFrame.Angles(math.rad(-10 - 10 * math.cos(timingsine / 25)), 0, math.rad(-20))
		rht = CFrame.Angles(math.rad(-10 - 10 * math.cos(timingsine / 25)), math.rad(-10), math.rad(20))
		lht = CFrame.Angles(math.rad(-10 - 10 * math.cos(timingsine / 25)), math.rad(10), math.rad(-10))
		if onground and not flight then
			rst = CFrame.Angles(0, 0, math.rad(-10))
			swordoff = CFrame.new(0, -1, 0) * CFrame.Angles(math.rad(154.35 + 5.65 * math.sin(timingsine / 25)), 0, 0)
		else
			rst = CFrame.Angles(math.rad(45), 0, math.rad(80 - 5 * math.cos(timingsine / 25)))
			swordoff = CFrame.new(0, 0, -0.5) * CFrame.Angles(0, math.rad(170), math.rad(-10))
		end
		local altnecksnap = hum.MoveDirection.Magnitude > 0
		if not altnecksnap then
			nt = CFrame.Angles(math.rad(20), math.rad(10 * math.sin(timingsine / 50)), 0)
		end
		local attackdur = t - attack
		if attackdur < 0.5 then
			altnecksnap = true
			local attackside = (attackdur < 0.25) == (attackcount % 2 == 0)
			if lastattackside ~= attackside then
				Attack((root.CFrame * CFrame.new(0, -math.cos(math.rad(attackdegrees + 10)) * 4.5 * scale, -4.5 * scale * m.HitboxScale)).Position, 4.5 * scale * m.HitboxScale)
			end
			lastattackside = attackside
			if attackside then
				rt = CFrame.new(0, 0, math.sin(timingsine / 25) * 0.5) * CFrame.Angles(math.rad(5), 0, math.rad(-20))
				rst = CFrame.Angles(0, math.rad(-50), math.rad(attackdegrees))
				swordoff = CFrame.new(-0.5, -0.5, 0) * CFrame.Angles(math.rad(180), math.rad(-90), 0)
			else
				rt = CFrame.new(0, 0, math.sin(timingsine / 25) * 0.5) * CFrame.Angles(math.rad(5), 0, math.rad(20))
				rst = CFrame.Angles(0, math.rad(50), math.rad(attackdegrees))
				swordoff = CFrame.new(-0.5, -0.5, 0) * CFrame.Angles(math.rad(180), math.rad(-90), 0)
			end
		end
		if altnecksnap then
			if math.random(15) == 1 then
				necksnap = timingsine
				necksnapcf = CFrame.Angles(
					math.rad(math.random(-20, 20)),
					math.rad(math.random(-20, 20)),
					math.rad(math.random(-20, 20))
				)
			end
		else
			if math.random(15) == 1 then
				necksnap = timingsine
				necksnapcf = CFrame.Angles(
					math.rad(20 + math.random(-20, 20)),
					math.rad((10 * math.sin(timingsine / 50)) + math.random(-20, 20)),
					math.rad(math.random(-20, 20))
				)
			end
		end
		
		-- fix neck snap replicate
		local snaptime = 1
		if m.FixNeckSnapReplicate then
			snaptime = 7
		end
		
		-- store the sword when dancing
		sword.Disabled = not not isdancing
		
		-- apply scaling
		scale = scale - 1
		rt += rt.Position * scale
		nt += nt.Position * scale
		rst += rst.Position * scale
		lst += lst.Position * scale
		rht += rht.Position * scale
		lht += lht.Position * scale
		
		-- joints
		local rj = root:FindFirstChild("RootJoint")
		local nj = torso:FindFirstChild("Neck")
		local rsj = torso:FindFirstChild("Right Shoulder")
		local lsj = torso:FindFirstChild("Left Shoulder")
		local rhj = torso:FindFirstChild("Right Hip")
		local lhj = torso:FindFirstChild("Left Hip")
		
		-- interpolation
		local alpha = math.exp(-17.25 * dt)
		joints.r = rt:Lerp(joints.r, alpha)
		joints.n = nt:Lerp(joints.n, alpha)
		joints.rs = rst:Lerp(joints.rs, alpha)
		joints.ls = lst:Lerp(joints.ls, alpha)
		joints.rh = rht:Lerp(joints.rh, alpha)
		joints.lh = lht:Lerp(joints.lh, alpha)
		joints.sw = swordoff:Lerp(joints.sw, alpha)
		
		-- apply transforms
		rj.Transform = joints.r
		rsj.Transform = joints.rs
		lsj.Transform = joints.ls
		rhj.Transform = joints.rh
		lhj.Transform = joints.lh
		if m.NeckSnap and timingsine - necksnap < snaptime then
			nj.Transform = necksnapcf
		else
			nj.Transform = joints.n
		end
		
		-- wings
		if isdancing then
			leftwing.Offset = CFrame.new(-0.15, 0, 0) * CFrame.Angles(0, math.rad(-15), 0)
			rightwing.Offset = CFrame.new(0.15, 0, 0) * CFrame.Angles(0, math.rad(15), 0)
		else
			if m.Bee then
				leftwing.Offset = CFrame.new(-0.15, 0, 0) * CFrame.Angles(0, math.rad(-15 + 25 * math.cos(timingsine)), 0)
				rightwing.Offset = CFrame.new(0.15, 0, 0) * CFrame.Angles(0, math.rad(15 - 25 * math.cos(timingsine)), 0)
			else
				leftwing.Offset = CFrame.new(-0.15, 0, 0) * CFrame.Angles(0, math.rad(-15 + 25 * math.cos(timingsine / 25)), 0)
				rightwing.Offset = CFrame.new(0.15, 0, 0) * CFrame.Angles(0, math.rad(15 - 25 * math.cos(timingsine / 25)), 0)
			end
		end
		
		-- sword
		sword.Offset = joints.sw
		
		-- dance reactions
		if figure:GetAttribute("IsDancing") then
			local name = figure:GetAttribute("DanceInternalName")
			if name == "RAGDOLL" then
				dancereact.Ragdoll = dancereact.Ragdoll or 0
				if t - dancereact.Ragdoll > 15 then
					if math.random(5) == 1 then
						notify("OW OW OW OW OW OW")
					elseif math.random(4) == 1 then
						notify("OH GOD NOT THE RAGDOLL NOT THE RAGDOLL")
					elseif math.random(3) == 1 then
						notify("NO NO NOT AGAIN NOT AGAIN NOT AGAIN")
					elseif math.random(2) == 1 then
						notify("OH NO NO NO NO WAIT WAIT WAIT WAIT WAIT")
					else
						notify("NO THIS IS NOT CANON I AM IMMORTAL")
					end
				end
				dancereact.Ragdoll = t
			end
			if name == "KEMUSAN" then
				dancereact.Kemusan = dancereact.Kemusan or 0
				if t - dancereact.Kemusan > 60 then
					task.delay(2, notify, "how many SOCIAL CREDITS do i get?")
				end
				dancereact.Kemusan = t
			end
			if name == "TUKATUKADONKDONK" then
				dancereact.TUKATUKADONKDONK = dancereact.TUKATUKADONKDONK or 0
				if t - dancereact.TUKATUKADONKDONK > 60 then
					task.delay(1, notify, "i have no idea what this is")
					task.delay(4, notify, "the green aura looking thing looks cool")
				end
				dancereact.TUKATUKADONKDONK = t
			end
			if name == "ClassC14" then
				dancereact.ClassC14 = dancereact.ClassC14 or 0
				if t - dancereact.ClassC14 > 60 then
					task.delay(2, notify, "this song is INTERESTING...")
				end
				dancereact.ClassC14 = t
			end
			if name == "SpeedAndKaiCenat" then
				if not dancereact.AlightMotion then
					task.delay(1, notify, "i have an idea " .. Player.Name:lower())
					task.delay(4, notify, "what if lightning cannon is the other guy")
				end
				dancereact.AlightMotion = true
			end
		end
	end
	m.Destroy = function(figure: Model?)
		ContextActionService:UnbindAction("Uhhhhhh_ILFlight")
		ContextActionService:UnbindAction("Uhhhhhh_ILAttack")
		ContextActionService:UnbindAction("Uhhhhhh_ILTeleport")
		ContextActionService:UnbindAction("Uhhhhhh_ILDestroy")
		ContextActionService:UnbindAction("Uhhhhhh_ILMusic")
		flyv:Destroy()
		flyg:Destroy()
		if chatconn then
			chatconn:Disconnect()
			chatconn = nil
		end
	end
	return m
end)

AddModule(function()
	local m = {}
	m.ModuleType = "MOVESET"
	m.Name = "Lightning Cannon"
	m.Description = "lc if he locked in\nF - Toggle flight\nClick/Tap - \"Shoot\"\nZ - Dash (yes it kills)\nX then Click/Tap - \"Singularity Beam\"\n(you can X again to cancel charge)\nC then Click/Tap - \"Painless Rain\"\nV then Click/Tap - GRENADE\nB -\"Die X3\"\nM - Switch modes\nModes: 1. Normal\n       2. Power-up\n       3. Fast-as-frick Boii"
	m.InternalName = "LightningFanon"
	m.Assets = {"LightningCannonTheme.mp3", "LightningCannonPower.mp3", "LightningCannonFastBoi.mp3"}

	m.Bee = false
	m.Notifications = true
	m.Sounds = true
	m.NoCooldown = false
	m.FlySpeed = 2
	m.UseSword = false
	m.HitboxDebug = false
	m.DarkFountain = false
	m.GrenadeAmount = 42
	m.BeamCharge = 3.86
	m.BeamDuration = 3
	m.RainAmount = 5
	m.IgnoreDancing = false
	m.SkipSanity = false
	m.Config = function(parent: GuiBase2d)
		Util_CreateSwitch(parent, "Bee Wings", m.Bee).Changed:Connect(function(val)
			m.Bee = val
		end)
		Util_CreateSwitch(parent, "Text thing", m.Notifications).Changed:Connect(function(val)
			m.Notifications = val
		end)
		Util_CreateSwitch(parent, "Sounds", m.Sounds).Changed:Connect(function(val)
			m.Sounds = val
		end)
		Util_CreateSlider(parent, "Fly Speed", m.FlySpeed, 1, 8, 1).Changed:Connect(function(val)
			m.FlySpeed = val
		end)
		Util_CreateSwitch(parent, "Hitbox Visual", m.HitboxDebug).Changed:Connect(function(val)
			m.HitboxDebug = val
		end)
		Util_CreateSeparator(parent)
		Util_CreateText(parent, "Random configs for the non-programmers that want to tweak the moveset >:D", 15, Enum.TextXAlignment.Center)
		Util_CreateText(parent, "No cooldowns, lets you spam attacks. Lag warning though!", 12, Enum.TextXAlignment.Center)
		Util_CreateSwitch(parent, "Turbo mode", m.NoCooldown).Changed:Connect(function(val)
			m.NoCooldown = val
		end)
		Util_CreateText(parent, "Use the sword instead of the gun!", 12, Enum.TextXAlignment.Center)
		Util_CreateSwitch(parent, "Gun = Sword", m.UseSword).Changed:Connect(function(val)
			m.UseSword = val
		end)
		Util_CreateSwitch(parent, "m.DarkFountain =", m.DarkFountain).Changed:Connect(function(val)
			m.DarkFountain = val
		end)
		Util_CreateText(parent, "Don't forget, the default is the answer to the meaning of life. (42)", 12, Enum.TextXAlignment.Center)
		Util_CreateSlider(parent, "Grenade Amount", m.GrenadeAmount, 1, 67, 1).Changed:Connect(function(val)
			m.GrenadeAmount = val
		end)
		Util_CreateText(parent, "The beam normally charges for 3.86 seconds. Who picked this number??? 🥀😭", 12, Enum.TextXAlignment.Center)
		Util_CreateSlider(parent, "Beam Charge", m.BeamCharge, 0, 10, 0).Changed:Connect(function(val)
			m.BeamCharge = val
		end)
		Util_CreateText(parent, "The beam normally lasts 3 seconds\nSet it to 0 and itll be a railgun", 12, Enum.TextXAlignment.Center)
		Util_CreateSlider(parent, "Beam Duration", m.BeamDuration, 0, 10, 0).Changed:Connect(function(val)
			m.BeamDuration = val
		end)
		Util_CreateText(parent, "More rain more fast", 15, Enum.TextXAlignment.Center)
		Util_CreateSlider(parent, "Rain Amount", m.RainAmount, 1, 20, 1).Changed:Connect(function(val)
			m.RainAmount = val
		end)
		Util_CreateText(parent, "This will let you use attacks when dancing, when in mode 2's \"intro\" or when in mode 3.", 12, Enum.TextXAlignment.Center)
		Util_CreateSwitch(parent, "Ignore Dancing", m.IgnoreDancing).Changed:Connect(function(val)
			m.IgnoreDancing = val
		end)
		Util_CreateText(parent, "Removes mode 2's \"intro\"", 12, Enum.TextXAlignment.Center)
		Util_CreateSwitch(parent, "Jump to INSaNiTY", m.SkipSanity).Changed:Connect(function(val)
			m.SkipSanity = val
		end)
	end
	m.LoadConfig = function(save: any)
		m.Bee = not not save.Bee
		m.Notifications = not save.NoTextType
		m.Sounds = not save.Muted
		m.FlySpeed = save.FlySpeed or m.FlySpeed
		m.HitboxDebug = not not save.HitboxDebug
		m.UseSword = not not save.UseSword
		m.NoCooldown = not not save.NoCooldown
		m.DarkFountain = not not save.DarkFountain
		m.GrenadeAmount = save.GrenadeAmount or m.GrenadeAmount
		m.BeamCharge = save.BeamCharge or m.BeamCharge
		m.BeamDuration = save.BeamDuration or m.BeamDuration
		m.RainAmount = save.RainAmount or m.RainAmount
		m.IgnoreDancing = not not save.IgnoreDancing
		m.SkipSanity = not not save.SkipSanity
	end
	m.SaveConfig = function()
		return {
			Bee = m.Bee,
			NoTextType = not m.Notifications,
			Muted = not m.Sounds,
			FlySpeed = m.FlySpeed,
			HitboxDebug = m.HitboxDebug,
			UseSword = m.UseSword,
			NoCooldown = m.NoCooldown,
			DarkFountain = m.DarkFountain,
			GrenadeAmount = m.GrenadeAmount,
			BeamCharge = m.BeamCharge,
			BeamDuration = m.BeamDuration,
			RainAmount = m.RainAmount,
			IgnoreDancing = m.IgnoreDancing,
			SkipSanity = m.SkipSanity,
		}
	end

	local ROOTC0 = CFrame.new(0, 0, 0) * CFrame.Angles(math.rad(-90), 0, math.rad(180))
	local NECKC0 = CFrame.new(0, 1, 0) * CFrame.Angles(math.rad(-90), 0, math.rad(180))
	local RIGHTSHOULDERC0 = CFrame.new(-0.5, 0, 0) * CFrame.Angles(0, math.rad(90), 0)
	local LEFTSHOULDERC0 = CFrame.new(0.5, 0, 0) * CFrame.Angles(0, math.rad(-90), 0)
	local curcolor = Color3.new(1, 0, 0)
	local scale = 1
	local isdancing = false
	local hum = nil
	local root = nil
	local torso = nil
	local flight = false
	local start = 0
	local attacking = false
	local animationOverride = nil
	local currentmode = 0
	local sanitysongsync = 0
	local fastboistart = 0
	local fastboisegment = false
	local rcp = RaycastParams.new()
	rcp.FilterType = Enum.RaycastFilterType.Exclude
	rcp.RespectCanCollide = true
	rcp.IgnoreWater = true
	local function PhysicsRaycast(origin, direction)
		return workspace:Raycast(origin, direction, rcp)
	end
	local function notify(message, glitchy)
		glitchy = not not glitchy
		if not m.Notifications then return end
		if not root or not torso then return end
		local dialog = torso:FindFirstChild("NOTIFICATION")
		if dialog then
			dialog:Destroy()
		end
		dialog = Instance.new("BillboardGui", torso)
		dialog.Size = UDim2.new(50 * scale, 0, 2 * scale, 0)
		dialog.StudsOffset = Vector3.new(0, 5 * scale, 0)
		dialog.Adornee = torso
		dialog.Name = "NOTIFICATION"
		local text1 = Instance.new("TextLabel", dialog)
		text1.BackgroundTransparency = 1
		text1.BorderSizePixel = 0
		text1.Text = ""
		text1.Font = "Code"
		text1.TextScaled = true
		text1.TextStrokeTransparency = 0
		text1.TextStrokeColor3 = Color3.new(1, 1, 1)
		text1.Size = UDim2.new(1, 0, 1, 0)
		text1.ZIndex = 0
		text1.TextColor3 = Color3.new(1, 0, 0)
		local text2 = text1:Clone()
		text2.Parent = dialog
		text2.ZIndex = 1
		task.spawn(function()
			local function update()
				if glitchy then
					local fonts = {"Antique", "Arcade", "Arial", "ArialBold", "Bodoni", "Cartoon", "Code", "Fantasy", "Garamond", "Gotham", "GothamBlack", "GothamBold", "GothamSemibold", "Highway", "SciFi", "SourceSans", "SourceSansBold", "SourceSansItalic", "SourceSansLight", "SourceSansSemibold"}
					local randomfont = fonts[math.random(1, #fonts)]
					text1.Font = randomfont
					text2.Font = randomfont
				end
				local color = curcolor
				text1.TextColor3 = Color3.new(0, 0, 0):Lerp(color, 0.5)
				text2.TextColor3 = color
				text1.Position = UDim2.new(0, math.random(-1, 1), 0, math.random(-1, 1))
				text2.Position = UDim2.new(0, math.random(-1, 1), 0, math.random(-1, 1))
			end
			local cps = 30
			local t = os.clock()
			local ll = 0
			repeat
				task.wait()
				local l = math.floor((os.clock() - t) * cps)
				if l > ll then
					ll = l
				end
				update()
				text1.Text = string.sub(message, 1, l)
				text2.Text = string.sub(message, 1, l)
			until ll >= #message
			text1.Text = message
			text2.Text = message
			t = os.clock()
			repeat
				task.wait()
				update()
			until os.clock() - t > 2
			t = os.clock()
			repeat
				task.wait()
				update()
				local a = os.clock() - t
				text1.Rotation = a * math.random() * -20
				text2.Rotation = a * math.random() * 20
				text1.TextTransparency = a
				text2.TextTransparency = a
				text1.TextStrokeTransparency = a
				text2.TextStrokeTransparency = a
			until os.clock() - t > 1
			dialog:Destroy()
		end)
	end
	local function randomdialog(arr, glitchy)
		notify(arr[math.random(1, #arr)], glitchy)
	end
	local function Effect(params)
		if not torso then return end
		local shapetype = params.EffectType or "Sphere"
		local size = params.Size or Vector3.new(1, 1, 1)
		local endsize = params.SizeEnd or Vector3.new(0, 0, 0)
		local transparency = params.Transparency or 0
		local endtransparency = params.TransparencyEnd or 1
		local cfr = params.CFrame or torso.CFrame
		local movedir = params.MoveToPos
		local rotx = params.RotationX or 0
		local roty = params.RotationY or 0
		local rotz = params.RotationZ or 0
		local material = params.Material or Enum.Material.Neon
		local color = params.Color or "RAINBOW"
		local ticks = params.Time or 45
		local start = os.clock()
		local boomerang = params.Boomerang
		local boomerangsize = params.BoomerangSize
		local effect = Instance.new("Part")
		effect.Massless = true
		effect.Transparency = transparency
		effect.CastShadow = false
		effect.Anchored = true
		effect.CanCollide = false
		effect.CanTouch = false
		effect.CanQuery = false
		effect.Color = Color3.new(1, 1, 1)
		effect.Name = RandomString()
		effect.Size = Vector3.one
		effect.Material = material
		effect.Parent = workspace
		local mesh = nil
		if shapetype == "Sphere" then
			mesh = Instance.new("SpecialMesh", effect)
			mesh.MeshType = "Sphere"
			mesh.Scale = size
		elseif shapetype == "Block" or shapetype == "Box" then
			mesh = Instance.new("BlockMesh", effect)
			mesh.Scale = size
		elseif shapetype == "Cylinder" then
			mesh = Instance.new("SpecialMesh", effect)
			mesh.MeshType = "Cylinder"
			mesh.Scale = size
		elseif shapetype == "Slash" then
			mesh = Instance.new("SpecialMesh", effect)
			mesh.MeshType = "FileMesh"
			mesh.MeshId = "rbxassetid://662585058"
			mesh.Scale = size
		elseif shapetype == "Swirl" then
			mesh = Instance.new("SpecialMesh", effect)
			mesh.MeshType = "FileMesh"
			mesh.MeshId = "rbxassetid://1051557"
			mesh.Scale = size
		end
		if mesh ~= nil then
			task.spawn(function()
				local movespeed = nil
				local growth = nil
				if boomerang and boomerangsize then
					local bmr1 = 1 + boomerang / 50
					local bmr2 = 1 + boomerangsize / 50
					if movedir ~= nil then
						movespeed = ((cfr.Position - movedir).Magnitude / ticks) * bmr1
					end
					growth = (endsize - size) * (bmr2 + 1)
					local t = 0
					repeat
						t = os.clock() - start
						if color == "RAINBOW" then
							effect.Color = curcolor
						elseif color == "RANDOM" then
							effect.Color = BrickColor.random().Color
						else
							effect.Color = color
						end
						local loop = t * 60
						local t2 = loop / ticks
						mesh.Scale = size + growth * (t2 - bmr2 * 0.5 * t2 * t2) * bmr2
						effect.Transparency = transparency + (endtransparency - transparency) * t2
						local add = Vector3.zero
						if movedir ~= nil then
							add = CFrame.lookAt(cfr.Position, movedir) * Vector3.new(0, 0, -movespeed * (t2 - bmr1 * 0.5 * t2 * t2))
						end
						if shapetype == "Block" then
							effect.CFrame = cfr * CFrame.Angles(
								math.random() * math.pi * 2,
								math.random() * math.pi * 2,
								math.random() * math.pi * 2
							) + add
						else
							effect.CFrame = cfr * CFrame.Angles(
								math.rad(rotx * loop),
								math.rad(roty * loop),
								math.rad(rotz * loop)
							) + add
						end
						task.wait()
					until t > ticks / 60
				else
					if movedir ~= nil then
						movespeed = (cfr.Position - movedir).Magnitude / ticks
					end
					growth = endsize - size
					local t = 0
					repeat
						t = os.clock() - start
						if color == "RAINBOW" then
							effect.Color = curcolor
						elseif color == "RANDOM" then
							effect.Color = BrickColor.random().Color
						else
							effect.Color = color
						end
						local loop = t * 60
						local t2 = loop / ticks
						mesh.Scale = size + growth * t2
						effect.Transparency = transparency + (endtransparency - transparency) * t2
						local add = Vector3.zero
						if movedir ~= nil then
							add = CFrame.lookAt(cfr.Position, movedir) * Vector3.new(0, 0, -movespeed * t2)
						end
						if shapetype == "Block" then
							effect.CFrame = cfr * CFrame.Angles(
								math.random() * math.pi * 2,
								math.random() * math.pi * 2,
								math.random() * math.pi * 2
							) + add
						else
							effect.CFrame = cfr * CFrame.Angles(
								math.rad(rotx * loop),
								math.rad(roty * loop),
								math.rad(rotz * loop)
							) + add
						end
						task.wait()
					until t > ticks / 60
				end
				effect.Transparency = 1
				Debris:AddItem(effect, 5)
			end)
		else
			effect.Transparency = 1
			Debris:AddItem(effect, 5)
		end
		return effect
	end
	local function Lightning(params)
		local start = params.Start or Vector3.new(0, 0, 0)
		local finish = params.Finish or Vector3.new(0, 512, 0)
		local offset = params.Offset or 0
		local ticks = params.Time or 15
		local color = params.Color or "RAINBOW"
		local sizestart = params.SizeStart or 0
		local sizeend = params.SizeEnd or 1
		local transparency = params.Transparency or 0
		local endtransparency = params.TransparencyEnd or 1
		local lenperseg = params.SegmentSize or 10
		local boomerangsize = params.BoomerangSize
		local dist = (finish - start).Magnitude
		local segs = math.clamp(dist // lenperseg, 1, 20)
		local curpos = start
		local progression = (1 / segs) * dist
		for i=1, segs do
			local alpha = i / segs
			local zig = Vector3.new(
				offset * (-1 + math.random(0, 1) * 2),
				offset * (-1 + math.random(0, 1) * 2),
				offset * (-1 + math.random(0, 1) * 2)
			)
			local uwu = (CFrame.new(curpos, finish) * Vector3.new(0, 0, -progression)) + zig
			local length = progression
			if segs == i then
				length = (curpos - finish).Magnitude
				uwu = finish
			end
			Effect({
				Time = ticks,
				EffectType = "Box",
				Size = Vector3.new(sizestart, sizestart, length),
				SizeEnd = Vector3.new(sizeend, sizeend, length),
				Transparency = transparency,
				TransparencyEnd = endtransparency,
				CFrame = CFrame.new(curpos, uwu) * CFrame.new(0, 0, -length / 2),
				Color = color,
				Boomerang = 0,
				BoomerangSize = boomerangsize
			})
			curpos = CFrame.new(curpos, uwu) * Vector3.new(0, 0, -length)
		end
	end
	local function CreateSound(id, pitch, extra)
		if not m.Sounds then return end
		if not torso then return end
		local parent = torso
		if typeof(id) == "Instance" then
			parent = id
			id, pitch = pitch, extra
		end
		pitch = pitch or 1
		local sound = Instance.new("Sound")
		sound.Name = tostring(id)
		sound.SoundId = "rbxassetid://" .. id
		sound.Volume = 1
		sound.Pitch = pitch
		sound.EmitterSize = 300
		sound.Parent = parent
		sound:Play()
		sound.Ended:Connect(function()
			sound:Destroy()
		end)
	end
	local function EffectCannon(hole, target, bang)
		local dist = (hole - target).Magnitude
		hole = CFrame.Angles(math.rad(math.random(0, 360)), math.rad(math.random(0, 360)), math.rad(math.random(0, 360))) + hole
		local before = Effect({Time = 25, EffectType = "Box", Size = Vector3.new(0, 0, 0), SizeEnd = Vector3.new(3, 3, 3), Transparency = 0, TransparencyEnd = 1, CFrame = hole, RotationX = math.random(-1, 1), RotationY = math.random(-1, 1), RotationZ = math.random(-1, 1), Boomerang = 0, BoomerangSize = 50})
		Effect({Time = 25, EffectType = "Box", Size = Vector3.new(0, 0, 0), SizeEnd = Vector3.new(3, 3, 3), Transparency = 0, TransparencyEnd = 1, CFrame = hole, RotationX = math.random(-1, 1), RotationY = math.random(-1, 1), RotationZ = math.random(-1, 1), Color = Color3.new(1, 1, 1), Boomerang = 0, BoomerangSize = 50})
		local after = Effect({Time = 25, EffectType = "Box", Size = Vector3.new(0, 0, 0), SizeEnd = Vector3.new(3, 3, 3), Transparency = 0, TransparencyEnd = 1, CFrame = CFrame.new(target), RotationX = math.random(-1, 1), RotationY = math.random(-1, 1), RotationZ = math.random(-1, 1), Boomerang = 0, BoomerangSize = 50})
		Effect({Time = 25, EffectType = "Box", Size = Vector3.new(0, 0, 0), SizeEnd = Vector3.new(3, 3, 3), Transparency = 0, TransparencyEnd = 1, CFrame = CFrame.new(target), RotationX = math.random(-1, 1), RotationY = math.random(-1, 1), RotationZ = math.random(-1, 1), Color = Color3.new(1, 1, 1), Boomerang = 0, BoomerangSize = 50})
		Effect({Time = 25, EffectType = "Cylinder", Size = Vector3.new(dist, 1, 1), SizeEnd = Vector3.new(dist, 1, 1), Transparency = 0, TransparencyEnd = 1, CFrame = CFrame.lookAt((hole.Position + target) / 2, target) * CFrame.Angles(0, math.rad(90), 0), Color = Color3.new(1, 1, 1)})
		for _=1,5 do
			Lightning({Start = hole.Position, Finish = target, Offset = 3.5, Time = 25, BoomerangSize = 55})
		end
		for _=0,2 do
			Effect({Time = math.random(25, 50), EffectType = "Slash", Size = Vector3.new(0, 0, 0), SizeEnd = Vector3.new(0.1, 0, 0.1), Transparency = 0, TransparencyEnd = 1, CFrame = hole * CFrame.Angles(math.rad(math.random(0, 360)), math.rad(math.random(0, 360)), math.rad(math.random(0, 360))), RotationX = math.random(-1, 1), RotationY = math.random(-1, 1), RotationZ = math.random(-1, 1), Boomerang = 0, BoomerangSize = 15})
			Effect({Time = math.random(25, 50), EffectType = "Slash", Size = Vector3.new(0, 0, 0), SizeEnd = Vector3.new(0.1, 0, 0.1), Transparency = 0, TransparencyEnd = 1, CFrame = hole * CFrame.Angles(math.rad(math.random(0, 360)), math.rad(math.random(0, 360)), math.rad(math.random(0, 360))), RotationX = math.random(-1, 1), RotationY = math.random(-1, 1), RotationZ = math.random(-1, 1), Color = Color3.new(1, 1, 1), Boomerang = 0, BoomerangSize = 15})
		end
		for _=0,2 do
			Effect({Time = math.random(25, 50), EffectType = "Slash", Size = Vector3.new(0, 0, 0), SizeEnd = Vector3.new(0.1, 0, 0.1), Transparency = 0, TransparencyEnd = 1, CFrame = CFrame.new(target) * CFrame.Angles(math.rad(math.random(0, 360)), math.rad(math.random(0, 360)), math.rad(math.random(0, 360))), RotationX = math.random(-1, 1), RotationY = math.random(-1, 1), RotationZ = math.random(-1, 1), Boomerang = 0, BoomerangSize = 15})
			Effect({Time = math.random(25, 50), EffectType = "Slash", Size = Vector3.new(0, 0, 0), SizeEnd = Vector3.new(0.1, 0, 0.1), Transparency = 0, TransparencyEnd = 1, CFrame = CFrame.new(target) * CFrame.Angles(math.rad(math.random(0, 360)), math.rad(math.random(0, 360)), math.rad(math.random(0, 360))), RotationX = math.random(-1, 1), RotationY = math.random(-1, 1), RotationZ = math.random(-1, 1), Color = Color3.new(1, 1, 1), Boomerang = 0, BoomerangSize = 15})
		end
		if bang ~= false then CreateSound(before, 642890855, 0.45) end
		CreateSound(after, 192410089, 0.55)
	end
	local function Attack(position, radius)
		if m.HitboxDebug then
			local hitvis = Instance.new("Part")
			hitvis.Name = RandomString()
			hitvis.CastShadow = false
			hitvis.Material = Enum.Material.ForceField
			hitvis.Anchored = true
			hitvis.CanCollide = false
			hitvis.CanTouch = false
			hitvis.CanQuery = false
			hitvis.Shape = Enum.PartType.Ball
			hitvis.Color = Color3.new(1, 1, 1)
			hitvis.Size = Vector3.one * radius * 2
			hitvis.CFrame = CFrame.new(position)
			hitvis.Parent = workspace
			Debris:AddItem(hitvis, 1)
		end
		local parts = workspace:GetPartBoundsInRadius(position, radius)
		for _,part in parts do
			if part.Parent then
				local hum = part.Parent:FindFirstChildOfClass("Humanoid")
				if hum and hum.RootPart and not hum.RootPart:IsGrounded() then
					ReanimateFling(part.Parent)
				end
			end
		end
	end
	local function AimTowards(target)
		if not root then return end
		local tcf = CFrame.lookAt(root.Position, target)
		local _,off,_ = root.CFrame:ToObjectSpace(tcf):ToEulerAngles(Enum.RotationOrder.YXZ)
		root.AssemblyAngularVelocity = Vector3.new(0, off, 0) * 60
	end
	local function Dash()
		if not m.IgnoreDancing then
			if isdancing then return end
			if currentmode == 1 then
				if sanitysongsync < 8 then return end
			end
			if currentmode == 2 then return end
		end
		if attacking and not m.NoCooldown then return end
		if not root or not hum or not torso then return end
		local rootu = root
		attacking = true
		hum.WalkSpeed = 16 * scale
		CreateSound(235097614, 1.5)
		animationOverride = function(timingsine, rt, nt, rst, lst, rht, lht, gunoff)
			rt = ROOTC0 * CFrame.Angles(0, 0, math.rad(-60))
			nt = NECKC0 * CFrame.Angles(0, 0, math.rad(60))
			rst = CFrame.new(1.25, 0.5, -0.25) * CFrame.Angles(math.rad(90), 0, math.rad(-60)) * RIGHTSHOULDERC0
			lst = CFrame.new(-1.25, 0.5, -0.25) * CFrame.Angles(math.rad(95), 0, math.rad(10)) * LEFTSHOULDERC0
			gunoff = CFrame.new(0, -0.5, 0) * CFrame.Angles(math.rad(180), 0, 0)
			return rt, nt, rst, lst, rht, lht, gunoff
		end
		task.spawn(function()
			task.wait(0.15)
			if not rootu:IsDescendantOf(workspace) then return end
			CreateSound(642890855, 0.45)
			Effect({Time = 25, EffectType = "Box", Size = Vector3.new(2, 2, 2), SizeEnd = Vector3.new(5, 5, 5), Transparency = 0, TransparencyEnd = 1, CFrame = root.CFrame, RotationX = math.random(-1, 1), RotationY = math.random(-1, 1), RotationZ = math.random(-1, 1), Boomerang = 0, BoomerangSize = 50})
			Effect({Time = 25, EffectType = "Box", Size = Vector3.new(2, 2, 2), SizeEnd = Vector3.new(5, 5, 5), Transparency = 0, TransparencyEnd = 1, CFrame = root.CFrame, RotationX = math.random(-1, 1), RotationY = math.random(-1, 1), RotationZ = math.random(-1, 1), Color = Color3.new(1, 1, 1), Boomerang = 0, BoomerangSize = 50})
			Effect({Time = math.random(25, 45), EffectType = "Sphere", Size = Vector3.new(2, 100, 2), SizeEnd = Vector3.new(6, 100, 6), Transparency = 0, TransparencyEnd = 1, CFrame = root.CFrame * CFrame.new(math.random(-1, 1), math.random(-1, 1), -50) * CFrame.Angles(math.rad(math.random(89, 91)), math.rad(math.random(-1, 1)), math.rad(math.random(-1, 1))), Boomerang = 0, BoomerangSize = 45})
			Effect({Time = math.random(25, 45), EffectType = "Sphere", Size = Vector3.new(3, 100, 3), SizeEnd = Vector3.new(9, 100, 9), Transparency = 0, TransparencyEnd = 1, CFrame = root.CFrame * CFrame.new(math.random(-1, 1), math.random(-1, 1), -50) * CFrame.Angles(math.rad(math.random(89, 91)), math.rad(math.random(-1, 1)), math.rad(math.random(-1, 1))), Color = Color3.new(1, 1, 1), Boomerang = 0, BoomerangSize = 45})
			Attack(root.Position, 14)
			for _=1, 4 do
				root.CFrame = root.CFrame * CFrame.new(0, 0, -25)
				Attack(root.Position, 14)
				Lightning({Start = root.CFrame * Vector3.new(math.random(-2.5, 2.5), math.random(-5, 5), math.random(-15, 15)), Finish = root.CFrame * Vector3.new(math.random(-2.5, 2.5), math.random(-5, 5), math.random(-15, 15)), Offset = 25, Time = math.random(30, 45), SizeStart = 0.5, SizeEnd = 1.5, BoomerangSize = 60})
			end
			Effect({Time = 25, EffectType = "Box", Size = Vector3.new(2, 2, 2), SizeEnd = Vector3.new(5, 5, 5), Transparency = 0, TransparencyEnd = 1, CFrame = root.CFrame, RotationX = math.random(-1, 1), RotationY = math.random(-1, 1), RotationZ = math.random(-1, 1), Boomerang = 0, BoomerangSize = 50})
			Effect({Time = 25, EffectType = "Box", Size = Vector3.new(2, 2, 2), SizeEnd = Vector3.new(5, 5, 5), Transparency = 0, TransparencyEnd = 1, CFrame = root.CFrame, RotationX = math.random(-1, 1), RotationY = math.random(-1, 1), RotationZ = math.random(-1, 1), Color = Color3.new(1, 1, 1), Boomerang = 0, BoomerangSize = 50})
			animationOverride = function(timingsine, rt, nt, rst, lst, rht, lht, gunoff)
				rt = ROOTC0 * CFrame.Angles(0, 0, math.rad(90))
				nt = NECKC0 * CFrame.Angles(0, 0, math.rad(-90))
				rst = CFrame.new(1.5, 0.5, 0) * CFrame.Angles(math.rad(90), 0, math.rad(90)) * RIGHTSHOULDERC0
				lst = CFrame.new(-1.5, 0.5, 0) * CFrame.Angles(math.rad(40), math.rad(5), math.rad(5)) * LEFTSHOULDERC0
				return rt, nt, rst, lst, rht, lht, gunoff
			end
			if math.random(2) == 1 then
				randomdialog({
					"SURPRISE",
					"got you",
					"Immortality Lord, YOU CANNOT DO THIS",
					"my mobility is far better",
					"LIGHTNING FAST",
					"KEEP UP",
					"EAT MY STARDUST",
					"YOU CANNOT BOLT AWAY",
					"READ MY NAME, I AM LIGHTNING CANNON.",
				}, true)
			end
			task.wait(0.15)
			if not rootu:IsDescendantOf(workspace) then return end
			animationOverride = nil
			attacking = false
			hum.WalkSpeed = 50 * scale
		end)
	end
	local function KaBoom()
		if not m.IgnoreDancing then
			if isdancing then return end
			if currentmode == 1 then
				if sanitysongsync < 8 then return end
			end
			if currentmode == 2 then return end
		end
		if attacking and not m.NoCooldown then return end
		if not root or not hum or not torso then return end
		local rootu = root
		attacking = true
		hum.WalkSpeed = 0
		notify("die... Die... DIE!!!", true)
		CreateSound(1566051529)
		task.spawn(function()
			local fountain = math.random(30) == 1 or m.DarkFountain
			local beamtime = 140
			if fountain then
				task.spawn(function()
					for _=1,9 do
						task.wait(0.2)
						CreateSound(199145095)
					end
				end)
				animationOverride = function(timingsine, rt, nt, rst, lst, rht, lht, gunoff)
					rt *= CFrame.new(0, 0, 8) * CFrame.Angles(math.rad((os.clock() * 120 * 22) % 360), 0, 0)
					return rt, nt, rst, lst, rht, lht, gunoff
				end
				task.wait(1.85)
				animationOverride = function(timingsine, rt, nt, rst, lst, rht, lht, gunoff)
					rt *= CFrame.new(0, 0, 10) * CFrame.Angles(math.rad(90), 0, math.rad(-60))
					nt = NECKC0 * CFrame.Angles(0, 0, math.rad(60))
					rst = CFrame.new(1.25, 0.5, -0.25) * CFrame.Angles(math.rad(90), 0, math.rad(-60)) * RIGHTSHOULDERC0
					lst = CFrame.new(-1.25, 0.5, -0.25) * CFrame.Angles(math.rad(95), 0, math.rad(10)) * LEFTSHOULDERC0
					gunoff = CFrame.new(0, -0.5, 0) * CFrame.Angles(math.rad(180), 0, 0)
					return rt, nt, rst, lst, rht, lht, gunoff
				end
				task.wait(0.1)
				CreateSound(73280255204654)
				task.spawn(function()
					local interval = 0.8 / 17
					local w = interval
					for i=-8, 8 do
						local cf = root.CFrame * CFrame.new(i * 2, 8 + math.random(), 3)
						for _=1, 3 do
							Effect({Time = math.random(45, 65), EffectType = "Sphere", Size = Vector3.new(0.2, 1, 0.2), SizeEnd = Vector3.new(0.2, 1, 0.2), Transparency = 0, TransparencyEnd = 1, CFrame = cf * CFrame.Angles(math.rad(math.random(0, 360)), math.rad(math.random(0, 360)), math.rad(math.random(0, 360)))})
						end
						local s = os.clock() + interval
						task.wait(w)
						w = interval - (os.clock() - s)
					end
				end)
				task.wait(0.8)
				animationOverride = function(timingsine, rt, nt, rst, lst, rht, lht, gunoff)
					rt *= CFrame.new(0, 0, -3) * CFrame.Angles(math.rad(90), 0, 0)
					nt = NECKC0 * CFrame.Angles(math.rad(15), 0, math.rad(-5))
					rst = CFrame.Angles(math.rad(10), math.rad(-10), math.rad(-175)) * RIGHTSHOULDERC0
					lst = CFrame.Angles(math.rad(5), math.rad(-10), math.rad(-10)) * LEFTSHOULDERC0
					return rt, nt, rst, lst, rht, lht, gunoff
				end
				task.wait(0.05)
				beamtime = 300
			else
				for _=1, 3 do
					animationOverride = function(timingsine, rt, nt, rst, lst, rht, lht, gunoff)
						rt *= CFrame.Angles(0, 0, math.rad(-5))
						nt = NECKC0 * CFrame.new(0, 0, 0) * CFrame.Angles(math.rad(15), 0, math.rad(-5))
						rst = CFrame.new(1.5, 0.5, 0) * CFrame.Angles(math.rad(175), math.rad(-10), math.rad(10)) * RIGHTSHOULDERC0
						lst = CFrame.new(-1.5, 0.5, 0) * CFrame.Angles(math.rad(-10), math.rad(-10), math.rad(-5)) * LEFTSHOULDERC0
						return rt, nt, rst, lst, rht, lht, gunoff
					end
					task.wait(0.15)
					if not rootu:IsDescendantOf(workspace) then return end
					local hole = root.CFrame * CFrame.new(Vector3.new(1, 4, -1) * scale)
					EffectCannon(hole.Position, root.CFrame * Vector3.new(0, 300, -50))
					animationOverride = function(timingsine, rt, nt, rst, lst, rht, lht, gunoff)
						nt = NECKC0 * CFrame.new(0, 0, 0) * CFrame.Angles(math.rad(20), 0, 0)
						return rt, nt, rst, lst, rht, lht, gunoff
					end
					task.wait(0.7)
					if not rootu:IsDescendantOf(workspace) then return end
				end
				animationOverride = nil
				task.wait(0.15)
			end
			if not rootu:IsDescendantOf(workspace) then return end
			local beam = root.CFrame
			local moonlord = Effect({Time = beamtime, EffectType = "Sphere", Size = Vector3.zero, SizeEnd = Vector3.new(98, 1120, 98), Transparency = 0, TransparencyEnd = 0, CFrame = beam})
			Effect({Time = beamtime, EffectType = "Sphere", Size = Vector3.zero, SizeEnd = Vector3.new(280, 280, 280), Transparency = 0, TransparencyEnd = 0, CFrame = beam})
			if not fountain then CreateSound(moonlord, 415700134) end
			local s = os.clock()
			local throt = 0
			repeat
				local t = 140 * (os.clock() - s) / beamtime
				if throt > 0.05 then
					Effect({Time = 5 + t * 60, EffectType = "Swirl", Size = Vector3.one * t * 128, SizeEnd = Vector3.new(0, t * 111.5, 0), Transparency = 0.8, TransparencyEnd = 1, CFrame = beam * CFrame.Angles(0, math.rad(t * 300), 0), RotationY = t * 7.5, Color = Color3.new(0, 0, 1)})
					throt = 0
				end
				throt += task.wait()
			until os.clock() - s >= beamtime / 60
			if rootu:IsDescendantOf(workspace) then Attack(beam.Position, 560) end
			Effect({Time = 75, EffectType = "Sphere", Size = Vector3.new(98, 1120, 98), SizeEnd = Vector3.new(0, 1120, 0), Transparency = 0, TransparencyEnd = 0, CFrame = beam, Color = Color3.new(1, 1, 1)})
			Effect({Time = 75, EffectType = "Sphere", Size = Vector3.new(280, 280, 280), SizeEnd = Vector3.zero, Transparency = 0, TransparencyEnd = 0.6, CFrame = beam, Color = Color3.new(1, 1, 1)})
			if not rootu:IsDescendantOf(workspace) then return end
			animationOverride = nil
			attacking = false
			hum.WalkSpeed = 50 * scale
		end)
	end
	local function AttackOne()
		if not m.IgnoreDancing then
			if isdancing then return end
			if currentmode == 1 then
				if sanitysongsync < 8 then return end
			end
			if currentmode == 2 then return end
		end
		if attacking and not m.NoCooldown then return end
		if not root or not hum or not torso then return end
		local rootu = root
		attacking = true
		local mouse = Player:GetMouse()
		local target = mouse.Hit.Position
		task.spawn(function()
			animationOverride = function(timingsine, rt, nt, rst, lst, rht, lht, gunoff)
				rt *= CFrame.Angles(0, 0, math.rad(30))
				nt = NECKC0 * CFrame.Angles(math.rad(15), 0, math.rad(-30))
				rst = CFrame.new(1.5, 0.5, 0) * CFrame.Angles(math.rad(90), 0, math.rad(30)) * RIGHTSHOULDERC0
				lst = CFrame.new(-1.5, 0.5, 0) * CFrame.Angles(math.rad(30), 0, 0) * LEFTSHOULDERC0
				AimTowards(target)
				return rt, nt, rst, lst, rht, lht, gunoff
			end
			task.wait(0.15)
			if not rootu:IsDescendantOf(workspace) then return end
			local hole = root.CFrame * CFrame.new(Vector3.new(1, 0.5, -5) * scale)
			local raycast = PhysicsRaycast(hole.Position, target - hole.Position)
			if raycast then
				target = raycast.Position
			end
			EffectCannon(hole.Position, target)
			if math.random(2) == 1 then
				randomdialog({
					"BOOM",
					"THAT ANT IS DEAD",
					"JUST DOING A GOD'S WORK",
					"Immortality Lord, YOU CANNOT DO THIS",
					"LIGHTNING FAST",
					"WHO THE HELL DO YOU THINK I AM???", -- gurren lagann referencs
					"EAT THIS IF YOU CAN EVEN",
					"READ MY NAME, OF COURSE I SHOOT LIGHTNING",
					"AND IT CANNOT FIGHT BACK",
					"DEATH IS INESCAPABLE. YOU MUST ACCEPT IT.",
				}, true)
			end
			Attack(target, 10)
			animationOverride = function(timingsine, rt, nt, rst, lst, rht, lht, gunoff)
				rt *= CFrame.Angles(0, 0, math.rad(30))
				nt = NECKC0 * CFrame.Angles(math.rad(10), 0, math.rad(-60))
				rst = CFrame.new(1.5, 0.5, 0) * CFrame.Angles(math.rad(160), math.rad(-20), math.rad(60)) * RIGHTSHOULDERC0
				lst = CFrame.new(-1.5, 0.5, 0) * CFrame.Angles(math.rad(40), math.rad(5), math.rad(5)) * LEFTSHOULDERC0
				AimTowards(target)
				return rt, nt, rst, lst, rht, lht, gunoff
			end
			task.wait(0.1)
			if not rootu:IsDescendantOf(workspace) then return end
			animationOverride = nil
			attacking = false
		end)
	end
	local function Granada()
		if not m.IgnoreDancing then
			if isdancing then return end
			if currentmode == 1 then
				if sanitysongsync < 8 then return end
			end
			if currentmode == 2 then return end
		end
		if attacking and not m.NoCooldown then return end
		if not root or not hum or not torso then return end
		local rootu = root
		attacking = true
		hum.WalkSpeed = 0
		local mouse = Player:GetMouse()
		task.spawn(function()
			local amount = math.floor(m.GrenadeAmount * (0.65853 + math.random() * 0.34147))
			if math.random(2) == 1 then
				randomdialog({
					"whoopsies!",
					"Lightning Cannon casts... " .. amount .. " grenades!",
					"Aaaaand... BOOM",
					"Granada!",
					"BOMB HAS BEEN PLANTED.",
					"Happy New Year",
					"DODGE THIS",
				}, true)
			end
			CreateSound(2785493, 0.8)
			animationOverride = function(timingsine, rt, nt, rst, lst, rht, lht, gunoff)
				local cos12 = math.cos(timingsine / 12)
				rt *= CFrame.Angles(0, 0, math.rad(-30))
				nt = NECKC0 * CFrame.Angles(math.rad(-5 - 3 * math.cos(timingsine / 12)), 0, math.rad(30))
				rst = CFrame.new(1.5, 0.5, 0) * CFrame.Angles(math.rad(135 + 8.5 * math.cos(timingsine / 49)), 0, math.rad(25)) * RIGHTSHOULDERC0
				lst = CFrame.new(-1.5, 0.5 + 0.1 * math.cos(timingsine / 12), 0) * CFrame.Angles(math.rad(85 - 1.5 * cos12), math.rad(-6 * cos12), math.rad(-30 - 6 * cos12)) * LEFTSHOULDERC0
				AimTowards(mouse.Hit.Position)
				return rt, nt, rst, lst, rht, lht, gunoff
			end
			local s = os.clock()
			local throt = 0
			repeat
				local hole = root.CFrame * CFrame.new(Vector3.new(0, -1, -2) * scale)
				if throt > 0.02 then
					Effect({Time = math.random(35, 55), EffectType = "Sphere", Size = Vector3.new(0.5, 0.5, 0.5), SizeEnd = Vector3.new(1, 1, 1), Transparency = 0, TransparencyEnd = 1, CFrame = hole, MoveToPos = hole.Position + Vector3.new(math.random(-10, 10), math.random(-10, 10), math.random(-10, 10)), Boomerang = 50, BoomerangSize = 50})
				end
				throt += task.wait()
			until os.clock() - s > 0.85 or not rootu:IsDescendantOf(workspace)
			if not rootu:IsDescendantOf(workspace) then return end
			for _=1, amount do
				task.spawn(function()
					local from = root.CFrame * CFrame.new(Vector3.new(0, -1, -2) * scale)
					local death = Instance.new("Part")
					death.Massless = true
					death.Transparency = 0
					death.Anchored = true
					death.CanCollide = false
					death.CanTouch = false
					death.CanQuery = false
					death.Name = RandomString()
					death.CFrame = from
					death.Size = Vector3.one * 0.6
					death.Shape = Enum.PartType.Ball
					death.Material = Enum.Material.Neon
					death.Parent = workspace
					Effect({Time = math.random(5, 20), EffectType = "Sphere", Size = Vector3.new(3, 3, 3) * math.random(-3, 2), SizeEnd = Vector3.new(6, 6, 6) * math.random(-3, 2), Transparency = 0.4, TransparencyEnd = 1, CFrame = from, Boomerang = 0, BoomerangSize = 25})
					for _=1, amount do task.wait() end
					Effect({Time = math.random(25, 35), EffectType = "Sphere", Size = Vector3.new(0.6, 0.6, 0.6), SizeEnd = Vector3.new(1.6, 1.6, 1.6), Transparency = 0, TransparencyEnd = 1, CFrame = from, Boomerang = 0, BoomerangSize = 25})
					local toward = mouse.Hit.Position + Vector3.new(math.random(-15, 15), math.random(-7, 7), math.random(-15, 15))
					local raycast = PhysicsRaycast(from.Position, (toward - from.Position) * 5)
					if raycast then
						toward = raycast.Position
					end
					from = CFrame.lookAt(from.Position, toward)
					local t, h = math.random(17, 31), math.random(9, 15)
					local s2 = os.clock()
					repeat
						local a = (os.clock() - s2) * 60
						death.Color = curcolor
						death.CFrame = from * CFrame.new(0, 200 * a * (t - a) / (t * t * h), -(toward - from.Position).Magnitude * (a / t))
						task.wait()
					until os.clock() - s2 > t / 60
					death.CFrame = from.Rotation + toward
					t = math.random(55, 65)
					s = os.clock()
					repeat
						death.Color = curcolor
						task.wait()
					until os.clock() - s2 > t / 60
					CreateSound(death, 168513088, 1.1)
					for _=1, 3 do
						Effect({Time = math.random(45, 65), EffectType = "Sphere", Size = Vector3.new(0.6, 6, 0.6) * math.random(-1.05, 1.25), SizeEnd = Vector3.new(1.6, 10, 1.6) * math.random(-1.05, 1.25), Transparency = 0, TransparencyEnd = 1, CFrame = death.CFrame * CFrame.Angles(math.rad(math.random(0, 360)), math.rad(math.random(0, 360)), math.rad(math.random(0, 360))), Boomerang = 20, BoomerangSize = 35})
					end
					task.wait(0.1)
					death.Transparency = 1
					if rootu:IsDescendantOf(workspace) then Attack(toward, 10) end
					task.wait(3)
					death:Destroy()
				end)
				task.wait()
				if not rootu:IsDescendantOf(workspace) then return end
			end
			animationOverride = nil
			task.wait()
			if not rootu:IsDescendantOf(workspace) then return end
			attacking = false
			hum.WalkSpeed = 50 * scale
		end)
	end
	local function LightningRain()
		if not m.IgnoreDancing then
			if isdancing then return end
			if currentmode == 1 then
				if sanitysongsync < 8 then return end
			end
			if currentmode == 2 then return end
		end
		if attacking then return end
		if not root or not hum then return end
		local rootu = root
		attacking = true
		hum.WalkSpeed = 16 * scale
		local mouse = Player:GetMouse()
		task.spawn(function()
			for _=1,3 do
				task.wait(0.2)
				CreateSound(199145095)
			end
		end)
		task.spawn(function()
			animationOverride = function(timingsine, rt, nt, rst, lst, rht, lht, gunoff)
				rt = ROOTC0 * CFrame.Angles(0, 0, math.rad(-10))
				nt = NECKC0 * CFrame.Angles(math.rad(25), 0, math.rad(-20))
				rst = CFrame.new(1.5, 0.5, 0) * CFrame.Angles(math.rad(35), math.rad(-35), math.rad(20)) * RIGHTSHOULDERC0
				lst = CFrame.new(-1.5, 0.5, 0) * CFrame.Angles(math.rad(-20), math.rad(-5), math.rad(-10)) * LEFTSHOULDERC0
				gunoff = CFrame.new(0.05, -1, -0.15) * CFrame.Angles(math.rad((os.clock() * 120 * 22) % 360), 0, 0)
				return rt, nt, rst, lst, rht, lht, gunoff
			end
			task.wait(0.5)
			if not rootu:IsDescendantOf(workspace) then return end
			animationOverride = function(timingsine, rt, nt, rst, lst, rht, lht, gunoff)
				rt = ROOTC0 * CFrame.Angles(0, 0, math.rad(-10))
				nt = NECKC0 * CFrame.Angles(math.rad(25), 0, math.rad(-20))
				rst = CFrame.new(1.5, 0.5, 0) * CFrame.Angles(math.rad(175), math.rad(-10), math.rad(10)) * RIGHTSHOULDERC0
				lst = CFrame.new(-1.5, 0.5, 0) * CFrame.Angles(math.rad(-10), math.rad(-10), math.rad(-5)) * LEFTSHOULDERC0
				return rt, nt, rst, lst, rht, lht, gunoff
			end
			task.wait(0.1)
			if not rootu:IsDescendantOf(workspace) then return end
			local hole = root.CFrame * CFrame.new(Vector3.new(1, 4, -1) * scale)
			local sky = root.CFrame * Vector3.new(0, 300, -50)
			EffectCannon(hole.Position, sky)
			animationOverride = function(timingsine, rt, nt, rst, lst, rht, lht, gunoff)
				rt = ROOTC0 * CFrame.Angles(0, 0, math.rad(-10))
				nt = NECKC0 * CFrame.Angles(math.rad(25), 0, math.rad(-20))
				rst = CFrame.new(1.5, 0.5, 0) * CFrame.Angles(math.rad(225), math.rad(-20), math.rad(20)) * RIGHTSHOULDERC0
				lst = CFrame.new(-1.5, 0.5, 0) * CFrame.Angles(math.rad(-5), math.rad(-5), 0) * LEFTSHOULDERC0
				return rt, nt, rst, lst, rht, lht, gunoff
			end
			task.wait(0.3)
			if not rootu:IsDescendantOf(workspace) then return end
			local target = mouse.Hit.Position
			animationOverride = nil
			hum.WalkSpeed = 50 * scale
			attacking = false
			if math.random(2) == 1 then
				randomdialog({
					"Then the sky STRIKES.",
					"LIGHTNING CAN STRIKE THE SAME PLACE THRICE",
					"SKY, BLAST THESE INSECTS",
					"THE WEATHER IS WIERD TODAY.",
					"Immortality Lord could NEVER do this!",
					"This will be PAINLESS",
				}, true)
			end
			task.wait(0.5)
			for _=1, m.RainAmount do
				local hit = target + Vector3.new(math.random(-18, 18), 0, math.random(-18, 18))
				EffectCannon(sky, hit, false)
				Attack(hit, 12)
				task.wait(1.25 / m.RainAmount)
			end
		end)
	end
	local SingularityBeam_ischarging = false
	local function SingularityBeam()
		if SingularityBeam_ischarging then
			SingularityBeam_ischarging = false
			return
		end
		if not m.IgnoreDancing then
			if isdancing then return end
			if currentmode == 1 then
				if sanitysongsync < 8 then return end
			end
			if currentmode == 2 then return end
		end
		if attacking then return end
		if not root or not hum then return end
		local rootu = root
		attacking = true
		hum.WalkSpeed = 0
		local mouse = Player:GetMouse()
		task.spawn(function()
			animationOverride = function(timingsine, rt, nt, rst, lst, rht, lht, gunoff)
				rt *= CFrame.Angles(0, 0, math.rad(-60))
				nt = NECKC0 * CFrame.Angles(0, 0, math.rad(60))
				rst = CFrame.new(1.25, 0.5, -0.25) * CFrame.Angles(math.rad(90), 0, math.rad(-60)) * RIGHTSHOULDERC0
				lst = CFrame.new(-1.25, 0.5, -0.25) * CFrame.Angles(math.rad(95), 0, math.rad(10)) * LEFTSHOULDERC0
				gunoff = CFrame.new(0, -0.5, 0) * CFrame.Angles(math.rad(180), 0, 0)
				AimTowards(mouse.Hit.Position)
				return rt, nt, rst, lst, rht, lht, gunoff
			end
			SingularityBeam_ischarging = true
			local kamehameha = math.random(10) == 1
			if kamehameha then
				notify("Kame.....hame.....", true)
			elseif math.random(2) == 1 then
				randomdialog({
					"Watch out...",
					"YOU are DONE for...",
					"DEATH IS INESCAPABLE...",
					"Loading death... 21%",
					"Loading death... 48%",
					"Loading death... 67%",
					"Loading death... 97%",
				}, true)
			end
			local core = Instance.new("Part")
			core.Massless = true
			core.Transparency = 0
			core.Anchored = true
			core.CanCollide = false
			core.CanTouch = false
			core.CanQuery = false
			core.Name = RandomString()
			core.Size = Vector3.one * 0.5
			core.Shape = Enum.PartType.Ball
			core.Color = Color3.new(1, 1, 1)
			core.Material = Enum.Material.Neon
			core.Parent = workspace
			CreateSound(core, 342793847, 1)
			local s = os.clock()
			repeat
				core.CFrame = root.CFrame * CFrame.new(Vector3.new(0, 0.25, -3) * scale)
				core.Size = Vector3.one * 2.5 * (os.clock() - s) / m.BeamCharge
				task.wait()
			until os.clock() - s > m.BeamCharge or not SingularityBeam_ischarging or not rootu:IsDescendantOf(workspace)
			if not rootu:IsDescendantOf(workspace) then
				SingularityBeam_ischarging = false
				core:Destroy()
				return
			end
			if not SingularityBeam_ischarging then
				CreateSound(3264923, 1)
				core:Destroy()
				animationOverride = nil
				hum.WalkSpeed = 50 * scale
				attacking = false
				return
			end
			SingularityBeam_ischarging = false
			if kamehameha then
				notify("HAAAAAAAAAAAAAAAA", true)
			elseif math.random(2) == 1 then
				randomdialog({
					"LIGHTNING CANNON BLAST",
					"NOW YOU are DONE for...",
					"YOU CANNOT ESCAPE THIS.",
					"Loading death... 100%",
					"BLAMOOO",
					"KABOOM",
					"*impressive impression of the blast sound*",
				}, true)
			end
			local beam = Instance.new("Part")
			beam.Massless = true
			beam.Transparency = 0
			beam.Anchored = true
			beam.CanCollide = false
			beam.CanTouch = false
			beam.CanQuery = false
			beam.Name = RandomString()
			beam.Shape = Enum.PartType.Cylinder
			beam.Color = Color3.new(1, 1, 1)
			beam.Material = Enum.Material.Neon
			beam.Parent = workspace
			task.spawn(function()
				CreateSound(beam, 138677306, 1)
				CreateSound(415700134, 1)
				if m.BeamDuration > 0.5 then task.wait(m.BeamDuration - 0.5) end
				CreateSound(3264923, 1)
			end)
			s = os.clock()
			local throt = 0
			local dt = 0
			repeat
				local hole = root.CFrame * CFrame.new(Vector3.new(0, 0.25, -3) * scale)
				root.CFrame *= CFrame.new(0, 0, dt * 6 * scale)
				core.CFrame = hole
				core.Size = Vector3.one * 2.5
				local target = mouse.Hit.Position
				local raycast = PhysicsRaycast(hole.Position, target - hole.Position)
				if raycast then
					target = raycast.Position
				end
				local dist = (target - hole.Position).Magnitude
				beam.Size = Vector3.new(dist, 2.5, 2.5)
				beam.CFrame = CFrame.lookAt(hole.Position:Lerp(target, 0.5), target) * CFrame.Angles(0, math.rad(90), 0)
				if throt > 0.02 then
					Lightning({Start = hole.Position, Finish = target, Offset = 3.5, Time = 25, SizeStart = 0, SizeEnd = 1, BoomerangSize = 55})
					Effect({Time = 10, EffectType = "Box", Size = Vector3.new(0, 0, 0), SizeEnd = Vector3.new(3, 3, 3), Transparency = 0, TransparencyEnd = 1, CFrame = CFrame.new(target), RotationX = math.random(-1, 1), RotationY = math.random(-1, 1), RotationZ = math.random(-1, 1), Boomerang = 0, BoomerangSize = 50})
					Effect({Time = 10, EffectType = "Box", Size = Vector3.new(0, 0, 0), SizeEnd = Vector3.new(3, 3, 3), Transparency = 0, TransparencyEnd = 1, CFrame = CFrame.new(target), RotationX = math.random(-1, 1), RotationY = math.random(-1, 1), RotationZ = math.random(-1, 1), Color = Color3.new(1, 1, 1), Boomerang = 0, BoomerangSize = 50})
					Effect({Time = 10, EffectType = "Slash", Size = Vector3.new(0, 0, 0), SizeEnd = Vector3.new(0.1, 0, 0.1), Transparency = 0, TransparencyEnd = 1, CFrame = hole * CFrame.Angles(math.rad(math.random(0, 360)), math.rad(math.random(0, 360)), math.rad(math.random(0, 360))), RotationX = math.random(-1, 1), RotationY = math.random(-1, 1), RotationZ = math.random(-1, 1), Boomerang = 0, BoomerangSize = 15})
					Effect({Time = 10, EffectType = "Slash", Size = Vector3.new(0, 0, 0), SizeEnd = Vector3.new(0.1, 0, 0.1), Transparency = 0, TransparencyEnd = 1, CFrame = hole * CFrame.Angles(math.rad(math.random(0, 360)), math.rad(math.random(0, 360)), math.rad(math.random(0, 360))), RotationX = math.random(-1, 1), RotationY = math.random(-1, 1), RotationZ = math.random(-1, 1), Color = Color3.new(1, 1, 1), Boomerang = 0, BoomerangSize = 15})
					Effect({Time = 10, EffectType = "Slash", Size = Vector3.new(0, 0, 0), SizeEnd = Vector3.new(0.1, 0, 0.1), Transparency = 0, TransparencyEnd = 1, CFrame = CFrame.new(target) * CFrame.Angles(math.rad(math.random(0, 360)), math.rad(math.random(0, 360)), math.rad(math.random(0, 360))), RotationX = math.random(-1, 1), RotationY = math.random(-1, 1), RotationZ = math.random(-1, 1), Boomerang = 0, BoomerangSize = 15})
					Effect({Time = 10, EffectType = "Slash", Size = Vector3.new(0, 0, 0), SizeEnd = Vector3.new(0.1, 0, 0.1), Transparency = 0, TransparencyEnd = 1, CFrame = CFrame.new(target) * CFrame.Angles(math.rad(math.random(0, 360)), math.rad(math.random(0, 360)), math.rad(math.random(0, 360))), RotationX = math.random(-1, 1), RotationY = math.random(-1, 1), RotationZ = math.random(-1, 1), Color = Color3.new(1, 1, 1), Boomerang = 0, BoomerangSize = 15})
					local lod = 5
					if dist < lod * 10 then
						for i=0, (dist // 10) + 1 do
							Attack(hole.Position:Lerp(target, (5 + i * 10) / dist), 5)
						end
					else
						for i=1, lod do
							Attack(hole.Position:Lerp(target, (i - 0.5) / lod), 5)
						end
					end
					Attack(target, 10)
					throt = 0
				end
				dt = task.wait()
				throt += dt
			until os.clock() - s > m.BeamDuration or not rootu:IsDescendantOf(workspace)
			core:Destroy()
			beam:Destroy()
			if not rootu:IsDescendantOf(workspace) then
				return
			end
			animationOverride = nil
			hum.WalkSpeed = 50 * scale
			attacking = false
		end)
	end

	local joints = {
		r = CFrame.identity,
		n = CFrame.identity,
		rs = CFrame.identity,
		ls = CFrame.identity,
		rh = CFrame.identity,
		lh = CFrame.identity,
		sw = CFrame.identity,
	}
	local leftwing = {}
	local rightwing = {}
	local gun = {}
	local flyv, flyg = nil, nil
	local walkingwheel = nil
	local chatconn = nil
	local uisbegin, uisend = nil, nil
	local dancereact = {}
	m.Init = function(figure: Model)
		start = os.clock()
		flight = false
		attacking = false
		animationOverride = nil
		currentmode = 0
		figure.Humanoid.WalkSpeed = 50 * figure:GetScale()
		SetOverrideMovesetMusic(AssetGetContentId("LightningCannonTheme.mp3"), "Lost Connection (LC's Theme)", 1)
		leftwing = {
			Group = "LeftWing",
			Limb = "Torso", Offset = CFrame.new(-0.15, 0, 0)
		}
		rightwing = {
			Group = "RightWing",
			Limb = "Torso", Offset = CFrame.new(0.15, 0, 0)
		}
		gun = {
			Group = "Gun",
			Limb = "Right Arm",
			Offset = CFrame.identity
		}
		table.insert(HatReanimator.HatCFrameOverride, leftwing)
		table.insert(HatReanimator.HatCFrameOverride, rightwing)
		table.insert(HatReanimator.HatCFrameOverride, gun)
		flyv = Instance.new("BodyVelocity")
		flyv.Name = "FlightBodyMover"
		flyv.P = 90000
		flyv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
		flyv.Parent = nil
		flyg = Instance.new("BodyGyro")
		flyg.Name = "FlightBodyMover"
		flyg.P = 3000
		flyg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
		flyg.Parent = nil
		walkingwheel = Instance.new("Model")
		walkingwheel.Name = "WalkingWheel"
		for i=1, 36 do
			local v = Instance.new("Part")
			v.Name = tostring(15 + 10 * i)
			v.Size = Vector3.new(2, 0.2, 0.56)
			v.Massless = true
			v.Material = Enum.Material.Neon
			v.Anchored = true
			v.CanCollide = false
			v.CanQuery = false
			v.CanTouch = false
			v.Color = Color3.new()
			v.Parent = walkingwheel
		end
		walkingwheel.Parent = figure
		hum = figure:FindFirstChild("Humanoid")
		root = figure:FindFirstChild("HumanoidRootPart")
		torso = figure:FindFirstChild("Torso")
		ContextActionService:BindAction("Uhhhhhh_LCFlight", function(_, state, _)
			if state == Enum.UserInputState.Begin then
				flight = not flight
				if math.random(4) == 1 then
					if flight then
						if math.random(4) == 1 then
							notify(Player.Name .. " just tried to tamper with my remotes.")
						elseif math.random(3) == 1 then
							notify("my FLYING ANIMATION is NOT JUST for SHOW", true)
						elseif math.random(2) == 1 then
							notify("im a birb")
							task.delay(1.7, notify, "GOVERNMENT DRONE", true)
						else
							notify("PATHETIC PEASANTS.", true)
						end
					else
						if math.random(2) == 1 then
							task.delay(1, notify, "sometimes i wonder why i stay near ground")
							task.delay(5, notify, "I AM A GOD AFTER ALL", true)
						else
							notify("watch me not crash on the ground as i descend")
						end
					end
				end
			end
		end, true, Enum.KeyCode.F)
		ContextActionService:SetTitle("Uhhhhhh_LCFlight", "F")
		ContextActionService:SetPosition("Uhhhhhh_LCFlight", UDim2.new(1, -130, 1, -130))
		ContextActionService:BindAction("Uhhhhhh_LCDash", function(_, state, _)
			if state == Enum.UserInputState.Begin then
				Dash()
			end
		end, true, Enum.KeyCode.Z)
		ContextActionService:SetTitle("Uhhhhhh_LCDash", "Z")
		ContextActionService:SetPosition("Uhhhhhh_LCDash", UDim2.new(1, -180, 1, -130))
		ContextActionService:BindAction("Uhhhhhh_LCBigbeam", function(_, state, _)
			if state == Enum.UserInputState.Begin then
				SingularityBeam()
			end
		end, true, Enum.KeyCode.X)
		ContextActionService:SetTitle("Uhhhhhh_LCBigbeam", "X")
		ContextActionService:SetPosition("Uhhhhhh_LCBigbeam", UDim2.new(1, -230, 1, -130))
		ContextActionService:BindAction("Uhhhhhh_LCRaining", function(_, state, _)
			if state == Enum.UserInputState.Begin then
				LightningRain()
			end
		end, true, Enum.KeyCode.C)
		ContextActionService:SetTitle("Uhhhhhh_LCRaining", "C")
		ContextActionService:SetPosition("Uhhhhhh_LCRaining", UDim2.new(1, -280, 1, -130))
		ContextActionService:BindAction("Uhhhhhh_LCGranada", function(_, state, _)
			if state == Enum.UserInputState.Begin then
				Granada()
			end
		end, true, Enum.KeyCode.V)
		ContextActionService:SetTitle("Uhhhhhh_LCGranada", "V")
		ContextActionService:SetPosition("Uhhhhhh_LCGranada", UDim2.new(1, -180, 1, -180))
		ContextActionService:BindAction("Uhhhhhh_LCKaboom", function(_, state, _)
			if state == Enum.UserInputState.Begin then
				KaBoom()
			end
		end, true, Enum.KeyCode.B)
		ContextActionService:SetTitle("Uhhhhhh_LCKaboom", "B")
		ContextActionService:SetPosition("Uhhhhhh_LCKaboom", UDim2.new(1, -230, 1, -180))
		ContextActionService:BindAction("Uhhhhhh_LCMusic", function(_, state, _)
			if state == Enum.UserInputState.Begin then
				currentmode = (currentmode + 1) % 3
				if currentmode == 0 then
					SetOverrideMovesetMusic(AssetGetContentId("LightningCannonTheme.mp3"), "Lost Connection (LC's Theme)", 1)
				end
				if currentmode == 1 then
					sanitysongsync = -1
					SetOverrideMovesetMusic(AssetGetContentId("LightningCannonPower.mp3"), "Ka1zer - INSaNiTY", 1, NumberRange.new(22.214, 112.826))
					if m.SkipSanity then
						sanitysongsync = 8
					end
				end
				if currentmode == 2 then
					notify("I am fast as frick, boii")
					fastboistart = os.clock()
					fastboisegment = false
					SetOverrideMovesetMusic(AssetGetContentId("LightningCannonFastBoi.mp3"), "RUNNING IN THE '90s", 1, NumberRange.new(0, 24.226))
				end
			end
		end, true, Enum.KeyCode.M)
		ContextActionService:SetTitle("Uhhhhhh_LCMusic", "M")
		ContextActionService:SetPosition("Uhhhhhh_LCMusic", UDim2.new(1, -130, 1, -180))
		if uisbegin then
			uisbegin:Disconnect()
		end
		if uisend then
			uisend:Disconnect()
		end
		local clickpos = nil
		local clicktime = 0
		uisbegin = UserInputService.InputBegan:Connect(function(input, gpe)
			if gpe then return end
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				clickpos = input.Position
				clicktime = os.clock()
			end
		end)
		uisend = UserInputService.InputEnded:Connect(function(input, gpe)
			if gpe then return end
			if not clickpos then return end
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				if (input.Position - clickpos).Magnitude < 5 then
					if os.clock() - clicktime < 0.5 then
						AttackOne()
					end
				end
			end
		end)
		if math.random(3) == 1 then
			task.delay(0, notify, "Lightning Cannon, by LuaQuack")
		elseif math.random(2) == 1 then
			task.delay(0, notify, "Lightning Cannon, by myworld")
		else
			task.delay(0, notify, "Lightning Cannon, by STEVE")
		end
		task.delay(1, randomdialog, {
			"Immortality Lord did not have to say that...",
			"That intro sucked.",
			"I THINK THIS MERE MORTAL KNOWS WHO I AM",
			"Blah, blah, blah, blah, BLAHH!!",
			"Die... Die... DIE!!!",
			"Now, WHERE IS THE MELEE USER",
			"It's been years since the good times for me",
			"WHO ARE WE GOING TO BLAST TO STARDUST TODAY?",
			"Ready or not, MY LIGHTNING CANNON IS READY",
			"LETS BLAST SOMEONE WITH INFINITE VOLTS",
			"YOU are such an IDIOT. YOU CANNOT KILL ME, A GOD",
		}, true)
		if chatconn then
			chatconn:Disconnect()
		end
		chatconn = OnPlayerChatted.Event:Connect(function(plr, msg)
			if plr == Player then
				notify(msg)
			end
		end)
		rcp.FilterDescendantsInstances = {figure}
	end
	m.Update = function(dt: number, figure: Model)
		local t = os.clock() - start
		scale = figure:GetScale()
		curcolor = Color3.fromHSV(os.clock() % 1, 1, 1)
		isdancing = not not figure:GetAttribute("IsDancing")
		
		-- get vii
		hum = figure:FindFirstChild("Humanoid")
		root = figure:FindFirstChild("HumanoidRootPart")
		torso = figure:FindFirstChild("Torso")
		if not hum then return end
		if not root then return end
		if not torso then return end
		
		-- fly
		if flight then
			hum.PlatformStand = true
			flyv.Parent = root
			flyg.Parent = root
			local camcf = CFrame.identity
			if workspace.CurrentCamera then
				camcf = workspace.CurrentCamera.CFrame
			end
			local _,angle,_ = camcf:ToEulerAngles(Enum.RotationOrder.YXZ)
			local movedir = CFrame.Angles(0, angle, 0):VectorToObjectSpace(hum.MoveDirection)
			flyv.Velocity = camcf:VectorToWorldSpace(movedir) * hum.WalkSpeed * m.FlySpeed
			flyg.CFrame = camcf.Rotation
		else
			hum.PlatformStand = false
			flyv.Parent = nil
			flyg.Parent = nil
		end
		
		-- jump fly
		if hum.Jump then
			hum:ChangeState(Enum.HumanoidStateType.Jumping)
		end
		
		-- float if not dancing
		if isdancing then
			hum.HipHeight = 0
		else
			-- and be fast if not attacking
			if attacking then
				hum.HipHeight = 3
			else
				hum.WalkSpeed = 50 * figure:GetScale()
				-- mode 3 is not floating
				if currentmode == 2 then
					hum.HipHeight = 0
				else
					hum.HipHeight = 3
				end
			end
		end
		
		-- joints
		local rt, nt, rst, lst, rht, lht = CFrame.identity, CFrame.identity, CFrame.identity, CFrame.identity, CFrame.identity, CFrame.identity
		local gunoff = CFrame.identity
		
		local timingsine = t * 60 -- timing from original
		local onground = hum:GetState() == Enum.HumanoidStateType.Running
		
		-- animations
		local sin50 = math.sin(timingsine / 50)
		local cos50 = math.cos(timingsine / 50)
		gunoff = CFrame.new(0.05, -1, -0.15) * CFrame.Angles(math.rad(180), 0, 0)
		if root.Velocity.Magnitude < 8 * scale then
			rt = ROOTC0 * CFrame.new(0.5 * cos50, 0, 10 * math.clamp(math.pow(1 - t, 3), 0, 1) - 0.5 * sin50)
			nt = NECKC0 * CFrame.Angles(math.rad(20), 0, 0)
			rst = CFrame.new(1.5, 0.5, 0) * CFrame.Angles(math.rad(135 + 8.5 * cos50), 0, math.rad(25)) * RIGHTSHOULDERC0
			lst = CFrame.new(-1.5, 0.5, 0) * CFrame.Angles(math.rad(25 + 8.5 * cos50), 0, math.rad(-25 - 5 * math.cos(timingsine / 25))) * LEFTSHOULDERC0
			rht = CFrame.new(1, -0.5, -0.5) * CFrame.Angles(math.rad(-15 + 9 * math.cos(timingsine / 74)), math.rad(80), 0) * CFrame.Angles(math.rad(5 * math.cos(timingsine / 37)), 0, 0)
			lht = CFrame.new(-1, -1, 0) * CFrame.Angles(math.rad(-15 - 9 * math.cos(timingsine / 54)), math.rad(-80), 0) * CFrame.Angles(math.rad(5 * math.cos(timingsine / 41)), 0, 0)
		else
			rt = ROOTC0 * CFrame.new(0.5 * cos50, 0, 10 * math.clamp(math.pow(1 - t, 3), 0, 1) - 0.5 * sin50) * CFrame.Angles(math.rad(40), 0, 0)
			nt = NECKC0 * CFrame.new(0, -0.25, 0) * CFrame.Angles(math.rad(-40), 0, 0)
			rst = CFrame.new(1.5, 0.5, 0) * CFrame.Angles(math.rad(-45), 0, math.rad(5 + 2 * math.cos(timingsine / 19))) * RIGHTSHOULDERC0
			lst = CFrame.new(-1.5, 0.5, 0) * CFrame.Angles(math.rad(-45), 0, math.rad(-5 - 2 * math.cos(timingsine / 19))) * LEFTSHOULDERC0
			rht = CFrame.new(1, -0.5, -0.5) * CFrame.Angles(math.rad(-15 + 9 * math.cos(timingsine / 74)), math.rad(80), 0) * CFrame.Angles(math.rad(5 * math.cos(timingsine / 37)), 0, 0)
			lht = CFrame.new(-1, -1, 0) * CFrame.Angles(math.rad(-15 - 9 * math.cos(timingsine / 54)), math.rad(-80), 0) * CFrame.Angles(math.rad(5 * math.cos(timingsine / 41)), 0, 0)
		end
		if currentmode == 1 then
			local sync = math.floor(GetOverrideMovesetMusicTime() / 2.795)
			if sanitysongsync < sync then
				sanitysongsync = sync
				if sanitysongsync == 0 then
					notify("sAnIty", true)
				elseif sanitysongsync == 1 then
					notify("Light is peeking through the darkness")
				elseif sanitysongsync == 2 then
					notify("pUrIty", true)
				elseif sanitysongsync == 3 then
					notify("Can't feel anymore of the stress")
				elseif sanitysongsync == 4 then
					notify("sAnIty", true)
				elseif sanitysongsync == 5 then
					notify("It's already fading away")
				elseif sanitysongsync == 6 then
					notify("crUElty", true)
				elseif sanitysongsync == 7 then
					notify("Instincts controlling me")
				elseif sanitysongsync == 8 then
					task.delay(1, randomdialog, {
						"Immortality Lord can't sing.",
						"Take that, Immortality Lord!",
						"DEATH IS INESCAPABLE.",
						"And my instincts, is to be A GOD",
						"INSaNiTY- oh wrong timing... nevermind.",
						"I know you love these effects, " .. Player.Name,
						"Why would Roblox remove this audio...",
						"Now...",
					})
					local function sphere(bonuspeed,type,pos,scale,value,color)
						local type = type
						local rng = Instance.new("Part",workspace)
						rng.Anchored = true
						rng.BrickColor = color
						rng.CanCollide = false
						rng.FormFactor = 3
						rng.Name = RandomString()
						rng.Material = "Neon"
						rng.Size = Vector3.new(1,1,1)
						rng.Transparency = 0
						rng.TopSurface = 0
						rng.BottomSurface = 0
						rng.CFrame = pos
						local rngm = Instance.new("SpecialMesh",rng)
						rngm.MeshType = "Sphere"
						rngm.Scale = scale
						local scaler2 = 1
						if type == "Add" then
							scaler2 = 1*value
						elseif type == "Divide" then
							scaler2 = 1/value
						end
						task.spawn(function()
							for i = 0,10/bonuspeed,0.1 do
								task.wait()
								if type == "Add" then
									scaler2 = scaler2 - 0.01*value/bonuspeed
								elseif type == "Divide" then
									scaler2 = scaler2 - 0.01/value*bonuspeed
								end
								rng.BrickColor = BrickColor.random()
								rng.Transparency = rng.Transparency + 0.01*bonuspeed
								rngm.Scale = rngm.Scale + Vector3.new(scaler2*bonuspeed,scaler2*bonuspeed,scaler2*bonuspeed)
							end
							rng:Destroy()
						end)
					end
					local function sphere2(bonuspeed,type,pos,scale,value,value2,value3,color)
						local type = type
						local rng = Instance.new("Part",workspace)
						rng.Anchored = true
						rng.BrickColor = color
						rng.CanCollide = false
						rng.FormFactor = 3
						rng.Name = RandomString()
						rng.Material = "Neon"
						rng.Size = Vector3.new(1,1,1)
						rng.Transparency = 0
						rng.TopSurface = 0
						rng.BottomSurface = 0
						rng.CFrame = pos
						local rngm = Instance.new("SpecialMesh",rng)
						rngm.MeshType = "Sphere"
						rngm.Scale = scale
						local scaler2 = 1
						local scaler2b = 1
						local scaler2c = 1
						if type == "Add" then
							scaler2 = 1*value
							scaler2b = 1*value2
							scaler2c = 1*value3
						elseif type == "Divide" then
							scaler2 = 1/value
							scaler2b = 1/value2
							scaler2c = 1/value3
						end
						task.spawn(function()
							for i = 0,10/bonuspeed,0.1 do
								task.wait()
								if type == "Add" then
									scaler2 = scaler2 - 0.01*value/bonuspeed
									scaler2b = scaler2b - 0.01*value/bonuspeed
									scaler2c = scaler2c - 0.01*value/bonuspeed
								elseif type == "Divide" then
									scaler2 = scaler2 - 0.01/value*bonuspeed
									scaler2b = scaler2b - 0.01/value*bonuspeed
									scaler2c = scaler2c - 0.01/value*bonuspeed
								end
								rng.Transparency = rng.Transparency + 0.01*bonuspeed
								rngm.Scale = rngm.Scale + Vector3.new(scaler2*bonuspeed,scaler2b*bonuspeed,scaler2c*bonuspeed)
							end
							rng:Destroy()
						end)
					end
					local function PixelBlockX(bonuspeed,FastSpeed,type,pos,x1,y1,z1,value,color,outerpos)
						local type = type
						local rng = Instance.new("Part",workspace)
						rng.Anchored = true
						rng.BrickColor = color
						rng.CanCollide = false
						rng.FormFactor = 3
						rng.Name = RandomString()
						rng.Material = "Neon"
						rng.Size = Vector3.new(1,1,1)
						rng.Transparency = 0
						rng.TopSurface = 0
						rng.BottomSurface = 0
						rng.CFrame = pos
						rng.CFrame = rng.CFrame + rng.CFrame.lookVector*outerpos
						local rngm = Instance.new("SpecialMesh",rng)
						rngm.MeshType = "Brick"
						rngm.Scale = Vector3.new(x1,y1,z1)
						local scaler2 = 1
						local speeder = FastSpeed/10
						if type == "Add" then
							scaler2 = 1*value
						elseif type == "Divide" then
							scaler2 = 1/value
						end
						task.spawn(function()
							for i = 0,10/bonuspeed,0.1 do
								task.wait()
								if type == "Add" then
									scaler2 = scaler2 - 0.01*value/bonuspeed
								elseif type == "Divide" then
									scaler2 = scaler2 - 0.01/value*bonuspeed
								end
								rng.BrickColor = BrickColor.random()
								speeder = speeder - 0.01*FastSpeed*bonuspeed/10
								rng.CFrame = rng.CFrame + rng.CFrame.lookVector*speeder*bonuspeed
								rng.Transparency = rng.Transparency + 0.01*bonuspeed
								rngm.Scale = rngm.Scale - Vector3.new(scaler2*bonuspeed,scaler2*bonuspeed,scaler2*bonuspeed)
							end
							rng:Destroy()
						end)
					end
					local function sphereMK(bonuspeed,FastSpeed,type,pos,x1,y1,z1,value,color,outerpos)
						local type = type
						local rng = Instance.new("Part",workspace)
						rng.Anchored = true
						rng.BrickColor = color
						rng.CanCollide = false
						rng.FormFactor = 3
						rng.Name = RandomString()
						rng.Material = "Neon"
						rng.Size = Vector3.new(1,1,1)
						rng.Transparency = 0
						rng.TopSurface = 0
						rng.BottomSurface = 0
						rng.CFrame = pos
						rng.CFrame = rng.CFrame + rng.CFrame.lookVector*outerpos
						local rngm = Instance.new("SpecialMesh",rng)
						rngm.MeshType = "Sphere"
						rngm.Scale = Vector3.new(x1,y1,z1)
						local scaler2 = 1
						local speeder = FastSpeed
						if type == "Add" then
							scaler2 = 1*value
						elseif type == "Divide" then
							scaler2 = 1/value
						end
						task.spawn(function()
							for i = 0,10/bonuspeed,0.1 do
								task.wait()
								if type == "Add" then
									scaler2 = scaler2 - 0.01*value/bonuspeed
								elseif type == "Divide" then
									scaler2 = scaler2 - 0.01/value*bonuspeed
								end
								rng.BrickColor = BrickColor.random()
								speeder = speeder - 0.01*FastSpeed*bonuspeed
								rng.CFrame = rng.CFrame + rng.CFrame.lookVector*speeder*bonuspeed
								rng.Transparency = rng.Transparency + 0.01*bonuspeed
								rngm.Scale = rngm.Scale + Vector3.new(scaler2*bonuspeed,scaler2*bonuspeed,0)
							end
							rng:Destroy()
						end)
					end
					local function slash(bonuspeed,rotspeed,rotatingop,typeofshape,type,typeoftrans,pos,scale,value,color)
						local type = type
						local rotenable = rotatingop
						local rng = Instance.new("Part",workspace)
						rng.Anchored = true
						rng.BrickColor = color
						rng.CanCollide = false
						rng.FormFactor = 3
						rng.Name = RandomString()
						rng.Material = "Neon"
						rng.Size = Vector3.new(1,1,1)
						rng.Transparency = 0
						if typeoftrans == "In" then
							rng.Transparency = 1
						end
						rng.TopSurface = 0
						rng.BottomSurface = 0
						rng.CFrame = pos
						local rngm = Instance.new("SpecialMesh",rng)
						rngm.MeshType = "FileMesh"
						if typeofshape == "Normal" then
							rngm.MeshId = "rbxassetid://662586858"
						elseif typeofshape == "Round" then
							rngm.MeshId = "rbxassetid://662585058"
						end
						rngm.Scale = scale
						local scaler2 = 1/10
						if type == "Add" then
							scaler2 = 1*value/10
						elseif type == "Divide" then
							scaler2 = 1/value/10
						end
						local randomrot = math.random(1,2)
						task.spawn(function()
							for i = 0,10/bonuspeed,0.1 do
								task.wait()
								if type == "Add" then
									scaler2 = scaler2 - 0.01*value/bonuspeed/10
								elseif type == "Divide" then
									scaler2 = scaler2 - 0.01/value*bonuspeed/10
								end
								if rotenable == true then
									if randomrot == 1 then
										rng.CFrame = rng.CFrame*CFrame.Angles(0,math.rad(rotspeed*bonuspeed/2),0)
									elseif randomrot == 2 then
										rng.CFrame = rng.CFrame*CFrame.Angles(0,math.rad(-rotspeed*bonuspeed/2),0)
									end
								end
								if typeoftrans == "Out" then
									rng.Transparency = rng.Transparency + 0.01*bonuspeed
								elseif typeoftrans == "In" then
									rng.Transparency = rng.Transparency - 0.01*bonuspeed
								end
								rngm.Scale = rngm.Scale + Vector3.new(scaler2*bonuspeed/10,0,scaler2*bonuspeed/10)
							end
							rng:Destroy()
						end)
					end
					sphere(1,"Add",torso.CFrame*CFrame.Angles(math.rad(math.random(-10,10)),math.rad(math.random(-10,10)),math.rad(math.random(-10,10))),Vector3.new(1,100000,1),0.6,BrickColor.new("Really black"))
					sphere2(math.random(1,4),"Add",torso.CFrame*CFrame.Angles(math.rad(math.random(-360,360)),math.rad(math.random(-360,360)),math.rad(math.random(-360,360))),Vector3.new(5,1,5),-0.005,math.random(25,100)/25,-0.005,BrickColor.new("Institutional white"))
					sphere(1,"Add",torso.CFrame,Vector3.new(1,1,1),0.8,BrickColor.new("Really black"))
					sphere2(2,"Add",torso.CFrame,Vector3.new(5,5,5),0.5,0.5,0.5,BrickColor.new("Institutional white"))
					sphere2(2,"Add",torso.CFrame,Vector3.new(5,5,5),0.75,0.75,0.75,BrickColor.new("Institutional white"))
					sphere2(3,"Add",torso.CFrame,Vector3.new(5,5,5),1,1,1,BrickColor.new("Institutional white"))
					sphere2(3,"Add",torso.CFrame,Vector3.new(5,5,5),1.25,1.25,1.25,BrickColor.new("Institutional white"))
					sphere2(1,"Add",torso.CFrame,Vector3.new(5,10000,5),0.5,0.5,0.5,BrickColor.new("Institutional white"))
					sphere2(2,"Add",torso.CFrame,Vector3.new(5,10000,5),0.6,0.6,0.6,BrickColor.new("Institutional white"))
					for i = 0,49 do
						PixelBlockX(1,math.random(1,20),"Add",torso.CFrame*CFrame.Angles(math.rad(math.random(-360,360)),math.rad(math.random(-360,360)),math.rad(math.random(-360,360))),8,8,8,0.16,BrickColor.new("Really black"),0)
						sphereMK(2.5,-1,"Add",torso.CFrame*CFrame.Angles(math.rad(math.random(-360,360)),math.rad(math.random(-360,360)),math.rad(math.random(-360,360))),2.5,2.5,25,-0.025,BrickColor.new("Really black"),0)
						slash(math.random(10,20)/10,5,true,"Round","Add","Out",torso.CFrame*CFrame.new(0,-3,0)*CFrame.Angles(math.rad(math.random(-30,30)),math.rad(math.random(-30,30)),math.rad(math.random(-40,40))),Vector3.new(0.05,0.01,0.05),math.random(50,60)/250,BrickColor.new("Really black"))
					end
					CreateSound(239000203)
					CreateSound(1042716828)
				end
			end
			if sanitysongsync >= 8 then
				curcolor = Color3.fromHSV(math.random(0, 19) / 20, 1, 1)
				rt = ROOTC0 * CFrame.new(0, 0, 0.5 * sin50) * CFrame.Angles(math.rad(20), 0, 0)
				rst = CFrame.new(1.5, 0.5, 0) * CFrame.Angles(math.rad(-41.6 - 4 * sin50), 0, 0) * RIGHTSHOULDERC0
				lst = CFrame.new(-1.5, 0.5, 0) * CFrame.Angles(math.rad(20), 0, math.rad(-10 - 10 * sin50)) * LEFTSHOULDERC0
				rht = CFrame.new(1, -1, -0.01) * CFrame.Angles(math.rad(10), math.rad(80), math.rad(10 + 10 * sin50))
				lht = CFrame.new(-1, -1, -0.01) * CFrame.Angles(math.rad(20), math.rad(-80), math.rad(-10 - 10 * sin50))
				if root.Velocity.Magnitude < 8 * scale then
					nt = NECKC0 * CFrame.Angles(math.rad(20), math.rad(10 * math.cos(timingsine / 100)), 0)
					if math.random(60) == 1 then
						nt = NECKC0 * CFrame.Angles(math.rad(20 + math.random(-20, 20)), math.rad(10 * math.cos(timingsine / 100) + math.random(-20, 20)), math.rad(math.random(-20, 20)))
						joints.n = nt
					end
				else
					nt = NECKC0
				end
			end
		end
		if currentmode == 2 then
			local dir = hum.MoveDirection * Vector3.new(1, 0, 1)
			if dir.Magnitude > 0 then
				dir = dir.Unit * 300
			end
			local segment = dir.Magnitude > 0
			if segment ~= fastboisegment then
				fastboisegment = segment
				if segment then
					SetOverrideMovesetMusic(AssetGetContentId("LightningCannonFastBoi.mp3"), "RUNNING IN THE '90s", 1, NumberRange.new(24.226, 36.333))
					SetOverrideMovesetMusicTime(24.226)
				else
					SetOverrideMovesetMusic(AssetGetContentId("LightningCannonFastBoi.mp3"), "RUNNING IN THE '90s", 1, NumberRange.new(0, 24.226))
					SetOverrideMovesetMusicTime((os.clock() - fastboistart) % 24.226)
				end
			end
			if segment then
				local sin2 = math.sin(timingsine / 2)
				rt = ROOTC0 * CFrame.new(0, 0, -0.2) * CFrame.Angles(math.rad(-45), 0, 0)
				nt = NECKC0 * CFrame.Angles(math.rad(-45), 0, 0)
				rst = CFrame.new(1.5, 0.5, 0) * CFrame.Angles(math.rad(-135), 0, 0) * RIGHTSHOULDERC0
				lst = CFrame.new(-1.5, 0.5, 0) * CFrame.Angles(math.rad(-135), 0, 0) * LEFTSHOULDERC0
				rht = CFrame.new(1, -1, -0.01) * CFrame.Angles(math.rad(75 * sin2), math.rad(90), 0)
				lht = CFrame.new(-1, -1, -0.01) * CFrame.Angles(math.rad(-75 * sin2), math.rad(-90), 0)
			else
				local sin5 = math.sin(timingsine / 5)
				rt = ROOTC0 * CFrame.new(0, 0, -0.2) * CFrame.Angles(math.rad(-timingsine * 6), 0, 0)
				nt = NECKC0
				rst = CFrame.new(1.5, 0.5, 0) * CFrame.Angles(math.rad(-75 * sin5), 0, 0) * RIGHTSHOULDERC0
				lst = CFrame.new(-1.5, 0.5, 0) * CFrame.Angles(math.rad(75 * sin5), 0, 0) * LEFTSHOULDERC0
				rht = CFrame.new(1, -1, -0.01) * CFrame.Angles(math.rad(75 * sin5), math.rad(90), 0)
				lht = CFrame.new(-1, -1, -0.01) * CFrame.Angles(math.rad(-75 * sin5), math.rad(-90), 0)
			end
			curcolor = Color3.new(0, 0, 0)
			if math.random(5) == 1 then
				curcolor = Color3.new(0, 0, math.random())
			end
			root.Velocity = Vector3.new(dir.X, root.Velocity.Y, dir.Z)
		end
		if animationOverride then
			rt, nt, rst, lst, rht, lht, gunoff = animationOverride(timingsine, rt, nt, rst, lst, rht, lht, gunoff)
		end
		for _,v in walkingwheel:GetChildren() do
			if v:IsA("BasePart") then
				local i = tonumber(v.Name)
				if i then
					if currentmode == 2 and not fastboisegment then
						v.CFrame = root.CFrame * CFrame.new(0, 0.01, 0) * CFrame.Angles(math.rad(i), 0, 0) * CFrame.new(0, 3.1, 0)
						v.Color = curcolor
						v.Transparency = 0
					else
						v.Transparency = 1
					end
				end
			end
		end
		
		-- joints
		local rj = root:FindFirstChild("RootJoint")
		local nj = torso:FindFirstChild("Neck")
		local rsj = torso:FindFirstChild("Right Shoulder")
		local lsj = torso:FindFirstChild("Left Shoulder")
		local rhj = torso:FindFirstChild("Right Hip")
		local lhj = torso:FindFirstChild("Left Hip")
		
		-- interpolation
		local alpha = math.exp(-18.6 * dt)
		joints.r = rt:Lerp(joints.r, alpha)
		joints.n = nt:Lerp(joints.n, alpha)
		joints.rs = rst:Lerp(joints.rs, alpha)
		joints.ls = lst:Lerp(joints.ls, alpha)
		joints.rh = rht:Lerp(joints.rh, alpha)
		joints.lh = lht:Lerp(joints.lh, alpha)
		joints.sw = gunoff:Lerp(joints.sw, alpha)
		
		-- apply transforms
		SetC0C1Joint(rj, joints.r, ROOTC0, scale)
		SetC0C1Joint(nj, joints.n, CFrame.new(0, -0.5, 0) * CFrame.Angles(math.rad(-90), 0, math.rad(180)), scale)
		SetC0C1Joint(rsj, joints.rs, CFrame.new(0.5, 0.5, 0, 0, 0, -1, 0, 1, 0, 1, 0, 0), scale)
		SetC0C1Joint(lsj, joints.ls, CFrame.new(-0.5, 0.5, 0, 0, 0, 1, 0, 1, 0, -1, 0, 0), scale)
		SetC0C1Joint(rhj, joints.rh, CFrame.new(0.5, 1, 0, 0, 0, 1, 0, 1, 0, -1, 0, 0), scale)
		SetC0C1Joint(lhj, joints.lh, CFrame.new(-0.5, 1, 0, 0, 0, -1, 0, 1, 0, 1, 0, 0), scale)
		
		-- wings
		if isdancing then
			leftwing.Offset = CFrame.new(-0.15, 0, 0) * CFrame.Angles(0, math.rad(-15), 0)
			rightwing.Offset = CFrame.new(0.15, 0, 0) * CFrame.Angles(0, math.rad(15), 0)
		else
			if m.Bee then
				leftwing.Offset = CFrame.new(-0.15, 0, 0) * CFrame.Angles(0, math.rad(-15 + 25 * math.cos(timingsine)), 0)
				rightwing.Offset = CFrame.new(0.15, 0, 0) * CFrame.Angles(0, math.rad(15 - 25 * math.cos(timingsine)), 0)
			else
				leftwing.Offset = CFrame.new(-0.15, 0, 0) * CFrame.Angles(0, math.rad(-15 + 25 * math.cos(timingsine / 25)), 0)
				rightwing.Offset = CFrame.new(0.15, 0, 0) * CFrame.Angles(0, math.rad(15 - 25 * math.cos(timingsine / 25)), 0)
			end
		end
		
		-- gun
		if m.UseSword then
			gun.Group = "Sword"
		else
			gun.Group = "Gun"
		end
		gun.Offset = joints.sw
		
		-- dance reactions
		if isdancing then
			local name = figure:GetAttribute("DanceInternalName")
			if name == "RAGDOLL" then
				dancereact.Ragdoll = dancereact.Ragdoll or 0
				if t - dancereact.Ragdoll > 1 then
					notify("ow my leg.")
				end
				dancereact.Ragdoll = t
			end
			if name == "SpeedAndKaiCenat" then
				if not dancereact.AlightMotion then
					task.delay(1, notify, "I have an idea, " .. Player.Name)
					task.delay(4, notify, "What if... Immortality Lord is the other guy?")
				end
				dancereact.AlightMotion = true
			end
		end
	end
	m.Destroy = function(figure: Model?)
		ContextActionService:UnbindAction("Uhhhhhh_LCFlight")
		ContextActionService:UnbindAction("Uhhhhhh_LCDash")
		ContextActionService:UnbindAction("Uhhhhhh_LCKaboom")
		ContextActionService:UnbindAction("Uhhhhhh_LCGranada")
		ContextActionService:UnbindAction("Uhhhhhh_LCRaining")
		ContextActionService:UnbindAction("Uhhhhhh_LCBigbeam")
		ContextActionService:UnbindAction("Uhhhhhh_LCMusic")
		flyv:Destroy()
		flyg:Destroy()
		walkingwheel:Destroy()
		if uisbegin then
			uisbegin:Disconnect()
			uisbegin = nil
		end
		if uisend then
			uisend:Disconnect()
			uisbegin = nil
		end
		if chatconn then
			chatconn:Disconnect()
			chatconn = nil
		end
		root, torso, hum = nil, nil, nil
	end
	return m
end)

return modules