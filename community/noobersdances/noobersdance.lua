local modules = {}
table.insert(modules,     function()
        local m = {}
    
        m.ModuleType  = "DANCE"
        m.Name        = "23 hour cinderella"
        m.Description = "censored 24 because of someone"
        m.Assets = {"noober_24 hour cinderella.anim@MARKET/noobersdances/24 hour cinderella.anim", "noober_24 hour cinderella.mp3@MARKET/noobersdances/24 hour cinderella.mp3"}
    
        m.Config = function(parent)
            Util_CreateText(parent, "No settings.", 14, Enum.TextXAlignment.Center)
        end
    
        m.SaveConfig = function() return {} end
        m.LoadConfig  = function(save) end
    
        local animator = nil
        local start    = 0
    
        m.Init = function(figure)
            SetOverrideDanceMusic(AssetGetContentId("24 hour cinderella.mp3"), "23 hour cinderella", 0.8, NumberRange.new(0, 45.5))
    
            start           = os.clock()
            animator        = AnimLib.Animator.new()
            animator.rig    = figure
            animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("24 hour cinderella.anim"))
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
        m.Name        = "aint no loving my man"
        m.Description = "shoo wats shoo wats "
        m.Assets = {"noober_aint no loving my man.anim@MARKET/noobersdances/aint no loving my man.anim", "noober_aint no loving my man.mp3@MARKET/noobersdances/aint no loving my man.mp3"}
    
        m.Config = function(parent)
            Util_CreateText(parent, "No settings.", 14, Enum.TextXAlignment.Center)
        end
    
        m.SaveConfig = function() return {} end
        m.LoadConfig  = function(save) end
    
        local animator = nil
        local start    = 0
    
        m.Init = function(figure)
            SetOverrideDanceMusic(AssetGetContentId("aint no loving my man.mp3"), "aint no loving my man", 0.8, NumberRange.new(0, 45.5))
    
            start           = os.clock()
            animator        = AnimLib.Animator.new()
            animator.rig    = figure
            animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("aint no loving my man.anim"))
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
        m.Name        = "CSGO Bhop"
        m.Description = "that one try hard movement in counter strike or left 4 dead"
        m.Assets = {"noober_Bhop.anim@MARKET/noobersdances/Bhop.anim", "noober_Bhop.mp3@MARKET/noobersdances/Bhop.mp3"}
    
        m.Config = function(parent)
            Util_CreateText(parent, "No settings.", 14, Enum.TextXAlignment.Center)
        end
    
        m.SaveConfig = function() return {} end
        m.LoadConfig  = function(save) end
    
        local animator = nil
        local start    = 0
    
        m.Init = function(figure)
            SetOverrideDanceMusic(AssetGetContentId("Bhop.mp3"), "Bhop", 0.8, NumberRange.new(0, 45.5))
    
            start           = os.clock()
            animator        = AnimLib.Animator.new()
            animator.rig    = figure
            animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("Bhop.anim"))
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
        m.Name        = "BloodPop"
        m.Description = "only 2021 survivors remember this"
        m.Assets = {"noober_BloodPop.anim@MARKET/noobersdances/BloodPop.anim", "noober_BloodPop.mp3@MARKET/noobersdances/BloodPop.mp3"}
    
        m.Config = function(parent)
            Util_CreateText(parent, "No settings.", 14, Enum.TextXAlignment.Center)
        end
    
        m.SaveConfig = function() return {} end
        m.LoadConfig  = function(save) end
    
        local animator = nil
        local start    = 0
    
        m.Init = function(figure)
            SetOverrideDanceMusic(AssetGetContentId("BloodPop.mp3"), "BloodPop", 0.8, NumberRange.new(0, 45.5))
    
            start           = os.clock()
            animator        = AnimLib.Animator.new()
            animator.rig    = figure
            animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("BloodPop.anim"))
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
        m.Name        = "Break Dance"
        m.Description = "Let's give real vibes to the serverrer"
        m.Assets = {"noober_BreakDance.anim@MARKET/noobersdances/BreakDance.anim", "noober_BreakDance.mp3@MARKET/noobersdances/BreakDance.mp3"}
    
        m.Config = function(parent)
            Util_CreateText(parent, "No settings.", 14, Enum.TextXAlignment.Center)
        end
    
        m.SaveConfig = function() return {} end
        m.LoadConfig  = function(save) end
    
        local animator = nil
        local start    = 0
    
        m.Init = function(figure)
            SetOverrideDanceMusic(AssetGetContentId("BreakDance.mp3"), "Break Dance", 0.8, NumberRange.new(0, 45.5))
    
            start           = os.clock()
            animator        = AnimLib.Animator.new()
            animator.rig    = figure
            animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("BreakDance.anim"))
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
        m.Name        = "BreakDown"
        m.Description = "we will break with this one🔥🔥🔥 (I forgot how it was sorry)"
        m.Assets = {"noober_BreakDown.anim@MARKET/noobersdances/BreakDown.anim", "noober_BreakDown.mp3@MARKET/noobersdances/BreakDown.mp3"}
    
        m.Config = function(parent)
            Util_CreateText(parent, "No settings.", 14, Enum.TextXAlignment.Center)
        end
    
        m.SaveConfig = function() return {} end
        m.LoadConfig  = function(save) end
    
        local animator = nil
        local start    = 0
    
        m.Init = function(figure)
            SetOverrideDanceMusic(AssetGetContentId("BreakDown.mp3"), "BreakDown", 0.8, NumberRange.new(0, 45.5))
    
            start           = os.clock()
            animator        = AnimLib.Animator.new()
            animator.rig    = figure
            animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("BreakDown.anim"))
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
        m.Name        = "ChronoShift"
        m.Description = "couldnt kill the zillean bro"
        m.Assets = {"noober_ChronoShift.anim@MARKET/noobersdances/ChronoShift.anim", "noober_ChronoShift.mp3@MARKET/noobersdances/ChronoShift.mp3"}
    
        m.Config = function(parent)
            Util_CreateText(parent, "No settings.", 14, Enum.TextXAlignment.Center)
        end
    
        m.SaveConfig = function() return {} end
        m.LoadConfig  = function(save) end
    
        local animator = nil
        local start    = 0
    
        m.Init = function(figure)
            SetOverrideDanceMusic(AssetGetContentId("ChronoShift.mp3"), "ChronoShift", 0.8, NumberRange.new(0, 45.5))
    
            start           = os.clock()
            animator        = AnimLib.Animator.new()
            animator.rig    = figure
            animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("ChronoShift.anim"))
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
        m.Name        = "Cry for me"
        m.Description = "I wanna oof myself before hearing this"
        m.Assets = {"noober_CryForMe.anim@MARKET/noobersdances/CryForMe.anim", "noober_CryForMe.mp3@MARKET/noobersdances/CryForMe.mp3"}
    
        m.Config = function(parent)
            Util_CreateText(parent, "No settings.", 14, Enum.TextXAlignment.Center)
        end
    
        m.SaveConfig = function() return {} end
        m.LoadConfig  = function(save) end
    
        local animator = nil
        local start    = 0
    
        m.Init = function(figure)
            SetOverrideDanceMusic(AssetGetContentId("CryForMe.mp3"), "Cry for me", 0.8, NumberRange.new(0, 45.5))
    
            start           = os.clock()
            animator        = AnimLib.Animator.new()
            animator.rig    = figure
            animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("CryForMe.anim"))
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
        m.Name        = "Ellen doe"
        m.Description = "gooning to this btw"
        m.Assets = {"noober_Ellen doe.anim@MARKET/noobersdances/Ellen doe.anim", "noober_Ellen doe.mp3@MARKET/noobersdances/Ellen doe.mp3"}
    
        m.Config = function(parent)
            Util_CreateText(parent, "No settings.", 14, Enum.TextXAlignment.Center)
        end
    
        m.SaveConfig = function() return {} end
        m.LoadConfig  = function(save) end
    
        local animator = nil
        local start    = 0
    
        m.Init = function(figure)
            SetOverrideDanceMusic(AssetGetContentId("Ellen doe.mp3"), "Ellen doe", 0.8, NumberRange.new(0, 45.5))
    
            start           = os.clock()
            animator        = AnimLib.Animator.new()
            animator.rig    = figure
            animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("Ellen doe.anim"))
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
        m.Name        = "Everybody gangnam"
        m.Description = "sorry Theo but I stealed the mp3 from your dances"
        m.Assets = {"noober_EverybodyGangnam.anim@MARKET/noobersdances/EverybodyGangnam.anim", "noober_EverybodyGangnam.mp3@MARKET/noobersdances/EverybodyGangnam.mp3"}
    
        m.Config = function(parent)
            Util_CreateText(parent, "No settings.", 14, Enum.TextXAlignment.Center)
        end
    
        m.SaveConfig = function() return {} end
        m.LoadConfig  = function(save) end
    
        local animator = nil
        local start    = 0
    
        m.Init = function(figure)
            SetOverrideDanceMusic(AssetGetContentId("EverybodyGangnam.mp3"), "Everybody gangnam", 0.8, NumberRange.new(0, 45.5))
    
            start           = os.clock()
            animator        = AnimLib.Animator.new()
            animator.rig    = figure
            animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("EverybodyGangnam.anim"))
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
        m.Name        = "Gangnam style (dod)"
        m.Description = "fresh meat"
        m.Assets = {"noober_Gangnam style (dod).anim@MARKET/noobersdances/Gangnam style (dod).anim", "noober_Gangnam style (dod).mp3@MARKET/noobersdances/Gangnam style (dod).mp3"}
    
        m.Config = function(parent)
            Util_CreateText(parent, "No settings.", 14, Enum.TextXAlignment.Center)
        end
    
        m.SaveConfig = function() return {} end
        m.LoadConfig  = function(save) end
    
        local animator = nil
        local start    = 0
    
        m.Init = function(figure)
            SetOverrideDanceMusic(AssetGetContentId("Gangnam style (dod).mp3"), "Gangnam style (dod)", 0.8, NumberRange.new(0, 45.5))
    
            start           = os.clock()
            animator        = AnimLib.Animator.new()
            animator.rig    = figure
            animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("Gangnam style (dod).anim"))
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
        m.Name        = "Hakari from fatsaken"
        m.Description = "if Steve not adding this, then Ill do it"
        m.Assets = {"noober_HakariForsaken.anim@MARKET/noobersdances/HakariForsaken.anim", "noober_HakariForsaken.mp3@MARKET/noobersdances/HakariForsaken.mp3"}
    
        m.Config = function(parent)
            Util_CreateText(parent, "No settings.", 14, Enum.TextXAlignment.Center)
        end
    
        m.SaveConfig = function() return {} end
        m.LoadConfig  = function(save) end
    
        local animator = nil
        local start    = 0
    
        m.Init = function(figure)
            SetOverrideDanceMusic(AssetGetContentId("HakariForsaken.mp3"), "Hakari from fatsaken", 0.8, NumberRange.new(0, 45.5))
    
            start           = os.clock()
            animator        = AnimLib.Animator.new()
            animator.rig    = figure
            animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("HakariForsaken.anim"))
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
        m.Name        = "Honey Pie"
        m.Description = "I remember that I didnt khow what does this song mean in 2023"
        m.Assets = {"noober_Honey Pie.anim@MARKET/noobersdances/Honey Pie.anim", "noober_Honey Pie.mp3@MARKET/noobersdances/Honey Pie.mp3"}
    
        m.Config = function(parent)
            Util_CreateText(parent, "No settings.", 14, Enum.TextXAlignment.Center)
        end
    
        m.SaveConfig = function() return {} end
        m.LoadConfig  = function(save) end
    
        local animator = nil
        local start    = 0
    
        m.Init = function(figure)
            SetOverrideDanceMusic(AssetGetContentId("Honey Pie.mp3"), "Honey Pie", 0.8, NumberRange.new(0, 45.5))
    
            start           = os.clock()
            animator        = AnimLib.Animator.new()
            animator.rig    = figure
            animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("Honey Pie.anim"))
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
        m.Name        = "HypnoDance"
        m.Description = "tell Theo to go to hell"
        m.Assets = {"noober_HypnoDance.anim@MARKET/noobersdances/HypnoDance.anim", "noober_HypnoDance.mp3@MARKET/noobersdances/HypnoDance.mp3"}
    
        m.Config = function(parent)
            Util_CreateText(parent, "No settings.", 14, Enum.TextXAlignment.Center)
        end
    
        m.SaveConfig = function() return {} end
        m.LoadConfig  = function(save) end
    
        local animator = nil
        local start    = 0
    
        m.Init = function(figure)
            SetOverrideDanceMusic(AssetGetContentId("HypnoDance.mp3"), "HypnoDance", 0.8, NumberRange.new(0, 45.5))
    
            start           = os.clock()
            animator        = AnimLib.Animator.new()
            animator.rig    = figure
            animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("HypnoDance.anim"))
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
        m.Name        = "I luv it"
        m.Description = "very good yes yes Noober approves"
        m.Assets = {"noober_I luv it.anim@MARKET/noobersdances/I luv it.anim", "noober_I luv it.mp3@MARKET/noobersdances/I luv it.mp3"}
    
        m.Config = function(parent)
            Util_CreateText(parent, "No settings.", 14, Enum.TextXAlignment.Center)
        end
    
        m.SaveConfig = function() return {} end
        m.LoadConfig  = function(save) end
    
        local animator = nil
        local start    = 0
    
        m.Init = function(figure)
            SetOverrideDanceMusic(AssetGetContentId("I luv it.mp3"), "I luv it", 0.8, NumberRange.new(0, 45.5))
    
            start           = os.clock()
            animator        = AnimLib.Animator.new()
            animator.rig    = figure
            animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("I luv it.anim"))
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
        m.Name        = "JK unlimited flexworks"
        m.Description = "kj but from Shein"
        m.Assets = {"noober_JK.anim@MARKET/noobersdances/JK.anim", "noober_JK.mp3@MARKET/noobersdances/JK.mp3"}
    
        m.Config = function(parent)
            Util_CreateText(parent, "No settings.", 14, Enum.TextXAlignment.Center)
        end
    
        m.SaveConfig = function() return {} end
        m.LoadConfig  = function(save) end
    
        local animator = nil
        local start    = 0
    
        m.Init = function(figure)
            SetOverrideDanceMusic(AssetGetContentId("JK.mp3"), "JK unlimited flexworks", 0.8, NumberRange.new(0, 45.5))
    
            start           = os.clock()
            animator        = AnimLib.Animator.new()
            animator.rig    = figure
            animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("JK.anim"))
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
        m.Name        = "Jamal celebration"
        m.Description = "lets celebrate"
        m.Assets = {"noober_Jamal celebration.anim@MARKET/noobersdances/Jamal celebration.anim", "noober_Jamal celebration.mp3@MARKET/noobersdances/Jamal celebration.mp3"}
    
        m.Config = function(parent)
            Util_CreateText(parent, "No settings.", 14, Enum.TextXAlignment.Center)
        end
    
        m.SaveConfig = function() return {} end
        m.LoadConfig  = function(save) end
    
        local animator = nil
        local start    = 0
    
        m.Init = function(figure)
            SetOverrideDanceMusic(AssetGetContentId("Jamal celebration.mp3"), "Jamal celebration", 0.8, NumberRange.new(0, 45.5))
    
            start           = os.clock()
            animator        = AnimLib.Animator.new()
            animator.rig    = figure
            animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("Jamal celebration.anim"))
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
        m.Name        = "Jax toy"
        m.Description = "can someone buy me this🥺"
        m.Assets = {"noober_Jax toy.anim@MARKET/noobersdances/Jax toy.anim", "noober_Jax toy.mp3@MARKET/noobersdances/Jax toy.mp3"}
    
        m.Config = function(parent)
            Util_CreateText(parent, "No settings.", 14, Enum.TextXAlignment.Center)
        end
    
        m.SaveConfig = function() return {} end
        m.LoadConfig  = function(save) end
    
        local animator = nil
        local start    = 0
    
        m.Init = function(figure)
            SetOverrideDanceMusic(AssetGetContentId("Jax toy.mp3"), "Jax toy", 0.8, NumberRange.new(0, 45.5))
    
            start           = os.clock()
            animator        = AnimLib.Animator.new()
            animator.rig    = figure
            animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("Jax toy.anim"))
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
        m.Name        = "Jung justice"
        m.Description = "we are justice"
        m.Assets = {"noober_Jung justice.anim@MARKET/noobersdances/Jung justice.anim", "noober_Jung justice.mp3@MARKET/noobersdances/Jung justice.mp3"}
    
        m.Config = function(parent)
            Util_CreateText(parent, "No settings.", 14, Enum.TextXAlignment.Center)
        end
    
        m.SaveConfig = function() return {} end
        m.LoadConfig  = function(save) end
    
        local animator = nil
        local start    = 0
    
        m.Init = function(figure)
            SetOverrideDanceMusic(AssetGetContentId("Jung justice.mp3"), "Jung justice", 0.8, NumberRange.new(0, 45.5))
    
            start           = os.clock()
            animator        = AnimLib.Animator.new()
            animator.rig    = figure
            animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("Jung justice.anim"))
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
        m.Name        = "Lil buddy was sick"
        m.Description = "bro is not tuff mango six seven skibidi warrior🙏🤣"
        m.Assets = {"noober_Lil buddy was sick.anim@MARKET/noobersdances/Lil buddy was sick.anim", "noober_Lil buddy was sick.mp3@MARKET/noobersdances/Lil buddy was sick.mp3"}
    
        m.Config = function(parent)
            Util_CreateText(parent, "No settings.", 14, Enum.TextXAlignment.Center)
        end
    
        m.SaveConfig = function() return {} end
        m.LoadConfig  = function(save) end
    
        local animator = nil
        local start    = 0
    
        m.Init = function(figure)
            SetOverrideDanceMusic(AssetGetContentId("Lil buddy was sick.mp3"), "Lil buddy was sick", 0.8, NumberRange.new(0, 45.5))
    
            start           = os.clock()
            animator        = AnimLib.Animator.new()
            animator.rig    = figure
            animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("Lil buddy was sick.anim"))
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
        m.Name        = "Low Cortisol"
        m.Description = "no more angry,only good vibes"
        m.Assets = {"noober_LowCortisol.anim@MARKET/noobersdances/LowCortisol.anim", "noober_LowCortisol.mp3@MARKET/noobersdances/LowCortisol.mp3"}
    
        m.Config = function(parent)
            Util_CreateText(parent, "No settings.", 14, Enum.TextXAlignment.Center)
        end
    
        m.SaveConfig = function() return {} end
        m.LoadConfig  = function(save) end
    
        local animator = nil
        local start    = 0
    
        m.Init = function(figure)
            SetOverrideDanceMusic(AssetGetContentId("LowCortisol.mp3"), "Low Cortisol", 0.8, NumberRange.new(0, 45.5))
    
            start           = os.clock()
            animator        = AnimLib.Animator.new()
            animator.rig    = figure
            animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("LowCortisol.anim"))
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
        m.Name        = "Luffy dance"
        m.Description = "almost 9000092773839383 episodes and still doesnt find the one piece"
        m.Assets = {"noober_Luffy dance.anim@MARKET/noobersdances/Luffy dance.anim", "noober_Luffy dance.mp3@MARKET/noobersdances/Luffy dance.mp3"}
    
        m.Config = function(parent)
            Util_CreateText(parent, "No settings.", 14, Enum.TextXAlignment.Center)
        end
    
        m.SaveConfig = function() return {} end
        m.LoadConfig  = function(save) end
    
        local animator = nil
        local start    = 0
    
        m.Init = function(figure)
            SetOverrideDanceMusic(AssetGetContentId("Luffy dance.mp3"), "Luffy dance", 0.8, NumberRange.new(0, 45.5))
    
            start           = os.clock()
            animator        = AnimLib.Animator.new()
            animator.rig    = figure
            animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("Luffy dance.anim"))
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
        m.Name        = "MLG"
        m.Description = "That feeling when you hit a 360"
        m.Assets = {"noober_MLG.anim@MARKET/noobersdances/MLG.anim", "noober_MLG.mp3@MARKET/noobersdances/MLG.mp3"}
    
        m.Config = function(parent)
            Util_CreateText(parent, "No settings.", 14, Enum.TextXAlignment.Center)
        end
    
        m.SaveConfig = function() return {} end
        m.LoadConfig  = function(save) end
    
        local animator = nil
        local start    = 0
    
        m.Init = function(figure)
            SetOverrideDanceMusic(AssetGetContentId("MLG.mp3"), "MLG", 0.8, NumberRange.new(0, 45.5))
    
            start           = os.clock()
            animator        = AnimLib.Animator.new()
            animator.rig    = figure
            animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("MLG.anim"))
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
        m.Name        = "macarena"
        m.Description = "good dance from like 2022"
        m.Assets = {"noober_Macarena.anim@MARKET/noobersdances/Macarena.anim", "noober_Macarena.mp3@MARKET/noobersdances/Macarena.mp3"}
    
        m.Config = function(parent)
            Util_CreateText(parent, "No settings.", 14, Enum.TextXAlignment.Center)
        end
    
        m.SaveConfig = function() return {} end
        m.LoadConfig  = function(save) end
    
        local animator = nil
        local start    = 0
    
        m.Init = function(figure)
            SetOverrideDanceMusic(AssetGetContentId("Macarena.mp3"), "macarena", 0.8, NumberRange.new(0, 45.5))
    
            start           = os.clock()
            animator        = AnimLib.Animator.new()
            animator.rig    = figure
            animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("Macarena.anim"))
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
        m.Name        = "No More Games"
        m.Description = "holy peak 🔥"
        m.Assets = {"noober_NoMoreGames.anim@MARKET/noobersdances/NoMoreGames.anim", "noober_NoMoreGames.mp3@MARKET/noobersdances/NoMoreGames.mp3"}
    
        m.Config = function(parent)
            Util_CreateText(parent, "No settings.", 14, Enum.TextXAlignment.Center)
        end
    
        m.SaveConfig = function() return {} end
        m.LoadConfig  = function(save) end
    
        local animator = nil
        local start    = 0
    
        m.Init = function(figure)
            SetOverrideDanceMusic(AssetGetContentId("NoMoreGames.mp3"), "No More Games", 0.8, NumberRange.new(0, 45.5))
    
            start           = os.clock()
            animator        = AnimLib.Animator.new()
            animator.rig    = figure
            animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("NoMoreGames.anim"))
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
        m.Name        = "Pick it up"
        m.Description = "holy dead emote lolllllllll"
        m.Assets = {"noober_Pick it up.anim@MARKET/noobersdances/Pick it up.anim", "noober_Pick it up.mp3@MARKET/noobersdances/Pick it up.mp3"}
    
        m.Config = function(parent)
            Util_CreateText(parent, "No settings.", 14, Enum.TextXAlignment.Center)
        end
    
        m.SaveConfig = function() return {} end
        m.LoadConfig  = function(save) end
    
        local animator = nil
        local start    = 0
    
        m.Init = function(figure)
            SetOverrideDanceMusic(AssetGetContentId("Pick it up.mp3"), "Pick it up", 0.8, NumberRange.new(0, 45.5))
    
            start           = os.clock()
            animator        = AnimLib.Animator.new()
            animator.rig    = figure
            animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("Pick it up.anim"))
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
        m.Name        = "I wanna ran away"
        m.Description = "this old meme but in uhhhhh reanimate"
        m.Assets = {"noober_Runaway.anim@MARKET/noobersdances/Runaway.anim", "noober_Runaway.mp3@MARKET/noobersdances/Runaway.mp3"}
    
        m.Config = function(parent)
            Util_CreateText(parent, "No settings.", 14, Enum.TextXAlignment.Center)
        end
    
        m.SaveConfig = function() return {} end
        m.LoadConfig  = function(save) end
    
        local animator = nil
        local start    = 0
    
        m.Init = function(figure)
            SetOverrideDanceMusic(AssetGetContentId("Runaway.mp3"), "I wanna ran away", 0.8, NumberRange.new(0, 45.5))
    
            start           = os.clock()
            animator        = AnimLib.Animator.new()
            animator.rig    = figure
            animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("Runaway.anim"))
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
        m.Name        = "6 7"
        m.Description = "ts invaded my fyp in 2025 bro"
        m.Assets = {"noober_Six Seven.anim@MARKET/noobersdances/Six Seven.anim", "noober_Six Seven.mp3@MARKET/noobersdances/Six Seven.mp3"}
    
        m.Config = function(parent)
            Util_CreateText(parent, "No settings.", 14, Enum.TextXAlignment.Center)
        end
    
        m.SaveConfig = function() return {} end
        m.LoadConfig  = function(save) end
    
        local animator = nil
        local start    = 0
    
        m.Init = function(figure)
            SetOverrideDanceMusic(AssetGetContentId("Six Seven.mp3"), "6 7", 0.8, NumberRange.new(0, 45.5))
    
            start           = os.clock()
            animator        = AnimLib.Animator.new()
            animator.rig    = figure
            animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("Six Seven.anim"))
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
        m.Name        = "SlickBack"
        m.Description = "someone made a show about this btw"
        m.Assets = {"noober_Slickback.anim@MARKET/noobersdances/Slickback.anim", "noober_Slickback.mp3@MARKET/noobersdances/Slickback.mp3"}
    
        m.Config = function(parent)
            Util_CreateText(parent, "No settings.", 14, Enum.TextXAlignment.Center)
        end
    
        m.SaveConfig = function() return {} end
        m.LoadConfig  = function(save) end
    
        local animator = nil
        local start    = 0
    
        m.Init = function(figure)
            SetOverrideDanceMusic(AssetGetContentId("Slickback.mp3"), "SlickBack", 0.8, NumberRange.new(0, 45.5))
    
            start           = os.clock()
            animator        = AnimLib.Animator.new()
            animator.rig    = figure
            animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("Slickback.anim"))
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
        m.Name        = "Soda Pop"
        m.Description = "the movie only lasted like 1 week lmao"
        m.Assets = {"noober_SodaPop.anim@MARKET/noobersdances/SodaPop.anim", "noober_SodaPop.mp3@MARKET/noobersdances/SodaPop.mp3"}
    
        m.Config = function(parent)
            Util_CreateText(parent, "No settings.", 14, Enum.TextXAlignment.Center)
        end
    
        m.SaveConfig = function() return {} end
        m.LoadConfig  = function(save) end
    
        local animator = nil
        local start    = 0
    
        m.Init = function(figure)
            SetOverrideDanceMusic(AssetGetContentId("SodaPop.mp3"), "Soda Pop", 0.8, NumberRange.new(0, 45.5))
    
            start           = os.clock()
            animator        = AnimLib.Animator.new()
            animator.rig    = figure
            animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("SodaPop.anim"))
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
        m.Name        = "Sparta Remix"
        m.Description = "My name is grasa🔥 (spanish meme)"
        m.Assets = {"noober_SpartaRemix.anim@MARKET/noobersdances/SpartaRemix.anim", "noober_SpartaRemix.mp3@MARKET/noobersdances/SpartaRemix.mp3"}
    
        m.Config = function(parent)
            Util_CreateText(parent, "No settings.", 14, Enum.TextXAlignment.Center)
        end
    
        m.SaveConfig = function() return {} end
        m.LoadConfig  = function(save) end
    
        local animator = nil
        local start    = 0
    
        m.Init = function(figure)
            SetOverrideDanceMusic(AssetGetContentId("SpartaRemix.mp3"), "Sparta Remix", 0.8, NumberRange.new(0, 45.5))
    
            start           = os.clock()
            animator        = AnimLib.Animator.new()
            animator.rig    = figure
            animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("Sparta Remix.anim"))
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
        m.Name        = "Sparta Remix"
        m.Description = "ts bugged and didnt play the animation, hope it works now"
        m.Assets = {"noober_Sparta Remix.anim@MARKET/noobersdances/Sparta Remix.anim", "noober_Sparta Remix.mp3@MARKET/noobersdances/Sparta Remix.mp3"}
    
        m.Config = function(parent)
            Util_CreateText(parent, "No settings.", 14, Enum.TextXAlignment.Center)
        end
    
        m.SaveConfig = function() return {} end
        m.LoadConfig  = function(save) end
    
        local animator = nil
        local start    = 0
    
        m.Init = function(figure)
            SetOverrideDanceMusic(AssetGetContentId("Sparta Remix.mp3"), "Sparta Remix", 0.8, NumberRange.new(0, 45.5))
    
            start           = os.clock()
            animator        = AnimLib.Animator.new()
            animator.rig    = figure
            animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("Sparta Remix.anim"))
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
        m.Name        = "Tokyo drift"
        m.Description = "Im gonna drift, oh yeah"
        m.Assets = {"noober_Tokyo drift.anim@MARKET/noobersdances/Tokyo drift.anim", "noober_Tokyo drift.mp3@MARKET/noobersdances/Tokyo drift.mp3"}
    
        m.Config = function(parent)
            Util_CreateText(parent, "No settings.", 14, Enum.TextXAlignment.Center)
        end
    
        m.SaveConfig = function() return {} end
        m.LoadConfig  = function(save) end
    
        local animator = nil
        local start    = 0
    
        m.Init = function(figure)
            SetOverrideDanceMusic(AssetGetContentId("Tokyo drift.mp3"), "Tokyo drift", 0.8, NumberRange.new(0, 45.5))
    
            start           = os.clock()
            animator        = AnimLib.Animator.new()
            animator.rig    = figure
            animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("Tokyo drift.anim"))
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
        m.Name        = "Wait"
        m.Description = "never could say that to someone :sob:"
        m.Assets = {"noober_Wait.anim@MARKET/noobersdances/Wait.anim", "noober_Wait.mp3@MARKET/noobersdances/Wait.mp3"}
    
        m.Config = function(parent)
            Util_CreateText(parent, "No settings.", 14, Enum.TextXAlignment.Center)
        end
    
        m.SaveConfig = function() return {} end
        m.LoadConfig  = function(save) end
    
        local animator = nil
        local start    = 0
    
        m.Init = function(figure)
            SetOverrideDanceMusic(AssetGetContentId("Wait.mp3"), "Wait", 0.8, NumberRange.new(0, 45.5))
    
            start           = os.clock()
            animator        = AnimLib.Animator.new()
            animator.rig    = figure
            animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("Wait.anim"))
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
        m.Name        = "with friends"
        m.Description = "me and the friends on the lego🔥🔥"
        m.Assets = {"noober_WithFriends.anim@MARKET/noobersdances/WithFriends.anim", "noober_WithFriends.mp3@MARKET/noobersdances/WithFriends.mp3"}
    
        m.Config = function(parent)
            Util_CreateText(parent, "No settings.", 14, Enum.TextXAlignment.Center)
        end
    
        m.SaveConfig = function() return {} end
        m.LoadConfig  = function(save) end
    
        local animator = nil
        local start    = 0
    
        m.Init = function(figure)
            SetOverrideDanceMusic(AssetGetContentId("WithFriends.mp3"), "with friends", 0.8, NumberRange.new(0, 45.5))
    
            start           = os.clock()
            animator        = AnimLib.Animator.new()
            animator.rig    = figure
            animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("WithFriends.anim"))
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
        m.Name        = "XO"
        m.Description = "XOXOXOXOOXOXOXOXOXO"
        m.Assets = {"noober_XO.anim@MARKET/noobersdances/XO.anim", "noober_XO.mp3@MARKET/noobersdances/XO.mp3"}
    
        m.Config = function(parent)
            Util_CreateText(parent, "No settings.", 14, Enum.TextXAlignment.Center)
        end
    
        m.SaveConfig = function() return {} end
        m.LoadConfig  = function(save) end
    
        local animator = nil
        local start    = 0
    
        m.Init = function(figure)
            SetOverrideDanceMusic(AssetGetContentId("XO.mp3"), "XO", 0.8, NumberRange.new(0, 45.5))
    
            start           = os.clock()
            animator        = AnimLib.Animator.new()
            animator.rig    = figure
            animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("XO.anim"))
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
        m.Name        = "Ai niche baby"
        m.Description = "youre not tuff lol"
        m.Assets = {"noober_ai niche baby.anim@MARKET/noobersdances/ai niche baby.anim", "noober_ai niche baby.mp3@MARKET/noobersdances/ai niche baby.mp3"}
    
        m.Config = function(parent)
            Util_CreateText(parent, "No settings.", 14, Enum.TextXAlignment.Center)
        end
    
        m.SaveConfig = function() return {} end
        m.LoadConfig  = function(save) end
    
        local animator = nil
        local start    = 0
    
        m.Init = function(figure)
            SetOverrideDanceMusic(AssetGetContentId("ai niche baby.mp3"), "Ai niche baby", 0.8, NumberRange.new(0, 45.5))
    
            start           = os.clock()
            animator        = AnimLib.Animator.new()
            animator.rig    = figure
            animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("ai niche baby.anim"))
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
        m.Name        = "analog horror funk"
        m.Description = "so scary waaaaaa :cry:"
        m.Assets = {"noober_Analog horror funk.anim@MARKET/noobersdances/Analog horror funk.anim", "noober_Analog horror funk.mp3@MARKET/noobersdances/Analog horror funk.mp3"}
    
        m.Config = function(parent)
            Util_CreateText(parent, "No settings.", 14, Enum.TextXAlignment.Center)
        end
    
        m.SaveConfig = function() return {} end
        m.LoadConfig  = function(save) end
    
        local animator = nil
        local start    = 0
    
        m.Init = function(figure)
            SetOverrideDanceMusic(AssetGetContentId("Analog horror funk.mp3"), "analog horror funk", 0.8, NumberRange.new(0, 45.5))
    
            start           = os.clock()
            animator        = AnimLib.Animator.new()
            animator.rig    = figure
            animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("Analog horror funk.anim"))
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
        m.Name        = "angry"
        m.Description = "Im very angry"
        m.Assets = {"noober_angry.anim@MARKET/noobersdances/angry.anim", "noober_angry.mp3@MARKET/noobersdances/angry.mp3"}
    
        m.Config = function(parent)
            Util_CreateText(parent, "No settings.", 14, Enum.TextXAlignment.Center)
        end
    
        m.SaveConfig = function() return {} end
        m.LoadConfig  = function(save) end
    
        local animator = nil
        local start    = 0
    
        m.Init = function(figure)
            SetOverrideDanceMusic(AssetGetContentId("angry.mp3"), "angry", 0.8, NumberRange.new(0, 45.5))
    
            start           = os.clock()
            animator        = AnimLib.Animator.new()
            animator.rig    = figure
            animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("angry.anim"))
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
        m.Name        = "ay mi gatito"
        m.Description = "ay mi gatito meow meow"
        m.Assets = {"noober_ay mi gatito.anim@MARKET/noobersdances/ay mi gatito.anim", "noober_ay mi gatito.mp3@MARKET/noobersdances/ay mi gatito.mp3"}
    
        m.Config = function(parent)
            Util_CreateText(parent, "No settings.", 14, Enum.TextXAlignment.Center)
        end
    
        m.SaveConfig = function() return {} end
        m.LoadConfig  = function(save) end
    
        local animator = nil
        local start    = 0
    
        m.Init = function(figure)
            SetOverrideDanceMusic(AssetGetContentId("ay mi gatito.mp3"), "ay mi gatito", 0.8, NumberRange.new(0, 45.5))
    
            start           = os.clock()
            animator        = AnimLib.Animator.new()
            animator.rig    = figure
            animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("ay mi gatito.anim"))
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
        m.Name        = "Beat em up"
        m.Description = "lets beat these guys boi"
        m.Assets = {"noober_beat em up.anim@MARKET/noobersdances/beat em up.anim", "noober_beat em up.mp3@MARKET/noobersdances/beat em up.mp3"}
    
        m.Config = function(parent)
            Util_CreateText(parent, "No settings.", 14, Enum.TextXAlignment.Center)
        end
    
        m.SaveConfig = function() return {} end
        m.LoadConfig  = function(save) end
    
        local animator = nil
        local start    = 0
    
        m.Init = function(figure)
            SetOverrideDanceMusic(AssetGetContentId("beat em up.mp3"), "Beat em up", 0.8, NumberRange.new(0, 45.5))
    
            start           = os.clock()
            animator        = AnimLib.Animator.new()
            animator.rig    = figure
            animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("beat em up.anim"))
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
        m.Name        = "Bones"
        m.Description = "bones for my dog heheh"
        m.Assets = {"noober_bones.anim@MARKET/noobersdances/bones.anim", "noober_bones.mp3@MARKET/noobersdances/bones.mp3"}
    
        m.Config = function(parent)
            Util_CreateText(parent, "No settings.", 14, Enum.TextXAlignment.Center)
        end
    
        m.SaveConfig = function() return {} end
        m.LoadConfig  = function(save) end
    
        local animator = nil
        local start    = 0
    
        m.Init = function(figure)
            SetOverrideDanceMusic(AssetGetContentId("bones.mp3"), "Bones", 0.8, NumberRange.new(0, 45.5))
    
            start           = os.clock()
            animator        = AnimLib.Animator.new()
            animator.rig    = figure
            animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("bones.anim"))
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
        m.Name        = "boombox"
        m.Description = "oh yeah Im very cool and youre not"
        m.Assets = {"noober_boombox.anim@MARKET/noobersdances/boombox.anim", "noober_boombox.mp3@MARKET/noobersdances/boombox.mp3"}
    
        m.Config = function(parent)
            Util_CreateText(parent, "No settings.", 14, Enum.TextXAlignment.Center)
        end
    
        m.SaveConfig = function() return {} end
        m.LoadConfig  = function(save) end
    
        local animator = nil
        local start    = 0
    
        m.Init = function(figure)
            SetOverrideDanceMusic(AssetGetContentId("boombox.mp3"), "boombox", 0.8, NumberRange.new(0, 45.5))
    
            start           = os.clock()
            animator        = AnimLib.Animator.new()
            animator.rig    = figure
            animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("boombox.anim"))
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
        m.Name        = "boomin"
        m.Description = "kaboom, yes rico kaboom"
        m.Assets = {"noober_booming.anim@MARKET/noobersdances/booming.anim", "noober_booming.mp3@MARKET/noobersdances/booming.mp3"}
    
        m.Config = function(parent)
            Util_CreateText(parent, "No settings.", 14, Enum.TextXAlignment.Center)
        end
    
        m.SaveConfig = function() return {} end
        m.LoadConfig  = function(save) end
    
        local animator = nil
        local start    = 0
    
        m.Init = function(figure)
            SetOverrideDanceMusic(AssetGetContentId("booming.mp3"), "boomin", 0.8, NumberRange.new(0, 45.5))
    
            start           = os.clock()
            animator        = AnimLib.Animator.new()
            animator.rig    = figure
            animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("booming.anim"))
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
        m.Name        = "Brickbattler"
        m.Description = "without lyrics because of hairytwinkle..."
        m.Assets = {"noober_Brickbattler.anim@MARKET/noobersdances/Brickbattler.anim", "noober_Brickbattler.mp3@MARKET/noobersdances/Brickbattler.mp3"}
    
        m.Config = function(parent)
            Util_CreateText(parent, "No settings.", 14, Enum.TextXAlignment.Center)
        end
    
        m.SaveConfig = function() return {} end
        m.LoadConfig  = function(save) end
    
        local animator = nil
        local start    = 0
    
        m.Init = function(figure)
            SetOverrideDanceMusic(AssetGetContentId("Brickbattler.mp3"), "Brickbattler", 0.8, NumberRange.new(0, 45.5))
    
            start           = os.clock()
            animator        = AnimLib.Animator.new()
            animator.rig    = figure
            animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("Brickbattler.anim"))
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
        m.Name        = "bumblebee"
        m.Description = "Im a bumblebee :3"
        m.Assets = {"noober_bumblebee.anim@MARKET/noobersdances/bumblebee.anim", "noober_bumblebee.mp3@MARKET/noobersdances/bumblebee.mp3"}
    
        m.Config = function(parent)
            Util_CreateText(parent, "No settings.", 14, Enum.TextXAlignment.Center)
        end
    
        m.SaveConfig = function() return {} end
        m.LoadConfig  = function(save) end
    
        local animator = nil
        local start    = 0
    
        m.Init = function(figure)
            SetOverrideDanceMusic(AssetGetContentId("bumblebee.mp3"), "bumblebee", 0.8, NumberRange.new(0, 45.5))
    
            start           = os.clock()
            animator        = AnimLib.Animator.new()
            animator.rig    = figure
            animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("bumblebee.anim"))
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
        m.Name        = "Butcher vanity"
        m.Description = "my wife fr, if someone says its not Ill shoot him"
        m.Assets = {"noober_butcher vanity.anim@MARKET/noobersdances/butcher vanity.anim", "noober_butcher vanity.mp3@MARKET/noobersdances/butcher vanity.mp3"}
    
        m.Config = function(parent)
            Util_CreateText(parent, "No settings.", 14, Enum.TextXAlignment.Center)
        end
    
        m.SaveConfig = function() return {} end
        m.LoadConfig  = function(save) end
    
        local animator = nil
        local start    = 0
    
        m.Init = function(figure)
            SetOverrideDanceMusic(AssetGetContentId("butcher vanity.mp3"), "Butcher vanity", 0.8, NumberRange.new(0, 45.5))
    
            start           = os.clock()
            animator        = AnimLib.Animator.new()
            animator.rig    = figure
            animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("butcher vanity.anim"))
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
        m.Name        = "cafeteria"
        m.Description = "a coffee pls"
        m.Assets = {"noober_cafeteria.anim@MARKET/noobersdances/cafeteria.anim", "noober_cafeteria.mp3@MARKET/noobersdances/cafeteria.mp3"}
    
        m.Config = function(parent)
            Util_CreateText(parent, "No settings.", 14, Enum.TextXAlignment.Center)
        end
    
        m.SaveConfig = function() return {} end
        m.LoadConfig  = function(save) end
    
        local animator = nil
        local start    = 0
    
        m.Init = function(figure)
            SetOverrideDanceMusic(AssetGetContentId("cafeteria.mp3"), "cafeteria", 0.8, NumberRange.new(0, 45.5))
    
            start           = os.clock()
            animator        = AnimLib.Animator.new()
            animator.rig    = figure
            animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("cafeteria.anim"))
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
        m.Name        = "Close to you"
        m.Description = "close to meeeee.... i think this is not the jsab song"
        m.Assets = {"noober_close to you.anim@MARKET/noobersdances/close to you.anim", "noober_close to you.mp3@MARKET/noobersdances/close to you.mp3"}
    
        m.Config = function(parent)
            Util_CreateText(parent, "No settings.", 14, Enum.TextXAlignment.Center)
        end
    
        m.SaveConfig = function() return {} end
        m.LoadConfig  = function(save) end
    
        local animator = nil
        local start    = 0
    
        m.Init = function(figure)
            SetOverrideDanceMusic(AssetGetContentId("close to you.mp3"), "Close to you", 0.8, NumberRange.new(0, 45.5))
    
            start           = os.clock()
            animator        = AnimLib.Animator.new()
            animator.rig    = figure
            animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("close to you.anim"))
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
        m.Name        = "Club Penguin"
        m.Description = "pls comeback club penguin we miss you"
        m.Assets = {"noober_clubPenguin.anim@MARKET/noobersdances/clubPenguin.anim", "noober_clubPenguin.mp3@MARKET/noobersdances/clubPenguin.mp3"}
    
        m.Config = function(parent)
            Util_CreateText(parent, "No settings.", 14, Enum.TextXAlignment.Center)
        end
    
        m.SaveConfig = function() return {} end
        m.LoadConfig  = function(save) end
    
        local animator = nil
        local start    = 0
    
        m.Init = function(figure)
            SetOverrideDanceMusic(AssetGetContentId("clubPenguin.mp3"), "Club Penguin", 0.8, NumberRange.new(0, 45.5))
    
            start           = os.clock()
            animator        = AnimLib.Animator.new()
            animator.rig    = figure
            animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("clubPenguin.anim"))
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
        m.Name        = "coffin"
        m.Description = "I ran out of ideas for this one srry"
        m.Assets = {"noober_coffin.anim@MARKET/noobersdances/coffin.anim", "noober_coffin.mp3@MARKET/noobersdances/coffin.mp3"}
    
        m.Config = function(parent)
            Util_CreateText(parent, "No settings.", 14, Enum.TextXAlignment.Center)
        end
    
        m.SaveConfig = function() return {} end
        m.LoadConfig  = function(save) end
    
        local animator = nil
        local start    = 0
    
        m.Init = function(figure)
            SetOverrideDanceMusic(AssetGetContentId("coffin.mp3"), "coffin", 0.8, NumberRange.new(0, 45.5))
    
            start           = os.clock()
            animator        = AnimLib.Animator.new()
            animator.rig    = figure
            animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("coffin.anim"))
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
        m.Name        = "company groove"
        m.Description = "dont use it for bad, Im watching you"
        m.Assets = {"noober_company groove.anim@MARKET/noobersdances/company groove.anim", "noober_company groove.mp3@MARKET/noobersdances/company groove.mp3"}
    
        m.Config = function(parent)
            Util_CreateText(parent, "No settings.", 14, Enum.TextXAlignment.Center)
        end
    
        m.SaveConfig = function() return {} end
        m.LoadConfig  = function(save) end
    
        local animator = nil
        local start    = 0
    
        m.Init = function(figure)
            SetOverrideDanceMusic(AssetGetContentId("company groove.mp3"), "company groove", 0.8, NumberRange.new(0, 45.5))
    
            start           = os.clock()
            animator        = AnimLib.Animator.new()
            animator.rig    = figure
            animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("company groove.anim"))
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
        m.Name        = "Conga"
        m.Description = "look guys, a conga dance"
        m.Assets = {"noober_conga.anim@MARKET/noobersdances/conga.anim", "noober_conga.mp3@MARKET/noobersdances/conga.mp3"}
    
        m.Config = function(parent)
            Util_CreateText(parent, "No settings.", 14, Enum.TextXAlignment.Center)
        end
    
        m.SaveConfig = function() return {} end
        m.LoadConfig  = function(save) end
    
        local animator = nil
        local start    = 0
    
        m.Init = function(figure)
            SetOverrideDanceMusic(AssetGetContentId("conga.mp3"), "Conga", 0.8, NumberRange.new(0, 45.5))
    
            start           = os.clock()
            animator        = AnimLib.Animator.new()
            animator.rig    = figure
            animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("conga.anim"))
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
        m.Name        = "criss cross"
        m.Description = "peak dance"
        m.Assets = {"noober_criss cross.anim@MARKET/noobersdances/criss cross.anim", "noober_criss cross.mp3@MARKET/noobersdances/criss cross.mp3"}
    
        m.Config = function(parent)
            Util_CreateText(parent, "No settings.", 14, Enum.TextXAlignment.Center)
        end
    
        m.SaveConfig = function() return {} end
        m.LoadConfig  = function(save) end
    
        local animator = nil
        local start    = 0
    
        m.Init = function(figure)
            SetOverrideDanceMusic(AssetGetContentId("criss cross.mp3"), "criss cross", 0.8, NumberRange.new(0, 45.5))
    
            start           = os.clock()
            animator        = AnimLib.Animator.new()
            animator.rig    = figure
            animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("criss cross.anim"))
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
        m.Name        = "cry for me (evilsaken)"
        m.Description = "I want you to search a job"
        m.Assets = {"noober_cry for me v2.anim@MARKET/noobersdances/cry for me v2.anim", "noober_cry for me v2.mp3@MARKET/noobersdances/cry for me v2.mp3"}
    
        m.Config = function(parent)
            Util_CreateText(parent, "No settings.", 14, Enum.TextXAlignment.Center)
        end
    
        m.SaveConfig = function() return {} end
        m.LoadConfig  = function(save) end
    
        local animator = nil
        local start    = 0
    
        m.Init = function(figure)
            SetOverrideDanceMusic(AssetGetContentId("cry for me v2.mp3"), "cry for me (evilsaken)", 0.8, NumberRange.new(0, 45.5))
    
            start           = os.clock()
            animator        = AnimLib.Animator.new()
            animator.rig    = figure
            animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("cry for me v2.anim"))
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
        m.Name        = "Cupid"
        m.Description = "I wish it was jack stauber cupid"
        m.Assets = {"noober_cupid.anim@MARKET/noobersdances/cupid.anim", "noober_cupid.mp3@MARKET/noobersdances/cupid.mp3"}
    
        m.Config = function(parent)
            Util_CreateText(parent, "No settings.", 14, Enum.TextXAlignment.Center)
        end
    
        m.SaveConfig = function() return {} end
        m.LoadConfig  = function(save) end
    
        local animator = nil
        local start    = 0
    
        m.Init = function(figure)
            SetOverrideDanceMusic(AssetGetContentId("cupid.mp3"), "Cupid", 0.8, NumberRange.new(0, 45.5))
    
            start           = os.clock()
            animator        = AnimLib.Animator.new()
            animator.rig    = figure
            animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("cupid.anim"))
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
        m.Name        = "Doomer"
        m.Description = "Doomer✅✅✅✅✅✅✅✅✅"
        m.Assets = {"noober_doomer.anim@MARKET/noobersdances/doomer.anim", "noober_doomer.mp3@MARKET/noobersdances/doomer.mp3"}
    
        m.Config = function(parent)
            Util_CreateText(parent, "No settings.", 14, Enum.TextXAlignment.Center)
        end
    
        m.SaveConfig = function() return {} end
        m.LoadConfig  = function(save) end
    
        local animator = nil
        local start    = 0
    
        m.Init = function(figure)
            SetOverrideDanceMusic(AssetGetContentId("doomer.mp3"), "Doomer", 0.8, NumberRange.new(0, 45.5))
    
            start           = os.clock()
            animator        = AnimLib.Animator.new()
            animator.rig    = figure
            animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("doomer.anim"))
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
        m.Name        = "Down"
        m.Description = "oh yeah time to get down"
        m.Assets = {"noober_down.anim@MARKET/noobersdances/down.anim", "noober_down.mp3@MARKET/noobersdances/down.mp3"}
    
        m.Config = function(parent)
            Util_CreateText(parent, "No settings.", 14, Enum.TextXAlignment.Center)
        end
    
        m.SaveConfig = function() return {} end
        m.LoadConfig  = function(save) end
    
        local animator = nil
        local start    = 0
    
        m.Init = function(figure)
            SetOverrideDanceMusic(AssetGetContentId("down.mp3"), "Down", 0.8, NumberRange.new(0, 45.5))
    
            start           = os.clock()
            animator        = AnimLib.Animator.new()
            animator.rig    = figure
            animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("down.anim"))
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
        m.Name        = "DownTown funk"
        m.Description = "ohhh ohhh wish a wish a khew khew"
        m.Assets = {"noober_downtown.anim@MARKET/noobersdances/downtown.anim", "noober_downtown.mp3@MARKET/noobersdances/downtown.mp3"}
    
        m.Config = function(parent)
            Util_CreateText(parent, "No settings.", 14, Enum.TextXAlignment.Center)
        end
    
        m.SaveConfig = function() return {} end
        m.LoadConfig  = function(save) end
    
        local animator = nil
        local start    = 0
    
        m.Init = function(figure)
            SetOverrideDanceMusic(AssetGetContentId("downtown.mp3"), "downtown", 0.8, NumberRange.new(0, 45.5))
    
            start           = os.clock()
            animator        = AnimLib.Animator.new()
            animator.rig    = figure
            animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("downtown.anim"))
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
        m.Name        = "Electronic swing"
        m.Description = "time to get electronic with this"
        m.Assets = {"noober_electro swing.anim@MARKET/noobersdances/electro swing.anim", "noober_electro swing.mp3@MARKET/noobersdances/electro swing.mp3"}
    
        m.Config = function(parent)
            Util_CreateText(parent, "No settings.", 14, Enum.TextXAlignment.Center)
        end
    
        m.SaveConfig = function() return {} end
        m.LoadConfig  = function(save) end
    
        local animator = nil
        local start    = 0
    
        m.Init = function(figure)
            SetOverrideDanceMusic(AssetGetContentId("electro swing.mp3"), "Electronic Swing", 0.8, NumberRange.new(0, 45.5))
    
            start           = os.clock()
            animator        = AnimLib.Animator.new()
            animator.rig    = figure
            animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("electro swing.anim"))
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
        m.Name        = "engineer taunt"
        m.Description = "this emote makes me question my life"
        m.Assets = {"noober_engineer taunt.anim@MARKET/noobersdances/engineer taunt.anim", "noober_engineer taunt.mp3@MARKET/noobersdances/engineer taunt.mp3"}
    
        m.Config = function(parent)
            Util_CreateText(parent, "No settings.", 14, Enum.TextXAlignment.Center)
        end
    
        m.SaveConfig = function() return {} end
        m.LoadConfig  = function(save) end
    
        local animator = nil
        local start    = 0
    
        m.Init = function(figure)
            SetOverrideDanceMusic(AssetGetContentId("engineer taunt.mp3"), "engineer taunt", 0.8, NumberRange.new(0, 45.5))
    
            start           = os.clock()
            animator        = AnimLib.Animator.new()
            animator.rig    = figure
            animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("engineer taunt.anim"))
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
        m.Name        = "epical"
        m.Description = "we are epical and moderators"
        m.Assets = {"noober_epical.anim@MARKET/noobersdances/epical.anim", "noober_epical.mp3@MARKET/noobersdances/epical.mp3"}
    
        m.Config = function(parent)
            Util_CreateText(parent, "No settings.", 14, Enum.TextXAlignment.Center)
        end
    
        m.SaveConfig = function() return {} end
        m.LoadConfig  = function(save) end
    
        local animator = nil
        local start    = 0
    
        m.Init = function(figure)
            SetOverrideDanceMusic(AssetGetContentId("epical.mp3"), "epical", 0.8, NumberRange.new(0, 45.5))
    
            start           = os.clock()
            animator        = AnimLib.Animator.new()
            animator.rig    = figure
            animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("epical.anim"))
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
        m.Name        = "firework"
        m.Description = "bayby im a firewooooooork"
        m.Assets = {"noober_firework.anim@MARKET/noobersdances/firework.anim", "noober_firework.mp3@MARKET/noobersdances/firework.mp3"}
    
        m.Config = function(parent)
            Util_CreateText(parent, "No settings.", 14, Enum.TextXAlignment.Center)
        end
    
        m.SaveConfig = function() return {} end
        m.LoadConfig  = function(save) end
    
        local animator = nil
        local start    = 0
    
        m.Init = function(figure)
            SetOverrideDanceMusic(AssetGetContentId("firework.mp3"), "firework", 0.8, NumberRange.new(0, 45.5))
    
            start           = os.clock()
            animator        = AnimLib.Animator.new()
            animator.rig    = figure
            animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("firework.anim"))
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
        m.Name        = "floss"
        m.Description = "im very cool mama"
        m.Assets = {"noober_floss.anim@MARKET/noobersdances/floss.anim", "noober_floss.mp3@MARKET/noobersdances/floss.mp3"}
    
        m.Config = function(parent)
            Util_CreateText(parent, "No settings.", 14, Enum.TextXAlignment.Center)
        end
    
        m.SaveConfig = function() return {} end
        m.LoadConfig  = function(save) end
    
        local animator = nil
        local start    = 0
    
        m.Init = function(figure)
            SetOverrideDanceMusic(AssetGetContentId("floss.mp3"), "floss", 0.8, NumberRange.new(0, 45.5))
    
            start           = os.clock()
            animator        = AnimLib.Animator.new()
            animator.rig    = figure
            animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("floss.anim"))
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
        m.Name        = "Gnarly"
        m.Description = "thanks bluuman to telling me the name of the dance"
        m.Assets = {"noober_gnarly.anim@MARKET/noobersdances/gnarly.anim", "noober_gnarly.mp3@MARKET/noobersdances/gnarly.mp3"}
    
        m.Config = function(parent)
            Util_CreateText(parent, "No settings.", 14, Enum.TextXAlignment.Center)
        end
    
        m.SaveConfig = function() return {} end
        m.LoadConfig  = function(save) end
    
        local animator = nil
        local start    = 0
    
        m.Init = function(figure)
            SetOverrideDanceMusic(AssetGetContentId("gnarly.mp3"), "Gnarly", 0.8, NumberRange.new(0, 45.5))
    
            start           = os.clock()
            animator        = AnimLib.Animator.new()
            animator.rig    = figure
            animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("gnarly.anim"))
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
        m.Name        = "mufasa"
        m.Description = "hypno dance eoeo h- wrong dance srry"
        m.Assets = {"noober_go mufasa.anim@MARKET/noobersdances/go mufasa.anim", "noober_go mufasa.mp3@MARKET/noobersdances/go mufasa.mp3"}
    
        m.Config = function(parent)
            Util_CreateText(parent, "No settings.", 14, Enum.TextXAlignment.Center)
        end
    
        m.SaveConfig = function() return {} end
        m.LoadConfig  = function(save) end
    
        local animator = nil
        local start    = 0
    
        m.Init = function(figure)
            SetOverrideDanceMusic(AssetGetContentId("go mufasa.mp3"), "mufasa", 0.8, NumberRange.new(0, 45.5))
    
            start           = os.clock()
            animator        = AnimLib.Animator.new()
            animator.rig    = figure
            animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("go mufasa.anim"))
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
        m.Name        = "goat simulator"
        m.Description = "me and the bois playing this in 2014"
        m.Assets = {"noober_goat simulator.anim@MARKET/noobersdances/goat simulator.anim", "noober_goat simulator.mp3@MARKET/noobersdances/goat simulator.mp3"}
    
        m.Config = function(parent)
            Util_CreateText(parent, "No settings.", 14, Enum.TextXAlignment.Center)
        end
    
        m.SaveConfig = function() return {} end
        m.LoadConfig  = function(save) end
    
        local animator = nil
        local start    = 0
    
        m.Init = function(figure)
            SetOverrideDanceMusic(AssetGetContentId("goat simulator.mp3"), "goat simulator", 0.8, NumberRange.new(0, 45.5))
    
            start           = os.clock()
            animator        = AnimLib.Animator.new()
            animator.rig    = figure
            animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("goat simulator.anim"))
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
        m.Name        = "Gojo"
        m.Description = "imagine being a KitKat, thats so LLLLL"
        m.Assets = {"noober_gojo.anim@MARKET/noobersdances/gojo.anim", "noober_gojo.mp3@MARKET/noobersdances/gojo.mp3"}
    
        m.Config = function(parent)
            Util_CreateText(parent, "No settings.", 14, Enum.TextXAlignment.Center)
        end
    
        m.SaveConfig = function() return {} end
        m.LoadConfig  = function(save) end
    
        local animator = nil
        local start    = 0
    
        m.Init = function(figure)
            SetOverrideDanceMusic(AssetGetContentId("gojo.mp3"), "Gojo", 0.8, NumberRange.new(0, 45.5))
    
            start           = os.clock()
            animator        = AnimLib.Animator.new()
            animator.rig    = figure
            animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("gojo.anim"))
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
        m.Name        = "Griddy"
        m.Description = "we hitting the Griddy with this"
        m.Assets = {"noober_griddy.anim@MARKET/noobersdances/griddy.anim", "noober_griddy.mp3@MARKET/noobersdances/griddy.mp3"}
    
        m.Config = function(parent)
            Util_CreateText(parent, "No settings.", 14, Enum.TextXAlignment.Center)
        end
    
        m.SaveConfig = function() return {} end
        m.LoadConfig  = function(save) end
    
        local animator = nil
        local start    = 0
    
        m.Init = function(figure)
            SetOverrideDanceMusic(AssetGetContentId("griddy.mp3"), "Griddy", 0.8, NumberRange.new(0, 45.5))
    
            start           = os.clock()
            animator        = AnimLib.Animator.new()
            animator.rig    = figure
            animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("griddy.anim"))
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
        m.Name        = "I just hit the jackpot"
        m.Description = "when you win 10 femboys with maid"
        m.Assets = {"noober_Hit the jackpot.anim@MARKET/noobersdances/Hit the jackpot.anim", "noober_Hit the jackpot.mp3@MARKET/noobersdances/Hit the jackpot.mp3"}
    
        m.Config = function(parent)
            Util_CreateText(parent, "No settings.", 14, Enum.TextXAlignment.Center)
        end
    
        m.SaveConfig = function() return {} end
        m.LoadConfig  = function(save) end
    
        local animator = nil
        local start    = 0
    
        m.Init = function(figure)
            SetOverrideDanceMusic(AssetGetContentId("Hit the jackpot.mp3"), "I just hit the jackpot", 0.8, NumberRange.new(0, 45.5))
    
            start           = os.clock()
            animator        = AnimLib.Animator.new()
            animator.rig    = figure
            animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("Hit the jackpot.anim"))
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
        m.Name        = "ice cream"
        m.Description = "one for me pls"
        m.Assets = {"noober_ice cream.anim@MARKET/noobersdances/ice cream.anim", "noober_ice cream.mp3@MARKET/noobersdances/ice cream.mp3"}
    
        m.Config = function(parent)
            Util_CreateText(parent, "No settings.", 14, Enum.TextXAlignment.Center)
        end
    
        m.SaveConfig = function() return {} end
        m.LoadConfig  = function(save) end
    
        local animator = nil
        local start    = 0
    
        m.Init = function(figure)
            SetOverrideDanceMusic(AssetGetContentId("ice cream.mp3"), "ice cream", 0.8, NumberRange.new(0, 45.5))
    
            start           = os.clock()
            animator        = AnimLib.Animator.new()
            animator.rig    = figure
            animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("ice cream.anim"))
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
        m.Name        = "IDK"
        m.Description = "forgot the name while making this so if someone khows the name pls dm me"
        m.Assets = {"noober_idk.anim@MARKET/noobersdances/idk.anim", "noober_idk.mp3@MARKET/noobersdances/idk.mp3"}
    
        m.Config = function(parent)
            Util_CreateText(parent, "No settings.", 14, Enum.TextXAlignment.Center)
        end
    
        m.SaveConfig = function() return {} end
        m.LoadConfig  = function(save) end
    
        local animator = nil
        local start    = 0
    
        m.Init = function(figure)
            SetOverrideDanceMusic(AssetGetContentId("idk.mp3"), "IDK", 0.8, NumberRange.new(0, 45.5))
    
            start           = os.clock()
            animator        = AnimLib.Animator.new()
            animator.rig    = figure
            animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("idk.anim"))
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
        m.Name        = "kj unlimited flexworks"
        m.Description = "jk but not from shein"
        m.Assets = {"noober_kj unlimited.anim@MARKET/noobersdances/kj unlimited.anim", "noober_kj unlimited.mp3@MARKET/noobersdances/kj unlimited.mp3"}
    
        m.Config = function(parent)
            Util_CreateText(parent, "No settings.", 14, Enum.TextXAlignment.Center)
        end
    
        m.SaveConfig = function() return {} end
        m.LoadConfig  = function(save) end
    
        local animator = nil
        local start    = 0
    
        m.Init = function(figure)
            SetOverrideDanceMusic(AssetGetContentId("kj unlimited.mp3"), "kj unlimited flexworks", 0.8, NumberRange.new(0, 45.5))
    
            start           = os.clock()
            animator        = AnimLib.Animator.new()
            animator.rig    = figure
            animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("kj unlimited.anim"))
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
        m.Name        = "konton boogie"
        m.Description = "boogie boogie"
        m.Assets = {"noober_konton boogie.anim@MARKET/noobersdances/konton boogie.anim", "noober_konton boogie.mp3@MARKET/noobersdances/konton boogie.mp3"}
    
        m.Config = function(parent)
            Util_CreateText(parent, "No settings.", 14, Enum.TextXAlignment.Center)
        end
    
        m.SaveConfig = function() return {} end
        m.LoadConfig  = function(save) end
    
        local animator = nil
        local start    = 0
    
        m.Init = function(figure)
            SetOverrideDanceMusic(AssetGetContentId("konton boogie.mp3"), "konton boogie", 0.8, NumberRange.new(0, 45.5))
    
            start           = os.clock()
            animator        = AnimLib.Animator.new()
            animator.rig    = figure
            animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("konton boogie.anim"))
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
        m.Name        = "Locked"
        m.Description = "dont you dare to offend us boiii"
        m.Assets = {"noober_locked.anim@MARKET/noobersdances/locked.anim", "noober_locked.mp3@MARKET/noobersdances/locked.mp3"}
    
        m.Config = function(parent)
            Util_CreateText(parent, "No settings.", 14, Enum.TextXAlignment.Center)
        end
    
        m.SaveConfig = function() return {} end
        m.LoadConfig  = function(save) end
    
        local animator = nil
        local start    = 0
    
        m.Init = function(figure)
            SetOverrideDanceMusic(AssetGetContentId("locked.mp3"), "Locked", 0.8, NumberRange.new(0, 45.5))
    
            start           = os.clock()
            animator        = AnimLib.Animator.new()
            animator.rig    = figure
            animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("locked.anim"))
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
        m.Name        = "lucky"
        m.Description = "I have luck on my side hehe"
        m.Assets = {"noober_lucky.anim@MARKET/noobersdances/lucky.anim", "noober_lucky.mp3@MARKET/noobersdances/lucky.mp3"}
    
        m.Config = function(parent)
            Util_CreateText(parent, "No settings.", 14, Enum.TextXAlignment.Center)
        end
    
        m.SaveConfig = function() return {} end
        m.LoadConfig  = function(save) end
    
        local animator = nil
        local start    = 0
    
        m.Init = function(figure)
            SetOverrideDanceMusic(AssetGetContentId("lucky.mp3"), "lucky", 0.8, NumberRange.new(0, 45.5))
    
            start           = os.clock()
            animator        = AnimLib.Animator.new()
            animator.rig    = figure
            animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("lucky.anim"))
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
        m.Name        = "lush life"
        m.Description = "we gotta lush at the life"
        m.Assets = {"noober_lush life.anim@MARKET/noobersdances/lush life.anim", "noober_lush life.mp3@MARKET/noobersdances/lush life.mp3"}
    
        m.Config = function(parent)
            Util_CreateText(parent, "No settings.", 14, Enum.TextXAlignment.Center)
        end
    
        m.SaveConfig = function() return {} end
        m.LoadConfig  = function(save) end
    
        local animator = nil
        local start    = 0
    
        m.Init = function(figure)
            SetOverrideDanceMusic(AssetGetContentId("lush life.mp3"), "lush life", 0.8, NumberRange.new(0, 45.5))
    
            start           = os.clock()
            animator        = AnimLib.Animator.new()
            animator.rig    = figure
            animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("lush life.anim"))
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
        m.Name        = "Mambo"
        m.Description = "mambo or mangos"
        m.Assets = {"noober_mambo.anim@MARKET/noobersdances/mambo.anim", "noober_mambo.mp3@MARKET/noobersdances/mambo.mp3"}
    
        m.Config = function(parent)
            Util_CreateText(parent, "No settings.", 14, Enum.TextXAlignment.Center)
        end
    
        m.SaveConfig = function() return {} end
        m.LoadConfig  = function(save) end
    
        local animator = nil
        local start    = 0
    
        m.Init = function(figure)
            SetOverrideDanceMusic(AssetGetContentId("mambo.mp3"), "Mambo", 0.8, NumberRange.new(0, 45.5))
    
            start           = os.clock()
            animator        = AnimLib.Animator.new()
            animator.rig    = figure
            animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("mambo.anim"))
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
        m.Name        = "miku miku beam"
        m.Description = "miku is better than teto frfrfrfr"
        m.Assets = {"noober_miku miku beam.anim@MARKET/noobersdances/miku miku beam.anim", "noober_miku miku beam.mp3@MARKET/noobersdances/miku miku beam.mp3"}
    
        m.Config = function(parent)
            Util_CreateText(parent, "No settings.", 14, Enum.TextXAlignment.Center)
        end
    
        m.SaveConfig = function() return {} end
        m.LoadConfig  = function(save) end
    
        local animator = nil
        local start    = 0
    
        m.Init = function(figure)
            SetOverrideDanceMusic(AssetGetContentId("miku miku beam.mp3"), "miku miku beam", 0.8, NumberRange.new(0, 45.5))
    
            start           = os.clock()
            animator        = AnimLib.Animator.new()
            animator.rig    = figure
            animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("miku miku beam.anim"))
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
        m.Name        = "miss the quiet"
        m.Description = "4 minute dance, daaam"
        m.Assets = {"noober_miss the quiet.anim@MARKET/noobersdances/miss the quiet.anim", "noober_miss the quiet.mp3@MARKET/noobersdances/miss the quiet.mp3"}
    
        m.Config = function(parent)
            Util_CreateText(parent, "No settings.", 14, Enum.TextXAlignment.Center)
        end
    
        m.SaveConfig = function() return {} end
        m.LoadConfig  = function(save) end
    
        local animator = nil
        local start    = 0
    
        m.Init = function(figure)
            SetOverrideDanceMusic(AssetGetContentId("miss the quiet.mp3"), "miss the quiet", 0.8, NumberRange.new(0, 45.5))
    
            start           = os.clock()
            animator        = AnimLib.Animator.new()
            animator.rig    = figure
            animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("miss the quiet.anim"))
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
        m.Name        = "monster"
        m.Description = "holy shi, Eminem"
        m.Assets = {"noober_monster.anim@MARKET/noobersdances/monster.anim", "noober_monster.mp3@MARKET/noobersdances/monster.mp3"}
    
        m.Config = function(parent)
            Util_CreateText(parent, "No settings.", 14, Enum.TextXAlignment.Center)
        end
    
        m.SaveConfig = function() return {} end
        m.LoadConfig  = function(save) end
    
        local animator = nil
        local start    = 0
    
        m.Init = function(figure)
            SetOverrideDanceMusic(AssetGetContentId("monster.mp3"), "monster", 0.8, NumberRange.new(0, 45.5))
    
            start           = os.clock()
            animator        = AnimLib.Animator.new()
            animator.rig    = figure
            animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("monster.anim"))
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
        m.Name        = "muffin time"
        m.Description = "what time is it"
        m.Assets = {"noober_muffin time.anim@MARKET/noobersdances/muffin time.anim", "noober_muffin time.mp3@MARKET/noobersdances/muffin time.mp3"}
    
        m.Config = function(parent)
            Util_CreateText(parent, "No settings.", 14, Enum.TextXAlignment.Center)
        end
    
        m.SaveConfig = function() return {} end
        m.LoadConfig  = function(save) end
    
        local animator = nil
        local start    = 0
    
        m.Init = function(figure)
            SetOverrideDanceMusic(AssetGetContentId("muffin time.mp3"), "muffin time", 0.8, NumberRange.new(0, 45.5))
    
            start           = os.clock()
            animator        = AnimLib.Animator.new()
            animator.rig    = figure
            animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("muffin time.anim"))
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
        m.Name        = "Orange Justice"
        m.Description = "Im shooting you if you say its from skibidi toilet"
        m.Assets = {"noober_Orange justice.anim@MARKET/noobersdances/Orange justice.anim", "noober_Orange justice.mp3@MARKET/noobersdances/Orange justice.mp3"}
    
        m.Config = function(parent)
            Util_CreateText(parent, "No settings.", 14, Enum.TextXAlignment.Center)
        end
    
        m.SaveConfig = function() return {} end
        m.LoadConfig  = function(save) end
    
        local animator = nil
        local start    = 0
    
        m.Init = function(figure)
            SetOverrideDanceMusic(AssetGetContentId("Orange justice.mp3"), "Orange Justice", 0.8, NumberRange.new(0, 45.5))
    
            start           = os.clock()
            animator        = AnimLib.Animator.new()
            animator.rig    = figure
            animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("Orange justice.anim"))
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
        m.Name        = "Otsukare Summer"
        m.Description = "can someone be my friend so I have someone to dance with?"
        m.Assets = {"noober_otsukare.anim@MARKET/noobersdances/otsukare.anim", "noober_otsukare.mp3@MARKET/noobersdances/otsukare.mp3"}
    
        m.Config = function(parent)
            Util_CreateText(parent, "No settings.", 14, Enum.TextXAlignment.Center)
        end
    
        m.SaveConfig = function() return {} end
        m.LoadConfig  = function(save) end
    
        local animator = nil
        local start    = 0
    
        m.Init = function(figure)
            SetOverrideDanceMusic(AssetGetContentId("otsukare.mp3"), "Otsukare Summer", 0.8, NumberRange.new(0, 45.5))
    
            start           = os.clock()
            animator        = AnimLib.Animator.new()
            animator.rig    = figure
            animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("otsukare.anim"))
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
        m.Name        = "parrot party"
        m.Description = "dont mind me chilling in Minecraft"
        m.Assets = {"noober_PARROT PARTY.anim@MARKET/noobersdances/PARROT PARTY.anim", "noober_PARROT PARTY.mp3@MARKET/noobersdances/PARROT PARTY.mp3"}
    
        m.Config = function(parent)
            Util_CreateText(parent, "No settings.", 14, Enum.TextXAlignment.Center)
        end
    
        m.SaveConfig = function() return {} end
        m.LoadConfig  = function(save) end
    
        local animator = nil
        local start    = 0
    
        m.Init = function(figure)
            SetOverrideDanceMusic(AssetGetContentId("PARROT PARTY.mp3"), "parrot party", 0.8, NumberRange.new(0, 45.5))
    
            start           = os.clock()
            animator        = AnimLib.Animator.new()
            animator.rig    = figure
            animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("PARROT PARTY.anim"))
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
        m.Name        = "Pick Up The Phone"
        m.Description = "is that a forsaken reference?!?! (pls get the joke)"
        m.Assets = {"noober_PickThePhone.anim@MARKET/noobersdances/PickThePhone.anim", "noober_PIckThePhone.mp3@MARKET/noobersdances/PIckThePhone.mp3"}
    
        m.Config = function(parent)
            Util_CreateText(parent, "No settings.", 14, Enum.TextXAlignment.Center)
        end
    
        m.SaveConfig = function() return {} end
        m.LoadConfig  = function(save) end
    
        local animator = nil
        local start    = 0
    
        m.Init = function(figure)
            SetOverrideDanceMusic(AssetGetContentId("PickThePhone.mp3"), "Pick Up The Phone", 0.8, NumberRange.new(0, 45.5))
    
            start           = os.clock()
            animator        = AnimLib.Animator.new()
            animator.rig    = figure
            animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("PickThePhone.anim"))
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
        m.Name        = "popStar"
        m.Description = "youre my rockstar"
        m.Assets = {"noober_popStar.anim@MARKET/noobersdances/popStar.anim", "noober_popStar.mp3@MARKET/noobersdances/popStar.mp3"}
    
        m.Config = function(parent)
            Util_CreateText(parent, "No settings.", 14, Enum.TextXAlignment.Center)
        end
    
        m.SaveConfig = function() return {} end
        m.LoadConfig  = function(save) end
    
        local animator = nil
        local start    = 0
    
        m.Init = function(figure)
            SetOverrideDanceMusic(AssetGetContentId("popStar.mp3"), "popStar", 0.8, NumberRange.new(0, 45.5))
    
            start           = os.clock()
            animator        = AnimLib.Animator.new()
            animator.rig    = figure
            animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("popStar.anim"))
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
        m.Name        = "Schadenfreude"
        m.Description = "pls don't use it to be toxic yk"
        m.Assets = {"noober_schadenfreude.anim@MARKET/noobersdances/schadenfreude.anim", "noober_schadenfreude.mp3@MARKET/noobersdances/schadenfreude.mp3"}
    
        m.Config = function(parent)
            Util_CreateText(parent, "No settings.", 14, Enum.TextXAlignment.Center)
        end
    
        m.SaveConfig = function() return {} end
        m.LoadConfig  = function(save) end
    
        local animator = nil
        local start    = 0
    
        m.Init = function(figure)
            SetOverrideDanceMusic(AssetGetContentId("schadenfreude.mp3"), "Schadenfreude", 0.8, NumberRange.new(0, 45.5))
    
            start           = os.clock()
            animator        = AnimLib.Animator.new()
            animator.rig    = figure
            animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("schadenfreude.anim"))
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
        m.Name        = "shake it"
        m.Description = "oh yeah time to shake our"
        m.Assets = {"noober_shake it.anim@MARKET/noobersdances/shake it.anim", "noober_shake it.mp3@MARKET/noobersdances/shake it.mp3"}
    
        m.Config = function(parent)
            Util_CreateText(parent, "No settings.", 14, Enum.TextXAlignment.Center)
        end
    
        m.SaveConfig = function() return {} end
        m.LoadConfig  = function(save) end
    
        local animator = nil
        local start    = 0
    
        m.Init = function(figure)
            SetOverrideDanceMusic(AssetGetContentId("shake it.mp3"), "shake it", 0.8, NumberRange.new(0, 45.5))
    
            start           = os.clock()
            animator        = AnimLib.Animator.new()
            animator.rig    = figure
            animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("shake it.anim"))
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
        m.Name        = "Shattered hopes"
        m.Description = "when someone ships you with a man"
        m.Assets = {"noober_shattered hopes.anim@MARKET/noobersdances/shattered hopes.anim", "noober_shattered hopes.mp3@MARKET/noobersdances/shattered hopes.mp3"}
    
        m.Config = function(parent)
            Util_CreateText(parent, "No settings.", 14, Enum.TextXAlignment.Center)
        end
    
        m.SaveConfig = function() return {} end
        m.LoadConfig  = function(save) end
    
        local animator = nil
        local start    = 0
    
        m.Init = function(figure)
            SetOverrideDanceMusic(AssetGetContentId("shattered hopes.mp3"), "Shattered hopes", 0.8, NumberRange.new(0, 45.5))
    
            start           = os.clock()
            animator        = AnimLib.Animator.new()
            animator.rig    = figure
            animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("shattered hopes.anim"))
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
        m.Name        = "Shout"
        m.Description = "I hope a bridge doesnt fall while Im on a bus"
        m.Assets = {"noober_Shout.anim@MARKET/noobersdances/Shout.anim", "noober_Shout.mp3@MARKET/noobersdances/Shout.mp3"}
    
        m.Config = function(parent)
            Util_CreateText(parent, "No settings.", 14, Enum.TextXAlignment.Center)
        end
    
        m.SaveConfig = function() return {} end
        m.LoadConfig  = function(save) end
    
        local animator = nil
        local start    = 0
    
        m.Init = function(figure)
            SetOverrideDanceMusic(AssetGetContentId("Shout.mp3"), "Shout", 0.8, NumberRange.new(0, 45.5))
    
            start           = os.clock()
            animator        = AnimLib.Animator.new()
            animator.rig    = figure
            animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("Shout.anim"))
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
        m.Name        = "shucks"
        m.Description = "aw shucks"
        m.Assets = {"noober_shucks.anim@MARKET/noobersdances/shucks.anim", "noober_shucks.mp3@MARKET/noobersdances/shucks.mp3"}
    
        m.Config = function(parent)
            Util_CreateText(parent, "No settings.", 14, Enum.TextXAlignment.Center)
        end
    
        m.SaveConfig = function() return {} end
        m.LoadConfig  = function(save) end
    
        local animator = nil
        local start    = 0
    
        m.Init = function(figure)
            SetOverrideDanceMusic(AssetGetContentId("shucks.mp3"), "shucks", 0.8, NumberRange.new(0, 45.5))
    
            start           = os.clock()
            animator        = AnimLib.Animator.new()
            animator.rig    = figure
            animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("shucks.anim"))
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
        m.Name        = "snowy"
        m.Description = "snowy of snowTown"
        m.Assets = {"noober_snowy.anim@MARKET/noobersdances/snowy.anim", "noober_snowy.mp3@MARKET/noobersdances/snowy.mp3"}
    
        m.Config = function(parent)
            Util_CreateText(parent, "No settings.", 14, Enum.TextXAlignment.Center)
        end
    
        m.SaveConfig = function() return {} end
        m.LoadConfig  = function(save) end
    
        local animator = nil
        local start    = 0
    
        m.Init = function(figure)
            SetOverrideDanceMusic(AssetGetContentId("snowy.mp3"), "snowy", 0.8, NumberRange.new(0, 45.5))
    
            start           = os.clock()
            animator        = AnimLib.Animator.new()
            animator.rig    = figure
            animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("snowy.anim"))
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
        m.Name        = "Speed covering mouth"
        m.Description = "neck hurts neck hurts neck hurts"
        m.Assets = {"noober_speed covering.anim@MARKET/noobersdances/speed covering.anim", "noober_speed covering.mp3@MARKET/noobersdances/speed covering.mp3"}
    
        m.Config = function(parent)
            Util_CreateText(parent, "No settings.", 14, Enum.TextXAlignment.Center)
        end
    
        m.SaveConfig = function() return {} end
        m.LoadConfig  = function(save) end
    
        local animator = nil
        local start    = 0
    
        m.Init = function(figure)
            SetOverrideDanceMusic(AssetGetContentId("speed covering.mp3"), "Speed covering mouth", 0.8, NumberRange.new(0, 45.5))
    
            start           = os.clock()
            animator        = AnimLib.Animator.new()
            animator.rig    = figure
            animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("speed covering.anim"))
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
        m.Name        = "speed driving"
        m.Description = "is not THAT serious bro"
        m.Assets = {"noober_speed driving.anim@MARKET/noobersdances/speed driving.anim", "noober_speed driving.mp3@MARKET/noobersdances/speed driving.mp3"}
    
        m.Config = function(parent)
            Util_CreateText(parent, "No settings.", 14, Enum.TextXAlignment.Center)
        end
    
        m.SaveConfig = function() return {} end
        m.LoadConfig  = function(save) end
    
        local animator = nil
        local start    = 0
    
        m.Init = function(figure)
            SetOverrideDanceMusic(AssetGetContentId("speed driving.mp3"), "speed driving", 0.8, NumberRange.new(0, 45.5))
    
            start           = os.clock()
            animator        = AnimLib.Animator.new()
            animator.rig    = figure
            animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("speed driving.anim"))
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
        m.Name        = "stereo hearts"
        m.Description = "peak ball music"
        m.Assets = {"noober_stereo hearts.anim@MARKET/noobersdances/stereo hearts.anim", "noober_stereo hearts.mp3@MARKET/noobersdances/stereo hearts.mp3"}
    
        m.Config = function(parent)
            Util_CreateText(parent, "No settings.", 14, Enum.TextXAlignment.Center)
        end
    
        m.SaveConfig = function() return {} end
        m.LoadConfig  = function(save) end
    
        local animator = nil
        local start    = 0
    
        m.Init = function(figure)
            SetOverrideDanceMusic(AssetGetContentId("stereo hearts.mp3"), "stereo hearts", 0.8, NumberRange.new(0, 45.5))
    
            start           = os.clock()
            animator        = AnimLib.Animator.new()
            animator.rig    = figure
            animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("stereo hearts.anim"))
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
        m.Name        = "Sturdy"
        m.Description = "WE GETTING STURDY WITH THIS ONE🔥🔥🔥"
        m.Assets = {"noober_sturdy.anim@MARKET/noobersdances/sturdy.anim", "noober_sturdy.mp3@MARKET/noobersdances/sturdy.mp3"}
    
        m.Config = function(parent)
            Util_CreateText(parent, "No settings.", 14, Enum.TextXAlignment.Center)
        end
    
        m.SaveConfig = function() return {} end
        m.LoadConfig  = function(save) end
    
        local animator = nil
        local start    = 0
    
        m.Init = function(figure)
            SetOverrideDanceMusic(AssetGetContentId("sturdy.mp3"), "Sturdy", 0.8, NumberRange.new(0, 45.5))
    
            start           = os.clock()
            animator        = AnimLib.Animator.new()
            animator.rig    = figure
            animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("sturdy.anim"))
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
        m.Name        = "subterFuge"
        m.Description = "if someone khows wheres is this from pls dm me"
        m.Assets = {"noober_SubterFuge.anim@MARKET/noobersdances/SubterFuge.anim", "noober_SubterFuge.mp3@MARKET/noobersdances/SubterFuge.mp3"}
    
        m.Config = function(parent)
            Util_CreateText(parent, "No settings.", 14, Enum.TextXAlignment.Center)
        end
    
        m.SaveConfig = function() return {} end
        m.LoadConfig  = function(save) end
    
        local animator = nil
        local start    = 0
    
        m.Init = function(figure)
            SetOverrideDanceMusic(AssetGetContentId("SubterFuge.mp3"), "subterFuge", 0.8, NumberRange.new(0, 45.5))
    
            start           = os.clock()
            animator        = AnimLib.Animator.new()
            animator.rig    = figure
            animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("SubterFuge.anim"))
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
        m.Name        = "Survivalist"
        m.Description = "hop on Minecraft bro"
        m.Assets = {"noober_Survivalist.anim@MARKET/noobersdances/Survivalist.anim", "noober_Survivalist.mp3@MARKET/noobersdances/Survivalist.mp3"}
    
        m.Config = function(parent)
            Util_CreateText(parent, "No settings.", 14, Enum.TextXAlignment.Center)
        end
    
        m.SaveConfig = function() return {} end
        m.LoadConfig  = function(save) end
    
        local animator = nil
        local start    = 0
    
        m.Init = function(figure)
            SetOverrideDanceMusic(AssetGetContentId("Survivalist.mp3"), "Survivalist", 0.8, NumberRange.new(0, 45.5))
    
            start           = os.clock()
            animator        = AnimLib.Animator.new()
            animator.rig    = figure
            animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("Survivalist.anim"))
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
        m.Name        = "teto territory"
        m.Description = "tetotetotetotetotetotheooooooooooooo"
        m.Assets = {"noober_teto territory.anim@MARKET/noobersdances/teto territory.anim", "noober_teto territory.mp3@MARKET/noobersdances/teto territory.mp3"}
    
        m.Config = function(parent)
            Util_CreateText(parent, "No settings.", 14, Enum.TextXAlignment.Center)
        end
    
        m.SaveConfig = function() return {} end
        m.LoadConfig  = function(save) end
    
        local animator = nil
        local start    = 0
    
        m.Init = function(figure)
            SetOverrideDanceMusic(AssetGetContentId("teto territory.mp3"), "teto territory", 0.8, NumberRange.new(0, 45.5))
    
            start           = os.clock()
            animator        = AnimLib.Animator.new()
            animator.rig    = figure
            animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("teto territory.anim"))
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
        m.Name        = "the hero"
        m.Description = "is that you Richard?"
        m.Assets = {"noober_the hero.anim@MARKET/noobersdances/the hero.anim", "noober_the hero.mp3@MARKET/noobersdances/the hero.mp3"}
    
        m.Config = function(parent)
            Util_CreateText(parent, "No settings.", 14, Enum.TextXAlignment.Center)
        end
    
        m.SaveConfig = function() return {} end
        m.LoadConfig  = function(save) end
    
        local animator = nil
        local start    = 0
    
        m.Init = function(figure)
            SetOverrideDanceMusic(AssetGetContentId("the hero.mp3"), "the hero", 0.8, NumberRange.new(0, 45.5))
    
            start           = os.clock()
            animator        = AnimLib.Animator.new()
            animator.rig    = figure
            animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("the hero.anim"))
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
        m.Name        = "these cuffs"
        m.Description = "AAAAAAAAAAAAA"
        m.Assets = {"noober_these cuffs.anim@MARKET/noobersdances/these cuffs.anim", "noober_these cuffs.mp3@MARKET/noobersdances/these cuffs.mp3"}
    
        m.Config = function(parent)
            Util_CreateText(parent, "No settings.", 14, Enum.TextXAlignment.Center)
        end
    
        m.SaveConfig = function() return {} end
        m.LoadConfig  = function(save) end
    
        local animator = nil
        local start    = 0
    
        m.Init = function(figure)
            SetOverrideDanceMusic(AssetGetContentId("these cuffs.mp3"), "these cuffs", 0.8, NumberRange.new(0, 45.5))
    
            start           = os.clock()
            animator        = AnimLib.Animator.new()
            animator.rig    = figure
            animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("these cuffs.anim"))
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
        m.Name        = "tick tock"
        m.Description = "WTF IS STEVE PYTHON FILE DOING TO THIS DANCE"
        m.Assets = {"noober_tick tock.anim@MARKET/noobersdances/tick tock.anim", "noober_tick tock.mp3@MARKET/noobersdances/tick tock.mp3"}
    
        m.Config = function(parent)
            Util_CreateText(parent, "No settings.", 14, Enum.TextXAlignment.Center)
        end
    
        m.SaveConfig = function() return {} end
        m.LoadConfig  = function(save) end
    
        local animator = nil
        local start    = 0
    
        m.Init = function(figure)
            SetOverrideDanceMusic(AssetGetContentId("tick tock.mp3"), "tick tock", 0.8, NumberRange.new(0, 45.5))
    
            start           = os.clock()
            animator        = AnimLib.Animator.new()
            animator.rig    = figure
            animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("tick tock.anim"))
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
        m.Name        = "topbot"
        m.Description = "ohhh yeah im a dancing robot"
        m.Assets = {"noober_topbot.anim@MARKET/noobersdances/topbot.anim", "noober_topbot.mp3@MARKET/noobersdances/topbot.mp3"}
    
        m.Config = function(parent)
            Util_CreateText(parent, "No settings.", 14, Enum.TextXAlignment.Center)
        end
    
        m.SaveConfig = function() return {} end
        m.LoadConfig  = function(save) end
    
        local animator = nil
        local start    = 0
    
        m.Init = function(figure)
            SetOverrideDanceMusic(AssetGetContentId("topbot.mp3"), "topbot", 0.8, NumberRange.new(0, 45.5))
    
            start           = os.clock()
            animator        = AnimLib.Animator.new()
            animator.rig    = figure
            animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("topbot.anim"))
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
        m.Name        = "Umamusume"
        m.Description = "wtf is that name dang"
        m.Assets = {"noober_umamusume.anim@MARKET/noobersdances/umamusume.anim", "noober_umamusume.mp3@MARKET/noobersdances/umamusume.mp3"}
    
        m.Config = function(parent)
            Util_CreateText(parent, "No settings.", 14, Enum.TextXAlignment.Center)
        end
    
        m.SaveConfig = function() return {} end
        m.LoadConfig  = function(save) end
    
        local animator = nil
        local start    = 0
    
        m.Init = function(figure)
            SetOverrideDanceMusic(AssetGetContentId("umamusume.mp3"), "Umamusume", 0.8, NumberRange.new(0, 45.5))
    
            start           = os.clock()
            animator        = AnimLib.Animator.new()
            animator.rig    = figure
            animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("umamusume.anim"))
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
        m.Name        = "work to the beat"
        m.Description = "I dont follow mr beats srry"
        m.Assets = {"noober_work to the beat.anim@MARKET/noobersdances/work to the beat.anim", "noober_work to the beat.mp3@MARKET/noobersdances/work to the beat.mp3"}
    
        m.Config = function(parent)
            Util_CreateText(parent, "No settings.", 14, Enum.TextXAlignment.Center)
        end
    
        m.SaveConfig = function() return {} end
        m.LoadConfig  = function(save) end
    
        local animator = nil
        local start    = 0
    
        m.Init = function(figure)
            SetOverrideDanceMusic(AssetGetContentId("work to the beat.mp3"), "work to the beat", 0.8, NumberRange.new(0, 45.5))
    
            start           = os.clock()
            animator        = AnimLib.Animator.new()
            animator.rig    = figure
            animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("work to the beat.anim"))
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