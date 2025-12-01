# Uhhhhhh documentation
Modules are just luau tables that are created by a function.
It does impose vulnerabilities, but who cares? Executors already
execute functions from user strings.

## Filesystem structure
Uhhhhhh's filesystem is like this
```txt
Executor's workspace/
| UhhhhhhReanim/
| | Assets/ - Contains UI Music
| | Modules/ - Should contain luau scripts that return a table of functions
| | Content/ - Contains module assets
| | | Anims/ - .anim (usually in STEVE's KeyframeSequence file format)
| | | Sounds/ - .mp3
| | | Images/ - .png
| | | Models/ - .rbxm
| | | Unknown/ - Ungrouped assets
| | tree.ehehetilde - All save data in JSON
| | .nomedia - Created for android users
```

## Modules
Modules are returned by a function from a luau script.
honestly idk how to document this in an understandable way so
heres an example, with code comments:
```lua
-- UhhhhhhReanim/Modules/lazy.lua

local modules = {} -- table to contain all modules

-- function called to create the module
-- this allows for local variables
table.insert(modules, function() -- put into modules table
	local m = {} -- module object
	
	-- can be "MOVESET" or "DANCE"
	m.ModuleType = "DANCE"
	
	-- name of module
	m.Name = "Lazy"
	
	-- description of module
	m.Description = "too lazy to even animate"
	
	-- internal name, used for movesets and dances to interact with each other
	-- best usage example of this is Immortality Lord + ragdoll
	-- this can be omitted
	m.InternalName = "DANCE_LAZY"
	
	-- table of assets to download, either in "filename" or "filename@url_to_source"
	m.Assets = {"Lazy.mp3@https://raw.githubusercontent.com/user/repo/main/69.mp3"}
	
	-- functions below should NOT yield
	
	-- configuration GUI function, recommended to use these:
	-- Util_CreateText(parent, text, fontsize, alignment)
	-- Util_CreateButton(parent, text, fontsize)
	-- Util_CreateSwitch(parent, text, is_on)
	-- Util_CreateTextbox(parent, text, placeholdertext, fontsize)
	-- Util_CreateSlider(parent, text, value, min, max, step)
	-- Util_CreateDropdown(parent, text, items, itemindex)
	-- Util_CreateCanvas(parent)
	-- Util_CreateScrollCanvas(parent, height)
	-- Util_CreateSeparator(parent)
	m.Config = function(parent: GuiBase2d)
		Util_CreateText(parent, "hi", 67, Enum.TextXAlignment.Center)
	end
	
	-- function called to load from save table
	-- this function can be omitted
	m.LoadConfig = function(save: any)
	end
	
	-- function called to save from load table
	-- this function can be omitted
	m.SaveConfig = function()
		return {} -- AND KEEP YOUR TABLES SERIALIZABLE
	end
	
	-- called upon initialization
	m.Init = function(figure: Model)
		-- access upvalues, initialize animator
	end
	
	-- called upon update loop
	m.Update = function(dt: number, figure: Model)
		local t = tick()
		-- step the animator, emit particles
	end
	
	-- called upon destruction
	-- this is not called when figure is refreshed so reference ur created and modified instances
	m.Destroy = function(figure: Model?)
		-- destroy created instances, dereference animator
	end
	return m -- function returns the module
end)

return modules -- return modules
```

## STEVE's KeyframeSequence file format
It's all pretty simple, really.
The byteorder is in little endian.

string structure: `<2 bytes short n> <n bytes string>`

pose structure: `<string pose_name> <4 bytes float weight> <string pose_easing_style> <string pose_easing_direction> <4 bytes float cframe component, times 12>`

keyframe structure: `<4 bytes float time> <4 bytes int n> <pose poses, times n>`

main file structure: `<string animation_name> <4 bytes int n> <keyframe keyframes, times n>`

## Uhhhhhh's env
Uhhhhhh gives modules whatever it can. Here are all of it!
```lua
RandomString(length) -- Random String function

-- UI Util functions, used for config UI
-- refer to line ~58 for usage
Util_CreateText
Util_CreateButton
Util_CreateSwitch
Util_CreateTextbox
Util_CreateSlider
Util_CreateDropdown
Util_CreateCanvas
Util_CreateScrollCanvas
Util_CreateSeparator

-- Reanimators
LimbReanimator
	.Running -- is running
	.Mode -- rootpart offset mode
		-- 0 - RootPart in void
		-- 1 - Keep RootPart streamed
		-- 2 - CurrentAngle style
		-- 3 - RootPart is Torso
HatReanimator
	.Running -- is running
	.Permadeath -- has permadeath?
	.HatCollide -- hat collde enabled?
	.HatCFrameOverride -- array of hat overrides
ReanimateShowHitboxes() -- function to show hitboxes, laggy for many hats
ReanimateFling(target, duration) -- fling target
-- target can be model, part, Vector3 or CFrame
-- duration can be 0 for fling to last a frame

-- music overrides
SetOverrideMovesetMusic(assetid, musicname, volume, loopregion) -- play music, pass no arguments to stop
GetOverrideMovesetMusicTime() -- returns time
SetOverrideMovesetMusicTime(time) -- set time
SetOverrideMovesetMusicSpeed(speed) -- set speed
-- same for dance, dances are high priority
SetOverrideDanceMusic(assetid, musicname, volume, loopregion)
GetOverrideDanceMusicTime()
SetOverrideDanceMusicTime(time)
SetOverrideDanceMusicSpeed(speed)

AnimLib -- Uhhhhhh's animation library
	.Track -- track util
		.fromfile(path) -- loads animation from file, must be in STEVE's KeyframeSequence file format
		.frominstance(ks) -- loads animation from a KeyframeSequence
		.paste(target, source, timeoffset) -- pastes keyframes from source to target, with a time offset
		.getPoses(track, time, looped) -- used by Animator
	.Animator -- animator
		.new() -- creates an animator
			.rig -- the character model
			.track -- the animation track
			.map -- map input time to animation time
			.looped -- loop animation by track end time
			.speed -- input time multiplication
			.weight -- use to blend with other animators, or smoothen animation
			:Step(time) -- apply pose

-- utils for grabbing assets from Uhhhhhh/Assets/...
AssetGetPathFromFilename(filename) -- used for AnimLib.Track.fromfile
AssetGetContentId(filename) -- loads file with getcustomasset

-- chat
ProtectedChat(message) -- make player say something, errors are supressed
OnPlayerChatted.Event:Connect(function(player, message) end) -- event when a player chats

HiddenGui -- the reference to the ScreenGui Uhhhhhh uses
```

# Uhhhhhh's Licenses
My code is covered by the MIT license. I made most of it. BUT...

MOST OF THESE ANIMATIONS AND MUSIC ARE NOT MINE!!!

See THIRD_PARTY for credits, original licenses, and usage notes.