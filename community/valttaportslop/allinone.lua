local modules = {}

table.insert(modules, function()
	local m = {}

	m.ModuleType  = "DANCE"
	m.Name        = "Birdbrain V2"
	m.Description = "Basically that rare birdbrain variant from birdbrain v1"
	m.Assets      = {"Birdbrainv2.anim@https://github.com/valttasar/Valttas-Port-Content/raw/refs/heads/main/Birdbrain%20V2/Birdbrainv2.anim", "BirdbrainAlt.mp3"}

	m.Config = function(parent)
		Util_CreateText(parent, "No settings.", 14, Enum.TextXAlignment.Center)
	end

	m.SaveConfig = function() return {} end
	m.LoadConfig  = function(save) end

	local animator = nil
	local start    = 0

	m.Init = function(figure)
		SetOverrideDanceMusic(AssetGetContentId("BirdbrainAlt.mp3"), "Birdbrain V2", 0.8, NumberRange.new(0, 999))

		start           = os.clock()
		animator        = AnimLib.Animator.new()
		animator.rig    = figure
		animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("Birdbrainv2.anim"))
		animator.looped = true
		animator.speed  = 1
	end

	m.Update = function(dt, figure)
		animator:Step(os.clock() - start)
	end

	m.Destroy = function(figure)
		animator = nil
	end

	return m
end)

table.insert(modules, function()
	local m = {}

	m.ModuleType  = "DANCE"
	m.Name        = "Bouncin"
	m.Description = "boppin' WHAT!?\n\nboppin' WHAT!?\n\nboppin' WHAT!?"
	m.Assets      = {"Bouncin.anim@https://github.com/valttasar/Valttas-Port-Content/raw/refs/heads/main/Bouncin/Bouncin.anim", "Bouncin.mp3@https://github.com/valttasar/Valttas-Port-Content/raw/refs/heads/main/Bouncin/Bouncin.mp3"}

	m.Config = function(parent)
		Util_CreateText(parent, "No settings.", 14, Enum.TextXAlignment.Center)
	end

	m.SaveConfig = function() return {} end
	m.LoadConfig  = function(save) end

	local animator = nil
	local start    = 0

	m.Init = function(figure)
		SetOverrideDanceMusic(AssetGetContentId("Bouncin.mp3"), "Bouncin", 0.8, NumberRange.new(0, 50.16))

		start           = os.clock()
		animator        = AnimLib.Animator.new()
		animator.rig    = figure
		animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("Bouncin.anim"))
		animator.looped = true
		animator.speed  = 1
	end

	m.Update = function(dt, figure)
		animator:Step(os.clock() - start)
	end

	m.Destroy = function(figure)
		animator = nil
	end

	return m
end)

table.insert(modules, function()
	local m = {}

	m.ModuleType  = "DANCE"
	m.Name        = "Competent"
	m.Description = "ts so glee :D:D:D:D:D:D"
	m.Assets      = {"Competent.anim@https://github.com/valttasar/Valttas-Port-Content/raw/refs/heads/main/Competent/Competent.anim", "Competent.mp3@https://github.com/valttasar/Valttas-Port-Content/raw/refs/heads/main/Competent/Competent.mp3"}

	m.Config = function(parent)
		Util_CreateText(parent, "No settings.", 14, Enum.TextXAlignment.Center)
	end

	m.SaveConfig = function() return {} end
	m.LoadConfig  = function(save) end

	local animator = nil
	local start    = 0

	m.Init = function(figure)
		SetOverrideDanceMusic(AssetGetContentId("Competent.mp3"), "Competent", 0.8, NumberRange.new(0, 999))

		start           = os.clock()
		animator        = AnimLib.Animator.new()
		animator.rig    = figure
		animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("Competent.anim"))
		animator.looped = true
		animator.speed  = 1
	end

	m.Update = function(dt, figure)
		animator:Step(os.clock() - start)
	end

	m.Destroy = function(figure)
		animator = nil
	end

	return m
end)

table.insert(modules, function()
	local m = {}

	m.ModuleType  = "DANCE"
	m.Name        = "Dare"
	m.Description = "Noodle is such a girly idol <3"
	m.Assets      = {"Dare.anim@https://github.com/valttasar/Valttas-Port-Content/raw/refs/heads/main/Dare/Dare.anim", "Dare.mp3@https://github.com/valttasar/Valttas-Port-Content/raw/refs/heads/main/Dare/Dare.mp3"}

	m.Config = function(parent)
		Util_CreateText(parent, "No settings.", 14, Enum.TextXAlignment.Center)
	end

	m.SaveConfig = function() return {} end
	m.LoadConfig  = function(save) end

	local animator = nil
	local start    = 0

	m.Init = function(figure)
		SetOverrideDanceMusic(AssetGetContentId("Dare.mp3"), "Dare", 0.8, NumberRange.new(0, 999))

		start           = os.clock()
		animator        = AnimLib.Animator.new()
		animator.rig    = figure
		animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("Dare.anim"))
		animator.looped = true
		animator.speed  = 1
	end

	m.Update = function(dt, figure)
		animator:Step(os.clock() - start)
	end

	m.Destroy = function(figure)
		animator = nil
	end

	return m
end)

table.insert(modules, function()
	local m = {}

	m.ModuleType  = "DANCE"
	m.Name        = "Doomer"
	m.Description = "GG desu GG desu"
	m.Assets      = {"Doomer.anim@https://github.com/valttasar/Valttas-Port-Content/raw/refs/heads/main/Doomer/Doomer.anim", "Doomer2.anim@https://github.com/valttasar/Valttas-Port-Content/raw/refs/heads/main/Doomer/Doomer2.anim", "Doomer.mp3@https://github.com/valttasar/Valttas-Port-Content/raw/refs/heads/main/Doomer/Doomer.mp3"}

	m.Alternative = false
	m.Config = function(parent)
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
		start = os.clock()
		animator        = AnimLib.Animator.new()
		animator.rig    = figure
		animator.looped = true
		animator.speed  = 1
		if m.Alternative then
			animator.track = AnimLib.Track.fromfile(AssetGetPathFromFilename("Doomer2.anim"))
			SetOverrideDanceMusic(AssetGetContentId("Doomer.mp3"), "Doomer", 1, NumberRange.new(0, 22.54))
		else
			animator.track = AnimLib.Track.fromfile(AssetGetPathFromFilename("Doomer.anim"))
			SetOverrideDanceMusic(AssetGetContentId("Doomer.mp3"), "Doomer", 1, NumberRange.new(0, 28.92))
		end
	end

	m.Update = function(dt, figure)
		animator:Step(os.clock() - start)
	end

	m.Destroy = function(figure)
		animator = nil
	end

	return m
end)

table.insert(modules, function()
	local m = {}
	m.ModuleType = "DANCE"
	m.Name = "Eyes Closed"
	m.Description = "performative male's favorite artist but fyeeee"
	m.Assets = {"Eyesclosed.anim@https://github.com/valttasar/Valttas-Port-Content/raw/refs/heads/main/Eyes%20Closed/Eyesclosed.anim", "Eyesclosed.mp3@https://github.com/valttasar/Valttas-Port-Content/raw/refs/heads/main/Eyes%20Closed/Eyesclosed.mp3"}

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

	local animator = nil
	local start = 0
	local instances = {}
	local ringPart = nil
	local ringBars = {}
	local ringSegments = 64
	local ghostTimer = 0
	local activeGhosts = {}
	local ghostColor = Color3.fromRGB(0, 255, 255)

	local function spawnGhost(figure)
		local ghost = Instance.new("Model")
		ghost.Name = "EyesClosedGhost"
		local parts = {"Head", "Torso", "Left Arm", "Right Arm", "Left Leg", "Right Leg"}
		for _, name in parts do
			local src = figure:FindFirstChild(name)
			if not src then continue end
			local p = Instance.new("Part")
			p.Name = name
			p.Anchored = true
			p.CanCollide = false
			p.CanTouch = false
			p.CanQuery = false
			p.CastShadow = false
			p.Color = ghostColor
			p.Material = Enum.Material.Neon
			p.Transparency = 0.55
			if name == "Head" then
				p.Shape = Enum.PartType.Cylinder
				p.Size = Vector3.new(src.Size.Y, src.Size.X, src.Size.Z)
				p.CFrame = src.CFrame * CFrame.Angles(0, 0, math.pi / 2)
			else
				p.Shape = Enum.PartType.Block
				p.Size = src.Size
				p.CFrame = src.CFrame
			end
			local light = Instance.new("PointLight")
			light.Brightness = 1.5
			light.Range = 5
			light.Color = ghostColor
			light.Parent = p
			p.Parent = ghost
		end
		ghost.Parent = workspace
		table.insert(activeGhosts, {model = ghost, elapsed = 0})
	end

	local function updateGhosts(dt)
		local i = 1
		while i <= #activeGhosts do
			local g = activeGhosts[i]
			g.elapsed += dt
			local alpha = g.elapsed / 1.0
			if alpha >= 1 then
				g.model:Destroy()
				table.remove(activeGhosts, i)
			else
				for _, p in g.model:GetChildren() do
					if p:IsA("BasePart") then
						p.Transparency = 0.55 + alpha * 0.45
						local t = 1 - alpha
						p.Color = Color3.fromRGB(
							math.floor(ghostColor.R * 255 * t),
							math.floor(ghostColor.G * 255 * t),
							math.floor(ghostColor.B * 255 * t)
						)
					end
				end
				i += 1
			end
		end
	end

	local function makeEmitters(parent, scale)
		local glow = Instance.new("ParticleEmitter")
		glow.Parent = parent
		glow.LightInfluence = 0
		glow.LightEmission = 1
		glow.Brightness = 2.5
		glow.ZOffset = -1
		glow.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(200, 230, 255)),
			ColorSequenceKeypoint.new(0.4, Color3.fromRGB(80, 160, 255)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 60, 220)),
		})
		glow.Orientation = Enum.ParticleOrientation.FacingCamera
		glow.Size = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 1.4 * scale),
			NumberSequenceKeypoint.new(0.3, 1.0 * scale),
			NumberSequenceKeypoint.new(0.7, 0.45 * scale),
			NumberSequenceKeypoint.new(1, 0),
		})
		glow.Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 0.05),
			NumberSequenceKeypoint.new(0.4, 0.3),
			NumberSequenceKeypoint.new(0.8, 0.65),
			NumberSequenceKeypoint.new(1, 1),
		})
		glow.Texture = "rbxasset://textures/particles/sparkles_main.dds"
		glow.Lifetime = NumberRange.new(0.18, 0.30)
		glow.Rate = 50
		glow.Speed = NumberRange.new(1.0 * scale, 2.5 * scale)
		glow.SpreadAngle = Vector2.new(45, 45)
		glow.Rotation = NumberRange.new(0, 360)
		glow.RotSpeed = NumberRange.new(-80, 80)
		glow.LockedToPart = false
		glow.Enabled = true
		local sparks = Instance.new("ParticleEmitter")
		sparks.Parent = parent
		sparks.LightInfluence = 0
		sparks.LightEmission = 0.7
		sparks.Brightness = 1.8
		sparks.ZOffset = 0
		sparks.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
			ColorSequenceKeypoint.new(0.2, Color3.fromRGB(160, 210, 255)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 100, 255)),
		})
		sparks.Orientation = Enum.ParticleOrientation.VelocityPerpendicular
		sparks.Size = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 0.07 * scale),
			NumberSequenceKeypoint.new(0.5, 0.04 * scale),
			NumberSequenceKeypoint.new(1, 0),
		})
		sparks.Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 0),
			NumberSequenceKeypoint.new(0.5, 0.35),
			NumberSequenceKeypoint.new(1, 1),
		})
		sparks.Texture = "rbxasset://textures/particles/sparkles_main.dds"
		sparks.Lifetime = NumberRange.new(0.12, 0.28)
		sparks.Rate = 65
		sparks.Speed = NumberRange.new(2.0 * scale, 5.0 * scale)
		sparks.SpreadAngle = Vector2.new(65, 65)
		sparks.Rotation = NumberRange.new(0, 360)
		sparks.RotSpeed = NumberRange.new(-120, 120)
		sparks.LockedToPart = false
		sparks.Enabled = true
		local light = Instance.new("PointLight")
		light.Brightness = 1.2
		light.Range = 5 * scale
		light.Color = Color3.fromRGB(60, 130, 255)
		light.Shadows = false
		light.Parent = parent
		return {glow, sparks, light}
	end

	local function buildFace(part, face, scale)
		local sgui = Instance.new("SurfaceGui")
		sgui.Name = "RingGui_" .. tostring(face)
		sgui.Face = face
		sgui.LightInfluence = 0
		sgui.Brightness = 4
		sgui.AlwaysOnTop = false
		sgui.MaxDistance = 60
		sgui.SizingMode = Enum.SurfaceGuiSizingMode.FixedSize
		sgui.CanvasSize = Vector2.new(256, 256)
		sgui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
		sgui.Parent = part
		local bg = Instance.new("Frame")
		bg.Size = UDim2.new(1, 0, 1, 0)
		bg.BackgroundTransparency = 1
		bg.BorderSizePixel = 0
		bg.Parent = sgui
		local bars = {}
		local cx, cy = 128, 128
		local innerR = 88
		local barW = 5
		local flip = (face == Enum.NormalId.Bottom) and -1 or 1
		for i = 1, ringSegments do
			local angle = flip * (i / ringSegments) * math.pi * 2
			local bar = Instance.new("Frame")
			bar.Name = "Bar" .. i
			bar.AnchorPoint = Vector2.new(0.5, 1)
			bar.BackgroundColor3 = Color3.fromRGB(80, 160, 255)
			bar.BorderSizePixel = 0
			bar.BackgroundTransparency = 0
			bar.Position = UDim2.new(0, cx + innerR * math.cos(angle) - barW / 2, 0, cy + innerR * math.sin(angle))
			bar.Size = UDim2.new(0, barW, 0, 2)
			bar.Rotation = math.deg(angle) + 90
			bar.Parent = bg
			local stroke = Instance.new("UIStroke")
			stroke.Color = Color3.fromRGB(140, 210, 255)
			stroke.Thickness = 1.5
			stroke.Transparency = 0.2
			stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
			stroke.Parent = bar
			table.insert(bars, bar)
		end
		table.insert(instances, sgui)
		return bars
	end

	local function makeRing(figure)
		local scale = figure:GetScale()
		ringPart = Instance.new("Part")
		ringPart.Name = "RingVisualizer"
		ringPart.Anchored = true
		ringPart.CanCollide = false
		ringPart.CanTouch = false
		ringPart.CanQuery = false
		ringPart.Transparency = 1
		ringPart.Size = Vector3.new(8 * scale, 0.01, 8 * scale)
		ringPart.Parent = figure
		table.insert(instances, ringPart)
		local topBars = buildFace(ringPart, Enum.NormalId.Top, scale)
		local bottomBars = buildFace(ringPart, Enum.NormalId.Bottom, scale)
		ringBars = {}
		for i = 1, ringSegments do
			table.insert(ringBars, {top = topBars[i], bottom = bottomBars[i]})
		end
	end

	m.Init = function(figure: Model)
		SetOverrideDanceMusic(AssetGetContentId("Eyesclosed.mp3"), "Eyes Closed", 0.8, NumberRange.new(0, 26.70))
		start = os.clock()
		animator = AnimLib.Animator.new()
		animator.rig = figure
		animator.track = AnimLib.Track.fromfile(AssetGetPathFromFilename("Eyesclosed.anim"))
		animator.looped = true
		for _,v in instances do v:Destroy() end
		for _,g in activeGhosts do g.model:Destroy() end
		instances = {}
		ringBars = {}
		ringPart = nil
		activeGhosts = {}
		ghostTimer = 0
		if m.Effects then
			local scale = figure:GetScale()
			for _, name in {"Left Arm", "Right Arm", "Left Leg", "Right Leg"} do
				local limb = figure:FindFirstChild(name)
				if not limb then continue end
				for _, inst in makeEmitters(limb, scale) do
					table.insert(instances, inst)
				end
			end
			makeRing(figure)
		end
	end
	m.Update = function(dt: number, figure: Model)
		animator:Step(os.clock() - start)
		if m.Effects then
			ghostTimer += dt
			if ghostTimer >= 0.5 then
				ghostTimer = 0
				spawnGhost(figure)
			end
			updateGhosts(dt)
		end
		if not ringPart or #ringBars == 0 then return end
		local root = figure:FindFirstChild("HumanoidRootPart")
		if not root then return end
		local scale = figure:GetScale()
		local head = figure:FindFirstChild("Head")
		local headY = head and head.Position.Y or root.Position.Y
		ringPart.CFrame = CFrame.new(root.Position.X, headY + 3.2 * scale, root.Position.Z)
		local t = GetOverrideDanceMusicTime()
		for i, pair in ringBars do
			local frac = (i - 1) / ringSegments
			local phase = frac * math.pi * 2
			local bass = math.abs(math.sin(t * 2.1 + phase * 0.5))
			local mid = math.abs(math.sin(t * 5.3 + phase * 1.2 + 1.1))
			local treble = math.abs(math.sin(t * 11.7 + phase * 2.5 + 2.3))
			local amplitude = (bass * 0.55 + mid * 0.30 + treble * 0.15) * (0.75 + 0.25 * math.sin(t * 3.14))
			local barH = math.max(2, math.floor(amplitude * 28))
			local col = Color3.fromRGB(
				math.floor(40 + amplitude * 100),
				math.floor(120 + amplitude * 110),
				255
			)
			local sz = UDim2.new(0, 5, 0, barH)
			pair.top.Size = sz
			pair.top.BackgroundColor3 = col
			pair.bottom.Size = sz
			pair.bottom.BackgroundColor3 = col
		end
	end
	m.Destroy = function(figure: Model?)
		animator = nil
		ringPart = nil
		ringBars = {}
		for _,v in instances do v:Destroy() end
		for _,g in activeGhosts do g.model:Destroy() end
		instances = {}
		activeGhosts = {}
		ghostTimer = 0
	end
	return m
end)

table.insert(modules, function()
	local m = {}

	m.ModuleType  = "DANCE"
	m.Name        = "I Came To Goon"
	m.Description = "A peanut butter house, I beat it in"
	m.Assets      = {"Cametogoon.anim@https://github.com/valttasar/Valttas-Port-Content/raw/refs/heads/main/Came%20To%20Goon/Cametogoon.anim", "Cametogoon.mp3@https://github.com/valttasar/Valttas-Port-Content/raw/refs/heads/main/Came%20To%20Goon/Cametogoon.mp3"}

	m.Config = function(parent)
		Util_CreateText(parent, "No settings.", 14, Enum.TextXAlignment.Center)
	end

	m.SaveConfig = function() return {} end
	m.LoadConfig  = function(save) end

	local animator = nil
	local start    = 0

	m.Init = function(figure)
		SetOverrideDanceMusic(AssetGetContentId("Cametogoon.mp3"), "I Came To Goon", 0.8, NumberRange.new(0, 999))

		start           = os.clock()
		animator        = AnimLib.Animator.new()
		animator.rig    = figure
		animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("Cametogoon.anim"))
		animator.looped = true
		animator.speed  = 1
	end

	m.Update = function(dt, figure)
		animator:Step(os.clock() - start)
	end

	m.Destroy = function(figure)
		animator = nil
	end

	return m
end)

table.insert(modules, function()
	local m = {}

	m.ModuleType  = "DANCE"
	m.Name        = "Iris Out"
	m.Description = "Really... why didn't I kill you the first time we met? Denji"
	m.Assets      = {"Irisout.anim@https://github.com/valttasar/Valttas-Port-Content/raw/refs/heads/main/Iris%20Out/Irisout.anim", "Irisout.mp3@https://github.com/valttasar/Valttas-Port-Content/raw/refs/heads/main/Iris%20Out/Irisout.mp3"}

	m.Config = function(parent)
		Util_CreateText(parent, "No settings.", 14, Enum.TextXAlignment.Center)
	end

	m.SaveConfig = function() return {} end
	m.LoadConfig  = function(save) end

	local animator = nil
	local start    = 0

	m.Init = function(figure)
		SetOverrideDanceMusic(AssetGetContentId("Irisout.mp3"), "Iris Out", 0.8, NumberRange.new(0, 16.16))

		start           = os.clock()
		animator        = AnimLib.Animator.new()
		animator.rig    = figure
		animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("Irisout.anim"))
		animator.looped = true
		animator.speed  = 1
	end

	m.Update = function(dt, figure)
		animator:Step(os.clock() - start)
	end

	m.Destroy = function(figure)
		animator = nil
	end

	return m
end)

table.insert(modules, function()
	local m = {}

	m.ModuleType  = "DANCE"
	m.Name        = "Liar Dancer"
	m.Description = "yall WHO is this :shrug:"
	m.Assets      = {"Liardancer.anim@https://github.com/valttasar/Valttas-Port-Content/raw/refs/heads/main/Liar%20Dance/Liardancer.anim", "Liardancer.mp3@https://github.com/valttasar/Valttas-Port-Content/raw/refs/heads/main/Liar%20Dance/Liardancer.mp3"}

	m.Config = function(parent)
		Util_CreateText(parent, "No settings.", 14, Enum.TextXAlignment.Center)
	end

	m.SaveConfig = function() return {} end
	m.LoadConfig  = function(save) end

	local animator = nil
	local start    = 0

	m.Init = function(figure)
		SetOverrideDanceMusic(AssetGetContentId("Liardancer.mp3"), "Liar Dancer", 0.8, NumberRange.new(0, 45.5))

		start           = os.clock()
		animator        = AnimLib.Animator.new()
		animator.rig    = figure
		animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("Liardancer.anim"))
		animator.looped = true
		animator.speed  = 1
	end

	m.Update = function(dt, figure)
		animator:Step(os.clock() - start)
	end

	m.Destroy = function(figure)
		animator = nil
	end

	return m
end)

table.insert(modules, function()
	local m = {}

	m.ModuleType  = "DANCE"
	m.Name        = "Lil Buddy Was Sick"
	m.Description = "I done got rich yeah, with no advance 🤑"
	m.Assets      = {"Lilbuddy.anim@https://github.com/valttasar/Valttas-Port-Content/raw/refs/heads/main/Lil%20Buddy/Lilbuddy.anim", "Lilbuddy.mp3@https://github.com/valttasar/Valttas-Port-Content/raw/refs/heads/main/Lil%20Buddy/Lilbuddy.mp3"}

	m.Config = function(parent)
		Util_CreateText(parent, "No settings.", 14, Enum.TextXAlignment.Center)
	end

	m.SaveConfig = function() return {} end
	m.LoadConfig  = function(save) end

	local animator = nil
	local start    = 0

	m.Init = function(figure)
		SetOverrideDanceMusic(AssetGetContentId("Lilbuddy.mp3"), "Lil Buddy Was Sick", 0.8, NumberRange.new(0, 13.23))

		start           = os.clock()
		animator        = AnimLib.Animator.new()
		animator.rig    = figure
		animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("Lilbuddy.anim"))
		animator.looped = true
		animator.speed  = 1
	end

	m.Update = function(dt, figure)
		animator:Step(os.clock() - start)
	end

	m.Destroy = function(figure)
		animator = nil
	end

	return m
end)

table.insert(modules, function()
	local m = {}

	m.ModuleType  = "DANCE"
	m.Name        = "Low Cortisol"
	m.Description = "Agnes Tachyon, Low Cortisol Uma"
	m.Assets      = {"Lowcortisol.anim@https://github.com/valttasar/Valttas-Port-Content/raw/refs/heads/main/Low%20Cortisol/Lowcortisol.anim", "Lowcortisol.mp3@https://github.com/valttasar/Valttas-Port-Content/raw/refs/heads/main/Low%20Cortisol/Lowcortisol.mp3"}

	m.Config = function(parent)
		Util_CreateText(parent, "No settings.", 14, Enum.TextXAlignment.Center)
	end

	m.SaveConfig = function() return {} end
	m.LoadConfig  = function(save) end

	local animator = nil
	local start    = 0

	m.Init = function(figure)
		SetOverrideDanceMusic(AssetGetContentId("Lowcortisol.mp3"), "Low Cortisol", 0.8, NumberRange.new(0, 999))

		start           = os.clock()
		animator        = AnimLib.Animator.new()
		animator.rig    = figure
		animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("Lowcortisol.anim"))
		animator.looped = true
		animator.speed  = 1
	end

	m.Update = function(dt, figure)
		animator:Step(os.clock() - start)
	end

	m.Destroy = function(figure)
		animator = nil
	end

	return m
end)

table.insert(modules, function()
	local m = {}

	m.ModuleType  = "DANCE"
	m.Name        = "Otsukare Summer"
	m.Description = "otsukare summer awai yumemishi otome wa hitoshirezu crying :sob:"
	m.Assets      = {"OtsukareSummer.anim@https://github.com/valttasar/Valttas-Port-Content/raw/refs/heads/main/Otsukare%20Summer/OtsukareSummer.anim", "OtsukareSummer.mp3@https://github.com/valttasar/Valttas-Port-Content/raw/refs/heads/main/Otsukare%20Summer/OtsukareSummer.mp3"}

	m.Config = function(parent)
		Util_CreateText(parent, "No settings.", 14, Enum.TextXAlignment.Center)
	end

	m.SaveConfig = function() return {} end
	m.LoadConfig  = function(save) end

	local animator = nil
	local start    = 0

	m.Init = function(figure)
		SetOverrideDanceMusic(AssetGetContentId("OtsukareSummer.mp3"), "Otsukare Summer", 0.8, NumberRange.new(0, 27.36))

		start           = os.clock()
		animator        = AnimLib.Animator.new()
		animator.rig    = figure
		animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("OtsukareSummer.anim"))
		animator.looped = true
		animator.speed  = 1
	end

	m.Update = function(dt, figure)
		animator:Step(os.clock() - start)
	end

	m.Destroy = function(figure)
		animator = nil
	end

	return m
end)

table.insert(modules, function()
	local m = {}

	m.ModuleType  = "DANCE"
	m.Name        = "Release The Ghouls!"
	m.Description = "Don't you know smoking kills?"
	m.Assets      = {"Ghouls.anim@https://github.com/valttasar/Valttas-Port-Content/raw/refs/heads/main/Release%20The%20Ghouls/Ghouls.anim", "Ghouls.mp3@https://github.com/valttasar/Valttas-Port-Content/raw/refs/heads/main/Release%20The%20Ghouls/Ghouls.mp3"}

	m.Config = function(parent)
		Util_CreateText(parent, "No settings.", 14, Enum.TextXAlignment.Center)
	end

	m.SaveConfig = function() return {} end
	m.LoadConfig  = function(save) end

	local animator = nil
	local start    = 0

	m.Init = function(figure)
		SetOverrideDanceMusic(AssetGetContentId("Ghouls.mp3"), "Release The Ghouls!", 0.8, NumberRange.new(0, 52.88))

		start           = os.clock()
		animator        = AnimLib.Animator.new()
		animator.rig    = figure
		animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("Ghouls.anim"))
		animator.looped = true
		animator.speed  = 1
	end

	m.Update = function(dt, figure)
		animator:Step(os.clock() - start)
	end

	m.Destroy = function(figure)
		animator = nil
	end

	return m
end)

table.insert(modules, function()
	local m = {}

	m.ModuleType  = "DANCE"
	m.Name        = "Schadenfreude"
	m.Description = "Can you feel the scha-den-freu-de?"
	m.Assets      = {
		"Scoutlaugh.anim@https://github.com/valttasar/Valttas-Port-Content/raw/refs/heads/main/Schadenfreude/Scoutlaugh.anim", "Scoutlaugh.mp3@https://github.com/valttasar/Valttas-Port-Content/raw/refs/heads/main/Schadenfreude/Scoutlaugh.mp3",
		"Pyrolaugh.anim@https://github.com/valttasar/Valttas-Port-Content/raw/refs/heads/main/Schadenfreude/Pyrolaugh.anim", "Pyrolaugh.mp3@https://github.com/valttasar/Valttas-Port-Content/raw/refs/heads/main/Schadenfreude/Pyrolaugh.mp3",
		"Mediclaugh.anim@https://github.com/valttasar/Valttas-Port-Content/raw/refs/heads/main/Schadenfreude/Mediclaugh.anim", "Mediclaugh.mp3@https://github.com/valttasar/Valttas-Port-Content/raw/refs/heads/main/Schadenfreude/Mediclaugh.mp3",
		"Heavylaugh.anim@https://github.com/valttasar/Valttas-Port-Content/raw/refs/heads/main/Schadenfreude/Heavylaugh.anim", "Heavylaugh.mp3@https://github.com/valttasar/Valttas-Port-Content/raw/refs/heads/main/Schadenfreude/Heavylaugh.mp3",
		"Demomanlaugh.anim@https://github.com/valttasar/Valttas-Port-Content/raw/refs/heads/main/Schadenfreude/Demomanlaugh.anim", "Demomanlaugh.mp3@https://github.com/valttasar/Valttas-Port-Content/raw/refs/heads/main/Schadenfreude/Demomanlaugh.mp3",
		"Sniperlaugh.anim@https://github.com/valttasar/Valttas-Port-Content/raw/refs/heads/main/Schadenfreude/Sniperlaugh.anim", "Sniperlaugh.mp3@https://github.com/valttasar/Valttas-Port-Content/raw/refs/heads/main/Schadenfreude/Sniperlaugh.mp3",
		"Spylaugh.anim@https://github.com/valttasar/Valttas-Port-Content/raw/refs/heads/main/Schadenfreude/Spylaugh.anim", "Spylaugh.mp3@https://github.com/valttasar/Valttas-Port-Content/raw/refs/heads/main/Schadenfreude/Spylaugh.mp3",
		"Soldierlaugh.anim@https://github.com/valttasar/Valttas-Port-Content/raw/refs/heads/main/Schadenfreude/Soldierlaugh.anim", "Soldierlaugh.mp3@https://github.com/valttasar/Valttas-Port-Content/raw/refs/heads/main/Schadenfreude/Soldierlaugh.mp3",
		"Engineerlaugh.anim@https://github.com/valttasar/Valttas-Port-Content/raw/refs/heads/main/Schadenfreude/Engineerlaugh.anim", "Engineerlaugh.mp3@https://github.com/valttasar/Valttas-Port-Content/raw/refs/heads/main/Schadenfreude/Engineerlaugh.mp3",
	}

	local mercenaries = {"Scout", "Pyro", "Medic", "Heavy", "Demoman", "Sniper", "Spy", "Soldier", "Engineer"}

	m.Variant = 1
	m.Config = function(parent)
		Util_CreateDropdown(parent, "Mercenary", mercenaries, m.Variant).Changed:Connect(function(val)
			m.Variant = val
		end)
	end
	m.LoadConfig = function(save)
		m.Variant = save.Variant or m.Variant
	end
	m.SaveConfig = function()
		return {
			Variant = m.Variant
		}
	end

	local animator = nil
	local start = 0

	m.Init = function(figure)
		local name = mercenaries[m.Variant]
		SetOverrideDanceMusic(AssetGetContentId(name .. "laugh.mp3"), "TF2 Schadenfreude - " .. name, 1)
		start = os.clock()
		animator = AnimLib.Animator.new()
		animator.rig = figure
		animator.track = AnimLib.Track.fromfile(AssetGetPathFromFilename(name .. "laugh.anim"))
		animator.looped = true
		animator.speed = 1
	end

	m.Update = function(dt, figure)
		animator:Step(os.clock() - start)
	end

	m.Destroy = function(figure)
		animator = nil
	end

	return m
end)

table.insert(modules, function()
	local m = {}

	m.ModuleType  = "DANCE"
	m.Name        = "Skeleton Shield Bash"
	m.Description = "RAHHHHHHHHHRGH! RAAARGH!"
	m.Assets      = {"Skellywarcry.anim@https://github.com/valttasar/Valttas-Port-Content/raw/refs/heads/main/Skelly%20War%20Cry/Skellywarcry.anim", "Skellywarcry.mp3@https://github.com/valttasar/Valttas-Port-Content/raw/refs/heads/main/Skelly%20War%20Cry/Skellywarcry.mp3"}

	m.Config = function(parent)
		Util_CreateText(parent, "No settings.", 14, Enum.TextXAlignment.Center)
	end

	m.SaveConfig = function() return {} end
	m.LoadConfig  = function(save) end

	local animator = nil
	local start    = 0

	m.Init = function(figure)
		SetOverrideDanceMusic(AssetGetContentId("Skellywarcry.mp3"), "Skeleton Shield Bash", 0.8, NumberRange.new(0, 2.5))

		start           = os.clock()
		animator        = AnimLib.Animator.new()
		animator.rig    = figure
		animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("Skellywarcry.anim"))
		animator.looped = true
		animator.speed  = 1
	end

	m.Update = function(dt, figure)
		animator:Step(os.clock() - start)
	end

	m.Destroy = function(figure)
		animator = nil
	end

	return m
end)

table.insert(modules, function()
	local m = {}

	m.ModuleType  = "DANCE"
	m.Name        = "Unlock It"
	m.Description = "you could be ma valentino yeah ~\n\nI suggest using S.E.W.H it's so gud "
	m.Assets      = {"Unlockit.anim@https://github.com/valttasar/Valttas-Port-Content/raw/refs/heads/main/Unlock%20It/Unlockit.anim", "Unlockit.mp3@https://github.com/valttasar/Valttas-Port-Content/raw/refs/heads/main/Unlock%20It/Unlockit.mp3", "Unlockit2.anim@https://github.com/valttasar/Valttas-Port-Content/raw/refs/heads/main/Unlock%20It/Unlockit2.anim", "Unlockit2.mp3@https://github.com/valttasar/Valttas-Port-Content/raw/refs/heads/main/Unlock%20It/Unlockit2.mp3"}

	m.Alternative  = false
	m.MusicVariant = 1
	m.Config = function(parent)
		Util_CreateSwitch(parent, "S.E.W.H Version", m.Alternative).Changed:Connect(function(val)
			m.Alternative = val
		end)
		Util_CreateDropdown(parent, "Music Variant", {"Normal", "S.E.W.H Ver."}, m.MusicVariant).Changed:Connect(function(val)
			m.MusicVariant = val
		end)
	end

	m.LoadConfig = function(save: any)
		m.Alternative = not not save.Alternative
		m.MusicVariant = save.MusicVariant or m.MusicVariant
	end

	m.SaveConfig = function()
		return {
			Alternative = m.Alternative,
			MusicVariant = m.MusicVariant
		}
	end

	local animator = nil
	local start = 0

	m.Init = function(figure: Model)
		if m.MusicVariant == 1 then
			SetOverrideDanceMusic(AssetGetContentId("Unlockit.mp3"), "Normal", 1, NumberRange.new(0, 14.43))
		elseif m.MusicVariant == 2 then
			SetOverrideDanceMusic(AssetGetContentId("Unlockit2.mp3"), "Something EVIL Will Happen", 1, NumberRange.new(0, 14.03))
		end

		if not m.Intro then
			SetOverrideDanceMusicTime(0)
		end

		start           = os.clock()
		animator        = AnimLib.Animator.new()
		animator.rig    = figure
		animator.looped = true
		animator.speed  = 1

		if m.Alternative then
			animator.track = AnimLib.Track.fromfile(AssetGetPathFromFilename("Unlockit2.anim"))
		else
			animator.track = AnimLib.Track.fromfile(AssetGetPathFromFilename("Unlockit.anim"))
		end
	end

	m.Update = function(dt, figure)
		animator:Step(os.clock() - start)
	end

	m.Destroy = function(figure)
		animator = nil
	end

	return m
end)

table.insert(modules, function()
	local m = {}

	m.ModuleType  = "DANCE"
	m.Name        = "Usagi"
	m.Description = "U u-ma-ma-uma\nUma-mama-takutakuchaa-mo"
	m.Assets      = {"Usagi.anim@https://github.com/valttasar/Valttas-Port-Content/raw/refs/heads/main/Usagi/Usagi.anim", "Usagi.mp3@https://github.com/valttasar/Valttas-Port-Content/raw/refs/heads/main/Usagi/Usagi.mp3"}

	m.Config = function(parent)
		Util_CreateText(parent, "No settings.", 14, Enum.TextXAlignment.Center)
	end

	m.SaveConfig = function() return {} end
	m.LoadConfig  = function(save) end

	local animator = nil
	local start    = 0

	m.Init = function(figure)
		SetOverrideDanceMusic(AssetGetContentId("Usagi.mp3"), "Usagi", 0.8, NumberRange.new(0, 999))

		start           = os.clock()
		animator        = AnimLib.Animator.new()
		animator.rig    = figure
		animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("Usagi.anim"))
		animator.looped = true
		animator.speed  = 1
	end

	m.Update = function(dt, figure)
		animator:Step(os.clock() - start)
	end

	m.Destroy = function(figure)
		animator = nil
	end

	return m
end)

table.insert(modules, function()
	local m = {}

	m.ModuleType  = "DANCE"
	m.Name        = "With Friends"
	m.Description = "Chris? he only plays with friends.. friends.. only.. plays.. oney plays...."
	m.Assets      = {"Withfriends.anim@https://github.com/valttasar/Valttas-Port-Content/raw/refs/heads/main/With%20Friends/Withfriends.anim", "Withfriends.mp3@https://github.com/valttasar/Valttas-Port-Content/raw/refs/heads/main/With%20Friends/Withfriends.mp3"}

	m.Config = function(parent)
		Util_CreateText(parent, "No settings.", 14, Enum.TextXAlignment.Center)
	end

	m.SaveConfig = function() return {} end
	m.LoadConfig  = function(save) end

	local animator = nil
	local start    = 0

	m.Init = function(figure)
		SetOverrideDanceMusic(AssetGetContentId("Withfriends.mp3"), "With Friends", 0.8, NumberRange.new(0, 20.16))

		start           = os.clock()
		animator        = AnimLib.Animator.new()
		animator.rig    = figure
		animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("Withfriends.anim"))
		animator.looped = true
		animator.speed  = 1
	end

	m.Update = function(dt, figure)
		animator:Step(os.clock() - start)
	end

	m.Destroy = function(figure)
		animator = nil
	end

	return m
end)

return modules