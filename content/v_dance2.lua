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

AddModule(function()
	local m = {}
	m.ModuleType = "DANCE"
	m.Name = "It's Going Down"
	m.Description = "first dance in v_dance2.lua"
	m.Assets = {"GoingDown.anim", "GoingDown.mp3"}

	m.Config = function(parent: GuiBase2d)
	end

	local animator = nil
	m.Init = function(figure: Model)
		SetOverrideDanceMusic(AssetGetContentId("GoingDown.mp3"), "IT'S GOING DOWN", 1)
		animator = AnimLib.Animator.new()
		animator.rig = figure
		animator.looped = true
		animator.track = AnimLib.Track.fromfile(AssetGetPathFromFilename("GoingDown.anim"))
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
	m.Name = "Results"
	m.Description = "real ones know ts from pizza tower\neffortless upload"
	m.Assets = {"Results.anim", "Results.mp3"}

	m.Config = function(parent: GuiBase2d)
	end

	local animator = nil
	m.Init = function(figure: Model)
		SetOverrideDanceMusic(AssetGetContentId("Results.mp3"), "Results! - PT Sugary Spire OST", 1)
		animator = AnimLib.Animator.new()
		animator.rig = figure
		animator.looped = false
		animator.track = AnimLib.Track.fromfile(AssetGetPathFromFilename("Results.anim"))
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
	m.Name = "Birdbrain"
	m.Description = "hey teto you should wish that you could\nc- c- c- c- c- CUHHHH\nFAHHHHHH\n\nSo... ####!!"
	m.Assets = {"Birdbrain.anim", "Birdbrain.mp3", "BirdbrainAlt.mp3"}

	m.Lag = false
	m.Config = function(parent: GuiBase2d)
		Util_CreateSwitch(parent, "Make it laggy", m.Lag).Changed:Connect(function(val)
			m.Lag = val
		end)
	end
	m.LoadConfig = function(save: any)
		m.Lag = not not save.Lag
	end
	m.SaveConfig = function()
		return {
			Lag = m.Lag
		}
	end

	local animator = nil
	m.Init = function(figure: Model)
		if math.random() < 0.1 then
			SetOverrideDanceMusic(AssetGetContentId("BirdbrainAlt.mp3"), "BIRDBRAIN ft. Kasane Teto", 1)
		else
			SetOverrideDanceMusic(AssetGetContentId("Birdbrain.mp3"), "BIRDBRAIN ft. Kasane Teto", 1)
		end
		animator = AnimLib.Animator.new()
		animator.rig = figure
		animator.looped = false
		animator.track = AnimLib.Track.fromfile(AssetGetPathFromFilename("Birdbrain.anim"))
	end
	m.Update = function(dt: number, figure: Model)
		if m.Lag then
			local fps = 1 / 12
			animator:Step((GetOverrideDanceMusicTime() // fps) * fps)
		else
			animator:Step(GetOverrideDanceMusicTime())
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
	m.Name = "Terraria Swing dance"
	m.Description = "enjoy enjoy enjoy enjoy enjoy enjoy\nenjoy enjoy enjoy enjoy\nenjoy enjoy enjoy enjoy\n\nthis is my first \"linearish\" animation"
	m.Assets = {"BusetA.anim", "BusetB.anim", "Buset.mp3"}

	m.MoveForward = false
	m.Config = function(parent: GuiBase2d)
		Util_CreateSwitch(parent, "Move Forward", m.MoveForward).Changed:Connect(function(val)
			m.MoveForward = val
		end)
	end
	m.LoadConfig = function(save: any)
		m.MoveForward = not not save.MoveForward
	end
	m.SaveConfig = function()
		return {
			MoveForward = m.MoveForward
		}
	end

	local allbusets = {{9, 27.216}, {31.945, 49.95}, {54.557, 72.494}, {77.534, 95.14}}

	local animator1, animator2 = nil, nil
	m.Init = function(figure: Model)
		SetOverrideDanceMusic(AssetGetContentId("Buset.mp3"), "MONTAGEM VOZES TALENTINHO", 1)
		animator1 = AnimLib.Animator.new()
		animator1.rig = figure
		animator1.looped = true
		animator1.track = AnimLib.Track.fromfile(AssetGetPathFromFilename("BusetA.anim"))
		animator2 = AnimLib.Animator.new()
		animator2.rig = figure
		animator2.looped = false
		animator2.track = AnimLib.Track.fromfile(AssetGetPathFromFilename("BusetB.anim"))
	end
	m.Update = function(dt: number, figure: Model)
		local t = GetOverrideDanceMusicTime()
		local s, e = 6767, 6768
		for i=1, #allbusets do
			if t < allbusets[i][2] then
				s, e = allbusets[i][1], allbusets[i][2]
				break
			end
		end
		local m2 = (e - s) / 32
		local t2 = ((t - s) / m2) + 0.28
		if t2 < -8 then
			animator1:Step(t)
		elseif t2 < 0 then
			if t2 < -2 and m.MoveForward then
				local root = figure:FindFirstChild("HumanoidRootPart")
				root.CFrame *= CFrame.new(0, 0, -dt * 3.5 * figure:GetScale())
			end
			animator2:Step(4.8 * (1 - (t2 / -8)))
		else
			animator2:Step(4.8 + (t2 % 1) * 0.57)
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
	m.Name = "Thriller"
	m.Description = "the moonwalk guy apparently danced this"
	m.Assets = {"Thriller.anim", "Thriller.mp3"}

	m.Config = function(parent: GuiBase2d)
	end

	local animator = nil
	local start = 0
	m.Init = function(figure: Model)
		SetOverrideDanceMusic(AssetGetContentId("Thriller.mp3"), "Michael Jackson - Thriller", 1)
		start = os.clock()
		animator = AnimLib.Animator.new()
		animator.rig = figure
		animator.looped = true
		animator.speed = 1
		animator.track = AnimLib.Track.fromfile(AssetGetPathFromFilename("Thriller.anim"))
	end
	m.Update = function(dt: number, figure: Model)
		local t = os.clock()
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
	m.Name = "Monster Mash"
	m.Description = "drink the potion that makes you dance!"
	m.Assets = {"RetroMonsterMash.anim", "RetroMonsterMash.mp3"}

	m.Config = function(parent: GuiBase2d)
	end

	local animator = nil
	local start = 0
	m.Init = function(figure: Model)
		SetOverrideDanceMusic("rbxassetid://35930009", "where did this even come from", 1)
		start = os.clock()
		animator = AnimLib.Animator.new()
		animator.rig = figure
		animator.looped = true
		animator.speed = 1
		animator.track = AnimLib.Track.fromfile(AssetGetPathFromFilename("RetroMonsterMash.anim"))
	end
	m.Update = function(dt: number, figure: Model)
		local t = os.clock()
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
	m.Name = "So Retro"
	m.Description = "forsakened\n\nnear at the end there is the literal super mario world tune lol"
	m.Assets = {"RetroSoRetro.anim", "RetroSoRetro.mp3"}

	m.Config = function(parent: GuiBase2d)
	end

	local animator = nil
	local start = 0
	m.Init = function(figure: Model)
		SetOverrideDanceMusic(AssetGetContentId("RetroSoRetro.mp3"), "so retro", 1)
		start = os.clock()
		animator = AnimLib.Animator.new()
		animator.rig = figure
		animator.looped = true
		animator.speed = 1
		animator.track = AnimLib.Track.fromfile(AssetGetPathFromFilename("RetroSoRetro.anim"))
	end
	m.Update = function(dt: number, figure: Model)
		local t = os.clock()
		animator:Step(t - start)
	end
	m.Destroy = function(figure: Model?)
		animator = nil
	end
	return m
end)

return modules