local modules = {}
function AddModule(m)
	table.insert(modules, m)
end

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

	local hstatechange, hrun = nil

	local lastpose = ""
	local pose = "Standing"
	local toolAnim = "None"
	local toolAnimTime = 0

	local rng = Random.new(math.random(-65536, 65536))
	local sndpoint = nil

	local lastupdate = 0
	local rs, ls, rh, lh = {V = 0, D = 0, C = 0}, {V = 0, D = 0, C = 0}, {V = 0, D = 0, C = 0}, {V = 0, D = 0, C = 0}

	m.Init = function(figure: Model)
		local hum = figure:FindFirstChild("Humanoid")
		hum.AutoRotate = true
		hum.WalkSpeed = 16
		hum.JumpPower = 50
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
				hum.AutoRotate = false
				hum.HipHeight = -1
			elseif state == "Freefall" then
				pose = "Freefall"
				hum.AutoRotate = false
				hum.HipHeight = -1
			elseif state == "Landed" then
				pose = "Freefall"
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
			elseif state == "Climbing" then
				pose = "Climbing"
			elseif state == "Seated" then
				pose = "Seated"
			elseif state == "Swimming" then
				pose = "Running"
			elseif state == "Running" then
				-- handled by run connection
			elseif state == "PlatformStand" then
				pose = "Standing"
			elseif state == "GettingUp" then
				pose = "GettingUp"
				hum.AutoRotate = false
				hum.HipHeight = -1
			elseif state == "Ragdoll" then
				pose = "Running"
			elseif state == "FallingDown" then
				pose = "FallingDown"
			else
				pose = "Standing"
			end
		end)
	end
	m.Update = function(dt: number, figure: Model)
		local t = tick()
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

			if pose == "Running" then
				rs.V = 0.15
				ls.V = 0.15
				rh.V = 0.15
				lh.V = 0.15
			elseif pose == "Climbing" then
				rs.V = 0.5
				ls.V = 0.5
				rh.V = 0.5
				lh.V = 0.5
				climbFudge = 3.14
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
	end
	return m
end)
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
	m.Name = "Uhhhhhh"
	--m.Description = "ik technologia\nMoveset with REAL IK Procedural animation. That means no keyframes!"
	m.Description = "unfinished thing"
	m.Assets = {}

	m.Config = function(parent: GuiBase2d)
	end

	local cassprint = RandomString(32)

	local function SetMotor6DOffset(motor, offset, dt)
		motor.Transform = (motor.C0:Inverse() * offset * motor.C1):Lerp(motor.Transform, math.exp(-32 * dt))
	end

	local function IKTarget(a, z)
		local r = 1.02
		local d = r * 2
		local q = r / 2
		local b = Vector3.zero
		local v = b - a
		local l = v.Magnitude
		local m = a + v.Unit * r
		if l < d then
			local h = math.sqrt(r * r - (l * l) / 4)
			local g = v / 2
			m = a + g + z.Unit * h
		end
		m = a + (m - a).Unit * r
		return CFrame.lookAt(m, a, z) * CFrame.Angles(math.pi * 0.5, 0, 0)
	end

	local function sigmoid(x)
		return 1 / (1 + math.exp(-x))
	end
	local function Path_w(t)
		t = t % 1
		local g = t + ((math.pow(2 * t - 1, 3) + 1) / 2 - t) * 0.5
		local x = 2 * math.pi * g
		return Vector2.new(math.sin(x), math.max(0, (math.exp(2 * math.cos(x)) - 0.8) / 4))
	end
	local function Path_r(t)
		t = t % 1
		local x = 2 * math.pi * t
		return Vector2.new(math.sin(x), math.max(0, (math.exp(2 * math.cos(x)) - 0.4) / 2))
	end

	local running = false
	local animtime = 0

	m.Init = function(figure: Model)
		running = false
		ContextActionService:BindAction(cassprint, function(_, state, input)
			if state == Enum.UserInputState.Begin then
				running = not running
			end
		end, true, Enum.KeyCode.LeftShift)
		ContextActionService:SetTitle(cassprint, "Run")
	end
	m.Update = function(dt: number, figure: Model)
		local t = tick()
		local hum = figure:FindFirstChild("Humanoid")
		if not hum then return end
		local root = figure:FindFirstChild("HumanoidRootPart")
		if not root then return end
		local torso = figure:FindFirstChild("Torso")
		if not torso then return end
		local rsj = torso:FindFirstChild("Right Shoulder")
		local lsj = torso:FindFirstChild("Left Shoulder")
		local rhj = torso:FindFirstChild("Right Hip")
		local lhj = torso:FindFirstChild("Left Hip")
		if not (rsj and lsj and rhj and lhj) then return end
		local tspeed = 6.67
		if running then tspeed = 25 end
		hum.WalkSpeed = tspeed + (hum.WalkSpeed - tspeed) * math.exp(-0.5 * dt)
		local persp = root.CFrame:VectorToObjectSpace(root.Velocity)
		local speed = (persp * Vector3.new(1, 0, 1)).Magnitude
		animtime = (animtime + (speed / 13.33) * dt) % 1
		local runwalk = sigmoid((speed - 16) / 8)
		local legl = Path_w(animtime):Lerp(Path_r(animtime), runwalk)
		local legr = Path_w(animtime + 0.5):Lerp(Path_r(animtime + 0.5), runwalk)
		legl *= Vector2.new(1, sigmoid(speed))
		legr *= Vector2.new(1, sigmoid(speed))
		local arms = math.sin(2 * math.pi * animtime)
		local breathe = math.sin(math.pi * animtime * 0.125) * 0.05
		local cf = CFrame.Angles(arms * math.pi * speed / 50, 0, 0)
		cf += Vector3.new(-1.5, 0.5, 0)
		cf *= CFrame.new(0, -1, 0)
		cf *= CFrame.Angles(math.pi * speed / 50, 0, breathe - 0.05)
		cf *= CFrame.new(0, 0.5, 0)
		SetMotor6DOffset(lsj, cf, dt)
		arms *= -1
		cf = CFrame.Angles(arms * math.pi * speed / 50, 0, 0)
		cf += Vector3.new(1.5, 0.5, 0)
		cf *= CFrame.new(0, -1, 0)
		cf *= CFrame.Angles(math.pi * speed / 50, 0, breathe + 0.05)
		cf *= CFrame.new(0, 0.5, 0)
		SetMotor6DOffset(rsj, cf, dt)
		local lz = Vector3.new(0, 0, -1)
		local e = 13.33
		cf = IKTarget(Vector3.new(legl.X * persp.X / e, legl.Y - 2, legl.X * persp.Z / e), lz)
		cf += Vector3.new(-0.5, -1, 0)
		SetMotor6DOffset(lhj, cf, dt)
		cf = IKTarget(Vector3.new(legr.X * persp.X / e, legr.Y - 2, legr.X * persp.Z / e), lz)
		cf += Vector3.new(0.5, -1, 0)
		SetMotor6DOffset(rhj, cf, dt)
	end
	m.Destroy = function(figure: Model?)
		ContextActionService:UnbindAction(cassprint)
	end
	--return m
end)

AddModule(function()
	local m = {}
	m.ModuleType = "DANCE"
	m.Name = "Rat Dance"
	m.Description = "how did this even become a meme\ngoogle ai says this is a tiktok trend\ncant be sure"
	m.Assets = {"RatDance.anim", "RatDance.mp3"}

	m.Config = function(parent: GuiBase2d)
	end

	local animator = nil
	local start = 0
	m.Init = function(figure: Model)
		SetOverrideMusic(AssetGetContentId("RatDance.mp3"), "Chess Type Beat Slowed")
		start = tick()
		animator = AnimLib.Animator.new()
		animator.rig = figure
		animator.track = AnimLib.Track.fromfile(AssetGetPathFromFilename("RatDance.anim"))
		animator.looped = true
		animator.speed = 1.15
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

return modules