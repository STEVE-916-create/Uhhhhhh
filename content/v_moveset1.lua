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
				local scale = figure:GetScale()
				local vel = hum.Torso.Velocity
				local power = -vel.Y / 2
				if power > 30 * scale then
					hum.Torso.Velocity = Vector3.new(vel.X, power, vel.Z)
					hum.Torso.RotVelocity = rng:NextUnitVector() * power * 0.5 / scale
					if power > 100 * scale then
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
			hum.JumpPower = 50 * scale

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
	m.Name = "2015 Roblox"
	m.Description = "workspace." .. Player.Name .. ".Animate\n\"Ahh, the time when Roblox started using Motor6Ds for their animations.\"\n        - Li'l Programmer Timmy born in 2022"
	m.InternalName = "RETROSLOP2"
	m.Assets = {}

	m.Config = function(parent: GuiBase2d)
	end

	local hstatechange, hrun = nil
	local hum = nil
	local justdanced = false

	local lastpose = ""
	local pose = "Standing"
	local currentAnim = ""
	local currentAnimInstance = nil
	local currentAnimTrack = nil
	local currentAnimKeyframeHandler = nil
	local currentAnimSpeed = 1.0
	local toolAnimName = ""
	local toolAnimTrack = nil
	local toolAnimInstance = nil
	local currentToolAnimKeyframeHandler = nil
	local function resetAnimate()
		if currentAnimTrack then
			currentAnimTrack:Destroy()
		end
		if currentAnimKeyframeHandler then
			currentAnimKeyframeHandler:Disconnect()
		end
		if toolAnimTrack then
			toolAnimTrack:Destroy()
		end
		if currentToolAnimKeyframeHandler then
			currentToolAnimKeyframeHandler:Disconnect()
		end
		currentAnim = ""
		currentAnimInstance = nil
		currentAnimTrack = nil
		currentAnimKeyframeHandler = nil
		currentAnimSpeed = 1.0
		toolAnimName = ""
		toolAnimTrack = nil
		toolAnimInstance = nil
		currentToolAnimKeyframeHandler = nil
	end
	local animTable = {}
	local animNames = { 
		idle = {
			{ id = "http://www.roblox.com/asset/?id=180435571", weight = 9 },
			{ id = "http://www.roblox.com/asset/?id=180435792", weight = 1 }
		},
		walk = {
			{ id = "http://www.roblox.com/asset/?id=180426354", weight = 10 }
		}, 
		run = {
			{ id = "http://www.roblox.com/asset/?id=180426354", weight = 10 }
		}, 
		jump = 	{
			{ id = "http://www.roblox.com/asset/?id=125750702", weight = 10 }
		}, 
		fall = 	{
			{ id = "http://www.roblox.com/asset/?id=180436148", weight = 10 }
		}, 
		climb = {
			{ id = "http://www.roblox.com/asset/?id=180436334", weight = 10 }
		}, 
		sit = 	{
			{ id = "http://www.roblox.com/asset/?id=178130996", weight = 10 }
		},	
		toolnone = {
			{ id = "http://www.roblox.com/asset/?id=182393478", weight = 10 }
		},
		toolslash = {
			{ id = "http://www.roblox.com/asset/?id=129967390", weight = 10 }
		},
		toollunge = {
			{ id = "http://www.roblox.com/asset/?id=129967478", weight = 10 }
		},
		wave = {
			{ id = "http://www.roblox.com/asset/?id=128777973", weight = 10 }
		},
		point = {
			{ id = "http://www.roblox.com/asset/?id=128853357", weight = 10 }
		},
		dance1 = {
			{ id = "http://www.roblox.com/asset/?id=182435998", weight = 10 },
			{ id = "http://www.roblox.com/asset/?id=182491037", weight = 10 },
			{ id = "http://www.roblox.com/asset/?id=182491065", weight = 10 }
		},
		dance2 = {
			{ id = "http://www.roblox.com/asset/?id=182436842", weight = 10 }, 
			{ id = "http://www.roblox.com/asset/?id=182491248", weight = 10 }, 
			{ id = "http://www.roblox.com/asset/?id=182491277", weight = 10 } 
		},
		dance3 = {
			{ id = "http://www.roblox.com/asset/?id=182436935", weight = 10 }, 
			{ id = "http://www.roblox.com/asset/?id=182491368", weight = 10 }, 
			{ id = "http://www.roblox.com/asset/?id=182491423", weight = 10 } 
		},
		laugh = {
			{ id = "http://www.roblox.com/asset/?id=129423131", weight = 10 } 
		},
		cheer = {
			{ id = "http://www.roblox.com/asset/?id=129423030", weight = 10 } 
		},
	}
	local dances = {"dance1", "dance2", "dance3"}
	local emoteNames = { wave = false, point = false, dance1 = true, dance2 = true, dance3 = true, laugh = false, cheer = false}
	
	local function configureAnimationSet(name)
		local fileList = animNames[name]
		if animTable[name] ~= nil then
			for _, connection in animTable[name].connections do
				connection:Disconnect()
			end
		end
		animTable[name] = {}
		animTable[name].count = 0
		animTable[name].totalWeight = 0	
		animTable[name].connections = {}
		for idx, anim in fileList do
			animTable[name][idx] = {}
			animTable[name][idx].anim = Instance.new("Animation")
			animTable[name][idx].anim.Name = name
			animTable[name][idx].anim.AnimationId = anim.id
			animTable[name][idx].weight = anim.weight
			animTable[name].count = animTable[name].count + 1
			animTable[name].totalWeight = animTable[name].totalWeight + anim.weight
		end
	end
	for name,_ in animNames do 
		configureAnimationSet(name)
	end
	local function stopAllAnimations()
		local oldAnim = currentAnim
		if emoteNames[oldAnim] ~= nil and emoteNames[oldAnim] == false then
			oldAnim = "idle"
		end
		currentAnim = ""
		currentAnimInstance = nil
		if currentAnimKeyframeHandler ~= nil then
			currentAnimKeyframeHandler:Disconnect()
		end
		if currentAnimTrack ~= nil then
			currentAnimTrack:Stop()
			currentAnimTrack:Destroy()
			currentAnimTrack = nil
		end
		return oldAnim
	end
	local function setAnimationSpeed(speed)
		if speed ~= currentAnimSpeed then
			currentAnimSpeed = speed
			currentAnimTrack:AdjustSpeed(currentAnimSpeed)
		end
	end
	local playAnimation
	local function keyFrameReachedFunc(frameName)
		if frameName == "End" then
			local repeatAnim = currentAnim
			if emoteNames[repeatAnim] ~= nil and emoteNames[repeatAnim] == false then
				repeatAnim = "idle"
			end
			local animSpeed = currentAnimSpeed
			playAnimation(repeatAnim, 0.0, hum)
			setAnimationSpeed(animSpeed)
		end
	end
	playAnimation = function(animName, transitionTime, humanoid)
		if justdanced then return end
		if not animTable[animName] then return end
		local roll = math.random(1, animTable[animName].totalWeight) 
		local origRoll = roll
		local idx = 1
		while roll > animTable[animName][idx].weight do
			roll = roll - animTable[animName][idx].weight
			idx = idx + 1
		end
		local anim = animTable[animName][idx].anim
		if anim ~= currentAnimInstance then
			if currentAnimTrack ~= nil then
				currentAnimTrack:Stop(transitionTime)
				currentAnimTrack:Destroy()
			end
			currentAnimSpeed = 1.0
			currentAnimTrack = humanoid:LoadAnimation(anim)
			currentAnimTrack.Priority = Enum.AnimationPriority.Core
			currentAnimTrack:Play(transitionTime)
			currentAnim = animName
			currentAnimInstance = anim
			if currentAnimKeyframeHandler ~= nil then
				currentAnimKeyframeHandler:Disconnect()
			end
			currentAnimKeyframeHandler = currentAnimTrack.KeyframeReached:connect(keyFrameReachedFunc)
		end
	end
	local playToolAnimation
	local function toolKeyFrameReachedFunc(frameName)
		if frameName == "End" then
			playToolAnimation(toolAnimName, 0.0, hum)
		end
	end
	playToolAnimation = function(animName, transitionTime, humanoid, priority)
		if justdanced then return end
		if not animTable[animName] then return end
		local roll = math.random(1, animTable[animName].totalWeight) 
		local origRoll = roll
		local idx = 1
		while roll > animTable[animName][idx].weight do
			roll = roll - animTable[animName][idx].weight
			idx = idx + 1
		end
		local anim = animTable[animName][idx].anim
		if toolAnimInstance ~= anim then
			if toolAnimTrack ~= nil then
				toolAnimTrack:Stop()
				toolAnimTrack:Destroy()
				transitionTime = 0
			end
			toolAnimTrack = humanoid:LoadAnimation(anim)
			if priority then
				toolAnimTrack.Priority = priority
			end
			toolAnimTrack:Play(transitionTime)
			toolAnimName = animName
			toolAnimInstance = anim
			currentToolAnimKeyframeHandler = toolAnimTrack.KeyframeReached:connect(toolKeyFrameReachedFunc)
		end
	end
	local function stopToolAnimations()
		local oldAnim = toolAnimName
		if currentToolAnimKeyframeHandler ~= nil then
			currentToolAnimKeyframeHandler:Disconnect()
		end
		toolAnimName = ""
		toolAnimInstance = nil
		if toolAnimTrack ~= nil then
			toolAnimTrack:Stop()
			toolAnimTrack:Destroy()
			toolAnimTrack = nil
		end
		return oldAnim
	end
	local function map(x, inMin, inMax, outMin, outMax)
		return (x - inMin)*(outMax - outMin)/(inMax - inMin) + outMin
	end
	local sndpoint = nil

	m.Init = function(figure: Model)
		hum = figure:FindFirstChild("Humanoid")
		hum.AutoRotate = true
		hum:ChangeState(Enum.HumanoidStateType.Freefall)
		resetAnimate()
		playAnimation("fall", 0.3, hum)
		sndpoint = Instance.new("Attachment")
		sndpoint.Name = "rbxcharactersounds"
		sndpoint.Parent = hum.Torso
		local function makesound(name, id)
			local sound = Instance.new("Sound")
			sound.SoundId = id
			sound.Parent = sndpoint
			sound.RollOffMinDistance = 5
			sound.RollOffMaxDistance = 150
			sound.Volume = 0.85
			sound.Name = name
			return sound
		end
		local run = makesound("Running", "rbxasset://sounds/action_footsteps_plastic.mp3")
		run.Looped = true
		run.PlaybackSpeed = 2
		run.Volume = 1
		local swim = makesound("Swimming", "rbxasset://sounds/action_swim.mp3")
		swim.Looped = true
		swim.PlaybackSpeed = 1.6
		local clim = makesound("Climbing", "rbxasset://sounds/action_footsteps_plastic.mp3")
		clim.Looped = true
		makesound("GettingUp", "rbxasset://sounds/action_get_up.mp3")
		makesound("FallingDown", "rbxasset://sounds/splat.wav")
		makesound("Jumping", "rbxasset://sounds/action_jump.mp3")
		makesound("Landing", "rbxasset://sounds/action_jump_land.mp3")
		makesound("Splash", "rbxasset://sounds/impact_water.mp3")
		hrun = hum.Running:Connect(function(speed)
			speed /= figure:GetScale()
			if speed > 0.01 then
				playAnimation("walk", 0.1, hum)
				setAnimationSpeed(speed / 14.5)
				pose = "Running"
			else
				if emoteNames[currentAnim] == nil then
					playAnimation("idle", 0.1, hum)
					pose = "Standing"
				end
			end
		end)
		hclim = hum.Climbing:Connect(function(speed)
			speed /= figure:GetScale()
			playAnimation("climb", 0.1, hum)
			setAnimationSpeed(speed / 12.0)
			pose = "Climbing"
		end)
		local stateid = 0
		hstatechange = hum.StateChanged:Connect(function(old, new)
			local verticalSpeed = math.abs(hum.RootPart.AssemblyLinearVelocity.Y)
			local state = new.Name
			local id = stateid
			if state ~= "Freefall" then
				id = math.random(-65536, 65536)
				stateid = id
			end
			run.Playing = false
			swim.Playing = false
			clim.Playing = false
			if state == "Jumping" then
				pose = "Jumping"
				playAnimation("jump", 0.1, hum)
				task.delay(0.3, function()
					if stateid == id then
						playAnimation("fall", 0.3, hum)
					end
				end)
				sndpoint.Jumping:Play()
			elseif state == "Seated" then
				pose = "Seated"
			elseif state == "Swimming" then
				if verticalSpeed > 0.1 then
					sndpoint.Splash.Volume = math.clamp(map(verticalSpeed, 100, 350, 0.28, 1), 0, 1)
					sndpoint.Splash:Play()
				end
				swim.Playing = true
				pose = "Swimming"
			elseif state == "PlatformStand" then
				pose = "Standing"
			elseif state == "GettingUp" then
				pose = "GettingUp"
				sndpoint.GettingUp:Play()
			elseif state == "Ragdoll" then
				pose = "Running"
			elseif state == "FallingDown" then
				pose = "FallingDown"
			elseif state == "Freefall" then
				pose = "Freefall"
				if old.Name ~= "Jumping" then
					playAnimation("fall", 0.3, hum)
				end
			elseif state == "Landed" then
				if verticalSpeed > 75 then
					sndpoint.Landing.Volume = math.clamp(map(verticalSpeed, 50, 100, 0, 1), 0, 1)
					sndpoint.Landing:Play()
				end
				pose = "Landed"
			elseif state == "Running" then
				run.Playing = true
				pose = "Running"
			elseif state == "Climbing" then
				clim.Playing = verticalSpeed > 0.1
				pose = "Climbing"
			else
				pose = "Standing"
			end
		end)
	end
	m.Update = function(dt: number, figure: Model)
		local t = os.clock()

		local scale = figure:GetScale()

		hum = figure:FindFirstChild("Humanoid")
		if not hum then return end
		local root = figure:FindFirstChild("HumanoidRootPart")
		if not root then return end
		local torso = figure:FindFirstChild("Torso")
		if not torso then return end

		if figure:GetAttribute("IsDancing") then
			for _,v in hum:GetPlayingAnimationTracks() do
				v:Stop(0)
				v:Destroy()
			end
			justdanced = true
			return
		end
		if justdanced then
			task.delay(0.1, function()
				playAnimation("idle", 0, hum)
			end)
			justdanced = false
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

		if pose == "Seated" then
			playAnimation("sit", 0.5, hum)
		else
			if pose == "Running" then
				sndpoint.Running.Playing = hum.MoveDirection.Magnitude > 0.5
			elseif pose == "Standing" then
				sndpoint.Running.Playing = false
			elseif pose == "Climbing" then
				sndpoint.Climbing.Playing = math.abs(hum.RootPart.AssemblyLinearVelocity.Y) > 0.1
			end
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
					playToolAnimation("toolnone", 0.1, hum, Enum.AnimationPriority.Idle)
				end
				if toolAnim == "Slash" then
					playToolAnimation("toolslash", 0, hum, Enum.AnimationPriority.Action)
				end
				if toolAnim == "Lunge" then
					playToolAnimation("toollunge", 0, hum, Enum.AnimationPriority.Action)
				end
			else
				toolAnim = "None"
				toolAnimTime = 0
				stopToolAnimations()
			end
		end
	end
	m.Destroy = function(figure: Model?)
		hstatechange:Disconnect()
		hrun:Disconnect()
		hclim:Disconnect()
		sndpoint:Destroy()
	end
	return m
end)

AddModule(function()
	-- TODO: Revamp this
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
					LimbReanimator.SetRootPartMode(0)
				else
					LimbReanimator.SetRootPartMode(2)
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
	m.Name = "Krystal Dance V3"
	m.Description = "Very lazy moveset\nthis is from the theo mod, so no furry run here"
	m.InternalName = "KDRV3"
	m.Assets = {"KDRV3Idle.anim", "KDRV3Walk.anim", "KDRV3Sprint.anim", "CreoSphere.mp3"}

	m.SimulateLagFromOriginal = false
	m.Config = function(parent: GuiBase2d)
		Util_CreateSwitch(parent, "Insane 7s Lag", m.SimulateLagFromOriginal).Changed:Connect(function(val)
			m.SimulateLagFromOriginal = val
		end)
	end

	local NeckC0 = CFrame.new(0, 1, 0, -1, 0, 0, 0, 0, 1, 0, 1, 0)
	local animatoridle = nil
	local animatorwalk = nil
	local animatorspri = nil
	local animationtime = 0
	local hasmovedsinceinit = false -- simulate noanim bug
	local isfinisheddoingfedora = false
	local laststate = "none"
	local sprinting = false
	local persistentloadnotif = false -- simulate loadstring sprint load notif
	m.Init = function(figure: Model)
		if m.SimulateLagFromOriginal then
			local lag = os.clock() + 6.5 + math.random() while os.clock() < lag do end
		end
		SetOverrideMovesetMusic("", "Level Up sound effect", 1)
		local hum = figure:FindFirstChild("Humanoid")
		if not hum then return end
		local root = figure:FindFirstChild("HumanoidRootPart")
		if not root then return end
		-- intro sound
		local introsound = Instance.new("Sound", figure)
		introsound.SoundId = "rbxassetid://236146895"
		introsound.Volume = 1
		introsound:Play()
		introsound.Ended:Connect(function()
			if figure:IsDescendantOf(workspace) then
				-- unlike the original kdv3, theo's mod breaks the main theme
				-- shouldve done an Ended fix here...
				SetOverrideMovesetMusic(AssetGetContentId("CreoSphere.mp3"), "Creo - Sphere", 1)
			end
		end)
		task.spawn(function()
			local bigfedora = Instance.new("Part", figure)
			bigfedora.Size = Vector3.new(2, 2, 2)
			bigfedora.CFrame = root.CFrame * CFrame.new(math.random(-60, 60) * figure:GetScale(), -0.2 * figure:GetScale(), math.random(-60, 60) * figure:GetScale()) * CFrame.Angles(0, math.rad(math.random(-180, 180)), 0)
			bigfedora.Anchored = true
			bigfedora.CanCollide = false
			bigfedora.Name = "bigemofedora"
			local mbigfedora = Instance.new("SpecialMesh", bigfedora)
			mbigfedora.MeshType = "FileMesh"
			mbigfedora.Scale = Vector3.new(5, 5, 5) * figure:GetScale()
			mbigfedora.MeshId = "http://www.roblox.com/asset/?id=1125478"
			mbigfedora.TextureId = "http://www.roblox.com/asset/?id=1125479"
			for i=1, 60 do
				bigfedora.CFrame = bigfedora.CFrame:Lerp(CFrame.new(0, -0.1 * figure:GetScale(), 0) + root.Position, 0.09)
				task.wait(1 / 60)
			end
			task.wait(0.25)
			for i=1, 50 do
				bigfedora.CFrame = bigfedora.CFrame:Lerp(CFrame.new(0, 1.5 * figure:GetScale(), 0) + root.Position, 0.05)
				task.wait(1 / 60)
			end
			local zmc = 0
			for i=1, 29 do
				zmc = zmc + 2
				mbigfedora.Scale = mbigfedora.Scale - Vector3.new(0.25, 0.25, 0.25) * figure:GetScale()
				bigfedora.CFrame = bigfedora.CFrame * CFrame.Angles(0, math.rad(zmc), 0)
				task.wait(1 / 60)
			end
			bigfedora:Destroy()
			-- move to force hasmovedsinceinit
			-- (very bad fix from whoever implemented this in original kdv3)
			for i=1, 5 do
				hum:Move(Vector3.new(0, 0, -1))
				task.wait(1 / 30)
			end
			if figure:IsDescendantOf(workspace) then
				-- at this point in time we have already moved anyway
				hasmovedsinceinit = true
				isfinisheddoingfedora = true
			end
		end)
		animatoridle = AnimLib.Animator.new()
		animatoridle.rig = figure
		animatoridle.looped = true
		animatoridle.track = AnimLib.Track.fromfile(AssetGetPathFromFilename("KDRV3Idle.anim"))
		animatorwalk = AnimLib.Animator.new()
		animatorwalk.rig = figure
		animatorwalk.looped = true
		animatorwalk.track = AnimLib.Track.fromfile(AssetGetPathFromFilename("KDRV3Walk.anim"))
		animatorspri = AnimLib.Animator.new()
		animatorspri.rig = figure
		animatorspri.looped = true
		animatorspri.track = AnimLib.Track.fromfile(AssetGetPathFromFilename("KDRV3Sprint.anim"))
		hasmovedsinceinit = false
		isfinisheddoingfedora = false
		animationtime = 0
		laststate = "none"
		sprinting = false
		ContextActionService:BindAction("Uhhhhhh_KDRV3Sprint", function(actName, state, input)
			if state == Enum.UserInputState.Begin then
				sprinting = not sprinting
				if sprinting and not persistentloadnotif then
					persistentloadnotif = true
					StarterGui:SetCore("SendNotification", {
						Title = "Uhhhhhh",
						Text = "Loaded: Sprint",
						Duration = 5
					})
				end
			end
		end, true, Enum.KeyCode.LeftControl)
		ContextActionService:SetTitle("Uhhhhhh_KDRV3Sprint", "Ctrl")
		ContextActionService:SetPosition("Uhhhhhh_KDRV3Sprint", UDim2.new(1, -130, 1, -130))
	end
	m.Update = function(dt: number, figure: Model)
		local t = os.clock()

		local scale = figure:GetScale()

		local hum = figure:FindFirstChild("Humanoid")
		if not hum then return end

		local state = "idle"
		if not hasmovedsinceinit then
			state = "none"
		end
		if hum.MoveDirection.Magnitude > 0.1 then
			if sprinting then
				state = "spri"
			else
				state = "walk"
			end
			hasmovedsinceinit = true
		end
		if laststate ~= state then
			animationtime = 0
			laststate = state
		else
			animationtime += dt
		end

		if state == "idle" then
			animatoridle:Step(animationtime)
		end
		if state == "walk" then
			animatorwalk:Step(animationtime)
		end
		if state == "spri" then
			animatorspri:Step(animationtime)
		end

		local head = figure:FindFirstChild("Head")
		if not head then return end
		local torso = figure:FindFirstChild("Torso")
		if not torso then return end
		local neck = torso:FindFirstChild("Neck")
		if not neck then return end
		local neckC0 = NeckC0
		if not figure:GetAttribute("IsDancing") then
			if sprinting then
				hum.WalkSpeed = 24 * scale
			else
				hum.WalkSpeed = 14 * scale
			end
			-- only turn head when the fedora animation is done
			if isfinisheddoingfedora then
				local HeadPosition = head.Position
				local MousePos = Player:GetMouse().Hit.Position
				if UserInputService.TouchEnabled then
					MousePos = workspace.CurrentCamera.CFrame * Vector3.new(0, 0, -10000)
				end
				local TranslationVector = (HeadPosition - MousePos).Unit
				local Pitch = math.atan(TranslationVector.Y)
				local Yaw = TranslationVector:Cross(torso.CFrame.LookVector).Y
				local Roll = math.atan(Yaw)
				neckC0 = NeckC0 * CFrame.Angles(Pitch, 0, Yaw)
			end
		end
		neck.C0 = neck.C0:Lerp(neckC0 + neckC0.Position * (scale - 1), dt * 10)
	end
	m.Destroy = function(figure: Model?)
		animatoridle = nil
		animatorwalk = nil
		animatorspri = nil
		ContextActionService:UnbindAction("Uhhhhhh_KDRV3Sprint")
	end
	return m
end)

-- update force 1

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
	local t = j.C0:Inverse() * c0 * c1:Inverse() * j.C1
	j.Transform = t + t.Position * (scale - 1)
end

local modules = {}
local function AddModule(m)
	table.insert(modules, m)
end

AddModule(function()
	local m = {}
	m.ModuleType = "MOVESET"
	m.Name = "Super Mario 64"
	m.InternalName = "SM64.Z64"
	m.Description = "itsumi mario! press start to play!\nmost of the code were copied from maximum_adhd's sm64-roblox\n\nhere are some wierd ways to defeat enemies in super mario 64\nwe can make chain chomp fall out of bounds\nwe can throw king bob-omb out of bounds\nwe can knock the chill bully off this platform and move him around, though he ends up dying elsewhere\nwe can get eye-rock to fall off the edge and then he doesnt come back up\nwe can get bowser to fall off the edge and then he doesnt come back up\nwe can drop mips into other levels\nwe can drop the 2 ukikis off the edge\nwe can drop the baby penguin off the edge\nwe can make the mama penguin fall off the edge\nwe can make the racing penguin fall off the edge\nwe can make koopa the quick fall off the edge\nwe can send koopa the quick to a parallel universe\nwe can get a bully stuck underground\nwe can get a bully stuck in a corner\nwe can make klepto lunge at us and then stuck in a pillar\nwe can throw a bob-omb buddy out of bounds\nwe can push a heave ho out of bounds using a block\nwe can make bubba fall off the edge\nand we can make yoshi fall off the castle roof"
	m.Assets = {}

	m.FPS30 = false
	m.ModeCap = 2
	m.EmulationSpeed = 1
	m.AutofireJump = true
	m.Config = function(parent: GuiBase2d)
		Util_CreateDropdown(parent, "Cap", {
			"Capless Mario",
			"Mario",
			"Wing Cap Mario",
			"Metal Mario",
			"Vanish Cap Mario",
		}, m.ModeCap).Changed:Connect(function(val)
			m.ModeCap = val
		end)
		Util_CreateSlider(parent, "Emulation Speed", m.EmulationSpeed, 0.25, 2, 0.25).Changed:Connect(function(val)
			m.EmulationSpeed = val
		end)
		Util_CreateSwitch(parent, "Autofire Jump", m.AutofireJump).Changed:Connect(function(val)
			m.AutofireJump = val
		end)
	end
	m.LoadConfig = function(save: any)
		m.FPS30 = not not save.FPS30
		m.ModeCap = save.ModeCap or m.ModeCap
		m.EmulationSpeed = save.EmulationSpeed or m.EmulationSpeed
		m.AutofireJump = not save.ManualDrive
	end
	m.SaveConfig = function()
		return {
			FPS30 = m.FPS30,
			ModeCap = m.ModeCap,
			EmulationSpeed = m.EmulationSpeed,
			ManualDrive = not m.AutofireJump,
		}
	end

	local SM64RobloxUrl = "https://raw.githubusercontent.com/MaximumADHD/sm64-roblox/refs/heads/main"
	local SM64Hierarchy = {}
	function SM64Hierarchy:GetAttribute(self, name)
		return nil
	end
	function SM64Hierarchy:WaitForChild(self, name)
		return self[name]
	end
	SM64Hierarchy.Parent = SM64Hierarchy
	local function CreateHierarch(name, pathe, parent)
		local h = {}
		function h:GetAttribute(self, name)
			return nil
		end
		function h:WaitForChild(self, name)
			return self[name]
		end
		if #pathe > 0 then
			local hash = 0
			for i=1, #pathe do
				hash += string.byte(pathe:sub(i, i)) + i
			end
			hash = tostring(hash):rep(16):sub(1, 16)
			hash = "SM64_" .. hash .. ".lua"
			table.insert(m.Assets, hash .. "@" .. SM64RobloxUrl .. "/client/" .. pathe)
			h.Source = hash
		end
		h.Name = name
		h.Parent = parent
		parent[name] = h
	end
	CreateHierarch("Enums", "Enums/init.lua", SM64Hierarchy)
	CreateHierarch("Buttons", "Enums/Buttons.lua", SM64Hierarchy.Enums)
	CreateHierarch("FloorType", "Enums/FloorType.lua", SM64Hierarchy.Enums)
	CreateHierarch("InputFlags", "Enums/InputFlags.lua", SM64Hierarchy.Enums)
	CreateHierarch("ModelFlags", "Enums/ModelFlags.lua", SM64Hierarchy.Enums)
	CreateHierarch("ParticleFlags", "Enums/ParticleFlags.lua", SM64Hierarchy.Enums)
	CreateHierarch("SurfaceClass", "Enums/SurfaceClass.lua", SM64Hierarchy.Enums)
	CreateHierarch("TerrainType", "Enums/TerrainType.lua", SM64Hierarchy.Enums)
	CreateHierarch("Action", "Enums/Action/init.lua", SM64Hierarchy.Enums)
	CreateHierarch("Groups", "Enums/Action/Groups.lua", SM64Hierarchy.Enums.Action)
	CreateHierarch("Flags", "Enums/Action/Flags.lua", SM64Hierarchy.Enums.Action)
	CreateHierarch("Mario", "", SM64Hierarchy.Enums)
	CreateHierarch("Cap", "Enums/Mario/Cap.lua", SM64Hierarchy.Enums.Mario)
	CreateHierarch("Eyes", "Enums/Mario/Eyes.lua", SM64Hierarchy.Enums.Mario)
	CreateHierarch("Flags", "Enums/Mario/Flags.lua", SM64Hierarchy.Enums.Mario)
	CreateHierarch("Hands", "Enums/Mario/Hands.lua", SM64Hierarchy.Enums.Mario)
	CreateHierarch("Input", "Enums/Mario/Input.lua", SM64Hierarchy.Enums.Mario)
	CreateHierarch("Steps", "", SM64Hierarchy.Enums)
	CreateHierarch("Air", "Enums/Steps/Air.lua", SM64Hierarchy.Enums.Steps)
	CreateHierarch("Ground", "Enums/Steps/Ground.lua", SM64Hierarchy.Enums.Steps)
	CreateHierarch("Water", "Enums/Steps/Water.lua", SM64Hierarchy.Enums.Steps)
	CreateHierarch("Mario", "Mario/init.lua", SM64Hierarchy)
	CreateHierarch("Airborne", "Mario/Airborne/init.server.lua", SM64Hierarchy.Mario)
	CreateHierarch("Automatic", "Mario/Automatic/init.server.lua", SM64Hierarchy.Mario)
	CreateHierarch("Moving", "Mario/Moving/init.server.lua", SM64Hierarchy.Mario)
	CreateHierarch("Stationary", "Mario/Stationary/init.server.lua", SM64Hierarchy.Mario)
	CreateHierarch("Submerged", "Mario/Submerged/init.server.lua", SM64Hierarchy.Mario)
	CreateHierarch("Types", "Types/init.lua", SM64Hierarchy)
	CreateHierarch("Flags", "Types/Flags.lua", SM64Hierarchy.Types)
	CreateHierarch("Util", "Util/init.lua", SM64Hierarchy)
	local cache = {}
	local newrequire = nil
	newrequire = function(m)
		if m and m.Source then
			if not cache[m] then
				local f = loadstring(readfile(AssetGetPathFromFilename(m.Source)), "SM64 :: " .. m.Name)
				setfenv(f, setmetatable({}, {
					__index = function(_, k)
						if k == "require" then
							return newrequire
						end
						if k == "script" then
							return m
						end
						return getfenv()[k]
					end,
					__newindex = function(_, k, v)
						getfenv()[k] = v
					end,
				}))
				cache[m] = f()
			end
			return cache[m]
		end
		error("Invalid argument.")
	end
	SM64Hierarchy.Shared = {Source = "inside the cache"}
	cache[SM64Hierarchy.Shared] = {
		Animations = {},
		Sounds = {},
	}
	local Sounds = {}
	local Enums, Mario, Types, Util, Action, Buttons, MarioFlags, ParticleFlags, mario
	local STEP_RATE = 30
	local NULL_TEXT = '<font color="#FF0000">NULL</font>'
	local FLIP = CFrame.Angles(0, math.pi, 0)
	local PARTICLE_CLASSES = {
		Fire = true,
		Smoke = true,
		Sparkles = true,
		ParticleEmitter = true,
	}
	local AUTO_STATS = {
		"Position",
		"Velocity",
		"AnimFrame",
		"FaceAngle",
		"ActionState",
		"ActionTimer",
		"ActionArg",
		"ForwardVel",
		"SlideVelX",
		"SlideVelZ",
		"CeilHeight",
		"FloorHeight",
		"WaterLevel",
	}
	local BUTTON_FEED = {}
	local BUTTON_BINDS = {}
	local function toStrictNumber(str)
		local result = tonumber(str)
		return assert(result, "Invalid number!")
	end
	local function processAction(id, state, input)
		local button = toStrictNumber(id:sub(5))
		BUTTON_FEED[button] = state
	end
	local function processInput(input, gameProcessedEvent)
		if gameProcessedEvent then return end
		if BUTTON_BINDS[input.UserInputType] ~= nil then
			processAction(BUTTON_BINDS[input.UserInputType], input.UserInputState, input)
		end
		if BUTTON_BINDS[input.KeyCode] ~= nil then
			processAction(BUTTON_BINDS[input.KeyCode], input.UserInputState, input)
		end
	end
	local uisb, uisc, uise
	local function bindInput(button, label, ...)
		local id = "BTN_" .. button
		if UserInputService.TouchEnabled then
			ContextActionService:BindAction(id, processAction, true)
			ContextActionService:SetTitle(id, label)
		end
		for i, input in { ... } do
			BUTTON_BINDS[input] = id
		end
	end
	local function unbindInput(button)
		local id = "BTN_" .. button
		ContextActionService:UnbindAction(id, processAction, true)
	end
	local function updateController(controller, humanoid)
		if not humanoid then
			return
		end
		local moveDir = Vector3.zero
		if workspace.CurrentCamera then
			local _,angle,_ = workspace.CurrentCamera.CFrame:ToEulerAngles(Enum.RotationOrder.YXZ)
			moveDir = CFrame.Angles(0, angle, 0):VectorToObjectSpace(humanoid:GetMoveVelocity() / humanoid.WalkSpeed)
			moveDir *= Vector3.new(1, -1)
		end
		local pos = Vector2.new(moveDir.X, -moveDir.Z)
		local mag = 0
		if pos.Magnitude > 0 then
			if pos.Magnitude > 1 then
				pos = pos.Unit
			end
			mag = pos.Magnitude
		end
		controller.StickMag = mag * 64
		controller.StickX = pos.X * 64
		controller.StickY = pos.Y * 64
		humanoid:ChangeState(Enum.HumanoidStateType.Physics)
		controller.ButtonPressed:Clear()
		if humanoid.Jump then
			BUTTON_FEED[Buttons.A_BUTTON] = Enum.UserInputState.Begin
		elseif controller.ButtonDown:Has(Buttons.A_BUTTON) then
			BUTTON_FEED[Buttons.A_BUTTON] = Enum.UserInputState.End
		end
		local lastButtonValue = controller.ButtonDown()
		for button, state in pairs(BUTTON_FEED) do
			if state == Enum.UserInputState.Begin then
				controller.ButtonDown:Add(button)
			elseif state == Enum.UserInputState.End then
				controller.ButtonDown:Remove(button)
			end
		end
		table.clear(BUTTON_FEED)
		local buttonValue = controller.ButtonDown()
		controller.ButtonPressed:Set(buttonValue)
		controller.ButtonPressed:Band(bit32.bxor(buttonValue, lastButtonValue))
		local character = humanoid.Parent
		if m.AutofireJump then
			if not mario.Action:Has(Enums.ActionFlags.SWIMMING) then
				if controller.ButtonDown:Has(Buttons.A_BUTTON) then
					controller.ButtonPressed:Set(Buttons.A_BUTTON)
				end
			end
		end
	end
	local Commands = {}
	local soundDecay = {}
	local function stepDecay(sound)
		local decay = soundDecay[sound]
		if decay then
			task.cancel(decay)
		end
		soundDecay[sound] = task.delay(0.1, function()
			sound:Stop()
			sound:Destroy()
			soundDecay[sound] = nil
		end)
		sound.Playing = true
	end
	function Commands.PlaySound(character, name)
		local sound = Sounds[name]
		local rootPart = character and character:FindFirstChild("HumanoidRootPart")
		if rootPart and sound then
			local oldSound = rootPart:FindFirstChild(name)
			local canPlay = true
			if oldSound and oldSound:IsA("Sound") then
				canPlay = false
				if name:sub(1, 6) == "MOVING" or sound:GetAttribute("Decay") then
					stepDecay(oldSound)
				elseif name:sub(1, 5) == "MARIO" then
					local now = os.clock()
					local lastPlay = oldSound:GetAttribute("LastPlay") or 0
					if now - lastPlay >= 2 / STEP_RATE then
						oldSound.TimePosition = 0
						oldSound:SetAttribute("LastPlay", now)
					end
				else
					canPlay = true
				end
			end
			if canPlay then
				local newSound = sound:Clone()
				newSound.Parent = rootPart
				newSound:Play()
				if name:find("MOVING") then
					stepDecay(newSound)
				end
				newSound.Ended:Connect(function()
					newSound:Destroy()
				end)
				newSound:SetAttribute("LastPlay", os.clock())
			end
		end
	end
	function Commands.SetParticle(character, name, set)
		local character = player.Character
		local rootPart = character and character.PrimaryPart
		if rootPart then
			local particles = rootPart:FindFirstChild("Particles")
			local inst = particles and particles:FindFirstChild(name, true)
			if inst and PARTICLE_CLASSES[inst.ClassName] then
				local particle = inst :: ParticleEmitter
				local emit = particle:GetAttribute("Emit")
				if typeof(emit) == "number" then
					particle:Emit(emit)
				elseif set ~= nil then
					particle.Enabled = set
				end
			else
				--warn("particle not found:", name)
			end
		end
	end
	local function networkDispatch(character, cmd, ...)
		local command = Commands[cmd]
		if command then
			task.spawn(command, character, ...)
		else
			warn("Unknown Command:", cmd, ...)
		end
	end
	local lastUpdate = os.clock()
	local lastHeadAngle
	local lastTorsoAngle
	local activeScale = 1
	local subframe = 0 -- 30hz subframe
	local emptyId = ""
	local goalCF, prevCF, activeTrack
	local debugStats = {}
	local function setDebugStat(key, value)
		if typeof(value) == "Vector3" then
			value = string.format("%.3f, %.3f, %.3f", value.X, value.Y, value.Z)
		elseif typeof(value) == "Vector3int16" then
			value = string.format("%i, %i, %i", value.X, value.Y, value.Z)
		elseif type(value) == "number" then
			value = string.format("%.3f", value)
		end
		debugStats[key] = value
	end
	local function getWaterLevel(pos: Vector3)
		local terrain = workspace.Terrain
		local voxelPos = terrain:WorldToCellPreferSolid(pos)
		local voxelRegion = Region3.new(voxelPos * 4, (voxelPos + Vector3.one + (Vector3.yAxis * 3)) * 4)
		voxelRegion = voxelRegion:ExpandToGrid(4)
		local materials, occupancies = terrain:ReadVoxels(voxelRegion, 4)
		local size: Vector3 = occupancies.Size
		local waterLevel = -11000
		for y = 1, size.Y do
			local occupancy = occupancies[1][y][1]
			local material = materials[1][y][1]
			if occupancy >= 0.9 and material == Enum.Material.Water then
				local top = ((voxelPos.Y * 4) + (4 * y + 2))
				waterLevel = math.max(waterLevel, top / Util.Scale)
			end
		end
		return waterLevel
	end
	local isTeleTravel = false
	local teleConn = nil
	m.Init = function(figure)
		local root = figure:FindFirstChild("HumanoidRootPart")
		uisb = UserInputService.InputBegan:Connect(processInput)
		uisc = UserInputService.InputChanged:Connect(processInput)
		uise = UserInputService.InputEnded:Connect(processInput)
		if not mario then
			Enums = newrequire(SM64Hierarchy.Enums)
			Mario = newrequire(SM64Hierarchy.Mario)
			Types = newrequire(SM64Hierarchy.Types)
			Util = newrequire(SM64Hierarchy.Util)
			Mario.SetAnimation = function(m, anim)
				-- TODO
				m.AnimFrameCount = 0
				m.AnimCurrent = nil
				m.AnimAccelAssist = 0
				m.AnimAccel = 0
				m.AnimReset = true
				m.AnimDirty = true
				m.AnimFrame = 0
				return 0
			end
			Action = Enums.Action
			Buttons = Enums.Buttons
			MarioFlags = Enums.MarioFlags
			ParticleFlags = Enums.ParticleFlags
			mario = Mario.new()
			newrequire(SM64Hierarchy.Mario.Airborne)
			newrequire(SM64Hierarchy.Mario.Automatic)
			newrequire(SM64Hierarchy.Mario.Moving)
			newrequire(SM64Hierarchy.Mario.Stationary)
			newrequire(SM64Hierarchy.Mario.Submerged)
		end
		bindInput(Buttons.B_BUTTON, "B", Enum.UserInputType.MouseButton1, Enum.KeyCode.ButtonX)
		bindInput(Buttons.Z_TRIG, "Z", Enum.KeyCode.LeftShift, Enum.KeyCode.RightShift, Enum.KeyCode.ButtonL2, Enum.KeyCode.ButtonR2)
		mario.SlideVelX = 0
		mario.SlideVelZ = 0
		mario.ForwardVel = 0
		mario.IntendedYaw = 0
		local pivot = root.CFrame
		goalCF = pivot
		prevCF = pivot
		mario.Position = Util.ToSM64(pivot.Position)
		mario.Velocity = Vector3.zero
		mario.FaceAngle = Vector3int16.new()
		mario.Health = 0x880
		mario:SetAction(Enums.Action.SPAWN_SPIN_AIRBORNE)
		teleConn = root:GetPropertyChangedSignal("CFrame"):Connect(function()
			if isTeleTravel then
				local pivot = root.CFrame
				goalCF = pivot
				prevCF = pivot
				mario.Position = Util.ToSM64(pivot.Position)
			end
		end)
	end
	m.Update = function(dt: number, figure: Model)
		local now = os.clock()
		local gfxRot = CFrame.identity
		local scale = figure:GetScale()
		if scale ~= activeScale then
			local marioPos = Util.ToRoblox(mario.Position)
			Util.Scale = scale / 20 -- HACK! Should this be instanced?
			mario.Position = Util.ToSM64(marioPos)
			activeScale = scale
		end
		local humanoid = figure:FindFirstChildOfClass("Humanoid")
		local _,neck = pcall(function() return figure.Torso.Neck end)
		local simSpeed = m.EmulationSpeed
		local robloxPos = Util.ToRoblox(mario.Position)
		mario.WaterLevel = getWaterLevel(robloxPos)
		Util.DebugWater(mario.WaterLevel)
		subframe += (now - lastUpdate) * (STEP_RATE * simSpeed)
		lastUpdate = now
		if m.ModeCap == 1 then
			mario.Flags:Remove(MarioFlags.NORMAL_CAP)
			mario.Flags:Remove(MarioFlags.WING_CAP)
			mario.Flags:Remove(MarioFlags.METAL_CAP)
			mario.Flags:Remove(MarioFlags.VANISH_CAP)
			mario.Flags:Remove(MarioFlags.CAP_ON_HEAD)
		end
		if m.ModeCap == 2 then
			mario.Flags:Add(MarioFlags.NORMAL_CAP)
			mario.Flags:Remove(MarioFlags.WING_CAP)
			mario.Flags:Remove(MarioFlags.METAL_CAP)
			mario.Flags:Remove(MarioFlags.VANISH_CAP)
			mario.Flags:Add(MarioFlags.CAP_ON_HEAD)
		end
		if m.ModeCap == 3 then
			mario.Flags:Remove(MarioFlags.NORMAL_CAP)
			mario.Flags:Add(MarioFlags.WING_CAP)
			mario.Flags:Remove(MarioFlags.METAL_CAP)
			mario.Flags:Remove(MarioFlags.VANISH_CAP)
			mario.Flags:Add(MarioFlags.CAP_ON_HEAD)
		end
		if m.ModeCap == 4 then
			mario.Flags:Remove(MarioFlags.NORMAL_CAP)
			mario.Flags:Remove(MarioFlags.WING_CAP)
			mario.Flags:Add(MarioFlags.METAL_CAP)
			mario.Flags:Remove(MarioFlags.VANISH_CAP)
			mario.Flags:Add(MarioFlags.CAP_ON_HEAD)
		end
		if m.ModeCap == 5 then
			mario.Flags:Remove(MarioFlags.NORMAL_CAP)
			mario.Flags:Remove(MarioFlags.WING_CAP)
			mario.Flags:Remove(MarioFlags.METAL_CAP)
			mario.Flags:Add(MarioFlags.VANISH_CAP)
			mario.Flags:Add(MarioFlags.CAP_ON_HEAD)
		end
		subframe = math.min(subframe, 4)
		while subframe >= 1 do
			subframe -= 1
			updateController(mario.Controller, humanoid)
			mario:ExecuteAction()
			local gfxPos = Util.ToRoblox(mario.Position)
			gfxRot = Util.ToRotation(mario.GfxAngle)
			prevCF = goalCF
			goalCF = CFrame.new(gfxPos) * FLIP * gfxRot
		end
		if figure and goalCF then
			local cf = figure:GetPivot()
			local rootPart = figure.PrimaryPart
			local animator = figure:FindFirstChildWhichIsA("Animator", true)
			if animator and (mario.AnimDirty or mario.AnimReset) and mario.AnimFrame >= 0 then
				local anim = mario.AnimCurrent
				local animSpeed = 0.1 / simSpeed
				if activeTrack and (activeTrack.Animation ~= anim or mario.AnimReset) then
					if tostring(activeTrack.Animation) == "TURNING_PART1" then
						if anim and anim.Name == "TURNING_PART2" then
							mario.AnimSkipInterp = 2
							animSpeed *= 2
						end
					end
					activeTrack:Stop(animSpeed)
					activeTrack = nil
				end
				if not activeTrack and anim then
					if anim.AnimationId == "" then
						if RunService:IsStudio() then
							warn("!! FIXME: Empty AnimationId for", anim.Name, "will break in live games!")
						end
						anim.AnimationId = emptyId
					end
					local track = animator:LoadAnimation(anim)
					track:Play(animSpeed, 1, 0)
					activeTrack = track
				end
				if activeTrack then
					local speed = mario.AnimAccel / 0x10000
					if speed > 0 then
						activeTrack:AdjustSpeed(speed * simSpeed)
					else
						activeTrack:AdjustSpeed(simSpeed)
					end
				end
				mario.AnimDirty = false
				mario.AnimReset = false
			end
			if activeTrack and mario.AnimSetFrame > -1 then
				activeTrack.TimePosition = mario.AnimSetFrame / STEP_RATE
				mario.AnimSetFrame = -1
			end
			if rootPart then
				local particles = rootPart:FindFirstChild("Particles")
				local alignPos = rootPart:FindFirstChildOfClass("AlignPosition")
				local alignCF = rootPart:FindFirstChildOfClass("AlignOrientation")
				local actionId = mario.Action()
				local throw = mario.ThrowMatrix
				if throw then
					local throwPos = Util.ToRoblox(throw.Position)
					goalCF = throw.Rotation * FLIP + throwPos
				end
				if alignCF then
					local nextCF = prevCF:Lerp(goalCF, subframe)
					cf = if mario.AnimSkipInterp > 0 then cf.Rotation + nextCF.Position else nextCF
					alignCF.CFrame = cf.Rotation
				end
				if limits ~= nil then
					Core:SetAttribute("TruncateBounds", false)
				end
				if isDebug then
					local animName = activeTrack and tostring(activeTrack.Animation)
					setDebugStat("Animation", animName)
					local actionName = Enums.GetName(Action, actionId)
					setDebugStat("Action", actionName)
					local wall = mario.Wall
					setDebugStat("Wall", wall and wall.Instance.Name or NULL_TEXT)
					local floor = mario.Floor
					setDebugStat("Floor", floor and floor.Instance.Name or NULL_TEXT)
					local ceil = mario.Ceil
					setDebugStat("Ceiling", ceil and ceil.Instance.Name or NULL_TEXT)
				end
				for _, name in AUTO_STATS do
					local value = rawget(mario, name)
					setDebugStat(name, value)
				end
				if alignPos then
					alignPos.Position = cf.Position
				end
				local bodyState = mario.BodyState
				local headAngle = bodyState.HeadAngle
				local torsoAngle = bodyState.TorsoAngle
				if actionId ~= Action.BUTT_SLIDE and actionId ~= Action.WALKING then
					bodyState.TorsoAngle *= 0
				end
				if torsoAngle ~= lastTorsoAngle then
					--waist.C1 = Util.ToRotation(-angle) + waist.C1.Position
					lastTorsoAngle = torsoAngle
				end
				if headAngle ~= lastHeadAngle then
					neck.C1 = (Util.ToRotation(-headAngle) * CFrame.Angles(math.pi * -0.5, 0, 0)) + neck.C1.Position
					lastHeadAngle = headAngle
				end
				if particles then
					for name, flag in pairs(ParticleFlags) do
						local inst = particles:FindFirstChild(name, true)
						if inst and PARTICLE_CLASSES[inst.ClassName] then
							local particle = inst
							local emit = particle:GetAttribute("Emit")
							local hasFlag = mario.ParticleFlags:Has(flag)
							if hasFlag then
								--print("SetParticle", name)
							end
							if emit then
								if hasFlag then
									networkDispatch(figure, "SetParticle", name)
								end
							elseif particle.Enabled ~= hasFlag then
								networkDispatch(figure, "SetParticle", name, hasFlag)
							end
						end
					end
				end
				for name, sound in pairs(Sounds) do
					local looped = false
					if sound:IsA("Sound") then
						if sound.TimeLength == 0 then
							continue
						end
						looped = sound.Looped
					end
					if sound:GetAttribute("Play") then
						networkDispatch(figure, "PlaySound", sound.Name)
						if not looped then
							sound:SetAttribute("Play", false)
						end
					elseif looped then
						sound:Stop()
					end
				end
				figure:PivotTo(cf)
			end
		end
	end
	m.Destroy = function(figure: Model?)
		uisb:Disconnect()
		uisc:Disconnect()
		uise:Disconnect()
		unbindInput(Buttons.B_BUTTON)
		unbindInput(Buttons.Z_TRIG)
	end
	return m
end)

return modules
return modules
