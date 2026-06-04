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

local Player = Players.LocalPlayer

local modules = {}
local function AddModule(m)
	table.insert(modules, m)
end

-- best to start with this!
AddModule(function()
	local m = {}
	m.ModuleType = "MOVESET"
	m.Name = "Station.31"
	m.Description = "I CANT FEEL MY FACE"
	m.Assets = {}

	local pose = 0

	m.Config = function(parent: GuiBase2d)
	end

	m.Init = function(figure: Model)
	  for i,v in figure:GetDescendants() do
	    if v:IsA("Accessory") then
	      for i,v in v:GetDescendants() do
	        if v:IsA("SpecialMesh") then
	          v:Destroy()
	        end
	      end
	    end
	  end
	  task.spawn(function()
	    while true do
	      pose = 1
	      wait(2)
	      pose = 0
	      wait(2)
	    end
	  end)
	end
	m.Update = function(dt: number, figure: Model)
		local timingsine = os.clock(16)
		local rt, nt, rst, lst, rht, lht = CFrame.identity, CFrame.identity, CFrame.identity, CFrame.identity, CFrame.identity, CFrame.identity
		
		local hum = figure:FindFirstChild("Humanoid")
		if not hum then return end
		local root = figure:FindFirstChild("HumanoidRootPart")
		if not root then return end
		local torso = figure:FindFirstChild("Torso")
		if not torso then return end
		local joints = {
		  r = root:FindFirstChild("RootJoint"),
		  n = torso:FindFirstChild("Neck"),
		  rs = torso:FindFirstChild("Right Shoulder"),
		  ls = torso:FindFirstChild("Left Shoulder"),
		  rh = torso:FindFirstChild("Right Hip"),
		  lh = torso:FindFirstChild("Left Hip")
		}
		
		local alpha = math.exp(-8*dt)
		
		if pose == 0 then
		  rt = CFrame.Angles(-1.919 + -0.017 * math.sin(timingsine * 500 + 3.628), -0.017 * math.sin(timingsine * 500 + 2.654), 3.141 + -0.017 * math.sin(timingsine * 500 + 3.628))
	nt = CFrame.new(0, 1, 0) * CFrame.Angles(-1.745 + 0.017 * math.sin(timingsine * 500 + 3.628), 0.017 * math.sin(timingsine * 500 + 2.654), 3.141 + 0.017 * math.sin(timingsine * 500 + 3.628))
	rst = CFrame.new(0.65, 0.5, 0) * CFrame.Angles(3.577 + 0.017 * math.sin(timingsine * 500 + 3.628), 0.785 + 0.017 * math.sin(timingsine * 500 + 2.654), -1.221 + 0.017 * math.sin(timingsine * 500 + 3.628))
	lst = CFrame.new(-0.65, 0.5, 0) * CFrame.Angles(3.665 + 0.017 * math.sin(timingsine * 500 + 3.628), -0.785 + 0.017 * math.sin(timingsine * 500 + 2.654), 1.221 + 0.017 * math.sin(timingsine * 500 + 3.628))
	rht = CFrame.new(1, -1, -0.25) * CFrame.Angles(0.349 + 0.017 * math.sin(timingsine * 500 + 3.628), 1.221 + 0.017 * math.sin(timingsine * 500 + 2.654), 0.017 * math.sin(timingsine * 500 + 3.628))
	lht = CFrame.new(-1, -1, -0.25) * CFrame.Angles(0.349 + 0.017 * math.sin(timingsine * 500 + 3.628), -1.221 + 0.017 * math.sin(timingsine * 500 + 2.654), 0.017 * math.sin(timingsine * 500 + 3.628))
		end
		
		if pose == 1 then
		  rt = CFrame.Angles(-1.396 + -0.017 * math.sin(timingsine * 500 + 3.628), -0.017 * math.sin(timingsine * 500 + 2.654), 3.141 + -0.017 * math.sin(timingsine * 500 + 3.628))
	nt = CFrame.new(0, 1, 0) * CFrame.Angles(-1.745 + 0.017 * math.sin(timingsine * 500 + 3.628), 0.017 * math.sin(timingsine * 500 + 2.654), 3.141 + 0.017 * math.sin(timingsine * 500 + 3.628))
	rst = CFrame.new(0.65, 0.5, 0) * CFrame.Angles(3.577 + 0.017 * math.sin(timingsine * 500 + 3.628), 0.785 + 0.017 * math.sin(timingsine * 500 + 2.654), -1.221 + 0.017 * math.sin(timingsine * 500 + 3.628))
	lst = CFrame.new(-0.65, 0.5, 0) * CFrame.Angles(3.665 + 0.017 * math.sin(timingsine * 500 + 3.628), -0.785 + 0.017 * math.sin(timingsine * 500 + 2.654), 1.221 + 0.017 * math.sin(timingsine * 500 + 3.628))
	rht = CFrame.new(1, -1, -0.25) * CFrame.Angles(-0.174 + 0.017 * math.sin(timingsine * 500 + 3.628), 1.221 + 0.017 * math.sin(timingsine * 500 + 2.654), 0.017 * math.sin(timingsine * 500 + 3.628))
	lht = CFrame.new(-1, -1, -0.25) * CFrame.Angles(-0.174 + 0.017 * math.sin(timingsine * 500 + 3.628), -1.221 + 0.017 * math.sin(timingsine * 500 + 2.654), 0.017 * math.sin(timingsine * 500 + 3.628))
		end
		
		joints.r.C0 = rt:Lerp(joints.r.C0, alpha)
		joints.n.C0 = nt:Lerp(joints.n.C0, alpha)
		joints.rs.C0 = rst:Lerp(joints.rs.C0, alpha)
		joints.ls.C0 = lst:Lerp(joints.ls.C0, alpha)
		joints.rh.C0 = rht:Lerp(joints.rh.C0, alpha)
		joints.lh.C0 = lht:Lerp(joints.lh.C0, alpha)
	end
	m.Destroy = function(figure: Model?)
	end
	return m
end)

return modules
