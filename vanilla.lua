--[[

# Uhhhhhh documentation
Modules are just luau tables that are created by a function.
It does impose vulnerabilities, but who cares? Executors already
execute functions from user strings.

## Filesystem structure
Uhhhhhh's filesystem is like this
```txt
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
```

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
	
	-- functions below should NOT yield
	
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
	
	-- called upon initialization
	m.Init = function(figure: Model)
		-- access upvalues, initialize animator
	end
	
	-- called upon update loop
	m.Update = function(dt: number, figure: Model)
		local t = tick()
		-- step the animator, emit particles
	end
	
	-- called upon destruction
	-- this is not called when figure is refreshed so reference ur created and modified instances
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
```txt
<2 bytes short n> <n bytes string>
```

pose structure
```txt
<string pose_name> <4 bytes float weight> <string pose_easing_style> <string pose_easing_direction> <4 bytes float cframe component, times 12>
```

keyframe structure
```txt
<4 bytes float time> <4 bytes int n> <pose poses, times n>
```

main file structure
```txt
<string animation_name> <4 bytes int n> <keyframe keyframes, times n>
```

## Uhhhhhh's env
Uhhhhhh gives modules whatever it can. Here are all of it!
```lua
-- whatever = whatever

RandomString(length) -- Random String function

-- UI Util functions, used for config UI
-- refer to line ~58 for usage
Util_CreateText
Util_CreateButton
Util_CreateSwitch
Util_CreateTextbox
Util_CreateDropdown
Util_CreateCanvas
Util_CreateScrollCanvas
Util_CreateSeparator

-- Reanimators
LimbReanimator
	.Running -- is running
	.Mode -- rootpart offset mode
		-- 0 - RootPart in void
		-- 1 - Keep RootPart streamed
		-- 2 - CurrentAngle style
		-- 3 - RootPart is Torso
HatReanimator
	.Running -- is running
	.Permadeath -- has permadeath?
	.HatCollide -- hat collde enabled?
	.HatCFrameOverride -- array of hat overrides
ReanimateShowHitboxes() -- function to show hitboxes, laggy for many hats
ReanimateFling(target, duration) -- fling target
-- target can be model, part, Vector3 or CFrame
-- duration can be 0 for fling to last a frame

-- music overrides
SetOverrideMovesetMusic(assetid, musicname, volume, loopregion) -- play music, pass no arguments to stop
GetOverrideMovesetMusicTime() -- returns time
SetOverrideMovesetMusicTime(time) -- set time
SetOverrideMovesetMusicSpeed(speed) -- set speed
-- same for dance, dances are high priority
SetOverrideDanceMusic(assetid, musicname, volume, loopregion)
GetOverrideDanceMusicTime()
SetOverrideDanceMusicTime(time)
SetOverrideDanceMusicSpeed(speed)

AnimLib -- Uhhhhhh's animation library
	.Track -- track util
		.fromfile(path) -- loads animation from file, must be in STEVE's KeyframeSequence file format
		.frominstance(ks) -- loads animation from a KeyframeSequence
		.paste(target, source, timeoffset) -- pastes keyframes from source to target, with a time offset
		.getPoses(track, time, looped) -- used by Animator
	.Animator -- animator
		.new() -- creates an animator
			.rig -- the character model
			.track -- the animation track
			.map -- map input time to animation time
			.looped -- loop animation by track end time
			.speed -- input time multiplication
			.weight -- use to blend with other animators, or smoothen animation
			:Step(time) -- apply pose

-- utils for grabbing assets from Uhhhhhh/Assets/...
AssetGetPathFromFilename(filename) -- used for AnimLib.Track.fromfile
AssetGetContentId(filename) -- loads file with getcustomasset

-- chat
ProtectedChat(message) -- make player say something, errors are supressed
OnPlayerChatted.Event:Connect(function(player, message) end) -- event when a player chats

HiddenGui -- the reference to the ScreenGui Uhhhhhh uses
```

]]

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
		Util_CreateDropdown(parent, "Fly Speed", {
			"1x", "2x", "3x", "4x", "5x", "6.1x", "6.7x"
		}, m.FlySpeed).Changed:Connect(function(val)
			m.FlySpeed = val
		end)
		Util_CreateDropdown(parent, "Hitbox Scale", {
			"1x", "2x", "3x", "4x"
		}, m.HitboxScale).Changed:Connect(function(val)
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
			HitboxDebug = not save.NoHitbox,
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
		local t = tick()
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
	m.Init = function(figure: Model)
		start = tick()
		flight = false
		dancereact = {}
		attack = -999
		necksnap = 0
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
					local t = tick() - start
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
			"server, tune up Lightning Cannon's powerup theme...",
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
		local t = tick() - start
		local scale = figure:GetScale()
		
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
		if figure:GetAttribute("IsDancing") then
			hum.HipHeight = 0
		else
			hum.HipHeight = 2.5
		end
		
		-- joints
		local rt, nt, rst, lst, rht, lht = CFrame.identity, CFrame.identity, CFrame.identity, CFrame.identity, CFrame.identity, CFrame.identity
		local swordoff = CFrame.identity
		
		local timingsine = t * 60 -- timing from patchma's il
		local onground = hum:GetState() == Enum.HumanoidStateType.Running
		
		-- animations
		rt = CFrame.new(0, 0, math.sin(timingsine / 25) * 0.5) * CFrame.Angles(math.rad(20), 0, 0)
		lst = CFrame.Angles(math.rad(-10 - 10 * math.cos(timingsine / 25)), 0, math.rad(-20))
		rht = CFrame.Angles(math.rad(-10 - 10 * math.cos(timingsine / 25)), math.rad(-10), math.rad(-20))
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
		if figure:GetAttribute("IsDancing") then
			sword.Limb = "Torso"
			swordoff = CFrame.new(0, 0, 0.6) * CFrame.Angles(0, 0, math.rad(115)) * CFrame.Angles(0, math.rad(90), 0) * CFrame.new(0, -1.5, 0)
		else
			sword.Limb = "Right Arm"
		end
		
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
		if figure:GetAttribute("IsDancing") then
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
	m.Description = "lc if he locked in\nF - Toggle flight\nClick/Tap - \"Shoot\"\nZ - Dash (yes it kills)\nX then Click/Tap - \"Singularity Beam\"\n(you can X again to cancel charge)\nC then Click/Tap - \"Painless Rain\"\nV - GRENADE\nB -\"Die X3\"\nM - Switch modes\nModes: 1. Normal\n       2. Power-up\n       3. Fast-as-frick Boii"
	m.InternalName = "LightningFanon"
	m.Assets = {}

	m.Bee = false
	m.Notifications = true
	m.Sounds = true
	m.FlySpeed = 2
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
		Util_CreateDropdown(parent, "Fly Speed", {
			"1x", "2x", "3x", "4x", "5x", "6.1x", "6.7x"
		}, m.FlySpeed).Changed:Connect(function(val)
			m.FlySpeed = val
		end)
	end
	m.LoadConfig = function(save: any)
		m.Bee = not not save.Bee
		m.Notifications = not save.NoTextType
		m.Sounds = not save.Muted
		m.FlySpeed = save.FlySpeed or m.FlySpeed
	end
	m.SaveConfig = function()
		return {
			Bee = m.Bee,
			NoTextType = not m.Notifications,
			Muted = not m.Sounds,
			FlySpeed = m.FlySpeed,
		}
	end

	local hum = nil
	local root = nil
	local torso = nil
	local function notify(message, glitchy)
		glitchy = not not glitchy
		if not m.Notifications then return end
		if not torso then return end
		local dialog = torso:FindFirstChild("NOTIFICATION")
		if dialog then
			dialog:Destroy()
		end
		dialog = Instance.new("BillboardGui", torso)
		dialog.Size = UDim2.new(50, 0, 2, 0)
		dialog.StudsOffset = Vector3.new(0, 5, 0)
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
				local color = Color3.fromHSV(tick() % 1, 1, 1)
				text1.TextColor3 = Color3.new(0, 0, 0):Lerp(color, 0.5)
				text2.TextColor3 = color
				text1.Position = UDim2.new(0, math.random(-1, 1), 0, math.random(-1, 1))
				text2.Position = UDim2.new(0, math.random(-1, 1), 0, math.random(-1, 1))
			end
			local cps = 30
			local t = tick()
			local ll = 0
			repeat
				task.wait()
				local l = math.floor((tick() - t) * cps)
				if l > ll then
					ll = l
				end
				update()
				text1.Text = string.sub(message, 1, l)
				text2.Text = string.sub(message, 1, l)
			until ll >= #message
			text1.Text = message
			text2.Text = message
			t = tick()
			repeat
				task.wait()
				update()
			until tick() - t > 2
			t = tick()
			repeat
				task.wait()
				update()
				local a = tick() - t
				text1.Rotation = a * math.random() * -20
				text2.Rotation = a * math.random() * 20
				text1.TextTransparency = a
				text2.TextTransparency = a
				text1.TextStrokeTransparency = a
				text2.TextStrokeTransparency = a
			until tick() - t > 1
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
		local material = params.Material or "Neon"
		local color = params.Color or Color3.new(1, 1, 1)
		local hOK,sOK,vOK = color:ToHSV()
		local rainbow = false
		if sOK > .1 then
			rainbow = true
		end
		local ticks = params.Time or 45
		local start = tick()
		local boomerang = params.Boomerang
		local boomerangsize = params.BoomerangSize
		task.spawn(function()
			local effect = Instance.new("Part")
			effect.Massless = true
			effect.Transparency = transparency
			effect.CanCollide = false
			effect.CanTouch = false
			effect.Anchored = true
			effect.Color = color
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
			elseif shapetype == "Slash" then
				mesh = Instance.new("SpecialMesh", effect)
				mesh.MeshType = "FileMesh"
				mesh.MeshId = "rbxassetid://662585058"
				mesh.Scale = size
			end
			if mesh ~= nil then
				local movespeed = nil
				local growth = nil
				if shapetype == "Block" then
					effect.CFrame = cfr * CFrame.Angles(
						math.random() * math.pi * 2,
						math.random() * math.pi * 2,
						math.random() * math.pi * 2
					)
				else
					effect.CFrame = cfr
				end
				if boomerang and boomerangsize then
					local bmr1 = 1 + boomerang / 50
					local bmr2 = 1 + boomerangsize / 50
					if movedir ~= nil then
						movespeed = ((cfr.Position - movedir).Magnitude / ticks) * bmr1
					end
					growth = (endsize - size) * (bmr2 + 1)
					local t = 0
					repeat
						local dt = task.wait()
						t = tick() - start
						if rainbow then
							effect.Color = Color3.fromHSV(tick() % 1, sOK, vOK)
						end
						local loop = t * 60
						local t2 = loop / ticks
						mesh.Scale = size + growth * (t2 - bmr2 * 0.5 * t2 * t2) * bmr2
						effect.Transparency = transparency + (endtransparency - transparency) * t2
						local add = CFrame.identity
						if movedir ~= nil then
							add = CFrame.new(0, 0, -movespeed * (t2 - bmr1 * 0.5 * t2 * t2))
						end
						if shapetype == "Block" then
							effect.CFrame = cfr * CFrame.Angles(
								math.random() * math.pi * 2,
								math.random() * math.pi * 2,
								math.random() * math.pi * 2
							) * add
						else
							effect.CFrame = cfr * CFrame.Angles(
								math.rad(rotx * loop),
								math.rad(roty * loop),
								math.rad(rotz * loop)
							) * add
						end
					until t > ticks / 60
				else
					if movedir ~= nil then
						movespeed = (cfr.Position - movedir).Magnitude / ticks
					end
					growth = endsize - size
					local t = 0
					repeat
						local dt = task.wait()
						t = tick() - start
						if rainbow then
							effect.Color = Color3.fromHSV(tick() % 1, sOK, vOK)
						end
						local loop = t * 60
						local t2 = loop / ticks
						mesh.Scale = size + growth * t2
						effect.Transparency = transparency + (endtransparency - transparency) * t2
						local add = CFrame.identity
						if movedir ~= nil then
							add = CFrame.new(0, 0, -movespeed * t2)
						end
						if shapetype == "Block" then
							effect.CFrame = cfr * CFrame.Angles(
								math.random() * math.pi * 2,
								math.random() * math.pi * 2,
								math.random() * math.pi * 2
							) * add
						else
							effect.CFrame = cfr * CFrame.Angles(
								math.rad(rotx * loop),
								math.rad(roty * loop),
								math.rad(rotz * loop)
							) * add
						end
					until t > ticks / 60
				end
			end
			effect:Destroy()
		end)
	end
	local function Lightning(params)
		local start = params.Start or Vector3.new(0, 0, 0)
		local finish = params.Finish or Vector3.new(0, 512, 0)
		local offset = params.Offset or 0
		local color = params.Color or Color3.new(1, 0, 0)
		local ticks = params.Time or 15
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
				Material = "Neon",
				Color = color,
				Boomerang = 0,
				BoomerangSize = boomerangsize
			})
			curpos = CFrame.new(curpos, uwu) * Vector3.new(0, 0, -length)
		end
	end
	local function CreateSound(id, pitch)
		pitch = pitch or 1
		if not m.Sounds then return end
		if not torso then return end
		local sound = Instance.new("Sound")
		sound.Name = tostring(id)
		sound.SoundId = "rbxassetid://" .. id
		sound.Volume = 1
		sound.Pitch = pitch
		sound.Parent = torso
		sound:Play()
		sound.Ended:Connect(function()
			sound:Destroy()
		end)
	end
	local function Attack(position, radius)
		local hitvis = Instance.new("Part")
		hitvis.Name = RandomString()
		hitvis.CastShadow = false
		hitvis.Material = Enum.Material.ForceField
		hitvis.Anchored = true
		hitvis.CanCollide = false
		hitvis.Shape = Enum.PartType.Ball
		hitvis.Color = Color3.new(1, 1, 1)
		hitvis.Size = Vector3.one * radius * 2
		hitvis.CFrame = CFrame.new(position)
		hitvis.Parent = workspace
		Debris:AddItem(hitvis, 1)
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
	local flight = false
	local start = 0
	local attacking = false
	local animationOverride = nil
	local currentmode = 0
	local function Dash()
		if attacking then return end
		if not root or not hum or not torso then return end
		local rootu = root
		attacking = true
		hum.WalkSpeed = 16 * root.Size.Z -- figure:GetScale() hack
		CreateSound(235097614, 1.5)
		animationOverride = function(timingsine, rt, nt, rst, lst, rht, lht, gunoff)
			rt = CFrame.new(0.5 * math.cos(timingsine / 50), 0, -0.5 * math.sin(timingsine / 50)) * CFrame.Angles(0, 0, math.rad(-60))
			nt = CFrame.Angles(0, 0, math.rad(60))
			rst = CFrame.new(-0.25, 0, 0.25) * CFrame.Angles(math.rad(-60), 0, math.rad(-90)) * CFrame.new(0, 0, 0.5)
			lst = CFrame.new(0.25, 0, 0.25) * CFrame.Angles(math.rad(-10), 0, math.rad(95)) * CFrame.new(0, 0, 0.5)
			gunoff = CFrame.new(0, -0.5, 0) * CFrame.Angles(math.rad(-90), 0, 0)
			return rt, nt, rst, lst, rht, lht, gunoff
		end
		task.spawn(function()
			task.wait(0.15)
			if not rootu:IsDescendantOf(workspace) then return end
			CreateSound(642890855, 0.45)
			Effect({Time = 25, EffectType = "Box", Size = Vector3.new(2, 2, 2), SizeEnd = Vector3.new(5, 5, 5), Transparency = 0, TransparencyEnd = 1, CFrame = root.CFrame, RotationX = math.random(-1, 1), RotationY = math.random(-1, 1), RotationZ = math.random(-1, 1), Material = "Neon", Color = Color3.new(1, 0, 0), Boomerang = 0, BoomerangSize = 50})
			Effect({Time = 25, EffectType = "Box", Size = Vector3.new(2, 2, 2), SizeEnd = Vector3.new(5, 5, 5), Transparency = 0, TransparencyEnd = 1, CFrame = root.CFrame, RotationX = math.random(-1, 1), RotationY = math.random(-1, 1), RotationZ = math.random(-1, 1), Material = "Neon", Color = Color3.new(1, 1, 1), Boomerang = 0, BoomerangSize = 50})
			Effect({Time = math.random(25, 45), EffectType = "Sphere", Size = Vector3.new(2, 100, 2), SizeEnd = Vector3.new(6, 100, 6), Transparency = 0, TransparencyEnd = 1, CFrame = root.CFrame * CFrame.new(math.random(-1, 1), math.random(-1, 1), -50) * CFrame.Angles(math.rad(math.random(89, 91)), math.rad(math.random(-1, 1)), math.rad(math.random(-1, 1))), Material = "Neon", Color = Color3.new(1, 0, 0), Boomerang = 0, BoomerangSize = 45})
			Effect({Time = math.random(25, 45), EffectType = "Sphere", Size = Vector3.new(3, 100, 3), SizeEnd = Vector3.new(9, 100, 9), Transparency = 0, TransparencyEnd = 1, CFrame = root.CFrame * CFrame.new(math.random(-1, 1), math.random(-1, 1), -50) * CFrame.Angles(math.rad(math.random(89, 91)), math.rad(math.random(-1, 1)), math.rad(math.random(-1, 1))), Material = "Neon", Color = Color3.new(1, 1, 1), Boomerang = 0, BoomerangSize = 45})
			Attack(root.Position, 14)
			for _=1, 4 do
				root.CFrame = root.CFrame * CFrame.new(0, 0, -25)
				Attack(root.Position, 14)
				Lightning({Start = root.CFrame * Vector3.new(math.random(-2.5, 2.5), math.random(-5, 5), math.random(-15, 15)), Finish = root.CFrame * Vector3.new(math.random(-2.5, 2.5), math.random(-5, 5), math.random(-15, 15)), Offset = 25, Color = Color3.new(1, 0, 0), Time = math.random(30, 45), SizeStart = 0.5, SizeEnd = 1.5, BoomerangSize = 60})
			end
			Effect({Time = 25, EffectType = "Box", Size = Vector3.new(2, 2, 2), SizeEnd = Vector3.new(5, 5, 5), Transparency = 0, TransparencyEnd = 1, CFrame = root.CFrame, RotationX = math.random(-1, 1), RotationY = math.random(-1, 1), RotationZ = math.random(-1, 1), Material = "Neon", Color = Color3.new(1, 0, 0), Boomerang = 0, BoomerangSize = 50})
			Effect({Time = 25, EffectType = "Box", Size = Vector3.new(2, 2, 2), SizeEnd = Vector3.new(5, 5, 5), Transparency = 0, TransparencyEnd = 1, CFrame = root.CFrame, RotationX = math.random(-1, 1), RotationY = math.random(-1, 1), RotationZ = math.random(-1, 1), Material = "Neon", Color = Color3.new(1, 1, 1), Boomerang = 0, BoomerangSize = 50})
			animationOverride = function(timingsine, rt, nt, rst, lst, rht, lht, gunoff)
				rt = CFrame.new(0.5 * math.cos(timingsine / 50), 0, -0.5 * math.sin(timingsine / 50)) * CFrame.Angles(0, 0, math.rad(90))
				nt = CFrame.Angles(0, 0, math.rad(-90))
				rst = CFrame.Angles(math.rad(90), 0, math.rad(-90)) * CFrame.new(0, 0, 0.5)
				lst = CFrame.Angles(math.rad(-5), math.rad(5), math.rad(40)) * CFrame.new(0, 0, 0.5)
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
			hum.WalkSpeed = 50 * root.Size.Z
		end)
	end
	local function KaBoom()
		if attacking then return end
		if not root or not hum or not torso then return end
		local rootu = root
		attacking = true
		hum.WalkSpeed = 0
		notify("die... Die... DIE!!!", true)
		CreateSound(1566051529)
		task.spawn(function()
			--CreateSound(642890855, 0.45)
			attacking = false
			hum.WalkSpeed = 50 * root.Size.Z
		end)
	end
	local function AttackOne()
		if attacking then return end
		if not root or not hum or not torso then return end
		local rootu = root
		attacking = true
		local mouse = Player:GetMouse()
		task.spawn(function()
			animationOverride = function(timingsine, rt, nt, rst, lst, rht, lht, gunoff)
				rt = CFrame.new(0.5 * math.cos(timingsine / 50), 0, -0.5 * math.sin(timingsine / 50)) * CFrame.Angles(0, 0, math.rad(30))
				nt = CFrame.Angles(math.rad(15), 0, math.rad(-30))
				rst = CFrame.Angles(math.rad(30), 0, math.rad(-90))
				lst = CFrame.Angles(math.rad(0), math.rad(0), math.rad(30))
				local tcf = CFrame.lookAt(root.Position, mouse.Hit.Position)
				local _,off,_ = root.CFrame:ToObjectSpace(tcf):ToEulerAngles(Enum.RotationOrder.YXZ)
				root.AssemblyAngularVelocity = Vector3.new(0, off, 0) * 15
				return rt, nt, rst, lst, rht, lht, gunoff
			end
			task.wait(0.15)
			if not rootu:IsDescendantOf(workspace) then return end
			local target = mouse.Hit.Position
			local hole = root.CFrame * CFrame.new(Vector3.new(1, 0.5, -5) * root.Size.Z)
			local dist = (hole.Position - target).Magnitude
			CreateSound(642890855, 0.45)
			CreateSound(192410089, 0.55)
			Effect({Time = 25, EffectType = "Box", Size = Vector3.new(0, 0, 0), SizeEnd = Vector3.new(3, 3, 3), Transparency = 0, TransparencyEnd = 1, CFrame = hole, RotationX = math.random(-1, 1), RotationY = math.random(-1, 1), RotationZ = math.random(-1, 1), Material = "Neon", Color = Color3.new(1, 0, 0), Boomerang = 0, BoomerangSize = 50})
			Effect({Time = 25, EffectType = "Box", Size = Vector3.new(0, 0, 0), SizeEnd = Vector3.new(3, 3, 3), Transparency = 0, TransparencyEnd = 1, CFrame = hole, RotationX = math.random(-1, 1), RotationY = math.random(-1, 1), RotationZ = math.random(-1, 1), Material = "Neon", Color = Color3.new(1, 1, 1), Boomerang = 0, BoomerangSize = 50})
			Effect({Time = 25, EffectType = "Box", Size = Vector3.new(0, 0, 0), SizeEnd = Vector3.new(3, 3, 3), Transparency = 0, TransparencyEnd = 1, CFrame = CFrame.new(target), RotationX = math.random(-1, 1), RotationY = math.random(-1, 1), RotationZ = math.random(-1, 1), Material = "Neon", Color = Color3.new(1, 0, 0), Boomerang = 0, BoomerangSize = 50})
			Effect({Time = 25, EffectType = "Box", Size = Vector3.new(0, 0, 0), SizeEnd = Vector3.new(3, 3, 3), Transparency = 0, TransparencyEnd = 1, CFrame = CFrame.new(target), RotationX = math.random(-1, 1), RotationY = math.random(-1, 1), RotationZ = math.random(-1, 1), Material = "Neon", Color = Color3.new(1, 1, 1), Boomerang = 0, BoomerangSize = 50})
			Effect({Time = 25, EffectType = "Cylinder", Size = Vector3.new(1, dist, 1), SizeEnd = Vector3.new(1, dist, 1), Transparency = 0, TransparencyEnd = 1, CFrame = CFrame.lookAt((hole.Position + target) / 2, target), Material = "Neon", Color = Color3.new(1, 1, 1)})
			for _=1,5 do
				Lightning({Start = hole.Position, Finish = target, Offset = 3.5, Color = Color3.new(1, 0, 0), Time = 25, SizeStart = 0, SizeEnd = 1, BoomerangSize = 55})
			end
			for _=0,2 do
				Effect({Time = math.random(25, 50), EffectType = "Slash", Size = Vector3.new(0, 0, 0), SizeEnd = Vector3.new(0.1, 0, 0.1), Transparency = 0, TransparencyEnd = 1, CFrame = hole * CFrame.Angles(math.rad(math.random(0, 360)), math.rad(math.random(0, 360)), math.rad(math.random(0, 360))), RotationX = math.random(-1, 1), RotationY = math.random(-1, 1), RotationZ = math.random(-1, 1), Material = "Neon", Color = Color3.new(1, 0, 0), Boomerang = 0, BoomerangSize = 15})
				Effect({Time = math.random(25, 50), EffectType = "Slash", Size = Vector3.new(0, 0, 0), SizeEnd = Vector3.new(0.1, 0, 0.1), Transparency = 0, TransparencyEnd = 1, CFrame = hole * CFrame.Angles(math.rad(math.random(0, 360)), math.rad(math.random(0, 360)), math.rad(math.random(0, 360))), RotationX = math.random(-1, 1), RotationY = math.random(-1, 1), RotationZ = math.random(-1, 1), Material = "Neon", Color = Color3.new(1, 1, 1), Boomerang = 0, BoomerangSize = 15})
			end
			for _=0,2 do
				Effect({Time = math.random(25, 50), EffectType = "Slash", Size = Vector3.new(0, 0, 0), SizeEnd = Vector3.new(0.1, 0, 0.1), Transparency = 0, TransparencyEnd = 1, CFrame = CFrame.new(target) * CFrame.Angles(math.rad(math.random(0, 360)), math.rad(math.random(0, 360)), math.rad(math.random(0, 360))), RotationX = math.random(-1, 1), RotationY = math.random(-1, 1), RotationZ = math.random(-1, 1), Material = "Neon", Color = Color3.new(1, 0, 0), Boomerang = 0, BoomerangSize = 15})
				Effect({Time = math.random(25, 50), EffectType = "Slash", Size = Vector3.new(0, 0, 0), SizeEnd = Vector3.new(0.1, 0, 0.1), Transparency = 0, TransparencyEnd = 1, CFrame = CFrame.new(target) * CFrame.Angles(math.rad(math.random(0, 360)), math.rad(math.random(0, 360)), math.rad(math.random(0, 360))), RotationX = math.random(-1, 1), RotationY = math.random(-1, 1), RotationZ = math.random(-1, 1), Material = "Neon", Color = Color3.new(1, 1, 1), Boomerang = 0, BoomerangSize = 15})
			end
			if math.random(2) == 1 then
				randomdialog({
					"BOOM",
					"THAT ANT IS DEAD",
					"Immortality Lord, YOU CANNOT DO THIS",
					"LIGHTNING FAST",
					"WHO THE HELL DO YOU THINK I AM???", -- gurren lagann referencs
					"EAT THIS",
					"READ MY NAME, I AM LIGHTNING CANNON.",
				}, true)
			end
			Attack(target, 10)
			animationOverride = function(timingsine, rt, nt, rst, lst, rht, lht, gunoff)
				rt = CFrame.new(0.5 * math.cos(timingsine / 50), 0, -0.5 * math.sin(timingsine / 50)) * CFrame.Angles(0, 0, math.rad(30))
				nt = CFrame.Angles(math.rad(10), 0, math.rad(-60))
				rst = CFrame.Angles(math.rad(60), math.rad(-20), math.rad(-160))
				lst = CFrame.Angles(math.rad(-5), math.rad(5), math.rad(40))
				return rt, nt, rst, lst, rht, lht, gunoff
			end
			task.wait(0.1)
			if not rootu:IsDescendantOf(workspace) then return end
			animationOverride = nil
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
	local chatconn = nil
	local uisbegin, uisend = nil, nil
	local dancereact = {}
	m.Init = function(figure: Model)
		start = tick()
		flight = false
		attacking = false
		animationOverride = nil
		figure.Humanoid.WalkSpeed = 50 * figure:GetScale()
		--SetOverrideMovesetMusic(AssetGetContentId("LightningCannonPower.mp3"), "Ka1zer - INSaNiTY", 1)
		--SetOverrideMovesetMusic(AssetGetContentId("LightningCannonFastBoi.mp3"), "RUNNING IN THE '90s", 1, NumberRange.new(24.226))
		leftwing = {
			Group = "LeftWing",
			Limb = "Torso", Offset = CFrame.new(-0.15, 0, 0)
		}
		rightwing = {
			Group = "RightWing",
			Limb = "Torso", Offset = CFrame.new(0.15, 0, 0)
		}
		sword = {
			Group = "Gun",
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
		hum = figure:FindFirstChild("Humanoid")
		root = figure:FindFirstChild("HumanoidRootPart")
		torso = figure:FindFirstChild("Torso")
		ContextActionService:BindAction("Uhhhhhh_LCFlight", function(_, state, _)
			if state == Enum.UserInputState.Begin then
				flight = not flight
				if math.random(4) == 1 then
					if flight then
						if math.random(4) == 1 then
							notify("i PIERCE through the HEAVENS", true)
						elseif math.random(3) == 1 then
							notify("my FLYING ANIMATION is NOT JUST for SHOW", true)
						elseif math.random(2) == 1 then
							notify("im a birb")
							task.delay(1.7, notify, "GOVERNMENT DRONE", true)
						else
							notify("PEASANTS.", true)
						end
					else
						if math.random(2) == 1 then
							task.delay(1, notify, "sometimes i wonder why i stay near ground")
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
		task.delay(0, notify, "Lightning Cannon, by LuaQuack")
		task.delay(1, randomdialog, {
			"Immortality Lord did not have to say that...",
			"that intro sucked",
			"I THINK THE USER KNOWS WHO I AM",
			"blah blah blah blah BLAHH!!",
			"die... Die... DIE!!!",
			"now WHERE IS THE MELEE USER",
			"its been years since the good times for me",
			"WHO ARE WE GOING TO BLAST TO STARDUST TODAY?",
			"ready or not, MY LIGHTNING CANNON IS READY",
			"LETS BLAST SOMEONE WITH INFINITE VOLTS",g
		}, true)
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
				clicktime = tick()
			end
		end)
		uisend = UserInputService.InputEnded:Connect(function(input, gpe)
			if gpe then return end
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				if (input.Position - clickpos).Magnitude < 5 then
					if tick() - clicktime < 0.5 then
						AttackOne()
					end
				end
			end
		end)
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
		local t = tick() - start
		local scale = figure:GetScale()
		
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
		if figure:GetAttribute("IsDancing") then
			hum.HipHeight = 0
		else
			hum.HipHeight = 3
		end
		
		-- joints
		local rt, nt, rst, lst, rht, lht = CFrame.identity, CFrame.identity, CFrame.identity, CFrame.identity, CFrame.identity, CFrame.identity
		local gunoff = CFrame.identity
		
		local timingsine = t * 60 -- timing from original
		local onground = hum:GetState() == Enum.HumanoidStateType.Running
		
		-- animations
		rt = CFrame.new(0.5 * math.cos(timingsine / 50), 0, 10 * math.clamp(math.pow(1 - t, 3), 0, 1) - 0.5 * math.sin(timingsine / 50))
		gunoff = CFrame.new(0.05, -1, -0.15) * CFrame.Angles(math.rad(-90), 0, 0)
		if root.Velocity.Magnitude < 8 * scale then
			nt = CFrame.Angles(math.rad(20), 0, 0)
			rst = CFrame.Angles(math.rad(25), 0, math.rad(135 + 8.5 * math.cos(timingsine / 50)))
			lst = CFrame.Angles(math.rad(-25 - 5 * math.cos(timingsine / 25)), 0, math.rad(-25 - 8.5 * math.cos(timingsine / 50)))
			rht = CFrame.new(0, 0.5, 0) * CFrame.Angles(0, math.rad(-10), 0) * CFrame.Angles(math.rad(-15 + 9 * math.cos(timingsine / 74) + 5 * math.cos(timingsine / 37)), 0, 0)
			lht = CFrame.Angles(0, math.rad(10), 0) * CFrame.Angles(math.rad(-15 - 9 * math.cos(timingsine / 54) - 5 * math.cos(timingsine / 41)), 0, 0)
		else
			rt *= CFrame.Angles(math.rad(40), 0, 0)
			nt = CFrame.new(0, -0.25, 0) * CFrame.Angles(math.rad(-20), 0, 0)
			rst = CFrame.Angles(math.rad(-5 - 2 * math.cos(timingsine / 19)), 0, math.rad(-45))
			lst = CFrame.Angles(math.rad(-5 - 2 * math.cos(timingsine / 19)), 0, math.rad(45))
			rht = CFrame.new(0, 0.5, 0) * CFrame.Angles(0, math.rad(-10), 0) * CFrame.Angles(math.rad(-20 + 9 * math.cos(timingsine / 74) + 5 * math.cos(timingsine / 37)), 0, 0)
			lht = CFrame.Angles(0, math.rad(10), 0) * CFrame.Angles(math.rad(-20 - 9 * math.cos(timingsine / 54) - 5 * math.cos(timingsine / 41)), 0, 0)
		end
		if animationOverride then
			rt, nt, rst, lst, rht, lht, gunoff = animationOverride(timingsine, rt, nt, rst, lst, rht, lht, gunoff)
		end
		
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
		local alpha = math.exp(-18.6 * dt)
		joints.r = rt:Lerp(joints.r, alpha)
		joints.n = nt:Lerp(joints.n, alpha)
		joints.rs = rst:Lerp(joints.rs, alpha)
		joints.ls = lst:Lerp(joints.ls, alpha)
		joints.rh = rht:Lerp(joints.rh, alpha)
		joints.lh = lht:Lerp(joints.lh, alpha)
		joints.sw = gunoff:Lerp(joints.sw, alpha)
		
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
				if t - dancereact.Ragdoll > 1 then
					notify("ow my leg")
				end
				dancereact.Ragdoll = t
			end
			if name == "SpeedAndKaiCenat" then
				if not dancereact.AlightMotion then
					task.delay(1, notify, "i have an idea " .. Player.Name:lower())
					task.delay(4, notify, "what if immortality lord is the other guy")
				end
				dancereact.AlightMotion = true
			end
		end
	end
	m.Destroy = function(figure: Model?)
		ContextActionService:UnbindAction("Uhhhhhh_LCFlight")
		ContextActionService:UnbindAction("Uhhhhhh_LCDash")
		flyv:Destroy()
		flyg:Destroy()
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
	end
	if Player.UserId ~= 1949002397 then return end
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
	local teleporthack = nil
	m.Init = function(figure: Model)
		table.clear(motors)
		table.clear(joints)
		if teleporthack then teleporthack:Disconnect() end
		
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
		teleporthack = root:GetPropertyChangedSignal("CFrame"):Connect(function()
			local cf = root.CFrame
			nj.Part1.CFrame = cf
			rsj.Part1.CFrame = cf
			lsj.Part1.CFrame = cf
			rhj.Part1.CFrame = cf
			lhj.Part1.CFrame = cf
		end)
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

	m.Config = function(parent: GuiBase2d)
	end

	local animator = nil
	m.Init = function(figure: Model)
		SetOverrideDanceMusic(AssetGetContentId("DoTheFlop.mp3"), "asdfmovie - Do The Flop", 1)
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
	m.Init = function(figure: Model)
		SetOverrideDanceMusic(AssetGetContentId("Backflips.mp3"), "Both Of You, Dance Like You Want To Win", 1)
		start = tick()
		animator = AnimLib.Animator.new()
		animator.rig = figure
		animator.looped = true
		animator.track = AnimLib.Track.fromfile(AssetGetPathFromFilename("Backflips.anim"))
	end
	m.Update = function(dt: number, figure: Model)
		animator:Step(tick() - start)
		local hum = figure:FindFirstChild("Humanoid")
		if not hum or not hum.RootPart then return end
		if hum.MoveDirection.Magnitude > 0 then
			-- move backwards
			hum.RootPart.Velocity = Vector3.new(
				hum.MoveDirection.X * -16 * figure:GetScale(),
				hum.RootPart.Velocity.Y,
				hum.MoveDirection.Z * -16 * figure:GetScale()
			)
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
	m.Name = "Headlock"
	m.Description = "bakas bakas bakas bakas baka sekao"
	m.Assets = {"Headlock.anim", "Headlock.mp3"}

	m.Config = function(parent: GuiBase2d)
	end

	local animator = nil
	m.Init = function(figure: Model)
		SetOverrideDanceMusic(AssetGetContentId("Headlock.mp3"), "what is this tune broski", 1)
		animator = AnimLib.Animator.new()
		animator.rig = figure
		animator.looped = true
		animator.map = {{0, 14.774}, {0, 14.76}}
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

return modules