# <p align="center">STEVETHEREALONE (@steve_internal)'s Universal Hierarchical 6 Reanimator</p>
<p align="center">A really cool, optimised animation program with demo scenes! Idea originated from a dream.</p>
<p align="center">
	<img src="./images/Showcase.gif" alt="drawing" width="45%"/>
	<img src="./images/Showcase2.gif" alt="drawing" width="45%"/>
</p>

This is the official repository for Uhhhhhh.
All code is stored in this repository.
Feel free to use these as your reference.

Join the [DISCORD](https://discord.gg/NASNUKRBVM) of all my programming shenanigans! :D

**NOTICE:** This is still in development, so things are subject to change and stuff are expected to be missing.

## Loadstring
Pick from one of these:

1. raw loadstring (cached by github)
```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/STEVE-916-create/Uhhhhhh/main/source/reanim.lua"))()
```

2. api loadstring (bypasses github cache)
```lua
local a,b,c,g="/STEVE-916-create/Uhhhhhh/","/source/reanim.lua",".github","https://"local d=request({Url=`{g}api{c}.com/repos{a}contents{b}`,Headers={Accept=`application/vnd{c}.VERSION.raw`}})if d.StatusCode~=200 then d.Body=game:HttpGet(`{g}raw{c}usercontent.com{a}main{b}`)end local e,f=loadstring(d.Body)if not e then warn(f)else e()end
```

## Features:
1. Probably the most stable hatdrop

   Uhhhhhh's hatdrop supports most (if not all) hat rigs!

   <img src="./images/ILDoesKemusan.gif" alt="drawing" width="350"/>

   <img src="./images/WaistRigSupport.gif" alt="drawing" width="350"/>

2. Limb reanimation support

   In the case where you are just unable to afford hats, you can use your own limbs instead!

   Unfortunately, this only supports a few games.

   <img src="./images/LimbReanimation.gif" alt="drawing" width="350"/>

3. Good looking UI

   definitely better than genesis

   <img src="./images/UserInterface.gif" alt="drawing" width="350"/>

4. Moveset and Dance system

   Have old animations, or become Lightning Cannon. Dance anytime!

   <img src="./images/IllMakeYouSay.gif" alt="drawing" width="350"/>

5. Takes advantage of random replicate properties

   Serversided Physics glue = very accurate (and fast) fling!

   <img src="./images/FastestFling.gif" alt="drawing" width="350"/>

6. Modding support

   Infinite Yield lets you make plugins. So why not add it to Uhhhhhh too?

   <img src="./images/GiantSkipping.gif" alt="drawing" width="350"/>

   The documentation is right below all of whatever these are.

7. Themes

   You hate the colors? Change them! Do you want black? Do you want white? Do you want your own? The choice is yours.

   <img src="./images/Theme1.jpg" alt="drawing" width="40%"/>
   <img src="./images/Theme2.jpg" alt="drawing" width="40%"/>
   <img src="./images/Theme3.jpg" alt="drawing" width="40%"/>
   <img src="./images/Theme4.jpg" alt="drawing" width="40%"/>

```lua
-- example theme
_G.UhhhhhhTheme = {
	Fore = Color3.new(0, 1, 0), -- nil = rainbow
	Back = Color3.new(0, 0, 0), -- nil = pure black
	Text = Color3.new(0, 1, 0),
}
-- the Color3s can also be a hex code string e.g.: "DDBB69"
```

# SHOWCASES
-- :3 user images brought to you by Awes955
<p align="center">
	<img src="./images/3321822271_7041939546_1768574213001.png" alt="drawing" width="45%"/>
	<img src="./images/4181218726_6441847031_1768744206674.png" alt="drawing" width="45%"/>
</p>
<p align="center">
	<img src="./images/4181218726_6441847031_1768755394038.png" alt="drawing" width="45%"/>
	<img src="./images/4181218726_6441847031_1768825207608.png" alt="drawing" width="45%"/>
</p>
<p align="center">
	<img src="./images/4181218726_6441847031_1768829759425.png" alt="drawing" width="45%"/>
	<img src="./images/IMG_0823.png" alt="drawing" width="45%"/>
</p>
<p align="center">
	<img src="./images/IMG_0843.png" alt="drawing" width="45%"/>
	<img src="./images/IMG_0847.jpg" alt="drawing" width="45%"/>
</p>
<p align="center">
	<img src="./images/IMG_20260118_172134_004.png" alt="drawing" width="45%"/>
	<img src="./images/Screenshot_20260117_205517_Roblox.jpg" alt="drawing" width="45%"/>
</p>
<p align="center">
	<img src="./images/IMG_20260119_163546_348.png" alt="drawing" width="45%"/>
	<img src="./images/IMG_4334.png" alt="drawing" width="45%"/>
</p>
<p align="center">
	<img src="./images/IMG_4335.png" alt="drawing" width="45%"/>
	<img src="./images/IMG_4336.jpg" alt="drawing" width="45%"/>
</p>
<p align="center">
	<img src="./images/Screenshot_20260118-165059.png" alt="drawing" width="45%"/>
	<img src="./images/Screenshot_20260118-192115.png" alt="drawing" width="45%"/>
</p>
<p align="center">
	<img src="./images/Screenshot_20260118-222617.png" alt="drawing" width="45%"/>
	<img src="./images/Screenshot_20260118-222711.png" alt="drawing" width="45%"/>
</p>
<p align="center">
	<img src="./images/4181218726_83560691049285_1769158731388.png" alt="drawing" width="45%"/>
	<img src="./images/Screenshot_20260122-031656.jpg" alt="drawing" width="45%"/>
</p>
<p align="center">
	<img src="./images/Screenshot_20260122-031857.jpg" alt="drawing" width="45%"/>
	<img src="./images/Screenshot_20260123-223246.jpg" alt="drawing" width="45%"/>
</p>
<p align="center">
	<img src="./images/Screenshot_20260124-174236.png" alt="drawing" width="45%"/>
	<img src="./images/image.png" alt="drawing" width="45%"/>
</p>
<p align="center">
	<img src="./images/image.webp" alt="drawing" width="45%"/>
	<img src="./images/Screenshot_20260124-141230.png" alt="drawing" width="45%"/>
</p>

- Thats all for now, ill add any images that looks good :D
  
## Contributing

"Can I help? Can I/you add support for my hat?""

If you want to help by changing code, fixing bugs, doing further optimisations, my pull requests are open.

As for me adding support for your hats (since the hat database is very small), create an issue and ill prolly read it.

# Uhhhhhh's probably the most important quotes
**DISCLAIMER**: Some random quotes made here are *simple jokes* (e.g.: "this script mogs genesis") and should **not** be taken seriously. This also includes *all* the self-glazing quotes. **It's your choice to agree with them or not**, and if you do or don't, **don't come harass/mock any individuals from it.** In the end, a *joke quote* is a *joke quote*.

# Uhhhhhh documentation

## Filesystem structure
Uhhhhhh's filesystem is like this
```txt
Executor's workspace/
| UhhhhhhReanim/
| | Assets/ - Contains UI Music
| | Modules/ - YOUR modules
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
Modules are just luau tables that are created by a function.
It does impose vulnerabilities, but who cares? Executors already
execute functions from user strings.

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

This just explains how this format works. If you don't like it, check the `tools` folder in this repo!

## Uhhhhhh's env
Uhhhhhh gives modules whatever it can. Here are all of it!
```lua
RandomString(length) -- Random String function

-- UI Util functions, used for config UI
-- refer to module example code block for usage
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
	.SetRootPartMode(mode) -- set rootpart mode
		-- 0 - RootPart in void
		-- 1 - Keep RootPart streamed
		-- 2 - CurrentAngle style
		-- 3 - RootPart is Torso
HatReanimator
	.Running -- is running
	.HasPermadeath -- has permadeath?
	.HasHatCollide -- hat collde enabled?
	.HatCFrameOverride -- array of hat overrides
		-- see IL moveset for use case
	.GetHatMap() -- get current hat map (changes wont apply)
		-- returns table of hat map items
		{
			Name = "hat name",
			MeshId = "mesh id", TextureId = "texture id",
			C0 = "C0 virtual weld",
			C1 = "C1 virtual weld",
			Scale = "the hat's scale set from Roblox accessory refiner",
			Limb = "the limb it is attached to",
			Group = "the name of the hat group, see IL moveset for use case"
		}
	.GetHatCFrameMeshAndTexture(mesh, tex) -- pass in mesh id and texture id to get hat cframe
	.GetAttachmentCFrame(name) -- attachment by name
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

-- utils for grabbing assets from Uhhhhhh/Content/...
AssetGetPathFromFilename(filename) -- used for AnimLib.Track.fromfile
AssetGetContentId(filename) -- loads file with getcustomasset

-- chat
ProtectedChat(message) -- make player say something, errors are supressed
OnPlayerChatted.Event:Connect(function(player, message) end) -- event when a player chats

HiddenGui -- the reference to the ScreenGui Uhhhhhh uses
FallenPartsDestroyHeight -- self explanatory
```

## "i dont understand all this"
That's why I have made (in v1.0.3) the stuff that gives Empyrean Reanimate (emper chill lowkirkenuinly) the ability to be used in require script convertions!
`_G.Uhhhhhh` which contains `.Character` and `.Fling`, but using this might make you rejoin just to stop everything...

So I also made `goodies/convertion.lua`! For all those smarty-pants out there, you may now make your own "moveset" with a couple of changes to the actual source!
Link your connection disconnections, thread stoppers and instance deconstructions to a singular `OnStopEvent` `BindableEvent`, NOW!
(not doing so will cause havoc in your threads ;P)

# Uhhhhhh's Licenses
My code is covered by the MIT license. I made most of it. BUT...

MOST OF THESE ANIMATIONS AND MUSIC ARE NOT MINE!!!

See THIRD_PARTY for credits, original licenses, and usage notes.
