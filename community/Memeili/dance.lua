local modules = {}
table.insert(modules, function()
    local m = {}
    m.ModuleType  = "DANCE"
    m.Name        = "Miss Me (Hello Neighbor Mix)"
    m.Description = "Music Goes hard asf"
    m.Assets = {"MissMeFix.anim@https://github.com/STEVE-916-create/Uhhhhhh/raw/refs/heads/main/community/Memeili/MissMeFix.anim", "TungBung.mp3@https://github.com/STEVE-916-create/Uhhhhhh/raw/refs/heads/main/community/Memeili/TungBung.mp3"}
    m.Config = function(parent)
        Util_CreateText(parent, "No settings.", 14, Enum.TextXAlignment.Center)
    end
    m.SaveConfig = function() return {} end
    m.LoadConfig  = function(save) end
    local animator = nil
    local start    = 0
    m.Init = function(figure)
        SetOverrideDanceMusic(AssetGetContentId("TungBung.mp3"),"TungBung", 0.8, NumberRange.new(0, 45.5))
        start           = os.clock()
        animator        = AnimLib.Animator.new()
        animator.rig    = figure
        animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("MissMeFix.anim"))
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
    m.Name        = "Real one knows this isn't avgn😂✌"
    m.Description = "SON NO COPYING 😂😂😂"
    m.Assets = {"KwikFlip.animhttps://github.com/STEVE-916-create/Uhhhhhh/raw/refs/heads/main/community/Memeili/KwikFlip.anim", "Kwik Flip.mp3https://github.com/STEVE-916-create/Uhhhhhh/raw/refs/heads/main/community/Memeili/Kwik%20Flip.mp3"}
    m.Config = function(parent)
        Util_CreateText(parent, "No settings.", 14, Enum.TextXAlignment.Center)
    end
    m.SaveConfig = function() return {} end
    m.LoadConfig  = function(save) end
    local animator = nil
    local start    = 0
    m.Init = function(figure)
        SetOverrideDanceMusic(AssetGetContentId("Kwik Flip.mp3"),"Kwik Flip", 0.8, NumberRange.new(0, 45.5))
        start           = os.clock()
        animator        = AnimLib.Animator.new()
        animator.rig    = figure
        animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename("KwikFlip.anim"))
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
