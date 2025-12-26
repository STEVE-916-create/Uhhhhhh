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

-- utils
local function ResetC0C1Joints(rj, nj, rsj, lsj, rhj, lhj)
	rj.C0 = CFrame.new(0, 0, 0, -1, 0, 0, 0, 0, 1, 0, 1, 0)
	rj.C1 = CFrame.new(0, 0, 0, -1, 0, 0, 0, 0, 1, 0, 1, 0)
	nj.C0 = CFrame.new(0, 1, 0, -1, 0, 0, 0, 0, 1, 0, 1, 0)
	nj.C1 = CFrame.new(0, -0.5, 0, -1, 0, 0, 0, 0, 1, 0, 1, 0)
	rsj.C0 = CFrame.new(-1, 0.5, 0, 0, 0, -1, 0, 1, 0, 1, 0, 0)
	rsj.C1 = CFrame.new(0.5, 0.5, 0, 0, 0, -1, 0, 1, 0, 1, 0, 0)
	lsj.C0 = CFrame.new(1, 0.5, 0, 0, 0, 1, 0, 1, 0, -1, 0, 0)
	lsj.C1 = CFrame.new(-0.5, 0.5, 0, 0, 0, 1, 0, 1, 0, -1, 0, 0)
	rhj.C0 = CFrame.new(-1, 1, 0, 0, 0, -1, 0, 1, 0, 1, 0, 0)
	rhj.C1 = CFrame.new(-0.5, 1, 0, 0, 0, -1, 0, 1, 0, 1, 0, 0)
	lhj.C0 = CFrame.new(1, 1, 0, 0, 0, 1, 0, 1, 0, -1, 0, 0)
	lhj.C1 = CFrame.new(0.5, 1, 0, 0, 0, 1, 0, 1, 0, -1, 0, 0)
end
local function SetC0C1Joint(j, c0, c1, scale)
	local t = j.C0:Inverse() * c0 * c1:Inverse() * j.C1
	j.Transform = t + t.Position * (scale - 1)
end

local modules = {}
local function AddModule(m)
	table.insert(modules, m)
end

AddModule(function()
	local m = {}
	m.ModuleType = "MOVESET"
	m.Name = "Super Mario 64"
	m.InternalName = "SM64.Z64"
	m.Description = "itsumi mario! press start to play!\nmost of the code were copied from maximum_adhd's sm64-roblox\n\nhere are some wierd ways to defeat enemies in super mario 64\nwe can make chain chomp fall out of bounds\nwe can throw king bob-omb out of bounds\nwe can knock the chill bully off this platform and move him around, though he ends up dying elsewhere\nwe can get eye-rock to fall off the edge and then he doesnt come back up\nwe can get bowser to fall off the edge and then he doesnt come back up\nwe can drop mips into other levels\nwe can drop the 2 ukikis off the edge\nwe can drop the baby penguin off the edge\nwe can make the mama penguin fall off the edge\nwe can make the racing penguin fall off the edge\nwe can make koopa the quick fall off the edge\nwe can send koopa the quick to a parallel universe\nwe can get a bully stuck underground\nwe can get a bully stuck in a corner\nwe can make klepto lunge at us and then stuck in a pillar\nwe can throw a bob-omb buddy out of bounds\nwe can push a heave ho out of bounds using a block\nwe can make bubba fall off the edge\nand we can make yoshi fall off the castle roof"
	m.Assets = {}

	m.FPS30 = false
	m.ModeCap = 2
	m.Config = function(parent: GuiBase2d)
		Util_CreateDropdown(parent, "Cap", {
			"Capless Mario"
			"Mario",
			"Wing Cap Mario",
			"Metal Mario",
			"Vanish Cap Mario",
		}, m.ModeCap).Changed:Connect(function(val)
			m.ModeCap = val
		end)
	end
	m.LoadConfig = function(save: any)
		m.FPS30 = not not save.FPS30
		m.ModeCap = save.ModeCap or m.ModeCap
	end
	m.SaveConfig = function()
		return {
			FPS30 = m.FPS30,
			ModeCap = m.ModeCap,
		}
	end

	local VECTOR3_XZ = Vector3.new(1, 0, 1)
	local XZ_DIRS = {
		Vector3.new(-1, 0, 0),
		Vector3.new(0, 0, -1),
		Vector3.new(1, 0, 0),
		Vector3.new(0, 0, 1),
	}
	local maryo = {}
	maryo.Enums = {}
	maryo.Enums.ActionGroups = {
		-- Group Flags
		STATIONARY = bit32.lshift(0, 6),
		MOVING = bit32.lshift(1, 6),
		AIRBORNE = bit32.lshift(2, 6),
		SUBMERGED = bit32.lshift(3, 6),
		CUTSCENE = bit32.lshift(4, 6),
		AUTOMATIC = bit32.lshift(5, 6),
		OBJECT = bit32.lshift(6, 6),

		-- Mask for capturing these Flags
		GROUP_MASK = 0b_000000111000000,
	}
	maryo.Enums.ActionFlags = {
		STATIONARY = bit32.lshift(1, 9),
		MOVING = bit32.lshift(1, 10),
		AIR = bit32.lshift(1, 11),
		INTANGIBLE = bit32.lshift(1, 12),
		SWIMMING = bit32.lshift(1, 13),
		METAL_WATER = bit32.lshift(1, 14),
		SHORT_HITBOX = bit32.lshift(1, 15),
		RIDING_SHELL = bit32.lshift(1, 16),
		INVULNERABLE = bit32.lshift(1, 17),
		BUTT_OR_STOMACH_SLIDE = bit32.lshift(1, 18),
		DIVING = bit32.lshift(1, 19),
		ON_POLE = bit32.lshift(1, 20),
		HANGING = bit32.lshift(1, 21),
		IDLE = bit32.lshift(1, 22),
		ATTACKING = bit32.lshift(1, 23),
		ALLOW_VERTICAL_WIND_ACTION = bit32.lshift(1, 24),
		CONTROL_JUMP_HEIGHT = bit32.lshift(1, 25),
		ALLOW_FIRST_PERSON = bit32.lshift(1, 26),
		PAUSE_EXIT = bit32.lshift(1, 27),
		SWIMMING_OR_FLYING = bit32.lshift(1, 28),
		WATER_OR_TEXT = bit32.lshift(1, 29),
		THROWING = bit32.lshift(1, 31),
	}
	maryo.Enums.Action = {
		-- group 0x000: stationary actions
		IDLE = 0x0C400201, -- (0x001 | FLAG_STATIONARY | FLAG_IDLE | FLAG_ALLOW_FIRST_PERSON | FLAG_PAUSE_EXIT)
		START_SLEEPING = 0x0C400202, -- (0x002 | FLAG_STATIONARY | FLAG_IDLE | FLAG_ALLOW_FIRST_PERSON | FLAG_PAUSE_EXIT)
		SLEEPING = 0x0C000203, -- (0x003 | FLAG_STATIONARY | FLAG_ALLOW_FIRST_PERSON | FLAG_PAUSE_EXIT)
		WAKING_UP = 0x0C000204, -- (0x004 | FLAG_STATIONARY | FLAG_ALLOW_FIRST_PERSON | FLAG_PAUSE_EXIT)
		PANTING = 0x0C400205, -- (0x005 | FLAG_STATIONARY | FLAG_IDLE | FLAG_ALLOW_FIRST_PERSON | FLAG_PAUSE_EXIT)
		HOLD_PANTING_UNUSED = 0x08000206, -- (0x006 | FLAG_STATIONARY | FLAG_PAUSE_EXIT)
		HOLD_IDLE = 0x08000207, -- (0x007 | FLAG_STATIONARY | FLAG_PAUSE_EXIT)
		HOLD_HEAVY_IDLE = 0x08000208, -- (0x008 | FLAG_STATIONARY | FLAG_PAUSE_EXIT)
		STANDING_AGAINST_WALL = 0x0C400209, -- (0x009 | FLAG_STATIONARY | FLAG_IDLE | FLAG_ALLOW_FIRST_PERSON | FLAG_PAUSE_EXIT)
		COUGHING = 0x0C40020A, -- (0x00A | FLAG_STATIONARY | FLAG_IDLE | FLAG_ALLOW_FIRST_PERSON | FLAG_PAUSE_EXIT)
		SHIVERING = 0x0C40020B, -- (0x00B | FLAG_STATIONARY | FLAG_IDLE | FLAG_ALLOW_FIRST_PERSON | FLAG_PAUSE_EXIT)
		IN_QUICKSAND = 0x0002020D, -- (0x00D | FLAG_STATIONARY | FLAG_INVULNERABLE)
		UNKNOWN_0002020E = 0x0002020E, -- (0x00E | FLAG_STATIONARY | FLAG_INVULNERABLE)
		CROUCHING = 0x0C008220, -- (0x020 | FLAG_STATIONARY | FLAG_SHORT_HITBOX | FLAG_ALLOW_FIRST_PERSON | FLAG_PAUSE_EXIT)
		START_CROUCHING = 0x0C008221, -- (0x021 | FLAG_STATIONARY | FLAG_SHORT_HITBOX | FLAG_ALLOW_FIRST_PERSON | FLAG_PAUSE_EXIT)
		STOP_CROUCHING = 0x0C008222, -- (0x022 | FLAG_STATIONARY | FLAG_SHORT_HITBOX | FLAG_ALLOW_FIRST_PERSON | FLAG_PAUSE_EXIT)
		START_CRAWLING = 0x0C008223, -- (0x023 | FLAG_STATIONARY | FLAG_SHORT_HITBOX | FLAG_ALLOW_FIRST_PERSON | FLAG_PAUSE_EXIT)
		STOP_CRAWLING = 0x0C008224, -- (0x024 | FLAG_STATIONARY | FLAG_SHORT_HITBOX | FLAG_ALLOW_FIRST_PERSON | FLAG_PAUSE_EXIT)
		SLIDE_KICK_SLIDE_STOP = 0x08000225, -- (0x025 | FLAG_STATIONARY | FLAG_PAUSE_EXIT)
		SHOCKWAVE_BOUNCE = 0x00020226, -- (0x026 | FLAG_STATIONARY | FLAG_INVULNERABLE)
		FIRST_PERSON = 0x0C000227, -- (0x027 | FLAG_STATIONARY | FLAG_ALLOW_FIRST_PERSON | FLAG_PAUSE_EXIT)
		BACKFLIP_LAND_STOP = 0x0800022F, -- (0x02F | FLAG_STATIONARY | FLAG_PAUSE_EXIT)
		JUMP_LAND_STOP = 0x0C000230, -- (0x030 | FLAG_STATIONARY | FLAG_ALLOW_FIRST_PERSON | FLAG_PAUSE_EXIT)
		DOUBLE_JUMP_LAND_STOP = 0x0C000231, -- (0x031 | FLAG_STATIONARY | FLAG_ALLOW_FIRST_PERSON | FLAG_PAUSE_EXIT)
		FREEFALL_LAND_STOP = 0x0C000232, -- (0x032 | FLAG_STATIONARY | FLAG_ALLOW_FIRST_PERSON | FLAG_PAUSE_EXIT)
		SIDE_FLIP_LAND_STOP = 0x0C000233, -- (0x033 | FLAG_STATIONARY | FLAG_ALLOW_FIRST_PERSON | FLAG_PAUSE_EXIT)
		HOLD_JUMP_LAND_STOP = 0x08000234, -- (0x034 | FLAG_STATIONARY | FLAG_PAUSE_EXIT)
		HOLD_FREEFALL_LAND_STOP = 0x08000235, -- (0x035 | FLAG_STATIONARY | FLAG_PAUSE_EXIT)
		AIR_THROW_LAND = 0x80000A36, -- (0x036 | FLAG_STATIONARY | FLAG_AIR | FLAG_THROWING)
		TWIRL_LAND = 0x18800238, -- (0x038 | FLAG_STATIONARY | FLAG_ATTACKING | FLAG_PAUSE_EXIT | FLAG_SWIMMING_OR_FLYING)
		LAVA_BOOST_LAND = 0x08000239, -- (0x039 | FLAG_STATIONARY | FLAG_PAUSE_EXIT)
		TRIPLE_JUMP_LAND_STOP = 0x0800023A, -- (0x03A | FLAG_STATIONARY | FLAG_PAUSE_EXIT)
		LONG_JUMP_LAND_STOP = 0x0800023B, -- (0x03B | FLAG_STATIONARY | FLAG_PAUSE_EXIT)
		GROUND_POUND_LAND = 0x0080023C, -- (0x03C | FLAG_STATIONARY | FLAG_ATTACKING)
		BRAKING_STOP = 0x0C00023D, -- (0x03D | FLAG_STATIONARY | FLAG_ALLOW_FIRST_PERSON | FLAG_PAUSE_EXIT)
		BUTT_SLIDE_STOP = 0x0C00023E, -- (0x03E | FLAG_STATIONARY | FLAG_ALLOW_FIRST_PERSON | FLAG_PAUSE_EXIT)
		HOLD_BUTT_SLIDE_STOP = 0x0800043F, -- (0x03F | FLAG_MOVING | FLAG_PAUSE_EXIT)

		-- group 0x040: moving (ground) actions
		WALKING = 0x04000440, -- (0x040 | FLAG_MOVING | FLAG_ALLOW_FIRST_PERSON)
		HOLD_WALKING = 0x00000442, -- (0x042 | FLAG_MOVING)
		TURNING_AROUND = 0x00000443, -- (0x043 | FLAG_MOVING)
		FINISH_TURNING_AROUND = 0x00000444, -- (0x044 | FLAG_MOVING)
		BRAKING = 0x04000445, -- (0x045 | FLAG_MOVING | FLAG_ALLOW_FIRST_PERSON)
		RIDING_SHELL_GROUND = 0x20810446, -- (0x046 | FLAG_MOVING | FLAG_RIDING_SHELL | FLAG_ATTACKING | FLAG_WATER_OR_TEXT)
		HOLD_HEAVY_WALKING = 0x00000447, -- (0x047 | FLAG_MOVING)
		CRAWLING = 0x04008448, -- (0x048 | FLAG_MOVING | FLAG_SHORT_HITBOX | FLAG_ALLOW_FIRST_PERSON)
		BURNING_GROUND = 0x00020449, -- (0x049 | FLAG_MOVING | FLAG_INVULNERABLE)
		DECELERATING = 0x0400044A, -- (0x04A | FLAG_MOVING | FLAG_ALLOW_FIRST_PERSON)
		HOLD_DECELERATING = 0x0000044B, -- (0x04B | FLAG_MOVING)
		BEGIN_SLIDING = 0x00000050, -- (0x050)
		HOLD_BEGIN_SLIDING = 0x00000051, -- (0x051)
		BUTT_SLIDE = 0x00840452, -- (0x052 | FLAG_MOVING | FLAG_BUTT_OR_STOMACH_SLIDE | FLAG_ATTACKING)
		STOMACH_SLIDE = 0x008C0453, -- (0x053 | FLAG_MOVING | FLAG_BUTT_OR_STOMACH_SLIDE | FLAG_DIVING | FLAG_ATTACKING)
		HOLD_BUTT_SLIDE = 0x00840454, -- (0x054 | FLAG_MOVING | FLAG_BUTT_OR_STOMACH_SLIDE | FLAG_ATTACKING)
		HOLD_STOMACH_SLIDE = 0x008C0455, -- (0x055 | FLAG_MOVING | FLAG_BUTT_OR_STOMACH_SLIDE | FLAG_DIVING | FLAG_ATTACKING)
		DIVE_SLIDE = 0x00880456, -- (0x056 | FLAG_MOVING | FLAG_DIVING | FLAG_ATTACKING)
		MOVE_PUNCHING = 0x00800457, -- (0x057 | FLAG_MOVING | FLAG_ATTACKING)
		CROUCH_SLIDE = 0x04808459, -- (0x059 | FLAG_MOVING | FLAG_SHORT_HITBOX | FLAG_ATTACKING | FLAG_ALLOW_FIRST_PERSON)
		SLIDE_KICK_SLIDE = 0x0080045A, -- (0x05A | FLAG_MOVING | FLAG_ATTACKING)
		HARD_BACKWARD_GROUND_KB = 0x00020460, -- (0x060 | FLAG_MOVING | FLAG_INVULNERABLE)
		HARD_FORWARD_GROUND_KB = 0x00020461, -- (0x061 | FLAG_MOVING | FLAG_INVULNERABLE)
		BACKWARD_GROUND_KB = 0x00020462, -- (0x062 | FLAG_MOVING | FLAG_INVULNERABLE)
		FORWARD_GROUND_KB = 0x00020463, -- (0x063 | FLAG_MOVING | FLAG_INVULNERABLE)
		SOFT_BACKWARD_GROUND_KB = 0x00020464, -- (0x064 | FLAG_MOVING | FLAG_INVULNERABLE)
		SOFT_FORWARD_GROUND_KB = 0x00020465, -- (0x065 | FLAG_MOVING | FLAG_INVULNERABLE)
		GROUND_BONK = 0x00020466, -- (0x066 | FLAG_MOVING | FLAG_INVULNERABLE)
		DEATH_EXIT_LAND = 0x00020467, -- (0x067 | FLAG_MOVING | FLAG_INVULNERABLE)
		JUMP_LAND = 0x04000470, -- (0x070 | FLAG_MOVING | FLAG_ALLOW_FIRST_PERSON)
		FREEFALL_LAND = 0x04000471, -- (0x071 | FLAG_MOVING | FLAG_ALLOW_FIRST_PERSON)
		DOUBLE_JUMP_LAND = 0x04000472, -- (0x072 | FLAG_MOVING | FLAG_ALLOW_FIRST_PERSON)
		SIDE_FLIP_LAND = 0x04000473, -- (0x073 | FLAG_MOVING | FLAG_ALLOW_FIRST_PERSON)
		HOLD_JUMP_LAND = 0x00000474, -- (0x074 | FLAG_MOVING)
		HOLD_FREEFALL_LAND = 0x00000475, -- (0x075 | FLAG_MOVING)
		QUICKSAND_JUMP_LAND = 0x00000476, -- (0x076 | FLAG_MOVING)
		HOLD_QUICKSAND_JUMP_LAND = 0x00000477, -- (0x077 | FLAG_MOVING)
		TRIPLE_JUMP_LAND = 0x04000478, -- (0x078 | FLAG_MOVING | FLAG_ALLOW_FIRST_PERSON)
		LONG_JUMP_LAND = 0x00000479, -- (0x079 | FLAG_MOVING)
		BACKFLIP_LAND = 0x0400047A, -- (0x07A | FLAG_MOVING | FLAG_ALLOW_FIRST_PERSON)

		-- group 0x080: airborne actions
		JUMP = 0x03000880, -- (0x080 | FLAG_AIR | FLAG_ALLOW_VERTICAL_WIND_ACTION | FLAG_CONTROL_JUMP_HEIGHT)
		DOUBLE_JUMP = 0x03000881, -- (0x081 | FLAG_AIR | FLAG_ALLOW_VERTICAL_WIND_ACTION | FLAG_CONTROL_JUMP_HEIGHT)
		TRIPLE_JUMP = 0x01000882, -- (0x082 | FLAG_AIR | FLAG_ALLOW_VERTICAL_WIND_ACTION)
		BACKFLIP = 0x01000883, -- (0x083 | FLAG_AIR | FLAG_ALLOW_VERTICAL_WIND_ACTION)
		STEEP_JUMP = 0x03000885, -- (0x085 | FLAG_AIR | FLAG_ALLOW_VERTICAL_WIND_ACTION | FLAG_CONTROL_JUMP_HEIGHT)
		WALL_KICK_AIR = 0x03000886, -- (0x086 | FLAG_AIR | FLAG_ALLOW_VERTICAL_WIND_ACTION | FLAG_CONTROL_JUMP_HEIGHT)
		SIDE_FLIP = 0x01000887, -- (0x087 | FLAG_AIR | FLAG_ALLOW_VERTICAL_WIND_ACTION)
		LONG_JUMP = 0x03000888, -- (0x088 | FLAG_AIR | FLAG_ALLOW_VERTICAL_WIND_ACTION | FLAG_CONTROL_JUMP_HEIGHT)
		WATER_JUMP = 0x01000889, -- (0x089 | FLAG_AIR | FLAG_ALLOW_VERTICAL_WIND_ACTION)
		DIVE = 0x0188088A, -- (0x08A | FLAG_AIR | FLAG_DIVING | FLAG_ATTACKING | FLAG_ALLOW_VERTICAL_WIND_ACTION)
		FREEFALL = 0x0100088C, -- (0x08C | FLAG_AIR | FLAG_ALLOW_VERTICAL_WIND_ACTION)
		TOP_OF_POLE_JUMP = 0x0300088D, -- (0x08D | FLAG_AIR | FLAG_ALLOW_VERTICAL_WIND_ACTION | FLAG_CONTROL_JUMP_HEIGHT)
		BUTT_SLIDE_AIR = 0x0300088E, -- (0x08E | FLAG_AIR | FLAG_ALLOW_VERTICAL_WIND_ACTION | FLAG_CONTROL_JUMP_HEIGHT)
		FLYING_TRIPLE_JUMP = 0x03000894, -- (0x094 | FLAG_AIR | FLAG_ALLOW_VERTICAL_WIND_ACTION | FLAG_CONTROL_JUMP_HEIGHT)
		SHOT_FROM_CANNON = 0x00880898, -- (0x098 | FLAG_AIR | FLAG_DIVING | FLAG_ATTACKING)
		FLYING = 0x10880899, -- (0x099 | FLAG_AIR | FLAG_DIVING | FLAG_ATTACKING | FLAG_SWIMMING_OR_FLYING)
		RIDING_SHELL_JUMP = 0x0281089A, -- (0x09A | FLAG_AIR | FLAG_RIDING_SHELL | FLAG_ATTACKING | FLAG_CONTROL_JUMP_HEIGHT)
		RIDING_SHELL_FALL = 0x0081089B, -- (0x09B | FLAG_AIR | FLAG_RIDING_SHELL | FLAG_ATTACKING)
		VERTICAL_WIND = 0x1008089C, -- (0x09C | FLAG_AIR | FLAG_DIVING | FLAG_SWIMMING_OR_FLYING)
		HOLD_JUMP = 0x030008A0, -- (0x0A0 | FLAG_AIR | FLAG_ALLOW_VERTICAL_WIND_ACTION | FLAG_CONTROL_JUMP_HEIGHT)
		HOLD_FREEFALL = 0x010008A1, -- (0x0A1 | FLAG_AIR | FLAG_ALLOW_VERTICAL_WIND_ACTION)
		HOLD_BUTT_SLIDE_AIR = 0x010008A2, -- (0x0A2 | FLAG_AIR | FLAG_ALLOW_VERTICAL_WIND_ACTION)
		HOLD_WATER_JUMP = 0x010008A3, -- (0x0A3 | FLAG_AIR | FLAG_ALLOW_VERTICAL_WIND_ACTION)
		TWIRLING = 0x108008A4, -- (0x0A4 | FLAG_AIR | FLAG_ATTACKING | FLAG_SWIMMING_OR_FLYING)
		FORWARD_ROLLOUT = 0x010008A6, -- (0x0A6 | FLAG_AIR | FLAG_ALLOW_VERTICAL_WIND_ACTION)
		AIR_HIT_WALL = 0x000008A7, -- (0x0A7 | FLAG_AIR)
		RIDING_HOOT = 0x000004A8, -- (0x0A8 | FLAG_MOVING)
		GROUND_POUND = 0x008008A9, -- (0x0A9 | FLAG_AIR | FLAG_ATTACKING)
		SLIDE_KICK = 0x018008AA, -- (0x0AA | FLAG_AIR | FLAG_ATTACKING | FLAG_ALLOW_VERTICAL_WIND_ACTION)
		AIR_THROW = 0x830008AB, -- (0x0AB | FLAG_AIR | FLAG_ALLOW_VERTICAL_WIND_ACTION | FLAG_CONTROL_JUMP_HEIGHT | FLAG_THROWING)
		JUMP_KICK = 0x018008AC, -- (0x0AC | FLAG_AIR | FLAG_ATTACKING | FLAG_ALLOW_VERTICAL_WIND_ACTION)
		BACKWARD_ROLLOUT = 0x010008AD, -- (0x0AD | FLAG_AIR | FLAG_ALLOW_VERTICAL_WIND_ACTION)
		CRAZY_BOX_BOUNCE = 0x000008AE, -- (0x0AE | FLAG_AIR)
		SPECIAL_TRIPLE_JUMP = 0x030008AF, -- (0x0AF | FLAG_AIR | FLAG_ALLOW_VERTICAL_WIND_ACTION | FLAG_CONTROL_JUMP_HEIGHT)
		BACKWARD_AIR_KB = 0x010208B0, -- (0x0B0 | FLAG_AIR | FLAG_INVULNERABLE | FLAG_ALLOW_VERTICAL_WIND_ACTION)
		FORWARD_AIR_KB = 0x010208B1, -- (0x0B1 | FLAG_AIR | FLAG_INVULNERABLE | FLAG_ALLOW_VERTICAL_WIND_ACTION)
		HARD_FORWARD_AIR_KB = 0x010208B2, -- (0x0B2 | FLAG_AIR | FLAG_INVULNERABLE | FLAG_ALLOW_VERTICAL_WIND_ACTION)
		HARD_BACKWARD_AIR_KB = 0x010208B3, -- (0x0B3 | FLAG_AIR | FLAG_INVULNERABLE | FLAG_ALLOW_VERTICAL_WIND_ACTION)
		BURNING_JUMP = 0x010208B4, -- (0x0B4 | FLAG_AIR | FLAG_INVULNERABLE | FLAG_ALLOW_VERTICAL_WIND_ACTION)
		BURNING_FALL = 0x010208B5, -- (0x0B5 | FLAG_AIR | FLAG_INVULNERABLE | FLAG_ALLOW_VERTICAL_WIND_ACTION)
		SOFT_BONK = 0x010208B6, -- (0x0B6 | FLAG_AIR | FLAG_INVULNERABLE | FLAG_ALLOW_VERTICAL_WIND_ACTION)
		LAVA_BOOST = 0x010208B7, -- (0x0B7 | FLAG_AIR | FLAG_INVULNERABLE | FLAG_ALLOW_VERTICAL_WIND_ACTION)
		GETTING_BLOWN = 0x010208B8, -- (0x0B8 | FLAG_AIR | FLAG_INVULNERABLE | FLAG_ALLOW_VERTICAL_WIND_ACTION)
		THROWN_FORWARD = 0x010208BD, -- (0x0BD | FLAG_AIR | FLAG_INVULNERABLE | FLAG_ALLOW_VERTICAL_WIND_ACTION)
		THROWN_BACKWARD = 0x010208BE, -- (0x0BE | FLAG_AIR | FLAG_INVULNERABLE | FLAG_ALLOW_VERTICAL_WIND_ACTION)

		-- group 0x0C0: submerged actions
		WATER_IDLE = 0x380022C0, -- (0x0C0 | FLAG_STATIONARY | FLAG_SWIMMING | FLAG_PAUSE_EXIT | FLAG_SWIMMING_OR_FLYING | FLAG_WATER_OR_TEXT)
		HOLD_WATER_IDLE = 0x380022C1, -- (0x0C1 | FLAG_STATIONARY | FLAG_SWIMMING | FLAG_PAUSE_EXIT | FLAG_SWIMMING_OR_FLYING | FLAG_WATER_OR_TEXT)
		WATER_ACTION_END = 0x300022C2, -- (0x0C2 | FLAG_STATIONARY | FLAG_SWIMMING | FLAG_SWIMMING_OR_FLYING | FLAG_WATER_OR_TEXT)
		HOLD_WATER_ACTION_END = 0x300022C3, -- (0x0C3 | FLAG_STATIONARY | FLAG_SWIMMING | FLAG_SWIMMING_OR_FLYING | FLAG_WATER_OR_TEXT)
		DROWNING = 0x300032C4, -- (0x0C4 | FLAG_STATIONARY | FLAG_INTANGIBLE | FLAG_SWIMMING | FLAG_SWIMMING_OR_FLYING | FLAG_WATER_OR_TEXT)
		BACKWARD_WATER_KB = 0x300222C5, -- (0x0C5 | FLAG_STATIONARY | FLAG_SWIMMING | FLAG_INVULNERABLE | FLAG_SWIMMING_OR_FLYING | FLAG_WATER_OR_TEXT)
		FORWARD_WATER_KB = 0x300222C6, -- (0x0C6 | FLAG_STATIONARY | FLAG_SWIMMING | FLAG_INVULNERABLE | FLAG_SWIMMING_OR_FLYING | FLAG_WATER_OR_TEXT)
		WATER_DEATH = 0x300032C7, -- (0x0C7 | FLAG_STATIONARY | FLAG_INTANGIBLE | FLAG_SWIMMING | FLAG_SWIMMING_OR_FLYING | FLAG_WATER_OR_TEXT)
		WATER_SHOCKED = 0x300222C8, -- (0x0C8 | FLAG_STATIONARY | FLAG_SWIMMING | FLAG_INVULNERABLE | FLAG_SWIMMING_OR_FLYING | FLAG_WATER_OR_TEXT)
		BREASTSTROKE = 0x300024D0, -- (0x0D0 | FLAG_MOVING | FLAG_SWIMMING | FLAG_SWIMMING_OR_FLYING | FLAG_WATER_OR_TEXT)
		SWIMMING_END = 0x300024D1, -- (0x0D1 | FLAG_MOVING | FLAG_SWIMMING | FLAG_SWIMMING_OR_FLYING | FLAG_WATER_OR_TEXT)
		FLUTTER_KICK = 0x300024D2, -- (0x0D2 | FLAG_MOVING | FLAG_SWIMMING | FLAG_SWIMMING_OR_FLYING | FLAG_WATER_OR_TEXT)
		HOLD_BREASTSTROKE = 0x300024D3, -- (0x0D3 | FLAG_MOVING | FLAG_SWIMMING | FLAG_SWIMMING_OR_FLYING | FLAG_WATER_OR_TEXT)
		HOLD_SWIMMING_END = 0x300024D4, -- (0x0D4 | FLAG_MOVING | FLAG_SWIMMING | FLAG_SWIMMING_OR_FLYING | FLAG_WATER_OR_TEXT)
		HOLD_FLUTTER_KICK = 0x300024D5, -- (0x0D5 | FLAG_MOVING | FLAG_SWIMMING | FLAG_SWIMMING_OR_FLYING | FLAG_WATER_OR_TEXT)
		WATER_SHELL_SWIMMING = 0x300024D6, -- (0x0D6 | FLAG_MOVING | FLAG_SWIMMING | FLAG_SWIMMING_OR_FLYING | FLAG_WATER_OR_TEXT)
		WATER_THROW = 0x300024E0, -- (0x0E0 | FLAG_MOVING | FLAG_SWIMMING | FLAG_SWIMMING_OR_FLYING | FLAG_WATER_OR_TEXT)
		WATER_PUNCH = 0x300024E1, -- (0x0E1 | FLAG_MOVING | FLAG_SWIMMING | FLAG_SWIMMING_OR_FLYING | FLAG_WATER_OR_TEXT)
		WATER_PLUNGE = 0x300022E2, -- (0x0E2 | FLAG_STATIONARY | FLAG_SWIMMING | FLAG_SWIMMING_OR_FLYING | FLAG_WATER_OR_TEXT)
		CAUGHT_IN_WHIRLPOOL = 0x300222E3, -- (0x0E3 | FLAG_STATIONARY | FLAG_SWIMMING | FLAG_INVULNERABLE | FLAG_SWIMMING_OR_FLYING | FLAG_WATER_OR_TEXT)
		METAL_WATER_STANDING = 0x080042F0, -- (0x0F0 | FLAG_STATIONARY | FLAG_METAL_WATER | FLAG_PAUSE_EXIT)
		HOLD_METAL_WATER_STANDING = 0x080042F1, -- (0x0F1 | FLAG_STATIONARY | FLAG_METAL_WATER | FLAG_PAUSE_EXIT)
		METAL_WATER_WALKING = 0x000044F2, -- (0x0F2 | FLAG_MOVING | FLAG_METAL_WATER)
		HOLD_METAL_WATER_WALKING = 0x000044F3, -- (0x0F3 | FLAG_MOVING | FLAG_METAL_WATER)
		METAL_WATER_FALLING = 0x000042F4, -- (0x0F4 | FLAG_STATIONARY | FLAG_METAL_WATER)
		HOLD_METAL_WATER_FALLING = 0x000042F5, -- (0x0F5 | FLAG_STATIONARY | FLAG_METAL_WATER)
		METAL_WATER_FALL_LAND = 0x000042F6, -- (0x0F6 | FLAG_STATIONARY | FLAG_METAL_WATER)
		HOLD_METAL_WATER_FALL_LAND = 0x000042F7, -- (0x0F7 | FLAG_STATIONARY | FLAG_METAL_WATER)
		METAL_WATER_JUMP = 0x000044F8, -- (0x0F8 | FLAG_MOVING | FLAG_METAL_WATER)
		HOLD_METAL_WATER_JUMP = 0x000044F9, -- (0x0F9 | FLAG_MOVING | FLAG_METAL_WATER)
		METAL_WATER_JUMP_LAND = 0x000044FA, -- (0x0FA | FLAG_MOVING | FLAG_METAL_WATER)
		HOLD_METAL_WATER_JUMP_LAND = 0x000044FB, -- (0x0FB | FLAG_MOVING | FLAG_METAL_WATER)

		-- group 0x100: cutscene actions
		DISAPPEARED = 0x00001300, -- (0x100 | FLAG_STATIONARY | FLAG_INTANGIBLE)
		INTRO_CUTSCENE = 0x04001301, -- (0x101 | FLAG_STATIONARY | FLAG_INTANGIBLE | FLAG_ALLOW_FIRST_PERSON)
		STAR_DANCE_EXIT = 0x00001302, -- (0x102 | FLAG_STATIONARY | FLAG_INTANGIBLE)
		STAR_DANCE_WATER = 0x00001303, -- (0x103 | FLAG_STATIONARY | FLAG_INTANGIBLE)
		FALL_AFTER_STAR_GRAB = 0x00001904, -- (0x104 | FLAG_AIR | FLAG_INTANGIBLE)
		READING_AUTOMATIC_DIALOG = 0x20001305, -- (0x105 | FLAG_STATIONARY | FLAG_INTANGIBLE | FLAG_WATER_OR_TEXT)
		READING_NPC_DIALOG = 0x20001306, -- (0x106 | FLAG_STATIONARY | FLAG_INTANGIBLE | FLAG_WATER_OR_TEXT)
		STAR_DANCE_NO_EXIT = 0x00001307, -- (0x107 | FLAG_STATIONARY | FLAG_INTANGIBLE)
		READING_SIGN = 0x00001308, -- (0x108 | FLAG_STATIONARY | FLAG_INTANGIBLE)
		JUMBO_STAR_CUTSCENE = 0x00001909, -- (0x109 | FLAG_AIR | FLAG_INTANGIBLE)
		WAITING_FOR_DIALOG = 0x0000130A, -- (0x10A | FLAG_STATIONARY | FLAG_INTANGIBLE)
		DEBUG_FREE_MOVE = 0x0000130F, -- (0x10F | FLAG_STATIONARY | FLAG_INTANGIBLE)
		STANDING_DEATH = 0x00021311, -- (0x111 | FLAG_STATIONARY | FLAG_INTANGIBLE | FLAG_INVULNERABLE)
		QUICKSAND_DEATH = 0x00021312, -- (0x112 | FLAG_STATIONARY | FLAG_INTANGIBLE | FLAG_INVULNERABLE)
		ELECTROCUTION = 0x00021313, -- (0x113 | FLAG_STATIONARY | FLAG_INTANGIBLE | FLAG_INVULNERABLE)
		SUFFOCATION = 0x00021314, -- (0x114 | FLAG_STATIONARY | FLAG_INTANGIBLE | FLAG_INVULNERABLE)
		DEATH_ON_STOMACH = 0x00021315, -- (0x115 | FLAG_STATIONARY | FLAG_INTANGIBLE | FLAG_INVULNERABLE)
		DEATH_ON_BACK = 0x00021316, -- (0x116 | FLAG_STATIONARY | FLAG_INTANGIBLE | FLAG_INVULNERABLE)
		EATEN_BY_BUBBA = 0x00021317, -- (0x117 | FLAG_STATIONARY | FLAG_INTANGIBLE | FLAG_INVULNERABLE)
		END_PEACH_CUTSCENE = 0x00001918, -- (0x118 | FLAG_AIR | FLAG_INTANGIBLE)
		CREDITS_CUTSCENE = 0x00001319, -- (0x119 | FLAG_STATIONARY | FLAG_INTANGIBLE)
		END_WAVING_CUTSCENE = 0x0000131A, -- (0x11A | FLAG_STATIONARY | FLAG_INTANGIBLE)
		PULLING_DOOR = 0x00001320, -- (0x120 | FLAG_STATIONARY | FLAG_INTANGIBLE)
		PUSHING_DOOR = 0x00001321, -- (0x121 | FLAG_STATIONARY | FLAG_INTANGIBLE)
		WARP_DOOR_SPAWN = 0x00001322, -- (0x122 | FLAG_STATIONARY | FLAG_INTANGIBLE)
		EMERGE_FROM_PIPE = 0x00001923, -- (0x123 | FLAG_AIR | FLAG_INTANGIBLE)
		SPAWN_SPIN_AIRBORNE = 0x00001924, -- (0x124 | FLAG_AIR | FLAG_INTANGIBLE)
		SPAWN_SPIN_LANDING = 0x00001325, -- (0x125 | FLAG_STATIONARY | FLAG_INTANGIBLE)
		EXIT_AIRBORNE = 0x00001926, -- (0x126 | FLAG_AIR | FLAG_INTANGIBLE)
		EXIT_LAND_SAVE_DIALOG = 0x00001327, -- (0x127 | FLAG_STATIONARY | FLAG_INTANGIBLE)
		DEATH_EXIT = 0x00001928, -- (0x128 | FLAG_AIR | FLAG_INTANGIBLE)
		UNUSED_DEATH_EXIT = 0x00001929, -- (0x129 | FLAG_AIR | FLAG_INTANGIBLE)
		FALLING_DEATH_EXIT = 0x0000192A, -- (0x12A | FLAG_AIR | FLAG_INTANGIBLE)
		SPECIAL_EXIT_AIRBORNE = 0x0000192B, -- (0x12B | FLAG_AIR | FLAG_INTANGIBLE)
		SPECIAL_DEATH_EXIT = 0x0000192C, -- (0x12C | FLAG_AIR | FLAG_INTANGIBLE)
		FALLING_EXIT_AIRBORNE = 0x0000192D, -- (0x12D | FLAG_AIR | FLAG_INTANGIBLE)
		UNLOCKING_KEY_DOOR = 0x0000132E, -- (0x12E | FLAG_STATIONARY | FLAG_INTANGIBLE)
		UNLOCKING_STAR_DOOR = 0x0000132F, -- (0x12F | FLAG_STATIONARY | FLAG_INTANGIBLE)
		ENTERING_STAR_DOOR = 0x00001331, -- (0x131 | FLAG_STATIONARY | FLAG_INTANGIBLE)
		SPAWN_NO_SPIN_AIRBORNE = 0x00001932, -- (0x132 | FLAG_AIR | FLAG_INTANGIBLE)
		SPAWN_NO_SPIN_LANDING = 0x00001333, -- (0x133 | FLAG_STATIONARY | FLAG_INTANGIBLE)
		BBH_ENTER_JUMP = 0x00001934, -- (0x134 | FLAG_AIR | FLAG_INTANGIBLE)
		BBH_ENTER_SPIN = 0x00001535, -- (0x135 | FLAG_MOVING | FLAG_INTANGIBLE)
		TELEPORT_FADE_OUT = 0x00001336, -- (0x136 | FLAG_STATIONARY | FLAG_INTANGIBLE)
		TELEPORT_FADE_IN = 0x00001337, -- (0x137 | FLAG_STATIONARY | FLAG_INTANGIBLE)
		SHOCKED = 0x00020338, -- (0x138 | FLAG_STATIONARY | FLAG_INVULNERABLE)
		SQUISHED = 0x00020339, -- (0x139 | FLAG_STATIONARY | FLAG_INVULNERABLE)
		HEAD_STUCK_IN_GROUND = 0x0002033A, -- (0x13A | FLAG_STATIONARY | FLAG_INVULNERABLE)
		BUTT_STUCK_IN_GROUND = 0x0002033B, -- (0x13B | FLAG_STATIONARY | FLAG_INVULNERABLE)
		FEET_STUCK_IN_GROUND = 0x0002033C, -- (0x13C | FLAG_STATIONARY | FLAG_INVULNERABLE)
		PUTTING_ON_CAP = 0x0000133D, -- (0x13D | FLAG_STATIONARY | FLAG_INTANGIBLE)

		-- group 0x140: "automatic" actions
		HOLDING_POLE = 0x08100340, -- (0x140 | FLAG_STATIONARY | FLAG_ON_POLE | FLAG_PAUSE_EXIT)
		GRAB_POLE_SLOW = 0x00100341, -- (0x141 | FLAG_STATIONARY | FLAG_ON_POLE)
		GRAB_POLE_FAST = 0x00100342, -- (0x142 | FLAG_STATIONARY | FLAG_ON_POLE)
		CLIMBING_POLE = 0x00100343, -- (0x143 | FLAG_STATIONARY | FLAG_ON_POLE)
		TOP_OF_POLE_TRANSITION = 0x00100344, -- (0x144 | FLAG_STATIONARY | FLAG_ON_POLE)
		TOP_OF_POLE = 0x00100345, -- (0x145 | FLAG_STATIONARY | FLAG_ON_POLE)
		START_HANGING = 0x08200348, -- (0x148 | FLAG_STATIONARY | FLAG_HANGING | FLAG_PAUSE_EXIT)
		HANGING = 0x00200349, -- (0x149 | FLAG_STATIONARY | FLAG_HANGING)
		HANG_MOVING = 0x0020054A, -- (0x14A | FLAG_MOVING | FLAG_HANGING)
		LEDGE_GRAB = 0x0800034B, -- (0x14B | FLAG_STATIONARY | FLAG_PAUSE_EXIT)
		LEDGE_CLIMB_SLOW = 0x0000054C, -- (0x14C | FLAG_MOVING)
		LEDGE_CLIMB_DOWN = 0x0000054D, -- (0x14D | FLAG_MOVING)
		LEDGE_CLIMB_FAST = 0x0000054E, -- (0x14E | FLAG_MOVING)
		GRABBED = 0x00020370, -- (0x170 | FLAG_STATIONARY | FLAG_INVULNERABLE)
		IN_CANNON = 0x00001371, -- (0x171 | FLAG_STATIONARY | FLAG_INTANGIBLE)
		TORNADO_TWIRLING = 0x10020372, -- (0x172 | FLAG_STATIONARY | FLAG_INVULNERABLE | FLAG_SWIMMING_OR_FLYING)

		-- group 0x180: object actions
		PUNCHING = 0x00800380, -- (0x180 | FLAG_STATIONARY | FLAG_ATTACKING)
		PICKING_UP = 0x00000383, -- (0x183 | FLAG_STATIONARY)
		DIVE_PICKING_UP = 0x00000385, -- (0x185 | FLAG_STATIONARY)
		STOMACH_SLIDE_STOP = 0x00000386, -- (0x186 | FLAG_STATIONARY)
		PLACING_DOWN = 0x00000387, -- (0x187 | FLAG_STATIONARY)
		THROWING = 0x80000588, -- (0x188 | FLAG_MOVING | FLAG_THROWING)
		HEAVY_THROW = 0x80000589, -- (0x189 | FLAG_MOVING | FLAG_THROWING)
		PICKING_UP_BOWSER = 0x00000390, -- (0x190 | FLAG_STATIONARY)
		HOLDING_BOWSER = 0x00000391, -- (0x191 | FLAG_STATIONARY)
		RELEASING_BOWSER = 0x00000392, -- (0x192 | FLAG_STATIONARY)
	}
	-- states preprocess
	for k,v in maryo.Enums.Action do
		local w = {}
		for l,x in maryo.Enums.ActionFlags do
			w[l] = bit32.band(v, x) ~= 0
		end
		w.GROUP = "UNKNOWN"
		local y = bit32.band(v, maryo.Enums.ActionGroups.GROUP_MASK)
		for l,x in maryo.Enums.ActionGroups do
			if l ~= "GROUP_MASK" then
				if y == x then
					w.GROUP = l
					break
				end
			end
		end
		w.ID = bit32.band(v, 0x1FF)
		w.NAME = k
		maryo.Enums.Action[k] = w
	end
	maryo.Enums.TerrainType = {
		[Enum.Material.Mud] = "GRASS",
		[Enum.Material.Grass] = "GRASS",
		[Enum.Material.Ground] = "GRASS",
		[Enum.Material.LeafyGrass] = "GRASS",
		
		[Enum.Material.Ice] = "ICE",
		[Enum.Material.Marble] = "ICE",
		[Enum.Material.Glacier] = "ICE",
		
		[Enum.Material.Wood] = "SPOOKY",
		[Enum.Material.WoodPlanks] = "SPOOKY",
		
		[Enum.Material.Foil] = "METAL",
		[Enum.Material.Metal] = "METAL",
		[Enum.Material.DiamondPlate] = "METAL",
		[Enum.Material.CorrodedMetal] = "METAL",
		
		[Enum.Material.Rock] = "STONE",
		[Enum.Material.Salt] = "STONE",
		[Enum.Material.Brick] = "STONE",
		[Enum.Material.Slate] = "STONE",
		[Enum.Material.Basalt] = "STONE",
		[Enum.Material.Pebble] = "STONE",
		[Enum.Material.Granite] = "STONE",
		[Enum.Material.Sandstone] = "STONE",
		[Enum.Material.Cobblestone] = "STONE",
		[Enum.Material.CrackedLava] = "STONE",
		
		[Enum.Material.Snow] = "SNOW",
		[Enum.Material.Sand] = "SAND",
		[Enum.Material.Water] = "WATER",
		[Enum.Material.Fabric] = "SNOW",
	}
	function maryo.IsAnimAtEnd()
		return maryo.AnimFrame >= maryo.AnimFrameCount
	end
	function maryo.IsAnimPastEnd()
		return maryo.AnimFrame >= maryo.AnimFrameCount - 2
	end
	function maryo.SetAnimation(anim)
		local data = maryo.Animations[anim]
		assert(data)
		if maryo.AnimCurrent == data then
			return maryo.AnimFrame
		end
		maryo.AnimFrameCount = data.C
		maryo.AnimCurrent = data
		maryo.AnimAccelAssist = 0
		maryo.AnimAccel = 0
		maryo.AnimReset = true
		maryo.AnimDirty = true
		maryo.AnimFrame = data.F
		return data.F
	end
	function maryo.SetAnimationWithAccel(anim, accel)
		local data = maryo.Animations[anim]
		assert(data)
		if maryo.AnimCurrent ~= data then
			maryo.SetAnimation(anim)
			maryo.AnimAccelAssist = -accel
		end
		maryo.AnimAccel = accel
		return maryo.AnimFrame
	end
	function maryo.SetAnimToFrame(frame)
		if maryo.AnimAccel ~= 0 then
			maryo.AnimAccelAssist = bit32.lshift(frame, 0x10) + maryo.AnimAccel
			maryo.AnimFrame = bit32.rshift(maryo.AnimAccelAssist, 0x10)
		else
			maryo.AnimFrame = frame + 1
		end
		maryo.AnimDirty = true
		maryo.AnimSetFrame = maryo.AnimFrame
	end
	function maryo.IsAnimPastFrame(frame)
		local isPastFrame = false
		local accel = maryo.AnimAccel
		if accel ~= 0 then
			local assist = maryo.AnimAccelAssist
			local accelFrame = bit32.lshift(frame, 0x10)
			isPastFrame = assist > accelFrame and accelFrame >= assist - accel
		else
			isPastFrame = maryo.AnimFrame == frame + 1
		end
		return isPastFrame
	end
	function maryo.PlaySound(sound)
		maryo.Sounds[sound] = true
	end
	function maryo.PlaySoundIfNoFlag(sound, flagname)
		if not maryo.Flags[flagname] then
			maryo.Flags[flagname] = true
			maryo.PlaySound(sound)
		end
	end
	function maryo.PlayJumpSound()
		if maryo.Flags.MARIO_SOUND_PLAYED then
			return
		end
		if maryo.Action.NAME == "TRIPLE_JUMP" then
			maryo.PlaySound("MARIO_YAHOO_WAHA_YIPPEE")
		elseif maryo.Action.NAME == "JUMP_KICK" then
			maryo.PlaySound("MARIO_PUNCH_HOO")
		else
			maryo.PlaySound("MARIO_YAH_WAH_HOO")
		end
		maryo.Flags.MARIO_SOUND_PLAYED = true
	end
	function maryo.PlayMaterialSound(sound)
		if maryo.TerrainType then
			maryo.PlaySound(sound .. "_" .. maryo.TerrainType)
		end
		maryo.PlaySound(sound)
	end
	function maryo.PlayActionSound(sound)
		maryo.PlaySoundIfNoFlag(sound, "ACTION_SOUND_PLAYED")
	end
	function maryo.PlayLandingSound(sound)
		sound = sound or "ACTION_TERRAIN_LANDING"
		if maryo.Flags.METAL_CAP then
			maryo.PlayMaterialSound("ACTION_METAL_LANDING")
			return
		end
		maryo.PlayMaterialSound(sound)
	end
	function maryo.PlayLandingSoundOnce()
		sound = sound or "ACTION_TERRAIN_LANDING"
		if maryo.Flags.METAL_CAP then
			maryo.PlayActionSound("ACTION_METAL_LANDING")
			return
		end
		maryo.PlayActionSound(sound)
	end
	function maryo.PlayHeavyLandingSound(sound)
		sound = sound or "ACTION_TERRAIN_LANDING"
		if maryo.Flags.METAL_CAP then
			maryo.PlayMaterialSound("ACTION_METAL_HEAVY_LANDING")
			return
		end
		maryo.PlayMaterialSound(sound)
	end
	function maryo.PlayHeavyLandingSoundOnce()
		sound = sound or "ACTION_TERRAIN_LANDING"
		if maryo.Flags.METAL_CAP then
			maryo.PlayActionSound("ACTION_METAL_HEAVY_LANDING")
			return
		end
		maryo.PlayActionSound(sound)
	end
	function maryo.PlayMarioSound(actionSound, marioSound)
		if marioSound == nil then
			marioSound = "MARIO_JUMP"
		end
		if actionSound == "ACTION_TERRAIN_JUMP" then
			if maryo.Flags.METAL_CAP then
				maryo.PlayActionSound("ACTION_METAL_JUMP")
			else
				maryo.PlayActionSound(actionSound)
			end
		else
			maryo.PlaySoundIfNoFlag(actionSound, "ACTION_SOUND_PLAYED")
		end
		if marioSound == "MARIO_JUMP" then
			maryo.PlayJumpSound()
		else
			maryo.PlaySoundIfNoFlag(marioSound, "MARIO_SOUND_PLAYED")
		end
	end
	function maryo.ToRotation(angle)
		return CFrame.fromAxisAngle(Vector3.yAxis, angle.Y) * CFrame.fromAxisAngle(Vector3.xAxis, -angle.X) * CFrame.fromAxisAngle(Vector3.zAxis, -angle.Z)
	end
	local rcp = RaycastParams.new()
	rcp.FilterType = Enum.RaycastFilterType.Exclude
	rcp.RespectCanCollide = true
	rcp.IgnoreWater = true
	function maryo.Raycast(pos, dir)
		return workspace:Raycast(pos, dir, rcp)
	end
	function maryo.FindFloor(pos)
		local height = -10000
		local result = maryo.Raycast(pos + Vector3.new(0, 5, 0), Vector3.new(0, -10000, 0))
		if result then
			height = result.Position.Y
		end
		return height, result
	end
	function maryo.FindCeiling(pos, height)
		local height = 10000
		local result = maryo.Raycast(Vector3.new(pos.X, (height or pos.Y) + 4, pos.Z), Vector3.new(0, 10000, 0))
		if result then
			height = result.Position.Y
		end
		return height, result
	end
	function maryo.FindWalls(pos, offset, radius)
		local origin = pos + Vector3.new(0, offset, 0)
		local lastwall = nil
		local disp = Vector3.zero
		for _,dir in XZ_DIRS do
			local contact = Util.RaycastSM64(origin, dir * radius)
			if contact then
				local normal = contact.Normal
				if math.abs(normal.Y) < 0.01 then
					local surface = contact.Position
					local move = (surface - pos) * VECTOR3_XZ
					local dist = move.Magnitude
					if dist < radius then
						disp += (contact.Normal * VECTOR3_XZ) * (radius - dist)
						lastwall = contact
					end
				end
			end
		end
		return pos + disp, lastwall
	end
	function maryo.SetForwardVel(forwardVel)
		maryo.ForwardVel = forwardVel
		maryo.SlideVelX = math.sin(maryo.FaceAngle.Y) * forwardVel
		maryo.SlideVelZ = math.cos(maryo.FaceAngle.Y) * forwardVel
		maryo.Velocity = Vector3.new(maryo.SlideVelX, maryo.Velocity.Y, maryo.SlideVelZ)
	end
	function maryo.SetUpwardVel(upwardVel)
		maryo.Velocity = Vector3.new(maryo.Velocity.X, upwardVel, maryo.Velocity.Z)
	end
	function maryo.SetHeight(height)
		maryo.Position = Vector3.new(maryo.Position.X, height, maryo.Position.Z)
	end
	function maryo.SetFaceYaw(yaw)
		maryo.FaceAngle = Vector3.new(maryo.FaceAngle.X, maryo.NormalizeAngle(yaw), maryo.FaceAngle.Z)
	end
	function maryo.GetFloorFriction()
		local f = maryo.Floor
		if f then
			local hit = f.Instance
			if hit then
				local friction = 0.7
				if hit:IsA("BasePart") then
					friction = hit.CurrentPhysicalProperties.Friction
				else
					-- its likely a terrain
					friction = PhysicalProperties.new(f.Material).Friction
				end
				if friction <= 0.025 then
					return "WHOOPSIES"
				elseif friction <= 0.5 then
					return "SLIPPERY"
				elseif friction >= 0.9 then
					return "STICKY"
				end
			end
		end
		return "DEFAULT"
	end
	function maryo.GetTerrainType()
		local f = maryo.Floor
		if f then
			return maryo.Enums.TerrainType[f.Material] or "DEFAULT"
		end
		return "DEFAULT"
	end
	-- this is for my reference
	-- positions scaled: 1 stud is 20 maryo units
	-- angle range [-pi, pi)
	-- cuz signed short does -0x8000 to 0x7FFF
	-- hoping cframes also do the same ^^
	function maryo.NormalizeAngle(angle)
		while angle < -math.pi do
			angle += 2 * math.pi
		end
		while angle >= math.pi do
			angle -= 2 * math.pi
		end
		return angle
	end
	function maryo.FacingDownhill(backwards)
		local faceAngleYaw = maryo.FaceAngle.Y
		if backwards and maryo.ForwardVel < 0 then
			faceAngleYaw = maryo.NormalizeAngle(faceAngleYaw + math.pi)
		end
		return math.abs(maryo.NormalizeAngle(maryo.FloorAngle - faceAngleYaw)) < math.pi / 2 -- 0x4000 is 90 degrees :3
	end
	function maryo.FloorAngleClassify(a, b, c, d)
		local f = maryo.Floor
		if f then
			local class = maryo.GetFloorFriction()
			local d = a
			if class == "WHOOPSIES" then
				d = b
			elseif class == "SLIPPERY" then
				d = c
			elseif class == "STICKY" then
				d = d
			end
			return floor.Normal.Y <= math.cos(math.rad(d))
		end
		return false
	end
	function maryo.FloorIsSlippery()
		return maryo.FloorAngleClassify(90, 10, 20, 38)
	end
	function maryo.FloorIsSlope()
		return maryo.FloorAngleClassify(15, 5, 10, 20)
	end
	function maryo.FloorIsSteep()
		return maryo.FloorAngleClassify(30, 1, 20, 30)
	end
	function maryo.FindFloorHeightRelativePolar(angle, dist)
		local x = math.sin(maryo.FaceAngle.Y + angle) * dist
		local z = math.cos(maryo.FaceAngle.Y + angle) * dist
		return maryo.FindFloor(maryo.Position + Vector3.new(x, 5, z))
	end
	function maryo.FindFloorSlope(angle)
		local x = math.sin(maryo.FaceAngle.Y + angle) * 5
		local z = math.cos(maryo.FaceAngle.Y + angle) * 5
		local floor1 = maryo.FindFloor(maryo.Position + Vector3.new(x, 5, z))
		local floor2 = maryo.FindFloor(maryo.Position + Vector3.new(-x, 5, -z))
		local result = 0
		if floor1 and floor2 then
			local delta1 = floor1 - maryo.Position.Y
			local delta2 = maryo.Position.Y - floor2
			if delta * delta1 < delta2 * delta2 then
				result = math.atan2(5, forwardYDelta)
			else
				result = math.atan2(5, backwardYDelta)
			end
		end
		return maryo.NormalizeAngle(result)
	end
	function maryo.SetSteepJumpAction()
		maryo.SteepJumpYaw = maryo.FaceAngle.Y
		if maryo.ForwardVel > 0 then
			local angleTemp = maryo.FloorAngle + math.pi
			local faceAngleTemp = maryo.FaceAngle.Y - angleTemp
			local y = math.sin(faceAngleTemp) * maryo.ForwardVel
			local x = math.cos(faceAngleTemp) * maryo.ForwardVel * 0.75
			maryo.ForwardVel = math.sqrt(y * y + x * x)
			maryo.SetFaceYaw(math.atan2(x, y) + angleTemp)
		end
		maryo.SetAction("STEEP_JUMP")
	end
	function maryo.SetYVelBasedOnFSpeed(inity, mult)
		maryo.SetUpwardVel(inity + maryo.ForwardVel * mult)
		if maryo.SquishTimer ~= 0 or maryo.QuicksandDepth > 1 then
			maryo.Velocity *= Vector3.new(1, 0.5, 1)
		end
	end
	function maryo.SetActionAirborne(action, arg)
		if maryo.SquishTimer ~= 0 or maryo.QuicksandDepth > 1 then
			if action.NAME == "DOUBLE_JUMP" or action.NAME == "TWIRLING" then
				action = maryo.Enums.Action.JUMP
			end
		end
		if action.NAME == "DOUBLE_JUMP" then
			maryo.SetYVelBasedOnFSpeed(52, 0.25)
			maryo.ForwardVel *= 0.8
		elseif action.NAME == "BACKFLIP" then
			maryo.AnimReset = true
			maryo.ForwardVel = -16
			maryo.SetYVelBasedOnFSpeed(62, 0)
		elseif action.NAME == "TRIPLE_JUMP" then
			maryo.SetYVelBasedOnFSpeed(69, 0)
			maryo.ForwardVel *= 0.8
		elseif action.NAME == "FLYING_TRIPLE_JUMP" then
			maryo.SetYVelBasedOnFSpeed(82, 0)
		elseif action.NAME == "WATER_JUMP" or action == "HOLD_WATER_JUMP" then
			if arg == 0 then
				maryo.SetYVelBasedOnFSpeed(42, 0)
			end
		elseif action.NAME == "BURNING_JUMP" then
			maryo.SetUpwardVel(31.5)
			maryo.ForwardVel = 8
		elseif action.NAME == "RIDING_SHELL_JUMP" then
			maryo.SetYVelBasedOnFSpeed(42, 0.25)
		elseif action.NAME == "JUMP" or action == "HOLD_JUMP" then
			maryo.AnimReset = true
			maryo.SetYVelBasedOnFSpeed(42, 0.25)
			maryo.ForwardVel *= 0.8
		elseif action.NAME == "WALL_KICK_AIR" or action == "TOP_OF_POLE_JUMP" then
			maryo.SetYVelBasedOnFSpeed(62, 0)
			if maryo.ForwardVel < 24 then
				maryo.ForwardVel = 24
			end
			maryo.WallKickTimer = 0
		elseif action.NAME == "SIDE_FLIP" then
			maryo.SetYVelBasedOnFSpeed(62, 0)
			maryo.ForwardVel = 8
			maryo.SetFaceYaw(maryo.IntendedYaw)
		elseif action.NAME == "STEEP_JUMP" then
			maryo.AnimReset = true
			maryoSetYVelBasedOnFSpeed(42, 0.25)
			maryo.FaceAngle = Vector3.new(-math.pi / 4, maryo.FaceAngle.Y, maryo.FaceAngle.Z)
		elseif action.NAME == "LAVA_BOOST" then
			maryo.SetUpwardVel(84)
			if arg == 0 then
				maryo.ForwardVel = 0
			end
		elseif action.NAME == "DIVE" then
			local forwardVel = maryo.ForwardVel + 15
			if forwardVel > 48 then
				forwardVel = 48
			end
			maryo.SetForwardVel(forwardVel)
		elseif action.NAME == "LONG_JUMP" then
			maryo.AnimReset = true
			maryo.SetYVelBasedOnFSpeed(30, 0)
			maryo.LongJumpIsSlow = maryo.ForwardVel <= 16
			maryo.ForwardVel *= 1.5
			if maryo.ForwardVel > 48 then
				maryo.ForwardVel = 48
			end
		elseif action.NAME == "SLIDE_KICK" then
			maryo.SetUpwardVel(12)
			if maryo.ForwardVel < 32 then
				maryo.ForwardVel = 32
			end
		elseif action.NAME == "JUMP_KICK" then
			maryo.SetUpwardVel(20)
		end
		maryo.PeakHeight = maryo.Position.Y
		maryo.Flags.MOVING_UP_IN_AIR = true
		return action
	end
	function maryo.SetActionMoving(action, arg)
		local forwardVel = maryo.ForwardVel
		local frick = maryo.GetFloorFriction()
		local mag = math.min(maryo.IntendedMag, 8)
		if action.NAME == "WALKING" then
			if frick ~= "WHOOPSIES" then
				if 0.0 <= forwardVel and forwardVel < mag then
					maryo.ForwardVel = mag
				end
			end
			maryo.WalkingPitch = 0
		elseif action.NAME == "HOLD_WALKING" then
			if 0.0 <= forwardVel and forwardVel < mag / 2 then
				maryo.ForwardVel = mag / 2
			end
		elseif action.NAME == "BEGIN_SLIDING" then
			if maryo.FacingDownhill() then
				action = maryo.Enums.Action.BUTT_SLIDE
			else
				action = maryo.Enums.Action.STOMACH_SLIDE
			end
		elseif action.NAME == "HOLD_BEGIN_SLIDING" then
			if maryo.FacingDownhill() then
				action = maryo.Enums.Action.HOLD_BUTT_SLIDE
			else
				action = maryo.Enums.Action.HOLD_STOMACH_SLIDE
			end
		end
		return action
	end
	function maryo.SetActionSubmerged(action, arg)
		if action.NAME == "METAL_WATER_JUMP" or action.NAME == "HOLD_METAL_WATER_JUMP" then
			maryo.SetUpwardVel(32)
		end
		return action
	end
	function maryo.SetActionCutscene(action, arg)
		if action.NAME == "EMERGE_FROM_PIPE" then
			maryo.SetUpwardVel(52)
		elseif action.NAME == "FALL_AFTER_STAR_GRAB" then
			maryo.SetForwardVel(0)
		elseif action.NAME == "SPAWN_SPIN_AIRBORNE" then
			maryo.SetForwardVel(2)
		elseif action.NAME == "SPECIAL_EXIT_AIRBORNE" or action.NAME == "SPECIAL_DEATH_EXIT" then
			maryo.SetUpwardVel(64)
		end
		return action
	end
	function maryo.SetAction(action, arg)
		action = maryo.Enums.Action[action] or action or nil
		arg = arg or 0
		if action then
			if action.GROUP == "MOVING" then
				action = maryo.SetActionMoving(action, arg)
			elseif action.GROUP == "AIRBORNE" then
				action = maryo.SetActionAirborne(action, arg)
			elseif action.GROUP == "SUBMERGED" then
				action = maryo.SetActionSubmerged(action, arg)
			elseif action.GROUP == "CUTSCENE" then
				action = maryo.SetActionCutscene(action, arg)
			end
			maryo.Flags.ACTION_SOUND_PLAYED = false
			maryo.Flags.MARIO_SOUND_PLAYED = false
			if not maryo.Action.AIR then
				maryo.Flags.FALLING_FAR = false
			end
		end
		maryo.PrevAction = maryo.Action
		maryo.Action = action
		maryo.ActionArg = arg or 0
		maryo.ActionState = 0
		maryo.ActionTimer = 0
		return true
	end
	function maryo.SetJumpFromLanding()
		if maryo.FloorIsSteep() then
			maryo.SetSteepJumpAction()
		elseif maryo.DoubleJumpTimer == 0 or maryo.SquishTimer ~= 0 then
			maryo.SetAction("JUMP")
		else
			local prev = maryo.PrevAction or {}
			if prev.NAME == "JUMP_LAND" then
				maryo.SetAction("DOUBLE_JUMP")
			elseif prev.NAME == "FREEFALL_LAND" then
				maryo.SetAction("DOUBLE_JUMP")
			elseif prev.NAME == "SIDE_FLIP_LAND_STOP" then
				maryo.SetAction("DOUBLE_JUMP")
			elseif prev.NAME == "DOUBLE_JUMP_LAND" then
				if maryo.Flags.WING_CAP then
					maryo.SetAction("FLYING_TRIPLE_JUMP")
				elseif maryo.ForwardVel > 20 then
					maryo.SetAction("TRIPLE_JUMP")
				else
					maryo.SetAction("JUMP")
				end
			else
				maryo.SetAction("JUMP")
			end
		end
		maryo.DoubleJumpTimer = 0
		return true
	end
	function maryo.SetJumpingAction(action, arg)
		if maryo.FloorIsSteep() then
			maryo.SetSteepJumpAction()
		else
			maryo.SetAction(action, arg)
		end
		return true
	end
	function maryo.HurtAndSetAction(action, arg, damage)
		maryo.HealthSub = damage
		maryo.SetAction(action, arg)
	end
	function maryo.CheckCommonActionExits()
		if maryo.Input.A_PRESSED then
			maryo.SetAction("JUMP")
			return true
		end
		if maryo.Input.OFF_FLOOR then
			maryo.SetAction("FREEFALL")
			return true
		end
		if maryo.Input.NONZERO_ANALOG then
			maryo.SetAction("WALKING")
			return true
		end
		if maryo.Input.ABOVE_SLIDE then
			maryo.SetAction("BEGIN_SLIDING")
			return true
		end
		return false
	end
	function maryo.UpdatePunchSequence()
		local endAction, crouchEndAction
		if maryo.Action.MOVING then
			endAction = Action.WALKING
			crouchEndAction = Action.CROUCH_SLIDE
		else
			endAction = Action.IDLE
			crouchEndAction = Action.CROUCHING
		end
		local arg = maryo.ActionArg
		if arg == 0 or arg == 1 then
			if arg == 0 then
				maryo.PlaySound("MARIO_PUNCH_YAH")
			end
			maryo.SetAnimation("FIRST_PUNCH")
			maryo.ActionArg = maryo.IsAnimAtEnd() and 2 or 1
			if maryo.AnimFrame >= 2 then
				maryo.Flags.PUNCHING = true
			end
		elseif arg == 2 then
			maryo.SetAnimation("FIRST_PUNCH_FAST")
			if maryo.AnimFrame <= 0 then
				maryo.Flags.PUNCHING = true
			end
			if maryo.Input.B_PRESSED then
				maryo.ActionArg = 3
			end
			if maryo.IsAnimAtEnd() then
				maryo.SetAction(endAction)
			end
		elseif arg == 3 or arg == 4 then
			if arg == 3 then
				maryo.PlaySound("MARIO_PUNCH_WAH")
			end
			maryo.SetAnimation("SECOND_PUNCH")
			maryo.ActionArg = maryo.IsAnimPastEnd() and 5 or 4
			if maryo.AnimFrame > 0 then
				maryo.Flags.PUNCHING = true
			end
		elseif arg == 5 then
			maryo.SetAnimation("SECOND_PUNCH_FAST")
			if maryo.AnimFrame <= 0 then
				maryo.Flags.PUNCHING = true
			end
			if maryo.Input.B_PRESSED then
				maryo.ActionArg = 6
			end
			if maryo.IsAnimAtEnd() then
				maryo.SetAction(endAction)
			end
		elseif arg == 6 then
			maryo.PlayActionSound("MARIO_PUNCH_HOO", 1)
			local animFrame = maryo.SetAnimation("GROUND_KICK")
			if animFrame >= 0 and animFrame < 8 then
				maryo.Flags.KICKING = true
			end
			if maryo.IsAnimAtEnd() then
				maryo.SetAction(endAction)
			end
		elseif arg == 9 then
			maryo.PlayActionSound("MARIO_PUNCH_HOO", 1)
			maryo.SetAnimation("BREAKDANCE")
			local animFrame = maryo.AnimFrame
			if animFrame >= 2 and animFrame < 8 then
				maryo.Flags.TRIPPING = true
			end
			if maryo.IsAnimAtEnd() then
				maryo.SetAction(crouchEndAction)
			end
		end
		return false
	end
	function maryo.BonkReflection(negateSpeed)
		local wall = maryo.Wall
		if wall ~= nil then
			local wallAngle = math.atan2(wall.Normal.Z, wall.Normal.X)
			maryo.SetFaceYaw(wallAngle - (maryo.FaceAngle.Y - wallAngle))
			maryo.PlaySound(if maryo.Flags.METAL_CAP then "ACTION_METAL_BONK" else "ACTION_BONK")
		else
			maryo.PlaySound("ACTION_HIT")
		end
		if negateSpeed then
			maryo.SetForwardVel(-maryo.ForwardVel)
		else
			maryo.SetFaceYaw(maryo.FaceAngle.Y + math.pi)
		end
	end
	function maryo.PushOffSteepFloor(action, arg)
		local floorDYaw = maryo.NormalizeAngle(maryo.FloorAngle - maryo.FaceAngle.Y)
		if floorDYaw > -math.pi / 4 and floorDYaw < math.pi / 4 then
			maryo.ForwardVel = 16
			maryo.SetFaceYaw(maryo.FloorAngle)
		else
			maryo.ForwardVel = -16
			maryo.SetFaceYaw(maryo.FloorAngle + math.pi)
		end
		maryo.SetAction(action, arg)
	end
	function maryo.StopAndSetHeightToFloor()
		maryo.SetForwardVel(0)
		maryo.Velocity *= Vector3.new(1, 0, 1)
		maryo.SetHeight(maryo.FloorHeight)
	end
	function maryo.StationaryGroundStep()
		maryo.SetForwardVel(0)
		return maryo.PerformGroundStep()
	end
	function maryo.PerformGroundQuarterStep(nextPos)
		local lowerPos, _ = maryo.FindWallCollisions(nextPos, 1.5, 1.2)
		nextPos = lowerPos
		local upperPos, upperWall = maryo.FindWallCollisions(nextPos, 3, 2.5)
		nextPos = upperPos
		local floorHeight, f = maryo.FindFloor(nextPos)
		local ceilHeight, _ = maryo.FindCeiling(nextPos, floorHeight)
		maryo.Wall = upperWall
		if f == nil then
			return "HIT_WALL_STOP_QSTEPS"
		end
		if nextPos.Y > floorHeight + 5 then
			if nextPos.Y + 8 >= ceilHeight then
				return "HIT_WALL_STOP_QSTEPS"
			end
			maryo.Floor = f
			maryo.FloorHeight = floorHeight
			return "LEFT_GROUND"
		end
		if floorHeight + 8 >= ceilHeight then
			return "HIT_WALL_STOP_QSTEPS"
		end
		maryo.Floor = f
		maryo.FloorHeight = floorHeight
		maryo.Position = Vector3.new(nextPos.X, floorHeight, nextPos.Z)
		if upperWall then
			local wallDYaw = math.abs(maryo.NormalizeAngle(math.atan2(upperWall.Normal.Z, upperWall.Normal.X) - maryo.FaceAngle.Y))
			if wallDYaw >= math.pi / 6 and wallDYaw <= math.pi / 3 then
				return "NONE"
			end
			return "HIT_WALL_CONTINUE_QSTEPS"
		end
		return "NONE"
	end
	function maryo.PerformGroundStep()
		local f = maryo.Floor
		if not f then
			return "NONE"
		end
		local stepResult = "NONE"
		for i = 1, 4 do
			local intendedX = maryo.Position.X + f.Normal.Y * (maryo.Velocity.X / 80)
			local intendedZ = maryo.Position.Z + f.Normal.Y * (maryo.Velocity.Z / 80)
			local intendedY = maryo.Position.Y
			local intendedPos = Vector3.new(intendedX, intendedY, intendedZ)
			stepResult = maryo.PerformGroundQuarterStep(intendedPos)
			if stepResult == "LEFT_GROUND" or stepResult == "HIT_WALL_STOP_QSTEPS" then
				break
			end
		end
		maryo.TerrainType = maryo.GetTerrainType()
		if stepResult == "HIT_WALL_CONTINUE_QSTEPS" then
			stepResult = "HIT_WALL"
		end
		return stepResult
	end
	function maryo.CheckLedgeGrab(wall, intendedPos, nextPos)
		if maryo.Velocity.Y > 0 then
			return false
		end
		local dispX = nextPos.X - intendedPos.X
		local dispZ = nextPos.Z - intendedPos.Z
		if dispX * maryo.Velocity.X + dispZ * maryo.Velocity.Z > 0 then
			return false
		end
		local ledgeX = nextPos.X - (wall.Normal.X * 3)
		local ledgeZ = nextPos.Z - (wall.Normal.Z * 3)
		local ledgePos = Vector3.new(ledgeX, nextPos.Y + 8, ledgeZ)
		local ledgeY, ledgeFloor = maryo.FindFloor(ledgePos)
		if ledgeY - nextPos.Y < 5 then
			return false
		end
		if ledgeFloor then
			ledgePos = ledgeFloor.Position
			maryo.Position = ledgePos
			maryo.Floor = ledgeFloor
			maryo.FloorHeight = ledgeY
			maryo.FloorAngle = maryo.NormalizeAngle(math.atan2(ledgeFloor.Normal.Z, ledgeFloor.Normal.X))
			maryo.FaceAngle *= Vector3.new(0, 1, 1)
			maryo.SetFaceYaw(math.atan2(wall.Normal.Z, wall.Normal.X) + math.pi)
			return true
		end
		return false
	end
	function maryo.PerformAirQuarterStep(intendedPos, checkLedge)
		local nextPos = intendedPos
		local upperPos, upperWall = maryo.FindWallCollisions(nextPos, 7.5, 2.5)
		nextPos = upperPos
		local lowerPos, lowerWall = maryo.FindWallCollisions(nextPos, 1.5, 2.5)
		nextPos = lowerPos
		local floorHeight, f = maryo.FindFloor(nextPos)
		local ceilHeight = maryo.FindCeiling(nextPos, floorHeight)
		maryo.Wall = nil
		if not f then
			if nextPos.Y <= maryo.FloorHeight then
				maryo.SetHeight(maryo.FloorHeight)
				return "LANDED"
			end
			maryo.SetHeight(nextPos.Y)
			return "HIT_WALL"
		end
		if nextPos.Y <= floorHeight then
			if ceilHeight - floorHeight > 8 then
				maryo.Floor = f
				maryo.FloorHeight = floorHeight
				maryo.Position = Vector3.new(nextPos.X, maryo.Position.Y, nextPos.Z)
			end
			maryo.SetHeight(floorHeight)
			return "LANDED"
		end
		if nextPos.Y + 8 > ceilHeight then
			if maryo.Velocity.Y > 0 then
				maryo.SetUpwardVel(0)
				return "NONE"
			end
			if nextPos.Y <= maryo.FloorHeight then
				maryo.SetHeight(floorHeight)
				return "LANDED"
			end
			maryo.SetHeight(nextPos.Y)
			return "HIT_WALL"
		end
		if checkLedge and upperWall == nil and lowerWall ~= nil then
			if maryo.CheckLedgeGrab(lowerWall, intendedPos, nextPos) then
				return "GRABBED_LEDGE"
			end
			maryo.Floor = f
			maryo.Position = nextPos
			maryo.FloorHeight = floorHeight
			return "NONE"
		end
		maryo.Floor = f
		maryo.Position = nextPos
		maryo.FloorHeight = floorHeight
		if upperWall or lowerWall then
			local wall = upperWall or lowerWall
			local wallDYaw = math.abs(maryo.NormalizeAngle(math.atan2(wall.Normal.Z, wall.Normal.X) - maryo.FaceAngle.Y))
			maryo.Wall = wall
			if wallDYaw > math.pi * 0.375 then
				return "HIT_WALL"
			end
		end
		return "NONE"
	end
	function maryo.ApplyTwirlGravity()
		local heaviness = 1
		if maryo.AngleVel.Y > 1024 then
			heaviness = 1024 / maryo.AngleVel.Y
		end
		local terminalVelocity = -75 * heaviness
		maryo.Velocity -= Vector3.new(0, 4 * heaviness, 0)
		if maryo.Velocity.Y < terminalVelocity then
			maryo.SetUpwardVel(terminalVelocity)
		end
	end
	function maryo.ShouldStrengthenGravityForJumpAscent()
		if not maryo.Flags.MOVING_UP_IN_AIR then
			return false
		end
		if maryo.Action.INTANGIBLE or maryo.Action.INVULNERABLE then
			return false
		end
		if not maryo.Input.A_DOWN and maryo.Velocity.Y > 20 then
			return maryo.Action.CONTROL_JUMP_HEIGHT
		end
		return false
	end
	function maryo.ApplyGravity()
		local action = maryo.Action
		if action.NAME == "TWIRLING" and maryo.Velocity.Y < 0 then
			maryo.ApplyTwirlGravity()
		elseif action.NAME == "SHOT_FROM_CANNON" then
			maryo.Velocity -= Vector3.yAxis
			if maryo.Velocity.Y < -75 then
				maryo.SetUpwardVel(-75)
			end
		elseif action.NAME == "LONG_JUMP" or action.NAME == "SLIDE_KICK" or action.NAME == "BBH_ENTER_SPIN" then
			maryo.Velocity -= Vector3.yAxis * 2
			if maryo.Velocity.Y < -75 then
				maryo.SetUpwardVel(-75)
			end
		elseif action.NAME == "LAVA_BOOST" or action.NAME == "FALL_AFTER_STAR_GRAB" then
			maryo.Velocity -= Vector3.yAxis * 3.2
			if maryo.Velocity.Y < -65 then
				maryo.SetUpwardVel(-65)
			end
		elseif maryo.ShouldStrengthenGravityForJumpAscent() then
			maryo.Velocity *= Vector3.new(1, 0.25, 1)
		elseif maryo.Action.METAL_WATER then
			maryo.Velocity -= Vector3.yAxis * 1.6
			if maryo.Velocity.Y < -16 then
				maryo.SetUpwardVel(-16)
			end
		elseif maryo.Flags.WING_CAP and maryo.Velocity.Y < 0 and maryo.Input.A_DOWN then
			maryo.Velocity -= Vector3.yAxis * 2
			if maryo.Velocity.Y < -37.5 then
				maryo.Velocity += Vector3.yAxis * 4
				if maryo.Velocity.Y > -37.5 then
					maryo.SetUpwardVel(-37.5)
				end
			end
		else
			maryo.Velocity -= Vector3.yAxis * 4
			if maryo.Velocity.Y < -75 then
				maryo.SetUpwardVel(-75)
			end
		end
	end
	function maryo.PerformAirStep(checkLedge)
		local stepResult = "NONE"
		maryo.Wall = nil
		for i = 1, 4 do
			local intendedPos = maryo.Position + (maryo.Velocity / 80)
			local result = maryo.PerformAirQuarterStep(intendedPos, checkLedge)
			if result ~= "NONE" then
				stepResult = result
			end
			if result == "LANDED" or result == "GRABBED_LEDGE" or result == "GRABBED_CEILING" or result == "HIT_LAVA_WALL" then
				break
			end
		end
		if maryo.Velocity.Y >= 0 then
			maryo.PeakHeight = maryo.Position.Y
		end
		maryo.TerrainType = maryo.GetTerrainType()
		if maryo.Action.NAME ~= "FLYING" then
			maryo.ApplyGravity()
		end
		return stepResult
	end
	function maryo.UpdateInputs()
		local controller = maryo.Controller
		maryo.Input = {}
		if controller.A then
			if not maryo._ButtonStates.A then
				maryo.Input.A_PRESSED = true
			end
			maryo.Input.A_DOWN = true
		end
		maryo._ButtonStates.A = controller.A
		if maryo.SquishTimer == 0 then
			if controller.B then
				if not maryo._ButtonStates.B then
					maryo.Input.B_PRESSED = true
				end
				maryo.Input.B_DOWN = true
			end
			maryo._ButtonStates.B = controller.B
			if controller.Z then
				if not maryo._ButtonStates.Z then
					maryo.Input.Z_PRESSED = true
				end
				maryo.Input.Z_DOWN = true
			end
			maryo._ButtonStates.Z = controller.Z
		end
		if maryo.AutoJump and maryo.Input.A_DOWN then
			maryo.Input.A_PRESSED = true
		end
		if maryo.Input.A_PRESSED then
			maryo.FramesSinceA = 0
		elseif maryo.FramesSinceA < 255 then
			maryo.FramesSinceA += 1
		end
		if maryo.Input.B_PRESSED then
			maryo.FramesSinceB = 0
		elseif maryo.FramesSinceB < 255 then
			maryo.FramesSinceB += 1
		end
		local dir = Vector3.new(controller.StickX, 0, controller.StickZ)
		local mag = math.pow(dir.Magnitude, 2)
		if maryo.SquishTimer == 0 then
			maryo.IntendedMag = mag / 2
		else
			maryo.IntendedMag = mag / 8
		end
		if maryo.IntendedMag > 0 then
			maryo.IntendedYaw = maryo.NormalizeAngle(math.atan2(dir.Z, dir.X))
			maryo.Input.NONZERO_ANALOG = true
		else
			maryo.IntendedYaw = maryo.FaceAngle.Y
		end
		local floorHeight, f = maryo.FindFloor(maryo.Position)
		local ceilHeight, c = maryo.FindCeiling(maryo.Position, maryo.FloorHeight)
		maryo.FloorHeight = floorHeight
		maryo.CeilHeight = ceilHeight
		maryo.Floor = f
		maryo.Ceil = c
		if f then
			maryo.FloorAngle = math.atan2(f.Normal.Z, f.Normal.X)
			maryo.TerrainType = maryo.GetTerrainType()
			if maryo.FloorIsSlippery() then
				maryo.Input.ABOVE_SLIDE = true
			end
			if c then
				local squishCheck = maryo.CeilHeight - maryo.FloorHeight
				if squishCheck > 0 and squishCheck < 7.5 then
					maryo.Input.SQUISHED = true
				end
			end
			if maryo.Position.Y > maryo.FloorHeight + 5 then
				maryo.Input.OFF_FLOOR = true
			end
			if maryo.Position.Y < maryo.WaterLevel - 0.5 then
				maryo.Input.IN_WATER = true
			end
		end
		if not maryo.Input.NONZERO_ANALOG and not maryo.Input.A_PRESSED then
			maryo.Input.NO_MOVEMENT = true
		end
		if maryo.WallKickTimer > 0 then
			maryo.WallKickTimer -= 1
		end
		if maryo.DoubleJumpTimer > 0 then
			maryo.DoubleJumpTimer -= 1
		end
		if maryo.Input.NONZERO_ANALOG or maryo.Input.A_PRESSED or maryo.Input.OFF_FLOOR or maryo.Input.ABOVE_SLIDE or maryo.Input.FIRST_PERSON or maryo.Input.STOMPED or maryo.Input.B_PRESSED or maryo.Input.Z_PRESSED then
			maryo.Input.DISTURBED = true
		end
		if maryo.Events.STOMPED then
			maryo.Events.STOMPED = false
			maryo.Input.STOMPED = true
		end
	end
	function maryo.CheckKickOrPunchWall()
		if maryo.Flags.PUNCHING or maryo.Flags.KICKING or maryo.Flags.TRIPPING then
			local range = Vector3.new(math.sin(maryo.FaceAngle.Y), 0, math.cos(maryo.FaceAngle.Y))
			local detector = maryo.Position + range * 2.5
			local _disp, wall = maryo.FindWallCollisions(detector, 80, 5)
			if wall then
				local action = maryo.Action
				if action.NAME ~= "MOVE_PUNCHING" or maryo.ForwardVel >= 0 then
					if action == "PUNCHING" then
						maryo.Action = maryo.Enums.Action.MOVE_PUNCHING
					end
					maryo.SetForwardVel(-48)
					maryo.PlaySound("ACTION_HIT")
				elseif action.AIR then
					maryo.SetForwardVel(-16)
					maryo.PlaySound("ACTION_HIT")
				end
			end
		end
	end
	function maryo.SetWaterPlungeAction()
		maryo.ForwardVel /= 4
		maryo.Velocity *= Vector3.new(1, 0.5, 1)
		maryo.Position = Vector3.new(maryo.Position.X, maryo.WaterLevel - 5, maryo.Position.Z)
		maryo.FaceAngle *= Vector3int16.new(1, 1, 0)
		maryo.AngleVel *= 0
		if not maryo.Action.DIVING then
			maryo.FaceAngle *= Vector3int16.new(0, 1, 1)
		end
		maryo.SetAction("WATER_PLUNGE")
	end
	function maryo.PlayFarFallSound()
		if maryo.Flags.FALLING_FAR then
			return
		end
		local action = maryo.Action
		if action.NAME == "TWIRLING" then
			return
		end
		if action.NAME == "FLYING" then
			return
		end
		if action.INVULNERABLE then
			return
		end
		if maryo.PeakHeight - maryo.Position.Y > 57.5 then
			maryo.PlaySound("MARIO_WAAAOOOW")
			maryo.Flags.FALLING_FAR = true
		end
	end
	function maryo.Step()
		if not maryo.Action then
			return
		end
		maryo.Sounds = {}
		maryo.AnimFrame = (maryo.AnimFrame + 1) % (maryo.AnimFrameCount + 1)
		if maryo.AnimAccel > 0 then
			maryo.AnimAccelAssist += maryo.AnimAccel
			maryo.AnimAccelAssist %= (maryo.AnimFrameCount + 1) * 65536
		end
		if maryo.SquishTimer > 0 then
			maryo.SquishTimer -= 1
		end
		maryo.AnimDirty = true
		maryo.AnimSkipInterp = math.max(0, maryo.AnimSkipInterp - 1)
		maryo.UpdateInputs()
		if maryo.Floor and not (maryo.Action.AIR or maryo.Action.SWIMMING) then
			if maryo.Floor.Material == Enum.Material.CrackedLava then
				if not maryo.Flags.METAL_CAP then
					maryo.HurtCounter += maryo.Flags.CAP_ON_HEAD and 12 or 18
				end
				maryo.SetAction("LAVA_BOOST")
			end
		end
		if maryo.InvincTimer > 0 then
			maryo.InvincTimer -= 1
		end
		maryo.CheckKickOrPunchWall()
		maryo.Flags.PUNCHING = false
		maryo.Flags.KICKING = false
		maryo.Flags.TRIPPING = false
		if not maryo.Floor then
			return
		end
		while maryo.Action do
			local id = maryo.Action
			local action = maryo.Actions[id.NAME]
			if action then
				local group = id.GROUP
				local cancel = false
				if group ~= "SUBMERGED" and maryo.Position.Y < maryo.WaterLevel - 5 then
					maryo.SetWaterPlungeAction()
					cancel = true
				else
					if group == "AIRBORNE" then
						maryo.PlayFarFallSound()
					elseif group == "SUBMERGED" then
						if maryo.Position.Y > maryo.WaterLevel - 4 then
							if maryo.WaterLevel - 4 > maryo.FloorHeight then
								maryo.SetHeight(maryo.WaterLevel - 4)
							else
								maryo.AngleVel = 0
								maryo.SetAction("WALKING")
								cancel = true
							end
						end
						maryo.QuicksandDepth = 0
					end
					if not cancel then
						cancel = action()
					end
				end
				if not cancel then
					break
				end
			else
				warn("uh oh stinky")
				maryo.Action = maryo.Enums.Action.IDLE
				break
			end
		end
	end
	local DEF_ACTION = function(name, func)
		maryo.Actions[name] = func
	end
	do -- STATIONARY
		local function checkStompEvent()
			if maryo.Input.STOMPED then
				return maryo.SetAction("SHOCKWAVE_BOUNCE")
			end
			return false
		end
		local function checkCommonIdleCancels()
			local f = maryo.Floor
			if f and f.Normal.Y < 0.29237169 then
				maryo.PushOffSteepFloor("FREEFALL", 0)
				return true
			end
			if maryo.Input.STOMPED then
				maryo.SetAction(SHOCKWAVE_BOUNCE)
				return true
			end
			if maryo.Input.A_PRESSED then
				maryo.SetJumpingAction("JUMP", 0)
				return true
			end
			if maryo.Input.OFF_FLOOR then
				maryo.SetAction("FREEFALL")
				return true
			end
			if maryo.Input.ABOVE_SLIDE then
				maryo.SetAction("BEGIN_SLIDING")
				return true
			end
			if maryo.Input.NONZERO_ANALOG) then
				maryo.SetFaceYaw(maryo.IntendedYaw)
				maryo.SetAction("WALKING")
				return true
			end
			if maryo.Input.B_PRESSED then
				maryo.SetAction("PUNCHING")
				return true
			end
			if maryo.Input.Z_DOWN then
				maryo.SetAction("START_CROUCHING")
				return true
			end
			return false
		end
		local function playAnimSound(actionState, animFrame, sound)
			if maryo.ActionState == actionState and maryo.AnimFrame == animFrame then
				maryo.PlaySound(sound)
			end
		end
		local function stoppingStep(anim, action)
			maryo.StationaryGroundStep()
			maryo.SetAnimation(anim)
			if maryo.IsAnimPastEnd() then
				maryo.SetAction(action)
			end
		end
		local function landingStep(anim, action)
			stoppingStep(anim, action)
		end
		local function checkCommonLandingCancels(action)
			if maryo.Input.A_PRESSED then
				if not action then
					maryo.SetJumpFromLanding()
				else
					maryo.SetJumpingAction(action, 0)
				end
			end
			if maryo.Input.NONZERO_ANALOG or maryo.Input.A_PRESSED or maryo.Input.OFF_FLOOR or maryo.Input.ABOVE_SLIDE) then
				return maryo.CheckCommonActionExits()
			end
			if maryo.Input.B_PRESSED then
				maryo.SetAction("PUNCHING")
				return true
			end
			return false
		end
		DEF_ACTION("IDLE", function()
			if checkStompEvent() then return true end
			if not bit32.btest(maryo.ActionArg, 1) and maryo.Health < 3 then
				return maryo.SetAction("PANTING")
			end
			if checkCommonIdleCancels() then return true end
			if maryo.ActionState == 3 then
				return maryo.SetAction("START_SLEEPING")
			end
			if bit32.btest(maryo.ActionArg, 1) then
				maryo.SetAnimation("STAND_AGAINST_WALL")
			else
				if maryo.ActionState == 0 then
					maryo.SetAnimation("IDLE_HEAD_LEFT")
				elseif maryo.ActionState == 1 then
					maryo.SetAnimation("IDLE_HEAD_RIGHT")
				elseif maryo.ActionState == 2 then
					maryo.SetAnimation("IDLE_HEAD_CENTER")
				end
				if maryo.IsAnimAtEnd() then
					maryo.ActionState += 1
					if maryo.ActionState == 3 then
						local deltaYOfFloorBehindMario = maryo.Position.Y - maryo.FindFloorHeightRelativePolar(math.pi, 3)
						if math.abs(deltaYOfFloorBehindMario) > 1.2 then
							maryo.ActionState = 0
						else
							maryo.ActionTimer += 1
							if maryo.ActionTimer < 10 then
								maryo.ActionState = 0
							end
						end
					end
				end
			end
			maryo.StationaryGroundStep()
			return false
		end)
		DEF_ACTION("START_SLEEPING", function()
			local animFrame = -1
			if checkCommonIdleCancels() then return true end
			if maryo.ActionState == 4 then
				maryo.SetAction("SLEEPING")
				return true
			end
			if maryo.ActionState == 0 then
				animFrame = maryo.SetAnimation("START_SLEEP_IDLE")
			elseif maryo.ActionState == 1 then
				animFrame = maryo.SetAnimation("START_SLEEP_SCRATCH")
			elseif maryo.ActionState == 2 then
				animFrame = maryo.SetAnimation("START_SLEEP_YAWN")
			elseif maryo.ActionState == 3 then
				animFrame = maryo.SetAnimation("START_SLEEP_SITTING")
			end
			playAnimSound(1, 41, "ACTION_PAT_BACK")
			playAnimSound(1, 49, "ACTION_PAT_BACK")
			if maryo.IsAnimAtEnd() then
				maryo.ActionState += 1
			end
			if maryo.ActionState == 2 and animFrame == 0 then
				maryo.PlaySound("MARIO_YAWNING")
			end
			if maryo.ActionState == 1 and animFrame == 0 then
				maryo.PlaySound("MARIO_IMA_TIRED")
			end
			maryo.StationaryGroundStep()
			return false
		end)
		DEF_ACTION("SLEEPING", function()
			if maryo.Input.DISTURBED then
				return maryo.SetAction("WAKING_UP", maryo.ActionState)
			end
			if maryo.Position.Y - maryo.FindFloorHeightRelativePolar(math.pi, 3) > 1.2 then
				return maryo.SetAction("WAKING_UP", maryo.ActionState)
			end
			maryo.StationaryGroundStep()
			if maryo.ActionState == 0 then
				local animFrame = maryo.SetAnimation("SLEEP_IDLE")
				if animFrame == 2 then
					maryo.PlaySound("MARIO_SNORING1")
				end
				if animFrame == 20 then
					maryo.PlaySound("MARIO_SNORING2")
				end
				if maryo.IsAnimAtEnd() then
					maryo.ActionTimer += 1
					if maryo.ActionTimer > 45 then
						maryo.ActionState += 1
					end
				end
			elseif maryo.ActionState == 1 then
				if maryo.SetAnimation("SLEEP_START_LYING") == 18 then
					maryo.PlayHeavyLandingSound("ACTION_TERRAIN_BODY_HIT_GROUND")
				end
				if maryo.IsAnimAtEnd() then
					maryo.ActionState += 1
				end
			elseif maryo.ActionState == 2 then
				maryo.SetAnimation("SLEEP_LYING")
				maryo.PlaySoundIfNoFlag("MARIO_SNORING3", "ACTION_SOUND_PLAYED")
			end
			return false
		end)
		DEF_ACTION("WAKING_UP", function()
			if checkStompEvent() then return true end
			if maryo.Input.OFF_FLOOR then
				maryo.SetAction("FREEFALL")
				return true
			end
			if maryo.Input.ABOVE_SLIDE then
				maryo.SetAction("BEGIN_SLIDING")
				return true
			end
			maryo.ActionTimer += 1
			if maryo.ActionTimer > 20 then
				maryo.SetAction("IDLE")
				return true
			end
			maryo.StationaryGroundStep()
			maryo.SetAnimation(if maryo.ActionArg == 0 then "WAKE_FROM_SLEEP" else "WAKE_FROM_LYING")
			return false
		end)
		DEF_ACTION("STANDING_AGAINST_WALL", function(m: Mario)
			if maryo.Input.STOMPED then
				maryo.SetAction("SHOCKWAVE_BOUNCE")
				return true
			end
			if maryo.Input.NONZERO_ANALOG or maryo.Input.A_PRESSED or maryo.Input.OFF_FLOOR or maryo.Input.ABOVE_SLIDE then
				return maryo.CheckCommonActionExits()
			end
			if maryo.Input.B_PRESSED then
				maryo.SetAction(Action.PUNCHING)
				return true
			end
			maryo.SetAnimation("A_POSE")
			maryo.StationaryGroundStep()
			return false
		end)
		DEF_ACTION("CROUCHING", function()
			if maryo.Input.STOMPED then
				maryo.SetAction("SHOCKWAVE_BOUNCE")
				return true
			end
			if maryo.Input.A_PRESSED then
				maryo.SetAction("BACKFLIP")
				return true
			end
			if maryo.Input.OFF_FLOOR then
				maryo.SetAction("FREEFALL")
				return true
			end
			if maryo.Input.ABOVE_SLIDE then
				maryo.SetAction("BEGIN_SLIDING")
				return true
			end
			if not maryo.Input.Z_DOWN then
				maryo.SetAction("STOP_CROUCHING")
				return true
			end
			if maryo.Input.NONZERO_ANALOG then
				maryo.SetAction("START_CRAWLING")
				return true
			end
			if maryo.Input.B_PRESSED then
				maryo.SetAction("PUNCHING", 9)
				return true
			end
			maryo.StationaryGroundStep()
			maryo.SetAnimation("CROUCHING")
			return false
		end)
		DEF_ACTION("PANTING", function()
			if maryo.Input.STOMPED then
				maryo.SetAction("SHOCKWAVE_BOUNCE")
				return true
			end
			if maryo.Health >= 5 then
				maryo.SetAction(Action.IDLE)
				return
			end
			if checkCommonIdleCancels() then
				return true
			end
			if maryo.SetAnimation("PANTING") == 1 then
				maryo.PlaySound("MARIO_PANTING")
			end
			maryo.StationaryGroundStep()
			return false
		end)
		DEF_ACTION("BRAKING_STOP", function()
			if maryo.Input.STOMPED then
				maryo.SetAction("SHOCKWAVE_BOUNCE")
				return true
			end
			if maryo.Input.OFF_FLOOR then
				maryo.SetAction("FREEFALL")
				return true
			end
			if maryo.Input.B_PRESSED then
				maryo.SetAction("PUNCHING")
				return true
			end
			if maryo.Input.NONZERO_ANALOG or maryo.Input.A_PRESSED or maryo.Input.OFF_FLOOR or maryo.Input.ABOVE_SLIDE then
				return maryo.CheckCommonActionExits()
			end
			stoppingStep("STOP_SKID", "IDLE")
			return false
		end)
		DEF_ACTION("BUTT_SLIDE_STOP", function()
			if maryo.Input.STOMPED then
				maryo.SetAction("SHOCKWAVE_BOUNCE")
				return true
			end
			if maryo.Input.NONZERO_ANALOG or maryo.Input.A_PRESSED or maryo.Input.OFF_FLOOR or maryo.Input.ABOVE_SLIDE then
				return maryo.CheckCommonActionExits()
			end
			stoppingStep("STOP_SLIDE", "IDLE")
			if maryo.AnimFrame == 6 then
				maryo.PlayLandingSound()
			end
			return false
		end)
		DEF_ACTION("SLIDE_KICK_SLIDE_STOP", function()
			if maryo.Input.STOMPED then
				maryo.SetAction("SHOCKWAVE_BOUNCE")
				return true
			end
			if maryo.Input.OFF_FLOOR then
				maryo.SetAction("FREEFALL")
				return true
			end
			stoppingStep("CROUCH_FROM_SLIDE_KICK", "CROUCHING")
			return false
		end)
		DEF_ACTION("START_CROUCHING", function()
			if maryo.CheckCommonActionExits() then
				return true
			end
			maryo.StationaryGroundStep()
			maryo.SetAnimation("START_CROUCHING")
			if maryo.IsAnimPastEnd() then
				maryo.SetAction("CROUCHING")
			end
			return false
		end)
		DEF_ACTION("STOP_CROUCHING", function()
			if maryo.CheckCommonActionExits() then
				return true
			end
			maryo.StationaryGroundStep()
			maryo.SetAnimation("START_CROUCHING")
			if maryo.IsAnimPastEnd() then
				maryo.SetAction("IDLE")
			end
			return false
		end)
		DEF_ACTION("START_CRAWLING", function()
			if maryo.Input:Has(InputFlags.OFF_FLOOR) then
				return maryo.SetAction(Action.FREEFALL)
			end
		
			if maryo.Input:Has(InputFlags.STOMPED) then
				return maryo.SetAction(Action.SHOCKWAVE_BOUNCE)
			end
		
			if maryo.Input:Has(InputFlags.ABOVE_SLIDE) then
				return maryo.SetAction(Action.BEGIN_SLIDING)
			end
		
			maryo.StationaryGroundStep()
			maryo.SetAnimation(Animations.START_CRAWLING)
		
			if maryo.IsAnimPastEnd() then
				maryo.SetAction(Action.CRAWLING)
			end
		
			return false
		end)
		
		DEF_ACTION(Action.STOP_CRAWLING, function(m: Mario)
			if maryo.Input:Has(InputFlags.OFF_FLOOR) then
				return maryo.SetAction(Action.FREEFALL)
			end
		
			if maryo.Input:Has(InputFlags.STOMPED) then
				return maryo.SetAction(Action.SHOCKWAVE_BOUNCE)
			end
		
			if maryo.Input:Has(InputFlags.ABOVE_SLIDE) then
				return maryo.SetAction(Action.BEGIN_SLIDING)
			end
		
			maryo.StationaryGroundStep()
			maryo.SetAnimation(Animations.STOP_CRAWLING)
		
			if maryo.IsAnimPastEnd() then
				maryo.SetAction(Action.CROUCHING)
			end
		
			return false
		end)
		
		DEF_ACTION(Action.SHOCKWAVE_BOUNCE, function(m: Mario)
			maryo.ActionTimer += 1
		
			if maryo.ActionTimer == 48 then
				maryo.SetAction(Action.IDLE)
			end
		
			local sp1E = bit32.lshift(maryo.ActionTimer % 16, 12)
			local sp18 = ((6 - maryo.ActionTimer / 8) * 8) + 4
		
			maryo.SetForwardVel(0)
			maryo.Velocity = Vector3.zero
		
			if Util.Sins(sp1E) >= 0 then
				maryo.Position = Util.SetY(maryo.Position, Util.Sins(sp1E) * sp18 + maryo.FloorHeight)
			else
				maryo.Position = Util.SetY(maryo.Position, maryo.FloorHeight - Util.Sins(sp1E) * sp18)
			end
		
			maryo.SetAnimation(Animations.A_POSE)
			return false
		end)
		
		DEF_ACTION(Action.JUMP_LAND_STOP, function(m: Mario)
			if checkCommonLandingCancels(m, 0) then
				return true
			end
		
			landingStep(m, Animations.LAND_FROM_SINGLE_JUMP, Action.IDLE)
			return false
		end)
		
		DEF_ACTION(Action.DOUBLE_JUMP_LAND_STOP, function(m: Mario)
			if checkCommonLandingCancels(m, 0) then
				return true
			end
		
			landingStep(m, Animations.LAND_FROM_DOUBLE_JUMP, Action.IDLE)
			return false
		end)
		
		DEF_ACTION(Action.SIDE_FLIP_LAND_STOP, function(m: Mario)
			if checkCommonLandingCancels(m, 0) then
				return true
			end
		
			landingStep(m, Animations.SLIDEFLIP_LAND, Action.IDLE)
			--maryo.GfxAngle += Vector3int16.new(0, 0x8000, 0)
		
			return false
		end)
		
		DEF_ACTION(Action.FREEFALL_LAND_STOP, function(m: Mario)
			if checkCommonLandingCancels(m, 0) then
				return true
			end
		
			landingStep(m, Animations.GENERAL_LAND, Action.IDLE)
			return false
		end)
		
		DEF_ACTION(Action.TRIPLE_JUMP_LAND_STOP, function(m: Mario)
			if checkCommonLandingCancels(m, Action.JUMP) then
				return true
			end
		
			landingStep(m, Animations.TRIPLE_JUMP_LAND, Action.IDLE)
			return false
		end)
		
		DEF_ACTION(Action.BACKFLIP_LAND_STOP, function(m: Mario)
			if not maryo.Input:Has(InputFlags.Z_DOWN) and maryo.AnimFrame >= 6 then
				maryo.Input:Remove(InputFlags.A_PRESSED)
			end
		
			if checkCommonLandingCancels(m, Action.BACKFLIP) then
				return true
			end
		
			landingStep(m, Animations.TRIPLE_JUMP_LAND, Action.IDLE)
			return false
		end)
		
		DEF_ACTION(Action.LAVA_BOOST_LAND, function(m: Mario)
			maryo.Input:Remove(InputFlags.FIRST_PERSON, InputFlags.B_PRESSED)
		
			if checkCommonLandingCancels(m, 0) then
				return true
			end
		
			landingStep(m, Animations.STAND_UP_FROM_LAVA_BOOST, Action.IDLE)
			return false
		end)
		
		DEF_ACTION(Action.LONG_JUMP_LAND_STOP, function(m: Mario)
			maryo.Input:Remove(InputFlags.B_PRESSED)
		
			if checkCommonLandingCancels(m, Action.JUMP) then
				return true
			end
		
			landingStep(
				m,
				if maryo.LongJumpIsSlow then Animations.CROUCH_FROM_FAST_LONGJUMP else Animations.CROUCH_FROM_SLOW_LONGJUMP,
				Action.CROUCHING
			)
		
			return false
		end)
		
		DEF_ACTION(Action.TWIRL_LAND, function(m: Mario)
			maryo.ActionState = 1
		
			if maryo.Input:Has(InputFlags.STOMPED) then
				return maryo.SetAction(Action.SHOCKWAVE_BOUNCE)
			end
		
			if maryo.Input:Has(InputFlags.OFF_FLOOR) then
				return maryo.SetAction(Action.FREEFALL)
			end
		
			maryo.StationaryGroundStep()
			maryo.SetAnimation(Animations.TWIRL_LAND)
		
			if maryo.AngleVel.Y > 0 then
				maryo.AngleVel -= Vector3int16.new(0, 0x400, 0)
		
				if maryo.AngleVel.Y < 0 then
					maryo.AngleVel *= Vector3int16.new(1, 0, 1)
				end
		
				maryo.TwirlYaw += maryo.AngleVel.Y
			end
		
			maryo.GfxAngle += Vector3int16.new(0, maryo.TwirlYaw, 0)
		
			if maryo.IsAnimAtEnd() and maryo.AngleVel.Y == 0 then
				maryo.FaceAngle += Vector3int16.new(0, maryo.TwirlYaw, 0)
				maryo.SetAction(Action.IDLE)
			end
		
			return false
		end)
		
		DEF_ACTION(Action.GROUND_POUND_LAND, function(m: Mario)
			if maryo.Input:Has(InputFlags.STOMPED) then
				return maryo.SetAction(Action.SHOCKWAVE_BOUNCE)
			end
		
			if maryo.Input:Has(InputFlags.OFF_FLOOR) then
				return maryo.SetAction(Action.FREEFALL)
			end
		
			if maryo.Input:Has(InputFlags.ABOVE_SLIDE) then
				return maryo.SetAction(Action.BUTT_SLIDE)
			end
		
			landingStep(m, Animations.GROUND_POUND_LANDING, Action.BUTT_SLIDE_STOP)
			return false
		end)
		
		DEF_ACTION(Action.STOMACH_SLIDE_STOP, function(m: Mario)
			if maryo.Input:Has(InputFlags.STOMPED) then
				return maryo.SetAction(Action.SHOCKWAVE_BOUNCE)
			end
		
			if maryo.Input:Has(InputFlags.OFF_FLOOR) then
				return maryo.SetAction(Action.FREEFALL)
			end
		
			if maryo.Input:Has(InputFlags.ABOVE_SLIDE) then
				return maryo.SetAction(Action.BEGIN_SLIDING)
			end
		
			animatedStationaryGroundStep(m, Animations.SLOW_LAND_FROM_DIVE, Action.IDLE)
			return false
		end)
	end
	do -- AIRBORNE
		local function stopRising(m: Mario)
			if maryo.Velocity.Y > 0 then
				maryo.Velocity *= Vector3.new(1, 0, 1)
			end
		end
		
		local function playFlipSounds(m: Mario, frame1: number, frame2: number, frame3: number)
			local animFrame = maryo.AnimFrame
		
			if animFrame == frame1 or animFrame == frame2 or animFrame == frame3 then
				maryo.PlaySound(Sounds.ACTION_SPIN)
			end
		end
		
		local function playKnockbackSound(m: Mario)
			if maryo.ActionArg == 0 and math.abs(maryo.ForwardVel) >= 28 then
				maryo.PlaySoundIfNoFlag(Sounds.MARIO_DOH, MarioFlags.MARIO_SOUND_PLAYED)
			else
				maryo.PlaySoundIfNoFlag(Sounds.MARIO_UH, MarioFlags.MARIO_SOUND_PLAYED)
			end
		end
		
		local function lavaBoostOnWall(m: Mario)
			local wall = maryo.Wall
		
			if wall then
				local angle = Util.Atan2s(wall.Normal.Z, wall.Normal.X)
				maryo.FaceAngle = Util.SetY(maryo.FaceAngle, angle)
			end
		
			if maryo.ForwardVel < 24 then
				maryo.ForwardVel = 24
			end
		
			if not maryo.Flags:Has(MarioFlags.METAL_CAP) then
				maryo.HurtCounter += if maryo.Flags:Has(MarioFlags.CAP_ON_HEAD) then 12 else 18
			end
		
			maryo.PlaySound(Sounds.MARIO_ON_FIRE)
			maryo.SetAction(Action.LAVA_BOOST, 1)
		end
		
		local function checkFallDamage(m: Mario, hardFallAction: number): boolean
			local fallHeight = maryo.PeakHeight - maryo.Position.Y
			local damageHeight = 1150
		
			if maryo.Action() == Action.TWIRLING then
				return false
			end
		
			if maryo.Velocity.Y < -55 and fallHeight > 3000 then
				maryo.HurtCounter += if maryo.Flags:Has(MarioFlags.CAP_ON_HEAD) then 16 else 24
				maryo.PlaySound(Sounds.MARIO_ATTACKED)
				maryo.SetAction(hardFallAction, 4)
			elseif fallHeight > damageHeight and not maryo.FloorIsSlippery() then
				maryo.HurtCounter += if maryo.Flags:Has(MarioFlags.CAP_ON_HEAD) then 8 else 12
				maryo.PlaySound(Sounds.MARIO_ATTACKED)
				maryo.SquishTimer = 30
			end
		
			return false
		end
		
		local function checkKickOrDiveInAir(m: Mario): boolean
			if maryo.Input:Has(InputFlags.B_PRESSED) then
				return maryo.SetAction(if maryo.ForwardVel > 28 then Action.DIVE else Action.JUMP_KICK)
			end
		
			return false
		end
		
		local function updateAirWithTurn(m: Mario)
			local dragThreshold = if maryo.Action() == Action.LONG_JUMP then 48 else 32
			maryo.ForwardVel = Util.ApproachFloat(maryo.ForwardVel, 0, 0.35)
		
			if maryo.Input:Has(InputFlags.NONZERO_ANALOG) then
				local intendedDYaw = maryo.IntendedYaw - maryo.FaceAngle.Y
				local intendedMag = maryo.IntendedMag / 32
		
				maryo.ForwardVel += 1.5 * Util.Coss(intendedDYaw) * intendedMag
				maryo.FaceAngle += Vector3int16.new(0, 512 * Util.Sins(intendedDYaw) * intendedMag, 0)
			end
		
			if maryo.ForwardVel > dragThreshold then
				maryo.ForwardVel -= 1
			end
		
			if maryo.ForwardVel < -16 then
				maryo.ForwardVel += 2
			end
		
			maryo.SlideVelX = maryo.ForwardVel * Util.Sins(maryo.FaceAngle.Y)
			maryo.SlideVelZ = maryo.ForwardVel * Util.Coss(maryo.FaceAngle.Y)
			maryo.Velocity = Vector3.new(maryo.SlideVelX, maryo.Velocity.Y, maryo.SlideVelZ)
		end
		
		local function updateAirWithoutTurn(m: Mario)
			local dragThreshold = 32
		
			if maryo.Action() == Action.LONG_JUMP then
				dragThreshold = 48
			end
		
			local sidewaysSpeed = 0
			maryo.ForwardVel = Util.ApproachFloat(maryo.ForwardVel, 0, 0.35)
		
			if maryo.Input:Has(InputFlags.NONZERO_ANALOG) then
				local intendedDYaw = maryo.IntendedYaw - maryo.FaceAngle.Y
				local intendedMag = maryo.IntendedMag / 32
		
				maryo.ForwardVel += intendedMag * Util.Coss(intendedDYaw) * 1.5
				sidewaysSpeed = intendedMag * Util.Sins(intendedDYaw) * 10
			end
		
			--! Uncapped air speed. Net positive when moving forward.
			if maryo.ForwardVel > dragThreshold then
				maryo.ForwardVel -= 1
			end
		
			if maryo.ForwardVel < -16 then
				maryo.ForwardVel += 2
			end
		
			maryo.SlideVelX = maryo.ForwardVel * Util.Sins(maryo.FaceAngle.Y)
			maryo.SlideVelZ = maryo.ForwardVel * Util.Coss(maryo.FaceAngle.Y)
		
			maryo.SlideVelX += sidewaysSpeed * Util.Sins(maryo.FaceAngle.Y + 0x4000)
			maryo.SlideVelZ += sidewaysSpeed * Util.Coss(maryo.FaceAngle.Y + 0x4000)
		
			maryo.Velocity = Vector3.new(maryo.SlideVelX, maryo.Velocity.Y, maryo.SlideVelZ)
		end
		
		local function updateLavaBoostOrTwirling(m: Mario)
			if maryo.Input:Has(InputFlags.NONZERO_ANALOG) then
				local intendedDYaw = maryo.IntendedYaw - maryo.FaceAngle.Y
				local intendedMag = maryo.IntendedMag / 32
		
				maryo.ForwardVel += Util.Coss(intendedDYaw) * intendedMag
				maryo.FaceAngle += Vector3int16.new(0, Util.Sins(intendedDYaw) * intendedMag * 1024, 0)
		
				if maryo.ForwardVel < 0 then
					maryo.FaceAngle += Vector3int16.new(0, 0x8000, 0)
					maryo.ForwardVel *= -1
				end
		
				if maryo.ForwardVel > 32 then
					maryo.ForwardVel -= 2
				end
			end
		
			maryo.SlideVelX = maryo.ForwardVel * Util.Sins(maryo.FaceAngle.Y)
			maryo.SlideVelZ = maryo.ForwardVel * Util.Coss(maryo.FaceAngle.Y)
		
			maryo.Velocity = Vector3.new(maryo.SlideVelX, maryo.Velocity.Y, maryo.SlideVelZ)
		end
		
		local function updateFlyingYaw(m: Mario)
			local targetYawVel = -Util.SignedShort(maryo.Controller.StickX * (maryo.ForwardVel / 4))
		
			if targetYawVel > 0 then
				if maryo.AngleVel.Y < 0 then
					maryo.AngleVel += Vector3int16.new(0, 0x40, 0)
		
					if maryo.AngleVel.Y > 0x10 then
						maryo.AngleVel = Util.SetY(maryo.AngleVel, 0x10)
					end
				else
					local y = Util.ApproachInt(maryo.AngleVel.Y, targetYawVel, 0x10, 0x20)
					maryo.AngleVel = Util.SetY(maryo.AngleVel, y)
				end
			elseif targetYawVel < 0 then
				if maryo.AngleVel.Y > 0 then
					maryo.AngleVel -= Vector3int16.new(0, 0x40, 0)
		
					if maryo.AngleVel.Y < -0x10 then
						maryo.AngleVel = Util.SetY(maryo.AngleVel, -0x10)
					end
				else
					local y = Util.ApproachInt(maryo.AngleVel.Y, targetYawVel, 0x20, 0x10)
					maryo.AngleVel = Util.SetY(maryo.AngleVel, y)
				end
			else
				local y = Util.ApproachInt(maryo.AngleVel.Y, 0, 0x40)
				maryo.AngleVel = Util.SetY(maryo.AngleVel, y)
			end
		
			maryo.FaceAngle += Vector3int16.new(0, maryo.AngleVel.Y, 0)
			maryo.FaceAngle = Util.SetZ(maryo.FaceAngle, 20 * -maryo.AngleVel.Y)
		end
		
		local function updateFlyingPitch(m: Mario)
			local targetPitchVel = -Util.SignedShort(maryo.Controller.StickY * (maryo.ForwardVel / 5))
		
			if targetPitchVel > 0 then
				if maryo.AngleVel.X < 0 then
					maryo.AngleVel += Vector3int16.new(0x40, 0, 0)
		
					if maryo.AngleVel.X > 0x20 then
						maryo.AngleVel = Util.SetX(maryo.AngleVel, 0x20)
					end
				else
					local x = Util.ApproachInt(maryo.AngleVel.X, targetPitchVel, 0x20, 0x40)
					maryo.AngleVel = Util.SetX(maryo.AngleVel, x)
				end
			elseif targetPitchVel < 0 then
				if maryo.AngleVel.X > 0 then
					maryo.AngleVel -= Vector3int16.new(0x40, 0, 0)
		
					if maryo.AngleVel.X < -0x20 then
						maryo.AngleVel = Util.SetX(maryo.AngleVel, -0x20)
					end
				else
					local x = Util.ApproachInt(maryo.AngleVel.X, targetPitchVel, 0x40, 0x20)
					maryo.AngleVel = Util.SetX(maryo.AngleVel, x)
				end
			else
				local x = Util.ApproachInt(maryo.AngleVel.X, 0, 0x40)
				maryo.AngleVel = Util.SetX(maryo.AngleVel, x)
			end
		end
		
		local function updateFlying(m: Mario)
			updateFlyingPitch(m)
			updateFlyingYaw(m)
		
			maryo.ForwardVel -= 2 * (maryo.FaceAngle.X / 0x4000) + 0.1
			maryo.ForwardVel -= 0.5 * (1 - Util.Coss(maryo.AngleVel.Y))
		
			if maryo.ForwardVel < 0 then
				maryo.ForwardVel = 0
			end
		
			if maryo.ForwardVel > 16 then
				maryo.FaceAngle += Vector3int16.new((maryo.ForwardVel - 32) * 6, 0, 0)
			elseif maryo.ForwardVel > 4 then
				maryo.FaceAngle += Vector3int16.new((maryo.ForwardVel - 32) * 10, 0, 0)
			else
				maryo.FaceAngle -= Vector3int16.new(0x400, 0, 0)
			end
		
			maryo.FaceAngle += Vector3int16.new(maryo.AngleVel.X, 0, 0)
		
			if maryo.FaceAngle.X > 0x2AAA then
				maryo.FaceAngle = Util.SetX(maryo.FaceAngle, 0x2AAA)
			end
		
			if maryo.FaceAngle.X < -0x2AAA then
				maryo.FaceAngle = Util.SetX(maryo.FaceAngle, -0x2AAA)
			end
		
			local velX = Util.Coss(maryo.FaceAngle.X) * Util.Sins(maryo.FaceAngle.Y)
			maryo.SlideVelX = maryo.ForwardVel * velX
		
			local velZ = Util.Coss(maryo.FaceAngle.X) * Util.Coss(maryo.FaceAngle.Y)
			maryo.SlideVelZ = maryo.ForwardVel * velZ
		
			local velY = Util.Sins(maryo.FaceAngle.X)
			maryo.Velocity = maryo.ForwardVel * Vector3.new(velX, velY, velZ)
		end
		
		local function commonAirActionStep(m: Mario, landAction: number, anim: Animation, stepArg: number): number
			local stepResult
			do
				updateAirWithoutTurn(m)
				stepResult = maryo.PerformAirStep(stepArg)
			end
		
			if stepResult == AirStep.NONE then
				maryo.SetAnimation(anim)
			elseif stepResult == AirStep.LANDED then
				if not checkFallDamage(m, Action.HARD_BACKWARD_GROUND_KB) then
					maryo.SetAction(landAction)
				end
			elseif stepResult == AirStep.HIT_WALL then
				maryo.SetAnimation(anim)
		
				if maryo.ForwardVel > 16 then
					maryo.BonkReflection()
					maryo.FaceAngle += Vector3int16.new(0, 0x8000, 0)
		
					if maryo.Wall then
						maryo.SetAction(Action.AIR_HIT_WALL)
					else
						stopRising(m)
		
						if maryo.ForwardVel >= 38 then
							maryo.ParticleFlags:Add(ParticleFlags.VERTICAL_STAR)
							maryo.SetAction(Action.BACKWARD_AIR_KB)
						else
							if maryo.ForwardVel > 8 then
								maryo.SetForwardVel(-8)
							end
		
							maryo.SetAction(Action.SOFT_BONK)
						end
					end
				else
					maryo.SetForwardVel(0)
				end
			elseif stepResult == AirStep.GRABBED_LEDGE then
				maryo.SetAnimation(Animations.IDLE_ON_LEDGE)
				maryo.SetAction(Action.LEDGE_GRAB)
			elseif stepResult == AirStep.GRABBED_CEILING then
				maryo.SetAction(Action.START_HANGING)
			elseif stepResult == AirStep.HIT_LAVA_WALL then
				lavaBoostOnWall(m)
			end
		
			return stepResult
		end
		
		local function commonRolloutStep(m: Mario, anim: Animation)
			local stepResult
		
			if maryo.ActionState == 0 then
				maryo.Velocity = Util.SetY(maryo.Velocity, 30)
				maryo.ActionState = 1
			end
		
			maryo.PlaySound(Sounds.ACTION_TERRAIN_JUMP)
			updateAirWithoutTurn(m)
		
			stepResult = maryo.PerformAirStep()
		
			if stepResult == AirStep.NONE then
				if maryo.ActionState == 1 then
					if maryo.SetAnimation(anim) == 4 then
						maryo.PlaySound(Sounds.ACTION_SPIN)
					end
				else
					maryo.SetAnimation(Animations.GENERAL_FALL)
				end
			elseif stepResult == AirStep.LANDED then
				maryo.SetAction(Action.FREEFALL_LAND_STOP)
				maryo.PlayLandingSound()
			elseif stepResult == AirStep.HIT_WALL then
				maryo.SetForwardVel(0)
			elseif stepResult == AirStep.HIT_LAVA_WALL then
				lavaBoostOnWall(m)
			end
		
			if maryo.ActionState == 1 and maryo.IsAnimPastEnd() then
				maryo.ActionState = 2
			end
		end
		
		local function commonAirKnockbackStep(
			m: Mario,
			landAction: number,
			hardFallAction: number,
			anim: Animation,
			speed: number
		)
			local stepResult
			do
				maryo.SetForwardVel(speed)
				stepResult = maryo.PerformAirStep()
			end
		
			if stepResult == AirStep.NONE then
				maryo.SetAnimation(anim)
			elseif stepResult == AirStep.LANDED then
				if not checkFallDamage(m, hardFallAction) then
					local action = maryo.Action()
		
					if action == Action.THROWN_FORWARD or action == Action.THROWN_BACKWARD then
						maryo.SetAction(landAction, maryo.HurtCounter)
					else
						maryo.SetAction(landAction, maryo.ActionArg)
					end
				end
			elseif stepResult == AirStep.HIT_WALL then
				maryo.SetAnimation(Animations.BACKWARD_AIR_KB)
				maryo.BonkReflection()
		
				stopRising(m)
				maryo.SetForwardVel(-speed)
			elseif stepResult == AirStep.HIT_LAVA_WALL then
				lavaBoostOnWall(m)
			end
		
			return stepResult
		end
		
		local function checkWallKick(m: Mario)
			if maryo.WallKickTimer ~= 0 then
				if maryo.Input:Has(InputFlags.A_PRESSED) then
					if maryo.PrevAction() == Action.AIR_HIT_WALL then
						maryo.FaceAngle += Vector3int16.new(0, 0x8000, 0)
					end
				end
			end
		
			return false
		end
		
		-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		-- Actions
		-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		
		local AIR_STEP_CHECK_BOTH = bit32.bor(AirStep.CHECK_LEDGE_GRAB, AirStep.CHECK_HANG)
		local DEF_ACTION: (number, (Mario) -> boolean) -> () = System.RegisterAction
		
		DEF_ACTION(Action.JUMP, function(m: Mario)
			if checkKickOrDiveInAir(m) then
				return true
			end
		
			if maryo.Input:Has(InputFlags.Z_PRESSED) then
				return maryo.SetAction(Action.GROUND_POUND)
			end
		
			maryo.PlayMarioSound(Sounds.ACTION_TERRAIN_JUMP)
			commonAirActionStep(m, Action.JUMP_LAND, Animations.SINGLE_JUMP, AIR_STEP_CHECK_BOTH)
		
			return false
		end)
		
		DEF_ACTION(Action.DOUBLE_JUMP, function(m: Mario)
			local anim = if maryo.Velocity.Y >= 0 then Animations.DOUBLE_JUMP_RISE else Animations.DOUBLE_JUMP_FALL
		
			if checkKickOrDiveInAir(m) then
				return true
			end
		
			if maryo.Input:Has(InputFlags.Z_PRESSED) then
				return maryo.SetAction(Action.GROUND_POUND)
			end
		
			maryo.PlayMarioSound(Sounds.ACTION_TERRAIN_JUMP, Sounds.MARIO_HOOHOO)
			commonAirActionStep(m, Action.DOUBLE_JUMP_LAND, anim, AIR_STEP_CHECK_BOTH)
		
			return false
		end)
		
		DEF_ACTION(Action.TRIPLE_JUMP, function(m: Mario)
			if maryo.Input:Has(InputFlags.B_PRESSED) then
				return maryo.SetAction(Action.DIVE)
			end
		
			if maryo.Input:Has(InputFlags.Z_PRESSED) then
				return maryo.SetAction(Action.GROUND_POUND)
			end
		
			maryo.PlayMarioSound(Sounds.ACTION_TERRAIN_JUMP)
			commonAirActionStep(m, Action.TRIPLE_JUMP_LAND, Animations.TRIPLE_JUMP, 0)
		
			playFlipSounds(m, 2, 8, 20)
			return false
		end)
		
		DEF_ACTION(Action.BACKFLIP, function(m: Mario)
			if maryo.Input:Has(InputFlags.Z_PRESSED) then
				return maryo.SetAction(Action.GROUND_POUND)
			end
		
			maryo.PlayMarioSound(Sounds.ACTION_TERRAIN_JUMP, Sounds.MARIO_YAH_WAH_HOO)
			commonAirActionStep(m, Action.BACKFLIP_LAND, Animations.BACKFLIP, 0)
		
			playFlipSounds(m, 2, 3, 17)
			return false
		end)
		
		DEF_ACTION(Action.FREEFALL, function(m: Mario)
			if maryo.Input:Has(InputFlags.B_PRESSED) then
				return maryo.SetAction(Action.DIVE)
			end
		
			if maryo.Input:Has(InputFlags.Z_PRESSED) then
				return maryo.SetAction(Action.GROUND_POUND)
			end
		
			local anim
		
			if maryo.ActionArg == 0 then
				anim = Animations.GENERAL_FALL
			elseif maryo.ActionArg == 1 then
				anim = Animations.FALL_FROM_SLIDE
			elseif maryo.ActionArg == 2 then
				anim = Animations.FALL_FROM_SLIDE_KICK
			end
		
			commonAirActionStep(m, Action.FREEFALL_LAND, anim, AirStep.CHECK_LEDGE_GRAB)
			return false
		end)
		
		DEF_ACTION(Action.SIDE_FLIP, function(m: Mario)
			if maryo.Input:Has(InputFlags.B_PRESSED) then
				return maryo.SetAction(Action.DIVE, 0)
			end
		
			if maryo.Input:Has(InputFlags.Z_PRESSED) then
				return maryo.SetAction(Action.GROUND_POUND)
			end
		
			maryo.PlayMarioSound(Sounds.ACTION_TERRAIN_JUMP)
			commonAirActionStep(m, Action.SIDE_FLIP_LAND, Animations.SLIDEFLIP, AirStep.CHECK_LEDGE_GRAB)
		
			if maryo.AnimFrame == 6 then
				maryo.PlaySound(Sounds.ACTION_SIDE_FLIP)
			end
		
			return false
		end)
		
		DEF_ACTION(Action.WALL_KICK_AIR, function(m: Mario)
			if maryo.Input:Has(InputFlags.B_PRESSED) then
				return maryo.SetAction(Action.DIVE)
			end
		
			if maryo.Input:Has(InputFlags.Z_PRESSED) then
				return maryo.SetAction(Action.GROUND_POUND)
			end
		
			maryo.PlayJumpSound()
			commonAirActionStep(m, Action.JUMP_LAND, Animations.SLIDEJUMP, AirStep.CHECK_LEDGE_GRAB)
		
			return false
		end)
		
		DEF_ACTION(Action.LONG_JUMP, function(m: Mario)
			local anim = if maryo.LongJumpIsSlow then Animations.SLOW_LONGJUMP else Animations.FAST_LONGJUMP
		
			maryo.PlayMarioSound(Sounds.ACTION_TERRAIN_JUMP, Sounds.MARIO_YAHOO)
			commonAirActionStep(m, Action.LONG_JUMP_LAND, anim, AirStep.CHECK_LEDGE_GRAB)
		
			return false
		end)
		
		DEF_ACTION(Action.TWIRLING, function(m: Mario)
			local startTwirlYaw = maryo.TwirlYaw
			local yawVelTarget = 0x1000
		
			if maryo.Input:Has(InputFlags.A_DOWN) then
				yawVelTarget = 0x2000
			end
		
			local yVel = Util.ApproachInt(maryo.AngleVel.Y, yawVelTarget, 0x200)
			maryo.AngleVel = Util.SetY(maryo.AngleVel, yVel)
			maryo.TwirlYaw += yVel
		
			maryo.SetAnimation(if maryo.ActionArg == 0 then Animations.START_TWIRL else Animations.TWIRL)
		
			if maryo.IsAnimPastEnd() then
				maryo.ActionArg = 1
			end
		
			if startTwirlYaw > maryo.TwirlYaw then
				maryo.PlaySound(Sounds.ACTION_TWIRL)
			end
		
			local step = maryo.PerformAirStep()
		
			if step == AirStep.LANDED then
				maryo.SetAction(Action.TWIRL_LAND)
			elseif step == AirStep.HIT_WALL then
				maryo.BonkReflection(false)
			elseif step == AirStep.HIT_LAVA_WALL then
				lavaBoostOnWall(m)
			end
		
			maryo.GfxAngle += Vector3int16.new(0, maryo.TwirlYaw, 0)
			return false
		end)
		
		DEF_ACTION(Action.DIVE, function(m: Mario)
			local airStep
		
			if maryo.ActionArg == 0 then
				maryo.PlayMarioSound(Sounds.ACTION_THROW, Sounds.MARIO_HOOHOO)
			else
				maryo.PlayMarioSound(Sounds.ACTION_TERRAIN_JUMP)
			end
		
			maryo.SetAnimation(Animations.DIVE)
			updateAirWithoutTurn(m)
			airStep = maryo.PerformAirStep()
		
			if airStep == AirStep.NONE then
				if maryo.Velocity.Y < 0 and maryo.FaceAngle.X > -0x2AAA then
					maryo.FaceAngle -= Vector3int16.new(0x200, 0, 0)
		
					if maryo.FaceAngle.X < -0x2AAA then
						maryo.FaceAngle = Util.SetX(maryo.FaceAngle, -0x2AAA)
					end
				end
		
				maryo.GfxAngle = Util.SetX(maryo.GfxAngle, -maryo.FaceAngle.X)
			elseif airStep == AirStep.LANDED then
				if not checkFallDamage(m, Action.HARD_FORWARD_GROUND_KB) then
					maryo.SetAction(Action.DIVE_SLIDE)
				end
		
				maryo.FaceAngle *= Vector3int16.new(0, 1, 1)
			elseif airStep == AirStep.HIT_WALL then
				maryo.BonkReflection(true)
				maryo.FaceAngle *= Vector3int16.new(0, 1, 1)
		
				stopRising(m)
		
				maryo.ParticleFlags:Add(ParticleFlags.VERTICAL_STAR)
				maryo.SetAction(Action.BACKWARD_AIR_KB)
			elseif airStep == AirStep.HIT_LAVA_WALL then
				lavaBoostOnWall(m)
			end
		
			return false
		end)
		
		DEF_ACTION(Action.WATER_JUMP, function(m: Mario)
			if maryo.ForwardVel < 15 then
				maryo.SetForwardVel(15)
			end
		
			maryo.PlaySound(Sounds.ACTION_WATER_EXIT)
			maryo.SetAnimation(Animations.SINGLE_JUMP)
		
			local step = maryo.PerformAirStep(AirStep.CHECK_LEDGE_GRAB)
		
			if step == AirStep.LANDED then
				maryo.SetAction(Action.JUMP_LAND)
			elseif step == AirStep.HIT_WALL then
				maryo.SetForwardVel(15)
			elseif step == AirStep.GRABBED_LEDGE then
				maryo.SetAnimation(Animations.IDLE_ON_LEDGE)
				maryo.SetAction(Action.LEDGE_GRAB)
			elseif step == AirStep.HIT_LAVA_WALL then
				lavaBoostOnWall(m)
			end
		
			return false
		end)
		
		DEF_ACTION(Action.STEEP_JUMP, function(m: Mario)
			local airStep
		
			if maryo.Input:Has(InputFlags.B_PRESSED) then
				return maryo.SetAction(Action.DIVE)
			end
		
			maryo.PlayMarioSound(Sounds.ACTION_TERRAIN_JUMP)
			maryo.SetForwardVel(0.98 * maryo.ForwardVel)
			airStep = maryo.PerformAirStep()
		
			if airStep == AirStep.LANDED then
				if not checkFallDamage(m, Action.HARD_BACKWARD_GROUND_KB) then
					maryo.FaceAngle *= Vector3int16.new(0, 1, 1)
					maryo.SetAction(if maryo.ForwardVel < 0 then Action.BEGIN_SLIDING else Action.JUMP_LAND)
				end
			elseif airStep == AirStep.HIT_WALL then
				maryo.SetForwardVel(0)
			elseif airStep == AirStep.HIT_LAVA_WALL then
				lavaBoostOnWall(m)
			end
		
			maryo.SetAnimation(Animations.SINGLE_JUMP)
			maryo.GfxAngle = Util.SetY(maryo.GfxAngle, maryo.SteepJumpYaw)
		
			return false
		end)
		
		DEF_ACTION(Action.GROUND_POUND, function(m: Mario)
			local stepResult
			local yOffset
		
			maryo.PlaySoundIfNoFlag(Sounds.ACTION_THROW, MarioFlags.ACTION_SOUND_PLAYED)
		
			if maryo.ActionState == 0 then
				if maryo.ActionTimer < 10 then
					yOffset = 20 - 2 * maryo.ActionTimer
		
					if maryo.Position.Y + yOffset + 160 < maryo.CeilHeight then
						maryo.Position += Vector3.new(0, yOffset, 0)
						maryo.PeakHeight = maryo.Position.Y
					end
				end
		
				maryo.Velocity = Util.SetY(maryo.Velocity, -50)
				maryo.SetForwardVel(0)
		
				maryo.SetAnimation(if maryo.ActionArg == 0 then Animations.START_GROUND_POUND else Animations.TRIPLE_JUMP_GROUND_POUND)
		
				if maryo.ActionTimer == 0 then
					maryo.PlaySound(Sounds.ACTION_SPIN)
				end
		
				maryo.ActionTimer += 1
				maryo.GfxAngle = Vector3int16.new(0, maryo.FaceAngle.Y, 0)
		
				if maryo.ActionTimer >= maryo.AnimFrameCount + 4 then
					maryo.PlaySound(Sounds.MARIO_GROUND_POUND_WAH)
					maryo.ActionState = 1
				end
			else
				maryo.SetAnimation(Animations.GROUND_POUND)
				stepResult = maryo.PerformAirStep()
		
				if stepResult == AirStep.LANDED then
					maryo.PlayHeavyLandingSound(Sounds.ACTION_HEAVY_LANDING)
		
					if not checkFallDamage(m, Action.HARD_BACKWARD_GROUND_KB) then
						maryo.ParticleFlags:Add(ParticleFlags.MIST_CIRCLE, ParticleFlags.HORIZONTAL_STAR)
						maryo.SetAction(Action.GROUND_POUND_LAND)
					end
				elseif stepResult == AirStep.HIT_WALL then
					maryo.SetForwardVel(-16)
					stopRising(m)
		
					maryo.ParticleFlags:Add(ParticleFlags.VERTICAL_STAR)
					maryo.SetAction(Action.BACKWARD_AIR_KB)
				end
			end
		
			return false
		end)
		
		DEF_ACTION(Action.BURNING_JUMP, function(m: Mario)
			maryo.PlayMarioSound(Sounds.ACTION_TERRAIN_JUMP)
			maryo.SetForwardVel(maryo.ForwardVel)
		
			if maryo.PerformAirStep() == AirStep.LANDED then
				maryo.PlayLandingSound()
				maryo.SetAction(Action.BURNING_GROUND)
			end
		
			maryo.SetAnimation(Animations.GENERAL_FALL)
			maryo.ParticleFlags:Add(ParticleFlags.FIRE)
			maryo.PlaySound(Sounds.MOVING_LAVA_BURN)
		
			maryo.BurnTimer += 3
			maryo.Health -= 10
		
			if maryo.Health < 0x100 then
				maryo.Health = 0xFF
			end
		
			return false
		end)
		
		DEF_ACTION(Action.BURNING_FALL, function(m: Mario)
			maryo.SetForwardVel(maryo.ForwardVel)
		
			if maryo.PerformAirStep() == AirStep.LANDED then
				maryo.PlayLandingSound(Sounds.ACTION_TERRAIN_LANDING)
				maryo.SetAction(Action.BURNING_GROUND)
			end
		
			maryo.SetAnimation(Animations.GENERAL_FALL)
			maryo.ParticleFlags:Add(ParticleFlags.FIRE)
		
			maryo.BurnTimer += 3
			maryo.Health -= 10
		
			if maryo.Health < 0x100 then
				maryo.Health = 0xFF
			end
		
			return false
		end)
		
		DEF_ACTION(Action.BACKWARD_AIR_KB, function(m: Mario)
			if checkWallKick(m) then
				return true
			end
		
			playKnockbackSound(m)
			commonAirKnockbackStep(
				m,
				Action.BACKWARD_GROUND_KB,
				Action.HARD_BACKWARD_GROUND_KB,
				Animations.BACKWARD_AIR_KB,
				-16
			)
		
			return false
		end)
		
		DEF_ACTION(Action.FORWARD_AIR_KB, function(m: Mario)
			if checkWallKick(m) then
				return true
			end
		
			playKnockbackSound(m)
			commonAirKnockbackStep(m, Action.FORWARD_GROUND_KB, Action.HARD_FORWARD_GROUND_KB, Animations.FORWARD_AIR_KB, 16)
		
			return false
		end)
		
		DEF_ACTION(Action.HARD_BACKWARD_AIR_KB, function(m: Mario)
			if checkWallKick(m) then
				return true
			end
		
			playKnockbackSound(m)
			commonAirKnockbackStep(
				m,
				Action.HARD_BACKWARD_GROUND_KB,
				Action.HARD_BACKWARD_GROUND_KB,
				Animations.BACKWARD_AIR_KB,
				-16
			)
		
			return false
		end)
		
		DEF_ACTION(Action.HARD_FORWARD_AIR_KB, function(m: Mario)
			if checkWallKick(m) then
				return true
			end
		
			playKnockbackSound(m)
			commonAirKnockbackStep(
				m,
				Action.HARD_FORWARD_GROUND_KB,
				Action.HARD_FORWARD_GROUND_KB,
				Animations.FORWARD_AIR_KB,
				16
			)
		
			return false
		end)
		
		DEF_ACTION(Action.THROWN_BACKWARD, function(m: Mario)
			local landAction = if maryo.ActionArg ~= 0 then Action.HARD_BACKWARD_GROUND_KB else Action.BACKWARD_GROUND_KB
		
			maryo.PlaySoundIfNoFlag(Sounds.MARIO_WAAAOOOW, MarioFlags.MARIO_SOUND_PLAYED)
			commonAirKnockbackStep(m, landAction, Action.HARD_BACKWARD_GROUND_KB, Animations.BACKWARD_AIR_KB, maryo.ForwardVel)
		
			maryo.ForwardVel *= 0.98
			return false
		end)
		
		DEF_ACTION(Action.THROWN_FORWARD, function(m: Mario)
			local landAction = if maryo.ActionArg ~= 0 then Action.HARD_FORWARD_GROUND_KB else Action.FORWARD_GROUND_KB
		
			maryo.PlaySoundIfNoFlag(Sounds.MARIO_WAAAOOOW, MarioFlags.MARIO_SOUND_PLAYED)
		
			if
				commonAirKnockbackStep(m, landAction, Action.HARD_FORWARD_GROUND_KB, Animations.FORWARD_AIR_KB, maryo.ForwardVel)
				== AirStep.NONE
			then
				local pitch = Util.Atan2s(maryo.ForwardVel, -maryo.Velocity.Y)
		
				if pitch > 0x1800 then
					pitch = 0x1800
				end
		
				maryo.GfxAngle = Util.SetX(maryo.GfxAngle, pitch + 0x1800)
			end
		
			maryo.ForwardVel *= 0.98
			return false
		end)
		
		DEF_ACTION(Action.SOFT_BONK, function(m: Mario)
			if checkWallKick(m) then
				return true
			end
		
			playKnockbackSound(m)
			commonAirKnockbackStep(
				m,
				Action.FREEFALL_LAND,
				Action.HARD_BACKWARD_GROUND_KB,
				Animations.GENERAL_FALL,
				maryo.ForwardVel
			)
		
			return false
		end)
		
		DEF_ACTION(Action.AIR_HIT_WALL, function(m: Mario)
			maryo.ActionTimer += 1
		
			if maryo.ActionTimer <= 2 then
				if maryo.Input:Has(InputFlags.A_PRESSED) then
					maryo.Velocity = Util.SetY(maryo.Velocity, 52)
					maryo.FaceAngle += Vector3int16.new(0, 0x8000, 0)
					return maryo.SetAction(Action.WALL_KICK_AIR)
				end
			elseif maryo.ForwardVel >= 38 then
				maryo.WallKickTimer = 5
		
				if maryo.Velocity.Y > 0 then
					maryo.Velocity = Util.SetY(maryo.Velocity, 0)
				end
		
				maryo.ParticleFlags:Add(ParticleFlags.VERTICAL_STAR)
				return maryo.SetAction(Action.BACKWARD_AIR_KB)
			else
				maryo.WallKickTimer = 5
		
				if m.Velocity.Y > 0 then
					maryo.Velocity = Util.SetY(maryo.Velocity, 0)
				end
		
				if maryo.ForwardVel > 8 then
					maryo.SetForwardVel(-8)
				end
		
				return maryo.SetAction(Action.SOFT_BONK)
			end
		
			return maryo.SetAnimation(Animations.START_WALLKICK) > 0
		end)
		
		DEF_ACTION(Action.FORWARD_ROLLOUT, function(m: Mario)
			commonRolloutStep(m, Animations.FORWARD_SPINNING)
			return false
		end)
		
		DEF_ACTION(Action.BACKWARD_ROLLOUT, function(m: Mario)
			commonRolloutStep(m, Animations.BACKWARD_SPINNING)
			return false
		end)
		
		DEF_ACTION(Action.BUTT_SLIDE_AIR, function(m: Mario)
			local stepResult
			maryo.ActionTimer += 1
		
			if maryo.ActionTimer > 30 and maryo.Position.Y - maryo.FloorHeight > 500 then
				return maryo.SetAction(Action.FREEFALL, 1)
			end
		
			updateAirWithTurn(m)
			stepResult = maryo.PerformAirStep()
		
			if stepResult == AirStep.LANDED then
				if maryo.ActionState == 0 and maryo.Velocity.Y < 0 then
					local floor = maryo.Floor
		
					if floor and floor.Normal.Y > 0.9848077 then
						maryo.Velocity *= Vector3.new(1, -0.5, 1)
						maryo.ActionState = 1
					else
						maryo.SetAction(Action.BUTT_SLIDE)
					end
				else
					maryo.SetAction(Action.BUTT_SLIDE)
				end
		
				maryo.PlayLandingSound()
			elseif stepResult == AirStep.HIT_WALL then
				stopRising(m)
				maryo.ParticleFlags:Add(ParticleFlags.VERTICAL_STAR)
				maryo.SetAction(Action.BACKWARD_AIR_KB)
			elseif stepResult == AirStep.HIT_LAVA_WALL then
				lavaBoostOnWall(m)
			end
		
			maryo.SetAnimation(Animations.SLIDE)
			return false
		end)
		
		DEF_ACTION(Action.LAVA_BOOST, function(m: Mario)
			local stepResult
			maryo.PlaySoundIfNoFlag(Sounds.MARIO_ON_FIRE, MarioFlags.MARIO_SOUND_PLAYED)
		
			if not maryo.Input:Has(InputFlags.NONZERO_ANALOG) then
				maryo.ForwardVel = Util.ApproachFloat(maryo.ForwardVel, 0, 0.35)
			end
		
			updateLavaBoostOrTwirling(m)
			stepResult = maryo.PerformAirStep()
		
			if stepResult == AirStep.LANDED then
				local floor = maryo.Floor
				local floorType: Enum.Material?
		
				if floor then
					floorType = floor.Material
				end
		
				if floorType == Enum.Material.CrackedLava then
					maryo.ActionState = 0
		
					if not maryo.Flags:Has(MarioFlags.METAL_CAP) then
						maryo.HurtCounter += if maryo.Flags:Has(MarioFlags.CAP_ON_HEAD) then 12 else 18
					end
		
					maryo.Velocity = Util.SetY(maryo.Velocity, 84)
					maryo.PlaySound(Sounds.MARIO_ON_FIRE)
				else
					maryo.PlayHeavyLandingSound(Sounds.ACTION_TERRAIN_BODY_HIT_GROUND)
		
					if maryo.ActionState < 2 and maryo.Velocity.Y < 0 then
						maryo.Velocity *= Vector3.new(1, -0.4, 1)
						maryo.SetForwardVel(maryo.ForwardVel / 2)
						maryo.ActionState += 1
					else
						maryo.SetAction(Action.LAVA_BOOST_LAND)
					end
				end
			elseif stepResult == AirStep.HIT_WALL then
				maryo.BonkReflection()
			elseif stepResult == AirStep.HIT_LAVA_WALL then
				lavaBoostOnWall(m)
			end
		
			maryo.SetAnimation(Animations.FIRE_LAVA_BURN)
		
			if not maryo.Flags:Has(MarioFlags.METAL_CAP) and maryo.Velocity.Y > 0 then
				maryo.ParticleFlags:Add(ParticleFlags.FIRE)
		
				if maryo.ActionState == 0 then
					maryo.PlaySound(Sounds.MOVING_LAVA_BURN)
				end
			end
		
			maryo.BodyState.EyeState = MarioEyes.DEAD
			return false
		end)
		
		DEF_ACTION(Action.SLIDE_KICK, function(m: Mario)
			local stepResult
		
			if maryo.ActionState == 0 and maryo.ActionTimer == 0 then
				maryo.PlayMarioSound(Sounds.ACTION_TERRAIN_JUMP, Sounds.MARIO_HOOHOO)
				maryo.SetAnimation(Animations.SLIDE_KICK)
			end
		
			maryo.ActionTimer += 1
		
			if maryo.ActionTimer > 30 and maryo.Position.Y - maryo.FloorHeight > 500 then
				return maryo.SetAction(Action.FREEFALL, 2)
			end
		
			updateAirWithoutTurn(m)
			stepResult = maryo.PerformAirStep()
		
			if stepResult == AirStep.NONE then
				if maryo.ActionState == 0 then
					local tilt = Util.Atan2s(maryo.ForwardVel, -maryo.Velocity.Y)
		
					if tilt > 0x1800 then
						tilt = 0x1800
					end
		
					maryo.GfxAngle = Util.SetX(maryo.GfxAngle, tilt)
				end
			elseif stepResult == AirStep.LANDED then
				if maryo.ActionState == 0 and maryo.Velocity.Y < 0 then
					maryo.Velocity *= Vector3.new(1, -0.5, 1)
					maryo.ActionState = 1
					maryo.ActionTimer = 0
				else
					maryo.SetAction(Action.SLIDE_KICK_SLIDE)
				end
		
				maryo.PlayLandingSound()
			elseif stepResult == AirStep.HIT_WALL then
				stopRising(m)
				maryo.ParticleFlags:Add(ParticleFlags.VERTICAL_STAR)
				maryo.SetAction(Action.BACKWARD_AIR_KB)
			elseif stepResult == AirStep.HIT_LAVA_WALL then
				lavaBoostOnWall(m)
			end
		
			return false
		end)
		
		DEF_ACTION(Action.JUMP_KICK, function(m: Mario)
			local stepResult
		
			if maryo.ActionState == 0 then
				maryo.PlaySoundIfNoFlag(Sounds.MARIO_PUNCH_HOO, MarioFlags.MARIO_SOUND_PLAYED)
				maryo.AnimReset = true
		
				maryo.SetAnimation(Animations.AIR_KICK)
				maryo.ActionState = 1
			end
		
			local animFrame = maryo.AnimFrame
		
			if animFrame == 0 then
				maryo.BodyState.PunchType = 2
				maryo.BodyState.PunchTimer = 6
			end
		
			if animFrame >= 0 and animFrame < 8 then
				maryo.Flags:Add(MarioFlags.KICKING)
			end
		
			updateAirWithoutTurn(m)
			stepResult = maryo.PerformAirStep()
		
			if stepResult == AirStep.LANDED then
				if not checkFallDamage(m, Action.HARD_BACKWARD_GROUND_KB) then
					maryo.SetAction(Action.FREEFALL_LAND)
				end
			elseif stepResult == AirStep.HIT_WALL then
				maryo.SetForwardVel(0)
			end
		
			return false
		end)
		
		DEF_ACTION(Action.FLYING, function(m: Mario)
			local startPitch = maryo.FaceAngle.X
		
			if maryo.Input:Has(InputFlags.Z_PRESSED) then
				return maryo.SetAction(Action.GROUND_POUND)
			end
		
			if not maryo.Flags:Has(MarioFlags.WING_CAP) then
				return maryo.SetAction(Action.FREEFALL)
			end
		
			if maryo.ActionState == 0 then
				if maryo.ActionArg == 0 then
					maryo.SetAnimation(Animations.FLY_FROM_CANNON)
				else
					maryo.SetAnimation(Animations.FORWARD_SPINNING_FLIP)
		
					if maryo.AnimFrame == 1 then
						maryo.PlaySound(Sounds.ACTION_SPIN)
					end
				end
		
				if maryo.IsAnimAtEnd() then
					maryo.SetAnimation(Animations.WING_CAP_FLY)
					maryo.ActionState = 1
				end
			end
		
			local stepResult
			do
				updateFlying(m)
				stepResult = maryo.PerformAirStep()
			end
		
			if stepResult == AirStep.NONE then
				maryo.GfxAngle = Util.SetX(maryo.GfxAngle, -maryo.FaceAngle.X)
				maryo.GfxAngle = Util.SetZ(maryo.GfxAngle, maryo.FaceAngle.Z)
				maryo.ActionTimer = 0
			elseif stepResult == AirStep.LANDED then
				maryo.SetAction(Action.DIVE_SLIDE)
				maryo.SetAnimation(Animations.DIVE)
		
				maryo.SetAnimToFrame(7)
				maryo.FaceAngle *= Vector3int16.new(0, 1, 1)
			elseif stepResult == AirStep.HIT_WALL then
				if maryo.Wall then
					maryo.SetForwardVel(-16)
					maryo.FaceAngle *= Vector3int16.new(0, 1, 1)
		
					stopRising(m)
					maryo.PlaySound(if maryo.Flags:Has(MarioFlags.METAL_CAP) then Sounds.ACTION_METAL_BONK else Sounds.ACTION_BONK)
		
					maryo.ParticleFlags:Add(ParticleFlags.VERTICAL_STAR)
					maryo.SetAction(Action.BACKWARD_AIR_KB)
				else
					maryo.ActionTimer += 1
		
					if maryo.ActionTimer == 0 then
						maryo.PlaySound(Sounds.ACTION_HIT)
					end
		
					if maryo.ActionTimer == 30 then
						maryo.ActionTimer = 0
					end
		
					maryo.FaceAngle -= Vector3int16.new(0x200, 0, 0)
		
					if maryo.FaceAngle.X < -0x2AAA then
						maryo.FaceAngle = Util.SetX(maryo.FaceAngle, -0x2AAA)
					end
		
					maryo.GfxAngle = Util.SetX(maryo.GfxAngle, -maryo.FaceAngle.X)
					maryo.GfxAngle = Util.SetZ(maryo.GfxAngle, maryo.FaceAngle.Z)
				end
			elseif stepResult == AirStep.HIT_LAVA_WALL then
				lavaBoostOnWall(m)
			end
		
			if maryo.FaceAngle.X > 0x800 and maryo.ForwardVel >= 48 then
				maryo.ParticleFlags:Add(ParticleFlags.DUST)
			end
		
			if startPitch <= 0 and maryo.FaceAngle.X > 0 and maryo.ForwardVel >= 48 then
				maryo.PlaySound(Sounds.ACTION_FLYING_FAST)
				maryo.PlaySound(Sounds.MARIO_YAHOO_WAHA_YIPPEE)
			end
		
			maryo.PlaySound(Sounds.MOVING_FLYING)
			maryo.AdjustSoundForSpeed()
		
			return false
		end)
		
		DEF_ACTION(Action.FLYING_TRIPLE_JUMP, function(m: Mario)
			if maryo.Input:Has(InputFlags.B_PRESSED) then
				return maryo.SetAction(Action.DIVE)
			end
		
			if maryo.Input:Has(InputFlags.Z_PRESSED) then
				return maryo.SetAction(Action.GROUND_POUND)
			end
		
			maryo.PlayMarioSound(Sounds.ACTION_TERRAIN_JUMP, Sounds.MARIO_YAHOO)
		
			if maryo.ActionState == 0 then
				maryo.SetAnimation(Animations.TRIPLE_JUMP_FLY)
		
				if maryo.AnimFrame == 7 then
					maryo.PlaySound(Sounds.ACTION_SPIN)
				end
		
				if maryo.IsAnimPastEnd() then
					maryo.SetAnimation(Animations.FORWARD_SPINNING)
					maryo.ActionState = 1
				end
			end
		
			if maryo.ActionState == 1 and maryo.AnimFrame == 1 then
				maryo.PlaySound(Sounds.ACTION_SPIN)
			end
		
			if maryo.Velocity.Y < 4 then
				if maryo.ForwardVel < 32 then
					maryo.SetForwardVel(32)
				end
		
				maryo.SetAction(Action.FLYING, 1)
			end
		
			maryo.ActionTimer += 1
		
			local stepResult
			do
				updateAirWithoutTurn(m)
				stepResult = maryo.PerformAirStep()
			end
		
			if stepResult == AirStep.LANDED then
				if not checkFallDamage(m, Action.HARD_BACKWARD_GROUND_KB) then
					maryo.SetAction(Action.DOUBLE_JUMP_LAND)
				end
			elseif stepResult == AirStep.HIT_WALL then
				maryo.BonkReflection()
			elseif stepResult == AirStep.HIT_LAVA_WALL then
				lavaBoostOnWall(m)
			end
		
			return false
		end)
		
		DEF_ACTION(Action.SPAWN_SPIN_AIRBORNE, function(m: Mario)
			maryo.SetForwardVel(maryo.ForwardVel)
		
			if maryo.PerformAirStep() == AirStep.LANDED then
				maryo.PlayLandingSound(Sounds.ACTION_TERRAIN_LANDING)
				maryo.SetAction(Action.SPAWN_SPIN_LANDING)
			end
		
			if maryo.ActionState == 0 and maryo.Position.Y - maryo.FloorHeight > 300 then
				if maryo.SetAnimation(Animations.FORWARD_SPINNING) == 0 then
					maryo.PlaySound(Sounds.ACTION_SPIN)
				end
			else
				maryo.ActionState = 1
				maryo.SetAnimation(Animations.GENERAL_FALL)
			end
		
			return false
		end)
		
		DEF_ACTION(Action.SPAWN_SPIN_LANDING, function(m: Mario)
			maryo.StopAndSetHeightToFloor()
			maryo.SetAnimation(Animations.GENERAL_LAND)
			if maryo.IsAnimAtEnd() then
				maryo.SetAction(Action.IDLE)
			end
			return false
		end)
	end

	function maryo.Reset(spawn)
		maryo.Controller = {
			A = false,
			B = false,
			Z = false,
			-- in world coords btw
			StickX = 0,
			StickZ = 0,
		}
		maryo._ButtonStates = {
			A = false,
			B = false,
			Z = false,
		}
		
		maryo.Flags = {
			NORMAL_CAP = true,
			CAP_ON_HEAD = true,
		}
		maryo.Input = {}
		maryo.Sounds = {}
		maryo.Events = {
			STOMPED = false,
		}
		
		maryo.Action = nil
		maryo.ActionArg = 0
		maryo.ActionState = 0
		maryo.ActionTimer = 0
		maryo.PrevAction = nil
		
		maryo.Health = 8
		maryo.HealthAdd = 0
		maryo.HealthSub = 0
		
		maryo.SlideYaw = 0
		maryo.TwirlYaw = 0
		
		maryo.Position = spawn or Vector3.new(0, 100, 0)
		maryo.Velocity = Vector3.zero
		
		maryo.ForwardVel = 0
		maryo.SlideVelX = 0
		maryo.SlideVelZ = 0
		
		maryo.FaceAngle = Vector3.zero
		maryo.AngleVel = Vector3.zero
		
		maryo.CeilHeight = maryo.Position.Y + 32
		maryo.Floor = nil
		maryo.FloorHeight = maryo.Position.Y - 32
		maryo.FloorAngle = 0
		maryo.WaterLevel = -10000
		
		maryo.IntendedMag = 0
		maryo.IntendedYaw = 0
		maryo.InvincTimer = 0
		
		maryo.FramesSinceA = 255
		maryo.FramesSinceB = 255
		
		maryo.WallKickTimer = 0
		maryo.DoubleJumpTimer = 0
		
		maryo.CapTimer = 0
		maryo.BurnTimer = 0
		maryo.PeakHeight = 0
		maryo.SteepJumpYaw = 0
		maryo.WalkingPitch = 0
		maryo.QuicksandDepth = 0
		maryo.LongJumpIsSlow = false
		
		maryo.AnimCurrent = nil
		maryo.AnimAccel = 0
		maryo.AnimFrame = -1
		maryo.AnimSetFrame = -1
		maryo.AnimDirty = false
		maryo.AnimReset = false
		maryo.AnimFrameCount = 0
		maryo.AnimAccelAssist = 0
		maryo.AnimSkipInterp = 0
		
		maryo.AutoJump = false
		maryo.InfiniteJump = false
		
		maryo.SetAction("SPAWN_SPIN_AIRBORNE")
	end
	maryo.Reset()

	m.Init = function(figure: Model)
		local root = figure:FindFirstChild("HumanoidRootPart")
		maryo.Reset(root and root.Position or nil)
	end
	m.Update = function(dt: number, figure: Model)
		local t = os.clock()
		if m.ModeCap == 1 then
			maryo.Flags.NORMAL_CAP = false
			maryo.Flags.WING_CAP = false
			maryo.Flags.METAL_CAP = false
			maryo.Flags.VANISH_CAP = false
			maryo.Flags.CAP_ON_HEAD = false
		end
		if m.ModeCap == 2 then
			maryo.Flags.NORMAL_CAP = true
			maryo.Flags.WING_CAP = false
			maryo.Flags.METAL_CAP = false
			maryo.Flags.VANISH_CAP = false
			maryo.Flags.CAP_ON_HEAD = true
		end
		if m.ModeCap == 3 then
			maryo.Flags.NORMAL_CAP = false
			maryo.Flags.WING_CAP = true
			maryo.Flags.METAL_CAP = false
			maryo.Flags.VANISH_CAP = false
			maryo.Flags.CAP_ON_HEAD = true
		end
		if m.ModeCap == 4 then
			maryo.Flags.NORMAL_CAP = false
			maryo.Flags.WING_CAP = false
			maryo.Flags.METAL_CAP = true
			maryo.Flags.VANISH_CAP = false
			maryo.Flags.CAP_ON_HEAD = true
		end
		if m.ModeCap == 5 then
			maryo.Flags.NORMAL_CAP = false
			maryo.Flags.WING_CAP = false
			maryo.Flags.METAL_CAP = false
			maryo.Flags.VANISH_CAP = true
			maryo.Flags.CAP_ON_HEAD = true
		end
	end
	m.Destroy = function(figure: Model?)
	end
	return m
end)

return modules