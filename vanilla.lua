--[[

# Uhhhhhh documentation
Modules are just luau tables that are created by a function.
It does impose vulnerabilities, but who cares? Executors already
execute functions from user strings.

## Filesystem structure
Uhhhhhh's filesystem is like this
Executor's workspace/
| UhhhhhhReanim/
| | Assets/ - Contains UI Music
| | Modules/ - Should contain luau scripts that return a table of functions
| | Content/ - Contains module assets
| | | Anims/ - .anim (usually in STEVE's KeyframeSequence file format)
| | | Sounds/ - .mp3
| | | Images/ - .png
| | | Models/ - .rbxm
| | | Unknown/ - Ungrouped assets
| | tree.ehehetilde - All save data in JSON
| | .nomedia - Created for android users

## Modules
Modules are returned by a function from a luau script.
honestly idk how to document this in an understandable way so
heres an example, with code comments:
```lua
-- UhhhhhhReanim/Modules/lazy.lua

local modules = {} -- table to contain all modules

-- function called to create the module
-- this allows for local variables
table.insert(modules, function() -- put into modules table
	local m = {} -- module object
	
	-- can be "MOVESET" or "DANCE"
	m.ModuleType = "DANCE"
	
	-- name of module
	m.Name = "Lazy"
	
	-- description of module
	m.Description = "too lazy to even animate"
	
	-- internal name, used for movesets and dances to interact with each other
	-- best usage example of this is Immortality Lord + ragdoll
	-- this can be omitted
	m.InternalName = "DANCE_LAZY"
	
	-- table of assets to download, either in "filename" or "filename@url_to_source"
	m.Assets = {"Lazy.mp3@https://raw.githubusercontent.com/user/repo/main/69.mp3"}
	
	-- configuration GUI function, recommended to use these:
	-- Util_CreateText(parent, text, fontsize, alignment)
	-- Util_CreateButton(parent, text, fontsize)
	-- Util_CreateSwitch(parent, text, is_on)
	-- Util_CreateTextbox(parent, text, placeholdertext, fontsize)
	-- Util_CreateDropdown(parent, text, items, itemindex)
	-- Util_CreateCanvas(parent)
	-- Util_CreateScrollCanvas(parent, height)
	-- Util_CreateSeparator(parent)
	m.Config = function(parent: GuiBase2d)
		Util_CreateText(parent, "hi", 67, Enum.TextXAlignment.Center)
	end
	
	-- function called to load from save table
	-- this function can be omitted
	m.LoadConfig = function(save: any)
	end
	
	-- function called to save from load table
	-- this function can be omitted
	m.SaveConfig = function()
		return {} -- AND KEEP YOUR TABLES SERIALIZABLE
	end
	
	-- called upon initialization, should NOT yield
	m.Init = function(figure: Model)
		-- access upvalues, initialize animator
	end
	
	-- called upon update loop, should NOT yield
	m.Update = function(dt: number, figure: Model)
		local t = tick()
		-- step the animator, emit particles
	end
	
	-- called upon destruction, should NOT yield
	m.Destroy = function(figure: Model?)
		-- destroy created instances, dereference animator
	end
	return m -- function returns the module
end)

return modules -- return modules
```

## STEVE's KeyframeSequence file format
It's all pretty simple, really.
The byteorder is in little endian.

string structure
```
<2 bytes short n> <n bytes string>
```

pose structure
```
<string pose_name> <4 bytes float weight> <string pose_easing_style> <string pose_easing_direction> <4 bytes float cframe component, times 12>
```

keyframe structure
```
<4 bytes float time> <2 bytes short n> <pose poses, times n>
```

main file structure
```
<string animation_name> <2 bytes short n> <keyframe keyframes, times n>
```

]]

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
						hum:ChangeState(Enum.HumanoidStateType.Ragdoll)
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

		if not climbing and (jumping or hum.HipHeight < -0.01) then
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
	m.Name = "Immortality Lord"
	m.Description = "il but he chill\nF - Toggle flight\nZ - \"Attack\""
	m.InternalName = "ImmortalityBored"
	m.Assets = {"ImmortalityLordTheme.mp3"}

	m.Bee = false
	m.NeckSnap = true
	m.FixNeckSnapReplicate = true
	m.Notifications = true
	m.FlySpeed = 2
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
		Util_CreateDropdown(parent, "Fly Speed", {
			"1x", "2x", "3x", "4x", "5x", "6.1x", "6.7x"
		}, m.FlySpeed).Changed:Connect(function(val)
			m.FlySpeed = val
		end)
	end
	m.LoadConfig = function(save: any)
		m.Bee = not not save.Bee
		m.NeckSnap = not save.NoNeckSnap
		m.FixNeckSnapReplicate = not save.DontFixNeckSnapReplicate
		m.Notifications = not save.NoTextType
		m.FlySpeed = save.FlySpeed or m.FlySpeed
	end
	m.SaveConfig = function()
		return {
			Bee = m.Bee,
			NoNeckSnap = not m.NeckSnap,
			DontFixNeckSnapReplicate = not m.FixNeckSnapReplicate,
			NoTextType = not m.Notifications,
			FlySpeed = m.FlySpeed,
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
		text.TextColor3 = Color3.new(1,1,1)
		text.TextStrokeTransparency = 0
		text.TextXAlignment = Enum.TextXAlignment.Left
		text.Parent = HiddenGui
		task.spawn(function()
			local cps = 30
			local t = tick()
			local ll = 0
			repeat
				task.wait()
				local l = math.floor((tick() - t) * cps)
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
			game:GetService("TweenService"):Create(text, TweenInfo.new(1, Enum.EasingStyle.Linear),{TextTransparency = 1, TextStrokeTransparency = 1}):Play()
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
	local sword1 = {}
	local sword1off = CFrame.new(-0.0023765564, 2.14191723, 3.825109, -1, 0, 0, 0, -0.519688249, -0.85435611, 0, -0.854355931, 0.519688308)
	local sword2 = {}
	local sword2off = CFrame.new(-0.00237464905, -1.31204176, -3.18902349, -1, 0, 0, 0, -0.519688249, -0.85435611, 0, -0.854355931, 0.519688308)
	local flyv, flyg = nil, nil
	local chatconn = nil
	local dancereact = {}
	m.Init = function(figure: Model)
		start = tick()
		flight = false
		dancereact = {}
		attack = -999
		necksnap = 0
		SetOverrideMovesetMusic(AssetGetContentId("ImmortalityLordTheme.mp3"), "In Aisles (IL's Theme)", 1)
		leftwing = {
			MeshId = "17269814619", TextureId = "",
			Limb = "Torso", Offset = CFrame.new(-0.3, 0, 0) * CFrame.Angles(0, math.rad(270), 0) * CFrame.new(2.2, -2, 1.5)
		}
		rightwing = {
			MeshId = "17269824947", TextureId = "",
			Limb = "Torso", Offset = CFrame.new(0.3, 0, 0) * CFrame.Angles(0, math.rad(270), 0) * CFrame.new(2.2, -2, -1.5)
		}
		sword1 = {
			MeshId = "17326555172", TextureId = "",
			Limb = "Right Arm", Offset = CFrame.new(0.3, 0, 0) * CFrame.Angles(0, math.rad(270), 0) * CFrame.new(2.2, -2, -1.5)
		}
		sword2 = {
			MeshId = "17326476901", TextureId = "",
			Limb = "Right Arm", Offset = CFrame.new(0.3, 0, 0) * CFrame.Angles(0, math.rad(270), 0) * CFrame.new(2.2, -2, -1.5)
		}
		table.insert(HatReanimator.HatCFrameOverride, leftwing)
		table.insert(HatReanimator.HatCFrameOverride, rightwing)
		table.insert(HatReanimator.HatCFrameOverride, sword1)
		table.insert(HatReanimator.HatCFrameOverride, sword2)
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
					local t = tick() - start
					if t - attack >= 0.75 then
						attackcount = 0
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
						notify("STOP RIGHT THIS INSTANT " .. game.Players.LocalPlayer.Name:upper())
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
		}
		task.delay(3, notify, lines[math.random(1, #lines)])
		if chatconn then
			chatconn:Disconnect()
		end
		chatconn = OnPlayerChatted.Event:Connect(function(plr, msg)
			if plr == game.Players.LocalPlayer then
				notify(msg)
			end
		end)
	end
	m.Update = function(dt: number, figure: Model)
		local t = tick() - start
		
		-- get vii
		local hum = figure:FindFirstChild("Humanoid")
		if not hum then return end
		local root = figure:FindFirstChild("HumanoidRootPart")
		if not root then return end
		local torso = figure:FindFirstChild("Torso")
		if not torso then return end
		
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
		
		-- joints
		local rt, nt, rst, lst, rht, lht = CFrame.identity, CFrame.identity, CFrame.identity, CFrame.identity, CFrame.identity, CFrame.identity
		local swordoff = CFrame.identity
		
		local timingsine = t * 60 -- timing from patchma's il
		local onground = hum:GetState() == Enum.HumanoidStateType.Running
		
		-- animations
		rt = CFrame.new(0, 0, 2.5 - math.sin(timingsine / 25) * 0.5) * CFrame.Angles(math.rad(20), 0, 0)
		lst = CFrame.Angles(math.rad(-10 - 10 * math.cos(timingsine / 25)), 0, math.rad(-20))
		rht = CFrame.Angles(math.rad(-10 - 10 * math.cos(timingsine / 25)), math.rad(-10), math.rad(-20))
		lht = CFrame.Angles(math.rad(-10 - 10 * math.cos(timingsine / 25)), math.rad(10), math.rad(-10))
		if onground and not flight then
			rst = CFrame.Angles(0, 0, math.rad(-10))
			swordoff = CFrame.new(0, -1, 0) * CFrame.Angles(math.rad(154.35 - 5.65 * math.sin(timingsine / 25)), 0, 0)
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
			if (attackdur < 0.25) == (attackcount % 2 == 0) then
				rt = CFrame.new(0, 0, 2.5 - math.sin(timingsine / 25) * 0.5) * CFrame.Angles(math.rad(5), 0, math.rad(-20))
				rst = CFrame.Angles(0, math.rad(-50), math.rad(attackdegrees))
				swordoff = CFrame.new(-0.5, -0.5, 0) * CFrame.Angles(math.rad(180), math.rad(-90), 0)
			else
				rt = CFrame.new(0, 0, 2.5 - math.sin(timingsine / 25) * 0.5) * CFrame.Angles(math.rad(5), 0, math.rad(20))
				rst = CFrame.Angles(0, math.rad(50), math.rad(attackdegrees))
				swordoff = CFrame.new(-0.5, -0.5, 0) * CFrame.Angles(math.rad(180), math.rad(-90), 0)
			end
			ReanimateShowHitboxes()
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
		if figure:GetAttribute("IsDancing") then
			sword1.Limb = "Torso"
			sword2.Limb = "Torso"
			swordoff = CFrame.new(0, 0, 0.6) * CFrame.Angles(0, 0, math.rad(115)) * CFrame.Angles(0, math.rad(90), 0) * CFrame.new(0, -3.15, 0)
		else
			sword1.Limb = "Right Arm"
			sword2.Limb = "Right Arm"
		end
		
		-- apply scaling
		local scale = figure:GetScale() - 1
		rt += rt.Position * scale
		nt += nt.Position * scale
		rst += rst.Position * scale
		lst += lst.Position * scale
		rht += rht.Position * scale
		lht += lht.Position * scale
		swordoff += swordoff.Position * scale
		
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
		if figure:GetAttribute("IsDancing") then
			leftwing.Offset = CFrame.new(-0.3, 0, 0) * CFrame.Angles(0, math.rad(-105), 0) * CFrame.new(2.2, -2, 1.5)
			rightwing.Offset = CFrame.new(0.3, 0, 0) * CFrame.Angles(0, math.rad(-75), 0) * CFrame.new(2.2, -2, -1.5)
		else
			if m.Bee then
				leftwing.Offset = CFrame.new(-0.3, 0, 0) * CFrame.Angles(0, math.rad(-105 + 25 * math.cos(timingsine)), 0) * CFrame.new(2.2, -2, 1.5)
				rightwing.Offset = CFrame.new(0.3, 0, 0) * CFrame.Angles(0, math.rad(-75 - 25 * math.cos(timingsine)), 0) * CFrame.new(2.2, -2, -1.5)
			else
				leftwing.Offset = CFrame.new(-0.3, 0, 0) * CFrame.Angles(0, math.rad(-105 + 25 * math.cos(timingsine / 25)), 0) * CFrame.new(2.2, -2, 1.5)
				rightwing.Offset = CFrame.new(0.3, 0, 0) * CFrame.Angles(0, math.rad(-75 - 25 * math.cos(timingsine / 25)), 0) * CFrame.new(2.2, -2, -1.5)
			end
		end
		
		-- sword
		sword1.Offset = joints.sw * CFrame.new(0, 6.3, 0) * sword1off:Inverse()
		sword2.Offset = joints.sw * CFrame.new(0, 6.3, 0) * sword2off:Inverse()
		
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
				if t - dancereact.Kemusan > 15 then
					task.delay(2, notify, "how many SOCIAL CREDITS do i get?")
				end
				dancereact.Kemusan = t
			end
			if name == "ClassC14" then
				dancereact.ClassC14 = dancereact.ClassC14 or 0
				if t - dancereact.ClassC14 > 15 then
					task.delay(2, notify, "this song is INTERESTING...")
				end
				dancereact.ClassC14 = t
			end
			if name == "SpeedAndKaiCenat" then
				if not dancereact.AlightMotion then
					task.delay(1, notify, "i have an idea " .. game.Players.LocalPlayer.Name:lower())
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
	m.ModuleType = "DANCE"
	m.Name = "Ragdoll"
	m.Description = "faint, or die\nAnimation-less, physics based, real and istic ragdoll."
	m.InternalName = "RAGDOLL"
	m.Assets = {}

	m.Config = function(parent: GuiBase2d)
	end

	local motors = {}
	local joints = {}
	m.Init = function(figure: Model)
		table.clear(motors)
		table.clear(joints)
		
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
	end
	m.Update = function(dt: number, figure: Model)
		local t = tick()
		local hum = figure:FindFirstChild("Humanoid")
		if not hum then return end
		local root = figure:FindFirstChild("HumanoidRootPart")
		if not root then return end
		hum.PlatformStand = true
	end
	m.Destroy = function(figure: Model?)
		for _,v in motors do
			v.Enabled = true
		end
		for _,v in joints do
			v:Destroy()
		end
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
		animator:Step(GetOverrideDanceMusicTime())
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
			SetOverrideDanceMusic(AssetGetContentId("SubjectThreeDubmood.mp3"), "Dubmood - The Scene Is Dead 2024", 1)
		else
			start += 3.71
			animator.speed = 1.01034703
			SetOverrideDanceMusic(AssetGetContentId("SubjectThree.mp3"), "Subject Three - Wen Ren Ting Shu", 1, NumberRange.new(3.71, 77.611))
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
		Util_CreateSwitch(parent, "Legs Outward on Land", m.LegFix).Changed:Connect(function(val)
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
				beat2 -= 0.2
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
				legs = math.rad(-30 * math.abs(math.cos(beat2 * math.pi)))
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
	m.Description = "Portal music seems to fit"
	m.Assets = {"Smug.anim", "Smug.mp3", "Smug2.mp3"}

	m.Deltarolled = true
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
	local lasttime = 0
	local function setmusic()
		if math.random(1, 5) == 1 or m.Deltarolled then
			SetOverrideDanceMusic(AssetGetContentId("Smug2.mp3"), "Portal Radio", 1)
		else
			SetOverrideDanceMusic(AssetGetContentId("Smug.mp3"), "Portal Radio", 1)
		end
	end
	m.Init = function(figure: Model)
		setmusic()
		animator = AnimLib.Animator.new()
		animator.rig = figure
		animator.looped = true
		animator.track = AnimLib.Track.fromfile(AssetGetPathFromFilename("Smug.anim"))
		animator.map = {{0, 22.572}, {0, 22.4}}
	end
	m.Update = function(dt: number, figure: Model)
		local t = GetOverrideDanceMusicTime()
		if lasttime > t then
			setmusic()
			SetOverrideDanceMusicTime(t)
		end
		lasttime = t
		animator:Step(t)
	end
	m.Destroy = function(figure: Model?)
		animator = nil
	end
	--return m
end)

return modules