local modules = {}

local dances = {
    {
        name = "Dance Alone",
        desc = "song by Hasimero, TheVanishedPeople / dance by CarlosisRBLX",
        anim = "dancealone.anim",
        animUrl = "https://github.com/testing734/UhhhhhhExtraDances/raw/refs/heads/main/dance%20alone.anim",
        song = "dancealone.mp3",
        songUrl = "https://github.com/testing734/UhhhhhhExtraDances/raw/refs/heads/main/Hasimero_TheVanishedPeople.mp3",
    },
    {
        name = "Hai Yorokonde",
        desc = "song by kocchi no kento, animated by CarlosisRBLX",
        anim = "hai.anim",
        animUrl = "https://github.com/testing734/UhhhhhhExtraDances/raw/refs/heads/main/Hai%20Yorokonde.anim",
        song = "hai.mp3",
        songUrl = "https://github.com/testing734/UhhhhhhExtraDances/raw/refs/heads/main/%E3%81%AF%E3%81%84%E3%82%88%E3%82%8D%E3%81%93%E3%82%93%E3%81%A7%20_%20%E3%81%93%E3%81%A3%E3%81%A1%E3%81%AE%E3%81%91%E3%82%93%E3%81%A8%20MV.mp3",
    },
}

for i = 1, #dances do
    local d = dances[i]
    table.insert(modules, function()
        local m = {}
        local animator = nil
        local start = 0

        m.ModuleType  = "DANCE"
        m.Name        = d.name
        m.Description = d.desc
        m.Assets      = {
            d.anim .. "@" .. d.animUrl,
            d.song .. "@" .. d.songUrl
        }

        m.Config = function(parent)
            if Util_CreateText then
                Util_CreateText(parent, "No settings.", 14, Enum.TextXAlignment.Center)
            end
        end

        m.SaveConfig = function() return {} end
        m.LoadConfig = function(save) end

        m.Init = function(figure)
            SetOverrideDanceMusic(AssetGetContentId(d.song))
            
            start           = os.clock()
            animator        = AnimLib.Animator.new()
            animator.rig    = figure
            animator.track  = AnimLib.Track.fromfile(AssetGetPathFromFilename(d.anim))
            animator.looped = true
            animator.speed  = 1
        end
        m.Update = function(dt: number, figure: Model)
            if animator then
                animator:Step(GetOverrideDanceMusicTime())
            end
        end

        m.Destroy = function(figure)
            animator = nil
        end

        return m
    end)
end

return modules
