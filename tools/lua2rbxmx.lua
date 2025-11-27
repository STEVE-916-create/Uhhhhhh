print("Loading file...")
local func = loadfile("filetoload.lua")
local env = getfenv(func)
local insts = {}
env.Enum = {
	PoseEasingStyle = {
		Linear = 0,
		Constant = 1,
		Elastic = 2,
		Cubic = 3,
		Bounce = 4,
		CubicV2 = 5,
	},
	PoseEasingDirection = {
		In = 0,
		Out = 1,
		InOut = 2,
	},
}
env.CFrame = {
	new = function(x, y, z, r00, r01, r02, r10, r11, r12, r20, r21, r22)
		return {x, y, z, r00, r01, r02, r10, r11, r12, r20, r21, r22}
	end
}
env.Instance = {
	new = function(classname)
		if classname == "KeyframeSequence" then
			local x = {
				Name = "KeyframeSequence",
				ClassName = "KeyframeSequence",
				Loop = true,
				Parent = nil
			}
			table.insert(insts, x)
			return x
		end
		if classname == "Keyframe" then
			local x = {
				Name = "Keyframe",
				ClassName = "Keyframe",
				Parent = nil,
				Time = 0
			}
			table.insert(insts, x)
			return x
		end
		if classname == "Pose" then
			local x = {
				Name = "Pose",
				ClassName = "Pose",
				Parent = nil,
				CFrame = {0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1},
				EasingStyle = 0,
				EasingDirection = 0,
				Weight = 1
			}
			table.insert(insts, x)
			return x
		end
		error("unknown instance " .. classname)
	end
}
print("Running file...")
local ks = func()
local e_style = {"Linear", "Constant", "Elastic", "Cubic", "Bounce", "CubicV2"}
local e_direc = {"In", "Out", "InOut"}
for _,inst in pairs(insts) do
	inst.Children = {}
	for _,x in pairs(insts) do
		if x ~= inst and x.Parent == inst then
			table.insert(inst.Children, x)
		end
	end
end
local function tablefind(a, b)
	for c, d in pairs(a) do
		if d == b then return c end
	end
end
local xml = {}
local function append(text)
	table.insert(xml, text)
end
append("<roblox xmlns:xmime=\"http://www.w3.org/2005/05/xmlmime\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xsi:noNamespaceSchemaLocation=\"http://www.roblox.com/roblox.xsd\" version=\"4\"><External>null</External><External>nil</External>")
local referents = {}
local function genreferent()
	local hex = {"0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "A", "B", "C", "D", "E", "F"}
	local str = "RBX"
	for _=1, 32 do
		str = str .. hex[math.random(1, #hex)]
	end
	if tablefind(referents, str) then return genreferent() end
	table.insert(referents, str)
	return str
end
local instcount = 0
local function serialize(inst)
	instcount = instcount + 1
	print("Converting instances: " .. instcount .. "/" .. #insts .. "; " .. (math.floor((instcount / #insts) * 10000) / 100) .. "%")
	append("<Item class=\"" .. inst.ClassName .. "\" referent=\"" .. genreferent() .. "\">")
	append("<Properties>")
	append("<BinaryString name=\"AttributesSerialize\"></BinaryString><SecurityCapabilities name=\"Capabilities\">0</SecurityCapabilities><bool name=\"DefinesCapabilities\">false</bool><string name=\"Name\">" .. inst.Name .. "</string><int64 name=\"SourceAssetId\">-1</int64><BinaryString name=\"Tags\"></BinaryString>")
	if inst.ClassName == "KeyframeSequence" then
		append("<float name=\"AuthoredHipHeight\">0</float><bool name=\"Loop\">true</bool><token name=\"Priority\">2</token>")
	end
	if inst.ClassName == "Keyframe" then
		append("<float name=\"Time\">" .. inst.Time .. "</float>")
	end
	if inst.ClassName == "Pose" then
		if type(inst.EasingStyle) == "string" then
			inst.EasingStyle = tablefind(e_style, inst.EasingStyle) - 1
		end
		if type(inst.EasingDirection) == "string" then
			inst.EasingDirection = tablefind(e_direc, inst.EasingDirection) - 1
		end
		append("<token name=\"EasingDirection\">" .. inst.EasingDirection .. "</token><token name=\"EasingStyle\">" .. inst.EasingStyle .. "</token>")
		append("<float name=\"Weight\">" .. inst.Weight .. "</float>")
		append("<CoordinateFrame name=\"CFrame\"><X>" .. inst.CFrame[1] .. "</X><Y>" .. inst.CFrame[2] .. "</Y><Z>" .. inst.CFrame[3] .. "</Z><R00>" .. inst.CFrame[4] .. "</R00><R01>" .. inst.CFrame[5] .. "</R01><R02>" .. inst.CFrame[6] .. "</R02><R10>" .. inst.CFrame[7] .. "</R10><R11>" .. inst.CFrame[8] .. "</R11><R12>" .. inst.CFrame[9] .. "</R12><R20>" .. inst.CFrame[10] .. "</R20><R21>" .. inst.CFrame[11] .. "</R21><R22>" .. inst.CFrame[12] .. "</R22></CoordinateFrame>")
	end
	append("</Properties>")
	for _,child in pairs(inst.Children) do
		serialize(child)
	end
	append("</Item>")
end
serialize(ks)
append("</roblox>")
local file = io.open("lua2rbxmx.rbxmx", "w")
file:write(table.concat(xml, ""))
file:close()
print("Convertion is successfully.")