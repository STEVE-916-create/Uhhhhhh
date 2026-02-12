--[[
 ...    :::::        ::        ::        ::        ::        ::        
 ;;     ;;;;;;       ;;;       ;;;       ;;;       ;;;       ;;;       
[['     [[[[[[[cc,,. [[[[cc,,. [[[[cc,,. [[[[cc,,. [[[[cc,,. [[[[cc,,. 
$$      $$$$$$"""$$$ $$$"""$$$ $$$"""$$$ $$$"""$$$ $$$"""$$$ $$$"""$$$ 
88    .d888888   "88o888   "88o888   "88o888   "88o888   "88o888   "88o
 "YmmMMMM""MMM    YMMMMM    YMMMMM    YMMMMM    YMMMMM    YMMMMM    YMM
       "DREAMS WILL NEVER COME TRUE UNTIL YOU ACTUALLY MAKE IT."       

       Code:    STEVETHEREALONE
       GFX:     STEVETHEREALONE
                AALib
                some random generators
       Music:   Dubmood
                4mat
                MASTER BOOT RECORD

Thou shalth not steal. Point at this source if you used a snippet here.
]]

if _G.UhhhhhhLoaded then return end
_G.UhhhhhhLoaded = true

local UhhhhhhVersion = "1.0.5 BETA"

cloneref = cloneref or function(o) return o end
getcustomasset = getcustomasset or getsynasset
gethiddengui = get_hidden_gui or gethui

-- restore
pcall(restorefunction, restorefunction)
pcall(restorefunction, sethiddenproperty)
pcall(restorefunction, replicatesignal)

local Debris = cloneref(game:GetService("Debris"))
local CoreGui = cloneref(game:GetService("CoreGui"))
local Players = cloneref(game:GetService("Players"))
local RunService = cloneref(game:GetService("RunService"))
local StarterGui = cloneref(game:GetService("StarterGui"))
local GuiService = cloneref(game:GetService("GuiService"))
local HttpService = cloneref(game:GetService("HttpService"))
local TextService = cloneref(game:GetService("TextService"))
local TweenService = cloneref(game:GetService("TweenService"))
local TextChatService = cloneref(game:GetService("TextChatService"))
local UserInputService = cloneref(game:GetService("UserInputService"))
local ContextActionService = cloneref(game:GetService("ContextActionService"))

local Util = {}

Util.RandomString = function(length)
	length = length or math.random(32, 256)
	local str = ""
	for _=1, length do
		str ..= string.char(math.random(32, 126))
	end
	return str
end
Util.DeepcopyTable = function(t)
	local c = {}
	for k, v in pairs(t) do
		if type(v) == "table" then
			v = Util.DeepcopyTable(v)
		end
		c[k] = v
	end
	return c
end
Util.Notify = function(text)
	StarterGui:SetCore("SendNotification", {
		Title = "Uhhhhhh",
		Text = text,
		Duration = 5
	})
end

do
	local function diefatal()
		Util.Notify("Executor not supported.")
		_G.UhhhhhhLoaded = nil
		error("fatal error cant start")
	end
	if not request then
		diefatal()
	end
	if not getcustomasset then
		diefatal()
	end
	if not (readfile and writefile and delfile and isfile and isfolder and makefolder and listfiles) then
		diefatal()
	end
	if not firetouchinterest then
		diefatal()
	end
	if not replicatesignal then
		diefatal()
	end
	if not sethiddenproperty then
		diefatal()
	end
	if not hookmetamethod and not hookfunction then
		diefatal()
	end
	local loadstringreturn = false
	local val = math.random(-65536, 65536)
	local _, func = pcall(loadstring, "return " .. val)
	if func then
		local s, val2 = pcall(func)
		if s and val == val2 then
			loadstringreturn = true
		end
	end
	if not loadstringreturn then
		diefatal()
	end
	if isfile then
		local s, e = pcall(isfile, Util.RandomString(32))
		if s and e then
			-- stupid executor
			isfile = function(path)
				local s, e = pcall(readfile, path)
				return not not (s and e)
			end
		end
	else
		diefatal()
	end
end

b_getfenv = getfenv -- "loadstring marks the env unsafe"

local Player = Players.LocalPlayer

if not game:IsLoaded() then
	local notLoaded = Instance.new("Message")
	xpcall(function()
		notLoaded.Parent = CoreGui
	end, function()
		notLoaded.Parent = workspace
	end)
	notLoaded.Text = "Uhhhhhh is waiting for the game to load"
	game.Loaded:Wait()
	for i=1, 60 do
		while task.wait() > 1 / 10 do end
	end
	notLoaded:Destroy()
end

local Camera = workspace.CurrentCamera
workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
	local newCamera = workspace.CurrentCamera
	if newCamera ~= nil then
		Camera = newCamera
	end
end)
Util._scrsiz = Vector2.new(512, 512)
Util.GetScreenSize = function()
	if Camera ~= nil then
		Util._scrsiz = Camera.ViewportSize
	end
	return Util._scrsiz
end
Util.LoopedHSV = function(h, s, v)
	h %= 1
	s = math.clamp(s, 0, 1)
	v = math.clamp(v, 0, 1)
	return Color3.fromHSV(h, s, v)
end
Util.Instance = function(cl, p)
	local i = Instance.new(cl)
	i.Name = Util.RandomString()
	i.Parent = p
	return i
end
Util.LinkDestroyI2I = function(a, b)
	a.Destroying:Once(function()
		b:Destroy()
	end)
end
Util.LinkDestroyI2C = function(a, b)
	a.Destroying:Once(function()
		b:Disconnect()
	end)
end
Util.ClearAllChildrenGui = function(a)
	for _,v in a:GetChildren() do
		if v:IsA("GuiObject") then
			v:Destroy()
		end
	end
end
Util.GetTransparency = function(part)
	return 1 - (1 - part.Transparency) * (1 - part.LocalTransparencyModifier)
end
Util.ScaleCFrame = function(cf, scale)
	return cf + cf.Position * (scale - 1)
end
Util.IsGuiVisible = function(guiObject)
	if not guiObject or not guiObject:IsA("GuiObject") then return false end
	while guiObject do
		if not guiObject.Visible then
			return false
		end
		guiObject = guiObject:FindFirstAncestorWhichIsA("GuiObject")
	end
	return true
end
Util.UDim2ToVector2Scale = function(x)
	return Vector2.new(x.X.Scale, x.Y.Scale)
end
Util.UDim2ToVector2Offset = function(x)
	return Vector2.new(x.X.Offset, x.Y.Offset)
end
Util.Vector2ToUDim2Scale = function(x)
	return UDim2.fromScale(x.X, x.Y)
end
Util.Vector2ToUDim2Offset = function(x)
	return UDim2.fromOffset(x.X, x.Y)
end
Util.QueryPlayerSelector = function(query, excludespeaker)
	if #query == 0 then return end
	query = query:lower()
	local t = {}
	for _,player in Players:GetPlayers() do
		if player ~= Player or not excludespeaker then
			local a = player.DisplayName:lower():find(query)
			local b = player.Name:lower():find(query)
			if a then table.insert(t, {player, 1, a}) end
			if b then table.insert(t, {player, 0, b}) end
		end
	end
	table.sort(t, function(a, b)
		if a[2] == b[2] then
			return a[3] < b[3]
		end
		return a[2] < b[2]
	end)
	if t[1] then
		return t[1][1]
	end
	return nil
end

local IsUhhhhhhFullyLoaded = false

local SCREENGUI = Util.Instance("ScreenGui")
SCREENGUI.IgnoreGuiInset = true
SCREENGUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
SCREENGUI.ClipToDeviceSafeArea = false
SCREENGUI.ResetOnSpawn = false
SCREENGUI.ScreenInsets = Enum.ScreenInsets.None
SCREENGUI.DisplayOrder = 2147483647
if gethiddengui then
	SCREENGUI.Parent = gethiddengui()
else
	SCREENGUI.Parent = CoreGui
end

local UIMainFrame = Util.Instance("Frame", SCREENGUI)
UIMainFrame.AnchorPoint = Vector2.new(0, 0)
UIMainFrame.Position = UDim2.new(0, 0, 0, 0)
UIMainFrame.Size = UDim2.new(1, 0, 1, 0)
UIMainFrame.BackgroundColor3 = Color3.new(0, 0, 0)
UIMainFrame.BackgroundTransparency = 1
UIMainFrame.BorderSizePixel = 0
UIMainFrame.ZIndex = 2147483647

local SaveData = {}
do
	pcall(makefolder, "UhhhhhhReanim")
	pcall(writefile, "UhhhhhhReanim/.nomedia", "")
	local SaveDataFilename = "UhhhhhhReanim/tree.ehehetilde"
	local s, data = pcall(readfile, SaveDataFilename)
	if s and data then
		s, data = pcall(HttpService.JSONDecode, HttpService, data)
		if s and data then
			SaveData = data
		else
			pcall(writefile, SaveDataFilename, "{}")
		end
	else
		pcall(writefile, SaveDataFilename, "{}")
	end
	task.spawn(function()
		local odata = nil
		local savefailwarn = false
		while true do
			task.wait()
			local s, data = pcall(HttpService.JSONEncode, HttpService, SaveData)
			if s then
				savefailwarn = false
				odata = odata or data
				if odata ~= data then
					odata = data
					pcall(writefile, SaveDataFilename, data)
				end
			else
				if not savefailwarn then
					Util.Notify("Failed to write tree.ehehetilde (your save file)")
					savefailwarn = true
				end
			end
		end
	end)
	pcall(makefolder, "UhhhhhhReanim/Assets")
	pcall(makefolder, "UhhhhhhReanim/Modules")
	pcall(makefolder, "UhhhhhhReanim/BuiltinModules")
	pcall(makefolder, "UhhhhhhReanim/Content")
	pcall(makefolder, "UhhhhhhReanim/Content/Anims")
	pcall(makefolder, "UhhhhhhReanim/Content/Sounds")
	pcall(makefolder, "UhhhhhhReanim/Content/Images")
	pcall(makefolder, "UhhhhhhReanim/Content/Models")
	pcall(makefolder, "UhhhhhhReanim/Content/Unknown")
end

do
	local CDNVersion = 2
	local AllFileNames = {
		"dm_afterburner.ft2.mp3",
		"4m_brokenheart.ft2.mp3",
		"dm_change.ft2.mp3",
		"dm_deadscene2024.ft2.mp3",
		"dm_deadscene2024alt.ft2.mp3",
		"dm_e1m777.ft2.mp3",
		"dm_haze.ft2.mp3",
		"dm_haze2.ft2.mp3",
		"dm_iostesso.ft2.mp3",
		"dm_keygen18.ft2.mp3",
		"dm_keygen19.ft2.mp3",
		"dm_keygen20.ft2.mp3",
		"dm_keygen21.ft2.mp3",
		"dm_keygen21alt.ft2.mp3",
		"dm_keygen22.ft2.mp3",
		"dm_keygen23.ft2.mp3",
		"dm_keygen3.ft2.mp3",
		"dm_keygen30.ft2.mp3",
		"dm_keygen31.ft2.mp3",
		"dm_keygen8.ft2.mp3",
		"dm_laparade.ft2.mp3",
		"dm_reztro4.ft2.mp3",
		"dm_robotadventure.ft2.mp3",
		"dm_unaseraariccione.ft2.mp3",
		"fr_keygen31.ft2.mp3",
		"lightinursoul.graphic.png",
		"letriangul.graphic.png",
	}
	local redownloadeverything = SaveData.CDNVersion ~= CDNVersion
	local theresassetsmissing = redownloadeverything
	for _,rfile in AllFileNames do
		local fil = "UhhhhhhReanim/Assets/" .. rfile
		local s, d = pcall(isfile, fil)
		if not (s and d) then
			theresassetsmissing = true
		end
	end
	if theresassetsmissing then
		local downloaded = 0
		local skipped = 0
		local assetsdownload = 0
		local downloadfile = function(meta)
			local fil = "UhhhhhhReanim/Assets/" .. meta.name
			if not redownloadeverything then
				local s, d = pcall(isfile, fil)
				if s and d then
					downloaded += 1
					return
				end
			end
			if not pcall(function()
				writefile(fil, game:HttpGet(meta.download_url))
			end) then skipped += 1 end
			downloaded += 1
		end
		local Downloading = Util.Instance("TextLabel", UIMainFrame)
		Downloading.AnchorPoint = Vector2.new(0.5, 0.5)
		Downloading.Position = UDim2.new(0.5, 0, 0.5, 0)
		Downloading.Size = UDim2.new(1, 0, 0, 0)
		Downloading.BackgroundColor3 = Color3.new(0, 0, 0)
		Downloading.BackgroundTransparency = 0.2
		Downloading.ClipsDescendants = true
		Downloading.BorderSizePixel = 0
		Downloading.TextColor3 = Color3.new(1, 1, 1)
		Downloading.TextSize = 20
		Downloading.Font = Enum.Font.Code
		Downloading.Text = "Fetching Assets metadata..."
		TweenService:Create(Downloading, TweenInfo.new(0.5), {
			Size = UDim2.new(1, 0, 0, 32)
		}):Play()
		task.wait(0.5)
		local s, assetsof = pcall(game.HttpGet, game, "https://api.github.com/repos/STEVE-916-create/Uhhhhhh/contents/uiassets/")
		if s and assetsof then
			s, assetsof = pcall(HttpService.JSONDecode, HttpService, assetsof)
			if s and assetsof then
				for i,file in assetsof do
					if not table.find(AllFileNames, file.name) then
						continue
					end
					assetsdownload += 1
					task.spawn(downloadfile, file)
				end
				repeat
					Downloading.Text = `Downloading assets {downloaded}/{assetsdownload}... ({skipped} skipped)`
					Downloading.BackgroundColor3 = Color3.new(0, 0, 0)
					task.wait()
				until downloaded == assetsdownload
				Downloading.Text = "Download complete! \\(^o^)/"
				Downloading.BackgroundColor3 = Color3.new(0, 1, 0)
				theresassetsmissing = false
			end
		end
		SaveData.CDNVersion = CDNVersion
		if theresassetsmissing then
			Downloading.Text = "Asset downloading failed. 3:"
			Downloading.BackgroundColor3 = Color3.new(1, 0, 0)
		end
		TweenService:Create(Downloading, TweenInfo.new(0.5), {
			Size = UDim2.new(1, 0, 0, 0),
			BackgroundColor3 = Color3.new(0, 0, 0),
		}):Play()
		task.wait(0.5)
		Downloading:Destroy()
	end
end

Util.GetCDNAsset = function(filename)
	local path = "UhhhhhhReanim/Assets/" .. filename
	local s, id = pcall(isfile, path)
	if s and id then
		s, id = pcall(getcustomasset, path)
		if s then return id end
	end
	return ""
end

Util.MakeTriforce = function(tris, color, dur)
	dur = dur or 8
	local function CreateTriangle(parent, radius, width, rotation, color)
		local height = (math.sqrt(3) / 2) * width
		local pivot = Util.Instance("Frame", parent)
		pivot.AnchorPoint = Vector2.new(0.5, 0.5)
		pivot.Position = UDim2.new(0.5, 0, 0.5, 0)
		pivot.Size = UDim2.new(1, 0, 1, 0)
		pivot.BackgroundTransparency = 1
		pivot.BorderSizePixel = 0
		pivot.Rotation = rotation
		local tri = Util.Instance("ImageLabel", pivot)
		tri.AnchorPoint = Vector2.new(0.5, 1)
		tri.Position = UDim2.new(0.5, 0, 0.5 - radius, 0)
		tri.Size = UDim2.new(width, 0, height, 0)
		tri.BackgroundTransparency = 1
		tri.BorderSizePixel = 0
		tri.Image = Util.GetCDNAsset("letriangul.graphic.png")
		local grey = math.max(color.R, color.G, color.B) * 0.5
		tri.ImageColor3 = Color3.new(grey, grey, grey)
		TweenService:Create(tri, TweenInfo.new(dur, Enum.EasingStyle.Linear), {
			ImageColor3 = color
		}):Play()
	end
	local radius = 0.1
	local pivot = Util.Instance("Frame")
	pivot.AnchorPoint = Vector2.new(0.5, 0.5)
	pivot.Position = UDim2.new(0.5, 0, 0.5, 0)
	pivot.BackgroundTransparency = 1
	pivot.BorderSizePixel = 0
	local width = 2 * radius * math.sin(math.pi / tris) * 2
	for i=1, tris do
		CreateTriangle(pivot, radius, width, (i / tris) * 360, color)
	end
	return pivot
end
Util.MakeText = function(text)
	text = text:upper()
	local ls = "BCDEIKOPQRSTUVYZ\\_`N^MJ"
	local lt = ""
	-- !, ", #, $, %, &, ', (, ), *, +, ,, -, ., /
	lt ..= "DDDDD@DFF@@@@@FSFSFSF@@@@@@@@@@@@@@EMMUKKTDD@@@@@DEEEEEDDBBBBBD@@@@@@@@@@@@@@@@@@@DE@@@G@@@@@@@@@DABBDEEI"
	-- numbers
	lt ..= "GJJJJJGDVDDDDSGJAGIISRAAGAARWJJSAAASIIRAARGIIRJJGSAABBDDGJJGJJGGJJHAAG"
	-- :, ;, <, =, >, ?, @
	lt ..= "@DD@DD@@DD@DE@@BDEDB@@@G@G@@@EDBDE@GJABD@D@@@@@@@"
	-- capital letters
	lt ..= "DFJSJJJRJJRJJRGJIIIJGRJJJJJRSIIRIISSIIRIIIHIILJJHJJJSJJJGDDDDDGAAAAAJHJKMOMKJIIIIIISJQNJJJJJJPNLJJGJJJJJGRJJRIIIGJJJNGCRJJRMKJGJIGAJGSDDDDDDJJJJJJGJJJJJFDJJJNQJJJJFDFJJJJFDDDDSABDEIS"
	local pixs = {}
	local totalsize = 0
	for i=0, 6 do
		local row = {}
		for j=1, text:len() do
			local c = text:byte(j, j)
			local w = 0
			if c ~= 0x20 then
				local k = (c - 33) * 7 + i
				w = lt:byte(k + 1, k + 1)
				if w ~= nil and w > 64 then
					w = ls:byte(w - 64, w - 64) - 65
				else
					w = 0
				end
			end
			for k=0, 5 do
				local h = (j - 1) * 6 + (4 - k)
				totalsize = math.max(totalsize, h + 1)
				local p = (w // math.pow(2, k)) % 2
				if p > 0 then
					row[h] = true
				end
			end
		end
		pixs[i] = row
	end
	local pivot = Util.Instance("Frame")
	pivot.AnchorPoint = Vector2.new(0.5, 0.5)
	pivot.Position = UDim2.new(0.5, 0, 0.5, 0)
	pivot.Size = UDim2.new(0, totalsize, 0, 7)
	pivot.BackgroundTransparency = 1
	pivot.BorderSizePixel = 0
	for i=0, 6 do
		local row = pixs[i]
		local olde = nil
		local olds = 0
		for j=0, totalsize - 1 do
			local pix = row[j]
			if pix == true then
				if olde ~= nil then
					olds += 1
					olde.Size = UDim2.new(olds / totalsize, 0, 1 / 7, 0)
				else
					olde = Util.Instance("Frame", pivot)
					olde.AnchorPoint = Vector2.new(0, 0)
					olde.Position = UDim2.new(j / totalsize, 0, i / 7, 0)
					olde.Size = UDim2.new(1 / totalsize, 0, 1 / 7, 0)
					olde.BackgroundTransparency = 1
					olde.BorderSizePixel = 0
					olds = 1
				end
			else
				olde = nil
				olds = 0
			end
		end
	end
	return pivot
end
Util.SetTextColor = function(text, color, tran)
	for _,v in text:GetChildren() do
		v.BackgroundColor3 = color
		v.BackgroundTransparency = tran
	end
end

local UISound = {}

UISound.Music = Util.Instance("Sound", UIMainFrame)
UISound.Music.Looped = false
UISound.Music.PlaybackRegionsEnabled = false
UISound.Music.Volume = 1
UISound.Music.PlaybackSpeed = 1

local MusicPlayer = {}
MusicPlayer.Database = {
	{"dm_afterburner.ft2.mp3", "Dubmood - Afterburner"},
	{"dm_robotadventure.ft2.mp3", "Dubmood & Zabutom - Robot Adventure Remix"},
	{"4m_brokenheart.ft2.mp3", "4-Mat - <3 Broken Heart <3"},
	{"dm_change.ft2.mp3", "Dubmood - Change (Radio Edit)"},
	{math.random() < 0.5 and "dm_deadscene2024.ft2.mp3" or "dm_deadscene2024alt.ft2.mp3", "Dubmood - The Scene is Dead 2024"},
	{"dm_e1m777.ft2.mp3", "Dubmood & MBR - E1M777"},
	{"dm_haze.ft2.mp3", "Dubmood - Haze (Keygen 13 Edit)"},
	{"dm_haze2.ft2.mp3", "Dubmood - Haze Keygen 2"},
	{"dm_iostesso.ft2.mp3", "Dubmood - Io Stesso"},
	{"dm_keygen3.ft2.mp3", "Dubmood - Keygen 3"},
	{"dm_keygen8.ft2.mp3", "Dubmood - Keygen 8"},
	{"dm_keygen18.ft2.mp3", "Dubmood - Keygen 18"}, -- intro music
	{"dm_keygen19.ft2.mp3", "Dubmood - Keygen 19"},
	{"dm_keygen20.ft2.mp3", "Dubmood - Keygen 20"},
	{"dm_keygen21alt.ft2.mp3", "Dubmood - Keygen 21"},
	{"dm_keygen21.ft2.mp3", "Dubmood - Keygen 21 (Installer Edit)"},
	{"dm_keygen22.ft2.mp3", "Dubmood - Keygen 22"},
	{"dm_keygen23.ft2.mp3", "Dubmood - Keygen 23"},
	{"dm_keygen30.ft2.mp3", "Dubmood - Keygen 30"},
	{"dm_keygen31.ft2.mp3", "Dubmood - Keygen 31"},
	{"fr_keygen31.ft2.mp3", "Hoster's FR - Alternate Keygen 31"},
	{"dm_laparade.ft2.mp3", "Dubmood & MBR - La Parade"},
	{"dm_reztro4.ft2.mp3", "Dubmood - Rez Cracktro #4"},
	{"dm_unaseraariccione.ft2.mp3", "Dubmood - Una Sera A Riccione"},
}
MusicPlayer.Switching = false
MusicPlayer.Last = 1
MusicPlayer.PlayMusic = function(i)
	if MusicPlayer.Switching then return end
	MusicPlayer.Switching = true
	local last = MusicPlayer.LastMusic
	if not i then
		i = last
		while i == last do
			i = math.random(1, #MusicPlayer.Database)
			task.wait()
		end
	end
	MusicPlayer.LastMusic = i
	local hi = MusicPlayer.Database[i]
	local soundid, soundname = hi[1], hi[2]
	UISound.Music.SoundId = Util.GetCDNAsset(soundid)
	UISound.Music.Name = soundname
	UISound.Music:Stop()
	task.wait()
	UISound.Music.TimePosition = 0
	task.wait()
	UISound.Music:Play()
	task.wait()
	MusicPlayer.Switching = false
	if #UISound.Music.SoundId == 0 then MusicPlayer.PlayMusic() end
end
UISound.Music.Ended:Connect(function()
	MusicPlayer.PlayMusic()
end)

SaveData.SkipIntro = not not SaveData.SkipIntro
if SaveData.SkipIntro then
	MusicPlayer.PlayMusic()
else
	UISound.Music.Volume = 0
	MusicPlayer.PlayMusic(1)
	repeat RunService.RenderStepped:Wait() until UISound.Music.IsLoaded
	UISound.Music:Stop()
	task.wait()
	UISound.Music:Play()
	UISound.Music.Volume = 1
	UISound.Music.TimePosition = 0
	local scrolltexts = {
		"stevetherealone presents a script                                 ",
		"hi guys welcome to my game                                        ",
		"holy shit where did our friends go?               *gets vc warned*",
		"greetings to qpmbsjbvt for getting me into reanimation            ",
		"those who know the place called ajman, dubai, uae                 ",
		":3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 >:3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3",
		"quick intro and quick scrolltext                                                                   hi i like dih",
		"meeeooowwwwwwwwww >:3                                          maw",
		"wwwwwwwwwwwwwwwwwww                         grass                 ",
		"erika's the towers                            sfoth iv update when",
		"i will leak all ur script i will leak all ur script i will leak al",
		"kasil loves gooning to everybody                                  ",
		"fflags are dead lol                                               ",
		"imagine being called a dummy                                      ",
		"nothing beats a jet 2 holiday. and right now, im beating myself to",
		"hi                          ...                oxide more like sui",
		"even if I mope, nothing good will happen! if i worked hard today, today will be perfecto!",
		"hi                          ...                                   ",
		"who the fuck even reads this??                     hi guys        ",
		"          trust me the ui looks good             here it comes    ",
		"is this even a btp legends release?? i myself dk if it should be  ",
		"dying is scary, but living is difficult                               dying: gifted scary; living: pure difficult",
		"but i halter my forethought, i keep on running like a chicken with his dih",
		"kaiya sounds like a perfect name for a genshin impact character   ",
		"this is an intro lol                        ",
		"greetings to myworld for helping with -net less                   ",
		"Omega-Skidded Immortality Lord Diddy Blud On The Calculator       ",
		"all UI music credits to dubmood, zabutom, ogge and 4mat           ",
		"heres the triforce                and heres my name                              ",
		"skids are now taking credit of this entire script, meaning its so good           ",
		"whenever i see hat reanimation nowadays i check to see if they are collidable    ",
	}
	scrolltexts = scrolltexts[math.random(1, #scrolltexts)]
	local fade = TweenService:Create(UIMainFrame, TweenInfo.new(5), {BackgroundTransparency = 0.5})
	fade:Play()
	local scrolltext = Util.MakeText(scrolltexts)
	scrolltext.Parent = UIMainFrame
	scrolltext.ZIndex = 0
	scrolltext.AnchorPoint = Vector2.new(0, 0.5)
	scrolltext.Position = UDim2.new(1.5, 0, 0.5, 0)
	Util.SetTextColor(scrolltext, Color3.new(1, 1, 1), 0.6)
	TweenService:Create(scrolltext, TweenInfo.new(5.256, Enum.EasingStyle.Linear), {
		Position = UDim2.new(1, 0, 0.5, 0),
		AnchorPoint = Vector2.new(1, 0.5),
	}):Play()
	local scrolltextratio = scrolltext.Size.X.Offset / scrolltext.Size.Y.Offset
	local Triforce1 = Util.MakeTriforce(3, Color3.new(1, 0.7, 0), 4)
	local Triforce2 = Util.MakeTriforce(3, Color3.new(0.8, 0.4, 0), 4)
	Triforce1.ZIndex = 2
	Triforce2.ZIndex = 1
	Triforce1.Parent = UIMainFrame
	Triforce2.Parent = UIMainFrame
	local TRI_offset = 0.01
	local TRI_height = 0.5
	local TRI_rot = 0
	local TRI_rotvel = 720
	local TRI_scale = 0
	local stevetherealone = Util.Instance("TextLabel", UIMainFrame)
	stevetherealone.TextScaled = true
	stevetherealone.Font = Enum.Font.Arcade
	stevetherealone.TextColor3 = Color3.new(1, 1, 1)
	stevetherealone.BackgroundColor3 = Color3.new(0, 0, 0)
	stevetherealone.BackgroundTransparency = 0
	stevetherealone.BorderColor3 = Color3.new(1, 1, 1)
	stevetherealone.BorderSizePixel = 8
	stevetherealone.AnchorPoint = Vector2.new(0.5, 0.5)
	stevetherealone.Position = UDim2.new(0.5, 0, 0.5, 0)
	stevetherealone.Size = UDim2.new(0, 0, 0, 0)
	stevetherealone.Visible = false
	stevetherealone.ZIndex = 3
	local stevetherealone_padding = Util.Instance("UIPadding", stevetherealone)
	stevetherealone_padding.PaddingLeft = UDim.new(0, 10)
	stevetherealone_padding.PaddingRight = UDim.new(0, 10)
	stevetherealone_padding.PaddingTop = UDim.new(0, 10)
	stevetherealone_padding.PaddingBottom = UDim.new(0, 10)
	while true do
		local dt = RunService.Heartbeat:Wait()
		local t = UISound.Music.TimePosition
		if t >= 5.256 then break end
		local screensize = Util.GetScreenSize()
		local ysize = screensize.Y
		local height = ysize / 3
		scrolltext.Size = UDim2.fromOffset(height * scrolltextratio * 0.5, height)
		TRI_rot = (TRI_rot + TRI_rotvel * dt) % 360
		TRI_rotvel *= math.exp(-0.25 * dt)
		Triforce1.Size = UDim2.fromOffset(TRI_scale * ysize * 0.8, TRI_scale * ysize * 0.8)
		if t >= 4.256 then
			local a = t - 4.256
			Triforce1.Size = Triforce1.Size:Lerp(UDim2.fromOffset(160, 160), a)
			TRI_height = 0.5 + (15 / ysize) * a
		end
		Triforce2.Size = Triforce1.Size
		Triforce1.Position = UDim2.new(0.5, ysize * -TRI_offset, TRI_height, ysize * -TRI_offset)
		Triforce2.Position = UDim2.new(0.5, 0, TRI_height, 0)
		Triforce1.Rotation = TRI_rot
		Triforce2.Rotation = TRI_rot
		if t < 4.256 then
			TRI_scale = 1 - ((1 - math.min(1, t / 3)) ^ 2)
		else
			local a = t - 4.256
			TRI_scale = 1 + a * 13
			if a > 0.5 then
				Triforce1.ZIndex = 5
				Triforce2.ZIndex = 4
			else
				Triforce1.ZIndex = 2
				Triforce2.ZIndex = 1
			end
		end
		if t < 2.152 then
			stevetherealone.Text = ""
			stevetherealone.Visible = false
		elseif t < 2.652 then
			local a = (t - 2.152) / 0.5
			local z = 20 * ((a * 100) // 20)
			stevetherealone.Text = ""
			stevetherealone.Visible = true
			stevetherealone.Size = UDim2.fromOffset(z, z)
		elseif t < 4.756 then
			stevetherealone.Text = "STEVE\nTHERE\nALONE"
			stevetherealone.Visible = true
			stevetherealone.Size = UDim2.fromOffset(100, 100)
		else
			local a = (t - 4.756) / 0.5
			local x = 20 * ((a * 260 + 100) // 20)
			local y = 20 * ((math.min(1, a / 0.538) * 140 + 100) // 20)
			stevetherealone.Text = ""
			stevetherealone.Visible = true
			stevetherealone.Size = UDim2.fromOffset(x, y)
			stevetherealone.Position = UDim2.new(0.5, 0, 0.5, 0)
		end
	end
	stevetherealone:Destroy()
	Triforce1:Destroy()
	Triforce2:Destroy()
	scrolltext:Destroy()
	fade:Cancel()
	UIMainFrame.BackgroundTransparency = 1
	local flash = Util.Instance("Frame", UIMainFrame)
	flash.AnchorPoint = Vector2.new(0, 0)
	flash.Position = UDim2.new(0, 0, 0, 0)
	flash.Size = UDim2.new(1, 0, 1, 0)
	flash.BackgroundColor3 = Color3.new(1, 1, 1)
	flash.BackgroundTransparency = 0
	flash.BorderSizePixel = 0
	flash.Interactable = false
	flash.ZIndex = 256
	TweenService:Create(flash, TweenInfo.new(1), {
		BackgroundTransparency = 1
	}):Play()
	Debris:AddItem(flash, 1)
end

SaveData.MuteUIMusic = not not SaveData.MuteUIMusic
SaveData.MuteReanimMusic = not not SaveData.MuteReanimMusic
SaveData.MuteUISound = not not SaveData.MuteUISound

if SaveData.MuteUIMusic then
	if SaveData.SkipIntro then
		UISound.Music.Volume = 0
	else
		TweenService:Create(UISound.Music, TweenInfo.new(3, Enum.EasingStyle.Linear), {
			Volume = 0
		}):Play()
	end
end

local StylizedObjs = {}
local function Stylize(obj, options)
	options = options or {}
	Util.Instance("UICorner", obj).CornerRadius = UDim.new(0, 5)
	local Out = Util.Instance("UIStroke", obj)
	Out.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	Out.Color = Color3.new(1, 1, 1)
	Out.LineJoinMode = Enum.LineJoinMode.Round
	Out.Thickness = 1
	Out.Transparency = 0
	Out.Enabled = true
	obj.BackgroundColor3 = Color3.new(0, 0, 0)
	local Glos = {}
	if options.Glow == true then
		local GloF = Util.Instance("Frame", UIMainFrame)
		Util.LinkDestroyI2I(obj, GloF)
		GloF.Interactable = false
		GloF.BackgroundTransparency = 1
		local function update()
			GloF.AnchorPoint = obj.AnchorPoint
			GloF.Position = obj.Position - Util.Vector2ToUDim2Offset((obj.AnchorPoint * 2 - Vector2.one) * 5)
			GloF.Size = obj.Size - UDim2.fromOffset(10, 10)
			GloF.Visible = obj.Visible
			GloF.ZIndex = obj.ZIndex - 2
		end
		update()
		obj.Changed:Connect(update)
		local tex = Util.GetCDNAsset("lightinursoul.graphic.png")
		for x=0, 2 do
			for y=0, 2 do
				local Glo = Util.Instance("ImageLabel", GloF)
				Glo.AnchorPoint = Vector2.new(1 - math.min(x, 1), 1 - math.min(y, 1))
				Glo.Position = UDim2.fromScale(math.max(x - 1, 0), math.max(y - 1, 0))
				Glo.Size = UDim2.new(1 - math.abs(x - 1), x == 1 and 0 or 32, 1 - math.abs(y - 1), y == 1 and 0 or 32)
				Glo.BackgroundTransparency = 1
				Glo.Image = tex
				Glo.ImageRectOffset = Vector2.new(math.min(x, 1) * 256, math.min(y, 1) * 256)
				Glo.ImageRectSize = Vector2.new(x == 1 and 0 or 256, y == 1 and 0 or 256)
				table.insert(Glos, Glo)
			end
		end
	end
	table.insert(StylizedObjs, {
		obj = obj,
		Out = Out,
		Glos = Glos,
		options = options,
	})
end
local ForceUIColor = nil
local ForceUIBGColor = nil
local function GetUIColor(t)
	if ForceUIColor then
		local si = math.sin(math.pi * 2 * t / 10)
		local h, s, v = ForceUIColor:ToHSV()
		if s < 0.2 then
			v *= 0.8 + si * 0.2
		else
			h += si * 0.01
		end
		return Util.LoopedHSV(h, s, v)
	end
	return Util.LoopedHSV(t / 10, 0.8, 1)
end
local function GetUIBGColor(t)
	if ForceUIBGColor then
		local si = math.sin(math.pi * 2 * t / 10)
		local h, s, v = ForceUIBGColor:ToHSV()
		if s < 0.2 then
			if v > 0.5 then
				v *= 0.95 + si * 0.05
			else
				v *= 1.05 + si * 0.05
			end
		else
			h += si * 0.01
		end
		return Util.LoopedHSV(h, s, v)
	end
	return Color3.new(0, 0, 0)
end
local UITextColor = Util.Instance("Color3Value")
UITextColor.Value = Color3.new(1, 1, 1)
local function RegisterTextLabel(obj)
	if obj:IsA("TextLabel") or obj:IsA("TextButton") then
		obj.TextColor3 = UITextColor.Value
		Util.LinkDestroyI2C(obj, UITextColor.Changed:Connect(function(val)
			obj.TextColor3 = val
		end))
	end
	if obj:IsA("TextBox") then
		local h, s, v = UITextColor.Value:ToHSV()
		obj.TextColor3 = UITextColor.Value
		obj.PlaceholderColor3 = Color3.fromHSV(h, s, 0.5 + (v - 0.5) * 0.4)
		Util.LinkDestroyI2C(obj, UITextColor.Changed:Connect(function(val)
			h, s, v = val:ToHSV()
			obj.TextColor3 = val
			obj.PlaceholderColor3 = Color3.fromHSV(h, s, 0.5 + (v - 0.5) * 0.4)
		end))
	end
end
local function UpdateGrads(t)
	local c = GetUIColor(t)
	local bgc = GetUIBGColor(t)
	local h, s, v = bgc:ToHSV()
	local bgcd = Color3.fromHSV(h, s, v * 0.9)
	local h2, s2, v2 = c:ToHSV()
	local glc = c
	if v > v2 then
		glc = bgc
	end
	for _,grad in StylizedObjs do
		local obj, Out, Glos, options = grad.obj, grad.Out, grad.Glos, grad.options
		Out.Color = c
		if options.Depthed then
			obj.BackgroundColor3 = bgcd
		else
			obj.BackgroundColor3 = bgc
		end
		for _,v in Glos do
			v.ImageColor3 = glc
		end
	end
end
local function SetUITheme(index)
	local UIThemes = {
		-- RGB/Default
		{nil, nil, Color3.new(1, 1, 1)},
		-- ALONE
		{Color3.new(1, 1, 1), nil, Color3.new(1, 1, 1)},
		-- Oxide
		{Color3.fromRGB(49, 203, 233), Color3.fromRGB(38, 38, 38), Color3.fromRGB(49, 203, 233)},
		-- Patchma-like
		{Color3.new(0.0941177, 0.317647, 0.878431), nil, Color3.new(0.560784, 0.560784, 0.560784)},
		-- Genesis V4 - Neptunian V
		{Color3.fromHex("7733FF"), Color3.fromHex("161330"), Color3.new(1, 1, 1)},
		-- Crimson
		{Color3.new(0.9, 0, 0), Color3.new(0.05, 0, 0), Color3.new(1, 1, 1)},
		-- r/masterhacker
		{Color3.new(0, 1, 0), nil, Color3.new(0, 1, 0)},
		-- Homer simpson
		{Color3.new(0, 0, 0), Color3.new(1, 0.95, 0), Color3.new(0, 0, 0)},
		-- Immortality Lord
		{Color3.new(0.1, 0.1, 0.1), nil, Color3.new(1, 1, 1)},
		-- RGB LIGHT
		{nil, Color3.new(1, 1, 1), Color3.new(0, 0, 0)},
		-- ALONE LIGHT
		{Color3.new(0, 0, 0), Color3.new(1, 1, 1), Color3.new(0, 0, 0)},
		-- ROSR
		{Color3.new(0, 0, 0), Color3.new(1, 0.6, 0), Color3.new(1, 1, 1)},
		-- FastTracker II Blue
		{Color3.fromHex("333780"), Color3.fromHex("666EFF"), Color3.new(1, 1, 1)},
		-- Cherry Blossom
		{Color3.fromHex("75284B"), Color3.fromHex("F7ABE8"), Color3.fromHex("75284B")},
		-- Cherry Blossom Inverted
		{Color3.fromHex("F7ABE8"), Color3.fromHex("75284B"), Color3.new(1, 1, 1)},
		-- Tommorow Night 80s
		{Color3.fromHex("272727"), Color3.fromHex("2D2D2D"), Color3.fromHex("BEBEBE")},
	}
	local theme = UIThemes[index]
	if index == #UIThemes + 1 then
		theme = {nil, nil, Color3.new(1, 1, 1)}
		local function processtable(t)
			if typeof(t.Fore) == "Color3" then
				theme[1] = t.Fore
			end
			if typeof(t.Back) == "Color3" then
				theme[2] = t.Back
			end
			if typeof(t.Text) == "Color3" then
				theme[3] = t.Text
			end
			if typeof(t.Fore) == "string" then
				theme[1] = Color3.fromHex(t.Fore)
			end
			if typeof(t.Back) == "string" then
				theme[2] = Color3.fromHex(t.Back)
			end
			if typeof(t.Text) == "string" then
				theme[3] = Color3.fromHex(t.Text)
			end
		end
		if type(_G.UhhhhhhTheme) == "table" and getmetatable(_G.UhhhhhhTheme) == nil then
			processtable(_G.UhhhhhhTheme)
			SaveData.UIThemeUserDefined = {
				Fore = theme[1] and theme[1]:ToHex(),
				Back = theme[2] and theme[2]:ToHex(),
				Text = theme[3] and theme[3]:ToHex() or "FFFFFF",
			}
		elseif type(SaveData.UIThemeUserDefined) == "table" then
			processtable(SaveData.UIThemeUserDefined)
		end
	end
	if theme then
		ForceUIColor = theme[1]
		ForceUIBGColor = theme[2]
		UITextColor.Value = theme[3]
	end
end
SaveData.UITheme = SaveData.UITheme or 1
SetUITheme(SaveData.UITheme)

UISound.Click = Util.Instance("Sound", UIMainFrame)
UISound.Click.SoundId = "rbxassetid://6324790483"
UISound.Click.Volume = 1
UISound.Click.PlaybackSpeed = 2
if SaveData.MuteUISound then
	UISound.Click.Volume = 0
end

local CracktroFrameText = "Uhhhhhh Reanimate V" .. UhhhhhhVersion
local UIMainWindow, WindowContent do
	UIMainWindow = Util.Instance("Frame", UIMainFrame)
	UIMainWindow.Active = true
	UIMainWindow.AnchorPoint = Vector2.new(0.5, 0.5)
	UIMainWindow.Position = UDim2.new(0.5, 0, 0.5, 0)
	UIMainWindow.Size = UDim2.new(0, 360, 0, 240)
	UIMainWindow.BackgroundTransparency = 0
	UIMainWindow.BackgroundColor3 = Color3.new(1, 1, 1)
	UIMainWindow.BorderSizePixel = 0
	Stylize(UIMainWindow, {
		Glow = true
	})
	local _clicksndclicked = false
	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			_clicksndclicked = false
		end
	end)
	local function _registerclicksnd(v)
		if v:GetAttribute("ClickSnd") then return end
		v:SetAttribute("ClickSnd", true)
		v.InputBegan:Connect(function(input)
			if _clicksndclicked then return end
			if input.UserInputState ~= Enum.UserInputState.Begin then return end
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				UISound.Click:Play()
				_clicksndclicked = true
			end
		end)
	end
	_registerclicksnd(UIMainWindow)
	UIMainWindow.DescendantAdded:Connect(function(v)
		if v:IsA("GuiObject") then
			_registerclicksnd(v)
		end
	end)
	
	local TopBarFrame = Util.Instance("Frame", UIMainWindow)
	TopBarFrame.Position = UDim2.new(0, 0, 0, 0)
	TopBarFrame.Size = UDim2.new(1, 0, 0, 30)
	TopBarFrame.BackgroundTransparency = 0
	TopBarFrame.BackgroundColor3 = Color3.new(1, 1, 1)
	TopBarFrame.BorderSizePixel = 0
	TopBarFrame.ClipsDescendants = true
	TopBarFrame.ZIndex = 1
	Stylize(TopBarFrame)
	
	local TopBarText = Util.Instance("TextLabel", TopBarFrame)
	TopBarText.AnchorPoint = Vector2.new(0, 0.5)
	TopBarText.Position = UDim2.new(0, 8, 0.5, 0)
	TopBarText.Size = UDim2.new(1, -35, 1, 0)
	TopBarText.BackgroundTransparency = 1
	TopBarText.ClipsDescendants = true
	TopBarText.Font = Enum.Font.Code
	TopBarText.TextColor3 = Color3.new(1, 1, 1)
	TopBarText.TextSize = 20
	TopBarText.TextXAlignment = Enum.TextXAlignment.Left
	TopBarText.Text = "Uhhhhhh Reanimate | v" .. UhhhhhhVersion
	TopBarText.RichText = true
	RegisterTextLabel(TopBarText)
	if (SaveData.SkipIntro and math.random(2) == 1) or os.date("%m %d") ~= "04 01" then
		local quotes = {
			"Ohhhhhh Re-create | v" .. UhhhhhhVersion,
			"jumpscare",
			"you'll never see it coming",
			Player.Name .. "'s Uhhhhhh Session",
			"genesis hat collide releaser admin gui",
			"Delta Executor",
			"optimise the optimised",
			":troll:",
			"solara executor",
			"wait a minute smth aint right",
			"gta6 releaser",
			"HD Admin",
			"The Return Of STEVE's Roserika",
			"HI",
			"<font color=\"#00DDFF\">Oxide</font> Version 67",
			"currentangle v5",
			"patchma hub by <font color=\"#0000FF\">MyWorld</font>",
			"Genesis FE with extra steps",
		}
		if os.date("%m") == "12" and math.random(4) == 1 then
			quotes = {
				"ho ho ho",
				"dess from deltarune",
				"jesus christmas",
				"Happy Xmas, " .. Player.Name,
				"Razor1911 says... SOCIALIZE!",
				"UHHHHHHHHHHHHHHHHHHHHHHHHHHHH",
				"its cold outside get in here",
				"christmas tree builder",
				"UHHHH]",
			}
		end
		if os.date("%m") == "01" and math.random(4) == 1 then
			quotes = {
				"new year new me",
				"HAVE A HAPPY NEW YEAR",
				"A NEW YEAR??",
				"New Years, " .. Player.Name,
				"did u explode yet?",
				"KEEP YER KIDS SAFE FROM FIREWORK",
				"kaboom? yes rico, kaboom.",
			}
		end
		local aprilfools = os.date("%m") == "04 01"
		if aprilfools then
			local troll = math.random(3)
			if troll == 1 then
				CracktroFrameText = "Oxide Reanimation V67"
				quotes = {"<font color=\"#00DDFF\">Oxide</font>   Reanimation"}
				SetUITheme(3)
			end
			if troll == 2 then
				CracktroFrameText = "patchma hub V67"
				quotes = {"<font color=\"#0000FF\">patchma hub</font> by MyWorld"}
				SetUITheme(4)
			end
			if troll == 3 then
				CracktroFrameText = "Genesis V4 but better"
				quotes = {"<font color=\"#CC11FF\">Genesis V4 - Neptunian V</font>"}
				SetUITheme(5)
			end
		end
		TopBarText.Text = quotes[math.random(1, #quotes)]
		if not aprilfools then
			task.delay(2, function()
				TopBarText.Text = "Uhhhhhh Reanimate | v" .. UhhhhhhVersion
			end)
		end
	end
	
	local TopBarClose = Util.Instance("TextButton", TopBarFrame)
	TopBarClose.AnchorPoint = Vector2.new(1, 0)
	TopBarClose.Position = UDim2.new(1, 0, 0, 0)
	TopBarClose.Size = UDim2.new(0, 30, 1, 0)
	TopBarClose.BackgroundTransparency = 1
	TopBarClose.Text = ""
	do
		local A = Util.Instance("Frame", TopBarClose)
		A.AnchorPoint = Vector2.new(0.5, 0.5)
		A.Position = UDim2.new(0.5, 0, 0.5, 0)
		A.Size = UDim2.new(0, 16, 0, 2)
		A.Rotation = 0
		A.BackgroundTransparency = 0
		A.BackgroundColor3 = UITextColor.Value
		A.BorderSizePixel = 0
		A.Name = "A"
		A = Util.Instance("Frame", A)
		A.AnchorPoint = Vector2.new(0.5, 0.5)
		A.Position = UDim2.new(0.5, 0, 0.5, 0)
		A.Size = UDim2.new(0, 2, 0, 0)
		A.Rotation = 0
		A.BackgroundTransparency = 0
		A.BackgroundColor3 = UITextColor.Value
		A.BorderSizePixel = 0
		A.Name = "B"
		UITextColor.Changed:Connect(function(val)
			TopBarClose.A.BackgroundColor3 = val
			TopBarClose.A.B.BackgroundColor3 = val
		end)
	end
	
	WindowContent = Util.Instance("Frame", UIMainWindow)
	WindowContent.Position = UDim2.new(0, 0, 0, 30)
	WindowContent.Size = UDim2.new(1, 0, 1, -35)
	WindowContent.BackgroundTransparency = 1
	WindowContent.ClipsDescendants = true
	WindowContent.ZIndex = 0
	
	local MainWindowClosed = false
	local MainWindowTweening = false
	local MainWindowPosOpen = nil
	local MainWindowPosClose = nil
	if SaveData.WindowClosedPosition then
		MainWindowPosClose = UDim2.new(unpack(SaveData.WindowClosedPosition))
	end
	TopBarClose.Activated:Connect(function()
		if MainWindowTweening then return end
		MainWindowTweening = true
		MainWindowClosed = not MainWindowClosed
		if MainWindowClosed then
			MainWindowPosOpen = UIMainWindow.Position
			TweenService:Create(UIMainWindow, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
				Position = MainWindowPosClose,
				Size = UDim2.fromOffset(112, 30)
			}):Play()
			TweenService:Create(TopBarClose.A, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
				Rotation = 180
			}):Play()
			TweenService:Create(TopBarClose.A.B, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
				Size = UDim2.new(0, 2, 0, 16)
			}):Play()
			task.delay(0.6, function()
				WindowContent.Visible = false
				MainWindowTweening = false
			end)
		else
			WindowContent.Visible = true
			MainWindowPosClose = UIMainWindow.Position
			SaveData.WindowClosedPosition = {MainWindowPosClose.X.Scale, MainWindowPosClose.X.Offset, MainWindowPosClose.Y.Scale, MainWindowPosClose.Y.Offset}
			TweenService:Create(UIMainWindow, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
				Position = MainWindowPosOpen,
				Size = UDim2.fromOffset(360, 240)
			}):Play()
			TweenService:Create(TopBarClose.A, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
				Rotation = 0
			}):Play()
			TweenService:Create(TopBarClose.A.B, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
				Size = UDim2.new(0, 2, 0, 0)
			}):Play()
			task.delay(0.6, function()
				MainWindowTweening = false
			end)
		end
		WindowContent.Active = not MainWindowClosed
		WindowContent.Interactable = not MainWindowClosed
	end)
	
	local dragref = nil
	local offset = Vector2.new(0, 0)
	TopBarFrame.InputBegan:Connect(function(input)
		if dragref then return end
		if input.UserInputState ~= Enum.UserInputState.Begin then return end
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			WindowContent.Interactable = false
			local screen = Util.GetScreenSize()
			local ch = (Vector2.new(input.Position.X, input.Position.Y) + SCREENGUI.AbsolutePosition) / screen
			offset = Util.UDim2ToVector2Scale(UIMainWindow.Position) - ch
			dragref = input
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if dragref then
			if input.UserInputType == Enum.UserInputType.MouseMovement or (input.UserInputType == Enum.UserInputType.Touch and dragref == input) then
				local screen = Util.GetScreenSize()
				local ch = (Vector2.new(input.Position.X, input.Position.Y) + SCREENGUI.AbsolutePosition) / screen
				local pos = ch + offset
				UIMainWindow.Position = Util.Vector2ToUDim2Scale(pos)
			end
		end
	end)
	UserInputService.InputEnded:Connect(function(input)
		if dragref and dragref == input then
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				WindowContent.Interactable = true
				dragref = nil
			end
		end
	end)
end

local _funcrefreshes = {}
local function AddToRenderStep(func, linkto)
	table.insert(_funcrefreshes, func)
	if linkto then
		linkto.Destroying:Connect(function()
			local i = table.find(_funcrefreshes, func)
			if i then
				table.remove(_funcrefreshes, i)
			end
		end)
	end
	return func
end
local _totalrendertime = 0
RunService:BindToRenderStep("Uhhhhhh_Render" .. Util.RandomString(), Enum.RenderPriority.Last.Value - 69, function(dt)
	_totalrendertime += dt
	UpdateGrads(_totalrendertime)
	WindowContent.Visible = UIMainWindow.Size.Y.Offset > 35
	for _,func in _funcrefreshes do
		local s, e = pcall(func, _totalrendertime, dt)
		if not s then warn(e) end
	end
end)

local CracktroFrame = Util.Instance("Frame", WindowContent)
CracktroFrame.Active = true
CracktroFrame.AnchorPoint = Vector2.new(0.5, 0.5)
CracktroFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
CracktroFrame.Size = UDim2.new(0, 360, 0, 205)
CracktroFrame.BackgroundTransparency = 0
CracktroFrame.BackgroundColor3 = Color3.new(0, 0, 0)
CracktroFrame.BorderSizePixel = 1
CracktroFrame.BorderColor3 = Color3.new(1, 1, 1)
CracktroFrame.ZIndex = 10
CracktroFrame.ClipsDescendants = true
AddToRenderStep(function(t)
	CracktroFrame.BorderColor3 = GetUIColor(t)
	CracktroFrame.BackgroundColor3 = GetUIBGColor(t)
end, CracktroFrame)

do -- homepage
	local TriforceClip = Util.Instance("CanvasGroup", CracktroFrame)
	TriforceClip.Position = UDim2.new(0, 0, 0, 0)
	TriforceClip.Size = UDim2.new(1, 0, 1, 0)
	TriforceClip.BackgroundTransparency = 1
	TriforceClip.ZIndex = 0

	local Glowy = Util.Instance("ImageLabel", CracktroFrame)
	Glowy.AnchorPoint = Vector2.new(0.5, 0.5)
	Glowy.Position = UDim2.new(0.5, 0, 0.5, 0)
	Glowy.Size = UDim2.new(0, 260, 0, 260)
	Glowy.BackgroundTransparency = 1
	Glowy.Image = Util.GetCDNAsset("lightinursoul.graphic.png")
	Glowy.ImageColor3 = UITextColor.Value
	Glowy.ImageTransparency = 0.7
	Glowy.ZIndex = -2

	local Triforce = Util.MakeTriforce(3, Color3.new(1, 0.7, 0), 0)
	Triforce.AnchorPoint = Vector2.new(0.5, 0.5)
	Triforce.Position = UDim2.new(0.5, 0, 0.5, 0)
	Triforce.Size = UDim2.new(0, 160, 0, 160)
	Triforce.Parent = TriforceClip

	local particles = {}
	local ps = 128
	local psc = Color3.new(1, 0.9, 0)
	for i=1, ps do
		local r = (i / ps) * 2 * math.pi
		local p = Util.Instance("Frame", CracktroFrame)
		p.AnchorPoint = Vector2.new(0.5, 0.5)
		p.Size = UDim2.fromOffset(2, 2)
		p.BackgroundColor3 = psc
		p.BackgroundTransparency = 0
		p.BorderSizePixel = 0
		p.ZIndex = -1
		p.Visible = false
		table.insert(particles, {
			p, Vector2.new(math.sin(r), math.cos(r)) * 8,
			Vector2.new(math.random(-128, 128), math.random(-128, 128)),
			math.random() * 2 - 1, false, -1
		})
	end

	local trivel = 360
	local oldpbl = 0

	local text = Util.MakeText(CracktroFrameText)
	text.AnchorPoint = Vector2.new(0.5, 1)
	text.Position = UDim2.new(0.5, 0, 1, -25)
	text.ZIndex = 3
	text.Parent = CracktroFrame
	local text0 = Util.MakeText("Discord: discord.gg/NASNUKRBVM")
	text0.AnchorPoint = Vector2.new(0.5, 1)
	text0.Position = UDim2.new(0.5, 0, 1, -17)
	text0.ZIndex = 3
	text0.Parent = CracktroFrame
	local text1 = Util.MakeText("Made by STEVETHEREALONE :" .. (math.random() < 0.333 and "3" or (math.random() < 0.5 and "D" or "P")))
	text1.AnchorPoint = Vector2.new(0.5, 1)
	text1.Position = UDim2.new(0.5, 0, 1, -17)
	text1.ZIndex = 3
	text1.Parent = CracktroFrame
	local text2 = Util.MakeText("Click me to start!")
	text2.AnchorPoint = Vector2.new(0.5, 1)
	text2.Position = UDim2.new(0.5, 0, 1, -17)
	text2.ZIndex = 3
	text2.Parent = CracktroFrame
	Util.SetTextColor(text, UITextColor.Value, 0)
	Util.SetTextColor(text0, UITextColor.Value, 0)
	Util.SetTextColor(text1, UITextColor.Value, 0)
	Util.SetTextColor(text2, UITextColor.Value, 0)
	local quotes = {
		"\"EVERY CLIENT ORBITS A SERVER...\"",
		Player.Name .. ", how is your " .. os.date("%A") .. "?",
		"A great " .. os.date("%A") .. " today, eh?",
		"Hello, " .. Player.Name .. ".",
		"What makes you play at " .. os.date("%I %p") .. "?",
		"You are going to love Uhhhhhh, I just know it.",
		"This script is very \"verbose\".",
		"Written mostly on a mobile phone.",
		"I am pretty new in this community! :D",
		"\"Dreams come true!\"",
		"Idea originated from a dream.",
		"If you love this program, join my Discord!",
	}
	local text3 = nil
	local function changequote()
		if text3 then text3:Destroy() end
		text3 = Util.MakeText(quotes[math.random(1, #quotes)])
		text3.AnchorPoint = Vector2.new(0.5, 1)
		text3.Position = UDim2.new(0.5, 0, 1, -17)
		text3.ZIndex = 3
		text3.Parent = CracktroFrame
		Util.SetTextColor(text3, UITextColor.Value, 0)
		task.delay(12, changequote)
	end
	changequote()
	UITextColor.Changed:Connect(function(val)
		Util.SetTextColor(text, val, 0)
		Util.SetTextColor(text0, val, 0)
		Util.SetTextColor(text1, val, 0)
		Util.SetTextColor(text2, val, 0)
		Util.SetTextColor(text3, val, 0)
	end)

	local PositionProcessor = {
		function(i, v, dt, pbl, spike)
			local inst, pos, vel, zind, lvis, lzind = unpack(v)
			local d = pos.Magnitude
			if d > 0 then
				local r = math.atan2(pos.X / d, pos.Y / d)
				local a = math.pi * 0.375
				local out = Vector2.new(math.sin(r + a), math.cos(r + a))
				local tp = out * (40 + pbl / 12)
				local tv = (tp - pos) * 2
				vel = tv:Lerp(vel, math.exp(-2 * dt))
				if math.random() < 0.01 then
					vel += Vector2.new(math.random(-64, 64), math.random(-64, 64))
				end
				if spike > 64 then
					vel += out * 64 * math.random()
				end
				pos += vel * dt
			else
				pos += Vector2.new(0, 10)
			end
			v[2], v[3] = pos, vel
			return Vector3.new(zind * pos.Magnitude / 6, pos.Y, pos.X)
		end,
		function(i, v, dt, pbl, spike)
			local inst, pos, vel, zind, lvis, lzind = unpack(v)
			local a = i / ps
			local s = (a * 6) % 1
			local r = (a + s / 8) * 2 * math.pi + os.clock() * 2 + zind * math.pi * 0.125 * (pbl / 200) * (1 - s)
			pos = Vector2.new(math.sin(r), math.cos(r)) * s * (100 + pbl / 15)
			v[2], v[3] = pos, Vector2.zero
			return Vector3.new(0, pos.Y, pos.X)
		end,
		function(i, v, dt, pbl, spike)
			local inst, pos, vel, zind, lvis, lzind = unpack(v)
			local a = i / ps
			local b = 1 / 3
			local c = math.sqrt(3) / 2
			local d = {
				{Vector2.new(0, b + c), Vector2.new(-0.5, b)},
				{Vector2.new(-0.5, b), Vector2.new(-1, b - c)},
				{Vector2.new(-1, b - c), Vector2.new(0, b - c)},
				{Vector2.new(0, b - c), Vector2.new(1, b - c)},
				{Vector2.new(1, b - c), Vector2.new(0.5, b)},
				{Vector2.new(0.5, b), Vector2.new(0, b - c)},
				{Vector2.new(0, b - c), Vector2.new(-0.5, b)},
				{Vector2.new(-0.5, b), Vector2.new(0.5, b)},
				{Vector2.new(0.5, b), Vector2.new(0, b + c)},
			}
			local t = a * #d
			local i = math.floor(t) + 1
			local u = t % 1
			if i > #d then
				i = #d
				u = 1
			end
			pos = d[i][1]:Lerp(d[i][2], u) * 150
			local r = os.clock() * 2
			pos = Vector2.new(
				pos.X * math.cos(r) - pos.Y * math.sin(r),
				pos.X * math.sin(r) + pos.Y * math.cos(r)
			)
			v[2], v[3] = pos, Vector2.zero
			return Vector3.new(0, pos.Y, pos.X)
		end,
	}
	local currentprocessor = 1

	AddToRenderStep(function(t, dt)
		if Util.IsGuiVisible(CracktroFrame) then
			local pp = PositionProcessor[currentprocessor]
			local CracktroFrameAbsoluteSize = CracktroFrame.AbsoluteSize
			Glowy.ImageColor3 = UITextColor.Value
			Glowy.ImageTransparency = 0.75 + math.sin(((os.clock() / 10) % 2) * math.pi) * 0.05
			local pbl = UISound.Music.PlaybackLoudness
			local spike = math.max(0, (pbl - oldpbl) - 16)
			oldpbl = pbl
			local trivelt = pbl * 2 * dt
			trivel = trivelt + (trivel - trivelt) * math.exp(-8 * dt)
			Triforce.Rotation = (Triforce.Rotation + trivel) % 360
			local ring = CFrame.Angles(
				0,
				math.cos(((t / 5) % 2) * math.pi) * math.pi * 0.5,
				(1 - math.cos(((t / 7) % 2) * math.pi)) * math.pi * 0.5
			)
			local fov = 220
			for i,v in particles do
				local inst, pos, vel, zind, lvis, lzind = unpack(v)
				local sp = ring:VectorToWorldSpace(pp(i, v, dt, pbl, spike))
				local z = sp.Z
				local sc = fov / (z + fov)
				sp = Vector2.new(sp.X, sp.Y) * sc
				local nvis, nzind = lvis, lzind
				if z > 1 - fov then
					inst.Position = Util.Vector2ToUDim2Offset(sp + CracktroFrameAbsoluteSize / 2)
					inst.Size = UDim2.fromOffset(sc * 2.5, sc * 2.5)
					--inst.BackgroundColor3 = psc:Lerp(Color3.new(0, 0, 0), math.clamp(z / (fov * 2), 0, 1))
					nvis = true
					if z > 0 then
						nzind = -1
					else
						nzind = 1
					end
				else
					nvis = false
				end
				if lvis ~= nvis then
					inst.Visible = nvis
					v[5] = nvis
				end
				if lzind ~= nzind then
					inst.ZIndex = nzind
					v[6] = nzind
				end
			end
			local textsel = t % 9
			if IsUhhhhhhFullyLoaded then
				textsel = t % 12
			end
			textsel //= 3
			if textsel == 0 then
				text0.Visible = true
				text1.Visible = false
				text2.Visible = false
				text3.Visible = false
			elseif textsel == 1 then
				text0.Visible = false
				text1.Visible = true
				text2.Visible = false
				text3.Visible = false
			elseif textsel == 2 then
				text0.Visible = false
				text1.Visible = false
				text2.Visible = false
				text3.Visible = true
			else
				text0.Visible = false
				text1.Visible = false
				text2.Visible = true
				text3.Visible = false
			end
		else
			currentprocessor = math.random(1, #PositionProcessor)
		end
	end, CracktroFrame)
end
task.wait()

local UI = {}
function UI.CreatePage()
	local Frame = Util.Instance("ScrollingFrame", WindowContent)
	Frame.AnchorPoint = Vector2.new(0.5, 0.5)
	Frame.Position = UDim2.new(0.5, 0, 0.5, 0)
	Frame.Size = UDim2.new(0, 360, 0, 205)
	Frame.BackgroundTransparency = 0
	Frame.BackgroundColor3 = Color3.new(0, 0, 0)
	Frame.BorderSizePixel = 1
	Frame.BorderColor3 = Color3.new(1, 1, 1)
	Frame.Visible = true
	Frame.ZIndex = 0
	Frame.AutomaticCanvasSize = Enum.AutomaticSize.Y
	Frame.CanvasSize = UDim2.new(0, 0, 0, 0)
	Frame.ScrollingDirection = Enum.ScrollingDirection.Y
	Frame.ScrollBarThickness = 0
	Frame.ClipsDescendants = true
	AddToRenderStep(function(t)
		Frame.BorderColor3 = GetUIColor(t)
		Frame.BackgroundColor3 = GetUIBGColor(t)
	end, Frame)
	local Padding = Util.Instance("UIPadding", Frame)
	Padding.PaddingTop = UDim.new(0, 5)
	Padding.PaddingBottom = UDim.new(0, 0)
	Padding.PaddingLeft = UDim.new(0, 0)
	Padding.PaddingRight = UDim.new(0, 0)
	local UIList = Util.Instance("UIListLayout", Frame)
	UIList.FillDirection = Enum.FillDirection.Vertical
	UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center
	UIList.VerticalAlignment = Enum.VerticalAlignment.Top
	UIList.Padding = UDim.new(0, 0)
	UIList.SortOrder = Enum.SortOrder.LayoutOrder
	return Frame
end
function UI.CreateText(parent, text, size, alignment)
	local margin = 5
	local Container = Util.Instance("Frame", parent)
	Container.AnchorPoint = Vector2.new(0.5, 0)
	Container.Size = UDim2.new(1, 0, 0, 65536)
	Container.BackgroundTransparency = 1
	Container.LayoutOrder = #parent:GetChildren()
	local Text = Util.Instance("TextLabel", Container)
	Text.Position = UDim2.new(0, margin, 0, 0)
	Text.Size = UDim2.new(1, margin * -2, 1, -margin)
	Text.BackgroundTransparency = 1
	Text.RichText = true
	Text.Font = Enum.Font.Code
	Text.TextColor3 = Color3.new(1, 1, 1)
	Text.TextTransparency = 0
	Text.TextXAlignment = alignment
	Text.TextYAlignment = Enum.TextYAlignment.Top
	Text.TextWrapped = true
	Text.TextSize = size
	RegisterTextLabel(Text)
	local function update()
		local x = parent.AbsoluteSize.X
		local size = TextService:GetTextSize(Text.ContentText, Text.TextSize, Text.Font, Vector2.new(x - margin * 2, math.huge))
		Container.Size = UDim2.new(1, 0, 0, size.Y + margin)
	end
	Text.Text = text
	update()
	Text.Changed:Connect(update)
	return Text
end
function UI.CreateSeparator(parent)
	local Container = Util.Instance("Frame", parent)
	Container.AnchorPoint = Vector2.new(0.5, 0)
	Container.Size = UDim2.new(1, 0, 0, 7)
	Container.BackgroundTransparency = 1
	Container.LayoutOrder = #parent:GetChildren()
	local Sep = Util.Instance("Frame", Container)
	Sep.AnchorPoint = Vector2.new(0.5, 0.5)
	Sep.Position = UDim2.new(0.5, 0, 0.5, 0)
	Sep.Size = UDim2.new(1, -8, 0, 1)
	Sep.BackgroundColor3 = UITextColor.Value
	Sep.BackgroundTransparency = 0.8
	Sep.BorderSizePixel = 0
	Util.LinkDestroyI2C(Sep, UITextColor.Changed:Connect(function(val)
		Sep.BackgroundColor3 = val
	end))
end
function UI.CreateButton(parent, text, size)
	local margin = 5
	local Container = Util.Instance("Frame", parent)
	Container.AnchorPoint = Vector2.new(0.5, 0)
	Container.Size = UDim2.new(1, 0, 0, 65536)
	Container.BackgroundTransparency = 1
	Container.LayoutOrder = #parent:GetChildren()
	local Button = Util.Instance("TextButton", Container)
	Button.AnchorPoint = Vector2.new(0, 0)
	Button.Position = UDim2.new(0, margin, 0, margin // 2)
	Button.Size = UDim2.new(1, margin * -2, 1, -margin)
	Button.BackgroundTransparency = 0
	Button.BackgroundColor3 = Color3.new(1, 1, 1)
	Button.BorderSizePixel = 0
	Button.Text = ""
	Button.AutoButtonColor = true
	local ButtonText = Util.Instance("TextLabel", Button)
	ButtonText.AnchorPoint = Vector2.new(0, 0.5)
	ButtonText.Position = UDim2.new(0, 0, 0.5, 0)
	ButtonText.Size = UDim2.new(1, 0, 1, -margin)
	ButtonText.BackgroundTransparency = 1
	ButtonText.RichText = true
	ButtonText.Font = Enum.Font.Code
	ButtonText.TextColor3 = Color3.new(1, 1, 1)
	ButtonText.TextTransparency = 0
	ButtonText.TextXAlignment = Enum.TextXAlignment.Center
	ButtonText.TextYAlignment = Enum.TextYAlignment.Center
	ButtonText.TextWrapped = true
	ButtonText.TextSize = size
	RegisterTextLabel(ButtonText)
	Stylize(Button)
	local function update()
		local x = parent.AbsoluteSize.X
		local size = TextService:GetTextSize(ButtonText.ContentText, ButtonText.TextSize, ButtonText.Font, Vector2.new(x - margin * 2, math.huge))
		Container.Size = UDim2.new(1, 0, 0, size.Y + margin * 2)
	end
	ButtonText.Text = text
	update()
	ButtonText.Changed:Connect(update)
	return Button, ButtonText
end
function UI.CreateSwitch(parent, text, value)
	local margin = 5
	local switchsize = 50
	local Container = Util.Instance("Frame", parent)
	Container.AnchorPoint = Vector2.new(0.5, 0)
	Container.Size = UDim2.new(1, 0, 0, 10)
	Container.BackgroundTransparency = 1
	Container.LayoutOrder = #parent:GetChildren()
	local Button = Util.Instance("TextButton", Container)
	Button.AnchorPoint = Vector2.new(0, 0)
	Button.Position = UDim2.new(0, 0, 0, 0)
	Button.Size = UDim2.new(1, 0, 1, 0)
	Button.BackgroundTransparency = 1
	Button.Text = ""
	local ButtonText = Util.Instance("TextLabel", Button)
	ButtonText.AnchorPoint = Vector2.new(0, 0)
	ButtonText.Position = UDim2.new(0, margin, 0, 0)
	ButtonText.Size = UDim2.new(1, margin * -3 - switchsize, 1, 0)
	ButtonText.BackgroundTransparency = 1
	ButtonText.RichText = true
	ButtonText.Font = Enum.Font.Code
	ButtonText.TextColor3 = Color3.new(1, 1, 1)
	ButtonText.TextTransparency = 0
	ButtonText.TextXAlignment = Enum.TextXAlignment.Left
	ButtonText.TextYAlignment = Enum.TextYAlignment.Center
	ButtonText.TextWrapped = true
	ButtonText.TextSize = 20
	RegisterTextLabel(ButtonText)
	local function update()
		local x = parent.AbsoluteSize.X
		local size = TextService:GetTextSize(ButtonText.ContentText, ButtonText.TextSize, ButtonText.Font, Vector2.new(x - margin * 3 - switchsize, math.huge))
		Container.Size = UDim2.new(1, 0, 0, math.max(35, size.Y))
	end
	ButtonText.Text = text
	update()
	ButtonText.Changed:Connect(update)
	local Switch = Util.Instance("Frame", Container)
	Switch.AnchorPoint = Vector2.new(1, 0.5)
	Switch.Position = UDim2.new(1, -margin, 0.5, 0)
	Switch.Size = UDim2.new(0, 25, 0, 25)
	Switch.BackgroundTransparency = 0
	Switch.BackgroundColor3 = Color3.new(0, 0, 0)
	Switch.BorderSizePixel = 0
	Util.Instance("UICorner", Switch).CornerRadius = UDim.new(0, 5)
	Stylize(Switch)
	local SwitchDot = Util.Instance("Frame", Switch)
	SwitchDot.AnchorPoint = Vector2.new(0.5, 0.5)
	SwitchDot.Position = UDim2.new(0.5, 0, 0.5, 0)
	SwitchDot.Size = UDim2.new(0, 19, 0, 19)
	SwitchDot.BackgroundTransparency = 0.2
	SwitchDot.BackgroundColor3 = UITextColor.Value
	SwitchDot.BorderSizePixel = 0
	Util.LinkDestroyI2C(SwitchDot, UITextColor.Changed:Connect(function(val)
		SwitchDot.BackgroundColor3 = val
	end))
	Util.Instance("UICorner", SwitchDot).CornerRadius = UDim.new(0, 2)
	local Lever = Util.Instance("BoolValue")
	Lever.Value = value
	local function updatesw()
		SwitchDot.Visible = Lever.Value
	end
	Lever.Changed:Connect(updatesw)
	updatesw()
	Button.Activated:Connect(function()
		Lever.Value = not Lever.Value
	end)
	return Lever, ButtonText
end
function UI.CreateTextbox(parent, text, placeholder, size)
	local margin = 5
	local Container = Util.Instance("Frame", parent)
	Container.AnchorPoint = Vector2.new(0.5, 0)
	Container.Size = UDim2.new(1, 0, 0, 65536)
	Container.BackgroundTransparency = 1
	Container.LayoutOrder = #parent:GetChildren()
	local Box = Util.Instance("Frame", Container)
	Box.AnchorPoint = Vector2.new(0, 0)
	Box.Position = UDim2.new(0, margin, 0, margin // 2)
	Box.Size = UDim2.new(1, margin * -2, 1, -margin)
	Box.BackgroundTransparency = 0
	Box.BackgroundColor3 = Color3.new(0.9, 0.9, 0.9)
	Box.BorderSizePixel = 0
	local BoxText = Util.Instance("TextBox", Box)
	BoxText.AnchorPoint = Vector2.new(0, 0.5)
	BoxText.Position = UDim2.new(0, 0, 0.5, 0)
	BoxText.Size = UDim2.new(1, 0, 1, -margin)
	BoxText.BackgroundTransparency = 1
	BoxText.Font = Enum.Font.Code
	BoxText.TextColor3 = Color3.new(1, 1, 1)
	BoxText.PlaceholderColor3 = Color3.new(0.7, 0.7, 0.7)
	BoxText.TextTransparency = 0
	BoxText.TextXAlignment = Enum.TextXAlignment.Center
	BoxText.TextYAlignment = Enum.TextYAlignment.Center
	BoxText.TextWrapped = true
	BoxText.TextSize = size
	BoxText.ClearTextOnFocus = false
	RegisterTextLabel(BoxText)
	BoxText.Focused:Connect(function()
		UISound.Click:Play()
	end)
	Stylize(Box, {
		Depthed = true,
	})
	local function update()
		local x = parent.AbsoluteSize.X
		if not BoxText.TextWrapped then
			x = math.huge
		end
		local t = BoxText.Text
		if t:len() == 0 then
			t = BoxText.PlaceholderText
		end
		local size = TextService:GetTextSize(t, BoxText.TextSize, BoxText.Font, Vector2.new(x - margin * 2, math.huge))
		Container.Size = UDim2.new(1, 0, 0, size.Y + margin * 2 + 2)
	end
	BoxText.Text = text
	BoxText.PlaceholderText = placeholder
	update()
	BoxText.Changed:Connect(update)
	return BoxText
end
function UI.CreateSlider(parent, text, value, min, max, step)
	min = min or 1
	max = max or 10
	step = math.abs(step or 0)
	assert(max > min)
	local margin = 5
	local Container = Util.Instance("Frame", parent)
	Container.AnchorPoint = Vector2.new(0.5, 0)
	Container.Size = UDim2.new(1, 0, 0, 65)
	Container.BackgroundTransparency = 1
	Container.LayoutOrder = #parent:GetChildren()
	local Text = Util.Instance("TextLabel", Container)
	Text.AnchorPoint = Vector2.new(0, 0)
	Text.Position = UDim2.new(0, margin, 0, 0)
	Text.Size = UDim2.new(1, margin * -2, 0, 35)
	Text.BackgroundTransparency = 1
	Text.RichText = true
	Text.Font = Enum.Font.Code
	Text.TextColor3 = Color3.new(1, 1, 1)
	Text.TextTransparency = 0
	Text.TextXAlignment = Enum.TextXAlignment.Left
	Text.TextYAlignment = Enum.TextYAlignment.Center
	Text.TextWrapped = true
	Text.TextSize = 20
	Text.Text = text
	RegisterTextLabel(Text)
	local Box = Util.Instance("Frame", Container)
	Box.AnchorPoint = Vector2.new(1, 0)
	Box.Position = UDim2.new(1, -margin, 0, margin)
	Box.Size = UDim2.new(0, 80, 0, 35 - margin * 2)
	Box.BackgroundTransparency = 0
	Box.BackgroundColor3 = Color3.new(1, 1, 1)
	Box.BorderSizePixel = 0
	local BoxText = Util.Instance("TextBox", Box)
	BoxText.AnchorPoint = Vector2.new(0, 0.5)
	BoxText.Position = UDim2.new(0, 0, 0.5, 0)
	BoxText.Size = UDim2.new(1, 0, 1, -margin)
	BoxText.BackgroundTransparency = 1
	BoxText.Font = Enum.Font.Code
	BoxText.TextColor3 = Color3.new(1, 1, 1)
	BoxText.PlaceholderColor3 = Color3.new(0.7, 0.7, 0.7)
	BoxText.TextTransparency = 0
	BoxText.TextXAlignment = Enum.TextXAlignment.Center
	BoxText.TextYAlignment = Enum.TextYAlignment.Center
	BoxText.TextWrapped = true
	BoxText.TextSize = 15
	BoxText.ClearTextOnFocus = false
	RegisterTextLabel(BoxText)
	BoxText.Focused:Connect(function()
		UISound.Click:Play()
	end)
	Stylize(Box, {
		Depthed = true,
	})
	local SliderC = Util.Instance("TextButton", Container)
	SliderC.AnchorPoint = Vector2.new(0, 0)
	SliderC.Position = UDim2.new(0, 0, 0, 40)
	SliderC.Size = UDim2.new(1, 0, 0, 20)
	SliderC.BackgroundTransparency = 1
	SliderC.Text = ""
	SliderC.AutoButtonColor = true
	local SliderR = Util.Instance("Frame", SliderC)
	SliderR.AnchorPoint = Vector2.new(0.5, 0.5)
	SliderR.Position = UDim2.new(0.5, 0, 0.5, 0)
	SliderR.Size = UDim2.new(1, margin * -2 - 18, 0, 5)
	SliderR.BackgroundTransparency = 0
	SliderR.BackgroundColor3 = Color3.new(1, 1, 1)
	SliderR.BorderSizePixel = 0
	local SliderB = Util.Instance("Frame", SliderR)
	SliderB.AnchorPoint = Vector2.new(0.5, 0.5)
	SliderB.Position = UDim2.new(0, 0, 0.5, 0)
	SliderB.Size = UDim2.new(0, 18, 0, 18)
	SliderB.BackgroundTransparency = 0
	SliderB.BackgroundColor3 = Color3.new(1, 1, 1)
	SliderB.BorderSizePixel = 0
	SliderB.ZIndex = 2
	Stylize(SliderR, {
		Depthed = true,
	})
	Stylize(SliderB)
	local range = max - min
	if step > 0 then
		if range / step < 20 then
			local i = min + step
			while i < max do
				local snaps = Util.Instance("Frame", SliderR)
				snaps.AnchorPoint = Vector2.new(0.5, 0)
				snaps.Position = UDim2.new((i - min) / range, 0, 0, 1)
				snaps.Size = UDim2.new(0, 1, 0, 3)
				snaps.BackgroundTransparency = 0.5
				snaps.BackgroundColor3 = Color3.new(1, 1, 1)
				snaps.BorderSizePixel = 0
				i += step
			end
		end
	end
	local Select = Util.Instance("NumberValue")
	local function update()
		local str = string.format("%.3f", Select.Value)
		if str:find("%.") then
			while str:sub(-1) == "0" do
				str = str:sub(1, -2)
				if str:sub(-1) == "." then
					str = str:sub(1, -2)
					break
				end
			end
		end
		BoxText.Text = str
		SliderB.Position = UDim2.new(math.clamp((Select.Value - min) / (max - min), 0, 1), 0, 0.5, 0)
	end
	Select.Value = value
	Select.Changed:Connect(update)
	update()
	BoxText.FocusLost:Connect(function()
		Select.Value = tonumber(BoxText.Text) or Select.Value
		update()
	end)
	local function ondrag(x)
		local val = range * math.clamp((x - SliderR.AbsolutePosition.X) / SliderR.AbsoluteSize.X, 0, 1)
		if step > 0 then
			val = math.round(val / step) * step
		end
		val += min
		Select.Value = val
	end
	local dragref = nil
	local start = nil
	SliderC.InputBegan:Connect(function(input)
		if input.UserInputState ~= Enum.UserInputState.Begin then return end
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragref = input
			start = input.Position
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if dragref then
			if input.UserInputType == Enum.UserInputType.MouseMovement or (input.UserInputType == Enum.UserInputType.Touch and dragref == input) then
				if start then
					local delta = input.Position - start
					if delta.Magnitude > 10 then
						start = nil
						if math.abs(delta.X) < math.abs(delta.Y) then
							dragref = nil
						end
					end
				else
					ondrag(input.Position.X)
				end
			end
		end
	end)
	UserInputService.InputEnded:Connect(function(input)
		if dragref and dragref == input then
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				ondrag(input.Position.X)
				dragref = nil
			end
		end
	end)
	return Select
end
function UI.CreateDropdown(parent, text, array, value)
	value = value and math.clamp(value, 1, #array) or 1
	local margin = 5
	local Container = Util.Instance("Frame", parent)
	Container.AnchorPoint = Vector2.new(0.5, 0)
	Container.Size = UDim2.new(1, 0, 0, 10)
	Container.BackgroundTransparency = 1
	Container.LayoutOrder = #parent:GetChildren()
	local Text = Util.Instance("TextLabel", Container)
	Text.AnchorPoint = Vector2.new(0, 0)
	Text.Position = UDim2.new(0, margin, 0, 0)
	Text.Size = UDim2.new(1, margin * -2, 1, 0)
	Text.BackgroundTransparency = 1
	Text.RichText = true
	Text.Font = Enum.Font.Code
	Text.TextColor3 = Color3.new(1, 1, 1)
	Text.TextTransparency = 0
	Text.TextXAlignment = Enum.TextXAlignment.Left
	Text.TextYAlignment = Enum.TextYAlignment.Center
	Text.TextWrapped = true
	Text.TextSize = 20
	RegisterTextLabel(Text)
	local Dropdown = Util.Instance("TextButton", Container)
	Dropdown.AnchorPoint = Vector2.new(1, 0.5)
	Dropdown.Position = UDim2.new(1, -margin, 0.5, 0)
	Dropdown.Size = UDim2.new(0.5, 0, 1, -margin)
	Dropdown.BackgroundTransparency = 0
	Dropdown.BackgroundColor3 = Color3.new(1, 1, 1)
	Dropdown.BorderSizePixel = 0
	Dropdown.Text = ""
	Dropdown.AutoButtonColor = true
	local DropdownText = Util.Instance("TextLabel", Dropdown)
	DropdownText.AnchorPoint = Vector2.new(0.5, 0.5)
	DropdownText.Position = UDim2.new(0.5, 0, 0.5, 0)
	DropdownText.Size = UDim2.new(1, -margin * 2, 1, -margin)
	DropdownText.BackgroundTransparency = 1
	DropdownText.RichText = true
	DropdownText.Font = Enum.Font.Code
	DropdownText.TextColor3 = Color3.new(1, 1, 1)
	DropdownText.TextTransparency = 0
	DropdownText.TextXAlignment = Enum.TextXAlignment.Center
	DropdownText.TextYAlignment = Enum.TextYAlignment.Center
	DropdownText.TextWrapped = true
	DropdownText.TextSize = 15
	RegisterTextLabel(DropdownText)
	Stylize(Dropdown)
	local function update()
		local x = parent.AbsoluteSize.X
		local size1 = TextService:GetTextSize(Text.ContentText, Text.TextSize, Text.Font, Vector2.new(x - margin * 2, math.huge))
		local size2 = TextService:GetTextSize(DropdownText.ContentText, DropdownText.TextSize, DropdownText.Font, Vector2.new(x * 0.8 - margin * 2, math.huge))
		Container.Size = UDim2.new(1, 0, 0, math.max(35, size1.Y, size2.Y + margin * 2))
		Dropdown.Size = UDim2.new(0, math.max(60, size2.X + margin * 2 + 2), 0, math.max(25, size2.Y + margin * 2))
	end
	Text.Text = text
	DropdownText.Text = array[value]
	update()
	Text.Changed:Connect(update)
	DropdownText.Changed:Connect(update)
	local Select = Util.Instance("IntValue")
	Select.Value = value
	Select.Changed:Connect(function()
		DropdownText.Text = array[Select.Value]
	end)
	local Droplist = Util.Instance("ScrollingFrame", UIMainFrame)
	Droplist.AnchorPoint = Vector2.new(0, 0)
	Droplist.Position = UDim2.new(0, 0, 0, 0)
	Droplist.Size = UDim2.new(0, 0, 0, 0)
	Droplist.BackgroundTransparency = 0
	Droplist.BackgroundColor3 = Color3.new(1, 1, 1)
	Droplist.BorderSizePixel = 0
	Droplist.Visible = false
	Droplist.CanvasSize = UDim2.new(0, 0, 0, 0)
	Droplist.AutomaticCanvasSize = Enum.AutomaticSize.Y
	Droplist.ScrollBarThickness = 0
	Droplist.ScrollingDirection = Enum.ScrollingDirection.Y
	local Padding = Util.Instance("UIPadding", Droplist)
	Padding.PaddingLeft = UDim.new(0, 5)
	Padding.PaddingRight = UDim.new(0, 5)
	Padding.PaddingTop = UDim.new(0, 0)
	Padding.PaddingBottom = UDim.new(0, 0)
	local UIList = Util.Instance("UIListLayout", Droplist)
	UIList.FillDirection = Enum.FillDirection.Vertical
	UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center
	UIList.VerticalAlignment = Enum.VerticalAlignment.Top
	UIList.Padding = UDim.new(0, 0)
	UIList.SortOrder = Enum.SortOrder.LayoutOrder
	Stylize(Droplist, {
		Glow = true
	})
	local items = {}
	local sizex = 60
	local interact = false
	local opened = false
	Util.LinkDestroyI2I(Dropdown, Droplist)
	for i,itemname in array do
		local Item = Util.Instance("TextButton", Droplist)
		Item.Size = UDim2.new(1, 0, 0, 20)
		Item.BackgroundTransparency = 0
		Item.BackgroundColor3 = Color3.new(0, 0, 0)
		Item.BorderSizePixel = 0
		Item.AutoButtonColor = true
		Item.LayoutOrder = i
		Item.Text = itemname
		Item.TextSize = 15
		Item.Font = Enum.Font.Code
		Item.TextColor3 = Color3.new(1, 1, 1)
		Item.TextXAlignment = Enum.TextXAlignment.Left
		Item.TextYAlignment = Enum.TextYAlignment.Center
		Item.TextWrapped = false
		RegisterTextLabel(Item)
		table.insert(items, Item)
		local size = TextService:GetTextSize(itemname, Item.TextSize, Item.Font, Vector2.new(math.huge, math.huge))
		sizex = math.max(sizex, size.X + 12)
		Item.Activated:Connect(function()
			Select.Value = i
			opened = false
			interact = true
		end)
		Item.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				interact = true
				UISound.Click:Play()
			end
		end)
	end
	Dropdown.Activated:Connect(function()
		opened = not opened
		interact = true
	end)
	local conn = UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			task.wait()
			if not interact then
				opened = false
			end
			interact = false
		end
	end)
	Util.LinkDestroyI2C(Dropdown, conn)
	local scrollframe = Container:FindFirstAncestorWhichIsA("ScrollingFrame")
	if scrollframe then
		local conn = scrollframe:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
			opened = false
		end)
	end
	local opentween = 0
	AddToRenderStep(function(t, dt)
		if opened then
			opentween = 1 + (opentween - 1) * math.exp(-32 * dt)
			Droplist.ZIndex = 4
			Droplist.Interactable = true
		else
			opentween *= math.exp(-32 * dt)
			Droplist.ZIndex = 3
			Droplist.Interactable = false
		end
		local ysize = math.round(math.min(90, #items * 20) * opentween)
		if ysize >= 1 then
			Droplist.Position = Util.Vector2ToUDim2Offset((Dropdown.AbsolutePosition + Vector2.new(0, Dropdown.AbsoluteSize.Y)) - UIMainFrame.AbsolutePosition)
			Droplist.Size = UDim2.new(0, math.max(Dropdown.Size.X.Offset, sizex), 0, ysize)
			Droplist.Visible = true
		else
			Droplist.Visible = false
		end
		local i1 = GetUIBGColor(t)
		local i2 = i1:Lerp(Color3.new(1, 1, 1), 0.1)
		for i,v in items do
			if i == Select.Value then
				v.BackgroundColor3 = i2
			else
				v.BackgroundColor3 = i1
			end
		end
	end, Droplist)
	Util.LinkDestroyI2I(Dropdown, Select)
	return Select, Text
end
function UI.CreateCanvas(parent)
	local margin = 5
	local Container = Util.Instance("Frame", parent)
	Container.AnchorPoint = Vector2.new(0.5, 0)
	Container.Size = UDim2.new(1, 0, 0, 30)
	Container.BackgroundTransparency = 1
	Container.LayoutOrder = #parent:GetChildren()
	Container.AutomaticSize = Enum.AutomaticSize.Y
	local Padding = Util.Instance("UIPadding", Container)
	Padding.PaddingTop = UDim.new(0, 2)
	Padding.PaddingBottom = UDim.new(0, 2)
	Padding.PaddingLeft = UDim.new(0, 5)
	Padding.PaddingRight = UDim.new(0, 5)
	local ListBox = Util.Instance("Frame", Container)
	ListBox.AnchorPoint = Vector2.new(0, 0)
	ListBox.Position = UDim2.new(0, 0, 0, 0)
	ListBox.Size = UDim2.new(1, 0, 0, 26)
	ListBox.BackgroundTransparency = 0
	ListBox.BackgroundColor3 = Color3.new(0.7, 0.7, 0.7)
	ListBox.BorderSizePixel = 0
	ListBox.AutomaticSize = Enum.AutomaticSize.Y
	Stylize(ListBox, {
		Depthed = true,
	})
	Padding = Util.Instance("UIPadding", ListBox)
	Padding.PaddingTop = UDim.new(0, 5)
	Padding.PaddingBottom = UDim.new(0, 5)
	Padding.PaddingLeft = UDim.new(0, 0)
	Padding.PaddingRight = UDim.new(0, 0)
	local UIList = Util.Instance("UIListLayout", ListBox)
	UIList.FillDirection = Enum.FillDirection.Vertical
	UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center
	UIList.VerticalAlignment = Enum.VerticalAlignment.Top
	UIList.Padding = UDim.new(0, 0)
	UIList.SortOrder = Enum.SortOrder.LayoutOrder
	Util.LinkDestroyI2I(ListBox, Container)
	return ListBox
end
function UI.CreateScrollCanvas(parent, height)
	local margin = 5
	local Container = Util.Instance("Frame", parent)
	Container.AnchorPoint = Vector2.new(0.5, 0)
	Container.Size = UDim2.new(1, 0, 0, height)
	Container.BackgroundTransparency = 1
	Container.LayoutOrder = #parent:GetChildren()
	local Padding = Util.Instance("UIPadding", Container)
	Padding.PaddingTop = UDim.new(0, 2)
	Padding.PaddingBottom = UDim.new(0, 2)
	Padding.PaddingLeft = UDim.new(0, 5)
	Padding.PaddingRight = UDim.new(0, 5)
	local ListBox = Util.Instance("ScrollingFrame", Container)
	ListBox.AnchorPoint = Vector2.new(0, 0)
	ListBox.Position = UDim2.new(0, 0, 0, 0)
	ListBox.Size = UDim2.new(1, 0, 0, 26)
	ListBox.BackgroundTransparency = 0
	ListBox.BackgroundColor3 = Color3.new(0.7, 0.7, 0.7)
	ListBox.BorderSizePixel = 0
	ListBox.AutomaticCanvasSize = Enum.AutomaticSize.Y
	ListBox.CanvasSize = UDim2.new(0, 0, 0, 0)
	ListBox.ScrollingDirection = Enum.ScrollingDirection.Y
	ListBox.ScrollBarThickness = 0
	ListBox.ClipsDescendants = true
	Stylize(ListBox, {
		Depthed = true,
	})
	Padding = Util.Instance("UIPadding", ListBox)
	Padding.PaddingTop = UDim.new(0, 5)
	Padding.PaddingBottom = UDim.new(0, 5)
	Padding.PaddingLeft = UDim.new(0, 0)
	Padding.PaddingRight = UDim.new(0, 0)
	local UIList = Util.Instance("UIListLayout", ListBox)
	UIList.FillDirection = Enum.FillDirection.Vertical
	UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center
	UIList.VerticalAlignment = Enum.VerticalAlignment.Top
	UIList.Padding = UDim.new(0, 0)
	UIList.SortOrder = Enum.SortOrder.LayoutOrder
	Util.LinkDestroyI2I(ListBox, Container)
	return ListBox
end
function UI.CreateItemListPage()
	local margin = 5
	local Frame = Util.Instance("Frame", WindowContent)
	Frame.AnchorPoint = Vector2.new(0.5, 0.5)
	Frame.Position = UDim2.new(0.5, 0, 0.5, 0)
	Frame.Size = UDim2.new(0, 360, 0, 205)
	Frame.BackgroundTransparency = 0
	Frame.BackgroundColor3 = Color3.new(0, 0, 0)
	Frame.BorderSizePixel = 1
	Frame.BorderColor3 = Color3.new(1, 1, 1)
	Frame.Visible = true
	Frame.ZIndex = 0
	Frame.ClipsDescendants = true
	AddToRenderStep(function(t)
		Frame.BorderColor3 = GetUIColor(t)
		Frame.BackgroundColor3 = GetUIBGColor(t)
	end, Frame)
	local Padding = Util.Instance("UIPadding", Frame)
	Padding.PaddingTop = UDim.new(0, margin)
	Padding.PaddingBottom = UDim.new(0, margin)
	Padding.PaddingLeft = UDim.new(0, margin)
	Padding.PaddingRight = UDim.new(0, margin)
	local BackButton = Util.Instance("TextButton", Frame)
	BackButton.AnchorPoint = Vector2.new(0, 0)
	BackButton.Position = UDim2.new(0, 0, 0, 0)
	BackButton.Size = UDim2.new(0, 30, 0, 25)
	BackButton.BackgroundTransparency = 0
	BackButton.BackgroundColor3 = Color3.new(1, 1, 1)
	BackButton.BorderSizePixel = 0
	BackButton.Text = ""
	BackButton.AutoButtonColor = true
	local BackButtonText = Util.Instance("TextLabel", BackButton)
	BackButtonText.AnchorPoint = Vector2.new(0.5, 0.5)
	BackButtonText.Position = UDim2.new(0.5, 0, 0.5, 0)
	BackButtonText.Size = UDim2.new(1, margin * -2, 1, -margin)
	BackButtonText.BackgroundTransparency = 1
	BackButtonText.Font = Enum.Font.Code
	BackButtonText.TextColor3 = Color3.new(1, 1, 1)
	BackButtonText.TextTransparency = 0
	BackButtonText.TextXAlignment = Enum.TextXAlignment.Center
	BackButtonText.TextYAlignment = Enum.TextYAlignment.Center
	BackButtonText.TextWrapped = true
	BackButtonText.TextSize = 20
	BackButtonText.Text = "<"
	RegisterTextLabel(BackButtonText)
	Stylize(BackButton)
	local SearchBox = Util.Instance("Frame", Frame)
	SearchBox.AnchorPoint = Vector2.new(1, 0)
	SearchBox.Position = UDim2.new(1, 0, 0, 0)
	SearchBox.Size = UDim2.new(1, -margin - 30, 0, 25)
	SearchBox.BackgroundTransparency = 0
	SearchBox.BackgroundColor3 = Color3.new(0.9, 0.9, 0.9)
	SearchBox.BorderSizePixel = 0
	local SearchBoxText = Util.Instance("TextBox", SearchBox)
	SearchBoxText.AnchorPoint = Vector2.new(0.5, 0.5)
	SearchBoxText.Position = UDim2.new(0.5, 0, 0.5, 0)
	SearchBoxText.Size = UDim2.new(1, margin * -2, 1, -margin)
	SearchBoxText.BackgroundTransparency = 1
	SearchBoxText.Font = Enum.Font.Code
	SearchBoxText.TextColor3 = Color3.new(1, 1, 1)
	SearchBoxText.PlaceholderColor3 = Color3.new(0.7, 0.7, 0.7)
	SearchBoxText.TextTransparency = 0
	SearchBoxText.TextXAlignment = Enum.TextXAlignment.Left
	SearchBoxText.TextYAlignment = Enum.TextYAlignment.Center
	SearchBoxText.TextWrapped = true
	SearchBoxText.TextSize = 20
	SearchBoxText.ClearTextOnFocus = false
	SearchBoxText.Focused:Connect(function()
		UISound.Click:Play()
	end)
	Stylize(SearchBox, {
		Depthed = true,
	})
	SearchBoxText.Text = ""
	SearchBoxText.PlaceholderText = "Seek..."
	RegisterTextLabel(SearchBoxText)
	local ListBox = Util.Instance("ScrollingFrame", Frame)
	ListBox.AnchorPoint = Vector2.new(0, 0)
	ListBox.Position = UDim2.new(0, 0, 0, 25 + margin)
	ListBox.Size = UDim2.new(1, 0, 1, -margin - 25)
	ListBox.BackgroundTransparency = 0
	ListBox.BackgroundColor3 = Color3.new(0.7, 0.7, 0.7)
	ListBox.BorderSizePixel = 0
	ListBox.AutomaticCanvasSize = Enum.AutomaticSize.Y
	ListBox.CanvasSize = UDim2.new(0, 0, 0, 0)
	ListBox.ScrollingDirection = Enum.ScrollingDirection.Y
	ListBox.ScrollBarThickness = 0
	ListBox.ClipsDescendants = true
	Stylize(ListBox, {
		Depthed = true,
	})
	Padding = Util.Instance("UIPadding", ListBox)
	Padding.PaddingTop = UDim.new(0, 5)
	Padding.PaddingBottom = UDim.new(0, 5)
	Padding.PaddingLeft = UDim.new(0, 0)
	Padding.PaddingRight = UDim.new(0, 0)
	local UIList = Util.Instance("UIListLayout", ListBox)
	UIList.FillDirection = Enum.FillDirection.Vertical
	UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center
	UIList.VerticalAlignment = Enum.VerticalAlignment.Top
	UIList.Padding = UDim.new(0, 0)
	UIList.SortOrder = Enum.SortOrder.LayoutOrder
	BackButton.Name = "Back"
	BackButtonText.Name = "Label"
	SearchBox.Name = "Search"
	SearchBoxText.Name = "Box"
	ListBox.Name = "List"
	SearchBoxText:GetPropertyChangedSignal("Text"):Connect(function()
		for _,v in ListBox:GetChildren() do
			if v:IsA("GuiObject") then
				v.Visible = not not v.Name:lower():find(SearchBoxText.Text:lower())
			end
		end
	end)
	return Frame
end
function UI.CreateItemListItem(parent)
	local margin = 5
	local Container = Util.Instance("Frame", parent)
	Container.AnchorPoint = Vector2.new(0.5, 0)
	Container.Size = UDim2.new(1, 0, 0, 30)
	Container.BackgroundTransparency = 1
	Container.LayoutOrder = #parent:GetChildren()
	Container.AutomaticSize = Enum.AutomaticSize.Y
	local Padding = Util.Instance("UIPadding", Container)
	Padding.PaddingTop = UDim.new(0, 2)
	Padding.PaddingBottom = UDim.new(0, 2)
	Padding.PaddingLeft = UDim.new(0, 5)
	Padding.PaddingRight = UDim.new(0, 5)
	local ListBox = Util.Instance("TextButton", Container)
	ListBox.AnchorPoint = Vector2.new(0, 0)
	ListBox.Position = UDim2.new(0, 0, 0, 0)
	ListBox.Size = UDim2.new(1, 0, 0, 26)
	ListBox.BackgroundTransparency = 0
	ListBox.BackgroundColor3 = Color3.new(0.7, 0.7, 0.7)
	ListBox.BorderSizePixel = 0
	ListBox.AutomaticSize = Enum.AutomaticSize.Y
	ListBox.Text = ""
	Stylize(ListBox)
	Padding = Util.Instance("UIPadding", ListBox)
	Padding.PaddingTop = UDim.new(0, 5)
	Padding.PaddingBottom = UDim.new(0, 5)
	Padding.PaddingLeft = UDim.new(0, 0)
	Padding.PaddingRight = UDim.new(0, 0)
	local UIList = Util.Instance("UIListLayout", ListBox)
	UIList.FillDirection = Enum.FillDirection.Vertical
	UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center
	UIList.VerticalAlignment = Enum.VerticalAlignment.Top
	UIList.Padding = UDim.new(0, 0)
	UIList.SortOrder = Enum.SortOrder.LayoutOrder
	Util.LinkDestroyI2I(ListBox, Container)
	return ListBox
end

local MainPage = UI.CreatePage()
MainPage.Interactable = false
CracktroFrame.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		if _totalrendertime < 1 or not IsUhhhhhhFullyLoaded then return end
		CracktroFrame.Interactable = false
		CracktroFrame.Visible = true
		MainPage.Interactable = false
		local tween = TweenService:Create(CracktroFrame, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
			Position = UDim2.new(0.5, -362, 0.5, 0),
		})
		tween:Play()
		tween.Completed:Connect(function()
			CracktroFrame.Visible = false
			MainPage.Interactable = true
		end)
	end
end)
local AsciiText = UI.CreateText(MainPage, "", 12, Enum.TextXAlignment.Center)
task.spawn(function()
	local AsciiTextarts = {
		{
			"  ____ ___.__    .__    .__    .__    .__    .__      ",
			" |    |   \\  |__ |  |__ |  |__ |  |__ |  |__ |  |__   ",
			" |    |   /  |  \\|  |  \\|  |  \\|  |  \\|  |  \\|  |  \\  ",
			" |    |  /|   Y  \\   Y  \\   Y  \\   Y  \\   Y  \\   Y  \\ ",
			" |______/ |___|  /___|  /___|  /___|  /___|  /___|  / ",
			"               \\/     \\/     \\/     \\/     \\/     \\/  ",
		},
		{
			"  _   _ _     _     _     _     _     _      ",
			" | | | | |   | |   | |   | |   | |   | |     ",
			" | | | | |__ | |__ | |__ | |__ | |__ | |__   ",
			" | | | | '_ \\| '_ \\| '_ \\| '_ \\| '_ \\| '_ \\  ",
			" | |_| | | | | | | | | | | | | | | | | | | | ",
			"  \\___/|_| |_|_| |_|_| |_|_| |_|_| |_|_| |_| ",
		},
		{
			"     (   ( /(  ( /(  ( /(  ( /(  ( /(  ( /(  ",
			"     )\\  )\\()) )\\()) )\\()) )\\()) )\\()) )\\()) ",
			"  _ ((_)((_)\\ ((_)\\ ((_)\\ ((_)\\ ((_)\\ ((_)\\  ",
			" | | | || |(_)| |(_)| |(_)| |(_)| |(_)| |(_) ",
			" | |_| || ' \\ | ' \\ | ' \\ | ' \\ | ' \\ | ' \\  ",
			"  \\___/ |_||_||_||_||_||_||_||_||_||_||_||_| ",
		},
		{
			" db    db db      db      db      db      db      db      ",
			" 88    88 88      88      88      88      88      88      ",
			" 88    88 888888. 888888. 888888. 888888. 888888. 888888. ",
			" 88    88 88   88 88   88 88   88 88   88 88   88 88   88 ",
			" 88.  .88 88   88 88   88 88   88 88   88 88   88 88   88 ",
			"  Y8888P  YP   YP YP   YP YP   YP YP   YP YP   YP YP   YP ",
		},
		{
			" Un    iv er      sa      lH      ie      ra      rc      ",
			" hi    ca l6      Re      an      im      at      eB      ",
			" yS    TE VETHERE ALONEUn iversal Hierarc hical6R eanimat ",
			" eB    yS TE   VE TH   ER EA   LO NE   Un iv   er sa   lH ",
			" ier  arc ic   al 6R   ea ni   ma te   By ST   EV ET   HE ",
			"  REALON  EU   ni ve   rs al   Hi er   ar ch   ic al   6R ",
		},
		{
			"animatio'   .jQQQ|;;;;;;;;;;;;;|QQWp,   'tionanim",
			"ationan'   .JTTVV|;;;;;;;;;;;;;|VVVVm>   'nimatio",
			"nanima'   _mQc;~~|.............|~~+jQmc   'ionani",
			"matio'   _QQQQg, |             |  jQQQQc.  'imati",
			"onan'   <QQQQQQm;|   Uhhhhhh   |.wQQQQWQa,  'onan",
			"ima'   jWQQQQQQQQ|             |mQQQQQQQQg,  'mat",
		},
		{
			"fore! It is really great! Good product! Feel alive, NO",
			"st part^ '' '  \"\"*E! (excluding taxes and the bills) N",
			"r seu- . Uhhhhhh .-|u ihis! It has become something ne",
			"rse! We ,... . ,.-rs of yellow-orange shiny triangles.",
			"ns at a really stable framerate, so optimised it handl",
			"ow, BUY OUR PRODUCT FOR FREE! We know you like it! We ",
		},
		{
			"....... gmWWWQQQQQQPg ..............................",
			":;:;:; qm#WWNWQQWQWWmp ;:;:;:.                  .;:;",
			"!!?!!?.WX##: W#W :###W.?!!?:.  hi im steve!      .:!",
			"lilili:ZSXS: XSX :X##Z:ilil!. welcome to Uhhhhhh .!i",
			"EEEEEE:YLkk2S2SXSXSXZP:EEEEEi:                  :iEE",
			"%%%%%%%;vnvkkkk2S2vnv;%%%%%%%%%oooooooooooooooo%%%%%",
		},
		{
			"  Get Uhhhhhh today! Feel the difference!       ",
			"           (-_-)         EPIC!    (^~^)   .vv=E ",
			"       ()-(:::::)-()         .()-(:::::)-()'    ",
			"LAME!  || |.....| ||      3=^^'  /...../        ",
			"       YP |     | YP            (     )   COOL! ",
			"      Without Uhhhhhh   vs.   With Uhhhhhh      ",
		},
		{
			"55 68 68 68 68 68 68 55 68 68 68 68 68 68",
			"68 68 68 68 68 68 55 68 68 68 68 68 68 55",
			"68 68 68 68 68 55 68 68 68 68 68 68 55 68",
			"68 68 68 68 Uhhhhhh  68 68 68 68 55 68 68",
			"68 68 68 55 68 68 68 68 68 68 55 68 68 68",
			"68 68 55 68 68 68 68 68 68 55 68 68 68 68",
		},
		{
			"  Uhhhhhh          ",
			"  01010101         ",
			"   01101000        ",
			"    01101000       ",
			"     01101000      ",
			"      01101000     ",
			"       01101000    ",
			"        01101000   ",
			"         Uhhhhhh   ",
		},
		{
			"+-[ Uhhhhhh Reanimate ]-----------------[#]-+",
			"|    ___                                    |",
			"|   / o \\   Hello, world! Programmed to     |",
			"|   \\ l /   work and not to feel.           |",
			"|    \"\"\"                                    |",
			"+-------------------------------------------+",
		},
		{
			"       cIyyyyyyF0\\ `TFyyyyyyq8_                 ",
			"           i+`}0v       V!'xD~                  ",
			"           &x~[.        W|11   --Uhhhhhh--      ",
			"          ~W,          }D                       ",
			"        <d$-         tg3`                       ",
			"   \".''   ......             '.      \"`   ;     ",
			"   2]~<J  ;!ci2q' rrrr^   <1_q'   -inr   `0;    ",
			"   F` '2    F<;            [&I- _+r%)    `@<}!  ",
			"    ~1}`  `}\\    ;*111*; ^[; .^    +\\    `x     ",
		},
		{
			"  local oldsec = 0          .-+=* Uhhhhhh *=+-. ",
			"  while i < #keyframes do     (code-ception!)   ",
			"      local k = keyframes[i]                    ",
			"      local sec = k.Time // self._optimiser     ",
			"      while oldsec < sec do                     ",
			"          local j = math.max(1, i - 1)          ",
		},
		{
			"er failed to process http://assetgame.roblox.com/as",
			"er failed to process http://assetgame.roblox.com/as",
			"--------------------------------------------       ",
			"so, Uhhhhhh...                                     ",
			"--------------------------------------------       ",
			"er failed to process http://assetgame.roblox.com/as",
			"er failed to process http://assetgame.roblox.com/as",
			"er failed to process http://assetgame.roblox.com/as",
		},
		{
			"usage: clone this repo and change the token and the",
			"(unless you like chaos) also make sure you have all",
			"the dev portal cuz Uhhhhhh.                        ",
			"                                                   ",
			"\"it's not fast it's shit\"                          ",
			"Believe me friend, its fuckingly fast, you don't ev",
		},
		{
			"Uhhhhhh  https://discord.gg/NASNUKRBVM  Uhhhhhh",
			"Uhhhhhh Uhhhhhh Uhhhhhh Uhhhhhh STEVETHEREALONE",
			"Uhhhhhh Uhhhhhh Uhhhhhh STEVETHEREALONE Uhhhhhh",
			"Uhhhhhh Uhhhhhh STEVETHEREALONE Uhhhhhh Uhhhhhh",
			"Uhhhhhh STEVETHEREALONE Uhhhhhh Uhhhhhh Uhhhhhh",
			"STEVETHEREALONE Uhhhhhh Uhhhhhh Uhhhhhh Uhhhhhh",
		},
	}
	AsciiText.Text = table.concat(AsciiTextarts[math.random(1, #AsciiTextarts)], "\n")
	local AsciiTextartsw = false
	local AsciiTextarttr = {}
	do -- generate transitions
		-- wipe to right
		local a = {}
		for i=0, 59 do
			local t = i / 60
			t *= 5
			t = (t - 1) / 3
			t *= 5
			local map = {}
			for y=0, 64 do
				local layer = {}
				for x=0, 64 do
					local prog = x / 64
					prog *= 5
					table.insert(layer, math.round(math.clamp(t - prog + math.random() * 0.2, 0, 1) * 3))
				end
				table.insert(map, layer)
			end
			table.insert(a, map)
			task.wait()
		end
		table.insert(AsciiTextarttr, a)
		table.insert(AsciiTextarttr, a)
		table.insert(AsciiTextarttr, a)
		table.insert(AsciiTextarttr, a)
		-- noisy fade
		a = {}
		for i=0, 59 do
			local t = i / 60
			local map = {}
			for y=0, 64 do
				local layer = {}
				for x=0, 64 do
					table.insert(layer, math.round(math.clamp(t * 2 - 1 + math.random() * 0.8, 0, 1) * 3))
				end
				table.insert(map, layer)
			end
			table.insert(a, map)
			task.wait()
		end
		table.insert(AsciiTextarttr, a)
		-- circle outward
		a = {}
		for i=0, 59 do
			local t = i / 60
			t *= 5
			local map = {}
			for y=0, 64 do
				local layer = {}
				for x=0, 64 do
					local dist = math.sqrt(math.pow(x - 32, 2) + math.pow(y - 32, 2)) / 64
					dist *= 5
					table.insert(layer, math.round(math.clamp(t - dist + math.random() * 0.2, 0, 1) * 3))
				end
				table.insert(map, layer)
			end
			table.insert(a, map)
			task.wait()
		end
		table.insert(AsciiTextarttr, a)
		-- circle inward
		a = {}
		for i=0, 59 do
			local t = 1 - i / 60
			t *= 5
			t -= 1
			local map = {}
			for y=0, 64 do
				local layer = {}
				for x=0, 64 do
					local dist = math.sqrt(math.pow(x - 32, 2) + math.pow(y - 32, 2)) / 64
					dist *= 5
					table.insert(layer, math.round(math.clamp(dist - t + math.random() * 0.2, 0, 1) * 3))
				end
				table.insert(map, layer)
			end
			table.insert(a, map)
			task.wait()
		end
		table.insert(AsciiTextarttr, a)
	end
	local function switchart()
		if AsciiTextartsw then return end
		AsciiTextartsw = true
		local function animation(art, inv)
			local transmap = AsciiTextarttr[math.random(1, #AsciiTextarttr)]
			local rot = math.random(0, 3)
			local st = os.clock()
			repeat
				local t = os.clock() - st
				local i = math.clamp(math.floor(t * 60) + 1, 1, 60)
				local render = {}
				for iy=1, #art do
					local y = (iy - 1) / #art
					local conc = ""
					local txt = art[iy]
					for ix=1, #txt do
						local x = (ix - 1) / #txt
						local ch = string.sub(txt, ix, ix)
						local b = 0
						if rot == 0 then
							b = transmap[i][math.floor(y * 64) + 1][math.floor(x * 64) + 1]
						elseif rot == 1 then
							b = transmap[i][math.floor(x * 64) + 1][64 - math.floor(y * 64)]
						elseif rot == 2 then
							b = transmap[i][64 - math.floor(y * 64)][64 - math.floor(x * 64)]
						elseif rot == 3 then
							b = transmap[i][64 - math.floor(x * 64)][math.floor(y * 64) + 1]
						end
						if inv then b = 3 - b end
						if b == 1 then
							if (ch == ch:upper() and ch ~= ch:lower()) or ch == "8" or ch == "0" then
								ch = "?"
							elseif ch == ":" or ch == ";" or ch == "_" then
								ch = "."
							elseif ch == "." or ch == "," or ch == " " then
								ch = " "
							else
								ch = ":"
							end
						elseif b == 2 then
							if (ch == ch:upper() and ch ~= ch:lower()) or ch == "8" or ch == "0" then
								ch = ":"
							elseif ch == ":" or ch == ";" or ch == "_" or ch == "." or ch == "," or ch == " " then
								ch = " "
							else
								ch = "."
							end
						elseif b == 3 then
							ch = " "
						end
						conc ..= ch
					end
					table.insert(render, conc)
				end
				AsciiText.Text = table.concat(render, "\n")
				task.wait()
			until os.clock() > st + 1
		end
		local source = string.split(AsciiText.Text, "\n")
		local target = source
		while table.concat(source, "\n") == table.concat(target, "\n") do
			task.wait()
			target = AsciiTextarts[math.random(1, #AsciiTextarts)]
		end
		animation(source, false)
		animation(target, true)
		AsciiText.Text = table.concat(target, "\n")
		AsciiTextartsw = false
	end
	local AsciiTextartin = nil
	AsciiText.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			AsciiTextartin = input
		end
	end)
	AsciiText.InputEnded:Connect(function(input)
		if AsciiTextartin == input then
			AsciiTextartin = nil
			switchart()
		end
	end)
	switchart()
end)
UI.CreateText(MainPage, `Reanimate V{UhhhhhhVersion}, By STEVE :D`, 15, Enum.TextXAlignment.Right)
UI.CreateSeparator(MainPage)
UI.CreateButton(MainPage, " &lt; Back to cool scene", 20).Activated:Connect(function()
	CracktroFrame.Interactable = false
	CracktroFrame.Visible = true
	MainPage.Interactable = false
	local tween = TweenService:Create(CracktroFrame, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.In), {
		Position = UDim2.new(0.5, 0, 0.5, 0),
	})
	tween:Play()
	tween.Completed:Connect(function()
		CracktroFrame.Interactable = true
	end)
end)
UI.CreateSwitch(MainPage, "Skip Intro", SaveData.SkipIntro).Changed:Connect(function(value)
	SaveData.SkipIntro = value
end)
UI.CreateDropdown(MainPage, "UI Theme", {
	"RGB/Default",
	"ALONE",
	"Oxide",
	"Patchma Hub",
	"Genesis V4",
	"Crimson",
	"r/masterhacker",
	"Homer Simpson",
	"Immortality Lord",
	"LIGHT RGB",
	"LIGHT ALONE",
	"Roserika",
	"FastTracker II Blue",
	"Cherry Blossom",
	"Sakura",
	"Tommorow Night 80s", -- my personal IDE theme
	"User Defined (see README)",
}, SaveData.UITheme).Changed:Connect(function(val)
	SaveData.UITheme = val
	SetUITheme(SaveData.UITheme)
end)
UI.CreateSeparator(MainPage)

local MusicName = UI.CreateText(MainPage, "", 15, Enum.TextXAlignment.Center)
UI.CreateButton(MainPage, "Random UI Music", 20).Activated:Connect(function()
	MusicPlayer.PlayMusic()
end)
local _musicnames = {"-- Choose --"}
for i=1, #MusicPlayer.Database do
	local hi = MusicPlayer.Database[i]
	table.insert(_musicnames, hi[2])
end
local MusicSelect = UI.CreateDropdown(MainPage, "UI Music", _musicnames, 1)
MusicSelect.Changed:Connect(function(val)
	if val > 1 then
		MusicSelect.Value = 1
		MusicPlayer.PlayMusic(val - 1)
	end
end)
UI.CreateSwitch(MainPage, "Mute UI Music", SaveData.MuteUIMusic).Changed:Connect(function(value)
	SaveData.MuteUIMusic = value
end)
UI.CreateSwitch(MainPage, "Mute Reanim Music", SaveData.MuteReanimMusic).Changed:Connect(function(value)
	SaveData.MuteReanimMusic = value
end)
UI.CreateSwitch(MainPage, "Mute Sounds", SaveData.MuteUISound).Changed:Connect(function(value)
	SaveData.MuteUISound = value
	if value then
		UISound.Click.Volume = 0
	else
		UISound.Click.Volume = 1
	end
end)
UI.CreateSeparator(MainPage)

UISound.MovesetMusic = Util.Instance("Sound", UIMainFrame)
UISound.MovesetMusic.Looped = true
UISound.MovesetMusic.PlaybackRegionsEnabled = false
UISound.MovesetMusic.Volume = 1
UISound.MovesetMusic.Name = "(unknown)"
UISound.MovesetMusic:SetAttribute("Volume", 1)
local function SetOverrideMovesetMusic(soundid, soundname, volume, region)
	if soundid then
		UISound.MovesetMusic.SoundId = soundid
		UISound.MovesetMusic.Name = soundname or "(unknown)"
		if volume ~= nil then
			UISound.MovesetMusic:SetAttribute("Volume", volume)
		else
			UISound.MovesetMusic:SetAttribute("Volume", 1)
		end
		if region ~= nil then
			UISound.MovesetMusic.PlaybackRegionsEnabled = true
			UISound.MovesetMusic.LoopRegion = region
		else
			UISound.MovesetMusic.PlaybackRegionsEnabled = false
		end
		UISound.MovesetMusic.PlaybackSpeed = 1
		UISound.MovesetMusic.TimePosition = 0
		UISound.MovesetMusic:Play()
	else
		UISound.MovesetMusic:Stop()
	end
end
local function GetOverrideMovesetMusicTime()
	return UISound.MovesetMusic.TimePosition
end
local function SetOverrideMovesetMusicTime(t)
	UISound.MovesetMusic.TimePosition = t
end
local function SetOverrideMovesetMusicSpeed(speed)
	UISound.MovesetMusic.PlaybackSpeed = speed
end
UISound.DanceMusic = Util.Instance("Sound", UIMainFrame)
UISound.DanceMusic.Looped = true
UISound.DanceMusic.PlaybackRegionsEnabled = false
UISound.DanceMusic.Volume = 1
UISound.DanceMusic.Name = "(unknown)"
UISound.DanceMusic:SetAttribute("Volume", 1)
local function SetOverrideDanceMusic(soundid, soundname, volume, region)
	if soundid then
		UISound.DanceMusic.SoundId = soundid
		UISound.DanceMusic.Name = soundname or "(unknown)"
		if volume ~= nil then
			UISound.DanceMusic:SetAttribute("Volume", volume)
		else
			UISound.DanceMusic:SetAttribute("Volume", 1)
		end
		if region ~= nil then
			UISound.DanceMusic.PlaybackRegionsEnabled = true
			UISound.DanceMusic.LoopRegion = region
		else
			UISound.DanceMusic.PlaybackRegionsEnabled = false
		end
		UISound.DanceMusic.PlaybackSpeed = 1
		UISound.DanceMusic.TimePosition = 0
		UISound.DanceMusic:Play()
	else
		UISound.DanceMusic:Stop()
	end
end
local function GetOverrideDanceMusicTime()
	return UISound.DanceMusic.TimePosition
end
local function SetOverrideDanceMusicTime(t)
	UISound.DanceMusic.TimePosition = t
end
local function SetOverrideDanceMusicSpeed(speed)
	UISound.DanceMusic.PlaybackSpeed = speed
end

local _MainMusicIsMuted = SaveData.MuteUIMusic
AddToRenderStep(function()
	local musicname = UISound.Music.Name
	local mustmute = SaveData.MuteUIMusic
	if SaveData.MuteReanimMusic then
		UISound.MovesetMusic.Volume = 0
		UISound.DanceMusic.Volume = 0
	else
		if UISound.DanceMusic.IsPlaying then
			mustmute = true
			UISound.DanceMusic.Volume = UISound.DanceMusic:GetAttribute("Volume")
			UISound.MovesetMusic.Volume = 0
			musicname = UISound.DanceMusic.Name
		elseif UISound.MovesetMusic.IsPlaying then
			mustmute = true
			UISound.MovesetMusic.Volume = UISound.MovesetMusic:GetAttribute("Volume")
			musicname = UISound.MovesetMusic.Name
		end
	end
	if _MainMusicIsMuted ~= mustmute then
		_MainMusicIsMuted = mustmute
		if mustmute then
			UISound.Music.Volume = 0
		else
			UISound.Music.Volume = 1
		end
	end
	MusicName.Text = `Current Music Playing:\n{musicname:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;")}`
end)
task.wait()

FallenPartsDestroyHeight = workspace.FallenPartsDestroyHeight
if FallenPartsDestroyHeight ~= FallenPartsDestroyHeight then
	FallenPartsDestroyHeight = -500
end
local RejectCharacterDeletionsDisabled = false
pcall(function()
	local rcd, _ = gethiddenproperty(workspace, "RejectCharacterDeletions")
	if rcd.Name == "Disabled" then
		RejectCharacterDeletionsDisabled = true
	end
end)

local function CreateHumanoidCharacter()
	local char = Util.Instance("Model")
	char.Name = "(C) Uhhhhhh V" .. UhhhhhhVersion

	local god = Util.Instance("ForceField", char)
	god.Name = "heyy!! :33"
	god.Visible = false

	local hum = Util.Instance("Humanoid", char)
	hum.Name = "Humanoid"
	hum.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
	hum.RequiresNeck = false
	hum.BreakJointsOnDeath = false
	hum.UseJumpPower = true
	hum.WalkSpeed = 16
	hum.JumpPower = 50
	hum.Health = 100
	hum.MaxHealth = 100
	hum.MaxSlopeAngle = 89
	hum.HipHeight = 0
	hum.AutoRotate = true
	hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)

	local function makePart(name, size, pos)
		local part = Util.Instance("Part", char)
		part.Name = name
		part.Size = size
		part.Position = pos
		part.Anchored = false
		part.CanCollide = false
		part.Transparency = 1
		part.Reflectance = 0
		part.Color = Color3.new(1, 0, 0)
		part.CastShadow = false
		part.TopSurface = Enum.SurfaceType.Smooth
		part.BottomSurface = Enum.SurfaceType.Smooth
		part.LeftSurface = Enum.SurfaceType.Smooth
		part.RightSurface = Enum.SurfaceType.Smooth
		part.FrontSurface = Enum.SurfaceType.Smooth
		part.BackSurface = Enum.SurfaceType.Smooth
		return part
	end

	local root = makePart("HumanoidRootPart", Vector3.new(2, 2, 1), Vector3.new(0, 0, 0))
	local torso = makePart("Torso", Vector3.new(2, 2, 1), Vector3.new(0, 0, 0))
	local head = makePart("Head", Vector3.new(2, 1, 1), Vector3.new(0, 1.5, 0))
	local leftArm = makePart("Left Arm", Vector3.new(1, 2, 1), Vector3.new(-1.5, 0, 0))
	local rightArm = makePart("Right Arm", Vector3.new(1, 2, 1), Vector3.new(1.5, 0, 0))
	local leftLeg = makePart("Left Leg", Vector3.new(1, 2, 1), Vector3.new(-0.5, -2, 0))
	local rightLeg = makePart("Right Leg", Vector3.new(1, 2, 1), Vector3.new(0.5, -2, 0))

	local function makeMotor(name, p0, p1, c0, c1)
		local motor = Instance.new("Motor6D", p0)
		motor.Name = name
		motor.Part0 = p0
		motor.Part1 = p1
		motor.C0 = c0
		motor.C1 = c1
		motor.MaxVelocity = 0
		Util.LinkDestroyI2C(motor, RunService.PreRender:Connect(function()
			local scale = char:GetScale()
			motor:SetAttribute("Transform", Util.ScaleCFrame(motor.Transform, 1 / scale))
			motor.Transform = Util.ScaleCFrame(motor:GetAttribute("Transform") or CFrame.identity, scale)
		end))
	end

	makeMotor(
		"RootJoint", root, torso,
		CFrame.new(0, 0, 0, -1, 0, 0, 0, 0, 1, 0, 1, 0),
		CFrame.new(0, 0, 0, -1, 0, 0, 0, 0, 1, 0, 1, 0)
	)
	makeMotor(
		"Neck", torso, head,
		CFrame.new(0, 1, 0, -1, 0, 0, 0, 0, 1, 0, 1, 0),
		CFrame.new(0, -0.5, 0, -1, 0, 0, 0, 0, 1, 0, 1, 0)
	)
	makeMotor(
		"Left Shoulder", torso, leftArm,
		CFrame.new(-1, 0.5, 0, 0, 0, -1, 0, 1, 0, 1, 0, 0),
		CFrame.new(0.5, 0.5, 0, 0, 0, -1, 0, 1, 0, 1, 0, 0)
	)
	makeMotor(
		"Right Shoulder", torso, rightArm,
		CFrame.new(1, 0.5, 0, 0, 0, 1, 0, 1, 0, -1, 0, 0),
		CFrame.new(-0.5, 0.5, 0, 0, 0, 1, 0, 1, 0, -1, 0, 0)
	)
	makeMotor(
		"Left Hip", torso, leftLeg,
		CFrame.new(-1, -1, 0, 0, 0, -1, 0, 1, 0, 1, 0, 0),
		CFrame.new(-0.5, 1, 0, 0, 0, -1, 0, 1, 0, 1, 0, 0)
	)
	makeMotor(
		"Right Hip", torso, rightLeg,
		CFrame.new(1, -1, 0, 0, 0, 1, 0, 1, 0, -1, 0, 0),
		CFrame.new(0.5, 1, 0, 0, 0, 1, 0, 1, 0, -1, 0, 0)
	)

	local headshape = Util.Instance("SpecialMesh", head)
	headshape.Name = "Mesh"
	headshape.MeshType = Enum.MeshType.Head
	headshape.Scale = Vector3.new(1.25, 1.25, 1.25)

	local face = Util.Instance("Decal", head)
	face.Name = "face"
	face.Texture = "rbxassetid://123572006339559"
	face.Color3 = Color3.new(0, 0, 0)

	local tshirt = Util.Instance("Decal", torso)
	tshirt.Name = "triforce"
	tshirt.Texture = "rbxassetid://101055520647223"
	tshirt.Color3 = Color3.new(1, 1, 1)
	
	Util.LinkDestroyI2C(char, RunService.PreRender:Connect(function()
		face.Transparency = Util.GetTransparency(head)
		tshirt.Transparency = Util.GetTransparency(torso)
	end))

	char.PrimaryPart = root

	return char
end

local GameSettings = UserSettings():GetService("UserGameSettings")

SaveData.NoInfiniteJump = not not SaveData.NoInfiniteJump
SaveData.NoclipEnabled = not not SaveData.NoclipEnabled
SaveData.CtrlClickEnabled = not not SaveData.CtrlClickEnabled
SaveData.ClickFlingEnabled = not not SaveData.ClickFlingEnabled
SaveData.NoSmoothCam = not not SaveData.NoSmoothCam
SaveData.NoSeatSitEnabled = not SaveData.NoSeatSitEnabled
SaveData.ToolGrabEnabled = not not SaveData.ToolGrabEnabled
SaveData.ScaleGravityEnabled = not not SaveData.ScaleGravityEnabled
SaveData.CharacterScale = SaveData.CharacterScale or 1
SaveData.P2PCollision = not not SaveData.P2PCollision
SaveData.ShiftlockDisabled = not not SaveData.ShiftlockDisabled
SaveData.NoLoadAnimationHook = not not SaveData.NoLoadAnimationHook
SaveData.NoPhysicsRepRootPart = not not SaveData.NoPhysicsRepRootPart
SaveData.NetlessVelocity = SaveData.NetlessVelocity or 25.01
SaveData.UsePatchmaLikeNetless = not not SaveData.UsePatchmaLikeNetless
SaveData.UseAngularVelocity = not not SaveData.UseAngularVelocity

-- empyrean-like thing
local _G_Uhhhhhh = {}
-- jjsloit didnt have _G, just making sure if 100% unc execs dont have this even
pcall(function() _G.Uhhhhhh = _G_Uhhhhhh end)
_G_Uhhhhhh.BindableEvent = Util.Instance("BindableEvent") -- not used 3:

local Reanimate = {
	Current = nil,
	Character = nil,
	CharacterLTMs = {},
	Starting = false,
	Stopping = false,
	UseLoadAnimationHook = not SaveData.NoLoadAnimationHook,
	UsePhysicsRepRootPart = not SaveData.NoPhysicsRepRootPart,
	PhysicsRepRootPartFling = 1 / 10,
	NetlessVelocity = SaveData.NetlessVelocity,
	UsePatchmaLikeNetless = SaveData.UsePatchmaLikeNetless,
	UseAngularVelocity = SaveData.UseAngularVelocity,
	InfiniteJump = not SaveData.NoInfiniteJump,
	Noclip = SaveData.NoclipEnabled,
	CtrlClick = SaveData.CtrlClickEnabled,
	ClickFling = SaveData.ClickFlingEnabled,
	SmoothCam = not SaveData.NoSmoothCam,
	SeatSit = not SaveData.NoSeatSitEnabled,
	ToolGrab = SaveData.ToolGrabEnabled,
	ScaleGravity = SaveData.ScaleGravityEnabled,
	AntiExplosions = true,
	CharacterScale = SaveData.CharacterScale,
	P2PCollision = false,
	ShiftlockEnabled = not SaveData.ShiftlockDisabled,
	Shiftlocked = false,
	ShouldRotationType = function(self)
		if self.Camera:IsMouseLocked() and not self.Camera.Scriptable and self.Character then
			local hum = self.Character:FindFirstChildOfClass("Humanoid")
			if hum and hum.AutoRotate and hum.RootPart and not hum.RootPart:IsGrounded() then
				local state = hum:GetState().Name
				if table.find({"Running", "Jumping", "Freefall", "Landed", "Climbing"}, state) then
					return true
				end
			end
		end
		return false
	end,
	Camera = {
		CFrame = CFrame.identity,
		Focus = CFrame.identity,
		Scriptable = false,
		Zoom = 16,
		FieldOfView = 70,
		Input = Vector3.zero,
		_Zoom = 16,
		OnReset = function(self)
			self.Zoom = (self.Focus.Position - self.CFrame.Position).Magnitude
			self._Zoom = self.Zoom
			self.Scriptable = false
			self.FieldOfView = 70
			self.Inputs:Reset()
		end,
		OnPanInput = function(self, vec, accum)
			if accum then
				self.Input += Vector3.new(vec.X, vec.Y, 0)
			else
				self.Input = Vector3.new(vec.X, vec.Y, self.Input)
			end
		end,
		OnZoomInput = function(self, zoom)
			self.Input += Vector3.new(0, 0, zoom)
		end,
		Inputs = {
			KB = {
				Left = false,
				Right = false,
			},
			MS = {
				RMB = false,
			},
			TC = {
				DJ = nil,
				Touch = {},
				LP = nil,
			},
			Reset = function(self)
				self.KB.Left = false
				self.KB.Right = false
				self.MS.RMB = false
				self.TC.DJ = nil
				table.clear(self.TC.Touch)
				self.TC.LP = nil
			end,
		},
	},
	LocalTransparencyModifier = 0,
	Control = {
		Move = Vector3.zero,
		Jump = false,
		Inputs = {
			KB = {
				Up = false,
				Down = false,
				Left = false,
				Right = false,
				Space = false,
			},
			TC = {
				DJ = nil,
				LP = nil,
				JB = nil,
			},
			Reset = function(self)
				self.KB.Up = false
				self.KB.Down = false
				self.KB.Left = false
				self.KB.Right = false
				self.KB.Space = false
				self.TC.DJ = nil
				self.TC.LP = nil
				self.TC.JB = nil
			end,
		}
	}
}
Reanimate.Camera.IsFirstPerson = function(self)
	return self.Zoom < 0.75
end
Reanimate.Camera.IsMouseLocked = function(self)
	return self:IsFirstPerson() or Reanimate.Shiftlocked
end
Reanimate.Camera.IsMousePanning = function(self)
	return self:IsMouseLocked() or self.Inputs.MS.RMB
end
do
	local function IsInThumbstickArea(pos)
		local playerGui = Player:FindFirstChildOfClass("PlayerGui")
		local touchGui = playerGui and playerGui:FindFirstChild("TouchGui")
		if not touchGui.Enabled then
			return false
		end
		local touchFrame = touchGui and touchGui:FindFirstChild("TouchControlFrame")
		local thumbstickFrame = touchFrame and (touchFrame:FindFirstChild("DynamicThumbstickFrame") or touchFrame:FindFirstChild("ThumbstickFrame"))
		if not thumbstickFrame then
			return false
		end
		local posTopLeft = thumbstickFrame.AbsolutePosition
		local posBottomRight = posTopLeft + thumbstickFrame.AbsoluteSize
		return pos.X >= posTopLeft.X and pos.Y >= posTopLeft.Y and pos.X <= posBottomRight.X and pos.Y <= posBottomRight.Y
	end
	local function IsInJumpButtonArea(pos)
		local playerGui = Player:FindFirstChildOfClass("PlayerGui")
		local touchGui = playerGui and playerGui:FindFirstChild("TouchGui")
		if not touchGui.Enabled then
			return false
		end
		local touchFrame = touchGui and touchGui:FindFirstChild("TouchControlFrame")
		local jumpButton = touchFrame and touchFrame:FindFirstChild("JumpButton")
		if not jumpButton then
			return false
		end
		local posTopLeft = jumpButton.AbsolutePosition
		local posBottomRight = posTopLeft + jumpButton.AbsoluteSize
		return pos.X >= posTopLeft.X and pos.Y >= posTopLeft.Y and pos.X <= posBottomRight.X and pos.Y <= posBottomRight.Y
	end
	do -- Control
		local self = Reanimate.Control
		UserInputService.InputBegan:Connect(function(input, gpe)
			if GuiService.MenuIsOpen then return end
			if UserInputService:GetFocusedTextBox() then return end
			if input.UserInputType == Enum.UserInputType.Keyboard then
				if input.KeyCode == Enum.KeyCode.W then
					self.Inputs.KB.Up = true
				end
				if input.KeyCode == Enum.KeyCode.S then
					self.Inputs.KB.Down = true
				end
				if input.KeyCode == Enum.KeyCode.Up then
					self.Inputs.KB.Up = true
				end
				if input.KeyCode == Enum.KeyCode.Down then
					self.Inputs.KB.Down = true
				end
				if input.KeyCode == Enum.KeyCode.A then
					self.Inputs.KB.Left = true
				end
				if input.KeyCode == Enum.KeyCode.D then
					self.Inputs.KB.Right = true
				end
				if input.KeyCode == Enum.KeyCode.Space then
					self.Inputs.KB.Space = true
				end
			end
			if input.UserInputType == Enum.UserInputType.Touch then
				if self.Inputs.TC.DJ == nil and IsInThumbstickArea(input.Position) then
					self.Inputs.TC.DJ = input
					self.Inputs.TC.LP = input.Position
					return
				end
				if self.Inputs.TC.JB == nil and IsInJumpButtonArea(input.Position) then
					self.Inputs.TC.JB = input
					return
				end
			end
		end)
		UserInputService.InputEnded:Connect(function(input)
			if GuiService.MenuIsOpen then return end
			if UserInputService:GetFocusedTextBox() then return end
			if input.UserInputType == Enum.UserInputType.Keyboard then
				if input.KeyCode == Enum.KeyCode.W then
					self.Inputs.KB.Up = false
				end
				if input.KeyCode == Enum.KeyCode.S then
					self.Inputs.KB.Down = false
				end
				if input.KeyCode == Enum.KeyCode.Up then
					self.Inputs.KB.Up = false
				end
				if input.KeyCode == Enum.KeyCode.Down then
					self.Inputs.KB.Down = false
				end
				if input.KeyCode == Enum.KeyCode.A then
					self.Inputs.KB.Left = false
				end
				if input.KeyCode == Enum.KeyCode.D then
					self.Inputs.KB.Right = false
				end
				if input.KeyCode == Enum.KeyCode.Space then
					self.Inputs.KB.Space = false
				end
			end
			if input.UserInputType == Enum.UserInputType.Touch then
				if self.Inputs.TC.DJ == input then
					self.Inputs.TC.DJ = nil
					self.Inputs.TC.LP = nil
				elseif self.Inputs.TC.JB == input then
					self.Inputs.TC.JB = nil
				end
			end
		end)
		local function resetInputDevices()
			self.Inputs:Reset()
		end
		UserInputService.WindowFocused:Connect(resetInputDevices)
		UserInputService.WindowFocusReleased:Connect(resetInputDevices)
		UserInputService.TextBoxFocusReleased:Connect(resetInputDevices)
		GuiService.MenuOpened:Connect(resetInputDevices)
		RunService:BindToRenderStep("Uhhhhhh_Control", Enum.RenderPriority.Input.Value + 1, function(dt)
			local screensize = Util.GetScreenSize()
			self.Move = Vector3.zero
			if self.Inputs.KB.Up then
				self.Move += Vector3.new(0, 0, -1)
			end
			if self.Inputs.KB.Down then
				self.Move += Vector3.new(0, 0, 1)
			end
			if self.Inputs.KB.Left then
				self.Move += Vector3.new(-1, 0, 0)
			end
			if self.Inputs.KB.Right then
				self.Move += Vector3.new(1, 0, 0)
			end
			if self.Inputs.TC.DJ and self.Inputs.TC.LP then
				local stickrad = 40
				if math.min(screensize.X, screensize.Y) < 500 then
					stickrad = 20
				end
				local dir = (self.Inputs.TC.DJ.Position - self.Inputs.TC.LP) / stickrad
				if dir.Magnitude > 0.05 then
					dir = dir.Unit * math.min(1, (dir.Magnitude - 0.05) / (1 - 0.05))
					self.Move = Vector3.new(dir.X, 0, dir.Y)
				end
			end
			if self.Move.Magnitude > 1 then self.Move = self.Move.Unit end
			self.Jump = false
			if self.Inputs.KB.Space then
				self.Jump = true
			end
			if self.Inputs.TC.JB then
				self.Jump = true
			end
		end)
	end
	do -- Camera
		local self = Reanimate.Camera
		local function AdjustTouchPitchSensitivity(delta)
			local pitch = Camera.CFrame:ToEulerAnglesYXZ()
			if delta.Y * pitch >= 0 then
				return delta
			end
			local curveY = 1 - (2 * math.abs(pitch) / math.pi) ^ 0.75
			local sensitivity = curveY * 0.75 + 0.25
			return Vector2.new(1, sensitivity) * delta
		end
		UserInputService.InputBegan:Connect(function(input, gpe)
			if GuiService.MenuIsOpen then return end
			if UserInputService:GetFocusedTextBox() then return end
			if input.UserInputType == Enum.UserInputType.Keyboard then
				if input.KeyCode == Enum.KeyCode.LeftShift or input.KeyCode == Enum.KeyCode.RightShift then
					Reanimate.Shiftlocked = Reanimate.ShiftlockEnabled and not Reanimate.Shiftlocked
				end
				if input.KeyCode == Enum.KeyCode.Left then
					self.Inputs.KB.Left = true
				end
				if input.KeyCode == Enum.KeyCode.Right then
					self.Inputs.KB.Right = true
				end
			end
			if input.UserInputType == Enum.UserInputType.MouseButton2 then
				if gpe then return end
				self.Inputs.MS.RMB = true
			end
			if input.UserInputType == Enum.UserInputType.Touch then
				if gpe then return end
				if self.Inputs.TC.DJ == nil and IsInThumbstickArea(input.Position) then
					self.Inputs.TC.DJ = input
					return
				end
				self.Inputs.TC.Touch[input] = true
			end
		end)
		UserInputService.InputChanged:Connect(function(input, gpe)
			if GuiService.MenuIsOpen then return end
			if input.UserInputType == Enum.UserInputType.MouseMovement then
				if self:IsMousePanning() then
					self:OnPanInput(Vector2.new(input.Delta.X, input.Delta.Y) * Vector2.new(1, 0.77) * math.rad(0.5), false)
				end
			end
			if input.UserInputType == Enum.UserInputType.MouseWheel then
				if gpe and not self:IsMousePanning() then return end
				local zoom = math.clamp(-input.Position.Z, -1, 1)
				self:OnZoomInput(zoom)
			end
			if input.UserInputType == Enum.UserInputType.Touch then
				if self.Inputs.TC.DJ == input then
					return
				end
				local touches = {}
				for touch,exist in self.Inputs.TC.Touch do
					if exist then table.insert(touches, touch) end
				end
				if #touches == 1 then
					if touches[1] == input then
						self:OnPanInput(Vector2.new(input.Delta.X, input.Delta.Y) * Vector2.new(1, 0.66) * math.rad(1), true)
					end
				end
				if #touches == 2 then
					local pinch = (touches[1].Position - touches[2].Position).Magnitude
					if self.Inputs.TC.LP then
						local zoom = (self.Inputs.TC.LP - pinch) * 0.04
						self:OnZoomInput(zoom)
					end
					self.Inputs.TC.LP = pinch
				else
					self.Inputs.TC.LP = nil
				end
			end
		end)
		UserInputService.InputEnded:Connect(function(input)
			if GuiService.MenuIsOpen then return end
			if UserInputService:GetFocusedTextBox() then return end
			if input.UserInputType == Enum.UserInputType.Keyboard then
				if input.KeyCode == Enum.KeyCode.Left then
					self.Inputs.KB.Left = false
				end
				if input.KeyCode == Enum.KeyCode.Right then
					self.Inputs.KB.Right = false
				end
			end
			if input.UserInputType == Enum.UserInputType.MouseButton2 then
				self.Inputs.MS.RMB = false
			end
			if input.UserInputType == Enum.UserInputType.Touch then
				if self.Inputs.TC.DJ == input then
					self.Inputs.TC.DJ = nil
					return
				end
				self.Inputs.TC.LP = nil
				self.Inputs.TC.Touch[input] = false
			end
		end)
		UserInputService.PointerAction:Connect(function(wheel, pan, pinch, gpe)
			if not gpe then
				self:OnPanInput(pan * Vector2.new(1, 0.77) * math.rad(7), false)
				self:OnZoomInput(-wheel - pinch)
			end
		end)
		local function resetInputDevices()
			self.Inputs:Reset()
		end
		UserInputService.WindowFocused:Connect(resetInputDevices)
		UserInputService.WindowFocusReleased:Connect(resetInputDevices)
		UserInputService.TextBoxFocusReleased:Connect(resetInputDevices)
		GuiService.MenuOpened:Connect(resetInputDevices)
		local states = {
			[false] = "rbxasset://textures/ui/mouseLock_off@2x.png",
			[true] = "rbxasset://textures/ui/mouseLock_on@2x.png"
		}
		local MobileShiftlock = Instance.new("ImageButton")
		MobileShiftlock.Parent = SCREENGUI
		MobileShiftlock.BackgroundTransparency = 1
		MobileShiftlock.Position = UDim2.new(1, -190, 1, -60)
		MobileShiftlock.Size = UDim2.new(0, 40, 0, 40)
		MobileShiftlock.Image = states[false]
		local state = false
		AddToRenderStep(function()
			if state ~= Reanimate.Shiftlocked then
				state = Reanimate.Shiftlocked
				MobileShiftlock.Image = states[state]
			end
			MobileShiftlock.Visible = not not (Reanimate.Character and UserInputService.TouchEnabled)
		end)
		MobileShiftlock.Activated:Connect(function()
			Reanimate.Shiftlocked = Reanimate.ShiftlockEnabled and not Reanimate.Shiftlocked
		end)
		RunService:BindToRenderStep("Uhhhhhh_Camera", Enum.RenderPriority.Camera.Value + 1, function(dt)
			if self.Inputs.KB.Left then
				self:OnPanInput(Vector2.new(math.rad(-120) * dt, 0), true)
			end
			if self.Inputs.KB.Right then
				self:OnPanInput(Vector2.new(math.rad(120) * dt, 0), true)
			end
			local ltm = Reanimate.LocalTransparencyModifier
			local tltm = 0
			local sltm = dt * 3
			if not self.Scriptable then
				if self:IsFirstPerson() then
					tltm = 1
				elseif self.Zoom < 1.5 * Reanimate.CharacterScale then
					tltm = 0.5
				end
			end
			if math.abs(ltm - tltm) <= sltm then
				ltm = tltm
			elseif ltm < tltm then
				ltm += sltm
			else
				ltm -= sltm
			end
			Reanimate.LocalTransparencyModifier = ltm
			if not Reanimate.ShiftlockEnabled and Reanimate.Shiftlocked then
				Reanimate.Shiftlocked = false
			end
			if Reanimate.Character then
				local targetMouseBehavior = Enum.MouseBehavior.Default
				if self:IsMousePanning() then
					if self:IsMouseLocked() then
						if UserInputService.TouchEnabled then
							targetMouseBehavior = Enum.MouseBehavior.LockCurrentPosition
						else
							targetMouseBehavior = Enum.MouseBehavior.LockCenter
						end
					else
						targetMouseBehavior = Enum.MouseBehavior.LockCurrentPosition
					end
				end
				if UserInputService.MouseBehavior ~= targetMouseBehavior then
					UserInputService.MouseBehavior = targetMouseBehavior
				end
				local targetMouseIcon = ""
				if Reanimate.Shiftlocked then
					targetMouseIcon = "rbxasset://textures/Cursors/CrossMouseIcon.png"
				end
				if UserInputService.MouseIcon ~= targetMouseIcon then
					UserInputService.MouseIcon = targetMouseIcon
				end
				if GameSettings.RotationType ~= Enum.RotationType.MovementRelative then
					GameSettings.RotationType = Enum.RotationType.MovementRelative
				end
				local Humanoid = Reanimate.Character:FindFirstChildOfClass("Humanoid")
				local RootPart = Reanimate.Character:FindFirstChild("HumanoidRootPart")
				if Humanoid and RootPart and Camera.CameraSubject == Humanoid then
					if self.Scriptable then
						Camera.FieldOfView = self.FieldOfView
						Camera.FieldOfViewMode = "Vertical"
					else
						Camera.FieldOfView = 70
						Camera.FieldOfViewMode = "Vertical"
						local newCameraCFrame, newCameraFocus = self.CFrame, self.Focus
						local subjectPosition = RootPart.Position + RootPart.CFrame.UpVector * 1.5
						subjectPosition += RootPart.CFrame.Rotation * Humanoid.CameraOffset
						local input = self.Input * Vector3.new(1, GameSettings:GetCameraYInvertValue(), 1)
						self.Input = Vector3.zero
						local zoomDelta = input.Z
						if math.abs(zoomDelta) > 0 then
							if zoomDelta > 0 then
								self.Zoom += zoomDelta * (1 + self.Zoom * 0.5)
							else
								self.Zoom = (self.Zoom + zoomDelta) / (1 - zoomDelta * 0.5)
							end
						end
						if self.Zoom < 0.5 then
							self.Zoom = 0.5
						end
						self._Zoom = self.Zoom + (self._Zoom - self.Zoom) * math.exp(-32 * dt)
						local currLookVector = suppliedLookVector or newCameraCFrame.LookVector
						local currPitchAngle = math.asin(currLookVector.Y)
						local constrainedRotateInput = Vector2.new(input.X, math.clamp(input.Y, math.rad(-80) + currPitchAngle, math.rad(80) + currPitchAngle))
						local startCFrame = CFrame.lookAt(Vector3.zero, currLookVector)
						local newLookCFrame = CFrame.Angles(0, -constrainedRotateInput.X, 0) * startCFrame * CFrame.Angles(-constrainedRotateInput.Y, 0, 0)
						local newLookVector = newLookCFrame.LookVector
						if self:IsMouseLocked() and not self:IsFirstPerson() then
							local cameraRelativeOffset = newLookCFrame * Vector3.new(1.7, 0, 0)
							if cameraRelativeOffset == cameraRelativeOffset then
								subjectPosition += cameraRelativeOffset
							end
						end
						newCameraFocus = CFrame.new(subjectPosition)
						local cameraFocusP = newCameraFocus.Position
						newCameraCFrame = CFrame.lookAt(cameraFocusP - newLookVector * self._Zoom, cameraFocusP)
						self.CFrame, self.Focus = newCameraCFrame, newCameraFocus
					end
					Camera.CFrame, Camera.Focus = self.CFrame, self.Focus
				end
				for _,v in Reanimate.CharacterLTMs do
					v.LocalTransparencyModifier = ltm
				end
			end
			pcall(function() CoreGui.TopBarApp.TopBarApp.FullScreenFrame.HurtOverlay.Visible = false end)
		end)
	end
end
Reanimate.CreateCharacter = function(InitCFrame)
	local RC = Reanimate.Character
	local cf = CFrame.new(Camera.Focus.Position)
	if RC then
		local r = RC:FindFirstChild("HumanoidRootPart")
		if r then
			cf = r.CFrame
		end
		RC:Destroy()
	elseif Player.Character then
		local r = Player.Character:FindFirstChild("HumanoidRootPart")
		if r then
			cf = r.CFrame
		end
	end
	if InitCFrame then
		cf = InitCFrame
	end
	Reanimate.Camera.CFrame, Reanimate.Camera.Focus = Camera.CFrame, Camera.Focus
	Reanimate.Camera:OnReset()
	RC = CreateHumanoidCharacter()
	local ltmparts = Reanimate.CharacterLTMs
	table.clear(ltmparts)
	local function OnDescendant(v)
		local exist = pcall(function()
			return v.LocalTransparencyModifier
		end)
		if exist then
			table.insert(ltmparts, v)
			local conn = nil
			conn = v.AncestryChanged:Connect(function()
				if not v:IsDescendantOf(RC) then
					local i = table.find(ltmparts, v)
					if i then
						table.remove(ltmparts, i)
					end
					conn:Disconnect()
				end
			end)
		end
	end
	RC.DescendantAdded:Connect(OnDescendant)
	for _,v in RC:GetDescendants() do
		task.spawn(OnDescendant, v)
	end
	RC:ScaleTo(Reanimate.CharacterScale)
	local RCHumanoid, RCRootPart = RC.Humanoid, RC.HumanoidRootPart
	local RCHead = RC.Head
	--[[local Anchor = Instance.new("Part", RCRootPart)
	Anchor.Name = "i can take explosions >:3"
	Anchor.Transparency = 1
	Anchor.Anchored = false
	Anchor.CanCollide = false
	Anchor.CanQuery = false
	Anchor.CanTouch = false
	Anchor.CustomPhysicalProperties = PhysicalProperties.new(100, 0, 0, 0, 0)
	Anchor.Size = Vector3.new(2048, 2048, 2048)
	local AnchorWeld = Instance.new("Weld")]]
	RC.Parent = workspace
	RCRootPart.CFrame = cf
	local SeatWeld = nil
	local LastJumpOffSeat = 0
	RCHumanoid.Touched:Connect(function(part, limb)
		if Reanimate.SeatSit and part:IsA("Seat") and not RCHumanoid.Sit and os.clock() - LastJumpOffSeat > 2 then
			RCHumanoid.Sit = true
			if SeatWeld ~= nil then
				SeatWeld = SeatWeld:Destroy()
			end
			SeatWeld = Instance.new("Weld")
			SeatWeld.Name = "hell yeah!! :3"
			SeatWeld.Parent = RCRootPart
			SeatWeld.Part0 = part
			SeatWeld.Part1 = RCRootPart
			SeatWeld.C0 = CFrame.new(0, part.Size.Y / 2, 0)
			SeatWeld.C1 = CFrame.new(0, -1.5 * RC:GetScale(), 0)
			Util.LinkDestroyI2C(SeatWeld, RCHumanoid:GetPropertyChangedSignal("Jump"):Connect(function()
				if RCHumanoid.Jump then
					RCHumanoid.Sit = false
					SeatWeld:Destroy()
				end
			end))
		end
		if part.Name == "Handle" and part.Parent:IsA("Tool") and not part.Parent.Parent:FindFirstChildOfClass("Humanoid") then
			if Reanimate.ToolGrab then
				if Player.Character then
					local Humanoid = Player.Character:FindFirstChildOfClass("Humanoid")
					if Humanoid then
						Humanoid:EquipTool(part.Parent)
					end
				end
			end
		end
	end)
	RCHumanoid.Seated:Connect(function(active)
		if not active then
			if SeatWeld ~= nil then
				SeatWeld = SeatWeld:Destroy()
			end
			LastJumpOffSeat = os.clock()
		end
	end)
	local LastJump = false
	local RCP = RaycastParams.new()
	RCP.RespectCanCollide = true
	RCP.FilterType = Enum.RaycastFilterType.Exclude
	RCP.FilterDescendantsInstances = {RC}
	local noclipStates = {"Running", "Jumping", "Freefall", "Landed", "Climbing", "Swimming"}
	local fallingStates = {"Jumping", "Freefall", "PlatformStanding", "Physics", "Ragdoll", "GettingUp", "Seated", "Flying", "FallingDown"}
	local LastSafest = RCRootPart.CFrame
	Util.LinkDestroyI2C(RC, RunService.PreAnimation:Connect(function(dt)
		local CMove, CJump = Reanimate.Control.Move, Reanimate.Control.Jump
		local CamCF = Reanimate.Camera.CFrame
		local _,x,_ = CamCF:ToEulerAngles(Enum.RotationOrder.YXZ)
		local MoveCF = CFrame.Angles(0, x, 0)
		pcall(sethiddenproperty, RCRootPart, "PhysicsRepRootPart", nil)
		if Reanimate.CharacterScale ~= RC:GetScale() then
			RC:ScaleTo(Reanimate.CharacterScale)
		end
		local RCHumanoidState = RCHumanoid:GetState().Name
		local clip = not table.find(noclipStates, RCHumanoidState)
		local gravaff = not not table.find(fallingStates, RCHumanoidState)
		for _,v in RC:GetChildren() do
			if v:IsA("BasePart") then
				v.CanCollide = clip or (not Reanimate.Noclip and v == RCRootPart)
			end
		end
		if gravaff then
			if Reanimate.ScaleGravity and not RCRootPart:IsGrounded() then
				RCRootPart.AssemblyLinearVelocity += Vector3.new(0, -workspace.Gravity * (Reanimate.CharacterScale - 1) * 0.25 * dt, 0)
			end
		end
		if LastJump ~= CJump then
			if CJump then
				if Reanimate.InfiniteJump and RCHumanoid:GetState() == Enum.HumanoidStateType.Freefall then
					RCRootPart.Velocity = Vector3.new(
						RCRootPart.Velocity.X, math.max(50, RCHumanoid.JumpPower), RCRootPart.Velocity.Z
					)
				end
			end
		end
		LastJump = CJump
		local TargetCameraOffset = (RCRootPart.CFrame * CFrame.new(0, 1.5, 0)):PointToObjectSpace(RCHead.Position)
		if not Reanimate.SmoothCam then
			TargetCameraOffset = Vector3.new(0, -1.5, 0) + Vector3.new(0, 1.5, 0) * RC:GetScale()
		end
		RCHumanoid.CameraOffset = TargetCameraOffset:Lerp(RCHumanoid.CameraOffset, math.exp(-9.8 * dt))
		if RCHumanoidState == "Swimming" then
			RCHumanoid:Move(CamCF:VectorToWorldSpace(CMove))
		else
			RCHumanoid:Move(MoveCF:VectorToWorldSpace(CMove))
		end
		RCHumanoid.Jump = CJump
		if RCRootPart.Position.Y < FallenPartsDestroyHeight + 3 * Reanimate.CharacterScale then
			RCRootPart.CFrame = LastSafest
			RCRootPart.Velocity = Vector3.new(0, 50, 0)
			RCRootPart.RotVelocity = Vector3.zero
		end
		local safe = true
		for i=1, 8 do
			local off = CFrame.Angles(0, (i / 4) * math.pi, 0):VectorToWorldSpace(Vector3.new(0, 0, -0.5))
			if not workspace:Raycast(RCRootPart.Position + off, Vector3.new(0, -(3 * Reanimate.CharacterScale + 8 + RCHumanoid.HipHeight), 0), RCP) then
				safe = false
			end
		end
		if safe then
			LastSafest = RCRootPart.CFrame
		end
	end))
	Reanimate.Character = RC
	_G_Uhhhhhh.Character = RC
end
Reanimate.DestroyCharacter = function()
	if Reanimate.Character then
		Reanimate.Character = Reanimate.Character:Destroy()
		_G_Uhhhhhh.Character = nil
	end
end

do
	local AntiflingHumanoids = {}
	local AntiflingBaseParts = {}
	RunService.PreAnimation:Connect(function()
		for i,v in AntiflingBaseParts do
			if v:IsDescendantOf(workspace) then
				v.CanCollide = false
				v.AssemblyLinearVelocity, v.AssemblyAngularVelocity = Vector3.zero, Vector3.zero
			else
				table.remove(AntiflingBaseParts, i)
			end
		end
		for i,v in AntiflingHumanoids do
			if v:IsDescendantOf(workspace) then
				v.EvaluateStateMachine = false
			else
				table.remove(AntiflingHumanoids, i)
			end
		end
	end)
	local OnBasePart = function(v)
		if v:IsA("BasePart") then
			v.CanCollide = false
			if not table.find(AntiflingBaseParts, v) then
				table.insert(AntiflingBaseParts, v)
			end
		end
		if v:IsA("Humanoid") then
			v.EvaluateStateMachine = false
			if not table.find(AntiflingHumanoids, v) then
				table.insert(AntiflingHumanoids, v)
			end
		end
	end
	local OnCharacter = function(character)
		character.DescendantAdded:Connect(OnBasePart)
		for _,v in character:GetDescendants() do
			OnBasePart(v)
		end
	end
	local OnPlayer = function(player)
		if player == Player then return end
		player.CharacterAdded:Connect(OnCharacter)
		if player.Character then OnCharacter(player.Character) end
	end
	Players.PlayerAdded:Connect(OnPlayer)
	for _,player in Players:GetPlayers() do
		OnPlayer(player)
	end
end

local HumanoidLASetHookState do
	local LoadAnimation_old = nil
	local function LoadAnimation_new(animation)
		local char = Instance.new("Model")
		char.Parent = workspace
		local hum = Instance.new("Humanoid")
		hum.Parent = char
		local anim = LoadAnimation_old(hum, animation)
		hum.Parent = nil
		char:Destroy()
		--warn("LoadAnimation prevented!")
		return anim
	end
	local LoadAnimation_nc = nil
	local _HumanoidDummy = Instance.new("Humanoid")
	local _HumanoidLA = _HumanoidDummy.LoadAnimation
	local newloadanimation = newcclosure(function(self, animation)
		if not checkcaller() and typeof(self) == "Instance" and (self:IsA("Humanoid") or self:IsA("Animator")) and typeof(animation) == "Instance" and animation:IsA("Animation") then
			return LoadAnimation_new(animation)
		end
		return LoadAnimation_old(self, animation)
	end)
	local newnamecall = newcclosure(function(...)
		local method = getnamecallmethod()
		if not checkcaller() and method and (method == "LoadAnimation" or method == "loadAnimation") then
			local self, animation = ...
			if typeof(self) == "Instance" and (self:IsA("Humanoid") or self:IsA("Animator")) and typeof(animation) == "Instance" and animation:IsA("Animation") then
				return LoadAnimation_new(animation)
			end
		end
		return LoadAnimation_nc(...)
	end)
	HumanoidLASetHookState = function(hooked)
		if hooked then
			if not LoadAnimation_old then
				LoadAnimation_old = hookfunction(_HumanoidLA, clonefunction(newloadanimation))
			end
			if not LoadAnimation_nc then
				LoadAnimation_nc = hookmetamethod(_HumanoidDummy, "__namecall", clonefunction(newnamecall))
			end
		else
			if LoadAnimation_old then
				hookfunction(_HumanoidLA, LoadAnimation_old)
				LoadAnimation_old = nil
			end
			if LoadAnimation_nc then
				hookmetamethod(_HumanoidDummy, "__namecall", LoadAnimation_nc)
				LoadAnimation_nc = nil
			end
		end
	end
end

Util.SetMotor6DTransform = function(motor, transform)
	local name = motor.Name
	motor.MaxVelocity = 9e9
	local _, _, angle = transform:ToEulerAngles(Enum.RotationOrder.ZYX)
	motor:SetDesiredAngle(angle)
	local axis, angle = transform:ToAxisAngle()
	local newangle = axis * angle
	pcall(sethiddenproperty, motor, "ReplicateCurrentOffset6D", transform.Position)
	pcall(sethiddenproperty, motor, "ReplicateCurrentAngle6D", newangle)
end
Util.SetMotor6DOffset = function(motor, offset)
	Util.SetMotor6DTransform(motor, motor.C0:Inverse() * offset * motor.C1)
end

Util.ShowPartHitbox = function(part)
	local w = Instance.new("WireframeHandleAdornment")
	w.Name = "TempWireframe"
	w.Adornee = part
	w.Color3 = Color3.new(0, 1, 0)
	w.Transparency = 0
	w.ZIndex = 10
	w.AlwaysOnTop = true
	w.Thickness = 1
	w.Parent = SCREENGUI
	local hs = part.Size / 2
	local verts = {
		Vector3.new(-hs.X, -hs.Y, -hs.Z),
		Vector3.new( hs.X, -hs.Y, -hs.Z),
		Vector3.new( hs.X,  hs.Y, -hs.Z),
		Vector3.new(-hs.X,  hs.Y, -hs.Z),
		Vector3.new(-hs.X, -hs.Y,  hs.Z),
		Vector3.new( hs.X, -hs.Y,  hs.Z),
		Vector3.new( hs.X,  hs.Y,  hs.Z),
		Vector3.new(-hs.X,  hs.Y,  hs.Z),
	}
	w:AddLine(verts[1], verts[2])
	w:AddLine(verts[2], verts[3])
	w:AddLine(verts[3], verts[4])
	w:AddLine(verts[4], verts[1])
	w:AddLine(verts[5], verts[6])
	w:AddLine(verts[6], verts[7])
	w:AddLine(verts[7], verts[8])
	w:AddLine(verts[8], verts[5])
	w:AddLine(verts[1], verts[5])
	w:AddLine(verts[2], verts[6])
	w:AddLine(verts[3], verts[7])
	w:AddLine(verts[4], verts[8])
	Debris:AddItem(w, 1)
end

local RIGHTGRIP_C0 = CFrame.new(0, -1, 0, 1, 0, 0, 0, 0, 1, 0, -1, 0)
Util.PredictionFling = function(target)
	if typeof(target) == "Instance" then
		if target:IsA("Model") then
			target = target:FindFirstChild("HumanoidRootPart") or target.PrimaryPart or target:FindFirstChildWhichIsA("BasePart")
		end
		if target and target:IsA("BasePart") then
			if not target:IsDescendantOf(workspace) then
				return CFrame.identity, true
			end
			local t = os.clock()
			local t2 = math.sin(t * 15) + 1
			local cf = target.CFrame * CFrame.Angles(1.57, 0, 0)
			if not Reanimate.UsePhysicsRepRootPart then
				cf += target.AssemblyLinearVelocity * t2 + Vector3.new(0, -workspace.Gravity * 0.5 * t2 * t2 + math.sin(t * 60), 0)
				if cf.Position.Y < target.Position.Y - 1 then
					cf = cf.Rotation + Vector3.new(cf.Position.X, target.Position.Y - 1, cf.Position.Z)
				end
			end
			--cf += Vector3.new(0, -0.5, 0)
			local oldpos = target:GetAttribute("_Uhhhhhh_LastPosition")
			if not oldpos then
				oldpos = target.Position
				target:SetAttribute("_Uhhhhhh_LastPosition", oldpos)
			end
			if (target.Position - oldpos).Magnitude > 200 then
				target:SetAttribute("_Uhhhhhh_LastPosition", nil)
				return cf, true
			end
			return cf, false
		end
	end
	if typeof(target) == "CFrame" then
		return target, false
	end
	if typeof(target) == "Vector3" then
		return CFrame.new(target), false
	end
	return CFrame.identity, true
end
Util.PredictionFlingPart = function(target)
	if typeof(target) == "Instance" then
		if target:IsA("Model") then
			target = target:FindFirstChild("HumanoidRootPart") or target.PrimaryPart or target:FindFirstChildWhichIsA("BasePart")
		end
		if target and target:IsA("BasePart") then
			return target
		end
	end
end

SaveData.Reanimator = SaveData.Reanimator or {}

local LimbReanimator = {}
LimbReanimator.Name = "Limbs"
SaveData.Reanimator.LimbMode = SaveData.Reanimator.LimbMode or 0
SaveData.Reanimator.LimbVelocity = SaveData.Reanimator.LimbVelocity or 0
SaveData.Reanimator.LimbInitMode = SaveData.Reanimator.LimbInitMode or 2
SaveData.Reanimator.LimbReplicateFPS10 = not not SaveData.Reanimator.LimbReplicateFPS10
SaveData.Reanimator.LimbRoleplay = not not SaveData.Reanimator.LimbRoleplay
SaveData.Reanimator.LimbUseNaNFling = not not SaveData.Reanimator.LimbUseNaNFling
LimbReanimator.Mode = SaveData.Reanimator.LimbMode
-- 0 = hide rootpart (defaults to 1 when streaming is enabled)
-- 1 = keep rootpart streamed, puts rootpart below character
-- 2 = currentangle styled
-- 3 = rootpart is torso (most interpolated mode)
LimbReanimator.Velocity = SaveData.Reanimator.LimbVelocity
-- 0 = no velocity
-- 1 = copy from fake character
-- 2 = fling-y velocity
LimbReanimator.InitMode = SaveData.Reanimator.LimbInitMode
-- 0 = just reset
-- 1 = time permadeath, and reset
-- 2 = time permadeath, "without reset"
LimbReanimator.ReplicateFPS10 = SaveData.Reanimator.LimbReplicateFPS10
LimbReanimator.FlingEnabled = not SaveData.Reanimator.LimbRoleplay
LimbReanimator.UseNaNFling = SaveData.Reanimator.LimbUseNaNFling
LimbReanimator.FlingTargets = {}
LimbReanimator._TempNotFling = {}
function LimbReanimator.ShowHitboxes()
	pcall(function()
		Util.ShowPartHitbox(Player.Character.HumanoidRootPart)
	end)
end
function LimbReanimator.Fling(target, duration)
	if not LimbReanimator.FlingEnabled then return end
	if not target then return false end
	for _,v in LimbReanimator.FlingTargets do
		if v.Target == target then
			return false
		end
	end
	if target == Reanimate.Character then return false end
	if target == Player.Character then return false end
	if typeof(target) == "Instance" then
		if LimbReanimator._TempNotFling[target] then return end
		LimbReanimator._TempNotFling[target] = true
		task.delay(1, function()
			LimbReanimator._TempNotFling[target] = nil
		end)
	end
	table.insert(LimbReanimator.FlingTargets, {
		Target = target,
		Duration = duration
	})
	if typeof(target) == "Instance" then
		if target:IsA("Model") then
			local h = Util.Instance("Highlight")
			h.Adornee = target
			h.FillColor = Color3.new(1, 0, 0)
			h.OutlineColor = Color3.new(1, 0, 0)
			h.FillTransparency = 0.5
			h.OutlineTransparency = 0
			h.Parent = target
			TweenService:Create(h, TweenInfo.new(5), {
				FillTransparency = 1,
				OutlineTransparency = 1
			}):Play()
			game.Debris:AddItem(h, 5)
		end
	end
	return true
end
function LimbReanimator.SetRootPartMode(mode)
	assert(typeof(mode) == "number")
	LimbReanimator.Mode = mode
end
function LimbReanimator.Config(parent)
	UI.CreateText(parent, "as mentioned in the README, this only works for SOME games,\nbecause 'modern' games create the Animator automatically which breaks limb reanimation", 10, Enum.TextXAlignment.Center)
	local dmode = UI.CreateDropdown(parent, "RootPart Mode", {"RootPart in void", "Keep RootPart Streamed", "CurrentAngle Style", "RootPart is Torso"}, LimbReanimator.Mode + 1)
	local dvel = UI.CreateDropdown(parent, "RootPart Velocity", {"No Velocity", "Follow Character", "Fling-like"}, LimbReanimator.Velocity + 1)
	local dinit = UI.CreateDropdown(parent, "Init Mode", {"Reset Character", "CDSB + Reset", "CDSB + SSE + Kill"}, LimbReanimator.InitMode + 1)
	dmode.Changed:Connect(function(val)
		LimbReanimator.Mode = val - 1
		SaveData.Reanimator.LimbMode = val - 1
	end)
	dvel.Changed:Connect(function(val)
		LimbReanimator.Velocity = val - 1
		SaveData.Reanimator.LimbVelocity = val - 1
	end)
	dinit.Changed:Connect(function(val)
		LimbReanimator.InitMode = val - 1
		SaveData.Reanimator.LimbInitMode = val - 1
	end)
	UI.CreateSwitch(parent, "Show me how I look!", LimbReanimator.ReplicateFPS10).Changed:Connect(function(val)
		LimbReanimator.ReplicateFPS10 = val
		SaveData.Reanimator.LimbReplicateFPS10 = val
	end)
	UI.CreateSwitch(parent, "Target Fling Enabled", LimbReanimator.FlingEnabled).Changed:Connect(function(val)
		LimbReanimator.FlingEnabled = val
		SaveData.Reanimator.LimbRoleplay = not val
	end)
	UI.CreateText(parent, "vvv touch player = they lose ownership vvv", 10, Enum.TextXAlignment.Center)
	UI.CreateSwitch(parent, "Use NaN State Fling", LimbReanimator.UseNaNFling).Changed:Connect(function(val)
		LimbReanimator.UseNaNFling = val
		SaveData.Reanimator.LimbUseNaNFling = val
	end)
	Util.LinkDestroyI2C(dmode, RunService.Heartbeat:Connect(function()
		dmode.Value = LimbReanimator.Mode + 1
		dvel.Value = LimbReanimator.Velocity + 1
		dinit.Value = LimbReanimator.InitMode + 1
	end))
end
function LimbReanimator.Start()
	local LimbNames = {"Head", "Torso", "Left Arm", "Right Arm", "Left Leg", "Right Leg"}
	local rootposition = Vector3.new(
		math.random(-65536, 65536),
		math.random(-70000, -60000),
		math.random(-65536, 65536)
	)
	local InitCFrame = nil
	if Player.Character then
		local h = Player.Character:FindFirstChildOfClass("Humanoid")
		if h and h.RootPart then
			local r = h.RootPart
			InitCFrame = r.CFrame
			if h:GetState() ~= Enum.HumanoidStateType.Dead then
				if LimbReanimator.InitMode ~= 0 and replicatesignal then
					local a = Player:GetNetworkPing()
					replicatesignal(Player.ConnectDiedSignalBackend)
					local t = os.clock()
					while h:GetState() ~= Enum.HumanoidStateType.Dead do
						task.wait()
						local d = Players.RespawnTime - 0.1 + math.max(Player:GetNetworkPing() - a, 0)
						if os.clock() - t > d then break end
					end
					InitCFrame = r.CFrame
					if h:GetState() ~= Enum.HumanoidStateType.Dead then
						if LimbReanimator.InitMode == 2 then
							h:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
						end
						replicatesignal(Player.Kill)
						h.Health = 0
						task.delay(1, function()
							if h:IsDescendantOf(workspace) then
								replicatesignal(Player.ConnectDiedSignalBackend)
								h:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
								h:ChangeState(Enum.HumanoidStateType.Dead)
							end
						end)
					end
				else
					h:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
					h:ChangeState(Enum.HumanoidStateType.Dead)
				end
			end
		end
	end

	local LimbMapping = loadstring(readfile("UhhhhhhReanim/BuiltinModules/d_limbmap.lua"))()

	local FakeTools = {}
	local function CreateFakeTool()
		local FakeTool = Instance.new("Tool")
		FakeTool.Name = "faketool"
		local FakeToolHandle = Instance.new("Part")
		FakeToolHandle.Name = "Handle"
		FakeToolHandle.Transparency = 1
		FakeToolHandle.Color = Color3.new(0, 0, 1)
		FakeToolHandle.CanCollide = false
		FakeToolHandle.Parent = FakeTool
		FakeTool.Parent = Reanimate.Character
		local RightGrip = Instance.new("Weld")
		RightGrip.Name = "RightGrip"
		RightGrip.Parent = FakeToolHandle
		RightGrip.Part0 = Reanimate.Character and Reanimate.Character:FindFirstChild("Right Arm")
		RightGrip.Part1 = FakeToolHandle
		RightGrip.C0 = RIGHTGRIP_C0
		Util.LinkDestroyI2C(FakeTool, FakeTool:GetPropertyChangedSignal("Grip"):Connect(function()
			RightGrip.C1 = FakeTool.Grip
		end))
		RightGrip.C1 = FakeTool.Grip
		return FakeTool
	end

	local BaseParts = {}
	local UnknownMotor6Ds = {}
	local CharOnDesc = function(v)
		if v:IsA("BasePart") then
			if not table.find(BaseParts, v) then
				table.insert(BaseParts, v)
				v.CanCollide = false
				v:GetPropertyChangedSignal("CanCollide"):Connect(function()
					if v.CanCollide then v.CanCollide = false end
				end)
			end
		elseif v:IsA("Motor6D") then
			repeat task.wait() until (not v:IsDescendantOf(workspace)) or (v.Part0 and v.Part1)
			if not v:IsDescendantOf(workspace) then return end
			local p0, p1 = v.Part0, v.Part1
			if p0 and p1 then
				p0, p1 = p0.Name, p1.Name
				for _,map in LimbMapping do
					if map.Part0 == p0 and map.Part1 == p1 then
						map.Reference = v
						return
					end
				end
			end
			table.insert(UnknownMotor6Ds, v)
		elseif v:IsA("Animator") then
			task.defer(v.Destroy, v)
		elseif v:IsA("LocalScript") and v.Parent == Player.Character then
			v.Enabled = false
			v:GetPropertyChangedSignal("Enabled"):Connect(function()
				if v.Enabled then v.Enabled = false end
			end)
			v:GetPropertyChangedSignal("Disabled"):Connect(function()
				if not v.Disabled then v.Disabled = true end
			end)
		elseif v:IsA("Tool") and v.Parent == Player.Character then
			if not FakeTools[v] then
				FakeTools[v] = true
				local fake = CreateFakeTool()
				fake.Grip = v.Grip
				local h = v:FindFirstChild("Handle")
				if h ~= nil then
					fake.Handle.Size = h.Size
				end
				Util.LinkDestroyI2C(fake, RunService.PreSimulation:Connect(function()
					if v.Parent == Player.Character then
						fake.Grip = v.Grip
						local h = v:FindFirstChild("Handle")
						if h ~= nil then
							fake.Handle.Size = h.Size
						end
					else
						fake:Destroy()
						FakeTools[v] = nil
					end
				end))
				Util.LinkDestroyI2C(fake, v.ChildAdded:Connect(function(v)
					if v.ClassName == "StringValue" and v.Name == "toolanim" then
						local w = Instance.new("StringValue")
						w.Name = "toolanim"
						w.Value = v.Value
						w.Parent = fake
						Debris:AddItem(v, 1)
						Debris:AddItem(w, 1)
					end
				end))
				fake.Handle.Touched:Connect(function(t)
					local h = v:FindFirstChild("Handle")
					if h and t and h:IsDescendantOf(workspace) and t:IsDescendantOf(workspace) then
						h.CanTouch = true
						pcall(firetouchinterest, h, t, 0)
					end
				end)
				fake.Handle.TouchEnded:Connect(function(t)
					local h = v:FindFirstChild("Handle")
					if h and t and h:IsDescendantOf(workspace) and t:IsDescendantOf(workspace) then
						h.CanTouch = true
						pcall(firetouchinterest, h, t, 1)
					end
				end)
			end
		end
	end
	local lastspawn = 0
	local CharConn = Player.CharacterAdded:Connect(function(character)
		local camcfr = Camera.CFrame
		RunService.PreRender:Once(function()
			RunService.PreAnimation:Wait()
			Camera.CFrame = camcfr
		end)
		lastspawn = os.clock()
		table.clear(BaseParts)
		table.clear(UnknownMotor6Ds)
		for _,map in LimbMapping do
			map.Reference = nil
		end
		character.DescendantAdded:Connect(CharOnDesc)
		for _,v in character:GetDescendants() do
			task.spawn(CharOnDesc, v)
		end
		local humanoid = character:WaitForChild("Humanoid", 5)
		local stupid = humanoid:FindFirstChildWhichIsA("Animator")
		if stupid then
			stupid:Destroy()
		end
		if not Reanimate.UseLoadAnimationHook then
			stupid = character:FindFirstChild("Animate")
			while not stupid do
				character.ChildAdded:Wait()
				stupid = character:FindFirstChild("Animate")
			end
			stupid:Destroy()
		end
	end)
	Player.CharacterAdded:Wait()
	Reanimate.CreateCharacter(InitCFrame)

	local lastrep = 0
	Reanimate.Starting = false
	while not Reanimate.Stopping do
		RunService.PreSimulation:Wait()
		workspace.FallenPartsDestroyHeight = 0/0
		local ReanimOkay = false
		local Character, Humanoid, RootPart = Player.Character, nil, nil
		if Character then
			Humanoid = Character:FindFirstChildOfClass("Humanoid")
			if Humanoid then
				Humanoid.AutoRotate = false
				if Humanoid.WalkSpeed < 1 then
					Humanoid.WalkSpeed = 16
				end
				if Humanoid.JumpPower < 1 then
					Humanoid.JumpPower = 50
				end
				RootPart = Humanoid.RootPart
				if RootPart and Humanoid:GetState() ~= Enum.HumanoidStateType.Dead then
					Humanoid:ChangeState(Enum.HumanoidStateType.Freefall)
					ReanimOkay = true
				end
			end
		end
		local rootcf = CFrame.new(rootposition)
		local rootvel = Vector3.zero
		local ltm = Reanimate.LocalTransparencyModifier
		local ReanimCharacter = Reanimate.Character
		if ReanimCharacter then
			local RCHumanoid = ReanimCharacter:FindFirstChildOfClass("Humanoid")
			local RCRootPart = ReanimCharacter:FindFirstChild("HumanoidRootPart")
			local RCTorso = ReanimCharacter:FindFirstChild("Torso")
			if RCRootPart and RCTorso then
				if LimbReanimator.Mode == 1 or workspace.StreamingEnabled then
					rootcf = CFrame.new(RCRootPart.Position + Vector3.new(0, -16, 0))
				end
				if LimbReanimator.Mode == 2 then
					rootcf = RCRootPart.CFrame
				end
				if LimbReanimator.Mode == 3 then
					rootcf = RCTorso.CFrame
				end
				if LimbReanimator.Velocity == 1 then
					rootvel = RCRootPart.Velocity
				elseif LimbReanimator.Velocity == 2 then
					rootvel = Vector3.new(0, 16384, 0)
				end
				if Camera then
					Camera.CameraSubject = RCHumanoid
				end
			end
			for _,v in BaseParts do
				v.CanCollide = false
				v.Velocity = Vector3.zero
				v.RotVelocity = Vector3.zero
				if not v:FindFirstAncestorWhichIsA("Tool") then
					v.LocalTransparencyModifier = ltm
				end
			end
			for _,v in ReanimCharacter:GetChildren() do
				if v:IsA("BasePart") then
					if table.find(LimbNames, v.Name) then
						v.Transparency = ReanimOkay and 1 or 0.5
					end
				end
			end
			if Character and Humanoid and RootPart then
				RunService.Heartbeat:Wait()
				if Reanimate:ShouldRotationType() then
					local ax, ay, az = Camera.CFrame:ToEulerAngles(Enum.RotationOrder.YXZ)
					local bx, by, bz = RCRootPart.CFrame:ToEulerAngles(Enum.RotationOrder.YXZ)
					local tcf = CFrame.fromEulerAngles(bx, ay, bz, Enum.RotationOrder.YXZ)
					RCRootPart.CFrame = tcf + RCRootPart.CFrame.Position
				end
				local t = os.clock()
				local flingtarget = LimbReanimator.FlingTargets[1]
				if flingtarget then
					if flingtarget.Time then
						if t > flingtarget.Time then
							table.remove(LimbReanimator.FlingTargets, 1)
							flingtarget = nil
						end
					else
						flingtarget.Time = t + (flingtarget.Duration or (Reanimate.UsePhysicsRepRootPart and (LimbReanimator.UseNaNFling and 1 or 0.5) or 2))
					end
				end
				local flingcf, flinged = CFrame.identity, true
				if flingtarget then
					flingcf, flinged = Util.PredictionFling(flingtarget.Target)
					if flinged then
						table.remove(LimbReanimator.FlingTargets, 1)
						flingtarget = nil
					end
				end
				if not RootPart:IsGrounded() then
					if flingtarget then
						if LimbReanimator.UseNaNFling then
							RootPart.CFrame = CFrame.new(flingcf.Position + Vector3.new(0, 0, math.random(0, 1) * 0.005)) * CFrame.Angles(0, os.clock() * 15, 0)
							RootPart.Velocity, RootPart.RotVelocity = Vector3.zero, Vector3.zero
						else
							RootPart.CFrame = flingcf + Vector3.new(0, 0, math.random(0, 1) * 0.005)
							RootPart.Velocity, RootPart.RotVelocity = Vector3.new(0, -16384, 0), Vector3.one * 16384
						end
						pcall(sethiddenproperty, RootPart, "PhysicsRepRootPart", Reanimate.UsePhysicsRepRootPart and Util.PredictionFlingPart(flingtarget.Target) or nil)
					else
						RootPart.CFrame = rootcf + Vector3.new(0, 0, math.random(0, 1) * 0.005)
						RootPart.Velocity, RootPart.RotVelocity = rootvel, Vector3.zero
						pcall(sethiddenproperty, RootPart, "PhysicsRepRootPart", nil)
					end
				end
				local dorep = true
				if LimbReanimator.ReplicateFPS10 then
					dorep = false
					local b = os.clock()
					local a = b - lastrep
					if a >= 1 / 10 then
						dorep = true
						a %= 1 / 10
						lastrep = b - a
					end
				end
				for _,v in UnknownMotor6Ds do
					Util.SetMotor6DTransform(v, CFrame.identity)
				end
				for _,map in LimbMapping do
					local v = map.Reference
					if v then
						if flingtarget then
							Util.SetMotor6DTransform(v, CFrame.identity)
						else
							local cf = CFrame.identity
							local p0, p1 = ReanimCharacter:FindFirstChild(map.RPart0), ReanimCharacter:FindFirstChild(map.RPart1)
							if map.RPart0 == "ROOT" then
								p0 = RootPart
							end
							if p0 and p1 then
								if map.Type == 1 then
									cf = p0.CFrame:ToObjectSpace(p1.CFrame)
								end
								if map.Type == 2 then
									local transform = map.C0:Inverse() * p0.CFrame:ToObjectSpace(p1.CFrame) * map.C1
									transform = map.Offset * transform.Rotation * map.Offset:Inverse() + transform.Position
									cf = CFrame.new(v.C0.Position) * transform * CFrame.new(-v.C1.Position)
								end
							end
							if dorep or not map.CFrame then
								map.CFrame = cf
							end
							Util.SetMotor6DOffset(v, map.CFrame)
						end
					end
				end
				if LimbReanimator.UseNaNFling then
					if os.clock() - lastspawn > 0.1 then
						pcall(sethiddenproperty, Humanoid, "MoveDirectionInternal", Vector3.new(0/0, 0/0, 0/0))
					else
						pcall(sethiddenproperty, Humanoid, "MoveDirectionInternal", Vector3.zero)
					end
					pcall(sethiddenproperty, Humanoid, "NetworkHumanoidState", Enum.HumanoidStateType.Freefall)
				else
					pcall(sethiddenproperty, Humanoid, "NetworkHumanoidState", Enum.HumanoidStateType[({"Running", "PlatformStanding", "Jumping", "Ragdoll", "Seated", "Physics"})[math.random(1, 6)]])
				end
				if Reanimate:ShouldRotationType() then
					RunService.PreRender:Wait()
					local ocf = RCRootPart.CFrame
					local ax, ay, az = Camera.CFrame:ToEulerAngles(Enum.RotationOrder.YXZ)
					local bx, by, bz = ocf:ToEulerAngles(Enum.RotationOrder.YXZ)
					local tcf = CFrame.fromEulerAngles(bx, ay, bz, Enum.RotationOrder.YXZ) + ocf.Position
					RootPart.CFrame = tcf:ToWorldSpace(ocf:ToObjectSpace(RootPart.CFrame))
					RCRootPart.CFrame = tcf
				end
			end
		end
	end
	CharConn:Disconnect()
	if Player.Character then
		local h = Player.Character:FindFirstChild("Humanoid")
		if h then
			if replicatesignal then
				replicatesignal(Player.ConnectDiedSignalBackend)
			end
			h:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
			h:ChangeState(Enum.HumanoidStateType.Dead)
		end
	end
	Reanimate.Stopping = false
	Reanimate.DestroyCharacter()
end

local HatReanimator = {}
HatReanimator.Name = "Hats"
SaveData.Reanimator.HatsCollide = not not SaveData.Reanimator.HatsCollide
SaveData.Reanimator.HatsCollideMethod = SaveData.Reanimator.HatsCollideMethod or 6
SaveData.Reanimator.IWantAllHats = not not SaveData.Reanimator.IWantAllHats
SaveData.Reanimator.IWantHatCollide = SaveData.Reanimator.IWantHatCollide or 3
SaveData.Reanimator.HatsPatchmahub = not not SaveData.Reanimator.HatsPatchmahub
SaveData.Reanimator.HatsFling = not not SaveData.Reanimator.HatsFling
SaveData.Reanimator.HatsSpin = not not SaveData.Reanimator.HatsSpin
SaveData.Reanimator.HatsFlingMethod = SaveData.Reanimator.HatsFlingMethod or 1
SaveData.Reanimator.HatsToolAnim = SaveData.Reanimator.HatsToolAnim or 0
HatReanimator.HatCollide = SaveData.Reanimator.HatsCollide
HatReanimator.HatCollideMethod = SaveData.Reanimator.HatsCollideMethod
-- 0 - shownape's method
-- 1 - my method
-- 2 - 1 but for back accessories
-- 3 - 1 but for shoulder accessories
-- 4 - pray that it works for all ur accessories lol
-- 5 - least amount of chance to hat drop
-- 6 - experimental
-- 7 - idk honestly but this is just modified heavily for now
HatReanimator.IWantAllHats = SaveData.Reanimator.IWantAllHats
HatReanimator.IWantHatCollide = SaveData.Reanimator.IWantHatCollide
HatReanimator.Permadeath = false--not SaveData.Reanimator.HatsPatchmahub
HatReanimator.HatFling = SaveData.Reanimator.HatsFling
HatReanimator.HatSpin = SaveData.Reanimator.HatsSpin
HatReanimator.FlingMethod = SaveData.Reanimator.HatsFlingMethod
-- -1 - disabled
-- 0 - respawn and fling
-- 1 - use biggest collidable hat
-- 2 - use all hats
-- 3 - tool fling
HatReanimator.ToolAnimMethod = SaveData.Reanimator.HatsToolAnim
-- 0 - nothing
-- 1 - sword
HatReanimator.UseNaNFling = true
HatReanimator.HasPermadeath = false
HatReanimator.HasHatCollide = false
HatReanimator.RebuildRequired = true
HatReanimator.HatMapSummary = "(no hat map yet, please * Reanimate * to build)"
HatReanimator.HatCFrameOverride = {}
HatReanimator.Status = {
	Permadeath = "(no status)",
	HatCollide = "(no status)",
	RespawnFling = "(no status)",
}
function HatReanimator.ShowHitboxes()
	if Player.Character then
		for _,v in Player.Character:GetChildren() do
			if v:IsA("Accessory") then
				local handle = v:FindFirstChild("Handle")
				if handle and handle:IsA("BasePart") then
					if handle:GetAttribute("_Uhhhhhh_HasCollide") then
						Util.ShowPartHitbox(handle)
					end
				end
			end
		end
	end
end
HatReanimator.FlingTargets = {}
HatReanimator._TempNotFling = {}
function HatReanimator.Fling(target, duration)
	if HatReanimator.FlingMethod == -1 then return end
	if not target then return false end
	for _,v in HatReanimator.FlingTargets do
		if v.Target == target then
			return false
		end
	end
	if target == Reanimate.Character then return false end
	if target == Player.Character then return false end
	if typeof(target) == "Instance" then
		if HatReanimator._TempNotFling[target] then return end
		HatReanimator._TempNotFling[target] = true
		task.delay(1, function()
			HatReanimator._TempNotFling[target] = nil
		end)
	end
	table.insert(HatReanimator.FlingTargets, {
		Target = target,
		Duration = duration
	})
	if typeof(target) == "Instance" then
		if target:IsA("Model") then
			local h = Util.Instance("Highlight")
			h.Adornee = target
			h.FillColor = Color3.new(1, 0, 0)
			h.OutlineColor = Color3.new(1, 0, 0)
			h.FillTransparency = 0.5
			h.OutlineTransparency = 0
			h.Parent = target
			TweenService:Create(h, TweenInfo.new(5), {
				FillTransparency = 1,
				OutlineTransparency = 1
			}):Play()
			game.Debris:AddItem(h, 5)
		end
	end
	return true
end
HatReanimator.DontFireCharAddOnThisChar = nil
function HatReanimator.Config(parent)
	UI.CreateText(parent, "permadeath is patched, this switch is ignored", 10, Enum.TextXAlignment.Center)
	UI.CreateSwitch(parent, "Permadeath", HatReanimator.Permadeath).Changed:Connect(function(val)
		--HatReanimator.Permadeath = val
		--SaveData.Reanimator.HatsPatchmahub = not val
	end)
	UI.CreateSwitch(parent, "Hat Collide", HatReanimator.HatCollide).Changed:Connect(function(val)
		HatReanimator.HatCollide = val
		SaveData.Reanimator.HatsCollide = val
	end)
	UI.CreateText(parent, "if ur hats get voided when u try to hat collide\nvvv try changing this vvv", 10, Enum.TextXAlignment.Center)
	UI.CreateDropdown(parent, "Torso Offset", {
		"1 - ShownApe's method (???)",
		"2 - STEVE's method V1 (specific)",
		"3 - 2 but for back accessories",
		"4 - 2 but for shoulder accessories",
		"5 - 2 but for waist accessories",
		"6 - STEVE's method V2 (kinda stable)",
		"7 - 6 but further from void (gl getting hatdrop)",
		"8 - STEVE's method V3 (most stable)",
		"9 - experimental do not use",
	}, HatReanimator.HatCollideMethod + 1).Changed:Connect(function(val)
		HatReanimator.HatCollideMethod = val - 1
		SaveData.Reanimator.HatsCollideMethod = val - 1
	end)
	UI.CreateSwitch(parent, "Ensure All Hats", HatReanimator.IWantAllHats).Changed:Connect(function(val)
		HatReanimator.IWantAllHats = val
		SaveData.Reanimator.IWantAllHats = val
	end)
	UI.CreateDropdown(parent, "Ensure Hat Collide", {
		"Off",
		"Atleast one",
		"Atleast #hats - 2",
		"Atleast #hats - 1",
		"ALL",
	}, HatReanimator.IWantHatCollide + 1).Changed:Connect(function(val)
		HatReanimator.IWantHatCollide = val - 1
		SaveData.Reanimator.IWantHatCollide = val - 1
	end)
	UI.CreateText(parent, "vvv dont use these two options with target fling... vvv", 10, Enum.TextXAlignment.Center)
	UI.CreateSwitch(parent, "Hat Fling", HatReanimator.HatFling).Changed:Connect(function(val)
		HatReanimator.HatFling = val
		SaveData.Reanimator.HatsFling = val
	end)
	UI.CreateText(parent, "^^^ ...unless you want to walkfling or... ^^^", 10, Enum.TextXAlignment.Center)
	UI.CreateSwitch(parent, "Hat Spin Fling", HatReanimator.HatSpin).Changed:Connect(function(val)
		HatReanimator.HatSpin = val
		SaveData.Reanimator.HatsSpin = val
	end)
	UI.CreateText(parent, "^^^ ...unless you want to look glitchy ^^^", 10, Enum.TextXAlignment.Center)
	UI.CreateText(parent, "vvv dont use tool fling with physics glue btw vvv", 10, Enum.TextXAlignment.Center)
	UI.CreateDropdown(parent, "Target Fling Method", {
		"Disabled (RP)",
		"Classic Respawn",
		"Biggest Hat",
		"All Hats",
		"Use Tool Handle",
	}, HatReanimator.FlingMethod + 2).Changed:Connect(function(val)
		HatReanimator.FlingMethod = val - 2
		SaveData.Reanimator.HatsFlingMethod = val - 2
	end)
	UI.CreateDropdown(parent, "toolanim Method", {
		"Disabled",
		"Sword",
	}, HatReanimator.ToolAnimMethod + 1).Changed:Connect(function(val)
		HatReanimator.ToolAnimMethod = val - 1
		SaveData.Reanimator.HatsToolAnim = val - 1
	end)
	UI.CreateSeparator(parent)
	local HatMapSummaryText = UI.CreateText(parent, HatReanimator.HatMapSummary, 12, Enum.TextXAlignment.Left)
	local HatReanimStatusText = UI.CreateText(parent, "", 12, Enum.TextXAlignment.Left)
	Util.LinkDestroyI2C(HatMapSummaryText, RunService.RenderStepped:Connect(function()
		HatMapSummaryText.Text = HatReanimator.HatMapSummary
		local str = ""
		for name, stat in HatReanimator.Status do
			str ..= name .. ": " .. stat .. "\n"
		end
		HatReanimStatusText.Text = str:sub(1, -2)
	end))
	UI.CreateButton(parent, "Rebuild Hat Map", 20).Activated:Connect(function()
		HatReanimator.RebuildRequired = true
	end)
	UI.CreateText(parent, "^^^ if ur rig built wrong or u switched to a new rig ^^^\nthis button is for you", 10, Enum.TextXAlignment.Center)
	UI.CreateButton(parent, "Respawn", 20).Activated:Connect(function()
		HatReanimator.Status.Permadeath = "Fired CDSB Signal!"
		replicatesignal(Player.ConnectDiedSignalBackend)
		if RejectCharacterDeletionsDisabled then
			HatReanimator.Status.Permadeath = "RCDless mode, did old technique!"
			local old = Player.Character
			for _,v in old:GetChildren() do
				if v:IsA("Accoutrement") then continue end
				v:Destroy()
			end
			local new = Util.Instance("Model", workspace)
			HatReanimator.DontFireCharAddOnThisChar = new
			Player.Character = new
			task.wait()
			HatReanimator.DontFireCharAddOnThisChar = old
			Player.Character = old
		end
	end)
end
HatReanimator.GetHatMap = function() end
HatReanimator.GetHatCFrameMeshAndTexture = function() end
HatReanimator.GetAttachmentCFrame = function() end
function HatReanimator.Start()
	local LimbNames = {"Head", "Torso", "Left Arm", "Right Arm", "Left Leg", "Right Leg"}

	local Attachments = {
		RightShoulderAttachment = {"Right Arm", CFrame.new(0, 1, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)},
		RightGripAttachment = {"Right Arm", CFrame.new(0, -1, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)},
		LeftFootAttachment = {"Left Leg", CFrame.new(0, -1, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)},
		LeftShoulderAttachment = {"Left Arm", CFrame.new(0, 1, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)},
		LeftGripAttachment = {"Left Arm", CFrame.new(0, -1, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)},
		RootAttachment = {"HumanoidRootPart", CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)},
		RightFootAttachment = {"Right Leg", CFrame.new(0, -1, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)},
		NeckAttachment = {"Torso", CFrame.new(0, 1, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)},
		BodyFrontAttachment = {"Torso", CFrame.new(0, 0, -0.5, 1, 0, 0, 0, 1, 0, 0, 0, 1)},
		BodyBackAttachment = {"Torso", CFrame.new(0, 0, 0.5, 1, 0, 0, 0, 1, 0, 0, 0, 1)},
		LeftCollarAttachment = {"Torso", CFrame.new(-1, 1, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)},
		RightCollarAttachment = {"Torso", CFrame.new(1, 1, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)},
		WaistFrontAttachment = {"Torso", CFrame.new(0, -1, -0.5, 1, 0, 0, 0, 1, 0, 0, 0, 1)},
		WaistCenterAttachment = {"Torso", CFrame.new(0, -1, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)},
		WaistBackAttachment = {"Torso", CFrame.new(0, -1, 0.5, 1, 0, 0, 0, 1, 0, 0, 0, 1)},
		HairAttachment = {"Head", CFrame.new(0, 0.6, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)},
		HatAttachment = {"Head", CFrame.new(0, 0.6, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)},
		FaceFrontAttachment = {"Head", CFrame.new(0, 0, -0.6, 1, 0, 0, 0, 1, 0, 0, 0, 1)},
		FaceCenterAttachment = {"Head", CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)},
	}

	local HatMeshDatabase, HatNameDatabase, HatKnownAccessoriesDatabase = loadstring(readfile("UhhhhhhReanim/BuiltinModules/d_hatsmap.lua"))()

	local function GetTools()
		local tools = {}
		local character, backpack = Player.Character, Player:FindFirstChildOfClass("Backpack")
		if character then
			for _,v in character:GetChildren() do
				if v:IsA("Tool") then
					table.insert(tools, v)
				end
			end
		end
		if backpack then
			for _,v in backpack:GetChildren() do
				if v:IsA("Tool") then
					table.insert(tools, v)
				end
			end
		end
		return tools
	end
	local function GetHatMeshAndTexture(hat)
		local handle = hat:FindFirstChild("Handle")
		if handle then
			local mesh, tex = nil, nil
			if handle:IsA("MeshPart") then
				return handle.MeshId, handle.TextureID
			elseif handle:IsA("BasePart") then
				local sm = handle:FindFirstChildOfClass("SpecialMesh")
				if sm then
					return sm.MeshId, sm.TextureId
				end
			end
		end
		return nil, nil
	end
	local function AssetIdMatch(a, b)
		a = a or ""
		b = b or ""
		if #b == 0 then return true end
		if #a == 0 then return false end
		if a:sub(1, 11) == "rbxasset://" then
			a = a:match("rbxasset://(.+)")
		elseif a:sub(1, 13) == "rbxassetid://" then
			a = a:match("rbxassetid://(%d+)")
		elseif a:sub(1, 4) == "http" then
			a = a:match("id=(%d+)")
		end
		return a == b
	end
	local function ClassifyHat(hat)
		local handle = hat:FindFirstChild("Handle")
		local mesh, tex = GetHatMeshAndTexture(hat)
		if handle and handle:IsA("BasePart") and mesh and tex then
			local mapdata = {
				Name = hat.Name,
				MeshId = mesh, TextureId = tex,
				C0 = CFrame.identity,
				C1 = CFrame.identity,
				Scale = 1,
				Limb = "HumanoidRootPart",
				Group = "RIG",
				Attachments = nil,
			}
			local originalsize = handle:FindFirstChild("OriginalSize")
			if originalsize and originalsize:IsA("Vector3Value") then
				originalsize = originalsize.Value
				local m1 = math.max(handle.Size.X, handle.Size.Y, handle.Size.Z)
				local m2 = math.max(originalsize.X, originalsize.Y, originalsize.Z)
				if m2 > 0 then
					mapdata.Scale = m1 / m2
				end
			end
			-- dont map explicitly overriden hats
			for _,data in HatReanimator.HatCFrameOverride do
				if data.MeshId and data.TextureId then
					if AssetIdMatch(mesh, data.MeshId) and AssetIdMatch(tex, data.TextureId) then
						return mapdata, "Unknown", 4
					end
				end
			end
			for _,data in HatKnownAccessoriesDatabase do
				if AssetIdMatch(mesh, data.MeshId) and AssetIdMatch(tex, data.TextureId) then
					mapdata.C0 = data.C0
					mapdata.C1 = data.C1
					mapdata.Limb = data.Limb
					mapdata.Group = data.Group
					mapdata.Attachments = data.Attachments
					return mapdata, "Accessories", 0
				end
			end
			for _,data in HatNameDatabase do
				if hat.Name:lower() == data.Match:lower() then
					mapdata.C1 = data.Offset
					return mapdata, data.For, 1
				end
			end
			for _,data in HatMeshDatabase do
				if AssetIdMatch(mesh, data.MeshId) and AssetIdMatch(tex, data.TextureId) then
					mapdata.C1 = data.Offset
					return mapdata, data.For, 2
				end
			end
			local assumption = handle.Size
			local originalsize = handle:FindFirstChild("OriginalSize")
			if originalsize and originalsize:IsA("Vector3Value") then
				assumption = originalsize.Value
			end
			local m = math.min(assumption.X, assumption.Y, assumption.Z)
			if m >= 0.25 then
				assumption = Vector3.new(
					math.round(assumption.X / m),
					math.round(assumption.Y / m),
					math.round(assumption.Z / m)
				)
			else
				assumption = Vector3.zero
			end
			if assumption == Vector3.new(2, 2, 1) then
				mapdata.C1 = CFrame.identity
				return mapdata, "Torso", 3
			elseif assumption == Vector3.new(2, 1, 2) then
				mapdata.C1 = CFrame.Angles(1.57, 0, 0)
				return mapdata, "Torso", 3
			elseif assumption == Vector3.new(1, 2, 2) then
				mapdata.C1 = CFrame.Angles(0, 1.57, 0)
				return mapdata, "Torso", 3
			elseif assumption == Vector3.new(1, 2, 1) then
				mapdata.C1 = CFrame.identity
				return mapdata, "ArmLeg", 3
			elseif assumption == Vector3.new(1, 1, 2) then
				mapdata.C1 = CFrame.Angles(1.57, 0, 0)
				return mapdata, "ArmLeg", 3
			elseif assumption == Vector3.new(2, 1, 1) then
				mapdata.C1 = CFrame.Angles(0, 0, 1.57)
				return mapdata, "ArmLeg", 3
			elseif handle:FindFirstChild("HatAttachment") and assumption == Vector3.new(1, 1, 1) and m < 1.2 then
				mapdata.C1 = CFrame.Angles(1.57, 0, 0)
				return mapdata, "Block", 3
			end
			return mapdata, "Unknown", 4
		end
		return nil
	end

	local BaseParts = {}
	local CharTools = {}
	local CharHats = {}

	local HatRefs = {}
	local Hat2HatRefs = {}
	local function ResetHatRefs()
		table.clear(Hat2HatRefs)
		for _,ref in HatRefs do
			ref.Hat = nil
		end
	end
	local function CreatePlaceholder(hat)
		local h = hat:FindFirstChild("Handle")
		local m = h and h:FindFirstChildOfClass("SpecialMesh")
		if h then
			local p = Instance.new("Part")
			p.Anchored = true
			p.CanCollide = false
			p.CanTouch = false
			p.CanQuery = false
			p.Transparency = 0.75
			p.Size = h.Size
			p.CFrame = h.CFrame
			p.Color = h.Color
			p.Name = "(C) Uhhhhhh V" .. UhhhhhhVersion .. " :: HAT PLACEHOLDER"
			local n = m:Clone()
			n:ClearAllChildren()
			n.Parent = p
			p.Parent = workspace
			return p
		end
	end
	local function RefHatToHatRefs(hat)
		local mesh, tex = GetHatMeshAndTexture(hat)
		if mesh and tex then
			for _,ref in HatRefs do
				if not ref.Hat then
					if ref.Name == hat.Name and ref.MeshId == mesh and ref.TextureId == tex then
						ref.Hat = hat
						Hat2HatRefs[hat] = ref
						if not ref.PH then
							ref.PH = CreatePlaceholder(hat)
						end
					end
				end
			end
		end
	end

	local HatMap = {}
	local HatMapCopy = {}
	local function RefreshHatMap(Character)
		local summary = ""
		summary ..= "[Hat Map Summary]\n"
		summary ..= "Total hats found: " .. #CharHats .. "\n"
		local hatfors = {
			Head = {},
			Torso = {},
			LeftArm = {},
			RightArm = {},
			LeftLeg = {},
			RightLeg = {},
			ArmLeg = {},
			Block = {},
			Accessories = {},
			Unknown = {},
		}
		for _,hat in CharHats do
			local mapdata, usefor, level = ClassifyHat(hat)
			if mapdata and hatfors[usefor] then
				table.insert(hatfors[usefor], {hat, mapdata, level})
			end
		end
		summary ..= "Classified "
		for name,arr in hatfors do
			table.sort(arr, function(a, b)
				return a[3] < b[3]
			end)
			summary ..= #arr .. " " .. name .. ", "
		end
		summary = summary:sub(1, -3) .. ".\n"
		summary ..= "Rig Building:\n"
		local hatrig = {
			Head = nil,
			Torso = nil,
			LeftArm = nil,
			RightArm = nil,
			LeftLeg = nil,
			RightLeg = nil,
		}
		if #hatfors.Head > 0 then
			summary ..= "  1 Head as Head (perfect match)\n"
			hatrig.Head = table.remove(hatfors.Head, 1)
		end
		if #hatfors.Torso > 0 then
			summary ..= "  1 Torso as Torso (perfect match)\n"
			hatrig.Torso = table.remove(hatfors.Torso, 1)
		end
		if #hatfors.LeftArm > 0 then
			summary ..= "  1 LeftArm as LeftArm (perfect match)\n"
			hatrig.LeftArm = table.remove(hatfors.LeftArm, 1)
		end
		if #hatfors.RightArm > 0 then
			summary ..= "  1 RightArm as RightArm (perfect match)\n"
			hatrig.RightArm = table.remove(hatfors.RightArm, 1)
		end
		if #hatfors.LeftLeg > 0 then
			summary ..= "  1 LeftLeg as LeftLeg (perfect match)\n"
			hatrig.LeftLeg = table.remove(hatfors.LeftLeg, 1)
		end
		if #hatfors.RightLeg > 0 then
			summary ..= "  1 RightLeg as RightLeg (perfect match)\n"
			hatrig.RightLeg = table.remove(hatfors.RightLeg, 1)
		end
		local limbstobuild = {}
		if not hatrig.LeftArm then
			if #hatfors.RightArm > 0 then
				hatrig.LeftArm = table.remove(hatfors.RightArm, 1)
				summary ..= "  1 RightArm as LeftArm (hat reused)\n"
			elseif #hatfors.LeftLeg > 0 then
				hatrig.LeftArm = table.remove(hatfors.LeftLeg, 1)
				summary ..= "  1 LeftLeg as LeftArm (hat reused)\n"
			elseif #hatfors.RightLeg > 0 then
				hatrig.LeftArm = table.remove(hatfors.RightLeg, 1)
				summary ..= "  1 RightLeg as LeftArm (hat reused)\n"
			elseif #hatfors.ArmLeg > 0 then
				hatrig.LeftArm = table.remove(hatfors.ArmLeg, 1)
				summary ..= "  1 ArmLeg as LeftArm (purpose match)\n"
			else
				table.insert(limbstobuild, "Left Arm")
			end
		end
		if not hatrig.RightArm then
			if #hatfors.LeftArm > 0 then
				hatrig.RightArm = table.remove(hatfors.LeftArm, 1)
				summary ..= "  1 LeftArm as RightArm (hat reused)\n"
			elseif #hatfors.RightLeg > 0 then
				hatrig.RightArm = table.remove(hatfors.RightLeg, 1)
				summary ..= "  1 RightLeg as RightArm (hat reused)\n"
			elseif #hatfors.LeftLeg > 0 then
				hatrig.RightArm = table.remove(hatfors.LeftLeg, 1)
				summary ..= "  1 LeftLeg as RightArm (hat reused)\n"
			elseif #hatfors.ArmLeg > 0 then
				hatrig.RightArm = table.remove(hatfors.ArmLeg, 1)
				summary ..= "  1 ArmLeg as RightArm (purpose match)\n"
			else
				table.insert(limbstobuild, "Right Arm")
			end
		end
		if not hatrig.LeftLeg then
			if #hatfors.RightLeg > 0 then
				hatrig.LeftLeg = table.remove(hatfors.RightLeg, 1)
				summary ..= "  1 RightLeg as LeftLeg (hat reused)\n"
			elseif #hatfors.LeftArm > 0 then
				hatrig.LeftLeg = table.remove(hatfors.LeftArm, 1)
				summary ..= "  1 LeftArm as LeftLeg (hat reused)\n"
			elseif #hatfors.RightArm > 0 then
				hatrig.LeftLeg = table.remove(hatfors.RightArm, 1)
				summary ..= "  1 LeftLeg as LeftLeg (hat reused)\n"
			elseif #hatfors.ArmLeg > 0 then
				hatrig.LeftLeg = table.remove(hatfors.ArmLeg, 1)
				summary ..= "  1 ArmLeg as LeftLeg (purpose match)\n"
			else
				table.insert(limbstobuild, "Left Leg")
			end
		end
		if not hatrig.RightLeg then
			if #hatfors.LeftLeg > 0 then
				hatrig.RightLeg = table.remove(hatfors.LeftLeg, 1)
				summary ..= "  1 LeftLeg as RightLeg (hat reused)\n"
			elseif #hatfors.RightArm > 0 then
				hatrig.RightLeg = table.remove(hatfors.RightArm, 1)
				summary ..= "  1 RightArm as RightLeg (hat reused)\n"
			elseif #hatfors.LeftArm > 0 then
				hatrig.RightLeg = table.remove(hatfors.LeftArm, 1)
				summary ..= "  1 LeftArm as RightLeg (hat reused)\n"
			elseif #hatfors.ArmLeg > 0 then
				hatrig.RightLeg = table.remove(hatfors.ArmLeg, 1)
				summary ..= "  1 ArmLeg as RightLeg (purpose match)\n"
			else
				table.insert(limbstobuild, "Right Leg")
			end
		end
		for _,v in HatRefs do if v.PH then v.PH:Destroy() end end
		table.clear(Hat2HatRefs)
		table.clear(HatRefs)
		HatMap = {}
		local function addhat(limb, data)
			if data and data[2] then
				data = data[2]
				if limb then
					data.Limb = limb
				end
				local index = #HatMap
				data.Index = index
				table.insert(HatMap, data)
				table.insert(HatRefs, {
					Name = data.Name,
					MeshId = data.MeshId, TextureId = data.TextureId,
					Map = data,
					Index = index,
					PH = nil,
					Hat = nil,
				})
			end
		end
		addhat("Head", hatrig.Head)
		addhat("Torso", hatrig.Torso)
		addhat("Left Arm", hatrig.LeftArm)
		addhat("Right Arm", hatrig.RightArm)
		addhat("Left Leg", hatrig.LeftLeg)
		addhat("Right Leg", hatrig.RightLeg)
		if #limbstobuild > 0 and #hatfors.Block > 0 then
			local blocks = {}
			local i = 0
			while i < #limbstobuild * 2 and #hatfors.Block > 0 do
				local name = limbstobuild[(i % #limbstobuild) + 1]
				if not blocks[name] then
					blocks[name] = {}
				end
				table.insert(blocks[name], table.remove(hatfors.Block, 1))
				i += 1
			end
			for name,v in blocks do
				if #v == 2 then
					local a, b = v[1], v[2]
					a[2].C0 = CFrame.new(0, -0.5, 0)
					b[2].C0 = CFrame.new(0, 0.5, 0)
					addhat(name, a)
					addhat(name, b)
					summary ..= "  2 Block as " .. name:gsub(" ", "") .. " (block build)\n"
				elseif #v == 1 then
					addhat(name, v[1])
					summary ..= "  1 Block as " .. name:gsub(" ", "") .. " (block build)\n"
				end
			end
		end
		summary ..= "  " .. #hatfors.Accessories .. " known accessories\n"
		for _,acc in hatfors.Accessories do
			addhat(nil, acc)
		end
		table.clear(hatfors.Accessories)
		local unused = 0
		for _,v in hatfors do
			for _,w in v do
				local hat = w[1]
				local map = w[2]
				local limb, c0, c1 = "Head", Attachments.HatAttachment[2], hat.AttachmentPoint
				local handle = hat:FindFirstChild("Handle")
				if handle then
					for _,x in handle:GetChildren() do
						if x:IsA("Attachment") then
							local att = Attachments[x.Name]
							if att then
								limb, c0, c1 = att[1], att[2], x.CFrame
							end
						end
					end
				end
				map.C0 = c0
				map.C1 = c1
				map.Limb = limb
				addhat(limb, w)
				unused += 1
			end
		end
		summary ..= "...which leaves " .. unused .. " unused."
		HatMap.Built = os.clock()
		HatMapCopy = Util.DeepcopyTable(HatMap)
		for _,v in CharHats do
			RefHatToHatRefs(v)
		end
		HatReanimator.HatMapSummary = summary
		HatReanimator.RebuildRequired = false
	end
	local function GetHatMappedOverride(hatmapped)
		local ReanimCharacter = Reanimate.Character
		if not ReanimCharacter then return end
		local scale = ReanimCharacter:GetScale()
		local hatscale = hatmapped.Scale
		-- cframe override
		for _,data in HatReanimator.HatCFrameOverride do
			if not data.Disable then
				-- accessory group
				if data.Group and hatmapped.Group == data.Group then
					if data.Limb then
						return {
							C0 = data.C0 or data.Offset or CFrame.identity,
							C1 = hatmapped.C1 * (data.C1 or CFrame.identity),
							Limb = data.Limb, RepRootPart = data.RepRootPart,
							Scale = hatscale,
						}
					else
						return {
							C0 = data.C0 or data.CFrame or CFrame.identity,
							C1 = hatmapped.C1 * (data.C1 or CFrame.identity),
							RepRootPart = data.RepRootPart,
							Scale = hatscale,
						}
					end
				end
				-- exact asset id
				if data.MeshId and data.TextureId then
					if AssetIdMatch(mesh, data.MeshId) and AssetIdMatch(tex, data.TextureId) then
						return {
							C0 = data.C0, C1 = data.C1,
							Offset = data.Offset or data.CFrame,
							Limb = data.Limb, RepRootPart = data.RepRootPart,
							Scale = hatscale,
						}
					end
				end
				if data.Index and hatmapped.Index == data.Index then
					return {
						C0 = data.C0 or data.CFrame or CFrame.identity,
						C1 = hatmapped.C1 * (data.C1 or CFrame.identity),
						RepRootPart = data.RepRootPart,
						Scale = hatscale,
					}
				end
			end
		end
		return hatmapped
	end
	local function GetHatMappedMeshAndTexture(mesh, tex, name)
		local ReanimCharacter = Reanimate.Character
		if not ReanimCharacter then return end
		local hatmapped = nil
		-- find hat mapping
		for _,data in ipairs(HatMap) do
			if (name and data.Name == name or not name) and data.MeshId == mesh and data.TextureId == tex then
				hatmapped = data
				break
			end
		end
		if not hatmapped then return end
		return GetHatMappedOverride(hatmapped)
	end
	local function GetHatMappedCFrame(hatmapped)
		local ReanimCharacter = Reanimate.Character
		if not ReanimCharacter then return end
		local scale = ReanimCharacter:GetScale()
		if hatmapped then
			local hatscale = hatmapped.Scale
			-- limb attached
			if hatmapped.Limb then
				local limb = ReanimCharacter:FindFirstChild(hatmapped.Limb)
				if limb and limb:IsA("BasePart") then
					-- weld-like
					if hatmapped.C0 and hatmapped.C1 then
						return limb.CFrame * Util.ScaleCFrame(hatmapped.C0, scale) * Util.ScaleCFrame(hatmapped.C1, hatscale):Inverse(), limb.Velocity
					end
					-- legacy
					if hatmapped.Offset then
						return limb.CFrame * hatmapped.Offset, limb.Velocity
					end
				end
			else
				-- world coords
				if hatmapped.C0 and hatmapped.C1 then
					return hatmapped.C0 * Util.ScaleCFrame(hatmapped.C1, hatscale):Inverse(), Vector3.zero
				end
			end
		end
		return
	end
	local function GetHatCFrameMeshAndTexture(mesh, tex, name)
		return GetHatMappedCFrame(GetHatMappedMeshAndTexture(mesh, tex, name))
	end
	local function GetHatMapped(hat)
		local handle = hat:FindFirstChild("Handle")
		if not handle or not handle:IsA("BasePart") then return end
		local mesh, tex = GetHatMeshAndTexture(hat)
		return GetHatMappedMeshAndTexture(mesh, tex, hat.Name)
	end
	local function GetHatCFrame(hat)
		local handle = hat:FindFirstChild("Handle")
		if not handle or not handle:IsA("BasePart") then return end
		local mesh, tex = GetHatMeshAndTexture(hat)
		return GetHatCFrameMeshAndTexture(mesh, tex, hat.Name)
	end
	local function GetAttachmentCFrame(name)
		local ReanimCharacter = Reanimate.Character
		if not ReanimCharacter then return end
		local scale = ReanimCharacter:GetScale()
		local hatmapped = nil
		-- find hat mapping
		for _,data in ipairs(HatMap) do
			if data.Attachments and data.Attachments[name] then
				hatmapped = data
				break
			end
		end
		if hatmapped then
			local cf = GetHatCFrameMeshAndTexture(hatmapped.MeshId, hatmapped.TextureId)
			local att = hatmapped.Attachments[name]
			return cf * Util.ScaleCFrame(att, hatmapped.Scale)
		end
		if Attachments[name] then
			local limb = ReanimCharacter:FindFirstChild(Attachments[name][1])
			if limb then
				return limb.CFrame * Util.ScaleCFrame(Attachments[name][2], scale)
			end
		end
		return
	end
	HatReanimator.GetHatMap = function() return HatMapCopy end
	HatReanimator.GetHatCFrameMeshAndTexture = GetHatCFrameMeshAndTexture
	HatReanimator.GetAttachmentCFrame = GetAttachmentCFrame

	local InitCFrame = nil
	local CurrentCharacter = nil

	HatReanimator.RebuildRequired = true
	HatReanimator.HatMapSummary = "(no hat map yet...)"
	table.clear(HatReanimator.FlingTargets)
	
	local lastsimradchange = 0
	local function SetSimulationRadius()
		local function setsimrad(plr, radius)
			pcall(function()
				plr.SimulationRadius = radius
			end)
			pcall(sethiddenproperty, plr, "SimulationRadius", radius)
		end
		settings().Physics.AllowSleep = false
		settings().Physics.ThrottleAdjustTime = 0/0
		for _,plr in Players:GetPlayers() do
			local a, b = pcall(compareinstances, plr, Player)
			if a and not b then
				setsimrad(plr, 0)
			end
		end
		local r = #Players:GetPlayers() * 1000
		setsimrad(Player, r)
		if os.clock() > lastsimradchange then
			lastsimradchange = os.clock() + 0.5
			pcall(replicatesignal, Player.SimulationRadiusChanged, r)
		end
		pcall(setsimulationradius, r, r)
		pcall(function()
			-- faster than findfirstchild + if then end
			sethiddenproperty(Player.Character.Humanoid, "InternalBodyScale", Vector3.new(9e9, 9e9, 9e9))
			sethiddenproperty(Player.Character.Humanoid, "InternalHeadScale", 9e9)
		end)
	end
	local function IsNetworkOwner(part)
		if isnetworkowner then
			local s, d = pcall(isnetworkowner, part)
			if s then
				return d
			else
				return part.ReceiveAge == 0
			end
		end
		return part.ReceiveAge == 0
	end
	
	local BackendAccoutrementState = {
		None = 0,
		HasHandle = 1,
		InWorkspace = 2,
		InCharacter = 3,
		Equipped = 4
	}
	local function SetAccoutrementState(hat, state)
		if sethiddenproperty then
			sethiddenproperty(hat, "BackendAccoutrementState", state)
		else
			if setscriptable then
				setscriptable(hat, "BackendAccoutrementState", true)
			end
			pcall(function()
				hat.BackendAccoutrementState = state
			end)
		end
	end

	local IsRespawning = false
	local function Respawn()
		if IsRespawning then return end
		IsRespawning = true
		replicatesignal(Player.ConnectDiedSignalBackend)
		if RejectCharacterDeletionsDisabled then
			local old = Player.Character
			for _,v in old:GetChildren() do
				if v:IsA("Accoutrement") then continue end
				v:Destroy()
			end
			local new = Util.Instance("Model", workspace)
			HatReanimator.DontFireCharAddOnThisChar = new
			Player.Character = new
			task.wait()
			HatReanimator.DontFireCharAddOnThisChar = old
			Player.Character = old
		end
	end

	-- Credits to MyWorld for helping with netless
	local function SetUACFrameNetless(handle, dt, newcf, tvel, fling, spin)
		if dt <= 0 then return false end
		if not (handle:IsA("BasePart") and handle:IsDescendantOf(workspace)) then return false end
		local timing = os.clock()
		local idlerv = Vector3.new(
			math.sin(timing * 14), math.sin(timing * 15 + 1.0472), math.sin(timing * 16 + 2.0944)
		)
		local idleoff = idlerv * 0.001
		local ylimit = FallenPartsDestroyHeight + 5
		if newcf.Y < ylimit then
			newcf += Vector3.new(0, ylimit - newcf.Y, 0)
		end
		local speedlimit = 16384
		if fling then
			speedlimit = math.huge
		end
		local netless = Reanimate.NetlessVelocity + (math.sin(timing * 0.5) + 1) / 2
		local aligned = true
		local lastcf = handle:GetAttribute("_Uhhhhhh_LastPosition")
		local claimtime = handle:GetAttribute("_Uhhhhhh_ClaimTime")
		if typeof(lastcf) ~= "CFrame" then lastcf = handle.CFrame end
		if not handle:IsGrounded() and IsNetworkOwner(handle) then
			local newpos = newcf.Position
			local lastpos = lastcf.Position
			local vel = (newpos - lastpos) / dt
			if vel.Magnitude < 0.12 then
				newcf += idleoff
			elseif vel.Magnitude > speedlimit then
				vel = vel.Unit * speedlimit
				newpos = lastpos + vel * dt
				newcf = newcf.Rotation + newpos
				aligned = false
			end
			local rvel = lastcf:ToObjectSpace(newcf)
			local a, b = rvel:ToAxisAngle()
			rvel = (a * b) / dt
			lastcf = newcf
			if claimtime then
				if timing - claimtime < 5.67 then
					handle.Massless = false
					handle.CustomPhysicalProperties = nil
				else
					handle.Massless = true
					handle.CustomPhysicalProperties = PhysicalProperties.new(0.01, 0, 0, 0, 0)
				end
				if timing - claimtime < 0.51 then
					handle.AssemblyLinearVelocity = Vector3.new(0, netless * 2, 0)
				else
					if fling then
						handle.AssemblyLinearVelocity = Vector3.new(16384, 16384, 16384)
					else
						-- so Patchma's netless doesn't need the velocity of the hat, just where its attached to.
						if Reanimate.UsePatchmaLikeNetless then
							vel = tvel
							vel *= Vector3.new(1, 0, 1)
							if vel.Magnitude > netless then
								vel = vel.Unit * netless
							end
							handle.AssemblyLinearVelocity = Vector3.new(vel.X * 10, netless, vel.Z * 10)
						else
							vel += tvel
							vel *= Vector3.new(1, 0, 1)
							if vel.Magnitude > netless then
								vel = vel.Unit * netless
							end
							handle.AssemblyLinearVelocity = Vector3.new(vel.X, math.max(vel.Y, netless), vel.Z)
						end
					end
				end
			else
				claimtime = timing
				handle.AssemblyLinearVelocity = Vector3.new(0, netless * 2, 0)
			end
			handle.CFrame = newcf
			if spin then
				handle.AssemblyAngularVelocity = Vector3.new(16384, 16384, 16384)
			else
				if Reanimate.UseAngularVelocity then
					handle.AssemblyAngularVelocity = rvel + idleoff
				else
					handle.AssemblyAngularVelocity = idleoff
				end
			end
		else
			claimtime = nil
			lastcf = handle.CFrame
			aligned = false
		end
		handle:SetAttribute("_Uhhhhhh_LastPosition", lastcf)
		handle:SetAttribute("_Uhhhhhh_ClaimTime", claimtime)
		return aligned
	end

	local CharOnDesc = function(v)
		if v:IsA("BasePart") and not v:FindFirstAncestorWhichIsA("Tool") then
			if not table.find(BaseParts, v) then
				table.insert(BaseParts, v)
			end
		elseif v:IsA("Animator") then
			task.defer(function()
				v:Destroy()
			end)
		elseif v:IsA("LocalScript") and v.Parent == Player.Character then
			v.Enabled = false
			v:GetPropertyChangedSignal("Enabled"):Connect(function()
				if v.Enabled then v.Enabled = false end
			end)
			v:GetPropertyChangedSignal("Disabled"):Connect(function()
				if not v.Disabled then v.Disabled = true end
			end)
		elseif v:IsA("Accessory") and v.Parent == Player.Character then
			if not table.find(CharHats, v) then
				table.insert(CharHats, v)
				local conn = nil
				conn = v.AncestryChanged:Connect(function()
					if v.Parent ~= Player.Character then
						local i = table.find(CharHats, v)
						if i then table.remove(CharHats, i) end
					end
				end)
			end
		elseif v:IsA("Tool") and v.Parent == Player.Character then
			if not table.find(CharTools, v) then
				table.insert(CharTools, v)
				local conn = nil
				conn = v.AncestryChanged:Connect(function()
					if v.Parent ~= Player.Character then
						local i = table.find(CharTools, v)
						if i then table.remove(CharTools, i) end
					end
				end)
			end
		end
	end
	local currentping = 0
	local function _counthats(hats)
		local collidable = 0
		local exists = 0
		for _,hat in hats do
			local handle = hat:FindFirstChild("Handle")
			if handle and handle:IsA("BasePart") then
				exists += 1
				if handle.CanCollide then
					collidable += 1
					handle:SetAttribute("_Uhhhhhh_HasCollide", true)
				end
				handle.CanCollide = false
			end
		end
		HatReanimator.Status.HatCollide = exists .. " hats, " .. collidable .. " has collide."
		return collidable
	end
	local function calculatepartdestroytime(height, velocity, gravity)
		return (velocity + math.sqrt(velocity * velocity + 2 * gravity * height)) / gravity
	end
	local HatCollideMethods = {}
	HatCollideMethods[-2] = {
		NoAnim = true,
		HRPTP = function(dt, character, Humanoid, RootPosition, RootPart, readystate)
			RootPart.CFrame = CFrame.new(RootPosition + Vector3.new(0, 141, 0))
			RootPart.AssemblyLinearVelocity, RootPart.AssemblyAngularVelocity = Vector3.zero, Vector3.zero
		end,
		State1 = function(character, Humanoid, hats)
			HatReanimator.Status.HatCollide = "RCDless Mode, applying reweld to head method"
			for _,v in hats do
				SetAccoutrementState(v, BackendAccoutrementState.None)
				local att = v:FindFirstChildOfClass("Attachment")
				if att then
					att:Destroy()
				end
			end
		end,
		State2 = function(character, hats)
			local torso = character:FindFirstChild("Torso")
			if torso then torso:Destroy() end
			local root = character:FindFirstChild("HumanoidRootPart")
			if root then root:Destroy() end
			for _,v in character:GetChildren() do
				if v:IsA("BasePart") and v.Name ~= "Head" then
					v:Destroy()
				end
			end
			local head = character:FindFirstChild("Head")
			if head then head:Destroy() end
			task.wait(0.5)
			return _counthats(hats)
		end,
	}
	HatCollideMethods[-1] = {
		NoAnim = true,
		Wait1 = 0.16,
		Wait2 = 0,
		HRPTP = function(dt, character, Humanoid, RootPosition, RootPart, readystate)
			RootPart.CFrame = CFrame.new(RootPosition + Vector3.new(0, 141, 0))
			RootPart.AssemblyLinearVelocity, RootPart.AssemblyAngularVelocity = Vector3.new(0, 30, 0), Vector3.zero
		end,
		State1 = function() end,
		State2 = function() return 0 end,
	}
	local shownapehatdrop_lock = {}
	HatCollideMethods[0] = {
		NoAnim = false,
		HRPTP = function(dt, character, Humanoid, RootPosition, RootPart, readystate)
			if Humanoid.RigType == Enum.HumanoidRigType.R15 then
				RootPart.CFrame = CFrame.new(RootPosition + Vector3.new(0, -0.25, 0)) * CFrame.Angles(math.rad(20), 0, 0)
			else
				RootPart.CFrame = CFrame.new(RootPosition + Vector3.new(0, -0.25, 0))
			end
			RootPart.AssemblyLinearVelocity, RootPart.AssemblyAngularVelocity = Vector3.new(0, 25, 0), Vector3.zero
		end,
		State1 = function(character, Humanoid, hats)
			local anim = Instance.new("Animation")
			anim.AnimationId = "rbxassetid://180436148"
			if Humanoid.RigType == Enum.HumanoidRigType.R15 then
				anim.AnimationId = "rbxassetid://507767968"
			end
			local track = Humanoid:LoadAnimation(anim)
			track.Priority = 5
			track:Play(0)
			track:AdjustSpeed(1)
			track:AdjustWeight(1)
			track.TimePosition = 0.1
			table.clear(shownapehatdrop_lock)
			for _,v in hats do
				table.insert(shownapehatdrop_lock, v.Changed:Connect(function(p)
					if p == "BackendAccoutrementState" then
						SetAccoutrementState(v, BackendAccoutrementState.None)
					end
				end))
				SetAccoutrementState(v, BackendAccoutrementState.InCharacter)
			end
			HatReanimator.Status.HatCollide = #hats .. " hats states ERADICATED!"
		end,
		State2 = function(character, hats)
			local torso = character:FindFirstChild("Torso")
			if torso then
				torso.AncestryChanged:Wait()
			end
			HatReanimator.Status.HatCollide = "Torso removed, state unlocked."
			for _,v in shownapehatdrop_lock do
				v:Disconnect()
			end
			for _,v in hats do
				SetAccoutrementState(v, BackendAccoutrementState.Equipped)
			end
			torso = character:FindFirstChild("Head")
			if torso then
				torso.AncestryChanged:Wait()
			end
			task.wait(0.5)
			return _counthats(hats)
		end,
	}
	local function hatcol_hrptpstab(torsooffset)
		return function(dt, character, Humanoid, RootPosition, RootPart, readystate)
			local rootcf = CFrame.new(RootPosition + Vector3.new(8, -8, 0)) * CFrame.Angles(math.pi * 0.5, 0, 0)
			if readystate > 0 then
				RootPart.CFrame = rootcf
				RootPart.AssemblyLinearVelocity, RootPart.AssemblyAngularVelocity = Vector3.new(0, 26, 0), Vector3.zero
			else
				RootPart.CFrame = rootcf + Vector3.new(0, 141, 0) -- CFrame.new(RootPosition + Vector3.new(8, 141, 0))
				RootPart.AssemblyLinearVelocity, RootPart.AssemblyAngularVelocity = Vector3.new(0, 26, 0), Vector3.zero
			end
			if Humanoid.RigType == Enum.HumanoidRigType.R15 then
				for _,v in character:GetDescendants() do
					if v:IsA("Motor6D") then
						if v.Name == "Root" then
							Util.SetMotor6DOffset(v, rootcf:ToObjectSpace(CFrame.new(RootPosition + Vector3.new(0, 0.75, 0)) * CFrame.Angles(math.pi * 0.5, 0, 0) * torsooffset))
						elseif v.Name == "Neck" then
							Util.SetMotor6DOffset(v, torsooffset.Rotation:Inverse() * CFrame.new(math.random() * 0.05, 1.5, -10))
						elseif v.Name:FindFirstChild("Shoulder") or v.Name:FindFirstChild("Hip") then
							Util.SetMotor6DOffset(v, torsooffset.Rotation:Inverse() * CFrame.new(v.C0.X - v.C1.X, v.C0.Y - v.C1.Y, -0.5 + math.random() * 0.05))
						else
							Util.SetMotor6DTransform(v, CFrame.identity)
						end
					end
				end
			else
				local i = 1
				for _,v in character:GetDescendants() do
					if v:IsA("Motor6D") then
						if v.Name == "RootJoint" then
							Util.SetMotor6DOffset(v, rootcf:ToObjectSpace(CFrame.new(RootPosition + Vector3.new(0, -0.25, 0)) * CFrame.Angles(math.pi * 0.5, 0, 0) * torsooffset))
						elseif v.Name == "Neck" then
							Util.SetMotor6DOffset(v, torsooffset.Rotation:Inverse() * CFrame.new(math.random() * 0.05, 1.5, -20))
						else
							Util.SetMotor6DOffset(v, torsooffset.Rotation:Inverse() * CFrame.new(i * -3, math.random() * 0.05, -3))
							i += 1
						end
					end
				end
			end
		end
	end
	HatCollideMethods[1] = {
		NoAnim = true,
		HRPTP = hatcol_hrptpstab(CFrame.new(0, 0, 0)),
		State1 = function(character, Humanoid, hats)
			for _,v in hats do
				SetAccoutrementState(v, BackendAccoutrementState.InWorkspace)
				SetAccoutrementState(v, BackendAccoutrementState.None)
			end
			HatReanimator.Status.HatCollide = #hats .. " hats states ERADICATED!"
		end,
		State2 = function(character, hats)
			local torso = character:FindFirstChild("Torso")
			if torso then
				torso.AncestryChanged:Wait()
			end
			HatReanimator.Status.HatCollide = "Torso removed, state unlocked."
			for _,v in hats do
				SetAccoutrementState(v, BackendAccoutrementState.Equipped)
			end
			torso = character:FindFirstChild("Head")
			if torso then
				torso.AncestryChanged:Wait()
			end
			task.wait(0.5)
			return _counthats(hats)
		end,
	}
	HatCollideMethods[2] = {
		NoAnim = true,
		HRPTP = hatcol_hrptpstab(CFrame.new(0, 0, 0) * CFrame.Angles(math.pi, 0, 0)),
		State1 = HatCollideMethods[1].State1,
		State2 = HatCollideMethods[1].State2,
	}
	HatCollideMethods[3] = {
		NoAnim = true,
		HRPTP = hatcol_hrptpstab(CFrame.new(0, 0, 0) * CFrame.Angles(math.pi * -0.5, 0, 0)),
		State1 = HatCollideMethods[1].State1,
		State2 = HatCollideMethods[1].State2,
	}
	HatCollideMethods[4] = {
		NoAnim = true,
		HRPTP = hatcol_hrptpstab(CFrame.new(0, 0, 0) * CFrame.Angles(math.pi * 0.5, 0, 0)),
		State1 = HatCollideMethods[1].State1,
		State2 = HatCollideMethods[1].State2,
	}
	HatCollideMethods[5] = {
		NoAnim = true,
		HRPTP = hatcol_hrptpstab(CFrame.new(0, 0, -8)),
		State1 = HatCollideMethods[1].State1,
		State2 = HatCollideMethods[1].State2,
	}
	HatCollideMethods[6] = {
		NoAnim = true,
		HRPTP = hatcol_hrptpstab(CFrame.new(0, 0, -60)),
		State1 = HatCollideMethods[1].State1,
		State2 = HatCollideMethods[1].State2,
	}
	HatCollideMethods[7] = {
		ColLimb = true,
		NoAnim = true,
		Wait1 = 0.1,
		Wait2 = 0.15,
		HRPTP = function(dt, character, Humanoid, RootPosition, RootPart, readystate)
			local rootcf = CFrame.new(RootPosition + Vector3.new(0, -4, 0))
			RootPart.CFrame = rootcf
			RootPart.AssemblyLinearVelocity, RootPart.AssemblyAngularVelocity = Vector3.new(0, 26, 0), Vector3.zero
			if Humanoid.RigType == Enum.HumanoidRigType.R15 then
				-- TODO
			else
				-- put the limbs in freefall, make sure they dont touch
				local headheight = 3
				for _,v in character:GetDescendants() do
					if v:IsA("Motor6D") then
						if v.Name == "RootJoint" then
							Util.SetMotor6DOffset(v, CFrame.new(0, 6, 0))
						elseif v.Name == "Neck" then
							Util.SetMotor6DOffset(v, CFrame.new(0, headheight, -2))
						elseif v.Name == "Right Shoulder" then
							Util.SetMotor6DOffset(v, CFrame.new((v.C0.X - v.C1.X) * 2, headheight + 0.5, -2))
						elseif v.Name == "Left Shoulder" then
							Util.SetMotor6DOffset(v, CFrame.new((v.C0.X - v.C1.X) * 2, 0, -2))
						elseif v.Name:find("Hip") then
							Util.SetMotor6DOffset(v, CFrame.new((v.C0.X - v.C1.X) * 2, -2, -2))
						else
							Util.SetMotor6DTransform(v, CFrame.identity)
						end
					end
				end
			end
		end,
		State1 = function(character, Humanoid, hats)
			HatReanimator.Status.HatCollide = "Hat states set."
			local head = character:FindFirstChild("Head")
			for _,v in hats do
				local handle = v:FindFirstChild("Handle")
				if handle then
					local weld = handle:FindFirstChild("AccessoryWeld")
					if weld then
						if weld.Part0 == handle and weld.Part1 ~= head then
							continue
						end
						if weld.Part1 == handle and weld.Part0 ~= head then
							continue
						end
					end
				end
				SetAccoutrementState(v, BackendAccoutrementState.InWorkspace)
			end
		end,
		State2 = function(character, hats)
			local ping = Player:GetNetworkPing()
			-- 3 of the most important instances (rootpart is destroyed after a frame anyway)
			local torso = character:FindFirstChild("Torso")
			local head = character:FindFirstChild("Head")
			local rightarm = character:FindFirstChild("Right Arm") -- this will also reevaluate collisions upon removal (cuz tool)
			if torso then
				task.wait(calculatepartdestroytime(2, 26, workspace.Gravity) - 0.1)
			end
			HatReanimator.Status.HatCollide = "Torso removed, I speculate."
			for _,v in hats do
				SetAccoutrementState(v, BackendAccoutrementState.InWorkspace)
			end
			if torso and torso.Parent then
				torso.AncestryChanged:Wait()
			end
			if head and head.Parent then
				head.AncestryChanged:Wait()
			end
			task.wait(1.5)
			return _counthats(hats)
		end,
	}
	HatCollideMethods[8] = { -- VERY EXPERIMENTAL, do NOT use.
		NoAnim = true,
		Wait1 = 0.1,
		Wait2 = 0.15,
		HRPTP = function(dt, character, Humanoid, RootPosition, RootPart, readystate)
			local rootcf = CFrame.new(RootPosition + Vector3.new(0, -4, 0)) * CFrame.Angles(math.pi * 0.5, 0, 0)
			RootPart.CFrame = rootcf
			RootPart.AssemblyLinearVelocity, RootPart.AssemblyAngularVelocity = Vector3.new(0, 0, 30), Vector3.zero
			if Humanoid.RigType == Enum.HumanoidRigType.R15 then
				for _,v in character:GetDescendants() do
					if v:IsA("Motor6D") then
						if v.Name == "Root" then
							Util.SetMotor6DTransform(v, CFrame.new(0, -30, 0))
						elseif v.Name == "Neck" then
							Util.SetMotor6DOffset(v, CFrame.new(0, 67, 0))
						else
							Util.SetMotor6DTransform(v, CFrame.identity)
						end
					end
				end
			else
				local i = 1
				for _,v in character:GetDescendants() do
					if v:IsA("Motor6D") then
						if v.Name == "RootJoint" then
							Util.SetMotor6DOffset(v, CFrame.new(0, 0, -20))
						elseif v.Name == "Neck" then
							Util.SetMotor6DOffset(v, CFrame.new(0, 0, -1))
						elseif v.Name == "Right Shoulder" then
							Util.SetMotor6DOffset(v, CFrame.new(0, 0, -20))
						else
							Util.SetMotor6DOffset(v, CFrame.new(i * -3, 0, 10))
							i += 1
						end
					end
				end
			end
		end,
		State1 = function(character, Humanoid, hats)
			HatReanimator.Status.HatCollide = "Hat states set."
			local head = character:FindFirstChild("Head")
			for _,v in hats do
				local handle = v:FindFirstChild("Handle")
				if handle then
					local weld = handle:FindFirstChild("AccessoryWeld")
					if weld then
						if weld.Part1 ~= head then
							continue
						end
					end
				end
				SetAccoutrementState(v, BackendAccoutrementState.InCharacter)
			end
		end,
		State2 = function(character, hats)
			local hum = character:FindFirstChild("Humanoid")
			local head = character:FindFirstChild("Right Arm")
			HatReanimator.Status.HatCollide = "We shall remain 1 part."
			task.wait(0.41)
			for _,v in hats do
				SetAccoutrementState(v, BackendAccoutrementState.InWorkspace)
				SetAccoutrementState(v, BackendAccoutrementState.InCharacter)
			end
			task.wait(0.19)
			if head and head:IsDescendantOf(workspace) then
				head.AncestryChanged:Wait()
			end
			for _,v in hats do
				SetAccoutrementState(v, BackendAccoutrementState.Equipped)
			end
			task.wait(1.5)
			return _counthats(hats)
		end,
	}
	local NumHats = 0
	local function OnCharacter(character)
		if HatReanimator.DontFireCharAddOnThisChar == character then return end
		local camcfr = Camera.CFrame
		RunService.PreRender:Once(function()
			RunService.PreAnimation:Wait()
			Camera.CFrame = camcfr
		end)
		currentping = Player:GetNetworkPing()
		table.clear(BaseParts)
		table.clear(CharHats)
		table.clear(CharTools)
		ResetHatRefs()
		character.DescendantAdded:Connect(CharOnDesc)
		for _,v in character:GetDescendants() do
			CharOnDesc(v)
		end
		HatReanimator.Status.ReanimState = "Respawned."
		HatReanimator.Status.Permadeath = "Respawn detected."
		HatReanimator.Status.HatCollide = "Respawn detected."
		HatReanimator.Status.RespawnFling = "Respawn detected."
		local hatcols = HatReanimator.HatCollide
		local perma = HatReanimator.Permadeath
		HatReanimator.HasPermadeath, HatReanimator.HasHatCollide = perma, hatcols
		local hatcolmeth = HatReanimator.HatCollideMethod
		if not replicatesignal then perma = false end
		if not hatcols then hatcolmeth = -1 end
		if hatcols and RejectCharacterDeletionsDisabled then
			hatcolmeth = -2
		end
		local selhatcol = HatCollideMethods[hatcolmeth]
		CurrentCharacter = nil
		local Humanoid = character:WaitForChild("Humanoid", 10)
		if not Humanoid then return end
		if not Reanimate.UseLoadAnimationHook then
			local stupid = character:FindFirstChild("Animate")
			if stupid then
				stupid:Destroy()
			end
			character.ChildAdded:Connect(function(v)
				if v:IsA("LocalScript") then
					v.Disabled = true
					task.defer(function()
						v:Destroy()
					end)
				end
			end)
		end
		if selhatcol.NoAnim then
			local stupid = Humanoid:FindFirstChild("Animator")
			if stupid then
				stupid:Destroy()
			end
		end
		if selhatcol.ColLimb then
			Humanoid.EvaluateStateMachine = false
			Humanoid:ChangeState(Enum.HumanoidStateType.Swimming)
		end
		local RootPart = character:WaitForChild("HumanoidRootPart", 10)
		if not RootPart then return end
		local RootPosition = Vector3.new(RootPart.Position.X, FallenPartsDestroyHeight, RootPart.Position.Z)
		if ReanimCharacter then
			local root = ReanimCharacter:FindFirstChild("HumanoidRootPart")
			if root then
				RootPosition = Vector3.new(root.Position.X, FallenPartsDestroyHeight, root.Position.Z)
			end
		end
		if not workspace.StreamingEnabled and false then
			local dir = CFrame.Angles(0, math.pi * 2 * math.random(), 0).LookVector * 300
			while true do
				local nearAPlayer = false
				for _,v in Players:GetPlayers() do
					if v.Character and v.Character.PrimaryPart then
						if (RootPosition - v.Character.PrimaryPart.CFrame.Position).Magnitude < 1000 then
							nearAPlayer = true
						end
					end
				end
				if nearAPlayer then
					RootPosition += dir
				else
					break
				end
			end
		end
		pcall(function() Player.ReplicationFocus = character end)
		if hatcols then
			HatReanimator.Status.HatCollide = "Waiting for Permadeath."
		else
			HatReanimator.Status.HatCollide = "Disabled, nothing to do!"
		end
		local cdsbeffect = os.clock()
		local cdsbtime = os.clock()
		if perma then
			replicatesignal(Player.ConnectDiedSignalBackend)
			HatReanimator.Status.Permadeath = "Fired CDSB Signal."
			cdsbeffect += Players.RespawnTime
		end
		HatReanimator.Status.RespawnFling = "Flinging targets..."
		if HatReanimator.UseNaNFling and HatReanimator.FlingTargets[1] then
			task.wait(0.2)
		end
		while character:IsDescendantOf(workspace) do
			local t = os.clock()
			local flingtarget = HatReanimator.FlingTargets[1]
			if flingtarget then
				if flingtarget.Time then
					if t > flingtarget.Time then
						table.remove(HatReanimator.FlingTargets, 1)
						flingtarget = nil
					end
				else
					flingtarget.Time = t + (flingtarget.Duration or (Reanimate.UsePhysicsRepRootPart and 1 or 2))
				end
			end
			local flingcf, flinged = CFrame.identity, true
			if flingtarget then
				flingcf, flinged = Util.PredictionFling(flingtarget.Target)
				if flinged then
					table.remove(HatReanimator.FlingTargets, 1)
					flingtarget = nil
				end
			end
			if flingtarget then
				if not RootPart:IsGrounded() then
					if HatReanimator.UseNaNFling then
						RootPart.CFrame = CFrame.new(flingcf.Position + Vector3.new(0, 0, math.random(0, 1) * 0.005)) * CFrame.Angles(0, os.clock() * 15, 0)
						RootPart.Velocity, RootPart.RotVelocity = Vector3.zero, Vector3.zero
					else
						RootPart.CFrame = flingcf + Vector3.new(0, 0, math.random(0, 1) * 0.005)
						RootPart.Velocity, RootPart.RotVelocity = Vector3.new(0, -16384, 0), Vector3.one * 16384
					end
					pcall(sethiddenproperty, RootPart, "PhysicsRepRootPart", Reanimate.UsePhysicsRepRootPart and Util.PredictionFlingPart(flingtarget.Target) or nil)
				end
				Humanoid:ChangeState(Enum.HumanoidStateType.Freefall)
				if HatReanimator.UseNaNFling then
					pcall(sethiddenproperty, Humanoid, "MoveDirectionInternal", Vector3.new(0/0, 0/0, 0/0))
				end
			elseif #HatReanimator.FlingTargets == 0 then
				break
			else
				RootPart.CFrame = CFrame.new(0, 1000, 0)
				RootPart.Velocity, RootPart.RotVelocity = Vector3.zero, Vector3.zero
				Humanoid:ChangeState(Enum.HumanoidStateType.Freefall)
			end
			task.wait()
		end
		if not character:IsDescendantOf(workspace) then
			return
		end
		pcall(sethiddenproperty, RootPart, "PhysicsRepRootPart", nil)
		HatReanimator.Status.RespawnFling = "Done."
		local lgloop = nil
		local bringconns = {}
		local readystate = 0
		lgloop = RunService.Heartbeat:Connect(function(dt)
			selhatcol.HRPTP(dt, character, Humanoid, RootPosition, RootPart, readystate)
		end)
		if perma then task.wait(1) end
		local backpack = Player:FindFirstChildOfClass("Backpack")
		local tools = GetTools()
		if perma and backpack then
			-- Credits to Empyrean as reference for this snippet
			for _,tool in tools do
				tool.Parent = character
				local handle = tool:FindFirstChild("Handle")
				if handle and handle:IsA("BasePart") then
					table.insert(bringconns, RunService.Heartbeat:Connect(function(dt)
						if handle:IsDescendantOf(workspace) and IsNetworkOwner(handle) then
							handle.CFrame = CFrame.new(claimarea) + Vector3.new(5, 0, 0)
							handle.Velocity = Vector3.new(0, 67, 0)
							handle.RotVelocity = Vector3.new(0, 0, 0)
						end
					end))
				end
				tool.Parent = backpack
			end
		end
		HatReanimator.Status.ReanimState = "Loading Permadeath."
		if perma then
			if RejectCharacterDeletionsDisabled then
				HatReanimator.Status.Permadeath = "Doing RCDless Permadeath."
				cdsbeffect = os.clock() + Players.RespawnTime + 0.05
				local oldperma = Util.Instance("Model", workspace)
				Instance.new("Part", oldperma).Name = "Torso"
				Instance.new("Part", oldperma).Name = "Head"
				Instance.new("Humanoid", oldperma).Name = "Humanoid"
				oldperma.PrimaryPart = oldperma.Torso
				oldperma:PivotTo(CFrame.new(0, 99999, 0))
				HatReanimator.DontFireCharAddOnThisChar = oldperma
				Player.Character = oldperma
				task.wait(3)
				if not character:IsDescendantOf(workspace) then
					lgloop:Disconnect()
					return
				end
				HatReanimator.DontFireCharAddOnThisChar = character
				Player.Character = character
				while Humanoid:GetState() ~= Enum.HumanoidStateType.Dead and character:IsDescendantOf(workspace) do
					if os.clock() > cdsbeffect then break end
					task.wait()
				end
				if not character:IsDescendantOf(workspace) then
					lgloop:Disconnect()
					return
				end
			else
				HatReanimator.Status.Permadeath = "Waiting for CDSB hack."
				while Humanoid:GetState() ~= Enum.HumanoidStateType.Dead and character:IsDescendantOf(workspace) do
					if os.clock() > cdsbeffect then break end
					task.wait()
				end
			end
			HatReanimator.Status.Permadeath = string.format("Permadeathed after %.3fs.", os.clock() - cdsbtime)
		else
			HatReanimator.Status.Permadeath = "Disabled, nothing to do."
		end
		if not character:IsDescendantOf(workspace) then
			lgloop:Disconnect()
			return
		end
		readystate = 1
		HatReanimator.Status.ReanimState = "Reanimate State: 1"
		if not selhatcol.ColLimb then
			Humanoid:ChangeState(Enum.HumanoidStateType.Physics)
		end
		NumHats = #CharHats
		selhatcol.State1(character, Humanoid, CharHats)
		local claimarea = RootPart.CFrame.Position + RootPart.CFrame.LookVector * 8
		claimarea = Vector3.new(claimarea.X, math.max(FallenPartsDestroyHeight + 16, claimarea.Y + 4), claimarea.Z)
		task.wait(selhatcol.Wait1 or 0.1)
		if not character:IsDescendantOf(workspace) then
			lgloop:Disconnect()
			return
		end
		readystate = 2
		HatReanimator.Status.ReanimState = "Reanimate State: 2"
		for _,hat in CharHats do
			local handle = hat:FindFirstChild("Handle")
			if handle and handle:IsA("BasePart") then
				table.insert(bringconns, RunService.Heartbeat:Connect(function(dt)
					if handle:IsDescendantOf(workspace) and IsNetworkOwner(handle) then
						handle.CFrame = CFrame.new(claimarea)
						handle.Velocity = Vector3.new(0, 67, 0)
						handle.RotVelocity = Vector3.new(0, 0, 0)
					end
				end))
				handle:BreakJoints()
				handle:SetAttribute("_Uhhhhhh_HasCollide", false)
			end
		end
		Humanoid:ChangeState(Enum.HumanoidStateType.FallingDown)
		task.wait(selhatcol.Wait2 or 0.15)
		if not character:IsDescendantOf(workspace) then
			lgloop:Disconnect()
			for _,c in bringconns do
				c:Disconnect()
			end
			return
		end
		replicatesignal(Humanoid.ServerBreakJoints)
		Humanoid.EvaluateStateMachine = true
		Humanoid.BreakJointsOnDeath = true
		Humanoid.Health = 0
		Humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
		Humanoid:ChangeState(Enum.HumanoidStateType.Dead)
		readystate = 3
		HatReanimator.Status.ReanimState = "Reanimate State: 3"
		IsRespawning = false
		if hatcols then
			local stateunlocked = false
			task.spawn(function()
				local collidable = selhatcol.State2(character, CharHats)
				stateunlocked = true
				local atleast = 0
				if SaveData.Reanimator.IWantHatCollide == 1 then
					atleast = 1
				end
				if SaveData.Reanimator.IWantHatCollide == 2 then
					atleast = #CharHats - 3
				end
				if SaveData.Reanimator.IWantHatCollide == 3 then
					atleast = #CharHats - 2
				end
				if SaveData.Reanimator.IWantHatCollide == 4 then
					atleast = #CharHats - 1
				end
				if hatcols and collidable <= atleast then
					if perma then
						HatReanimator.Status.Permadeath = "No hat collide. Respawning!"
						Respawn()
					end
				end
			end)
			repeat task.wait() until stateunlocked or not character:IsDescendantOf(workspace)
			task.wait(0.25)
		end
		if perma and backpack then
			for _,tool in tools do
				tool.Parent = character
			end
			Humanoid:UnequipTools()
		end
		lgloop:Disconnect()
		if perma then task.wait(1) end
		for _,c in bringconns do
			c:Disconnect()
		end
		if not character:IsDescendantOf(workspace) then
			return
		end
		HatReanimator.Status.ReanimState = "Done."
		if #CharHats == 0 then
			if perma then
				HatReanimator.Status.Permadeath = "All hats died. Respawning!"
				Respawn()
			end
		end
		if perma and hatcols then
			if HatReanimator.IWantAllHats and NumHats > #CharHats then
				if perma then
					HatReanimator.Status.Permadeath = "Some hats died. Respawning!"
					Respawn()
				end
			else
				NumHats = #CharHats
			end
		end
		pcall(function() Player.ReplicationFocus = nil end)
		CurrentCharacter = character
	end

	local CharConn = Player.CharacterAdded:Connect(OnCharacter)

	if Player.Character then
		local h = Player.Character:FindFirstChildOfClass("Humanoid")
		if h and h.RootPart then
			InitCFrame = h.RootPart.CFrame
			pcall(function() Player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Dead) end)
			pcall(function() Player.Character.Humanoid.Health = 0 end)
			pcall(replicatesignal, Player.Character.Humanoid.ServerBreakJoints)
			pcall(replicatesignal, Player.ConnectDiedSignalBackend)
			Player.Character.DescendantAdded:Connect(CharOnDesc)
			for _,v in Player.Character:GetDescendants() do
				CharOnDesc(v)
			end
			CurrentCharacter = Player.Character
		end
	end

	Reanimate.CreateCharacter(InitCFrame)

	Reanimate.Starting = false
	local letitgo = 0
	while not Reanimate.Stopping do
		RunService.PreSimulation:Wait()
		workspace.FallenPartsDestroyHeight = 0/0
		SetSimulationRadius()
		local ReanimOkay = false
		local Character = Player.Character
		local ReanimCharacter = Reanimate.Character
		if Character and Character:IsDescendantOf(workspace) then
			if CurrentCharacter == Character then
				if #CharHats > 0 then
					ReanimOkay = true
				end
				if HatReanimator.HasPermadeath and not IsRespawning and HatReanimator.IWantAllHats then
					if NumHats > #CharHats then
						HatReanimator.Status.Permadeath = "Some hats died. Respawning!"
						Respawn()
					else
						local midpoint = Vector3.zero
						local hatsowned = 0
						local hatsnotowned = {}
						for _,v in CharHats do
							if v:FindFirstChild("Handle") then
								if IsNetworkOwner(v.Handle) then
									midpoint += v.Handle.Position
									hatsowned += 1
								else
									table.insert(hatsnotowned, v.Handle)
								end
							end
						end
						midpoint /= hatsowned
						for _,v in hatsnotowned do
							if (v.Position - midpoint).Magnitude > 2000 then
								HatReanimator.Status.Permadeath = "Some hats unclaimable. Respawning!"
								Respawn()
								break
							end
						end
						hatsnotowned = nil
					end
				end
			end
			local Humanoid = Character:FindFirstChildOfClass("Humanoid")
			if Humanoid then
				if Humanoid.WalkSpeed < 1 then
					Humanoid.WalkSpeed = 16
				end
				if Humanoid.JumpPower < 1 then
					Humanoid.JumpPower = 50
				end
				if Camera then
					if (ReanimOkay and ReanimCharacter) or not HatReanimator.Permadeath then
						Camera.CameraSubject = ReanimCharacter:FindFirstChildOfClass("Humanoid")
					else
						Camera.CameraSubject = Humanoid
					end
				end
			end
		end
		local RCRootPart = ReanimCharacter and ReanimCharacter:FindFirstChild("HumanoidRootPart")
		local ltm = Reanimate.LocalTransparencyModifier
		local t = os.clock()
		local slocked = {}
		if ReanimOkay then
			local dt = RunService.PostSimulation:Wait()
			if HatReanimator.RebuildRequired then
				RefreshHatMap(Character)
			end
			for _,v in BaseParts do
				v.CanCollide = false
				if not v:FindFirstAncestorWhichIsA("Tool") then
					v.LocalTransparencyModifier = ltm
				end
			end
			if RCRootPart then
				if Reanimate:ShouldRotationType() then
					local ax, ay, az = Camera.CFrame:ToEulerAngles(Enum.RotationOrder.YXZ)
					local bx, by, bz = RCRootPart.CFrame:ToEulerAngles(Enum.RotationOrder.YXZ)
					local tcf = CFrame.fromEulerAngles(bx, ay, bz, Enum.RotationOrder.YXZ)
					RCRootPart.CFrame = tcf + RCRootPart.CFrame.Position
				end
				local rightarm = ReanimCharacter:FindFirstChild("Right Arm") or RCRootPart
				local rightgrip = Util.ScaleCFrame(RIGHTGRIP_C0, Reanimate.CharacterScale)
				local claimoverride = nil
				local toolequipped = false
				local toolactivate = false
				local toolactivated = nil
				local handlethese = {}
				for _,v in CharTools do
					local handle = v:FindFirstChild("Handle")
					if handle and handle:IsA("BasePart") then
						handlethese[handle] = rightarm.CFrame * rightgrip * v.Grip:Inverse()
						if IsNetworkOwner(handle) then
							handle.CanCollide = false
						else
							handle.CanCollide = true
							local a = Player:GetNetworkPing() + 0.2 + math.sin(t * 30) * 0.2
							claimoverride = handle.CFrame
							claimoverride += handle.Velocity * a
							claimoverride += Vector3.new(0, -workspace.Gravity, 0) * 0.5 * a * a
						end
					end
					if not v:GetAttribute("_Uhhhhhh_ActivateConn") then
						v:SetAttribute("_Uhhhhhh_ActivateConn", true)
						v.Activated:Connect(function()
							v:SetAttribute("_Uhhhhhh_Activate", true)
						end)
					end
					if v:GetAttribute("_Uhhhhhh_Activate") then
						v:SetAttribute("_Uhhhhhh_Activate", nil)
						toolactivate = true
						toolactivated = v
					end
					v.Enabled = true
					v.RequiresHandle = false
					v.ManualActivationOnly = false
				end
				if #CharTools > 0 then
					local FakeTool = ReanimCharacter:FindFirstChildOfClass("Tool")
					if not FakeTool then
						toolequipped = true
						FakeTool = Instance.new("Tool")
						FakeTool.Name = "faketool"
						local FakeToolHandle = Instance.new("Part")
						FakeToolHandle.Name = "Handle"
						FakeToolHandle.Transparency = 1
						FakeToolHandle.Color = Color3.new(0, 0, 1)
						FakeToolHandle.CanCollide = false
						FakeToolHandle.Parent = FakeTool
						FakeTool.Parent = ReanimCharacter
						local RightGrip = Instance.new("Weld")
						RightGrip.Name = "RightGrip"
						RightGrip.Parent = FakeToolHandle
						RightGrip.Part0 = rightarm
						RightGrip.Part1 = FakeToolHandle
						RightGrip.C0 = RIGHTGRIP_C0
						Util.LinkDestroyI2C(FakeTool, FakeTool:GetPropertyChangedSignal("Grip"):Connect(function()
							RightGrip.C1 = FakeTool.Grip
						end))
						RightGrip.C1 = FakeTool.Grip
					end
					if HatReanimator.ToolAnimMethod == 1 then
						if toolequipped then
							local sound = Instance.new("Sound")
							sound.Name = "snd"
							sound.SoundId = "rbxasset://sounds/unsheath.wav"
							sound.Volume = 1
							sound.Parent = FakeTool:FindFirstChild("Handle")
							sound:Play()
							Debris:AddItem(sound, 1)
						end
						if toolactivate then
							local newuse = FakeTool:GetAttribute("_Uhhhhhh_Sword_CD") or 0
							local lastuse = FakeTool:GetAttribute("_Uhhhhhh_Sword_LU") or 0
							if t > newuse then
								if t - lastuse < 0.2 then
									newuse = t + 1
									local toolanim = Instance.new("StringValue")
									toolanim.Name = "toolanim"
									toolanim.Value = "Lunge"
									toolanim.Parent = FakeTool
									local sound = Instance.new("Sound")
									sound.Name = "snd"
									sound.SoundId = "rbxasset://sounds/swordlunge.wav"
									sound.Volume = 1
									sound.Parent = FakeTool:FindFirstChild("Handle")
									sound:Play()
									Debris:AddItem(toolanim, 1)
									Debris:AddItem(sound, 1)
									task.spawn(function(v)
										v.GripForward = Vector3.new(0, 0, 1)
										v.GripRight = Vector3.new(0, -1, 0)
										v.GripUp = Vector3.new(-1, 0, 0)
										task.wait(1)
										v.GripForward = Vector3.new(-1, 0, 0)
										v.GripRight = Vector3.new(0, 1, 0)
										v.GripUp = Vector3.new(0, 0, 1)
									end, toolactivated)
								else
									newuse = t + 0.05
									local toolanim = Instance.new("StringValue")
									toolanim.Name = "toolanim"
									toolanim.Value = "Slash"
									toolanim.Parent = FakeTool
									local sound = Instance.new("Sound")
									sound.Name = "snd"
									sound.SoundId = "rbxasset://sounds/swordslash.wav"
									sound.Volume = 1
									sound.Parent = FakeTool:FindFirstChild("Handle")
									sound:Play()
									Debris:AddItem(toolanim, 1)
									Debris:AddItem(sound, 1)
								end
								lastuse = t
							end
							FakeTool:SetAttribute("_Uhhhhhh_Sword_CD", newuse)
							FakeTool:SetAttribute("_Uhhhhhh_Sword_LU", lastuse)
						end
					end
				else
					local FakeTool = ReanimCharacter:FindFirstChildOfClass("Tool")
					if FakeTool then FakeTool:Destroy() end
				end
				local flingtarget = nil
				local flingcf, flinged = CFrame.identity, true
				if t > letitgo then
					flingtarget = HatReanimator.FlingTargets[1]
					if flingtarget then
						if not HatReanimator.HasPermadeath or HatReanimator.FlingMethod == 0 then
							Respawn()
							flingtarget.Time = nil
							flingtarget = nil
						else
							if flingtarget.Time then
								if t > flingtarget.Time then
									table.remove(HatReanimator.FlingTargets, 1)
									flingtarget = nil
								end
							else
								flingtarget.Time = t + (flingtarget.Duration or (Reanimate.UsePhysicsRepRootPart and Reanimate.PhysicsRepRootPartFling or 2))
							end
						end
					end
					if flingtarget then
						flingcf, flinged = Util.PredictionFling(flingtarget.Target)
						if flinged then
							table.remove(HatReanimator.FlingTargets, 1)
							flingtarget = nil
							letitgo = t + 0.1
						end
					end
				end
				local blacklist = {}
				if flingtarget then
					local flingpart = Reanimate.UsePhysicsRepRootPart and Util.PredictionFlingPart(flingtarget.Target) or nil
					if HatReanimator.FlingMethod == 1 then
						local biggest = nil
						local biggesthat = nil
						local biggestarea = 0
						for _,hat in CharHats do
							local handle = hat:FindFirstChild("Handle")
							if handle and handle:IsA("BasePart") and handle:GetAttribute("_Uhhhhhh_HasCollide") and IsNetworkOwner(handle) then
								local area = handle.Size.X * handle.Size.Y * handle.Size.Z
								if biggestarea < area then
									biggest = handle
									biggesthat = hat
									biggestarea = area
								end
							end
						end
						blacklist[biggesthat] = true
						SetUACFrameNetless(biggest, dt, flingcf, Vector3.zero, false, true)
						pcall(sethiddenproperty, biggest, "PhysicsRepRootPart", Reanimate.UsePhysicsRepRootPart and flingpart or nil)
					end
					if HatReanimator.FlingMethod == 2 then
						local collide = false
						for _,hat in CharHats do
							local handle = hat:FindFirstChild("Handle")
							if handle and handle:IsA("BasePart") then
								if handle:GetAttribute("_Uhhhhhh_HasCollide") then
									collide = true
								end
							end
						end
						if collide then
							for _,hat in CharHats do
								local handle = hat:FindFirstChild("Handle")
								if handle and handle:IsA("BasePart") then
									blacklist[hat] = true
									SetUACFrameNetless(handle, dt, flingcf, Vector3.zero, false, true)
									pcall(sethiddenproperty, handle, "PhysicsRepRootPart", Reanimate.UsePhysicsRepRootPart and flingpart or nil)
								end
							end
						end
					end
					if HatReanimator.FlingMethod == 3 then
						for handle, cf in handlethese do
							blacklist[handle] = true
							SetUACFrameNetless(handle, dt, flingcf, Vector3.zero, false, true)
							pcall(sethiddenproperty, handle, "PhysicsRepRootPart", Reanimate.UsePhysicsRepRootPart and flingpart or nil)
						end
					end
				end
				for _,hat in CharHats do
					local handle = hat:FindFirstChild("Handle")
					if handle and handle:IsA("BasePart") then
						local ref = Hat2HatRefs[hat]
						if blacklist[hat] then
							if ref then ref.Aligned = false end
						else
							if claimoverride then
								SetUACFrameNetless(handle, dt, claimoverride, Vector3.zero, false, false)
								pcall(sethiddenproperty, handle, "PhysicsRepRootPart", nil)
								if ref then ref.Aligned = false end
							else
								local mapped = nil
								if ref then
									mapped = GetHatMappedOverride(ref.Map)
								else
									RefHatToHatRefs(hat)
								end
								local tcf, tvel = GetHatMappedCFrame(mapped)
								tcf = tcf or RCRootPart.CFrame * CFrame.new(0, 5, 0)
								tvel = tvel or Vector3.zero
								local aligned = SetUACFrameNetless(handle, dt, tcf, tvel, HatReanimator.HatFling, HatReanimator.HatSpin)
								if aligned then
									table.insert(slocked, handle)
								end
								if ref then ref.Aligned = aligned end
								pcall(sethiddenproperty, handle, "PhysicsRepRootPart", mapped and mapped.RepRootPart)
							end
						end
					end
				end
				for handle, cf in handlethese do
					if not blacklist[handle] then
						if SetUACFrameNetless(handle, dt, cf, rightarm.Velocity, HatReanimator.HatFling, HatReanimator.HatSpin) then
							table.insert(slocked, handle)
						end
					end
				end
			end
		else
			if CurrentCharacter then
				CurrentCharacter = nil
				replicatesignal(Player.ConnectDiedSignalBackend)
			end
		end
		for _,ref in HatRefs do
			local ph = ref.PH
			if ph then
				if ref.Hat and ref.Aligned then
					ph.Transparency = 1
				else
					local tcf, _ = GetHatMappedCFrame(GetHatMappedOverride(ref.Map))
					ph.CFrame = tcf
					ph.Transparency = 0.625 + math.sin(t) * 0.125
					table.insert(slocked, ph)
				end
			end
		end
		if Reanimate:ShouldRotationType() then
			RunService.PreRender:Wait()
			local ocf = RCRootPart.CFrame
			local ax, ay, az = Camera.CFrame:ToEulerAngles(Enum.RotationOrder.YXZ)
			local bx, by, bz = ocf:ToEulerAngles(Enum.RotationOrder.YXZ)
			local tcf = CFrame.fromEulerAngles(bx, ay, bz, Enum.RotationOrder.YXZ) + ocf.Position
			for _,handle in slocked do
				handle.CFrame = tcf:ToWorldSpace(ocf:ToObjectSpace(handle.CFrame))
			end
			RCRootPart.CFrame = tcf
		end
	end
	ResetHatRefs()
	CharConn:Disconnect()
	replicatesignal(Player.ConnectDiedSignalBackend)
	Reanimate.Stopping = false
	Reanimate.DestroyCharacter()
end

task.wait()
local function ReanimateShowHitboxes()
	local Reanimator = Reanimate.Current
	if Reanimator and Reanimator.ShowHitboxes then
		Reanimator.ShowHitboxes()
	end
end
local function ReanimateFling(target, duration)
	local Reanimator = Reanimate.Current
	if Reanimator and Reanimator.Fling then
		return Reanimator.Fling(target, duration)
	end
	return false
end
-- SetCharacter thing, very empyrean-like system
_G_Uhhhhhh.Fling = function(part)
	if part and part.Parent then
		if part:IsA("BasePart") then
			part = part.Parent
			if part:IsA("Accessory") then
				part = part.Parent
			end
		end
		local hum = part:FindFirstChildOfClass("Humanoid")
		if hum and hum.RootPart and not hum.RootPart:IsGrounded() then
			return ReanimateFling(part)
		end
	end
end

do
	SaveData.SelectedReanimator = SaveData.SelectedReanimator or 1
	local ReanimateMethodSelect = UI.CreateDropdown(MainPage, "Reanimator", {"Limb Reanimator", "Hats Reanimator"}, SaveData.SelectedReanimator)
	local ReanimatorConfigTitle = UI.CreateText(MainPage, "-=+ Limb Reanimator Config +=-", 15, Enum.TextXAlignment.Center)
	local SelectedReanimator = LimbReanimator
	if SaveData.SelectedReanimator == 2 then
		SelectedReanimator = HatReanimator
		ReanimatorConfigTitle.Text = "-=+ Hats Reanimator Config +=-"
	end
	local ReanimatorConfigCanvas = UI.CreateCanvas(MainPage)
	ReanimateMethodSelect.Changed:Connect(function(value)
		SaveData.SelectedReanimator = value
		if value == 1 then
			SelectedReanimator = LimbReanimator
			ReanimatorConfigTitle.Text = "-=+ Limb Reanimator Config +=-"
		end
		if value == 2 then
			SelectedReanimator = HatReanimator
			ReanimatorConfigTitle.Text = "-=+ Hats Reanimator Config +=-"
		end
		Util.ClearAllChildrenGui(ReanimatorConfigCanvas)
		SelectedReanimator.Config(ReanimatorConfigCanvas)
	end)
	SelectedReanimator.Config(ReanimatorConfigCanvas)
	UI.CreateText(MainPage, " ", 5, Enum.TextXAlignment.Center)
	local ReanimateText = UI.CreateText(MainPage, "Running: NONE", 15, Enum.TextXAlignment.Center)
	local ReanimateStartButton, ReanimateStartButtonText = UI.CreateButton(MainPage, "* Reanimate *", 20)
	ReanimateStartButton.Activated:Connect(function()
		ReanimateStartButton.Interactable = false
		if Reanimate.Current then
			ReanimateStartButtonText.Text = "Stopping..."
			Reanimate.Stopping = true
			repeat task.wait() until not Reanimate.Stopping
			Reanimate.Current.Running = nil
			Reanimate.Current = nil
			HumanoidLASetHookState(false)
			ReanimateText.Text = "Running: NONE"
			task.wait(1)
			ReanimateStartButtonText.Text = "* Reanimate *"
		else
			ReanimateStartButtonText.Text = "Starting..."
			Reanimate.Starting = true
			Reanimate.Current = SelectedReanimator
			HumanoidLASetHookState(Reanimate.UseLoadAnimationHook)
			ReanimateText.Text = "Running: " .. Reanimate.Current.Name
			task.spawn(Reanimate.Current.Start)
			repeat task.wait() until not Reanimate.Starting
			Reanimate.Current.Running = true
			task.wait(1)
			ReanimateStartButtonText.Text = "* Deanimate *"
		end
		ReanimateStartButton.Interactable = true
	end)
	UI.CreateButton(MainPage, "Show Reanimate Hitboxes", 15).Activated:Connect(function()
		if not Reanimate.Character then return end
		ReanimateShowHitboxes()
	end)
	UI.CreateButton(MainPage, "Refresh Reanimate Character", 10).Activated:Connect(function()
		if not Reanimate.Character then return end
		Reanimate.CreateCharacter()
	end)
end
UI.CreateSeparator(MainPage)

do
	UI.CreateText(MainPage, "Reanimate Character Settings", 15, Enum.TextXAlignment.Center)
	UI.CreateSwitch(MainPage, "Infinite Jump", Reanimate.InfiniteJump).Changed:Connect(function(val)
		Reanimate.InfiniteJump = val
		SaveData.NoInfiniteJump = not val
	end)
	UI.CreateSwitch(MainPage, "Noclip", Reanimate.Noclip).Changed:Connect(function(val)
		Reanimate.Noclip = val
		SaveData.NoclipEnabled = val
	end)
	UI.CreateSwitch(MainPage, "Smooth Camera", Reanimate.SmoothCam).Changed:Connect(function(val)
		Reanimate.SmoothCam = val
		SaveData.NoSmoothCam = not val
	end)
	UI.CreateSwitch(MainPage, "Allow Shiftlock", Reanimate.ShiftlockEnabled).Changed:Connect(function(val)
		Reanimate.ShiftlockEnabled = val
		SaveData.ShiftlockDisabled = not val
	end)
	UI.CreateSwitch(MainPage, "Can Sit on Seats", Reanimate.SeatSit).Changed:Connect(function(val)
		Reanimate.SeatSit = val
		SaveData.NoSeatSitEnabled = not val
	end)
	UI.CreateSwitch(MainPage, "Can Pickup Tools", Reanimate.ToolGrab).Changed:Connect(function(val)
		Reanimate.ToolGrab = val
		SaveData.ToolGrabEnabled = val
	end)
	UI.CreateSwitch(MainPage, "Apply Scale to Gravity", Reanimate.ScaleGravity).Changed:Connect(function(val)
		Reanimate.ScaleGravity = val
		SaveData.ScaleGravityEnabled = val
	end)
	UI.CreateButton(MainPage, "Force Sit (2x to remove gyro)", 20).Activated:Connect(function()
		local ch = Reanimate.Character or Player.Character
		if ch then
			local h = ch:FindFirstChildOfClass("Humanoid")
			local r = h and h.RootPart
			if h and r then
				h.Sit = true
				if r:FindFirstChild("SeatGyro") then
					r.SeatGyro:Destroy()
				else
					local g = Instance.new("BodyGyro")
					g.Name = "SeatGyro"
					g.CFrame = r.CFrame
					g.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
					g.Parent = r
					Util.LinkDestroyI2C(g, h:GetPropertyChangedSignal("Sit"):Once(function()
						g:Destroy()
					end))
				end
			end
		end
	end)
	local CharacterScaleSlider = UI.CreateSlider(MainPage, "Character Scale", Reanimate.CharacterScale, 0.5, 5, 0.5)
	CharacterScaleSlider.Changed:Connect(function(val)
		val = math.clamp(val, 0.001, 20)
		CharacterScaleSlider.Value = val
		Reanimate.CharacterScale = val
		SaveData.CharacterScale = val
	end)
	UI.CreateSeparator(MainPage)
	local function ReanimCharacterTeleport(pos)
		local ch = Reanimate.Character or Player.Character
		if ch then
			local h = ch:FindFirstChildOfClass("Humanoid")
			local r = h and h.RootPart
			if h and r then
				r.CFrame = r.CFrame.Rotation + pos
				r.Velocity = Vector3.new(0, 50, 0)
			end
		end
	end
	UI.CreateSwitch(MainPage, "Click Fling", Reanimate.ClickFling).Changed:Connect(function(val)
		Reanimate.ClickFling = val
		SaveData.ClickFlingEnabled = val
	end)
	UI.CreateSwitch(MainPage, "Key+Click Teleport", Reanimate.CtrlClick).Changed:Connect(function(val)
		Reanimate.CtrlClick = val
		SaveData.CtrlClickEnabled = val
	end)
	local selectedkey = Enum.KeyCode.LeftControl
	SaveData.CtrlClickKey = SaveData.CtrlClickKey or 1
	local function updatekey()
		local val = SaveData.CtrlClickKey
		if val == 1 then
			selectedkey = Enum.KeyCode.LeftControl
		end
		if val == 2 then
			selectedkey = Enum.KeyCode.RightBracket
		end
		if val == 3 then
			selectedkey = Enum.KeyCode.Tab
		end
		if val == 4 then
			selectedkey = Enum.KeyCode.Z
		end
		if val == 5 then
			selectedkey = Enum.KeyCode.X
		end
		if val == 6 then
			selectedkey = Enum.KeyCode.F
		end
		if val == 7 then
			selectedkey = Enum.KeyCode.T
		end
	end
	updatekey()
	UI.CreateDropdown(MainPage, "TP Key", {
		"Left Ctrl (default)", "inno's pick (']')", "Tab (idk)",
		"Z", "X (i like this one on pc)", "F", "T",
	}, SaveData.CtrlClickKey).Changed:Connect(function(val)
		SaveData.CtrlClickKey = val
		updatekey()
	end)
	local Maus = Player:GetMouse()
	local HoldingCtrl = UI.CreateSwitch(MainPage, "TP Key Held", false)
	local _lastclick = nil
	local _lastclickgpe = false
	local _lastclicktick = 0
	local _lastclickpos = Vector3.zero
	UserInputService.InputBegan:Connect(function(input, guiprocessed)
		if input.UserInputType == Enum.UserInputType.Keyboard then
			if input.KeyCode == selectedkey then
				HoldingCtrl.Value = true
			end
		end
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			_lastclick = input
			_lastclickgpe = gpe
			_lastclicktick = os.clock()
			_lastclickpos = input.Position
		end
	end)
	UserInputService.InputEnded:Connect(function(input, guiprocessed)
		if input.UserInputType == Enum.UserInputType.Keyboard then
			if input.KeyCode == selectedkey then
				HoldingCtrl.Value = false
			end
		end
		if _lastclick and _lastclick == input and not _lastclickgpe then
			if os.clock() - _lastclicktick < 0.3 and (input.Position - _lastclickpos).Magnitude < 10 then
				if Reanimate.CtrlClick and HoldingCtrl.Value then
					if Maus.Target and Maus.Target.Parent then
						ReanimCharacterTeleport(Maus.Hit.Position + Vector3.new(0, 3, 0))
						return
					end
				end
				if Reanimate.ClickFling then
					if Maus.Target and Maus.Target.Parent then 
						local target = Maus.Target.Parent
						if target:IsA("Accessory") then
							target = target.Parent
						end
						if target:FindFirstChildOfClass("Humanoid") then
							if ReanimateFling(target) then return end
						end
					end
				end
			end
		end
	end)
	UI.CreateButton(MainPage, "Teleport to 0, highest, 0", 20).Activated:Connect(function()
		local hit = workspace:Raycast(Vector3.new(0, 4500, 0), Vector3.new(0, -4500 + FallenPartsDestroyHeight, 0))
		if hit and hit.Position == hit.Position then
			ReanimCharacterTeleport(hit.Position + Vector3.new(0, 5, 0))
		else
			ReanimCharacterTeleport(Vector3.new(0, 0, 0))
		end
	end)
	local TeleportToPlayerSel = UI.CreateText(MainPage, "<font color=\"#AAAAAA\">(enter a player name)</font>", 15, Enum.TextXAlignment.Center)
	local TeleportToPlayer = UI.CreateTextbox(MainPage, "", "Teleport To Player", 20)
	TeleportToPlayer:GetPropertyChangedSignal("Text"):Connect(function()
		local sel = Util.QueryPlayerSelector(TeleportToPlayer.Text)
		if sel then
			TeleportToPlayerSel.Text = `{sel.DisplayName} (@{sel.Name})`
		else
			if #TeleportToPlayer.Text == 0 then
				TeleportToPlayerSel.Text = "<font color=\"#AAAAAA\">(enter a player name)</font>"
			else
				TeleportToPlayerSel.Text = "<font color=\"#FF7777\">(player not found)</font>"
			end
		end
	end)
	TeleportToPlayer.FocusLost:Connect(function(enter)
		if enter then
			local sel = Util.QueryPlayerSelector(TeleportToPlayer.Text)
			if sel and sel.Character then
				local r = sel.Character:FindFirstChild("LowerTorso") or sel.Character:FindFirstChild("Torso")
				if r and r:IsA("BasePart") then
					ReanimCharacterTeleport(r.CFrame.Position)
				end
			end
			TeleportToPlayer.Text = ""
		end
	end)
end
UI.CreateSeparator(MainPage)
do
	UI.CreateText(MainPage, "Internals Settings", 15, Enum.TextXAlignment.Center)
	UI.CreateSwitch(MainPage, "Hook LoadAnimation", Reanimate.UseLoadAnimationHook).Changed:Connect(function(val)
		Reanimate.UseLoadAnimationHook = val
		SaveData.NoLoadAnimationHook = not val
	end)
	UI.CreateSwitch(MainPage, "Use Physics Glue", Reanimate.UsePhysicsRepRootPart).Changed:Connect(function(val)
		Reanimate.UsePhysicsRepRootPart = val
		SaveData.NoPhysicsRepRootPart = not val
	end)
	UI.CreateText(MainPage, "internals for physics based reanimation\n(like hat reanimator)", 10, Enum.TextXAlignment.Center)
	UI.CreateSwitch(MainPage, "Patchma-like Netless", Reanimate.UsePatchmaLikeNetless).Changed:Connect(function(val)
		Reanimate.UsePatchmaLikeNetless = val
		SaveData.UsePatchmaLikeNetless = val
	end)
	local NetVelSlider = UI.CreateSlider(MainPage, "Netless Velocity", Reanimate.NetlessVelocity, 25.01, 30, 0.1)
	NetVelSlider.Changed:Connect(function(val)
		val = math.clamp(val, 25.01, 30)
		NetVelSlider.Value = val
		Reanimate.NetlessVelocity = val
		SaveData.NetlessVelocity = val
	end)
	UI.CreateSwitch(MainPage, "Apply RotVelocity", Reanimate.UseAngularVelocity).Changed:Connect(function(val)
		Reanimate.UseAngularVelocity = val
		SaveData.UseAngularVelocity = val
	end)
end
UI.CreateSeparator(MainPage)

local AnimLib = {}
do
	local Track = {}
	function Track.frombuffer(buf)
		local needle = 0
		local buflen = buffer.len(buf)
		local function getleft()
			return buflen - needle
		end
		local function readstring()
			assert(getleft() >= 2)
			local len = buffer.readu16(buf, needle)
			needle += 2
			assert(getleft() >= len)
			local val = buffer.readstring(buf, needle, len)
			needle += len
			return val
		end
		local function readsizet()
			assert(getleft() >= 4)
			local val = buffer.readu32(buf, needle)
			needle += 4
			return val
		end
		local function readfloat()
			assert(getleft() >= 4)
			local val = buffer.readf32(buf, needle)
			needle += 4
			return val
		end
		local anim = {
			Name = "<unknown>",
			Time = 0,
			Keyframes = {},
		}
		anim.Name = readstring() -- name
		local nkeyframes = readsizet() -- # of keyframes
		for _=1, nkeyframes do
			local t = readfloat() -- time
			anim.Time = math.max(anim.Time, t)
			local nposes = readsizet() -- # of poses
			local keyframe = {
				Time = t,
				Poses = {}
			}
			for _=1, nposes do
				local pose = {}
				pose.Name = readstring() -- "bone" name
				pose.Weight = readfloat() -- weight (usually 1 or 0)
				pose.EasingStyle = readstring() -- EasingStyle
				pose.EasingDirection = readstring() -- EasingDirection
				pose.CFrame = CFrame.new(
					readfloat(),
					readfloat(),
					readfloat(),
					readfloat(),
					readfloat(),
					readfloat(),
					readfloat(),
					readfloat(),
					readfloat(),
					readfloat(),
					readfloat(),
					readfloat()
				) -- cframe
				table.insert(keyframe.Poses, pose)
			end
			table.insert(anim.Keyframes, keyframe)
		end
		-- sort by time for ez lookup
		table.sort(anim.Keyframes, function(a, b)
			return a.Time < b.Time
		end)
		return anim
	end
	function Track.fromfile(path)
		local s, data = pcall(readfile, path)
		if s and data then
			local buf = buffer.fromstring(data)
			return Track.frombuffer(buf)
		end
	end
	function Track.frominstance(ks)
		assert(ks and ks:IsA("KeyframeSequence"))
		local anim = {
			Name = "<unknown>",
			Time = 0,
			Keyframes = {},
		}
		anim.Name = ks.Name
		for _,k in ks:GetKeyframes() do
			local t = k.Time
			anim.Time = math.max(anim.Time, t)
			local keyframe = {
				Time = t,
				Poses = {}
			}
			for _,p in k:GetDescendants() do
				if not p:IsA("Pose") then continue end
				table.insert(keyframe.Poses, {
					Name = p.Name,
					Weight = p.Weight,
					EasingStyle = p.EasingStyle.Name,
					EasingDirection = p.EasingDirection.Name,
					CFrame = p.CFrame
				})
			end
			table.insert(anim.Keyframes, keyframe)
		end
		table.sort(anim.Keyframes, function(a, b)
			return a.Time < b.Time
		end)
		return anim
	end
	function Track.paste(target, source, timeoffset)
		for _,keyframe in source.Keyframes do
			local newkeyframe = DeepcopyTable(keyframe)
			newkeyframe.Time += timeoffset
			table.insert(target.Keyframes, newkeyframe)
		end
		anim.Time = 0
		table.sort(source.Keyframes, function(a, b)
			anim.Time = math.max(anim.Time, a.Time, b.Time)
			return a.Time < b.Time
		end)
	end
	function Track.getPoses(track, t, looped)
		-- not recommended for use on big anims
		local poses = {}
		local keyframes = track.Keyframes
		for _,keyframe in keyframes do
			for _,pose in keyframe.Poses do
				poses[pose.Name] = CFrame.identity
			end
		end
		if looped then
			t = t % track.Time
		end
		for name,_ in poses do
			local k1, k2, t1, t2 = nil, nil, -math.huge, math.huge
			for _,k in keyframes do
				local po = nil
				for _,p in k.Poses do
					if p.Name == name and p.Weight > 0 then
						po = p
					end
				end
				if po ~= nil then
					if t1 < k.Time and k.Time <= t then
						k1 = po
						t1 = k.Time
					end
					if t2 > k.Time and k.Time > t then
						k2 = po
						t2 = k.Time
					end
				end
			end
			local cf = CFrame.identity
			if k1 ~= nil then
				if k2 ~= nil then
					local a = (t - t1) / (t2 - t1)
					local es, ed = k1.EasingStyle, k1.EasingDirection
					if es == "Constant" then
						if ed == "In" then
							a = 1
						elseif ed == "Out" then
							a = 0
						else
							if a < 0.5 then
								a = 0
							else
								a = 1
							end
						end
					else
						if es == "CubicV2" then
							es = "Cubic"
						end
						a = TweenService:GetValue(
							a,
							Enum.EasingStyle[es],
							Enum.EasingDirection[ed]
						)
					end
					cf = k1.CFrame:Lerp(k2.CFrame, a)
				else
					cf = k1.CFrame
				end
			else
				if k2 ~= nil then
					cf = k2.CFrame
				end
			end
			poses[name] = cf
		end
		return poses
	end
	AnimLib.Track = Track
	local Animator = {}
	Animator.__index = Animator
	function Animator.new()
		local self = setmetatable({}, Animator)
		self.rig = nil
		self.track = nil
		self.map = {{0, 1}, {0, 1}}
		self.looped = false
		self.speed = 1
		self.weight = 1
		self._optimiser = 1
		self._jointmap = nil
		self._skipsec = nil
		self._rig = nil
		self._track = nil
		return self
	end
	function Animator:Step(t)
		local rig, track, map, speed, weight, looped = self.rig, self.track, self.map, self.speed, self.weight, self.looped
		local jointmap, skipsec = self._jointmap, self._skipsec
		if rig and track then
			local scale = rig:GetScale()
			t *= speed
			if map then
				t = map[2][1] + (t - map[1][1]) * (map[2][2] - map[2][1]) / (map[1][2] - map[1][1])
			end
			if self._rig ~= rig then
				jointmap = nil
				self._rig = rig
			end
			if self._track ~= track then
				skipsec = nil
				self._track = track
			end
			if not jointmap then
				jointmap = {}
				for _,v in rig:GetDescendants() do
					if v:IsA("Motor6D") and v.Part0 and v.Part1 then
						jointmap[v.Part1.Name] = v
					end
				end
				self._jointmap = jointmap
			end
			local keyframes = track.Keyframes
			if not skipsec then
				skipsec = {}
				local i = 1
				local oldsec = 0
				while i < #keyframes do
					local k = keyframes[i]
					local sec = k.Time // self._optimiser
					while oldsec < sec do
						local j = math.max(1, i - 1)
						local poses = {}
						local scan = j
						while scan > 0 do
							local k2 = keyframes[scan]
							local ok = true
							for name,_ in jointmap do
								if not poses[name] then
									for _,p in k2.Poses do
										if p.Name == name and p.Weight > 0 then
											poses[name] = true
											j = scan
											break
										end
									end
								end
								ok = poses[name] and ok
							end
							if ok then break end
							scan -= 1
						end
						table.insert(skipsec, {j, j})
						oldsec += 1
					end
					i += 1
				end
				for i,v in skipsec do
					while v[2] < #keyframes and keyframes[v[2]].Time <= (i + 1) * self._optimiser do
						v[2] += 1
					end
				end
				self._skipsec = skipsec
			end
			local poses = {}
			for name,_ in jointmap do
				poses[name] = CFrame.identity
			end
			if looped then
				t = t % track.Time
			end
			local skip1, skip2 = 1, #keyframes
			if #skipsec >= 2 then
				local i = t // self._optimiser
				if i < 1 then
					skip1, skip2 = 1, skipsec[1][2]
				elseif i < #skipsec then
					skip1, skip2 = skipsec[i][1], skipsec[i][2]
				else
					skip1, skip2 = skipsec[#skipsec][1], #keyframes
				end
			end
			for name,_ in poses do
				local k1, k2, t1, t2 = nil, nil, -math.huge, math.huge
				for i=skip1, skip2 do
					local k = keyframes[i]
					local po = nil
					for _,p in k.Poses do
						if p.Name == name and p.Weight > 0 then
							po = p
						end
					end
					if po ~= nil then
						if t1 < k.Time and k.Time <= t then
							k1 = po
							t1 = k.Time
						end
						if t2 > k.Time and k.Time > t then
							k2 = po
							t2 = k.Time
						end
					end
				end
				local cf = CFrame.identity
				if k1 ~= nil then
					if k2 ~= nil then
						local a = (t - t1) / (t2 - t1)
						local es, ed = k1.EasingStyle, k1.EasingDirection
						if es == "Constant" then
							if ed == "In" then
								a = 1
							elseif ed == "Out" then
								a = 0
							else
								if a < 0.5 then
									a = 0
								else
									a = 1
								end
							end
						else
							if es == "CubicV2" then
								es = "Cubic"
							end
							a = TweenService:GetValue(
								a,
								Enum.EasingStyle[es],
								Enum.EasingDirection[ed]
							)
						end
						cf = k1.CFrame:Lerp(k2.CFrame, a)
					else
						cf = k1.CFrame
					end
				else
					if k2 ~= nil then
						cf = k2.CFrame
					end
				end
				poses[name] = cf
			end
			for name,joint in jointmap do
				local cf = poses[name] or CFrame.identity
				cf = cf.Rotation + (cf.Position * scale)
				if weight == 1 then
					joint.Transform = cf
				elseif weight ~= 0 then
					joint.Transform = joint.Transform:Lerp(cf, weight)
				end
			end
		end
	end
	AnimLib.Animator = Animator
end
local function AssetGetPathFromFilename(filename)
	local filetype = "Unknown/"
	if filename:sub(-4, -1) == ".mp3" then
		filetype = "Sounds/"
	elseif filename:sub(-5, -1) == ".anim" then
		filetype = "Anims/"
	elseif filename:sub(-4, -1) == ".png" then
		filetype = "Images/"
	elseif filename:sub(-4, -1) == ".rbxm" then
		filetype = "Models/"
	end
	return "UhhhhhhReanim/Content/" .. filetype .. filename
end
local _Assetdownloading = {}
local function AssetDownload(filename)
	local source = "https://raw.githubusercontent.com/STEVE-916-create/Uhhhhhh/main/content/" .. filename
	local split = string.split(filename, "@")
	if #split > 1 then
		filename = table.remove(split, 1)
		source = table.concat(split, "@")
	end
	local path = AssetGetPathFromFilename(filename)
	if isfile(path) then return true end
	if _Assetdownloading[filename] then return false end
	_Assetdownloading[filename] = true
	task.spawn(function()
		Util.Notify("Downloading " .. filename .. "...")
		local s, resp = pcall(request, {
			Method = "GET",
			Url = source,
		})
		if s and resp and resp.StatusCode == 200 then
			pcall(writefile, path, resp.Body)
		else
			Util.Notify("Failed to download " .. filename .. "!")
		end
		task.wait(10)
		_Assetdownloading[filename] = nil
	end)
	return false
end
local function AssetGetContentId(filename)
	local path = AssetGetPathFromFilename(filename)
	if not isfile(path) then return "" end
	local s, id = pcall(getcustomasset, path)
	if s and id then
		return id
	end
	return ""
end
local function AssetEnsure(list)
	local ok = true
	for _,filename in list do
		if not AssetDownload(filename) then
			ok = false
		end
	end
	return ok
end
local function ProtectedChat(content)
	pcall(function()
		TextChatService:FindFirstChildOfClass("ChatInputBarConfiguration").TargetTextChannel:SendAsync(content, Util.RandomString(64))
	end)
end
local OnPlayerChatted = Util.Instance("BindableEvent")
TextChatService.MessageReceived:Connect(function(message)
	if message.Status ~= Enum.TextChatMessageStatus.Sending and message.TextSource and message.TextSource.UserId then
		local plr, msg = Players:GetPlayerByUserId(message.TextSource.UserId), message.Text:gsub("&lt;", "<"):gsub("&gt;", ">"):gsub("&quot;", "\""):gsub("&apos;", "'"):gsub("&amp;", "&")
		if plr then OnPlayerChatted:Fire(plr, msg) end
	end
end)
task.wait()

local function GiveFunctionsToFunction(func)
	local env = b_getfenv(func)
	env.RandomString = Util.RandomString
	env.Util_CreateText = UI.CreateText
	env.Util_CreateButton = UI.CreateButton
	env.Util_CreateSwitch = UI.CreateSwitch
	env.Util_CreateTextbox = UI.CreateTextbox
	env.Util_CreateSlider = UI.CreateSlider
	env.Util_CreateDropdown = UI.CreateDropdown
	env.Util_CreateCanvas = UI.CreateCanvas
	env.Util_CreateScrollCanvas = UI.CreateScrollCanvas
	env.Util_CreateSeparator = UI.CreateSeparator
	env.ReanimCamera = Reanimate.Camera
	env.LimbReanimator = LimbReanimator
	env.HatReanimator = HatReanimator
	env.ReanimateShowHitboxes = ReanimateShowHitboxes
	env.ReanimateFling = ReanimateFling
	env.SetOverrideMovesetMusic = SetOverrideMovesetMusic
	env.GetOverrideMovesetMusicTime = GetOverrideMovesetMusicTime
	env.SetOverrideMovesetMusicTime = SetOverrideMovesetMusicTime
	env.SetOverrideMovesetMusicSpeed = SetOverrideMovesetMusicSpeed
	env.SetOverrideDanceMusic = SetOverrideDanceMusic
	env.GetOverrideDanceMusicTime = GetOverrideDanceMusicTime
	env.SetOverrideDanceMusicTime = SetOverrideDanceMusicTime
	env.SetOverrideDanceMusicSpeed = SetOverrideDanceMusicSpeed
	env.AnimLib = AnimLib
	env.AssetGetPathFromFilename = AssetGetPathFromFilename
	env.AssetGetContentId = AssetGetContentId
	env.ProtectedChat = ProtectedChat
	env.OnPlayerChatted = OnPlayerChatted
	env.HiddenGui = SCREENGUI
	env.FallenPartsDestroyHeight = FallenPartsDestroyHeight
end

local MovementStyles = {}
local DanceableDances = {}

local CurrentMovementStyle = nil
local MovementStyleIndex = 2
local _MovementStyleIndex = nil
local CurrentDance = nil
local _CurrentDance = nil
local OldReanimCharacter = nil

if type(SaveData.MovesetIndex) == "number" then
	MovementStyleIndex = SaveData.MovesetIndex
end

local MovesetsPage = UI.CreateItemListPage()
MovesetsPage.ZIndex = 1
MovesetsPage.Position = UDim2.new(0.5, 360, 0.5, 0)
MovesetsPage.Interactable = false
MovesetsPage.Visible = false
UI.CreateButton(MainPage, "Movesets &gt;", 20).Activated:Connect(function()
	MovesetsPage.Interactable = false
	MovesetsPage.Visible = true
	MainPage.Interactable = false
	local tween = TweenService:Create(MovesetsPage, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.In), {
		Position = UDim2.new(0.5, 0, 0.5, 0),
	})
	tween:Play()
	tween.Completed:Connect(function()
		MovesetsPage.Interactable = true
	end)
end)
MovesetsPage.Back.Activated:Connect(function()
	MovesetsPage.Interactable = false
	MovesetsPage.Visible = true
	MainPage.Interactable = false
	local tween = TweenService:Create(MovesetsPage, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
		Position = UDim2.new(0.5, 360, 0.5, 0),
	})
	tween:Play()
	tween.Completed:Connect(function()
		MainPage.Interactable = true
		MovesetsPage.Visible = false
	end)
end)
local DancesPage = UI.CreateItemListPage()
DancesPage.ZIndex = 1
DancesPage.Position = UDim2.new(0.5, 360, 0.5, 0)
DancesPage.Interactable = false
DancesPage.Visible = false
UI.CreateButton(MainPage, "Dances &gt;", 20).Activated:Connect(function()
	DancesPage.Interactable = false
	DancesPage.Visible = true
	MainPage.Interactable = false
	local tween = TweenService:Create(DancesPage, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.In), {
		Position = UDim2.new(0.5, 0, 0.5, 0),
	})
	tween:Play()
	tween.Completed:Connect(function()
		DancesPage.Interactable = true
	end)
end)
DancesPage.Back.Activated:Connect(function()
	DancesPage.Interactable = false
	DancesPage.Visible = true
	MainPage.Interactable = false
	local tween = TweenService:Create(DancesPage, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
		Position = UDim2.new(0.5, 360, 0.5, 0),
	})
	tween:Play()
	tween.Completed:Connect(function()
		MainPage.Interactable = true
		DancesPage.Visible = false
	end)
end)
local KeybindsPage = UI.CreateItemListPage()
KeybindsPage.ZIndex = 1
KeybindsPage.Position = UDim2.new(0.5, 360, 0.5, 0)
KeybindsPage.Interactable = false
KeybindsPage.Visible = false
UI.CreateButton(MainPage, "Dance Keybinds &gt;", 20).Activated:Connect(function()
	KeybindsPage.Interactable = false
	KeybindsPage.Visible = true
	MainPage.Interactable = false
	local tween = TweenService:Create(KeybindsPage, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.In), {
		Position = UDim2.new(0.5, 0, 0.5, 0),
	})
	tween:Play()
	tween.Completed:Connect(function()
		KeybindsPage.Interactable = true
	end)
end)
KeybindsPage.Back.Activated:Connect(function()
	KeybindsPage.Interactable = false
	KeybindsPage.Visible = true
	MainPage.Interactable = false
	local tween = TweenService:Create(KeybindsPage, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
		Position = UDim2.new(0.5, 360, 0.5, 0),
	})
	tween:Play()
	tween.Completed:Connect(function()
		MainPage.Interactable = true
		KeybindsPage.Visible = false
	end)
end)

SaveData.KeybindsEnabled = not not SaveData.KeybindsEnabled
UI.CreateSwitch(MainPage, "Dance Keybinds Enabled", SaveData.KeybindsEnabled).Changed:Connect(function(val)
	SaveData.KeybindsEnabled = val
end)
local Keybinds = {}
local KeybindsPerPage = {"Z", "X", "C", "V", "B", "N", "G", "H", "J", "K", "L", "R", "T", "U", "P"}
local KeybindPaging = 0
local RefreshKeybinds = nil
local function HandleKeybind(key)
	if table.find(KeybindsPerPage, key) then
		if CurrentDance then
			CurrentDance = nil
		else
			CurrentDance = Keybinds[key]
			if CurrentDance then
				Util.Notify(key .. " - " .. CurrentDance.Name)
			end
		end
	end
	if key == "M" then
		local pages = math.max(1, 1 + ((#DanceableDances - 1) // #KeybindsPerPage))
		KeybindPaging = (KeybindPaging + 1) % pages
		Util.Notify("Page " .. (KeybindPaging + 1))
		RefreshKeybinds()
	end
end
RefreshKeybinds = function()
	local pages = math.max(1, 1 + ((#DanceableDances - 1) // #KeybindsPerPage))
	Util.ClearAllChildrenGui(KeybindsPage.List)
	local button = UI.CreateButton(KeybindsPage.List, "M - Page " .. (((KeybindPaging + 1) % pages) + 1), 20)
	button.Parent.Name = ""
	button.Activated:Connect(function()
		HandleKeybind("M")
	end)
	local indexoffset = KeybindPaging * #KeybindsPerPage
	for i=1, #KeybindsPerPage do
		local key = KeybindsPerPage[i]
		local index = indexoffset + i
		local dance = DanceableDances[index]
		Keybinds[key] = dance
		if dance then
			button = UI.CreateButton(KeybindsPage.List, key .. " - " .. dance.Name, 20)
			button.Parent.Name = key .. " " .. dance.Name
			button.Activated:Connect(function()
				HandleKeybind(key)
			end)
		end
	end
end
UserInputService.InputBegan:Connect(function(input, typing)
	if not SaveData.KeybindsEnabled then return end
	if typing then return end
	if input.UserInputType == Enum.UserInputType.Keyboard then
		HandleKeybind(input.KeyCode.Name)
	end
end)

if type(SaveData.ModuleConfigs) ~= "table" then
	SaveData.ModuleConfigs = {}
end
local function GetModuleHash(m)
	if m.Hash then return m.Hash end
	local str = m.Name .. ":3/:3" .. m.Description
	str = buffer.fromstring(string.rep(str, 8))
	local hash = {36, 91, 225, 10, 232, 117, 96, 243, 93, 128, 61, 97, 101, 120, 130, 69, 177, 80, 131, 27, 137, 242, 155, 245, 22, 123, 197, 145, 146, 206, 157, 20}
	local off = buffer.readu8(str, 0) % 32
	local l = buffer.len(str)
	for i=1, l do
		local j = ((off + i) % 32) + 1
		hash[j] = bit32.bxor(hash[j], buffer.readu8(str, i - 1)) % 256
	end
	str = ""
	local hex = {"0","1","2","3","4","5","6","7","8","9","A","B","C","D","E","F"}
	for i=1, #hash do
		local x = hash[i]
		local a, b = x % 16, x // 16
		str ..= hex[b + 1] .. hex[a + 1]
	end
	m.Hash = str
	return str
end
local function AddMoveset(m)
	if type(m) == "table" then
		if not m.Name then return end
		if not m.Description then return end
		if not m.Config then return end
		if not m.Assets then return end
		if not m.Init then return end
		if not m.Update then return end
		if not m.Destroy then return end
		GetModuleHash(m)
		if m.LoadConfig then
			if SaveData.ModuleConfigs[m.Hash] then
				pcall(m.LoadConfig, SaveData.ModuleConfigs[m.Hash])
			end
		end
		table.insert(MovementStyles, m)
		local item = UI.CreateItemListItem(MovesetsPage.List)
		local msname = UI.CreateText(item, m.Name .. " &gt;", 20, Enum.TextXAlignment.Left)
		local msdesc = UI.CreateText(item, string.split(m.Description, "\n")[1], 12, Enum.TextXAlignment.Left)
		msname.Name = "LabelName"
		msdesc.Name = "LabelDesc"
		item.Parent.Name = m.Name .. " " .. m.Description
		Util.LinkDestroyI2C(item, item.Activated:Connect(function()
			local page = UI.CreatePage()
			page.ZIndex = 2
			page.Position = UDim2.new(0.5, 360, 0.5, 0)
			page.Interactable = false
			page.Visible = true
			UI.CreateButton(page, " &lt; Hurry back", 20).Activated:Connect(function()
				page.Interactable = false
				MovesetsPage.Interactable = false
				local tween = TweenService:Create(page, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
					Position = UDim2.new(0.5, 360, 0.5, 0),
				})
				tween:Play()
				tween.Completed:Connect(function()
					MovesetsPage.Interactable = true
					page:Destroy()
				end)
			end)
			UI.CreateSeparator(page)
			UI.CreateText(page, m.Name, 20, Enum.TextXAlignment.Left)
			UI.CreateText(page, m.Description, 15, Enum.TextXAlignment.Left)
			local equip, equiptext = UI.CreateButton(page, "Use Moveset", 20)
			if MovementStyleIndex == table.find(MovementStyles, m) then
				equiptext.Text = "* ACTIVE *"
			end
			equip.Activated:Connect(function()
				equiptext.Text = "* ACTIVE *"
				MovementStyleIndex = table.find(MovementStyles, m)
			end)
			UI.CreateSeparator(page)
			UI.CreateText(page, "* Configuration *", 15, Enum.TextXAlignment.Center)
			m.Config(page)
			MovesetsPage.Interactable = false
			local tween = TweenService:Create(page, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.In), {
				Position = UDim2.new(0.5, 0, 0.5, 0),
			})
			tween:Play()
			tween.Completed:Connect(function()
				page.Interactable = true
			end)
		end))
	end
end
local function AddDance(m)
	if type(m) == "table" then
		if not m.Name then return end
		if not m.Description then return end
		if not m.Assets then return end
		if not m.Config then return end
		if not m.Init then return end
		if not m.Update then return end
		if not m.Destroy then return end
		GetModuleHash(m)
		if m.LoadConfig then
			if SaveData.ModuleConfigs[m.Hash] then
				pcall(m.LoadConfig, SaveData.ModuleConfigs[m.Hash])
			end
		end
		table.insert(DanceableDances, m)
		local item = UI.CreateItemListItem(DancesPage.List)
		local msname = UI.CreateText(item, m.Name .. " &gt;", 20, Enum.TextXAlignment.Left)
		local msdesc = UI.CreateText(item, string.split(m.Description, "\n")[1], 12, Enum.TextXAlignment.Left)
		msname.Name = "LabelName"
		msdesc.Name = "LabelDesc"
		item.Parent.Name = m.Name .. " " .. m.Description
		Util.LinkDestroyI2C(item, item.Activated:Connect(function()
			local page = UI.CreatePage()
			page.ZIndex = 2
			page.Position = UDim2.new(0.5, 360, 0.5, 0)
			page.Interactable = false
			page.Visible = true
			UI.CreateButton(page, " &lt; Hurry back", 20).Activated:Connect(function()
				page.Interactable = false
				DancesPage.Interactable = false
				local tween = TweenService:Create(page, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
					Position = UDim2.new(0.5, 360, 0.5, 0),
				})
				tween:Play()
				tween.Completed:Connect(function()
					DancesPage.Interactable = true
					page:Destroy()
				end)
			end)
			UI.CreateSeparator(page)
			UI.CreateText(page, m.Name, 20, Enum.TextXAlignment.Left)
			UI.CreateText(page, m.Description, 15, Enum.TextXAlignment.Left)
			local equip, equiptext = UI.CreateButton(page, "Play Dance", 20)
			if CurrentDance == m then
				equiptext.Text = "Stop Dance"
			end
			equip.Activated:Connect(function()
				if CurrentDance == m then
					equiptext.Text = "Play Dance"
					CurrentDance = nil
				else
					equiptext.Text = "Stop Dance"
					CurrentDance = m
				end
			end)
			UI.CreateSeparator(page)
			UI.CreateText(page, "* Configuration *", 15, Enum.TextXAlignment.Center)
			m.Config(page)
			DancesPage.Interactable = false
			local tween = TweenService:Create(page, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.In), {
				Position = UDim2.new(0.5, 0, 0.5, 0),
			})
			tween:Play()
			tween.Completed:Connect(function()
				page.Interactable = true
			end)
		end))
	end
end
local function AddModule(func)
	GiveFunctionsToFunction(func)
	local m = func()
	if m and type(m) == "table" then
		if m.ModuleType == "MOVESET" then
			AddMoveset(m)
		elseif m.ModuleType == "DANCE" then
			AddDance(m)
		else
			error("Unknown ModuleType for Module!")
		end
	else
		error("Module return value is not a table. Got " .. typeof(m) .. " instead.")
	end
end
local function AddModules(list)
	if type(list) == "table" then
		for i=1, #list do
			AddModule(list[i])
			task.wait()
		end
	end
end
task.spawn(function()
	local function SaveConfig(m)
		if m.SaveConfig then
			local s, data = pcall(m.SaveConfig)
			if s and data then
				local s2, p = pcall(HttpService.JSONEncode, HttpService, data)
				if s2 and p then
					SaveData.ModuleConfigs[m.Hash] = data
					return
				else
					warn(p)
				end
			else
				warn(data)
			end
			Util.Notify("Failed to save " .. m.Name .. "'s config")
		end
	end
	while task.wait(5) do
		for _,m in MovementStyles do
			SaveConfig(m)
		end
		for _,m in DanceableDances do
			SaveConfig(m)
		end
	end
end)
task.spawn(function()
	local _oldcharacterreference = nil
	local errorsandwarnings = {}
	local currenterrorid = 1
	while true do local dt = RunService.Heartbeat:Wait() xpcall(function(dt)
		local ReanimCharacter = Reanimate.Character
		SaveData.MovesetIndex = MovementStyleIndex
		if ReanimCharacter then
			if _oldcharacterreference ~= ReanimCharacter then
				SetOverrideMovesetMusic(nil)
				SetOverrideDanceMusic(nil)
				if CurrentMovementStyle then
					pcall(CurrentMovementStyle.Destroy, nil)
					CurrentMovementStyle = nil
				end
				if _CurrentDance then
					pcall(_CurrentDance.Destroy, nil)
					_CurrentDance = nil
				end
				_MovementStyleIndex = nil
			end
			if MovementStyleIndex ~= _MovementStyleIndex then
				if CurrentMovementStyle then
					CurrentMovementStyle.Destroy(ReanimCharacter)
					CurrentMovementStyle = nil
				end
				_MovementStyleIndex = MovementStyleIndex
				CurrentMovementStyle = MovementStyles[MovementStyleIndex]
				SetOverrideMovesetMusic(nil)
				if ReanimCharacter:GetAttribute("MovementInit") then
					Reanimate.CreateCharacter()
					ReanimCharacter = Reanimate.Character
				end
			end
			if CurrentMovementStyle then
				if ReanimCharacter:GetAttribute("MovementInit") then
					CurrentMovementStyle.Update(dt, ReanimCharacter)
					if CurrentDance ~= _CurrentDance then
						if _CurrentDance then
							pcall(_CurrentDance.Destroy, ReanimCharacter)
						end
						_CurrentDance = CurrentDance
						ReanimCharacter:SetAttribute("IsDancing", nil)
						ReanimCharacter:SetAttribute("DanceInternalName", nil)
						SetOverrideDanceMusic(nil)
					end
					if _CurrentDance then
						if ReanimCharacter:GetAttribute("IsDancing") then
							_CurrentDance.Update(dt, ReanimCharacter)
						else
							if AssetEnsure(_CurrentDance.Assets) then
								ReanimCharacter:SetAttribute("IsDancing", true)
								ReanimCharacter:SetAttribute("DanceInternalName", _CurrentDance.InternalName)
								_CurrentDance.Init(ReanimCharacter)
							else
								SetOverrideDanceMusic(nil)
							end
						end
					end
				else
					HatReanimator.HatWeldOverride = {}
					if AssetEnsure(CurrentMovementStyle.Assets) then
						ReanimCharacter:SetAttribute("MovementInit", true)
						ReanimCharacter:SetAttribute("MovesetInternalName", CurrentMovementStyle.InternalName)
						table.clear(HatReanimator.HatCFrameOverride)
						CurrentMovementStyle.Init(ReanimCharacter)
					else
						SetOverrideMovesetMusic(nil)
					end
				end
			else
				ReanimCharacter:SetAttribute("MovementInit", nil)
				_MovementStyleIndex = nil
			end
		else
			CurrentDance = nil
			_MovementStyleIndex = nil
			SetOverrideMovesetMusic(nil)
			SetOverrideDanceMusic(nil)
			if CurrentMovementStyle then
				CurrentMovementStyle.Destroy(nil)
				CurrentMovementStyle = nil
			end
			if _CurrentDance then
				_CurrentDance.Destroy(nil)
				_CurrentDance = nil
			end
		end
		_oldcharacterreference = ReanimCharacter
	end, function(m)
		m = debug.traceback("ANIMLOOP :: " .. m)
		local id = errorsandwarnings[m]
		if not id then
			errorsandwarnings[m] = {currenterrorid, 0}
			currenterrorid += 1
			warn("ERROR #" .. errorsandwarnings[m][1] .. ": " .. m)
		else
			id[2] += 1
			if id[2] <= 8192 and math.sqrt(id[2]) % 1 == 0 then
				warn("ERROR #" .. id[1] .. " repeated " .. id[2] .. " times")
			end
		end
	end, dt) end
end)
UI.CreateSeparator(MainPage)
task.wait()
local CreditsPage = UI.CreatePage()
CreditsPage.ZIndex = 1
CreditsPage.Position = UDim2.new(0.5, 360, 0.5, 0)
CreditsPage.Interactable = false
CreditsPage.Visible = false
UI.CreateButton(MainPage, "Credits", 15).Activated:Connect(function()
	CreditsPage.Interactable = false
	CreditsPage.Visible = true
	MainPage.Interactable = false
	local tween = TweenService:Create(CreditsPage, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.In), {
		Position = UDim2.new(0.5, 0, 0.5, 0),
	})
	tween:Play()
	tween.Completed:Connect(function()
		CreditsPage.Interactable = true
	end)
end)
UI.CreateButton(CreditsPage, "&lt; Hurry back", 20).Activated:Connect(function()
	CreditsPage.Interactable = false
	MainPage.Interactable = false
	local tween = TweenService:Create(CreditsPage, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
		Position = UDim2.new(0.5, 360, 0.5, 0),
	})
	tween:Play()
	tween.Completed:Connect(function()
		MainPage.Interactable = true
		CreditsPage.Visible = false
	end)
end)
local UhhhhhhFire = UI.CreateText(CreditsPage, "", 12, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "Reanimate by STEVE :D", 15, Enum.TextXAlignment.Right)
local UhhhhhhFiret = UI.CreateSlider(CreditsPage, "Transparency", 0.25, 0, 1, 0)
local UhhhhhhFirep = {}
for i=1, 64 do
	table.insert(UhhhhhhFirep, {i / 64, 0.98 + math.random() * 0.04, math.random(), math.random() - 0.5})
end
local UhhhhhhFirea = {
	"XX    XX XX      XX      XX      XX      XX      XX     ",
	"XX    XX XX      XX      XX      XX      XX      XX     ",
	"XX    XX XXXXXX  XXXXXX  XXXXXX  XXXXXX  XXXXXX  XXXXXX ",
	"XX    XX XX   XX XX   XX XX   XX XX   XX XX   XX XX   XX",
	"XXX  XXX XX   XX XX   XX XX   XX XX   XX XX   XX XX   XX",
	" XXXXXX  XX   XX XX   XX XX   XX XX   XX XX   XX XX   XX",
}
local UhhhhhhFirex = #UhhhhhhFirea[1]
local UhhhhhhFirey = #UhhhhhhFirea
AddToRenderStep(function(t, dt)
	local radius = 0.1
	local ratio = (UhhhhhhFirey / UhhhhhhFirex) * 1.75
	if Util.IsGuiVisible(UhhhhhhFire) then
		local tr = math.clamp(UhhhhhhFiret.Value, 0, 1)
		local pp = {}
		for _,v in UhhhhhhFirep do
			v[1] += dt * v[2]
			if v[1] >= 1 then
				v[1], v[2], v[3], v[4] = 0, 0.98 + math.random() * 0.04, math.random(), math.random() - 0.5
			end
			table.insert(pp, {1 - v[1], v[3] + v[4] * v[1] * 0.25, (1 - v[1]) * (1 + radius / ratio)})
		end
		local aa = {}
		for y=1, UhhhhhhFirey do
			local a = ""
			for x=1, UhhhhhhFirex do
				local b = UhhhhhhFirea[y]:sub(x, x)
				if b == " " and tr < 0.1 then
					a ..= " "
				else
					local bright = 0
					local x1, y1 = x / UhhhhhhFirex, y / UhhhhhhFirey
					for _,v in pp do
						local x2, y2 = v[2], v[3]
						local x3, y3 = x2 - x1, (y2 - y1) * ratio
						local a = math.max(0, 1 - math.sqrt(x3 * x3 + y3 * y3) / radius) * v[1];
						bright += (1.0 - bright) * math.pow(a, 1.5);
					end
					if b == " " then bright *= tr end
					if bright > 0.9 then
						a ..= "Q";
					elseif bright > 0.8 then
						a ..= "W";
					elseif bright > 0.7 then
						a ..= "#";
					elseif bright > 0.6 then
						a ..= "S";
					elseif bright > 0.5 then
						a ..= "l";
					elseif bright > 0.4 then
						a ..= "v";
					elseif bright > 0.3 then
						a ..= "|";
					elseif bright > 0.2 then
						a ..= ";";
					elseif bright > 0.1 then
						a ..= ".";
					else
						a ..= " ";
					end
				end
			end
			table.insert(aa, a)
		end
		UhhhhhhFire.Text = table.concat(aa, "\n")
		pp = nil
	end
end)
UI.CreateSeparator(CreditsPage)
UI.CreateText(CreditsPage, "<b>* Credits to *</b>", 15, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "<b>rez aka @chiptune</b>", 14, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "wow cool 64k demos, great inspiration", 12, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "<b>AALib & BB Demo</b>", 14, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "artificial ascii art cool!", 12, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "no transformer needed lol", 12, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "<b>Polariaus</b>", 14, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "isnt reanimation dead? oh hats.", 12, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "also ur like a fast bug hunter", 12, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "<b>Awesome Awes955</b>", 14, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "u run out of ideas", 12, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "but i dont, cuz u give me ideas", 12, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "<b>" .. (math.random() < 0.67 and "Tatsuki" or "Kaylie") .. "</b>", 14, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "u needed help, u paid it back well", 12, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "somehow u got me in touch with MyWorld", 12, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "<b>MyWorld</b>", 14, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "so thats how netless really works", 12, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "math.max is THE solution here!!", 12, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "also, hey, pwease unban me from Hax Updates >m<", 12, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "<b>Krystal Dance V3 mod by Theo</b>", 14, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "nice dance animations. MINE NOW!! >:D", 12, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "<b>Delta Executor</b>", 14, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "primary env target", 12, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "thanks for disabling the key system temporarily when its down", 12, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "happened fast lol", 12, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "<b>Dubmood</b>", 14, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "u and rez REALLY need to collab again or smth", 12, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "the scene is dead was (and still is) so cool!!!", 12, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "<b>4mat</b>", 14, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "pls dont kick dubmood's ass lol", 12, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "<b>pouet.net</b>", 14, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "other than rez' and anat's demos theres lots of good demos there", 12, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "tho im considered a LAMER with no scene ID loool", 12, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "so uhhhhhh....", 12, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "...greetings to lamers and fuckings to elites?", 12, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "<b>github.com</b>", 14, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "YES!! KEEP SAVING ME FROM MY DATA CORRUPTION!!!", 12, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "no i dont want ur stupid ai subscription", 12, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "<b>Those require script databases</b>", 14, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "bro 99% of the characters are LORELESS and SILENT", 12, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "<b>my math teacher</b>", 14, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "i LOVE your method of teaching! its fun!!", 12, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "<b>return_request</b>", 14, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "what is DisconnectVerboselyModeratedGame again?", 12, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "also when pissstrap release (and banstrap)", 12, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "<b>Termux</b>", 14, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "what a great \"distro\", will u add open document api?", 12, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "<b>anthonyisnthere</b>", 14, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "who r u again? oh ur the one who made skidfling in ur github", 12, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "<b>adamxdd690</b>", 14, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "hey did u get a new phone yet? cuz ur great!!", 12, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "<b>indexFailed</b>", 14, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "thats a good lua code snippet trade :)", 12, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "<b>Roblox</b>", 14, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "this program's primary target", 12, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "expose more backend functions for me like a good boy", 12, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "<b>rqz's Genesis FE</b>", 14, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "ill be taking ALL your convertions >:D", 12, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "actually, im just taking the names, search it up on script sources, read the source, convert it and stuff then done", 12, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "<font color=\"#4444FF\"><b>Empyrean Reanimate (click for Discord)</b></font>", 12, Enum.TextXAlignment.Center).InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		Util.Notify("Link copied!")
		pcall(setclipboard, "https://discord.gg/UJ7YtqadPJ")
		pcall(request, {
			Url = "http://127.0.0.1:6463/rpc?v=1",
			Method = "POST",
			Headers = {
				["Content-Type"] = 'application/json',
				["Origin"] = "https://discord.com",
			},
			Body = HttpService:JSONEncode({
				cmd = "INVITE_BROWSER",
				nonce = HttpService:GenerateGUID(false),
				args = {code = "UJ7YtqadPJ"},
			}),
		})
	end
end)
UI.CreateText(CreditsPage, "your tool fling is great reference!", 12, Enum.TextXAlignment.Center)
UI.CreateSeparator(CreditsPage)
UI.CreateText(CreditsPage, "<b>* Greetings to *</b>", 15, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "fev, inno, rqz, mry7zz, theo, redactedre, colon", 12, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "terminal, guinwah, kasil, hamza, nexus, hoster", 12, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "hamoun, baze, luacope, 2024, 2023 and 2022 me", 12, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "scout, edge, shownape, index, blackhole/whitehole", 12, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "zero from iwbtc for no reason, presidentanvil, mech/catlover", 12, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "return from fishstrap, erika, skeltoun", 12, Enum.TextXAlignment.Center)
UI.CreateSeparator(CreditsPage)
UI.CreateText(CreditsPage, "<b>* Very random quotes *</b>", 15, Enum.TextXAlignment.Center)
do
	local quotes = {
		"anthonyisnthere: \":fasttrack Luacope\"\n(funny because most of the music in this script is made in FastTracker II)",
		"hemi once said: \"hat collide has never worked on perma\"",
		"skids after genesis adds a minimize button: \"REVOLUTIONARY\"",
		"\"roblox banned my leg\" sounds the same in any context",
		"what is a 0x1b packet hack? cuz idk wattahel that is", -- oh its some raknet
		"\"i have real fe bypass but i cant show here cuz roblox will detect and patch you have to join me in my game\"",
		"my income is 2 dollars. i shall DELETE /self now /j",
		"obfuscator: gifted power\nreal-time registry dumper: pure effort",
		"always flinging kdrv3 users (they think they'll have antifling)",
		"im gonna fling you. *turns your screen black*",
		"headcanon: \"Lightning Cannon is a top.\"",
		"\"dont bpt ples\" \"brick portationtele?\"",
		"WHO CARES IF A FEW TREES ARE DYING!?",
		"while i was in mwtp, someone said \"leak the hatdrop script\"",
		"i was in fencing, then someone said \"its the genesis killer\"",
		"STEVE, THE DANCING IMMORTALITY LORD!",
		"\"kid im filipino\" - " .. (math.random() < 0.67 and "Tatsuki" or "Kaylie"),
		"imagine getting ur script mogged by a script written and tested mostly on a mobile phone LOL",
		"shownskid",
		"this script mogs genesis", -- true-untrue though
		"\"Tired of your hats phasing through people? Uhhhhhh turns that fact upside-down!\"",
		"\"The best part? It is FREE!! (excluding the taxes and bills) Now, BUY OUR PRODUCT FOR FREE! We know you like it! We know you do.\"",
		"Does anyone ever physically look upwards when they think of ideas? I definitely don't.",
		"\"It's not even another Reanimate; it just uses Emper Reanimate. So you can change the name to 'uhhhh hub', that's it.\"",
		"i wrote this during permadeath's patch. my members are so quick in reporting bugs and stuff lol",
		"i plead the six seventh amendment",
		"\"i have strong network ownership that can take big buildings\" \"i have strong network too\" *61 MBPS*",
	}
	for _=1, 15 do
		local idx = math.random(1, #quotes)
		UI.CreateText(CreditsPage, table.remove(quotes, idx), 12, Enum.TextXAlignment.Center)
	end
end
UI.CreateSeparator(CreditsPage)
UI.CreateText(CreditsPage, "DISCLAIMER: Some random quotes made here are jokes (e.g.: 'this script mogs genesis') and should not be taken seriously. This also includes all the self-glazing quotes. It's your choice to agree with them or not, and if you do or don't, don't come harass/mock any individuals from it. In the end, a joke quote is a joke quote.", 15, Enum.TextXAlignment.Center)
UI.CreateSeparator(CreditsPage)
UI.CreateText(CreditsPage, "This \"software\" is FREE, meaning YOU SHOULD NOT REDISTRIBUTE WITH RENUMERATIVE INTENT!!", 15, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "If you want to add content to Uhhhhhh, like Dances or Movesets, go to <font color=\"#4444FF\">this thing</font>.", 15, Enum.TextXAlignment.Center).InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		Util.Notify("Link copied!")
		pcall(setclipboard, "https://github.com/STEVE-916-create/Uhhhhhh/")
	end
end)
UI.CreateSeparator(CreditsPage)
UI.CreateText(CreditsPage, "<b>(C) 2026 STEVETHEREALONE</b>", 14, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "all rights reserved", 14, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "<font color=\"#4444FF\">[ Discord invite ]</font>", 15, Enum.TextXAlignment.Center).InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		Util.Notify("Link copied!")
		pcall(setclipboard, "https://discord.gg/NASNUKRBVM")
		pcall(request, {
			Url = "http://127.0.0.1:6463/rpc?v=1",
			Method = "POST",
			Headers = {
				["Content-Type"] = 'application/json',
				["Origin"] = "https://discord.com",
			},
			Body = HttpService:JSONEncode({
				cmd = "INVITE_BROWSER",
				nonce = HttpService:GenerateGUID(false),
				args = {code = "NASNUKRBVM"},
			}),
		})
	end
end)
local ChangelogsPage = UI.CreatePage()
ChangelogsPage.ZIndex = 1
ChangelogsPage.Position = UDim2.new(0.5, 360, 0.5, 0)
ChangelogsPage.Interactable = false
ChangelogsPage.Visible = false
UI.CreateButton(MainPage, "Changelogs", 15).Activated:Connect(function()
	ChangelogsPage.Interactable = false
	ChangelogsPage.Visible = true
	MainPage.Interactable = false
	local tween = TweenService:Create(ChangelogsPage, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.In), {
		Position = UDim2.new(0.5, 0, 0.5, 0),
	})
	tween:Play()
	tween.Completed:Connect(function()
		ChangelogsPage.Interactable = true
	end)
end)
UI.CreateButton(ChangelogsPage, "&lt; Hurry back", 20).Activated:Connect(function()
	ChangelogsPage.Interactable = false
	MainPage.Interactable = false
	local tween = TweenService:Create(ChangelogsPage, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
		Position = UDim2.new(0.5, 360, 0.5, 0),
	})
	tween:Play()
	tween.Completed:Connect(function()
		MainPage.Interactable = true
		ChangelogsPage.Visible = false
	end)
end)
task.spawn(function()
	UI.CreateText(ChangelogsPage, "Changelogs", 30, Enum.TextXAlignment.Center)
	local content = UI.CreateText(ChangelogsPage, "Loading...", 12, Enum.TextXAlignment.Left)
	xpcall(function()
		local logs = game:HttpGet("https://raw.githubusercontent.com/STEVE-916-create/Uhhhhhh/main/CHANGELOGS")
		content.Text = "Rendering error."
		for _,v in string.split(logs, "\n") do
			if v:sub(1, 2) == "# " then
				UI.CreateText(ChangelogsPage, "<b>" .. v:sub(3) .. "</b>", 15, Enum.TextXAlignment.Left)
			else
				UI.CreateText(ChangelogsPage, v, 12, Enum.TextXAlignment.Left)
			end
		end
		content.Parent:Destroy()
	end, function()
		content.Text = "ERROR: Could not fetch"
	end)
end)
UI.CreateText(MainPage, "\n\n\n<b>DANGER ZONE</b>", 15, Enum.TextXAlignment.Center)
local clearcontenthash, clearcontenthashtext = UI.CreateButton(MainPage, "CLEAR ALL DOWNLOADED CONTENT", 15)
local clearcontenthashclicks = 0
clearcontenthash.Activated:Connect(function()
	clearcontenthashclicks += 1
	if clearcontenthashclicks == 1 then
		clearcontenthashtext.Text = "ARE YOU SURE ABOUT THAT!?"
		task.wait(1)
		if clearcontenthashclicks == 1 then
			clearcontenthashclicks = 0
		end
	elseif clearcontenthashclicks == 2 then
		clearcontenthashtext.Text = "VERY SURE??????"
		task.wait(1)
		if clearcontenthashclicks == 2 then
			clearcontenthashclicks = 0
		end
	elseif clearcontenthashclicks == 3 then
		SaveData.ContentHash = nil
		clearcontenthashtext.Text = "Cleared, now rejoin to apply"
	end
end)
task.wait()
Util.Notify("Checking SHA1 Hashes...")
local filesofbuiltins = {"v_moveset1.lua", "v_moveset2.lua", "v_moveset3.lua", "v_dance1.lua", "v_dance2.lua", "d_limbmap.lua", "d_hatsmap.lua"}
local filesofbuiltins_m = {"v_moveset1.lua", "v_moveset2.lua", "v_moveset3.lua", "v_dance1.lua", "v_dance2.lua"}
local filesofbuiltins_d = {"d_limbmap.lua", "d_hatsmap.lua"}
SaveData.ContentHash = SaveData.ContentHash or {}
xpcall(function()
	local s, resp = pcall(request, {
		Method = "GET",
		Url = "https://api.github.com/repos/STEVE-916-create/Uhhhhhh/contents/content/",
	})
	if s and resp and resp.StatusCode == 200 then
		s, resp = pcall(HttpService.JSONDecode, HttpService, resp.Body)
		if s and resp then
			for _,file in resp do
				if file.name and file.sha then
					if SaveData.ContentHash[file.name] ~= file.sha then
						SaveData.ContentHash[file.name] = file.sha
						if table.find(filesofbuiltins, file.name) then
							local path = "UhhhhhhReanim/BuiltinModules/" .. file.name
							if isfile(path) then
								delfile(path)
							end
						else
							local path = AssetGetPathFromFilename(file.name)
							if isfile(path) then
								delfile(path)
							end
						end
					end
				end
			end
		end
	end
end, function()
	Util.Notify("Failed to check for SHA1 hashes...")
end)
local wasold = false
if SaveData.VanillaModuleCache then
	wasold = true
	SaveData.VanillaModuleCache = nil
end
local function getgithubraw(path)
	local s, resp = pcall(request, {
		Method = "GET",
		Url = "https://api.github.com/repos/STEVE-916-create/Uhhhhhh/contents/content/" .. path,
		Headers = {
			Accept = "application/vnd.github.VERSION.raw"
		}
	})
	if s and resp and resp.StatusCode == 200 then
		return resp.Body
	end
	s, resp = pcall(request, {
		Method = "GET",
		Url = "https://raw.githubusercontent.com/STEVE-916-create/Uhhhhhh/main/contents/content/" .. path,
	})
	if s and resp and resp.StatusCode == 200 then
		return resp.Body
	end
	return nil
end
Util.Notify("Loading maps...")
for _,x in filesofbuiltins_d do
	local path = "UhhhhhhReanim/BuiltinModules/" .. x
	local exist = false
	local s, a = pcall(isfile, path)
	if s and a then exist = true end
	if not exist then
		local content = getgithubraw(x)
		if content then
			pcall(writefile, path, content)
		else
			Util.Notify("Failed to load " .. x .. ": Download failed.")
			SaveData.ContentHash[x] = nil
		end
	end
end
Util.Notify("Loading builtin modules...")
for _,x in filesofbuiltins_m do
	local path = "UhhhhhhReanim/BuiltinModules/" .. x
	local exist = false
	local s, a = pcall(isfile, path)
	if s and a then exist = true end
	if wasold then exist = false end
	local data = ""
	if exist then
		data = readfile(path)
		task.wait()
	else
		local content = getgithubraw(x)
		if content then
			pcall(writefile, path, content)
			data = content
		else
			Util.Notify("Failed to load " .. x .. ": Download failed.")
			SaveData.ContentHash[x] = nil
		end
	end
	task.wait()
	xpcall(function()
		local func, comperr = loadstring(data, "Uhhhhhh :: VANILLA " .. x)
		if func then
			AddModules(func())
		elseif comperr then
			error("COMPILE FAILED: " .. comperr)
		end
	end, function(msg)
		warn(debug.traceback("VANILLA " .. x .. ": " .. msg))
		Util.Notify("Failed to load " .. x .. ", see console.")
	end)
end
-- user
Util.Notify("Loading user modules...")
for _,path in listfiles("UhhhhhhReanim/Modules/") do
	if isfile(path) then
		--Util.Notify("User: " .. path:sub(23))
		xpcall(function()
			local func, comperr = loadstring(readfile(path), "Uhhhhhh :: " .. path:sub(23))
			if func then
				AddModules(func())
			elseif comperr then
				error("COMPILE FAILED: " .. comperr)
			end
		end, function(msg)
			warn(debug.traceback(path .. ": " .. msg))
			Util.Notify("Failed to load " .. path:sub(23) .. ", see console.")
		end)
	end
end
RefreshKeybinds()
Util.Notify("Init complete")

IsUhhhhhhFullyLoaded = true