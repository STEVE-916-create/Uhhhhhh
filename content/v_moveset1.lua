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
			hum:SetStateEnabled(Enum.HumanoidStateType.Jumping, false)
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
			hum:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)

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
				playAnimation("walk", 0.1, hum)
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
		ContextActions:BindAction("Uhhhhhh_SansDodge", function(actName, state, input)
			if state == Enum.UserInputState.Begin then
				dodgetick = os.clock()
			end
		end, true, Enum.KeyCode.Q)
		ContextActions:SetTitle("Uhhhhhh_SansDodge", "Dodge")
		ContextActions:SetPosition("Uhhhhhh_SansDodge", UDim2.new(1, -130, 1, -130))
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
					LimbReanimator.SetRootPartMode(3)
				end
			end
		end
	end
	m.Destroy = function(figure: Model?)
		animator = nil
		ContextActions:UnbindAction("Uhhhhhh_SansDodge")
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
		ContextActions:BindAction("Uhhhhhh_KDRV3Sprint", function(actName, state, input)
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
		ContextActions:SetTitle("Uhhhhhh_KDRV3Sprint", "Ctrl")
		ContextActions:SetPosition("Uhhhhhh_KDRV3Sprint", UDim2.new(1, -130, 1, -130))
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
		ContextActions:UnbindAction("Uhhhhhh_KDRV3Sprint")
	end
	return m
end)

AddModule(function()
	local VRService = cloneref(game:GetService("VRService"))
	
	local m = {}
	m.ModuleType = "MOVESET"
	m.Name = "Immersive VR"
	m.Description = "fake but real vr altho clunky\n\nvery clunky\n\nM1 - Point Left Hand\nM2 - Point Right Hand\nLeftControl/Button B - Toggle Run\nC - Crouch"
	m.Assets = {}

	m.Config = function(parent: GuiBase2d)
	end

	local scale, isdancing = 1, false
	local hum, root, torso

	local function SetCFrame(part, cf)
		part.CFrame = cf
		part.Velocity, part.RotVelocity = Vector3.zero, Vector3.zero
		local antigravity = Instance.new("BodyForce", part)
		antigravity.Force = Vector3.new(0, workspace.Gravity * part:GetMass(), 0)
		RunService.PreRender:Once(function()
			part.CFrame = cf
			part.Velocity, part.RotVelocity = Vector3.zero, Vector3.zero
		end)
		RunService.Stepped:Once(function()
			part.CFrame = cf
			part.Velocity, part.RotVelocity = Vector3.zero, Vector3.zero
		end)
		RunService.PostSimulation:Once(function()
			antigravity:Destroy()
		end)
	end

	local rcp = RaycastParams.new()
	rcp.FilterType = Enum.RaycastFilterType.Exclude
	rcp.RespectCanCollide = true
	rcp.IgnoreWater = true
	local function PhysicsRaycast(origin, direction)
		return workspace:Raycast(origin, direction, rcp)
	end
	local mouse = Player:GetMouse()
	local function MouseHit()
		local ray = mouse.UnitRay
		local dist = 2000
		local raycast = PhysicsRaycast(ray.Origin, ray.Direction * dist)
		if raycast then
			return raycast.Position
		end
		return ray.Origin + ray.Direction * dist
	end

	-- grok made ts
	local function IK2Bone(from: Vector3, target: Vector3, direction: Vector3, lenA: number, lenB: number): CFrame
		-- 2-segment IK solver (upper arm lenA, forearm lenB). Returns CFrame at target position
		-- whose rotation orients the bone next to the hand (forearm) using the pole direction
		-- for the elbow bend plane. Logic tested: elbow solved via law-of-cosines + pole projection;
		-- last bone roll is pole-consistent so the entire chain stays in the correct plane.
		-- Handles full extension when unreachable; assumes reachable for under-extension (standard).

		local root = from
		local goal = target
		local pole = direction

		local toGoal = goal - root
		local dist = toGoal.Magnitude
		if dist < 1e-6 then
			return CFrame.new(goal) -- degenerate case, no valid plane
		end

		local dir = toGoal / dist

		-- project pole onto plane perpendicular to dir (defines bend direction)
		local poleProj = pole - dir * pole:Dot(dir)
		local poleMag = poleProj.Magnitude
		if poleMag < 1e-6 then
			-- fallback perpendicular (avoids singularity)
			local arb = Vector3.yAxis
			if math.abs(dir:Dot(arb)) > 0.99 then
				arb = Vector3.xAxis
			end
			poleProj = (arb - dir * arb:Dot(dir)).Unit
		else
			poleProj /= poleMag
		end

		-- compute elbow position
		local elbowPos
		if dist > lenA + lenB then
			-- fully extended toward target (unreachable case)
			elbowPos = root + dir * lenA
		else
			-- standard triangle solution
			local a = (lenA * lenA + dist * dist - lenB * lenB) / (2 * dist)
			local hSq = lenA * lenA - a * a
			local h = hSq > 0 and math.sqrt(hSq) or 0
			elbowPos = root + dir * a + poleProj * h
		end

		-- forearm direction (bone next to hand)
		local boneDir = (goal - elbowPos).Unit

		-- project pole onto plane perpendicular to forearm for consistent roll/up
		local desiredUp = pole - boneDir * pole:Dot(boneDir)
		local upMag = desiredUp.Magnitude
		if upMag < 1e-6 then
			local arb = Vector3.yAxis
			if math.abs(boneDir:Dot(arb)) > 0.99 then
				arb = Vector3.xAxis
			end
			desiredUp = (arb - boneDir * arb:Dot(boneDir)).Unit
		else
			desiredUp /= upMag
		end

		-- CFrame at target with LookVector along bone (forward = boneDir from elbow → hand)
		-- and UpVector pole-projected so rotation respects "elbow points" direction
		return CFrame.lookAt(goal, goal + boneDir, desiredUp)
	end

	local rj, nj, rsj, lsj, rhj, lhj, scale

	local LegsTarget = {}
	local FakeVRArms = {}
	local Crouching = false
	local CrouchDistance = 0
	local TorsoRotation = CFrame.identity

	local CROUCH_DISTANCE = 1.25
	local LEG_TWEEN_TIME = 0.25
	local LEG_MOVE_TIME = 0.25

	local function GetLegPoint(leg)
		if leg.InAir then
			return leg.Position
		end
		local tweener = math.clamp(leg.Timer / LEG_TWEEN_TIME, 0, 1)
		return leg.Target:Lerp(leg.Position, tweener) + Vector3.new(0, math.sin(math.pi * tweener) * (leg.Target - leg.Position).Magnitude * 0.1, 0)
	end
	local function ProcessLegs(leg, dt)
		local last
		for _=1, 1 do
			last = Vector3.new(math.random() * 2 - 1, math.random() * 2 - 1, math.random() * 2 - 1) * 0.2
			for i=1, #leg.Realism do
				last = last:Lerp(leg.Realism[i], math.exp(-16 * dt))
				leg.Realism[i] = last
			end
		end
		local real = CFrame.Angles(last.X, last.Y, last.Z)
		local onground = hum:GetState() == Enum.HumanoidStateType.Running
		local origin = torso.CFrame * (leg.Offset * scale) + root.CFrame.LookVector * scale + root.Velocity * (LEG_MOVE_TIME * 0.6)
		local dir = (Vector3.new(0, -3, 0) - root.CFrame.LookVector * 1.5) * scale
		if hum:GetState() == Enum.HumanoidStateType.Climbing then
			onground = true
			origin = torso.CFrame * (leg.Offset * scale) + Vector3.new(0, -0.5, 0) * scale
			dir = root.CFrame.LookVector * 3 * scale
		end
		local tgt = leg.Position
		if onground then
			leg.Timer += dt / LEG_MOVE_TIME
			if leg.Timer >= 1 then
				leg.Timer %= 1
				leg.Target = leg.Position
				local cast = PhysicsRaycast(origin, dir)
				if cast then
					cast = cast.Position
				else
					cast = origin + Vector3.new(0, -2, 0)
				end
				leg.Position = cast
			end
			local tweener = math.clamp(leg.Timer / LEG_TWEEN_TIME, 0, 1)
			tgt = leg.Target:Lerp(leg.Position, tweener) + Vector3.new(0, math.sin(math.pi * tweener) * (leg.Target - leg.Position).Magnitude * 0.1, 0)
		else
			leg.InAir = true
			tgt = torso.CFrame * ((leg.Offset + Vector3.new(0, -1.3, -0.3)) * scale)
			tgt = tgt:Lerp(leg.Position + root.Velocity * dt, math.exp(-16 * dt))
			leg.Position = tgt
			leg.Target = tgt
		end
		if leg.InAir then
			leg.InAir = false
			leg.Timer = (leg.Timer % 1) + 1
		end
		local orig = torso.CFrame * (leg.Offset * scale)
		local dir = root.CFrame.Rotation * Vector3.new(leg.Offset.X, 0, -2)
		if (tgt - orig).Magnitude > 2.1 * scale then
			tgt = orig + (tgt - orig).Unit * 2.1 * scale
			return CFrame.lookAlong(tgt, tgt - orig, orig, dir) * real * CFrame.Angles(1.57, 0, 0) * CFrame.new(0, 1 * scale, 0)
		end
		return IK2Bone(orig, tgt, dir, 0.7 * scale, 1.2 * scale) * real * CFrame.Angles(1.57, 0, 0) * CFrame.new(0, 1 * scale, 0)
	end
	local function ProcessArms(arm, dt, vro, headcf)
		local last
		for _=1, 1 do
			last = Vector3.new(math.random() * 2 - 1, math.random() * 2 - 1, math.random() * 2 - 1) * 0.5
			for i=1, #arm.Realism do
				last = last:Lerp(arm.Realism[i], math.exp(-16 * dt))
				arm.Realism[i] = last
			end
		end
		local cast = PhysicsRaycast(vro.Position, headcf.LookVector * 32 * scale)
		if cast then
			cast = (cast.Position - vro.Position - arm.Offset.Position).Unit
			if cast ~= cast or cast.Magnitude == 0 then
				cast = headcf.LookVector
			end
		else
			cast = headcf.LookVector
		end
		local ha = CFrame.new(0, -0.5, 0) * CFrame.Angles(0.3 + last.X, last.Y, last.Z) * CFrame.new(0, -0.4, 0) * CFrame.Angles(-1.57, 0, 0)
		local hb = CFrame.lookAlong(Vector3.zero, cast) * CFrame.new(0, 0, -0.5) * CFrame.Angles(last.X, last.Y, last.Z) * CFrame.new(0, 0, -0.5)
		local tm = arm.Timer
		if arm.Waving then
			tm = math.min(1, tm + dt / 0.2)
		else
			tm = math.max(0, tm - dt / 0.2)
		end
		arm.Timer = tm
		return arm.Offset * ha:Lerp(hb, TweenService:GetValue(tm, Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut))
	end

	m.Init = function(figure: Model)
		hum = figure:FindFirstChild("Humanoid")
		root = figure:FindFirstChild("HumanoidRootPart")
		torso = figure:FindFirstChild("Torso")
		if not hum then return end
		if not root then return end
		if not torso then return end
		hum.WalkSpeed = 12
		--ReanimCamera.FPSLocked = true
		for _,v in figure:GetChildren() do
			if v:IsA("BasePart") then
				for _,w in figure:GetChildren() do
					if v ~= w and w:IsA("BasePart") then
						local nocoll = Instance.new("NoCollisionConstraint", v)
						nocoll.Part0, nocoll.Part1 = v, w
					end
				end
			end
		end
		LegsTarget = {
			{
				Position = root.CFrame * Vector3.new(-0.5, -3, 0),
				Offset = Vector3.new(-0.5, -1, 0),
				Target = root.CFrame * Vector3.new(-0.5, -3, 0),
				Timer = 0.5,
				Realism = {
					Vector3.zero,
					Vector3.zero,
					Vector3.zero,
					Vector3.zero,
				},
				InAir = false,
			},
			{
				Position = root.CFrame * Vector3.new(0.5, -3, 0),
				Offset = Vector3.new(0.5, -1, 0),
				Target = root.CFrame * Vector3.new(0.5, -3, 0),
				Timer = 0,
				Realism = {
					Vector3.zero,
					Vector3.zero,
					Vector3.zero,
					Vector3.zero,
				},
				InAir = false,
			},
		}
		FakeVRArms = {
			{
				Timer = 1,
				Realism = {
					Vector3.zero,
					Vector3.zero,
					Vector3.zero,
					Vector3.zero,
				},
				Waving = false,
				Offset = CFrame.new(-1.5, -1, 0),
			},
			{
				Timer = 1,
				Realism = {
					Vector3.zero,
					Vector3.zero,
					Vector3.zero,
					Vector3.zero,
				},
				Waving = false,
				Offset = CFrame.new(1.5, -1, 0),
			},
		}
		Crouching = false
		CrouchDistance = 0
		ContextActions:BindAction("Uhhhhhh_VRWaveL", function(_, state, _)
			if state == Enum.UserInputState.Begin then
				FakeVRArms[1].Waving = true
			end
			if state == Enum.UserInputState.End then
				FakeVRArms[1].Waving = false
			end
		end, true, Enum.UserInputType.MouseButton1)
		ContextActions:SetTitle("Uhhhhhh_VRWaveL", "L")
		ContextActions:SetPosition("Uhhhhhh_VRWaveL", UDim2.new(1, -230, 1, -130))
		ContextActions:BindAction("Uhhhhhh_VRWaveR", function(_, state, _)
			if state == Enum.UserInputState.Begin then
				FakeVRArms[2].Waving = true
			end
			if state == Enum.UserInputState.End then
				FakeVRArms[2].Waving = false
			end
		end, true, Enum.UserInputType.MouseButton2)
		ContextActions:SetTitle("Uhhhhhh_VRWaveR", "R")
		ContextActions:SetPosition("Uhhhhhh_VRWaveR", UDim2.new(1, -180, 1, -130))
		ContextActions:BindAction("Uhhhhhh_VRCrouch", function(_, state, _)
			if state == Enum.UserInputState.Begin then
				Crouching = not Crouching
			end
		end, true, Enum.KeyCode.C)
		ContextActions:SetTitle("Uhhhhhh_VRCrouch", "C")
		ContextActions:SetPosition("Uhhhhhh_VRCrouch", UDim2.new(1, -130, 1, -230))
		ContextActions:BindAction("Uhhhhhh_VRRun", function(_, state, _)
			if state == Enum.UserInputState.Begin then
				if hum.WalkSpeed == 12 then
					hum.WalkSpeed = 24
				else
					hum.WalkSpeed = 12
				end
			end
		end, true, Enum.KeyCode.LeftControl, Enum.KeyCode.ButtonB)
		ContextActions:SetTitle("Uhhhhhh_VRRun", "Run")
		ContextActions:SetPosition("Uhhhhhh_VRRun", UDim2.new(1, -180, 1, -230))
	end
	m.Update = function(dt: number, figure: Model)
		local t = os.clock()
		scale = figure:GetScale()
		isdancing = not not figure:GetAttribute("IsDancing")
		rcp.FilterDescendantsInstances = {figure, Player.Character}

		-- get vii
		hum = figure:FindFirstChild("Humanoid")
		root = figure:FindFirstChild("HumanoidRootPart")
		torso = figure:FindFirstChild("Torso")
		if not hum then return end
		if not root then return end
		if not torso then return end

		-- joints
		local rj = root:FindFirstChild("RootJoint")
		local nj = torso:FindFirstChild("Neck")
		local rsj = torso:FindFirstChild("Right Shoulder")
		local lsj = torso:FindFirstChild("Left Shoulder")
		local rhj = torso:FindFirstChild("Right Hip")
		local lhj = torso:FindFirstChild("Left Hip")

		if Crouching then
			CrouchDistance = CROUCH_DISTANCE + (CrouchDistance - CROUCH_DISTANCE) * math.exp(-16 * dt)
		else
			CrouchDistance *= math.exp(-16 * dt)
		end

		if not isdancing then
			rj.Enabled, nj.Enabled, rsj.Enabled, lsj.Enabled, rhj.Enabled, lhj.Enabled = false, false, false, false, false, false
			--hum.HipHeight = 2 * scale
			hum.HipHeight = 2 * scale - 2 - CrouchDistance * scale
			root.CustomPhysicalProperties = PhysicalProperties.new(3.15, 0.3, 0.5)
			local head = figure:FindFirstChild("Head")
			local rarm = figure:FindFirstChild("Right Arm")
			local larm = figure:FindFirstChild("Left Arm")
			local rleg = figure:FindFirstChild("Right Leg")
			local lleg = figure:FindFirstChild("Left Leg")
			local chead, clarm, crarm
			local vro = root.CFrame * CFrame.new(0, 1.5 * scale, 0)
			local vroot = root.CFrame
			vro += Vector3.new(0, CrouchDistance * scale, 0)
			vroot += Vector3.new(0, CrouchDistance * scale, 0)
			if VRService.VREnabled then
				chead, clarm, crarm = VRService:GetUserCFrame(Enum.UserCFrame.Head), VRService:GetUserCFrame(Enum.UserCFrame.LeftHand), VRService:GetUserCFrame(Enum.UserCFrame.RightHand)
				if ReanimCamera:IsFirstPerson() then
					local _, y, _ = chead:ToEulerAngles(Enum.RotationOrder.YXZ)
					vro *= CFrame.Angles(0, -y, 0)
				end
			else
				local x, y, z = root.CFrame.Rotation:ToObjectSpace(ReanimCamera.CFrame.Rotation):ToEulerAngles(Enum.RotationOrder.YXZ)
				if ReanimCamera:IsFirstPerson() then
					y *= 0
				else
					if math.abs(y) > math.pi / 2 then
						y = math.pi - y
					end
				end
				chead = CFrame.new(0, -0.5, 0) * CFrame.fromEulerAngles(x, y, z, Enum.RotationOrder.YXZ) * CFrame.new(0, 0.5, 0) + Vector3.new(0, -CrouchDistance, 0)
				clarm = ProcessArms(FakeVRArms[1], dt, vro, chead) + Vector3.new(0, -CrouchDistance, 0)
				crarm = ProcessArms(FakeVRArms[2], dt, vro, chead) + Vector3.new(0, -CrouchDistance, 0)
			end
			chead += chead.Position * (scale - 1)
			clarm += clarm.Position * (scale - 1)
			crarm += crarm.Position * (scale - 1)
			local armo = CFrame.Angles(1.57, 0, 0) * CFrame.new(0, 0, 0)
			SetCFrame(head, vro * chead)
			SetCFrame(larm, vro * clarm * armo)
			SetCFrame(rarm, vro * crarm * armo)
			local z1, z2 = vroot:PointToObjectSpace(GetLegPoint(LegsTarget[1])).Z, vroot:PointToObjectSpace(GetLegPoint(LegsTarget[2])).Z
			local yabai = CFrame.Angles(0, math.atan(z1 - z2) * 0.5 / scale, 0)
			TorsoRotation = yabai:Lerp(TorsoRotation, math.exp(-4 * dt))
			SetCFrame(torso, IK2Bone(
				vroot * Vector3.new(0, -3 * scale, 0),
				vro * chead * Vector3.new(0, -0.5 * scale, 0),
				-vroot.LookVector, 1.5 * scale, 1.5 * scale)
			 * CFrame.Angles(1.57, 3.14, 3.14) * CFrame.new(0, -1 * scale, 0) * TorsoRotation)
			SetCFrame(lleg, ProcessLegs(LegsTarget[1], dt))
			SetCFrame(rleg, ProcessLegs(LegsTarget[2], dt))
		else
			rj.Enabled, nj.Enabled, rsj.Enabled, lsj.Enabled, rhj.Enabled, lhj.Enabled = true, true, true, true, true, true
			hum.HipHeight = 2 * scale - 2
			root.CustomPhysicalProperties = nil
		end
	end
	m.Destroy = function(figure: Model?)
		ContextActions:UnbindAction("Uhhhhhh_VRWaveL")
		ContextActions:UnbindAction("Uhhhhhh_VRWaveR")
		ContextActions:UnbindAction("Uhhhhhh_VRCrouch")
		ContextActions:UnbindAction("Uhhhhhh_VRRun")
	end
	return m
end)

return modules