local modules = {}
table.insert(modules,     function()
    	local m = {}
    
    	m.ModuleType  = "DANCE"
    	m.Name        = "One Two Three"
    	m.Description = "One two three de arukidase!\n \nAdded flipped version why not?"
    	m.Assets = {"nil_123.anim@https://github.com/czmalio291/Mkaxss/raw/refs/heads/main/goodies/contents/nil_123.anim", "nil_123_F.anim@https://github.com/czmalio291/Mkaxss/raw/refs/heads/main/goodies/contents/nil_123_F.anim", "nil_123.mp3@https://github.com/czmalio291/Mkaxss/raw/refs/heads/main/goodies/contents/nil_123.mp3"}
    
    	m.Flip = false
    	m.Config = function(parent)
    		Util_CreateSwitch(parent, "Flipped vers", m.Flip).Changed:Connect(function(val)
    			m.Flip = val
    		end)
    	end
    
    	m.LoadConfig = function(save: any)
    		m.Flip = not not save.Flip
    	end
    
    	m.SaveConfig = function()
    		return {
    			Flip = m.Flip
    		}
    	end
    
    	local animator = nil
    	local start = 0
    
    	m.Init = function(figure: Model)
    		SetOverrideDanceMusic(AssetGetContentId("nil_123.mp3"))
    
    		start = os.clock()
    		animator        = AnimLib.Animator.new()
    		animator.rig    = figure
    		animator.looped = true
    		animator.speed  = 1
    		if m.Flip then
    			animator.track = AnimLib.Track.fromfile(AssetGetPathFromFilename("nil_123_F.anim"))
    		else
    			animator.track = AnimLib.Track.fromfile(AssetGetPathFromFilename("nil_123.anim"))
    		end
    	end)
table.insert(modules,     function(dt, figure)
    		animator:Step(os.clock() - start)
    	end)
table.insert(modules,     function(dt: number, figure: Model)
    		animator:Step(GetOverrideDanceMusicTime())
    	end)
table.insert(modules,     function(figure)
    		animator = nil
    	end)
table.insert(modules,     function()
    	local m = {}
    
    	m.ModuleType  = "DANCE"
    	m.Name        = "24 Hours Cinderella"
    	m.Description = "Step and Go!"
    	m.Assets = {"nil_Cinderella.anim@https://github.com/czmalio291/Mkaxss/blob/main/goodies/contents/nil_Cinderella.anim", "nil_Cinderella.mp3@https://github.com/czmalio291/Mkaxss/blob/main/goodies/contents/nil_Cinderella.mp3"}
    
    	m.Config = function(parent)
    		Util_CreateText(parent, "No settings.", 14, Enum.TextXAlignment.Center)
    	end
    
    	m.SaveConfig = function() return {} end
    	m.LoadConfig  = function(save) end
    
    	local animator = nil
    	local start    = 0
    
    	m.Init = function(figure)
    		SetOverrideDanceMusic(AssetGetContentId("nil_Cinderella.mp3")
    
    		start           = os.clock()
    		animator        = AnimLib.Animator.new()
    		animator.rig    = figure
    		animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("nil_Cinderella.anim"))
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
table.insert(modules,     function()
    	local m = {}
    
    	m.ModuleType  = "DANCE"
    	m.Name        = "Bunny hop"
    	m.Description = "Phoon was here"
    	m.Assets = {"nil_bhop.anim@MARKET/nilsbin/bhop.anim", "nil_bhop.mp3@MARKET/nilsbin/bhop.mp3"}
    
    	m.Config = function(parent)
    		Util_CreateText(parent, "No settings.", 14, Enum.TextXAlignment.Center)
    	end
    
    	m.SaveConfig = function() return {} end
    	m.LoadConfig  = function(save) end
    
    	local animator = nil
    	local start    = 0
    	local force = nil
    
    	m.Init = function(figure)
    		SetOverrideDanceMusic(AssetGetContentId("bhop.mp3"))
    
    		start           = os.clock()
    		animator        = AnimLib.Animator.new()
    		animator.rig    = figure
    		animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("bhop.anim"))
    		animator.looped = true
    		force = Instance.new("BodyVelocity")
    		force.P = 9e4
    		force.MaxForce = Vector3.new(math.huge, 0, math.huge)
    		force.Parent = figure.HumanoidRootPart
    	end
    
    	m.Update = function(dt, figure)
    	animator:Step(os.clock() - start)
    	local hum = figure:FindFirstChild("Humanoid")
    	local hum = figure:FindFirstChild("Humanoid")
    		if not hum or not hum.RootPart then return end
    		hum.WalkSpeed = 0.05
    		if hum.MoveDirection.Magnitude > 0 then
    			-- move backwards
    			force.Velocity = Vector3.new(
    				hum.MoveDirection.X * 26 * figure:GetScale(),
    				0,
    				hum.MoveDirection.Z * 26 * figure:GetScale()
    			)
    		else
    			force.Velocity = Vector3.zero
    		end)
table.insert(modules,     function(figure)
    	animator = nil
    	force:Destroy()
    	if not figure then return end)
table.insert(modules,     function()
    	local m = {}
    
    	m.ModuleType  = "DANCE"
    	m.Name        = "IA Mesmerizer"
    	m.Description = "Item asylum mesmerizer boohoo\nBasically a looped mesmerizer"
    	m.Assets = {"nil_IAmesmerizer.anim@https://github.com/czmalio291/Mkaxss/raw/refs/heads/main/goodies/contents/nil_IAmesmerizer.anim", "nil_IAmesmerizer.mp3@https://github.com/czmalio291/Mkaxss/raw/refs/heads/main/goodies/contents/nil_IAmesmerizer.mp3"}
    
    	m.Config = function(parent)
    		Util_CreateText(parent, "No settings.", 14, Enum.TextXAlignment.Center)
    	end
    
    	m.SaveConfig = function() return {} end
    	m.LoadConfig  = function(save) end
    
    	local animator = nil
    	local start    = 0
    
    	m.Init = function(figure)
    		SetOverrideDanceMusic(AssetGetContentId("nil_IAmesmerizer.mp3"), "Item Asylum mesmerizer", 0.9, NumberRange.new(0, 600))
    
    		start           = os.clock()
    		animator        = AnimLib.Animator.new()
    		animator.rig    = figure
    		animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("nil_IAmesmerizer.anim"))
    		animator.looped = true
    		animator.speed  = 1
    	end
    
    	m.Update = function(dt, figure)
    		animator:Step(os.clock() - start)
    	end
    
    	m.Update = function(dt: number, figure: Model)
    		animator:Step(GetOverrideDanceMusicTime())
    	end
    
    	m.Destroy = function(figure)
    		animator = nil
    	end
    
    	return m
    end)
table.insert(modules,     function()
    	local m = {}
    
    	m.ModuleType  = "DANCE"
    	m.Name        = "IA Gangnam"
    	m.Description = "wop wop wop"
    	m.Assets = {"nil_iagangnam.anim@MARKET/nilsbin/iagangnam.anim", "nil_Gangnam.mp3@MARKET/nilsbin/Gangnam.mp3", "nil_iagangnam.mp3@MARKET/nilsbin/iagangnam.mp3", "nil_iagangnamAlt.mp3@MARKET/nilsbin/iagangnamAlt.mp3"}
    
    	m.Alternative = false
    	m.Config = function(parent)
    		Util_CreateSwitch(parent, "Roland vers", m.Alternative).Changed:Connect(function(val)
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
    			animator.track = AnimLib.Track.fromfile(AssetGetPathFromFilename("iagangnam.anim"))
    			SetOverrideDanceMusic(AssetGetContentId("iagangnamAlt.mp3"))
    			animator.speed = 1.7
    		else
    			animator.track = AnimLib.Track.fromfile(AssetGetPathFromFilename("iagangnam.anim"))
    			SetOverrideDanceMusic(AssetGetContentId("iagangnam.mp3"))
    		end
    	end)
table.insert(modules,     function(dt, figure)
    		animator:Step(os.clock() - start)
    	end)
table.insert(modules,     function(figure)
    		animator = nil
    	end)
table.insert(modules,     function()
    	local m = {}
    
    	m.ModuleType  = "DANCE"
    	m.Name        = "Onion"
    	m.Description = "What if we say chocolate instead of onion!!!!!"
    	m.Assets = {"nil_Onion.anim@https://github.com/czmalio291/Mkaxss/raw/refs/heads/main/goodies/contents/nil_Onion.anim", "nil_Onion.mp3@https://github.com/czmalio291/Mkaxss/raw/refs/heads/main/goodies/contents/nil_Onion.mp3"}
    
    	m.Config = function(parent)
    		Util_CreateText(parent, "No settings.", 14, Enum.TextXAlignment.Center)
    	end
    
    	m.SaveConfig = function() return {} end
    	m.LoadConfig  = function(save) end
    
    	local animator = nil
    	local start    = 0
    
    	m.Init = function(figure)
    		SetOverrideDanceMusic(AssetGetContentId("nil_Onion.mp3"))
    
    		start           = os.clock()
    		animator        = AnimLib.Animator.new()
    		animator.rig    = figure
    		animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("nil_Onion.anim")
    		animator.looped = true
    		animator.speed  = 1
    	end
    
    	m.Update = function(dt, figure)
    		animator:Step(os.clock() - start)
    	end
      
    	m.Update = function(dt: number, figure: Model)
    		animator:Step(GetOverrideDanceMusicTime())
    	end
    
    	m.Destroy = function(figure)
    		animator = nil
    	end
    
    	return m
    end)
table.insert(modules,     function()
    	local m = {}
    
    	m.ModuleType  = "DANCE"
    	m.Name        = "Paranormal Swagtivity"
    	m.Description = "stop you're scaring everyone away"
    	m.Assets = {"nil_Paranormal.anim@https://github.com/czmalio291/Mkaxss/blob/main/goodies/contents/nil_Paranormal.anim", "nil_Paranormal.mp3@https://github.com/czmalio291/Mkaxss/blob/main/goodies/contents/nil_Paranormal.mp3"}
    
    	m.Config = function(parent)
    		Util_CreateText(parent, "No settings.", 14, Enum.TextXAlignment.Center)
    	end
    
    	m.SaveConfig = function() return {} end
    	m.LoadConfig  = function(save) end
    
    	local animator = nil
    	local start    = 0
    
    	m.Init = function(figure)
    		SetOverrideDanceMusic(AssetGetContentId("nil_Paranormal.mp3"), "Night of nights", 1, NumberRange.new(0, 600))
    
    		start           = os.clock()
    		animator        = AnimLib.Animator.new()
    		animator.rig    = figure
    		animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("nil_Paranormal.anim"))
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
table.insert(modules,     function()
    	local m = {}
    
    	m.ModuleType  = "DANCE"
    	m.Name        = "Jumper"
    	m.Description = "ometry ash"
    	m.Assets = {"nil_Jumper.anim@https://github.com/czmalio291/Mkaxss/raw/refs/heads/main/goodies/contents/nil_Jumper.anim", "nil_Jumper.mp3@https://github.com/czmalio291/Mkaxss/raw/refs/heads/main/goodies/contents/nil_Jumper.mp3"}
    
    	m.Config = function(parent)
    		Util_CreateText(parent, "refence to one dude dancing like that", 14, Enum.TextXAlignment.Center)
    	end
    
    	m.SaveConfig = function() return {} end
    	m.LoadConfig  = function(save) end
    
    	local animator = nil
    	local start    = 0
    
    	m.Init = function(figure)
    		SetOverrideDanceMusic(AssetGetContentId("nil_Jumper.mp3"), "gdjumper", 1, NumberRange.new(10.85, 600))
    
    		start           = os.clock()
    		animator        = AnimLib.Animator.new()
    		animator.rig    = figure
    		animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("nil_Jumper.anim"))
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
table.insert(modules,     function()
    	local m = {}
    
    	m.ModuleType  = "DANCE"
    	m.Name        = "XD Meme"
    	m.Description = "oh god no\nWould the colonthreespam likes this one?\n:3 :3 :3 :3 :3 :3 :3 "
    	m.Assets = {"nil_xd.anim@https://github.com/czmalio291/Mkaxss/raw/refs/heads/main/goodies/contents/nil_xd.anim", "nil_xd.mp3@https://github.com/czmalio291/Mkaxss/raw/refs/heads/main/goodies/contents/nil_xd.mp3"}
    
    	m.Config = function(parent)
    		Util_CreateText(parent, "another item asylum emote", 14, Enum.TextXAlignment.Center)
    	end
    
    	m.SaveConfig = function() return {} end
    	m.LoadConfig  = function(save) end
    
    	local animator = nil
    	local start    = 0
    
    	m.Init = function(figure)
    		SetOverrideDanceMusic(AssetGetContentId("nil_xd.mp3"))
    
    		start           = os.clock()
    		animator        = AnimLib.Animator.new()
    		animator.rig    = figure
    		animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("nil_xd.anim"))
    		animator.looped = true
    		animator.speed  = 1
    	end
    
    	m.Update = function(dt, figure)
    		animator:Step(os.clock() - start)
    	end
    
    	m.Update = function(dt: number, figure: Model)
    		animator:Step(GetOverrideDanceMusicTime())
    	end
    
    	m.Destroy = function(figure)
    		animator = nil
    	end
    
    	return m
    end)
table.insert(modules,     function()
    	local m = {}
    
    	m.ModuleType  = "DANCE"
    	m.Name        = "Usagi Flap"
    	m.Description = "We are becoming samsung smart fridges with this one"
    	m.Assets = {"nil_Usagiflap.anim@MARKET/nilsbin/Usagiflap.anim", "nil_Usagiflap.mp3@MARKET/nilsbin/Usagiflap.mp3"}
    
    	m.Config = function(parent)
    		Util_CreateText(parent, "No settings.", 14, Enum.TextXAlignment.Center)
    	end
    
    	m.SaveConfig = function() return {} end
    	m.LoadConfig  = function(save) end
    
    	local animator = nil
    	local start    = 0
    
    	m.Init = function(figure)
    		SetOverrideDanceMusic(AssetGetContentId("Usagiflap.mp3"), "IAusagi", 1, NumberRange.new(11.82, 60))
    
    		start           = os.clock()
    		animator        = AnimLib.Animator.new()
    		animator.rig    = figure
    		animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("Usagiflap.anim"))
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
table.insert(modules,     function()
    	local m = {}
    
    	m.ModuleType  = "DANCE"
    	m.Name        = "Spamton"
    	m.Description = "THAT'S RIGHT!! NOW'S YOUR CHANCE TO BE A [BIG SHOT]!!"
    	m.Assets = {"nil_Spamton.anim@https://github.com/czmalio291/Mkaxss/raw/refs/heads/main/goodies/contents/nil_Spamton.anim", "nil_Spamton.mp3@https://github.com/czmalio291/Mkaxss/raw/refs/heads/main/goodies/contents/nil_Spamton.mp3"}
    
    	m.Config = function(parent)
    		Util_CreateText(parent, "No settings.", 14, Enum.TextXAlignment.Center)
    	end
    
    	m.SaveConfig = function() return {} end
    	m.LoadConfig  = function(save) end
    
    	local animator = nil
    	local start    = 0
    
    	m.Init = function(figure)
    		SetOverrideDanceMusic(AssetGetContentId("nil_Spamton.mp3"))
    
    		start           = os.clock()
    		animator        = AnimLib.Animator.new()
    		animator.rig    = figure
    		animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("nil_Spamton.anim"))
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
table.insert(modules,     function()
    	local m = {}
    
    	m.ModuleType  = "DANCE"
    	m.Name        = "Birthday"
    	m.Description = "Ots my birthday today"
    	m.Assets = {"nil_Birthday.anim@https://github.com/czmalio291/Mkaxss/raw/refs/heads/main/goodies/contents/nil_Birthday.anim", "nil_Birthday.mp3@https://github.com/czmalio291/Mkaxss/raw/refs/heads/main/goodies/contents/nil_Birthday.mp3"}
    
    	m.Config = function(parent)
    		Util_CreateText(parent, "No settings.", 14, Enum.TextXAlignment.Center)
    	end
    
    	m.SaveConfig = function() return {} end
    	m.LoadConfig  = function(save) end
    
    	local animator = nil
    	local start    = 0
    
    	m.Init = function(figure)
    		SetOverrideDanceMusic(AssetGetContentId("nil_Birthday.mp3"))
    
    		start           = os.clock()
    		animator        = AnimLib.Animator.new()
    		animator.rig    = figure
    		animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("nil_Birthday.anim")
    		animator.looped = true
    		animator.speed  = 1
    	end
    
    	m.Update = function(dt, figure)
    		animator:Step(os.clock() - start)
    	end
      
    	m.Update = function(dt: number, figure: Model)
    		animator:Step(GetOverrideDanceMusicTime())
    	end
    
    	m.Destroy = function(figure)
    		animator = nil
    	end
    
    	return m
    end)
table.insert(modules,     function()
    	local m = {}
    
    	m.ModuleType  = "DANCE"
    	m.Name        = "Pirate"
    	m.Description = "the 1700s still hit hard"
    	m.Assets = {"nil_Pirate.anim@https://github.com/czmalio291/Mkaxss/blob/main/goodies/contents/nil_Pirate.anim", "Pirate.mp3@https://github.com/czmalio291/Mkaxss/blob/main/goodies/contents/nil_Pirate.mp3"}
    
    	m.Config = function(parent)
    		Util_CreateText(parent, "No settings.", 14, Enum.TextXAlignment.Center)
    	end
    
    	m.SaveConfig = function() return {} end
    	m.LoadConfig  = function(save) end
    
    	local animator = nil
    	local start    = 0
    
    	m.Init = function(figure)
    		SetOverrideDanceMusic(AssetGetContentId("nil_Pirate.mp3")
    
    		start           = os.clock()
    		animator        = AnimLib.Animator.new()
    		animator.rig    = figure
    		animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("nil_Pirate.anim"))
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
table.insert(modules,     function()
    	local m = {}
    
    	m.ModuleType  = "DANCE"
    	m.Name        = "Chad"
    	m.Description = "can't outchad the chad"
    	m.Assets = {"nil_Chad.anim@https://github.com/czmalio291/Mkaxss/raw/refs/heads/main/goodies/contents/nil_Chad.anim", "nil_Chad.mp3@https://github.com/czmalio291/Mkaxss/raw/refs/heads/main/goodies/contents/nil_Chad.mp3"}
    
    	m.Config = function(parent)
    		Util_CreateText(parent, "No settings.", 14, Enum.TextXAlignment.Center)
    	end
    
    	m.SaveConfig = function() return {} end
    	m.LoadConfig  = function(save) end
    
    	local animator = nil
    	local start    = 0
    
    	m.Init = function(figure)
    		SetOverrideDanceMusic(AssetGetContentId("nil_Chad.mp3"))
    
    		start           = os.clock()
    		animator        = AnimLib.Animator.new()
    		animator.rig    = figure
    		animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("nil_Chad.anim"))
    		animator.looped = true
    		animator.speed  = 1
    	end
    
    	m.Update = function(dt, figure)
    		animator:Step(os.clock() - start)
    	end
    	
    	m.Update = function(dt: number, figure: Model)
    		animator:Step(GetOverrideDanceMusicTime())
    	end
    
    	m.Destroy = function(figure)
    		animator = nil
    	end
    
    	return m
    end)
table.insert(modules,     function()
    	local m = {}
    
    	m.ModuleType  = "DANCE"
    	m.Name        = "Proxima Creature"
    	m.Description = ":fear:"
    	m.Assets = {"nil_proxima.anim@MARKET/nilsbin/proxima.anim", "nil_proxima.mp3@MARKET/nilsbin/proxima.mp3"}
    
    	m.Config = function(parent)
    		Util_CreateText(parent, "No settings.", 14, Enum.TextXAlignment.Center)
    	end
    
    	m.SaveConfig = function() return {} end
    	m.LoadConfig  = function(save) end
    
    	local animator = nil
    	local start    = 0
    
    	m.Init = function(figure)
    		SetOverrideDanceMusic(AssetGetContentId("proxima.mp3"))
    
    		start           = os.clock()
    		animator        = AnimLib.Animator.new()
    		animator.rig    = figure
    		animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("proxima.anim"))
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
table.insert(modules,     function()
    	local m = {}
    
    	m.ModuleType  = "DANCE"
    	m.Name        = "Omni"
    	m.Description = "500 years of constant human evolution"
    	m.Assets = {"nil_omni.anim@https://github.com/czmalio291/Mkaxss/raw/refs/heads/main/goodies/contents/nil_omni.anim", "nil_omni.mp3@https://github.com/czmalio291/Mkaxss/raw/refs/heads/main/goodies/contents/nil_omni.mp3"}
    
    	m.Config = function(parent)
    		Util_CreateText(parent, "how do i add distortionsoundeffect?", 14, Enum.TextXAlignment.Center)
    	end
    
    	m.SaveConfig = function() return {} end
    	m.LoadConfig  = function(save) end
    
    	local animator = nil
    	local start    = 0
    
    	m.Init = function(figure)
    		SetOverrideDanceMusic(AssetGetContentId("nil_omni.mp3"), "omniman", 1, NumberRange.new(0, 39))
    
    		start           = os.clock()
    		animator        = AnimLib.Animator.new()
    		animator.rig    = figure
    		animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("nil_omni.anim"))
    		animator.looped = false
    		animator.speed  = 1
    	end
    
    	m.Update = function(dt, figure)
    		animator:Step(os.clock() - start)
    	end
    
    	m.Update = function(dt: number, figure: Model)
    		animator:Step(GetOverrideDanceMusicTime())
    	end
    
    	m.Destroy = function(figure)
    		animator = nil
    	end
    
    	return m
    end)
table.insert(modules,     function()
    	local m = {}
    
    	m.ModuleType  = "DANCE"
    	m.Name        = "운테르게임"
    	m.Description = "he so jolly"
    	m.Assets = {"nil_Bong.anim@https://github.com/czmalio291/Mkaxss/blob/main/goodies/contents/nil_Bong.anim", "nil_Bong.mp3@https://github.com/czmalio291/Mkaxss/blob/main/goodies/contents/nil_Bong.mp3"}
    
    	m.Config = function(parent)
    		Util_CreateText(parent, "No settings.", 14, Enum.TextXAlignment.Center)
    	end
    
    	m.SaveConfig = function() return {} end
    	m.LoadConfig  = function(save) end
    
    	local animator = nil
    	local start    = 0
    
    	m.Init = function(figure)
    		SetOverrideDanceMusic(AssetGetContentId("nil_Bong.mp3")
    
    		start           = os.clock()
    		animator        = AnimLib.Animator.new()
    		animator.rig    = figure
    		animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("nil_Bong.anim"))
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
table.insert(modules,     function()
    	local m = {}
    
    	m.ModuleType  = "DANCE"
    	m.Name        = "Insanity"
    	m.Description = "Ran Ran Ruu!"
    	m.Assets = {"nil_Insanity.anim@https://github.com/czmalio291/Mkaxss/raw/refs/heads/main/goodies/contents/nil_Insanity.anim", "nil_Insanity.mp3@https://github.com/czmalio291/Mkaxss/raw/refs/heads/main/goodies/contents/nil_Insanity.mp3"}
    
    	m.Config = function(parent)
    		Util_CreateText(parent, "where is my burger?", 14, Enum.TextXAlignment.Center)
    	end
    
    	m.SaveConfig = function() return {} end
    	m.LoadConfig  = function(save) end
    
    	local animator = nil
    	local start    = 0
    
    	m.Init = function(figure)
    		SetOverrideDanceMusic(AssetGetContentId("nil_insanity.mp3"), "IAinsanity", 0.8, NumberRange.new(0, 600))
    
    		start           = os.clock()
    		animator        = AnimLib.Animator.new()
    		animator.rig    = figure
    		animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("nil_insanity.anim"))
    		animator.looped = false
    		animator.speed  = 1
    	end
    
    	m.Update = function(dt, figure)
    		animator:Step(os.clock() - start)
    	end
    	m.Update = function(dt: number, figure: Model)
    		animator:Step(GetOverrideDanceMusicTime())
    	end
    	m.Destroy = function(figure)
    		animator = nil
    	end
    
    	return m
    end)

return modules