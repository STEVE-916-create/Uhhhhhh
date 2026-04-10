local modules = {}

table.insert(modules, function()
    local m = {}

    m.ModuleType  = "DANCE"
    m.Name        = "CSGO Bhop"
    m.Description = "that one try hard movement in counter strike or left 4 dead"
    m.Assets = {"Bhop.anim@MARKET/nbhoptest/Bhop.anim", "Bhop.mp3@MARKET/nbhoptest/Bhop.mp3"}

    m.Config = function(parent)
        -- u dont need anything in config if u have no configs
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

return modules