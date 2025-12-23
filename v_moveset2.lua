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
	m.Config = function(parent: GuiBase2d)
		Util_CreateSwitch(parent, "30 FPS Cap", m.FPS30).Changed:Connect(function(val)
			m.FPS30 = val
		end)
	end
	m.LoadConfig = function(save: any)
		m.FPS30 = not not save.FPS30
	end
	m.SaveConfig = function()
		return {
			FPS30 = m.FPS30,
		}
	end

	local VECTOR3_XZ = Vector3.new(1, 0, 1)
	local XZ_DIRS = {
		Vector3.new(-1, 0, 0)
	}
	local maryo = {}
	maryo.Enums = {}
	maryo.Enums.StateGroups = {
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
	maryo.Enums.StateFlags = {
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
	maryo.Enums.States = {
		UNINITIALIZED = 0x00000000, -- (0x000)

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
	maryo.Enums.Flags = {
		NORMAL_CAP = 0x00000001,
		VANISH_CAP = 0x00000002,
		METAL_CAP = 0x00000004,
		WING_CAP = 0x00000008,
		CAP_ON_HEAD = 0x00000010,
		CAP_IN_HAND = 0x00000020,
		METAL_SHOCK = 0x00000040,
		TELEPORTING = 0x00000080,
		MOVING_UP_IN_AIR = 0x00000100,
		ACTION_SOUND_PLAYED = 0x00010000,
		MARIO_SOUND_PLAYED = 0x00020000,
		FALLING_FAR = 0x00040000,
		PUNCHING = 0x00100000,
		KICKING = 0x00200000,
		TRIPPING = 0x00400000,
	}
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
		local result = maryo.Raycast(pos, Vector3.new(0, -10000, 0))
		if result then
			height = result.Position.Y
		end
		return height, result
	end
	function maryo.FindCeiling(pos)
		local height = 10000
		local result = maryo.Raycast(pos, Vector3.new(0, 10000, 0))
		if result then
			height = result.Position.Y
		end
		return height, result
	end
	function maryo.FindWalls(pos, offset, radius)
		local origin = pos + Vector3.new(0, offset, 0)
		local lastWall = nil
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
						lastWall = contact
					end
				end
			end
		end
		return pos + disp, lastWall
	end

	function maryo.Reset(spawn)
		maryo.Flags = maryo.Enums.Flags.MOVING_UP_IN_AIR
		maryo.State = maryo.Enums.States.SPAWN_SPIN_AIRBORNE
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
		maryo.CeilHeight = 0
		maryo.FloorHeight = 0
		maryo.FloorAngle = 0
		maryo.WaterLevel = 0
	end

	m.Init = function(figure: Model)
		local root = figure:FindFirstChild("HumanoidRootPart")
		maryo.Reset(root and root.Position or nil)
	end
	m.Update = function(dt: number, figure: Model)
		local t = os.clock()
	end
	m.Destroy = function(figure: Model?)
	end
	return m
end)

AddModule(function()
	local m = {}
	m.ModuleType = "MOVESET"
	m.Name = "2007 Roblox"
	m.Description = "old roblox is retroslop.\nVery accurate recreation of the old Roblox physics!\nReject Motor6Ds, and return to Motors!"
	m.InternalName = "RETROSLOP"
	m.Assets = {}

	m.FPS30 = true
	m.Snap = true
	m.Config = function(parent: GuiBase2d)
		Util_CreateSwitch(parent, "30 FPS Cap", m.FPS30).Changed:Connect(function(val)
			m.FPS30 = val
		end)
		Util_CreateSwitch(parent, "Joint Snapping", m.Snap).Changed:Connect(function(val)
			m.Snap = val
		end)
	end
	m.LoadConfig = function(save: any)
		m.FPS30 = not save.FPSUnlock
		m.Snap = not save.NoSnap
	end
	m.SaveConfig = function()
		return {
			FPSUnlock = not m.FPS30,
			NoSnap = not m.Snap
		}
	end

	local rcp = RaycastParams.new()
	rcp.FilterType = Enum.RaycastFilterType.Exclude
	rcp.RespectCanCollide = true
	rcp.IgnoreWater = true

	-- https://raw.githubusercontent.com/MaximumADHD/Super-Nostalgia-Zone/refs/heads/main/Player/RetroClimbing.client.lua
	local searchDepth = 0.7
	local maxClimbDist = 2.45
	local sampleSpacing = 1 / 7
	local lowLadderSearch = 2.7
	local ladderSearchDist = 2.0
	local function findPartInLadderZone(figure, root, hum)
		local cf = root.CFrame
		local top = -hum.HipHeight
		local bottom = -lowLadderSearch + top
		local radius = 0.5 * ladderSearchDist
		local center = cf.Position + (cf.LookVector * ladderSearchDist * 0.5)
		local min = Vector3.new(-radius, bottom, -radius)
		local max = Vector3.new(radius, top, radius)
		local extents = Region3.new(center + min, center + max)
		return #workspace:FindPartsInRegion3(extents, figure) > 0
	end
	local function findLadder(figure, root, hum)
		local scale = figure:GetScale()
		searchDepth = 0.7 * scale
		maxClimbDist = 2.45 * scale
		sampleSpacing = scale / 7
		lowLadderSearch = 2.7 * scale
		ladderSearchDist = 2.0 * scale
		if not findPartInLadderZone(figure, root, hum) then
			return false
		end
		local torsoCoord = root.CFrame
		local torsoLook = torsoCoord.LookVector
		local firstSpace = 0
		local firstStep = 0
		local lookForSpace = true
		local lookForStep = false
		local topRay = math.floor(lowLadderSearch / sampleSpacing)
		for i = 1, topRay do
			local distFromBottom = i * sampleSpacing
			local originOnTorso = Vector3.new(0, -lowLadderSearch + distFromBottom, 0)
			local casterOrigin = torsoCoord.Position + originOnTorso
			local casterDirection = torsoLook * ladderSearchDist
			local hitPrim, hitLoc = nil, casterOrigin + casterDirection
			local hit = workspace:Raycast(casterOrigin, casterDirection, rcp)
			if hit then
				hitPrim, hitLoc = hit.Instance, hit.Position
			end
			-- make trusses climbable.
			if hitPrim and hitPrim:IsA("TrussPart") then
				return true
			end
			local mag = (hitLoc - casterOrigin).Magnitude
			if mag < searchDepth then
				if lookForSpace then
					firstSpace = distFromBottom
					lookForSpace = false
					lookForStep = true
				end
			elseif lookForStep then
				firstStep = distFromBottom - firstSpace
				lookForStep = false
			end
		end
		return firstSpace < maxClimbDist and firstStep > 0 and firstStep < maxClimbDist
	end

	local hstatechange, hrun = nil

	local lastpose = ""
	local pose = "Standing"
	local toolAnim = "None"
	local toolAnimTime = 0
	local canClimb = false
	local hipHeight = 0

	local rng = Random.new(math.random(-65536, 65536))
	
	local sndpoint, climbforce = nil, nil

	local lastupdate = 0
	local rs, ls, rh, lh = {V = 0, D = 0, C = 0}, {V = 0, D = 0, C = 0}, {V = 0, D = 0, C = 0}, {V = 0, D = 0, C = 0}

	m.Init = function(figure: Model)
		local hum = figure:FindFirstChild("Humanoid")
		hum.AutoRotate = true
		hum:SetStateEnabled(Enum.HumanoidStateType.Climbing, false)
		hum:ChangeState(Enum.HumanoidStateType.Freefall)
		sndpoint = Instance.new("Attachment")
		sndpoint.Name = "oldrobloxsound"
		sndpoint.Parent = hum.Torso
		local function makesound(name, id)
			local sound = Instance.new("Sound")
			sound.SoundId = id
			sound.Parent = sndpoint
			sound.Volume = 5
			sound.Name = name
			return sound
		end
		makesound("Running", "rbxasset://sounds/bfsl-minifigfoots1.mp3").Looped = true
		makesound("Climbing", "rbxasset://sounds/bfsl-minifigfoots1.mp3").Looped = true
		makesound("GettingUp", "rbxasset://sounds/hit.wav")
		local f = makesound("Freefall", "rbxassetid://12222200")
		makesound("FallingDown", "rbxasset://sounds/splat.wav")
		local j = makesound("Jumping", "rbxasset://sounds/button.wav")
		j.Played:Connect(function()
			task.wait(0.12 + math.random() * 0.08)
			j:Stop()
		end)
		hrun = hum.Running:Connect(function(speed)
			if speed > 0.2 then
				pose = "Running"
			else
				pose = "Standing"
			end
		end)
		hstatechange = hum.StateChanged:Connect(function(old, new)
			local state = new.Name
			if state == "Jumping" then
				pose = "Jumping"
				canClimb = true
				hum.AutoRotate = false
				hipHeight = -1
			elseif state == "Freefall" then
				pose = "Freefall"
				canClimb = true
				hum.AutoRotate = false
				hipHeight = -1
			elseif state == "Landed" then
				pose = "Freefall"
				canClimb = true
				local vel = hum.Torso.Velocity
				local power = -vel.Y / 2
				if power > 30 then
					hum.Torso.Velocity = Vector3.new(vel.X, power, vel.Z)
					hum.Torso.RotVelocity = rng:NextUnitVector() * power * 0.5
					if power > 100 then
						hum:ChangeState(Enum.HumanoidStateType.Ragdoll)
					else
						hum:ChangeState(Enum.HumanoidStateType.Freefall)
					end
				end
				hum.AutoRotate = false
				hipHeight = -1
				f:Play()
			elseif state == "Seated" then
				pose = "Seated"
				canClimb = false
			elseif state == "Swimming" then
				pose = "Running"
				canClimb = false
			elseif state == "Running" then
				canClimb = true
			elseif state == "PlatformStand" then
				pose = "Standing"
				canClimb = false
			elseif state == "GettingUp" then
				pose = "GettingUp"
				canClimb = false
				hum.AutoRotate = false
				hum.HipHeight = -1
			elseif state == "Ragdoll" then
				pose = "Running"
				canClimb = false
			elseif state == "FallingDown" then
				pose = "FallingDown"
				canClimb = false
			else
				pose = "Standing"
				canClimb = false
			end
		end)
		climbforce = Instance.new("BodyVelocity")
		climbforce.Name = "ClimbForce"
		climbforce.Parent = nil
	end
	m.Update = function(dt: number, figure: Model)
		local t = os.clock()

		rcp.FilterDescendantsInstances = {figure}

		local scale = figure:GetScale()

		local hum = figure:FindFirstChild("Humanoid")
		if not hum then return end
		local root = figure:FindFirstChild("HumanoidRootPart")
		if not root then return end
		local torso = figure:FindFirstChild("Torso")
		if not torso then return end

		if lastpose ~= pose then
			local snd1 = sndpoint:FindFirstChild(lastpose)
			local snd2 = sndpoint:FindFirstChild(pose)
			if snd1 and snd1.Looped then snd1:Stop() end
			if snd2 then
				if pose == "Freefall" then
					task.delay(0.15, snd2.Play, snd2)
				else
					snd2:Play()
				end
			end
			lastpose = pose
		end

		local function getTool()
			for _, kid in figure:GetChildren() do
				if kid.className == "Tool" then
					return kid
				end
			end
			return nil
		end

		local function getToolAnim(tool)
			for _, c in tool:GetChildren() do
				if c.Name == "toolanim" and c.ClassName == "StringValue" then
					return c
				end
			end
			return nil
		end

		local climbing = canClimb and findLadder(figure, root, hum)
		local jumping = pose == "Jumping" or pose == "Freefall"

		local climbforced = false
		local climbspeed = hum.WalkSpeed * 0.7
		if climbing then
			if hum.MoveDirection.Magnitude > 0 then
				climbforce.Velocity = Vector3.new(0, climbspeed, 0)
				climbforced = true
			elseif jumping then
				climbforce.Velocity = Vector3.new(0, -climbspeed, 0)
				climbforced = true
			end
		end
		if climbforced then
			climbforce.MaxForce = Vector3.new(climbspeed * 100, 10e6, climbspeed * 100)
			climbforce.Parent = root
		else
			climbforce.Parent = nil
		end

		if not climbing and (jumping or hipHeight < -0.01) then
			if not jumping then
				hipHeight *= math.exp(-16 * dt)
			end
			hum.JumpPower = 0
			rs.V = 0.5
			ls.V = 0.5
			rs.D = 3.14
			ls.D = -3.14
			rh.V = 0.5
			lh.V = 0.5
			rh.D = 0
			lh.D = 0
		elseif pose == "Seated" then
			rs.V = 0.15
			ls.V = 0.15
			rs.D = 1.57
			ls.D = -1.57
			rh.V = 0.15
			lh.V = 0.15
			rh.D = 1.57
			lh.D = -1.57
		else
			hum.AutoRotate = true
			hum.JumpPower = 50

			local amplitude = 1
			local frequency = 9
			local climbFudge = 0

			if climbing then
				rs.V = 0.5
				ls.V = 0.5
				rh.V = 0.1
				lh.V = 0.1
				climbFudge = 3.14
			elseif pose == "Running" then
				rs.V = 0.15
				ls.V = 0.15
				rh.V = 0.1
				lh.V = 0.1
			else
				amplitude = 0.1
				frequency = 1
			end

			local desiredAngle = amplitude * math.sin(t * frequency)
			rs.D = desiredAngle + climbFudge
			ls.D = desiredAngle - climbFudge
			rh.D = -desiredAngle
			lh.D = -desiredAngle

			local tool = getTool()
			if tool and tool.RequiresHandle then
				local msg = getToolAnim(tool)
				if msg then
					toolAnim = msg.Value
					msg:Destroy()
					toolAnimTime = t + 0.3
				end
				if t > toolAnimTime then
					toolAnimTime = 0
					toolAnim = "None"
				end
				if toolAnim == "None" then
					rs.D = 1.57
				elseif toolAnim == "Slash" then
					rs.V = 0.5
					rs.D = 0
				elseif toolAnim == "Lunge" then
					rs.V = 0.5
					ls.V = 0.5
					rs.D = 1.57
					ls.D = 1
					rh.V = 0.5
					lh.V = 0.5
					rh.D = 1.57
					lh.D = 1
				end
			else
				toolAnim = "None"
				toolAnimTime = 0
			end
		end
		hum.HipHeight = hipHeight * scale

		local rj = root:FindFirstChild("RootJoint")
		local nj = torso:FindFirstChild("Neck")
		local rsj = torso:FindFirstChild("Right Shoulder")
		local lsj = torso:FindFirstChild("Left Shoulder")
		local rhj = torso:FindFirstChild("Right Hip")
		local lhj = torso:FindFirstChild("Left Hip")

		local function stepjoint(a, b, c)
			local d = a.D - a.C
			if math.abs(d) < a.V then
				a.C = a.D
			elseif d > 0 then
				a.C += a.V * 30 * c
			else
				a.C -= a.V * 30 * c
			end
			local e = a.C
			if m.Snap then
				local snap = math.pi / 90
				e = math.round(a.C / snap) * snap
			end
			b.Transform = CFrame.Angles(0, 0, e)
		end

		local delta = 1 / 30
		if not m.FPS30 then
			lastupdate = 0
			delta = dt
		end

		if t - lastupdate > 1 / 30 then
			lastupdate = t
			rj.Transform = CFrame.identity
			nj.Transform = CFrame.identity
			stepjoint(rs, rsj, delta)
			stepjoint(ls, lsj, delta)
			stepjoint(rh, rhj, delta)
			stepjoint(lh, lhj, delta)
		end
	end
	m.Destroy = function(figure: Model?)
		hstatechange:Disconnect()
		hrun:Disconnect()
		sndpoint:Destroy()
		climbforce:Destroy()
	end
	return m
end)

return modules