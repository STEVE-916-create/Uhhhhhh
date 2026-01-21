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

	local hierarch = {
		GetAttribute = function(self, name)
			return nil
		end,
		WaitForChild = function(self, name)
			return self[name]
		end,
	}
	local SM64RobloxUrl = "https://raw.githubusercontent.com/MaximumADHD/sm64-roblox/refs/heads/main"
	local SM64Hierarchy = setmetatable({}, hierarch)
	SM64Hierarchy.Parent = SM64Hierarchy
	local function CreateHierarch(name, pathe, parent)
		local h = setmetatable({}, hierarch)
		local hash = 0
		for i=1, #pathe do
			hash += string.byte(pathe:sub(i, i)) + i
		end
		hash = hash:rep(16):sub(1, 16)
		hash = "SM64_" .. hash .. ".lua"
		table.insert(m.Assets, hash .. "@" .. SM64RobloxUrl .. "/client/" .. pathe)
		h.Source = hash
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
	CreateHierarch("Flags", "Types/Flags.lua", SM64Hierarchy)
	CreateHierarch("Util", "Util/init.lua", SM64Hierarchy)
	local cache = {}
	local newrequire = nil
	newrequire = function(m)
		if m.Source then
			if not cache[m] then
				local f = loadstring(readfile(AssetGetPathFromFilename(m.Source)))
				local env = loadstring("return getfenv")()(f)
				env.require = newrequire
				env.script = m
				cache[m] = f()
			end
			return cache[m]
		end
		error("Invalid argument.")
	end
	local Sounds = {}
	local Enums = newrequire(SM64Hierarchy.Enums)
	local Mario = newrequire(SM64Hierarchy.Mario)
	local Types = newrequire(SM64Hierarchy.Types)
	local Util = newrequire(SM64Hierarchy.Util)
	local Action = Enums.Action
	local Buttons = Enums.Buttons
	local MarioFlags = Enums.MarioFlags
	local ParticleFlags = Enums.ParticleFlags
	local mario = Mario.new()
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
	bindInput(Buttons.B_BUTTON, "B", Enum.UserInputType.MouseButton1, Enum.KeyCode.ButtonX)
	bindInput(Buttons.Z_TRIG, "Z", Enum.KeyCode.LeftShift, Enum.KeyCode.RightShift, Enum.KeyCode.ButtonL2, Enum.KeyCode.ButtonR2)
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
				warn("particle not found:", name)
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
	local isTeleTravel = false
	local teleConn = nil
	m.Init = function(figure)
		local root = figure:FindFirstChild("HumanoidRootPart")
		uisb = UserInputService.InputBegan:Connect(processInput)
		uisc = UserInputService.InputChanged:Connect(processInput)
		uise = UserInputService.InputEnded:Connect(processInput)
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
		local neck = pcall(function() return figure.Torso.Neck end)
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
	end
	return m
end)

return modules