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
		"gd_tidalwave.syn.mp3",
		"fr_keygen31.ft2.mp3",
		"lightinursoul.graphic.png",
		"letriangul.graphic.png",
		"wearegenesis.graphic.png",
		"newgen_sceneA1.graphic.png",
		"newgen_sceneA2.graphic.png",
		"newgen_sceneB1.graphic.png",
		"newgen_sceneB2.graphic.png",
		"newgen_text1.graphic.png",
		"newgen_text2.graphic.png",
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
		Util.ForceTextSize(Downloading)
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
	{"gd_tidalwave.syn.mp3", "Dion Timmer - Shiawase"},
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
			i = math.random(1, #MusicPlayer.Database - 1)
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
	MusicPlayer.PlayMusic(#MusicPlayer.Database)
	repeat RunService.RenderStepped:Wait() until UISound.Music.IsLoaded
	UISound.Music:Stop()
	task.wait()
	UISound.Music:Play()
	TweenService:Create(UISound.Music, TweenInfo.new(1), {Volume = 1}):Play()
	UISound.Music.TimePosition = 32
	local scrolltexts = {
		"stevetherealone presents a script                                 ",
		"hi guys welcome to my game                                        ",
		"holy shit where did our friends go?               *gets vc warned*",
		"greetings to qpmbsjbvt for getting me into reanimation            ",
		"those who know the place called ajman, dubai, uae                 ",
		":3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 >:3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3 :3",
		"quick intro        with quick scrolltext         and you will miss the punchline              punchline                did you get the punchline?  ",
		"meeeooowwwwwwwwww >:3                                          maw",
		"wwwwwwwwwwwwwwwwwww                         grass                 ",
		"erika's the towers                            sfoth iv update when",
		"i will leak all ur script i will leak all ur script i will leak al",
		"kasil loves gooning to everybody                                  ",
		"fflags are dead lol                                               ",
		"imagine being called a dummy                                      ",
		"hi                          ...                oxide more like sui",
		"even if I mope, nothing good will happen! if i worked hard today, today will be perfecto!",
		"hi                          ...                                   ",
		"who the fuck even reads this??                     hi guys        ",
		"          trust me the ui looks good             here it comes    ",
		"dying is scary, but living is difficult                               dying: gifted scary; living: pure difficult",
		"but i halter my forethought, i keep on running like a chicken with his dih",
		"kaiya sounds like a perfect name for a genshin impact character   ",
		"this is an intro lol                        ",
		"greetings to myworld for helping with -net less                   ",
		"Omega-Skidded Immortality Lord Diddy Blud On The Calculator       ",
		"all UI music credits to dubmood, zabutom, ogge, 4mat and hoster   ",
		"heres the triforce                and heres my name                              ",
		"skids are now taking credit of this entire script, meaning its so good           ",
		"skids, be alert, go to weao.xyz for your roblox hacks!            ",
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
	TweenService:Create(scrolltext, TweenInfo.new(5, Enum.EasingStyle.Linear), {
		Position = UDim2.new(1, 0, 0.5, 0),
		AnchorPoint = Vector2.new(1, 0.5),
	}):Play()
	local scrolltextratio = scrolltext.Size.X.Offset / scrolltext.Size.Y.Offset
	local Triforce1 = Util.MakeTriforce(7, Color3.new(1, 0.7, 0), 4)
	local Triforce2 = Util.MakeTriforce(7, Color3.new(0.8, 0.4, 0), 4)
	Triforce1.ZIndex = 2
	Triforce2.ZIndex = 1
	Triforce1.Parent = UIMainFrame
	Triforce2.Parent = UIMainFrame
	local TRI_offset = 0.01
	local TRI_height = 0.5
	local TRI_rot = 0
	local TRI_rotvel = 720
	local TRI_scale = 0
	local ratioright = Util.Instance("Frame", UIMainFrame)
	ratioright.AnchorPoint = Vector2.new(0, 0)
	ratioright.Position = UDim2.new(0, 0, 0, 0)
	ratioright.Size = UDim2.new(2.26071428571, 0, 1, 0)
	ratioright.BackgroundTransparency = 1
	ratioright.Interactable = false
	local stevetherealone = Util.Instance("TextLabel", ratioright)
	stevetherealone.TextScaled = true
	stevetherealone.Font = Enum.Font.Arcade
	stevetherealone.TextColor3 = Color3.new(1, 1, 1)
	stevetherealone.BackgroundColor3 = Color3.new(0, 0, 0)
	stevetherealone.BackgroundTransparency = 0
	stevetherealone.BorderColor3 = Color3.new(1, 1, 1)
	stevetherealone.BorderSizePixel = 8
	stevetherealone.AnchorPoint = Vector2.new(0.5, 0.5)
	stevetherealone.Position = UDim2.new(0.5, 0, 0.5, 0)
	stevetherealone.Size = UDim2.fromOffset(100, 100)
	stevetherealone.Text = "STEVE\nTHERE\nALONE"
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