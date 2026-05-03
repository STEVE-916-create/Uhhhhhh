# Uhhhhhh - Universal Hierarchical 6 Reanimator

A Roblox Lua scripting project featuring a reanimation/animation script with UI, dances, movesets, hat dropping, and modding support.

## Project Overview

This is **not a web application**. It is a Roblox exploit/script project written in Lua, designed to be loaded into Roblox via a loadstring. It has no web server, frontend, or backend.

## Project Structure

- `source/reanim.lua` - Main Roblox Lua script (~9600+ lines). The core reanimation script loaded into Roblox.
- `source/reanim_bak.lua` - Backup of the main script.
- `content/` - Animation files (`.anim`), audio files (`.mp3`), and Lua variant files for dances/movesets.
- `community/` - Community-contributed content and dance files.
- `uiassets/` - UI audio and graphic assets used by the script.
- `goodies/convertion.lua` - Utility Lua script for conversions.
- `tools/` - Python and Lua utility tools:
  - `allinone.py` - All-in-one processing script (AI-assisted).
  - `getassetids.py` - Tool to extract Roblox asset IDs.
  - `rbxm2anim.py` - Converts `.rbxm` (Roblox model) files to `.anim` format.
  - `lua2rbxmx.lua` - Converts Lua animation data to `.rbxmx` format.
  - `verify.lua` - Verifies animation buffer data.
- `images/` - Screenshots and GIF showcases.

## Languages & Runtimes

- **Lua 5.2** - Main scripting language (Roblox uses a Luau dialect, but tools use Lua 5.2)
- **Python 3.12** - Used for conversion/utility tools

## How to Use

### Running the script in Roblox
Use one of these loadstrings in a Roblox exploit executor:

```lua
-- Cached (via GitHub raw):
loadstring(game:HttpGet("https://raw.githubusercontent.com/STEVE-916-create/Uhhhhhh/main/source/reanim.lua"))()

-- Non-cached (via GitHub API):
local a,b,c,g="/STEVE-916-create/Uhhhhhh/","/source/reanim.lua",".github","https://"local d=request({Url=`{g}api{c}.com/repos{a}contents{b}`,Headers={Accept=`application/vnd{c}.VERSION.raw`}})if d.StatusCode~=200 then d.Body=game:HttpGet(`{g}raw{c}usercontent.com{a}main{b}`)end local e,f=loadstring(d.Body)if not e then warn(f)else e()end
```

### Using Python tools
```bash
python3 tools/rbxm2anim.py   # Convert Roblox model to anim
python3 tools/getassetids.py # Extract asset IDs
python3 tools/allinone.py    # All-in-one processing
```

## Dependencies

- No external package dependencies
- Lua 5.2 (available at `/nix/store/.../bin/lua`)
- Python 3.12 standard library (zipfile, struct, base64, re, math, xml)

## Notes

- The script is designed to run inside Roblox's Luau environment, which provides Roblox-specific globals (`game`, `workspace`, `cloneref`, etc.) not available in standard Lua.
- The Python tools are standalone utilities for processing animation files offline.
