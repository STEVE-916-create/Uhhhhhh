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

-- utils
local function SetC0C1Joint(j, c0, c1, scale)
	local t = c0 * c1:Inverse()
	t += t.Position * (scale - 1)
	t = j.C0:Inverse() * t * j.C1
	j.Transform = t
end

local modules = {}
local function AddModule(m)
	table.insert(modules, m)
end

AddModule(function()
	local m = {}
	m.ModuleType = "MOVESET"
	m.Name = "Patchma Hub"
	m.Description = "A port of MyWorld's hub to Uhhhhhh\nsee the configurations to set ur anims"
	m.Assets = {}

	local emptyfunction = function() end
	local sine = 0
	local deltaTime = 0
	local Lerp = CFrame.identity.Lerp
	local cfMul = function(a, b) return a * b end
	local cf = CFrame.new
	local angles = CFrame.fromEulerAnglesXYZ
	local v2 = Vector2.new 
	local v3 = Vector3.new
	local mrandom = math.random
	local sin = math.sin
	local cos = math.cos
	local abs = math.abs
	local min = math.min
	local max = math.max
	local clamp = math.clamp
	local round = math.round
	local cf_0 = CFrame.identity
	local twait = task.wait

	local animatorcfg
	local function animatorreset()
		animatorcfg = {
			-- val, sinval, sinspeed, sinoff
			RootJoint = {
				x = {0, 0, 1, 0},
				y = {0, 0, 1, 0},
				z = {0, 0, 1, 0},
				rx = {-90, 0, 1, 0},
				ry = {0, 0, 1, 0},
				rz = {180, 0, 1, 0},
			},
			Neck = {
				x = {0, 0, 1, 0},
				y = {1, 0, 1, 0},
				z = {0, 0, 1, 0},
				rx = {-90, 0, 1, 0},
				ry = {0, 0, 1, 0},
				rz = {180, 0, 1, 0},
			},
			RightShoulder = {
				x = {1, 0, 1, 0},
				y = {0.5, 0, 1, 0},
				z = {0, 0, 1, 0},
				rx = {0, 0, 1, 0},
				ry = {90, 0, 1, 0},
				rz = {0, 0, 1, 0},
			},
			LeftShoulder = {
				x = {-1, 0, 1, 0},
				y = {0.5, 0, 1, 0},
				z = {0, 0, 1, 0},
				rx = {0, 0, 1, 0},
				ry = {-90, 0, 1, 0},
				rz = {0, 0, 1, 0},
			},
			RightHip = {
				x = {1, 0, 1, 0},
				y = {-1, 0, 1, 0},
				z = {0, 0, 1, 0},
				rx = {0, 0, 1, 0},
				ry = {90, 0, 1, 0},
				rz = {0, 0, 1, 0},
			},
			LeftHip = {
				x = {-1, 0, 1, 0},
				y = {-1, 0, 1, 0},
				z = {0, 0, 1, 0},
				rx = {0, 0, 1, 0},
				ry = {-90, 0, 1, 0},
				rz = {0, 0, 1, 0},
			},
			speed = 16,
			change = 1,
		}
	end
	animatorreset()

	local anims = {
		function(t)
			local getJoint=t.getJoint
			local rootJoint=getJoint("RootJoint")
			local rightShoulder=getJoint("Right Shoulder")
			local leftShoulder=getJoint("Left Shoulder")
			local rightHip=getJoint("Right Hip")
			local leftHip=getJoint("Left Hip")
			local neck=getJoint("Neck")
		
			t.setWalkSpeed(10)
		
			local euler=angles
			local jumplerp=function()
				local sine=sine*60
				neck.C0 = Lerp(neck.C0,cfMul(cf(0,0,0.5), euler(0,0,3.141592653589793)),deltaTime) 
				rootJoint.C0 = Lerp(rootJoint.C0,cfMul(cf(0,-1.4,0), euler(3.141592653589793,0,-3.141592653589793)),deltaTime) 
				leftShoulder.C0 = Lerp(leftShoulder.C0,cfMul(cf(-1,1.5,0.3), euler(1.7453292519943295,0,-0.17453292519943295)),deltaTime) 
				rightShoulder.C0 = Lerp(rightShoulder.C0,cfMul(cf(1,1.5,0.3), euler(1.7453292519943295,0,0.17453292519943295)),deltaTime) 
				leftHip.C0 = Lerp(leftHip.C0,cfMul(cf(-1,-1.5,0.8), euler(1.3962634015954636,0,-0.17453292519943295)),deltaTime) 
				rightHip.C0 = Lerp(rightHip.C0,cfMul(cf(1,-1.5,0.8), euler(1.3962634015954636,0,0.17453292519943295)),deltaTime)
			end
		
			t.addmode("default",{
				idle=function()
					local sine=sine*60
					neck.C0 = Lerp(neck.C0,cfMul(cf(0,0,0.5), euler(0.08726646259971647 * sin((sine + 20) * 0.05),0,3.141592653589793 + 0.3490658503988659 * sin((sine + -30) * 0.025))),deltaTime) 
					rootJoint.C0 = Lerp(rootJoint.C0,cfMul(cf(0,-1.5 + 0.1 * sin(sine * 0.05),0), euler(3.141592653589793,0,-3.1590459461097367 + 0.05235987755982989 * sin(sine * 0.025))),deltaTime) 
					leftShoulder.C0 = Lerp(leftShoulder.C0,cfMul(cf(-1,1.5,-0.1 * sin(sine * 0.05)), euler(1.5707963267948966,0,0.08726646259971647 * sin(sine * 0.025))),deltaTime) 
					rightShoulder.C0 = Lerp(rightShoulder.C0,cfMul(cf(1,1.5,-0.1 * sin(sine * 0.05)), euler(1.5707963267948966,0,0.08726646259971647 * sin(sine * 0.025))),deltaTime) 
					leftHip.C0 = Lerp(leftHip.C0,cfMul(cf(-1,-1.5,0.5 + -0.1 * sin((sine + 10) * 0.05)), euler(1.5707963267948966,0,0.08726646259971647 * sin(sine * 0.025))),deltaTime) 
					rightHip.C0 = Lerp(rightHip.C0,cfMul(cf(1,-1.5,0.5 + -0.1 * sin((sine + 10) * 0.05)), euler(1.5707963267948966,0,0.08726646259971647 * sin(sine * 0.025))),deltaTime) 
				end,
				walk=function()
					local sine=sine*60
					neck.C0 = Lerp(neck.C0,cfMul(cf(0,0,0.5), euler(0.17453292519943295,0.03490658503988659 * sin((sine + 2.5) * 0.2),3.141592653589793 + -0.17453292519943295 * sin((sine + -10) * 0.2))),deltaTime) 
					rootJoint.C0 = Lerp(rootJoint.C0,cfMul(cf(0,-1.5,0), euler(3.0543261909900767,0.08726646259971647 * sin((sine + 7.5) * 0.2),-3.1590459461097367 + -0.08726646259971647 * sin(sine * 0.2))),deltaTime) 
					leftShoulder.C0 = Lerp(leftShoulder.C0,cfMul(cf(-1,1.5 + 0.5 * sin((sine + 10) * 0.2),0.3 + 0.2 * sin((sine + -10) * 0.2)), euler(1.6580627893946132 + 0.17453292519943295 * sin((sine + 15) * 0.2),0,-0.08726646259971647 * sin(sine * 0.2))),deltaTime) 
					rightShoulder.C0 = Lerp(rightShoulder.C0,cfMul(cf(1,1.5 + 0.5 * sin((sine + -7.5) * 0.2),0.3 + 0.2 * sin((sine + 5) * 0.2)), euler(1.6580627893946132 + 0.17453292519943295 * sin(sine * 0.2),0,-0.08726646259971647 * sin(sine * 0.2))),deltaTime) 
					leftHip.C0 = Lerp(leftHip.C0,cfMul(cf(-1,-1.5 + 0.5 * sin((sine + -7.5) * 0.2),0.5 + 0.2 * sin((sine + 5) * 0.2)), euler(1.6580627893946132 + 0.17453292519943295 * sin(sine * 0.2),0,-0.08726646259971647 * sin(sine * 0.2))),deltaTime) 
					rightHip.C0 = Lerp(rightHip.C0,cfMul(cf(1,-1.5 + 0.5 * sin((sine + 10) * 0.2),0.5 + 0.2 * sin((sine + -7.5) * 0.2)), euler(1.6580627893946132 + -0.17453292519943295 * sin(sine * 0.2),0,-0.08726646259971647 * sin(sine * 0.2))),deltaTime) 
				end,
				jump=jumplerp,
				fall=jumplerp
			})
		end,
		function(t)
			local raycastlegs=t.raycastlegs
			local velbycfrvec=t.velbycfrvec
			local addmode=t.addmode
			local getJoint=t.getJoint
			local velYchg=t.velYchg
			local setWalkSpeed=t.setWalkSpeed
			local RootJoint=getJoint("RootJoint")
			local RightShoulder=getJoint("Right Shoulder")
			local LeftShoulder=getJoint("Left Shoulder")
			local RightHip=getJoint("Right Hip")
			local LeftHip=getJoint("Left Hip")
			local Neck=getJoint("Neck")
		
			addmode("default", {
				idle = function()
					local rY, lY = raycastlegs()
		
					local Ychg=velYchg()/20
		
					LeftShoulder.C0=Lerp(LeftShoulder.C0,cfMul(cf(-1,0.5+0.1*sin((sine - 1)*1.3),0.05 * sin((sine-0.3)*1.3)),angles(0.5235987755982988+0.08726646259971647*sin(sine*1),-1.4835298641951802+0.10471975511965978*sin(sine*1.3),0.5235987755982988)),deltaTime) 
					RightShoulder.C0=Lerp(RightShoulder.C0,cfMul(cf(1,0.5+0.1*sin((sine - 1)*1.3),0.05 * sin((sine-0.3)*1.3)),angles(0.5235987755982988+0.08726646259971647*sin(sine*1),1.4835298641951802-0.10471975511965978*sin(sine*1.3),-0.5235987755982988)),deltaTime) 
					LeftHip.C0=Lerp(LeftHip.C0,cfMul(cf(-1,-1.09-0.1*sin(sine*1.3)+lY-Ychg,lY*-0.5),angles(-0.026179938779914945*sin(sine*1.3),-1.3962634015954636,0)),deltaTime) 
					RightHip.C0=Lerp(RightHip.C0,cfMul(cf(1,-1.09-0.1*sin(sine*1.3)+rY-Ychg,rY*-0.5),angles(-0.026179938779914945*sin(sine*1.3),1.3962634015954636,0)),deltaTime) 
					RootJoint.C0=Lerp(RootJoint.C0,cfMul(cf(0,0.09+0.1*sin(sine*1.3) + Ychg,0.025 * sin(sine*1.3)),angles(-1.5707963267948966+0.026179938779914945*sin(sine*1.3),0,3.141592653589793)),deltaTime) 
					Neck.C0=Lerp(Neck.C0,cfMul(cf(0,1,0),angles(-1.53588974175501-0.026179938779914945*sin((sine+1)*1.3),0.05235987755982989*sin((sine-0.6)*0.65),3.141592653589793)),deltaTime) 
					--MW_animatorProgressSave: LeftArm,-1,0,0,1,30,5,0,1,0.5,0.1,-1,1.3,-85,6,0,1.3,0,0.05,-0.3,1.3,30,0,0,1,RightArm,1,0,0,1,30,5,0,1,0.5,0.1,-1,1.3,85,-6,0,1.3,0,0.05,-0.3,1.3,-30,0,0,1,LeftLeg,-1,0,0,1,-0,-1.5,0,1.3,-1.09,-0.1,0,1.3,-80,0,0,1,0,0,0,1,0,0,0,1,CPlusPlusTextbook_Handle,8.658389560878277e-09,0,0,1,0,0,0,1,-0.25,0,0,1,0,0,0,1,-0.0002722442150115967,0,0,1,0,0,0,1,RightLeg,1,0,0,1,0,-1.5,0,1.3,-1.09,-0.1,0,1.3,80,0,0,1,0,0,0,1,0,0,0,1,Torso,0,0,0,1,-90,1.5,0,1.3,0.09,0.1,0,1.3,-0,0,0,1,0,0.025,0,1.3,180,0,0,1,Head,0,0,0,1,-88,-1.5,1,1.3,1,0,0,1,-0,3,-0.6,0.65,0,0,0,1,180,0,0,1
				end,
				walk = function()
					local Vfw, Vrt = velbycfrvec()
		
					local rY, lY = raycastlegs()
		
					local Ychg=velYchg()/20
		
					LeftShoulder.C0=Lerp(LeftShoulder.C0,cfMul(cf(-1,0.5,0),angles(-0.7853981633974483*sin((sine+0.07)*8)*Vfw,-1.5707963267948966+0.5235987755982988*sin((sine+0.15)*8),0)),deltaTime) 
					RightShoulder.C0=Lerp(RightShoulder.C0,cfMul(cf(1,0.5,0),angles(0.7853981633974483*sin((sine+0.07)*8)*Vfw,1.5707963267948966+0.5235987755982988*sin((sine+0.15)*8),0)),deltaTime) 
					RightHip.C0=Lerp(RightHip.C0,cfMul(cf(1,-1+0.3*sin((sine - 0.15)*8)+rY-Ychg,rY*-0.5),angles(1.5707963267948966-0.9599310885968813*sin(sine*8)*Vfw,1.5707963267948966-0.7853981633974483*sin(sine*8)*Vrt,-1.5707963267948966)),deltaTime) 
					LeftHip.C0=Lerp(LeftHip.C0,cfMul(cf(-1,-1+0.3*sin((sine + 0.15)*8)+lY-Ychg,lY*-0.5),angles(1.5707963267948966+0.9599310885968813*sin(sine*8)*Vfw,-1.5707963267948966+0.7853981633974483*sin(sine*8)*Vrt,1.5707963267948966)),deltaTime) 
					Neck.C0=Lerp(Neck.C0,cfMul(cf(0,1,0),angles(-1.5707963267948966+0.08726646259971647*sin(sine*16),0,3.141592653589793+0.08726646259971647*sin((sine+0.04)*8)-Vrt)),deltaTime) 
					RootJoint.C0=Lerp(RootJoint.C0,cfMul(cf(0,0.2 * sin((sine+0.1)*16) + Ychg,0),angles(-1.5707963267948966,0,3.141592653589793)),deltaTime) 
					--MW_animatorProgressSave: CPlusPlusTextbook_Handle,8.658389560878277e-09,0,0,8,0,0,0,8,-0.25,0,0,8,0,0,0,8,-0.0002722442150115967,0,0,8,0,0,0,8,LeftArm,-1,0,0,8,-0,-45,0.07,8,0.5,0,0,8,-90,30,0.15,8,0,0,0,8,0,0,0,8,RightArm,1,0,0,8,0,45,0.07,8,0.5,0,0,8,90,30,0.15,8,0,0,0,8,0,0,0,8,RightLeg,1,0,0,8,90,-55,0,8,-1,0.3,-0.15,8,90,-45,0,8,0,0,0,8,-90,0,0,8,LeftLeg,-1,0,0,8,90,55,0,8,-1,0.3,0.15,8,-90,45,0,8,0,0,0,8,90,0,0,8,Head,0,0,0,8,-90,5,0,16,1,0,0,8,-0,0,0,8,0,0,0,8,180,5,0.04,8,Torso,0,0,0,8,-90,0,0,8,0,0.2,0.1,16,-0,0,0,8,0,0,0,8,180,0,0,8
				end,
				jump = function()
					velYchg()
					local Vfw, Vrt = velbycfrvec()
					RootJoint.C0 = Lerp(RootJoint.C0,cfMul(cf_0,angles(-1.4835298641951802 + Vfw * 0.1, Vrt * -0.05, -3.141592653589793)),deltaTime) 
					RightShoulder.C0 = Lerp(RightShoulder.C0,cfMul(cf(1, 0.5, 0),angles(4.014257279586958 - 0.08726646259971647 * sin((sine + 0.5) * 4), 1.7453292519943295 + 0.08726646259971647 * sin((sine + 0.25) * 4), -1.5707963267948966)),deltaTime) 
					LeftHip.C0 = Lerp(LeftHip.C0,cfMul(cf(-1, -1, 0),angles(1.5707963267948966 - 0.08726646259971647 * sin((sine + 0.5) * 4), -1.6580627893946132 + 0.06981317007977318 * sin((sine + 0.25) * 4), 1.5707963267948966)),deltaTime) 
					LeftShoulder.C0 = Lerp(LeftShoulder.C0,cfMul(cf(-1, 0.5, 0),angles(4.014257279586958 - 0.08726646259971647 * sin((sine + 0.5) * 4), -1.7453292519943295 - 0.08726646259971647 * sin((sine + 0.25) * 4), 1.5707963267948966)),deltaTime) 
					Neck.C0 = Lerp(Neck.C0,cfMul(cf(0, 1, 0),angles(-1.3962634015954636, 0, -3.141592653589793 - Vrt)),deltaTime) 
					RightHip.C0 = Lerp(RightHip.C0,cfMul(cf(1, -1, 0),angles(1.5707963267948966 - 0.08726646259971647 * sin((sine + 0.5) * 4), 1.6580627893946132 - 0.06981317007977318 * sin((sine + 0.25) * 4), -1.5707963267948966)),deltaTime) 
					--Torso,0,0,0,4,-85,0,0,4,0,0,0,4,0,0,0,4,0,0,0,4,-180,0,0,4,RightArm,1,0,0,4,230,-5,0.5,4,0.5,0,0,4,100,5,0.25,4,0,0,0,4,-90,0,0,4,LeftLeg,-1,0,0,4,90,-5,0.5,4,-1,0,0,4,-95,4,0.25,4,0,0,0,4,90,0,0,4,LeftArm,-1,0,0,4,230,-5,0.5,4,0.5,0,0,4,-100,-5,0.25,4,0,0,0,4,90,0,0,4,Head,0,0,0,4,-80,0,0.5,4,1,0,0,4,0,0,0.25,4,0,0,0,4,-180,0,0,4,RightLeg,1,0,0,4,90,-5,0.5,4,-1,0,0,4,95,-4,0.25,4,0,0,0,4,-90,0,0,4
				end,
				fall = function()
					velYchg()
					local Vfw, Vrt = velbycfrvec()
					RootJoint.C0 = Lerp(RootJoint.C0,cfMul(cf_0,angles(-1.6580627893946132 + Vfw * 0.1, Vrt * -0.05, -3.141592653589793)),deltaTime) 
					RightShoulder.C0 = Lerp(RightShoulder.C0,cfMul(cf(1, 0.5, 0),angles(4.014257279586958 - 0.08726646259971647 * sin((sine + 0.5) * 4), 1.7453292519943295 + 0.08726646259971647 * sin((sine + 0.25) * 4), -1.5707963267948966)),deltaTime) 
					LeftHip.C0 = Lerp(LeftHip.C0,cfMul(cf(-1, -1, 0),angles(1.5707963267948966 - 0.08726646259971647 * sin((sine + 0.5) * 4), -1.6580627893946132 + 0.06981317007977318 * sin((sine + 0.25) * 4), 1.5707963267948966)),deltaTime) 
					LeftShoulder.C0 = Lerp(LeftShoulder.C0,cfMul(cf(-1, 0.5, 0),angles(4.014257279586958 - 0.08726646259971647 * sin((sine + 0.5) * 4), -1.7453292519943295 - 0.08726646259971647 * sin((sine + 0.25) * 4), 1.5707963267948966)),deltaTime) 
					Neck.C0 = Lerp(Neck.C0,cfMul(cf(0, 1, 0),angles(-1.7453292519943295, 0, -3.141592653589793 - Vrt)),deltaTime) 
					RightHip.C0 = Lerp(RightHip.C0,cfMul(cf(1, -1, 0),angles(1.5707963267948966 - 0.08726646259971647 * sin((sine + 0.5) * 4), 1.6580627893946132 - 0.06981317007977318 * sin((sine + 0.25) * 4), -1.5707963267948966)),deltaTime) 
					--Torso,0,0,0,4,-95,0,0,4,0,0,0,4,0,0,0,4,0,0,0,4,-180,0,0,4,RightArm,1,0,0,4,230,-5,0.5,4,0.5,0,0,4,100,5,0.25,4,0,0,0,4,-90,0,0,4,LeftLeg,-1,0,0,4,90,-5,0.5,4,-1,0,0,4,-95,4,0.25,4,0,0,0,4,90,0,0,4,LeftArm,-1,0,0,4,230,-5,0.5,4,0.5,0,0,4,-100,-5,0.25,4,0,0,0,4,90,0,0,4,Head,0,0,0,4,-100,0,0.5,4,1,0,0,4,0,0,0.25,4,0,0,0,4,-180,0,0,4,RightLeg,1,0,0,4,90,-5,0.5,4,-1,0,0,4,95,-4,0.25,4,0,0,0,4,-90,0,0,4
				end
			})
		
			addmode("q", {
				idle = function()
					velYchg()
					LeftShoulder.C0 = Lerp(LeftShoulder.C0,cfMul(cf(-1, 0.75, -0.2),angles(2.705260340591211 - 0.08726646259971647 * sin((sine + 0.1) * 2), -2.792526803190927, -0.6981317007977318)),deltaTime) 
					RightShoulder.C0 = Lerp(RightShoulder.C0,cfMul(cf(1, 0.75, -0.2),angles(2.705260340591211 - 0.08726646259971647 * sin((sine + 0.1) * 2), 2.792526803190927, 0.6981317007977318)),deltaTime) 
					Neck.C0 = Lerp(Neck.C0,cfMul(cf(0, 1, 0),angles(-1.9198621771937625 - 0.10471975511965978 * sin((sine + 0.3) * 2), 0, 3.141592653589793)),deltaTime) 
					RootJoint.C0 = Lerp(RootJoint.C0,cfMul(cf(0, -2.45 - 0.05 * sin(sine * 2), 0),angles(0.03490658503988659 * sin(sine * 2), 0, 3.141592653589793)),deltaTime) 
					RightHip.C0 = Lerp(RightHip.C0,cfMul(cf(1, -1, 0),angles(1.3962634015954636 - 0.03490658503988659 * sin(sine * 2), 1.3089969389957472, -0.9599310885968813)),deltaTime) 
					LeftHip.C0 = Lerp(LeftHip.C0,cfMul(cf(-1, -1, 0),angles(1.5707963267948966 - 0.03490658503988659 * sin(sine * 2), -1.3089969389957472, 1.5707963267948966)),deltaTime) 
					--LeftArm,-1,0,0,2,155,-5,0.1,2,0.75,0,0,2,-160,0,0,2,-0.2,0,0,2,-40,0,0,2,RightArm,1,0,0,2,155,-5,0.1,2,0.75,0,0,2,160,0,0,2,-0.2,0,0,2,40,0,0,2,Head,0,0,0,2,-110,-6,0.3,2,1,0,0,2,-0,0,0,2,0,0,0,2,180,0,0,2,Torso,0,0,0,2,0,2,0,2,-2.45,-0.05,0,2,-0,0,0,2,0,0,0,2,180,0,0,2,RightLeg,1,0,0,2,80,-2,0,2,-1,0,0,2,75,0,0,2,0,0,0,2,-55,0,0,2,LeftLeg,-1,0,0,2,90,-2,0,2,-1,0,0,2,-75,0,0,2,0,0,0,2,90,0,0,2
				end
			})
			addmode("e", {
				idle = function()
					velYchg()
					LeftShoulder.C0 = Lerp(LeftShoulder.C0,cfMul(cf(-0.9, 0.4 + 0.1 * sin(sine * 2), 0.3 - 0.15 * sin(sine * 2)),angles(-1.0471975511965976 - 0.12217304763960307 * sin(sine * 2), -1.3962634015954636, -0.6981317007977318)),deltaTime) 
					RootJoint.C0 = Lerp(RootJoint.C0,cfMul(cf(0, -1.85 - 0.1 * sin((sine + 0.2) * 2), 0),angles(-1.3962634015954636 + 0.03490658503988659 * sin(sine * 2), -0.08726646259971647, 3.141592653589793)),deltaTime) 
					RightShoulder.C0 = Lerp(RightShoulder.C0,cfMul(cf(1, 0.4 + 0.1 * sin(sine * 2), 0.2 - 0.15 * sin(sine * 2)),angles(0.6108652381980153 - 0.12217304763960307 * sin(sine * 2), 1.2217304763960306, -0.7853981633974483)),deltaTime) 
					Neck.C0 = Lerp(Neck.C0,cfMul(cf(0, 1, 0),angles(-1.6580627893946132 - 0.03490658503988659 * sin((sine + 0.6) * 2), 0.10471975511965978 + 0.06981317007977318 * sin(sine * 0.66), 3.141592653589793 + 0.3490658503988659 * sin(sine * 0.66))),deltaTime) 
					RightHip.C0 = Lerp(RightHip.C0,cfMul(cf(1, 0.2 + 0.15 * sin((sine + 0.2) * 2), -0.7 + 0.1 * sin(sine * 2)),angles(1.4835298641951802 + 0.03490658503988659 * sin(sine * 2), 1.4835298641951802, -1.5707963267948966)),deltaTime) 
					LeftHip.C0 = Lerp(LeftHip.C0,cfMul(cf(-1, -0.75 + 0.1 * sin((sine + 0.2) * 2), -0.5),angles(1.3962634015954636 - 0.03490658503988659 * sin(sine * 2), -1.6580627893946132, 0)),deltaTime) 
					--LeftArm,-0.9,0,0,2,-60,-7,0,2,0.4,0.1,0,2,-80,0,0,2,0.3,-0.15,0,2,-40,0,0,2,Torso,0,0,0,2,-80,2,0,2,-1.85,-0.1,0.2,2,-5,0,0,2,0,0,0,2,180,0,0,2,RightArm,1,0,0,2,35,-7,0,2,0.4,0.1,0,2,70,0,0,2,0.2,-0.15,0,2,-45,0,0,2,Head,0,0,0,2,-95,-2,0.6,2,1,0,0,2,6,4,0,0.66,0,0,0,2,180,20,0,0.66,RightLeg,1,0,0,2,85,2,0,2,0.2,0.15,0.2,2,85,0,0,2,-0.7,0.1,0,2,-90,0,0,2,LeftLeg,-1,0,0,2,80,-2,0,2,-0.75,0.1,0.2,2,-95,0,0,2,-0.5,0,0,2,0,0,0,2
				end
			})
			addmode("r", {
				idle = function()
					local Ychg=velYchg()/20
					RightHip.C0 = Lerp(RightHip.C0,cfMul(cf(1, -0.9 - 0.2 * sin(sine * 2)-Ychg, 0),angles(1.5707963267948966, 1.6580627893946132 - 0.17453292519943295 * sin(sine + 0.8), -1.5707963267948966)),deltaTime) 
					RootJoint.C0 = Lerp(RootJoint.C0,cfMul(cf(0.3 * sin(sine + 0.8), -0.1 + 0.2 * sin(sine * 2)+Ychg, 0),angles(-1.5707963267948966, 0, -3.141592653589793)),deltaTime) 
					Neck.C0 = Lerp(Neck.C0,cfMul(cf(0, 1, 0),angles(-1.5707963267948966 + 0.08726646259971647 * sin((sine - 0.5) * 2), 0.08726646259971647 * sin(sine - 1), -3.141592653589793 + 0.2617993877991494 * sin(sine * 5))),deltaTime) 
					LeftShoulder.C0 = Lerp(LeftShoulder.C0,cfMul(cf(-1 + 0.1 * sin(sine * 7), 0.2 - 0.1 * sin(sine + 0.8), -0.25),angles(1.5707963267948966 + 0.5235987755982988 * sin(sine * 7), -0.6981317007977318, 0.3490658503988659 * sin(sine * 7))),deltaTime) 
					LeftHip.C0 = Lerp(LeftHip.C0,cfMul(cf(-1, -0.9 - 0.2 * sin(sine * 2)-Ychg, 0),angles(1.5707963267948966, -1.6580627893946132 - 0.17453292519943295 * sin(sine + 0.8), 1.5707963267948966)),deltaTime) 
					RightShoulder.C0 = Lerp(RightShoulder.C0,cfMul(cf(1 + 0.1 * sin(sine * 7), 0.2 + 0.1 * sin(sine + 0.8), -0.25),angles(1.5707963267948966 - 0.5235987755982988 * sin(sine * 7), 0.6981317007977318, 0.3490658503988659 * sin(sine * 7))),deltaTime) 
					--RightLeg,1,0,0,1,90,0,0,1,-0.9,-0.2,0,2,95,-10,0.8,1,0,0,0,1,-90,0,0,1,Torso,0,0.3,0.8,1,-90,0,0,1,-0.1,0.2,0,2,0,0,0,1,0,0,0,1,-180,0,0,1,Head,0,0,0,1,-90,5,-0.5,2,1,0,0,1,0,5,-1,1,0,0,0,1,-180,15,0,5,Fedora_Handle,8.657480066176504e-09,0,0,1,-6,0,0,1,-0.15052366256713867,0,0,1,0,0,0,1,-0.010221302509307861,0,0,1,0,0,0,1,LeftArm,-1,0.1,0,7,90,30,0,7,0.2,-0.1,0.8,1,-40,0,0,1,-0.25,0,0,1,0,20,0,7,LeftLeg,-1,0,0,1,90,0,0,1,-0.9,-0.2,0,2,-95,-10,0.8,1,0,0,0,1,90,0,0,1,RightArm,1,0.1,0,7,90,-30,0,7,0.2,0.1,0.8,1,40,0,0,1,-0.25,0,0,1,-0,20,0,7
				end
			})
			addmode("t", {
				idle = function()
					local Ychg=velYchg()/20
					LeftShoulder.C0 = Lerp(LeftShoulder.C0,cfMul(cf(-1, 0.5, 0),angles(1.5707963267948966, -1.6580627893946132 + 0.08726646259971647 * sin((sine - 0.3) * 4), 1.5707963267948966)),deltaTime) 
					RightShoulder.C0 = Lerp(RightShoulder.C0,cfMul(cf(1 + 0.15 * sin((sine - 0.4) * 4), 1.42, 0),angles(1.5707963267948966, 1.4835298641951802 - 0.3490658503988659 * sin((sine - 0.4) * 4), 1.5707963267948966)),deltaTime) 
					Neck.C0 = Lerp(Neck.C0,cfMul(cf(0, 1, 0),angles(-1.4835298641951802, 0.04363323129985824 - 0.08726646259971647 * sin((sine + 0.1) * 4), -3.141592653589793 + 0.04363323129985824 * sin(sine * 4))),deltaTime) 
					RootJoint.C0 = Lerp(RootJoint.C0,cfMul(cf(0.1 * sin(sine * 4), Ychg, 0),angles(-1.5707963267948966, -0.08726646259971647 + 0.08726646259971647 * sin(sine * 4), -3.141592653589793)),deltaTime) 
					RightHip.C0 = Lerp(RightHip.C0,cfMul(cf(1, -1.1 + 0.1 * sin(sine * 4)-Ychg, 0),angles(1.5707963267948966, 1.5707963267948966 + 0.08726646259971647 * sin(sine * 4), -1.5707963267948966)),deltaTime) 
					LeftHip.C0 = Lerp(LeftHip.C0,cfMul(cf(-1 - 0.02 * sin(sine * 4), -0.925 - 0.07 * sin(sine * 4)-Ychg, 0),angles(1.5707963267948966, -1.7453292519943295 + 0.08726646259971647 * sin(sine * 4), 1.5707963267948966)),deltaTime) 
					--LeftArm,-1,0,0,4,90,0,0,4,0.5,0,0,4,-95,5,-0.3,4,0,0,0,4,90,0,0,4,RightArm,1,0.15,-0.4,4,90,0,0,4,1.42,0,0,4,85,-20,-0.4,4,0,0,0,4,90,0,0,4,Head,0,0,0,4,-85,0,0,4,1,0,0,4,2.5,-5,0.1,4,0,0,0,4,-180,2.5,0,4,Torso,0,0.1,0,4,-90,0,0,4,0,0,0,4,-5,5,0,4,0,0,0,4,-180,0,0,4,RightLeg,1,0,0,4,90,0,0,4,-1.1,0.1,0,4,90,5,0,4,0,0,0,4,-90,0,0,4,LeftLeg,-1,-0.02,0,4,90,0,0,4,-0.925,-0.07,0,4,-100,5,0,4,0,0,0,4,90,0,0,4
				end
			})
			addmode("y", {
				idle = function()
					local Ychg=velYchg()/20
					LeftShoulder.C0 = Lerp(LeftShoulder.C0,cfMul(cf(-1.5, 0.5, 0),angles(-1.7453292519943295, 0.17453292519943295 - 0.04363323129985824 * sin(sine * 2), -1.4835298641951802)),deltaTime) 
					RightHip.C0 = Lerp(RightHip.C0,cfMul(cf(1, -0.9000000953674316 - 0.1 * sin(sine * 2)-Ychg, 0),angles(-1.3962634015954636, 1.3962634015954636, 1.5707963267948966)),deltaTime) 
					LeftHip.C0 = Lerp(LeftHip.C0,cfMul(cf(-1, -1.0000001192092896 - 0.1 * sin(sine * 2)-Ychg, 0),angles(-1.5707963267948966, -1.3962634015954636, -1.5707963267948966)),deltaTime) 
					Neck.C0 = Lerp(Neck.C0,cfMul(cf(0, 1, 0),angles(-2.0943951023931953 + 0.08726646259971647 * sin((sine - 1) * 2), -0.08726646259971647, 2.792526803190927)),deltaTime) 
					RightShoulder.C0 = Lerp(RightShoulder.C0,cfMul(cf(1, 1.2000000476837158, 0),angles(2.6179938779914944 + 0.08726646259971647 * sin((sine - 1) * 2), 0.6981317007977318, -1.3962634015954636)),deltaTime) 
					RootJoint.C0 = Lerp(RootJoint.C0,cfMul(cf(0, 0.1 * sin(sine * 2) + Ychg, 0),angles(-1.6580627893946132, 0.08726646259971647, 3.0543261909900767)),deltaTime) 
					--LeftArm,-1.5,0,0,2,-100,0,0,2,0.5,0,0,2,10,-2.5,0,2,0,0,0,2,-85,0,0,2,RightLeg,1,0,0,2,-80,0,0,2,-0.9000000953674316,-0.1,0,2,80,0,0,2,0,0,0,2,90,0,0,2,LeftLeg,-1,0,0,2,-90,0,0,2,-1.0000001192092896,-0.1,0,2,-80,0,0,2,0,0,0,2,-90,0,0,2,Fedora_Handle,8.657480066176504e-09,0,0,2,-6,0,0,2,-0.15052366256713867,0,0,2,0,0,0,2,-0.010221302509307861,0,0,2,0,0,0,2,Head,0,0,0,2,-120,5,-1,2,1,0,0,2,-5,0,0,2,0,0,0,2,160,0,0,2,RightArm,1,0,0,2,150,5,-1,2,1.2000000476837158,0,0,2,40,0,0,2,0,0,0,2,-80,0,0,2,Torso,0,0,0,2,-95,0,0,2,0,0.1,0,2,5,0,0,2,0,0,0,2,175,0,0,2
				end
			})
			addmode("u", {
				idle = function()
					velYchg()
					RootJoint.C0 = Lerp(RootJoint.C0,cfMul(cf(0, 0.75 + 0.25 * sin(sine * 2), 0),angles(-1.5707963267948966, 0, 3.141592653589793)),deltaTime) 
					Neck.C0 = Lerp(Neck.C0,cfMul(cf(0, 1.5 - 0.1 * sin((sine + 0.2) * 2), 0),angles(-1.5707963267948966 - 0.08726646259971647 * sin((sine + 0.4) * 2), 0, 3.141592653589793 + 0.3490658503988659 * sin(sine * 0.66))),deltaTime) 
					LeftHip.C0 = Lerp(LeftHip.C0,cfMul(cf(-0.5 - 1 * sin((sine + 0.2) * 2.2), -0.75 - 0.25 * sin(sine * 2), 1 * sin((sine + 0.95) * 2.2)),angles(0, -1.5707963267948966, 0)),deltaTime) 
					RightHip.C0 = Lerp(RightHip.C0,cfMul(cf(0.5 + 1 * sin((sine + 0.2) * 2.2), -0.75 - 0.25 * sin(sine * 2), -1 * sin((sine + 0.95) * 2.2)),angles(0, 1.5707963267948966, 0)),deltaTime) 
					RightShoulder.C0 = Lerp(RightShoulder.C0,cfMul(cf(-0.5 - 1.85 * sin(sine * 2), 0.8 - 0.5 * sin(sine * 2), -1.85 * sin((sine + 0.75) * 2)),angles(0, 1.5707963267948966, 0)),deltaTime) 
					LeftShoulder.C0 = Lerp(LeftShoulder.C0,cfMul(cf(0.5 + 1.85 * sin(sine * 2), 0.8 - 0.5 * sin(sine * 2), 1.85 * sin((sine + 0.75) * 2)),angles(0, -1.5707963267948966, 0)),deltaTime) 
					--Torso,0,0,0,2,-90,0,0,2,0.75,0.25,0,2,-0,0,0,2,0,0,0,2,180,0,0,2,Fedora_Handle,8.657480066176504e-09,0,0,2,-6,0,0,2,-0.15052366256713867,0,0,2,0,0,0,2,-0.010221302509307861,0,0,2,0,0,0,2,Head,0,0,0,2,-90,-5,0.4,2,1.5,-0.1,0.2,2,-0,0,0,2,0,0,0,2,180,20,0,0.66,LeftLeg,-0.5,-1,0.2,2.2,-0,0,0,2,-0.75,-0.25,0,2,-90,0,0,2,0,1,0.95,2.2,0,0,0,2,RightLeg,0.5,1,0.2,2.2,0,0,0,2,-0.75,-0.25,0,2,90,0,0,2,0,-1,0.95,2.2,0,0,0,2,RightArm,-0.5,-1.85,0,2,0,0,0,2,0.8,-0.5,0,2,90,0,0,2,0,-1.85,0.75,2,0,0,0,2,LeftArm,0.5,1.85,0,2,-0,0,0,2,0.8,-0.5,0,2,-90,0,0,2,0,1.85,0.75,2,0,0,0,2
				end
			})
			addmode("i", {
				idle = function()
					local Ychg=velYchg()/20
					LeftShoulder.C0 = Lerp(LeftShoulder.C0,cfMul(cf(-0.5, 0.5 + 0.1 * sin((sine - 0.4444444444444444) * 9), 0),angles(2.9670597283903604 + 0.17453292519943295 * sin((sine - 0.17777777777777778) * 9), -0.5235987755982988, 1.5707963267948966 + 0.17453292519943295 * sin(sine * 4.5))),deltaTime) 
					LeftHip.C0 = Lerp(LeftHip.C0,cfMul(cf(-1, -0.5 + 0.1 * sin((sine + 0.26666666666666666) * 4.5)-Ychg, -0.5),angles(1.7453292519943295 - 1.0471975511965976 * sin(sine * 4.5), -1.5707963267948966 + 0.03490658503988659 * sin(sine * 4.5), 1.5707963267948966)),deltaTime) 
					RootJoint.C0 = Lerp(RootJoint.C0,cfMul(cf(0, -0.5 + 0.5 * sin((sine + 0.17777777777777778) * 9)+Ychg, 0),angles(-1.3962634015954636 - 0.03490658503988659 * sin((sine + 0.17777777777777778) * 9), -0.05235987755982989 * sin(sine * 4.5), 3.141592653589793 + 0.03490658503988659 * sin(sine * 4.5))),deltaTime) 
					Neck.C0 = Lerp(Neck.C0,cfMul(cf(0, 1 + 0.2 * sin(sine * 9), 0),angles(-1.5707963267948966 + 0.08726646259971647 * sin(sine * 9), 0.08726646259971647 * sin(sine * 4.5), 3.141592653589793 - 0.06981317007977318 * sin(sine * 4.5))),deltaTime) 
					RightShoulder.C0 = Lerp(RightShoulder.C0,cfMul(cf(0.5, 0.5 + 0.1 * sin((sine - 0.4444444444444444) * 9), 0),angles(2.9670597283903604 + 0.17453292519943295 * sin((sine - 0.17777777777777778) * 9), 0.5235987755982988, -1.5707963267948966 + 0.17453292519943295 * sin(sine * 4.5))),deltaTime) 
					RightHip.C0 = Lerp(RightHip.C0,cfMul(cf(1, -0.5 + 0.1 * sin((sine - 0.26666666666666666) * 4.5)-Ychg, -0.5),angles(1.7453292519943295 + 1.0471975511965976 * sin(sine * 4.5), 1.5707963267948966 + 0.03490658503988659 * sin(sine * 4.5), -1.5707963267948966)),deltaTime) 
					--LeftArm,-0.5,0,0,4.5,170,10,-0.17777777777777778,9,0.5,0.1,-0.4444444444444444,9,-30,0,0,4.5,0,0,0,4.5,90,10,0,4.5,LeftLeg,-1,0,0,4.5,100,-60,0,4.5,-0.5,0.1,0.26666666666666666,4.5,-90,2,0,4.5,-0.5,0,0,4.5,90,0,0,4.5,Torso,0,0,0,4.5,-80,-2,0.17777777777777778,9,-0.5,0.5,0.17777777777777778,9,-0,-3,0,4.5,0,0,0,4.5,180,2,0,4.5,Head,0,0,0,4.5,-90,5,0,9,1,0.2,0,9,-0,5,0,4.5,0,0,0,4.5,180,-4,0,4.5,RightArm,0.5,0,0,4.5,170,10,-0.17777777777777778,9,0.5,0.1,-0.4444444444444444,9,30,0,0,4.5,0,0,0,4.5,-90,10,0,4.5,RightLeg,1,0,0,4.5,100,60,0,4.5,-0.5,0.1,-0.26666666666666666,4.5,90,2,0,4.5,-0.5,0,0,4.5,-90,0,0,4.5
				end,
			})
			addmode("o", {
				idle = function()
					local Ychg=velYchg()/20
					local rY, lY = raycastlegs()
		
					LeftHip.C0 = Lerp(LeftHip.C0,cfMul(cf(-1, -1 + lY-Ychg, lY * -0.5),angles(-1.8325957145940461 - 0.08726646259971647 * sin(sine * 2), -1.4835298641951802, -1.5707963267948966)),deltaTime) 
					RootJoint.C0 = Lerp(RootJoint.C0,cfMul(cf(0, Ychg, 0.09 * sin(sine * 2)),angles(-1.3962634015954636 + 0.08726646259971647 * sin(sine * 2), -0.08726646259971647, 3.141592653589793)),deltaTime) 
					LeftShoulder.C0 = Lerp(LeftShoulder.C0,cfMul(cf(-1, 0.5, 0),angles(2.9670597283903604 + 0.08726646259971647 * sin(sine * 1), -1.5707963267948966 + 0.08726646259971647 * sin((sine + 0.6) * 1), 1.5707963267948966)),deltaTime) 
					RightHip.C0 = Lerp(RightHip.C0,cfMul(cf(1, -1.1 + rY-Ychg, rY * -0.5),angles(-1.7453292519943295 - 0.08726646259971647 * sin(sine * 2), 1.5707963267948966, 1.5707963267948966)),deltaTime) 
					Neck.C0 = Lerp(Neck.C0,cfMul(cf(0, 1, 0),angles(-1.2217304763960306 - 0.08726646259971647 * sin((sine + 0.3) * 2), -0.2617993877991494 - 0.08726646259971647 * sin(sine * 2), 3.141592653589793)),deltaTime) 
					RightShoulder.C0 = Lerp(RightShoulder.C0,cfMul(cf(1, 0.5, 0),angles(2.8797932657906435 + 0.08726646259971647 * sin(sine * 1), 1.5707963267948966 - 0.08726646259971647 * sin((sine + 0.6) * 1), -1.5707963267948966)),deltaTime) 
					--LeftLeg,-1,0,0,2,-105,-5,0,2,-1,0,0,2,-85,0,0,2,0,0,0,2,-90,0,0.75,2,Torso,0,0,0,2,-80,5,0,2,0,0,0,2,-5,0,0,2,0,0.09,0,2,180,0,0,2,LeftArm,-1,0,0,2,170,5,0,1,0.5,0,0,2,-90,5,0.6,1,0,0,0,2,90,0,0,2,RightLeg,1,0,0,2,-100,-5,0,2,-1.1,0,0,2,90,0,0,2,0,0,0,2,90,0,0.75,2,Head,0,0,0,2,-70,-5,0.3,2,1,0,0,2,-15,-5,0,2,0,0,0,2,180,0,0,2,RightArm,1,0,0,2,165,5,0,1,0.5,0,0,2,90,-5,0.6,1,0,0,0,2,-90,0,0,2
				end,
				walk = function()
					local Ychg=velYchg()/20
					local Vfw, Vrt = velbycfrvec()
		
					local rY, lY = raycastlegs()
		
					Neck.C0 = Lerp(Neck.C0,cfMul(cf(0, 1, 0),angles(-1.5707963267948966 + 0.04363323129985824 * sin(sine * 16), 0, 3.141592653589793 + 0.08726646259971647 * sin(sine * 8) - Vrt)),deltaTime) 
					RightHip.C0 = Lerp(RightHip.C0,cfMul(cf(1, -1 - 0.3 * sin((sine + 0.15) * 8) + rY-Ychg, rY * -0.5),angles(-1.5707963267948966 - 0.6981317007977318 * sin(sine * 8) * Vfw, 1.5707963267948966 + 0.6981317007977318 * sin(sine * 8) * Vrt, 1.5707963267948966)),deltaTime) 
					RightShoulder.C0 = Lerp(RightShoulder.C0,cfMul(cf(1, 0.5, 0),angles(0.08726646259971647 * sin((sine - 0.05) * 16), 1.5707963267948966 + 0.08726646259971647 * sin(sine * 8) - Vrt/3, 1.5707963267948966)),deltaTime) 
					LeftShoulder.C0 = Lerp(LeftShoulder.C0,cfMul(cf(-1, 0.5, 0),angles(0.08726646259971647 * sin((sine - 0.05) * 16), -1.5707963267948966 + 0.08726646259971647 * sin(sine * 8) - Vrt/3, -1.5707963267948966)),deltaTime) 
					RootJoint.C0 = Lerp(RootJoint.C0,cfMul(cf(0, 0.1 * sin((sine + 0.1) * 16)+Ychg, 0),angles(-1.5707963267948966, 0, 3.141592653589793 - 0.08726646259971647 * sin(sine * 8))),deltaTime) 
					LeftHip.C0 = Lerp(LeftHip.C0,cfMul(cf(-1, -1 + 0.3 * sin((sine + 0.15) * 8) + lY-Ychg, lY * -0.5),angles(1.5707963267948966 + 0.6981317007977318 * sin(sine * 8) * Vfw, -1.5707963267948966 + 0.6981317007977318 * sin(sine * 8) * Vrt, 1.5707963267948966)),deltaTime) 
					--Head,0,0,0,8,-90,2.5,0,16,1,0,0,8,-0,0,0,8,0,0,0,8,180,5,0,8,RightLeg,1,0,0,8,-90,-40,0,8,-1,-0.3,0.15,8,90,40,0,8,0,0,0,8,90,0,0,8,RightArm,1,0,0,8,0,5,-0.05,16,0.5,0,0,8,90,5,0,8,0,0,0,8,90,0,0,8,LeftArm,-1,0,0,8,0,5,-0.05,16,0.5,0,0,8,-90,5,0,8,0,0,0,8,-90,0,0,8,Torso,0,0,0,8,-90,0,0,8,0,0.1,0.1,16,-0,0,0,8,0,0,0,8,180,-5,0,8,LeftLeg,-1,0,0,8,90,40,0,8,-1,0.3,0.15,8,-90,40,0,8,0,0,0,8,90,0,0,8
				end
			})
			addmode("p", {
				idle = function()
					local Ychg=velYchg()/20
					RightShoulder.C0 = Lerp(RightShoulder.C0,cfMul(cf(1.5, 0.5, 0),angles(1.5707963267948966, 3.141592653589793, -1.5707963267948966)),deltaTime) 
					RightHip.C0 = Lerp(RightHip.C0,cfMul(cf(1, -1-Ychg, 0),angles(0, 1.5707963267948966, 0)),deltaTime) 
					LeftShoulder.C0 = Lerp(LeftShoulder.C0,cfMul(cf(-1.5, 0.5, 0),angles(1.5707963267948966, 3.141592653589793, 1.5707963267948966)),deltaTime) 
					LeftHip.C0 = Lerp(LeftHip.C0,cfMul(cf(-1, -1-Ychg, 0),angles(0, -1.5707963267948966, 0)),deltaTime) 
					Neck.C0 = Lerp(Neck.C0,cfMul(cf(0, 1, 0),angles(-1.5707963267948966, 0, -3.141592653589793)),deltaTime) 
					RootJoint.C0 = Lerp(RootJoint.C0,cfMul(cf(0, Ychg, 0),angles(-1.5707963267948966, 0, -3.141592653589793)),deltaTime) 
					--RightArm,1.5,0,0,1,90,0,0,1,0.5,0,0,1,180,0,0,1,0,0,0,1,-90,0,0,1,RightLeg,1,0,0,1,0,0,0,1,-1,0,0,1,90,0,0,1,0,0,0,1,0,0,0,1,Fedora_Handle,8.657480066176504e-09,0,0,1,-6,0,0,1,-0.15052366256713867,0,0,1,0,0,0,1,-0.010221302509307861,0,0,1,0,0,0,1,LeftArm,-1.5,0,0,1,90,0,0,1,0.5,0,0,1,180,0,0,1,0,0,0,1,90,0,0,1,LeftLeg,-1,0,0,1,-0,0,0,1,-1,0,0,1,-90,0,0,1,0,0,0,1,0,0,0,1,Head,0,0,0,1,-90,0,0,1,1,0,0,1,0,0,0,1,0,0,0,1,-180,0,0,1,Torso,0,0,0,1,-90,0,0,1,0,0,0,1,0,0,0,1,0,0,0,1,-180,0,0,1
				end
			})
			addmode("f", {
				modeEntered = function()
					setWalkSpeed(25)
				end,
				idle = function()
					velYchg()
					LeftShoulder.C0 = Lerp(LeftShoulder.C0,cfMul(cf(-1, 0.5, 0),angles(-3.0543261909900767 - 0.17453292519943295 * sin((sine + 1.5) * 1), -1.5707963267948966 + 0.08726646259971647 * sin((sine + 0.6) * 1), -1.5707963267948966)),deltaTime) 
					RightShoulder.C0 = Lerp(RightShoulder.C0,cfMul(cf(1, 0.5, 0),angles(3.141592653589793 - 0.08726646259971647 * sin(sine * 1), 0.3490658503988659 + 0.08726646259971647 * sin((sine + 0.3) * 1), -1.9198621771937625 + 0.08726646259971647 * sin((sine + 1) * 1))),deltaTime) 
					Neck.C0 = Lerp(Neck.C0,cfMul(cf(0, 1, 0),angles(-1.3089969389957472 - 0.2617993877991494 * sin((sine + 1.2) * 1), 0.08726646259971647 * sin((sine + 0.2) * 0.5), -2.9670597283903604)),deltaTime) 
					RootJoint.C0 = Lerp(RootJoint.C0,cfMul(cf(0, 5 - 0.5 * sin((sine - 0.2) * 1), 0.2 * sin((sine - 1.2) * 1)),angles(-0.08726646259971647 + 0.17453292519943295 * sin((sine + 1.2) * 1), 0.08726646259971647 * sin(sine * 0.5), 3.141592653589793)),deltaTime) 
					LeftHip.C0 = Lerp(LeftHip.C0,cfMul(cf(-1, -1, 0),angles(1.3962634015954636 + 0.12217304763960307 * sin((sine + 1.5) * 1), -1.2217304763960306 + 0.08726646259971647 * sin((sine + 0.2) * 0.5), 1.5707963267948966)),deltaTime) 
					RightHip.C0 = Lerp(RightHip.C0,cfMul(cf(1, -1, 0),angles(1.9198621771937625 + 0.12217304763960307 * sin((sine + 1.5) * 1), 1.2217304763960306 + 0.08726646259971647 * sin((sine + 0.2) * 0.5), -1.5707963267948966)),deltaTime) 
					--LeftArm,-1,0,0,1,-175,-10,1.5,1,0.5,0,0,1,-90,5,0.6,1,0,0,0,1,-90,0,0,1,RightArm,1,0,0,1,180,-5,0,1,0.5,0,0,1,20,5,0.3,1,0,0,0,1,-110,5,1,1,Head,0,0,0,1,-75,-15,1.2,1,1,0,0,1,-0,5,0.2,0.5,0,0,0,1,-170,0,0,1,Torso,0,0,0,1,-5,10,1.2,1,5,-0.5,-0.2,1,-0,5,0,0.5,0,0.2,-1.2,1,180,0,0,1,LeftLeg,-1,0,0,1,80,7,1.5,1,-1,0,0,1,-70,5,0.2,0.5,0,0,0,1,90,0,0,1,RightLeg,1,0,0,1,110,7,1.5,1,-1,0,0,1,70,5,0.2,0.5,0,0,0,1,-90,0,0,1
				end,
				walk = function()
					velYchg()
					local Vfw, Vrt = velbycfrvec()
					LeftShoulder.C0 = Lerp(LeftShoulder.C0,cfMul(cf(-1, 0.5, 0),angles(-3.0543261909900767 - 0.17453292519943295 * sin((sine + 1.5) * 1) - Vfw * 0.1, -1.5707963267948966 + 0.08726646259971647 * sin((sine + 0.6) * 1) + Vrt * 0.2, -1.5707963267948966)),deltaTime) 
					RightShoulder.C0 = Lerp(RightShoulder.C0,cfMul(cf(1, 0.5, 0),angles(3.141592653589793 - 0.08726646259971647 * sin(sine * 1), 0.3490658503988659 + 0.08726646259971647 * sin((sine + 0.3) * 1), -1.9198621771937625 + 0.08726646259971647 * sin((sine + 1) * 1))),deltaTime) 
					Neck.C0 = Lerp(Neck.C0,cfMul(cf(0, 1, 0),angles(-1.3089969389957472 - 0.2617993877991494 * sin((sine + 1.2) * 1) + Vfw * 0.1, 0.08726646259971647 * sin((sine + 0.2) * 0.5) - Vrt * 0.2, -2.9670597283903604)),deltaTime) 
					RootJoint.C0 = Lerp(RootJoint.C0,cfMul(cf(0, 5 - 0.5 * sin((sine - 0.2) * 1), 0.2 * sin((sine - 1.2) * 1)),angles(-0.08726646259971647 + 0.17453292519943295 * sin((sine + 1.2) * 1) - Vfw * 0.2, 0.08726646259971647 * sin(sine * 0.5), 3.141592653589793 - Vrt * 0.2)),deltaTime) 
					LeftHip.C0 = Lerp(LeftHip.C0,cfMul(cf(-1, -1, 0),angles(1.3962634015954636 + 0.12217304763960307 * sin((sine + 1.5) * 1) - Vfw * 0.2, -1.2217304763960306 + 0.08726646259971647 * sin((sine + 0.2) * 0.5), 1.5707963267948966)),deltaTime) 
					RightHip.C0 = Lerp(RightHip.C0,cfMul(cf(1, -1, 0),angles(1.9198621771937625 + 0.12217304763960307 * sin((sine + 1.5) * 1) - Vfw * 0.2, 1.2217304763960306 + 0.08726646259971647 * sin((sine + 0.2) * 0.5), -1.5707963267948966)),deltaTime) 
					--LeftArm,-1,0,0,1,-175,-10,1.5,1,0.5,0,0,1,-90,5,0.6,1,0,0,0,1,-90,0,0,1,RightArm,1,0,0,1,180,-5,0,1,0.5,0,0,1,20,5,0.3,1,0,0,0,1,-110,5,1,1,Head,0,0,0,1,-75,-15,1.2,1,1,0,0,1,-0,5,0.2,0.5,0,0,0,1,-170,0,0,1,Torso,0,0,0,1,-5,10,1.2,1,5,-0.5,-0.2,1,-0,5,0,0.5,0,0.2,-1.2,1,180,0,0,1,LeftLeg,-1,0,0,1,80,7,1.5,1,-1,0,0,1,-70,5,0.2,0.5,0,0,0,1,90,0,0,1,RightLeg,1,0,0,1,110,7,1.5,1,-1,0,0,1,70,5,0.2,0.5,0,0,0,1,-90,0,0,1
				end,
				modeLeft = function()
					setWalkSpeed(16)
				end,
			})
			addmode("g", {
				idle = function()
					local Ychg=velYchg()/20
					LeftShoulder.C0 = Lerp(LeftShoulder.C0,cfMul(cf(-0.9 + 0.4 * sin(sine * 8), 0.5, 0.5 * sin((sine + 0.25) * 4)),angles(1.5707963267948966, -1.5707963267948966 + 1.0471975511965976 * sin(sine * 8), 1.5707963267948966 + 0.6981317007977318 * sin((sine + 0.25) * 4))),deltaTime) 
					RootJoint.C0 = Lerp(RootJoint.C0,cfMul(cf(0.3 * sin((sine + 0.4) * 8), Ychg, 0),angles(-1.5707963267948966, 0.3490658503988659 * sin(sine * 8), -3.141592653589793)),deltaTime) 
					Neck.C0 = Lerp(Neck.C0,cfMul(cf(0, 1, 0),angles(-1.5707963267948966 + 0.061086523819801536 * sin((sine + 0.125) * 16), -0.3839724354387525 * sin(sine * 8), -3.141592653589793)),deltaTime) 
					RightHip.C0 = Lerp(RightHip.C0,cfMul(cf(1, -1 + 0.4 * sin((sine - 0.01) * 8)-Ychg, 0),angles(1.5707963267948966, 1.7453292519943295 + 0.6981317007977318 * sin(sine * 8), -1.5707963267948966)),deltaTime) 
					LeftHip.C0 = Lerp(LeftHip.C0,cfMul(cf(-1, -1 - 0.4 * sin((sine - 0.01) * 8)-Ychg, 0),angles(1.5707963267948966, -1.7453292519943295 + 0.6981317007977318 * sin(sine * 8), 1.5707963267948966)),deltaTime) 
					RightShoulder.C0 = Lerp(RightShoulder.C0,cfMul(cf(0.9 + 0.4 * sin(sine * 8), 0.5, -0.5 * sin((sine - 0.35) * 4)),angles(1.5707963267948966 + 0.6981317007977318 * sin(sine * 4), 1.5707963267948966 + 1.0471975511965976 * sin(sine * 8), -1.5707963267948966 + 0.17453292519943295 * sin((sine - 0.35) * 4))),deltaTime) 
					--LeftArm,-0.9,0.4,0,8,90,0,0.25,4,0.5,0,0,8,-90,60,0,8,0,0.5,0.25,4,90,40,0.25,4,Torso,0,0.3,0.4,8,-90,0,0,8,0,0,0,4,0,20,0,8,0,0,0,8,-180,0,0,8,Head,0,0,0,8,-90,3.5,0.125,16,1,0,0,8,0,-22,0,8,0,0,0,8,-180,0,0,1.1,RightLeg,1,0,0,8,90,0,0,8,-1,0.4,-0.01,8,100,40,0,8,0,0,0,8,-90,0,0,8,LeftLeg,-1,0,0,8,90,0,0,8,-1,-0.4,-0.01,8,-100,40,0,8,0,0,0,8,90,0,0,8,RightArm,0.9,0.4,0,8,90,40,0,4,0.5,0,0,8,90,60,0,8,0,-0.5,-0.35,4,-90,10,-0.35,4
				end
			})
			addmode("h", {
				idle = function()
					local Ychg=velYchg()/20
					Neck.C0 = Lerp(Neck.C0,cfMul(cf(0, 1, 0),angles(-1.5707963267948966, -0.4363323129985824 * sin(sine * 8), -3.141592653589793)),deltaTime) 
					RightHip.C0 = Lerp(RightHip.C0,cfMul(cf(1, -1 + 0.3 * sin(sine * 8)-Ychg, 0),angles(1.5707963267948966, 1.5707963267948966 + 0.5235987755982988 * sin(sine * 8), -1.5707963267948966)),deltaTime) 
					LeftShoulder.C0 = Lerp(LeftShoulder.C0,cfMul(cf(-0.5, 1, 0),angles(-0.5235987755982988, -1.5707963267948966 - 0.5235987755982988 * sin(sine * 8), 3.141592653589793)),deltaTime) 
					RightShoulder.C0 = Lerp(RightShoulder.C0,cfMul(cf(0.5, 1, 0),angles(-0.5235987755982988, 1.5707963267948966 - 0.5235987755982988 * sin(sine * 8), 3.141592653589793)),deltaTime) 
					RootJoint.C0 = Lerp(RootJoint.C0,cfMul(cf(-0.1 * sin(sine * 8), 0.2 * sin((sine + 0.1) * 16)+Ychg, 0),angles(-1.5707963267948966, 0.2617993877991494 * sin(sine * 8), -3.141592653589793)),deltaTime) 
					LeftHip.C0 = Lerp(LeftHip.C0,cfMul(cf(-1, -1 - 0.3 * sin(sine * 8)-Ychg, 0),angles(1.5707963267948966, -1.5707963267948966 + 0.5235987755982988 * sin(sine * 8), 1.5707963267948966)),deltaTime) 
					--Head,0,0,0,8,-90,0,0,8,1,0,0,8,0,-25,0,8,0,0,0,8,-180,0,0,8,RightLeg,1,0,0,8,90,0,0,8,-1,0.3,0,8,90,30,0,8,0,0,0,8,-90,0,0,8,LeftArm,-0.5,0,0,8,-30,0,0,8,1,0,0,8,-90,-30,0,8,0,0,0,8,180,0,0,8,RightArm,0.5,0,0,8,-30,0,0,8,1,0,0,16,90,-30,0,8,0,0,0,8,180,0,0,8,Torso,0,-0.1,0,8,-90,0,0,8,0,0.2,0.1,16,0,15,0,8,0,0,0,8,-180,0,0,8,LeftLeg,-1,0,0,8,90,0,0,8,-1,-0.3,0,8,-90,30,0,8,0,0,0,8,90,0,0,8,Fedora_Handle,8.657480066176504e-09,0,0,8,-6,0,0,8,-0.15052366256713867,0,0,8,0,0,0,8,-0.010221302509307861,0,0,8,0,0,0,8
				end
			})
			addmode("j", {
				idle = function()
					local Ychg=velYchg()/20
					LeftHip.C0 = Lerp(LeftHip.C0,cfMul(cf(-0.8, -1, -0.1),angles(0.17453292519943295, -0.6981317007977318, 0)),deltaTime) 
					LeftShoulder.C0 = Lerp(LeftShoulder.C0,cfMul(cf(-1.2, 0.5, 0),angles(-0.3490658503988659 + 0.08726646259971647 * sin((sine + 0.1) * 4), 0, 0.6981317007977318 + 0.08726646259971647 * sin((sine + 0.1) * 4))),deltaTime) 
					RightHip.C0 = Lerp(RightHip.C0,cfMul(cf(1.1, -1, 0),angles(1.5707963267948966, 1.7453292519943295, -1.5707963267948966)),deltaTime) 
					Neck.C0 = Lerp(Neck.C0,cfMul(cf(0, 1, 0),angles(-1.5707963267948966 + 0.08726646259971647 * sin((sine + 0.1) * 4), 0, 2.792526803190927)),deltaTime) 
					RootJoint.C0 = Lerp(RootJoint.C0,cfMul(cf(0, -1.7 + 0.5 * sin(sine * 4)+Ychg, 0.15 * sin(sine * 4)),angles(3.3161255787892263 + 0.17453292519943295 * sin(sine * 4), 0, 3.6651914291880923)),deltaTime) 
					RightShoulder.C0 = Lerp(RightShoulder.C0,cfMul(cf(0.8 + 0.4 * sin(sine * 4), 0.6 + 0.1 * sin(sine * 4), 0.4 - 0.25 * sin(sine * 4)),angles(2.9670597283903604, 2.2689280275926285 - 0.17453292519943295 * sin(sine * 4), -1.4835298641951802 - 0.17453292519943295 * sin(sine * 4))),deltaTime) 
					--GalaxyBeautifulHair_Handle,-0.15000000596046448,0,0,1,0,0,0,1,0.10000000149011612,0,0,1,0,0,0,1,0,0,0,1,0,0,0,1,LeftLeg,-0.8,0,0,4,10,0,0,4,-1,0,0,4,-40,0,0,4,-0.1,0,0,4,0,0,0,4,LeftArm,-1.2,0,0,4,-20,5,0.1,4,0.5,0,0,4,0,0,0,4,0,0,0,4,40,5,0.1,4,Fedora_Handle,8.657480066176504e-09,0,0,1,-6,0,0,1,-0.15052366256713867,0,0,1,0,0,0,1,-0.010221302509307861,0,0,1,0,0,0,1,ValkyrieHelm_Handle,8.658389560878277e-09,0,0,1,-15,0,0,1,-0.2433757781982422,0,0,1,0,0,0,1,-0.2657628059387207,0,0,1,0,0,0,1,RightLeg,1.1,0,0,4,90,0,0,4,-1,0,0,4,100,0,0,4,0,0,0,4,-90,0,0,4,BlackIronAntlers_Handle,8.658389560878277e-09,0,0,1,0,0,0,1,-0.6500000953674316,0,0,1,0,0,0,1,0.19972775876522064,0,0,1,0,0,0,1,DevAwardsAdurite_Handle,0,0,0,1,0,0,0,1,-0.25,0,0,1,0,0,0,1,0,0,0,1,0,0,0,1,SilverthornAntlers_Handle,8.658389560878277e-09,0,0,1,0,0,0,1,-0.6500000953674316,0,0,1,0,0,0,1,0.19972775876522064,0,0,1,0,0,0,1,Head,0,0,0,4,-90,5,0.1,4,1,0,0,4,-0,0,0,4,0,0,0,4,160,0,0,4,Torso,0,0,0,4,190,10,0,4,-1.70,0.5,0,4,-0,0,0,4,0,0.15,0,4,210,0,0,4,RightArm,0.8,0.4,0,4,170,0,0,4,0.6,0.1,0,4,130,-10,0,4,0.4,-0.25,0,4,-85,-10,0,4
				end
			})
			addmode("k", {
				idle = function()
					local Ychg=velYchg()/20
					Neck.C0 = Lerp(Neck.C0,cfMul(cf(0, 1, 0),angles(-1.6580627893946132 - 0.08726646259971647 * sin((sine + 0.3333333333333333) * 12), -0.08726646259971647 * sin((sine + 0.2) * 6), 3.141592653589793)),deltaTime) 
					LeftHip.C0 = Lerp(LeftHip.C0,cfMul(cf(-1, -0.5 - 0.5 * sin((sine + 0.39999999999999997) * 12)-Ychg, -0.5),angles(1.7453292519943295 - 1.0471975511965976 * sin(sine * 6), -1.5707963267948966 + 0.1308996938995747 * sin(sine * 6), 1.5707963267948966)),deltaTime) 
					RightHip.C0 = Lerp(RightHip.C0,cfMul(cf(1, -0.5 - 0.5 * sin((sine + 0.39999999999999997) * 12)-Ychg, -0.5),angles(1.7453292519943295 + 1.0471975511965976 * sin(sine * 6), 1.5707963267948966 + 0.1308996938995747 * sin(sine * 6), -1.5707963267948966)),deltaTime) 
					RootJoint.C0 = Lerp(RootJoint.C0,cfMul(cf(0, -0.5 + 0.3 * sin((sine + 0.16666666666666666) * 12)+Ychg, 0),angles(-1.3962634015954636 + 0.08726646259971647 * sin((sine + 0.3333333333333333) * 12), 0.08726646259971647 * sin((sine + 0.06666666666666667) * 6), 3.141592653589793)),deltaTime) 
					LeftShoulder.C0 = Lerp(LeftShoulder.C0,cfMul(cf(-0.8 - 0.1 * sin(sine * 6), 0.5 + 0.1 * sin(sine * 6), -0.2),angles(3.141592653589793 - 0.17453292519943295 * sin((sine + 0.39999999999999997) * 12), -0.17453292519943295, 1.5707963267948966)),deltaTime) 
					RightShoulder.C0 = Lerp(RightShoulder.C0,cfMul(cf(0.8 - 0.1 * sin(sine * 6), 0.5 - 0.1 * sin(sine * 6), -0.2),angles(3.141592653589793 - 0.17453292519943295 * sin((sine + 0.39999999999999997) * 12), 0.17453292519943295, -1.5707963267948966)),deltaTime) 
					--GalaxyBeautifulHair_Handle,-0.15000000596046448,0,0,1.5,0,0,0,1.5,0.10000000149011612,0,0,1.5,0,0,0,1.5,0,0,0,1.5,0,0,0,1.5,Head,0,0,0,6,-95,-5,0.3333333333333333,12,1,0,0,6,-0,-5,0.2,6,0,0,0,6,180,0,0,6,ValkyrieHelm_Handle,8.658389560878277e-09,0,0,1.5,-15,0,0,1.5,-0.2433757781982422,0,0,1.5,0,0,0,1.5,-0.2657628059387207,0,0,1.5,0,0,0,1.5,SilverthornAntlers_Handle,8.658389560878277e-09,0,0,1.5,0,0,0,1.5,-0.6500000953674316,0,0,1.5,0,0,0,1.5,0.19972775876522064,0,0,1.5,0,0,0,1.5,BlackIronAntlers_Handle,8.658389560878277e-09,0,0,1.5,0,0,0,1.5,-0.6500000953674316,0,0,1.5,0,0,0,1.5,0.19972775876522064,0,0,1.5,0,0,0,1.5,Fedora_Handle,8.657480066176504e-09,0,0,1.5,-6,0,0,1.5,-0.15052366256713867,0,0,1.5,0,0,0,1.5,-0.010221302509307861,0,0,1.5,0,0,0,1.5,LeftLeg,-1,0,0,6,100,-60,0,6,-0.5,-0.5,0.39999999999999997,12,-90,7.5,0,6,-0.5,0,0,6,90,0,0,6,EyelessSmileHead_Handle,-0.00043487548828125,0,0,1.5,180,0,0,1.5,0.6000361442565918,0,0,1.5,0,0,0,1.5,0.0003204345703125,0,0,1.5,180,0,0,1.5,RightLeg,1,0,0,6,100,60,0,6,-0.5,-0.5,0.39999999999999997,12,90,7.5,0,6,-0.5,0,0,6,-90,0,0,6,DevAwardsAdurite_Handle,0,0,0,1.5,0,0,0,1.5,-0.25,0,0,1.5,0,0,0,1.5,0,0,0,1.5,0,0,0,1.5,Torso,0,0,0,6,-80,5,0.3333333333333333,12,-0.5,0.3,0.16666666666666666,12,-0,5,0.06666666666666667,6,0,0,0,6,180,0,0,6,LeftArm,-0.8,-0.1,0,6,180,-10,0.39999999999999997,12,0.5,0.1,0,6,-10,0,0,6,-0.2,0,0,6,90,0,0,6,RightArm,0.8,-0.1,0,6,180,-10,0.39999999999999997,12,0.5,-0.1,0,6,10,0,0,6,-0.2,0,0,6,-90,0,0,6
				end
			})
			local idleL=function()
				local Ychg=velYchg()/20
				RightHip.C0=Lerp(RightHip.C0,cfMul(cf(1,-0.9+0.2*sin((sine - 0.2)*16)-Ychg,0.25),angles(0,0.7853981633974483,0.4363323129985824-1.1344640137963142*sin((sine-0.0875)*8))),deltaTime) 
				RootJoint.C0=Lerp(RootJoint.C0,cfMul(cf(0.15 * sin((sine-0.1)*8),0.54 * sin(sine*16)+Ychg,0),angles(-1.5707963267948966,-0.08726646259971647*sin((sine-0.0785)*8),3.141592653589793-0.08726646259971647*sin((sine-0.0785)*8))),deltaTime) 
				RightShoulder.C0=Lerp(RightShoulder.C0,cfMul(cf(0.75+0.07*sin((sine - 0.0785)*8),1.3+0.1*sin((sine - 0.0875)*16),0),angles(1.3962634015954636,2.356194490192345-0.06981317007977318*sin((sine-0.0785)*8),1.2217304763960306)),deltaTime) 
				Neck.C0=Lerp(Neck.C0,cfMul(cf(0,1,0),angles(-1.5707963267948966+0.08726646259971647*sin((sine-0.1)*16),0.12217304763960307*sin((sine-0.0785)*8),3.141592653589793)),deltaTime) 
				LeftHip.C0=Lerp(LeftHip.C0,cfMul(cf(-1,-0.9+0.2*sin((sine - 0.2)*16)-Ychg,0.25),angles(0,-0.7853981633974483,-0.4363323129985824-1.1344640137963142*sin((sine-0.0875)*8))),deltaTime) 
				LeftShoulder.C0=Lerp(LeftShoulder.C0,cfMul(cf(-1,0.45+0.05*sin((sine - 0.0875)*16),-0.2),angles(2.0943951023931953+0.17453292519943295*sin((sine-0.0875)*16),-0.5235987755982988,1.5707963267948966+0.17453292519943295*sin((sine-0.0875)*16))),deltaTime) 
				--MW_animatorProgressSave: RightLeg,1,0,0,16,0,0,0,8,-0.9,0.2,-0.2,16,45,0,-0.0875,8,0.25,0,0,16,25,-65,-0.0875,8,Fedora_Handle,8.657480066176504e-09,0,0,2,-6,0,0,2,-0.15052366256713867,0,0,2,0,0,0,2,-0.010221302509307861,0,0,2,0,0,0,2,Torso,0,0.15,-0.1,8,-90,0,0,16,0,0.54,0,16,-0,-5,-0.0785,8,0,0,0,16,180,-5,-0.0785,8,RightArm,0.75,0.07,-0.0785,8,80,0,0,16,1.3,0.1,-0.0875,16,135,-4,-0.0785,8,0,0,0,16,70,0,0,16,Head,0,0,0,16,-90,5,-0.1,16,1,0,0,16,-0,7,-0.0785,8,0,0,0,16,180,0,0,16,LeftLeg,-1,0,0,16,0,0,0,8,-0.9,0.2,-0.2,16,-45,0,0,8,0.25,0,0,16,-25,-65,-0.0875,8,Bandana_Handle,3.9362930692732334e-09,0,0,2,0,0,0,2,0.3000001907348633,0,0,2,0,0,0,2,-0.6002722978591919,0,0,2,0,0,0,2,LeftArm,-1,0,0,16,120,10,-0.0875,16,0.45,0.05,-0.0875,16,-30,0,0,16,-0.2,0,0,16,90,10,-0.0875,16
			end
			addmode("l", {
				modeEntered = function()
					setWalkSpeed(10)
				end,
				idle = idleL,
				walk = idleL,
				modeLeft = function()
					setWalkSpeed(16)
				end
			})
		end,
		function(t)
			local raycastlegs=t.raycastlegs
			local velbycfrvec=t.velbycfrvec
			local velchgbycfrvec=t.velchgbycfrvec
			local addmode=t.addmode
			local getJoint=t.getJoint
			local RootJoint=getJoint("RootJoint")
			local RightShoulder=getJoint("Right Shoulder")
			local LeftShoulder=getJoint("Left Shoulder")
			local RightHip=getJoint("Right Hip")
			local LeftHip=getJoint("Left Hip")
			local Neck=getJoint("Neck")
		
			addmode("default", {
				idle = function()
					local rY, lY = raycastlegs()
		
					local Cfw, Crt = velchgbycfrvec()
		
					RightShoulder.C0 = Lerp(RightShoulder.C0,cfMul(cf(1, 0.3 + 0.1 * sin(sine * 2), -0.1),angles(-0.5235987755982988 + 0.05235987755982989 * sin((sine + 1.5) * 2), 1.0471975511965976 + 0.08726646259971647 * sin((sine + 0.5) * 2), 0.5235987755982988)),deltaTime) 
					Neck.C0 = Lerp(Neck.C0,cfMul(cf(0, 1, 0),angles(-1.6580627893946132 + 0.08726646259971647 * sin((sine + 0.6) * 2), 0, 3.141592653589793 + 0.2617993877991494 * sin((sine - 1.2) * 1))),deltaTime) 
					RootJoint.C0 = Lerp(RootJoint.C0,cfMul(cf(Crt * 3, 0.1 * sin(sine * 2), Cfw * -3),angles(-1.5707963267948966 + 0.08726646259971647 * sin(sine * 2) - Cfw, Crt, 3.141592653589793)),deltaTime) 
					RightHip.C0 = Lerp(RightHip.C0,cfMul(cf(1, -1 - 0.1 * sin(sine * 2) + rY, 0.1 * sin(sine * 2) - rY * 0.5),angles(-0.6981317007977318 - 0.08726646259971647 * sin(sine * 2), 1.0471975511965976, 0.5235987755982988)),deltaTime) 
					LeftShoulder.C0 = Lerp(LeftShoulder.C0,cfMul(cf(-1, 0.6 + 0.1 * sin(sine * 2), 0),angles(3.141592653589793 + 0.05235987755982989 * sin((sine + 0.5) * 2), -2.705260340591211 + 0.017453292519943295 * sin((sine + 1.5) * 2), -1.2217304763960306 + 0.05235987755982989 * sin((sine + 1.5) * 2))),deltaTime) 
					LeftHip.C0 = Lerp(LeftHip.C0,cfMul(cf(-1, -1 - 0.1 * sin(sine * 2) + lY, 0.1 * sin(sine * 2) - lY * 0.5),angles(-0.3490658503988659 - 0.08726646259971647 * sin(sine * 2), -1.0471975511965976, -0.5235987755982988)),deltaTime) 
					--RightArm,1,0,0,2,-30,3,1.5,2,0.3,0.1,0,2,60,5,0.5,2,-0.1,0,0,2,30,0,0,2,Head,0,0,0,2,-95,5,0.6,2,1,0,0,2,-0,0,0,1,0,0,0,2,180,15,-1.2,1,Torso,0,0,0,2,-90,5,0,2,0,0.1,0,2,-0,0,0,2,0,0,0,2,180,0,0,2,RightLeg,1,0,0,2,-40,-5,0,2,-1,-0.1,0,2,60,0,0,2,0,0.1,0,2,30,0,0,2,Meshes/TrollFaceHeadAccessory_Handle,0.01043701171875,0,0,1,0,0,0,1,0.43610429763793945,0,0,1,0,0,0,1,-0.01102447509765625,0,0,1,0,0,0,1,LeftArm,-1,0,0,2,180,3,0.5,2,0.6,0.1,0,2,-155,1,1.5,2,0,0,0,2,-70,3,1.5,2,LeftLeg,-1,0,0,2,-20,-5,0,2,-1,-0.1,0,2,-60,0,0,2,0,0.1,0,2,-30,0,0,2
				end,
				walk = function()
					local Vfw, Vrt = velbycfrvec()
		
					local rY, lY = raycastlegs()
		
					local Cfw, Crt = velchgbycfrvec()
		
					RootJoint.C0 = Lerp(RootJoint.C0,cfMul(cf(Crt * 3, -0.2 + 0.2 * sin(sine * 16), Cfw * -3),angles(-1.6580627893946132 + 0.04363323129985824 * sin(sine * 16) - Vfw * 0.15 - Cfw, 0.03490658503988659 * sin(sine * 8) + Vrt * 0.15 + Crt, -3.141592653589793 - 0.08726646259971647 * sin((sine + 0.25) * 8) - Vrt * 0.1)),deltaTime) 
					RightHip.C0 = Lerp(RightHip.C0,cfMul(cf(1, -0.8 + 0.4 * sin((sine + 0.125) * 8) + rY, -0.15 * Vfw + 0.4 * sin((sine + 10) * 8) * Vfw + rY * -0.5),angles(1.3962634015954636 + 0.6981317007977318 * sin(sine * 8)*Vfw, 1.5707963267948966 + 0.6981317007977318 * sin(sine * 8)*Vrt, -1.5707963267948966 + 0.2617993877991494 * sin(sine * 8))),deltaTime) 
					LeftShoulder.C0 = Lerp(LeftShoulder.C0,cfMul(cf(-1, 0.35 - 0.1 * sin(sine * 8), 0),angles(0.5235987755982988 * sin(sine * 8)*Vfw, -1.5707963267948966 - 0.5235987755982988 * sin(sine * 8)*Vfw, -0.5235987755982988 * sin(sine * 8)*Vfw)),deltaTime) 
					RightShoulder.C0 = Lerp(RightShoulder.C0,cfMul(cf(1, 0.35 + 0.1 * sin(sine * 8), 0),angles(-0.5235987755982988 * sin(sine * 8)*Vfw, 1.5707963267948966 - 0.5235987755982988 * sin(sine * 8)*Vfw, -0.5235987755982988 * sin(sine * 8)*Vfw)),deltaTime) 
					LeftHip.C0 = Lerp(LeftHip.C0,cfMul(cf(-1, -0.8 - 0.4 * sin((sine + 0.125) * 8) + lY, -0.15 * Vfw - 0.4 * sin((sine + 10) * 8) * Vfw + lY * -0.5),angles(1.3962634015954636 - 0.6981317007977318 * sin(sine * 8)*Vfw, -1.5707963267948966 - 0.6981317007977318 * sin(sine * 8)*Vrt, 1.5707963267948966 + 0.2617993877991494 * sin(sine * 8))),deltaTime) 
					Neck.C0 = Lerp(Neck.C0,cfMul(cf(0, 1, 0),angles(-1.5707963267948966 + 0.08726646259971647 * sin((sine + 10) * 16) + Vfw * 0.15, -0.08726646259971647 * sin(sine * 8) + Vrt * -0.1, 3.141592653589793 - 0.05235987755982989 * sin((sine + 5) * 8) - Vrt * 0.5)),deltaTime) 
					--Torso,0,0,0,8,-95,2.5,0,16,-0.2,0.2,0,16,0,5,0,8,0,0,0,8,-180,-5,0.25,8,RightArm,1,0,0,1,0,-30,0,8,0.35,0.1,0,8,90,-30,0,8,0,0,0,8,0,-30,0,8,RightLeg,1,0,0,8,80,40,0,8,-0.8,0.4,0.125,8,90,40,0,8,-0.15,0.4,10,8,-90,15,0,8,LeftLeg,-1,0,0,8,80,-40,0,8,-0.8,-0.4,0.125,8,-90,-40,0,8,-0.15,-0.4,10,8,90,15,0,8,Head,0,0,0,1,-90,2.5,10,16,1,0,0,1,-0,-5,0,8,0,0,0,1,180,-3,5,8,LeftArm,-1,0,0,1,0,30,0,8,0.35,-0.1,0,8,-90,-30,0,8,0,-0.4,0,8,0,-30,0,8
				end,
				jump = function()
					local Vfw, Vrt = velbycfrvec()
		
					local Cfw, Crt = velchgbycfrvec()
		
					RootJoint.C0 = Lerp(RootJoint.C0,cfMul(cf(Crt * 3, 0, Cfw * -3),angles(-1.4835298641951802 + Vfw * 0.1 - Cfw, Vrt * -0.05 + Crt, -3.141592653589793)),deltaTime) 
					RightShoulder.C0 = Lerp(RightShoulder.C0,cfMul(cf(1, 0.5, 0),angles(4.014257279586958 - 0.08726646259971647 * sin((sine + 0.5) * 4), 1.7453292519943295 + 0.08726646259971647 * sin((sine + 0.25) * 4), -1.5707963267948966)),deltaTime) 
					LeftHip.C0 = Lerp(LeftHip.C0,cfMul(cf(-1, -1, 0),angles(1.5707963267948966 - 0.08726646259971647 * sin((sine + 0.5) * 4), -1.6580627893946132 + 0.06981317007977318 * sin((sine + 0.25) * 4), 1.5707963267948966)),deltaTime) 
					LeftShoulder.C0 = Lerp(LeftShoulder.C0,cfMul(cf(-1, 0.5, 0),angles(4.014257279586958 - 0.08726646259971647 * sin((sine + 0.5) * 4), -1.7453292519943295 - 0.08726646259971647 * sin((sine + 0.25) * 4), 1.5707963267948966)),deltaTime) 
					Neck.C0 = Lerp(Neck.C0,cfMul(cf(0, 1, 0),angles(-1.3962634015954636, 0, -3.141592653589793 - Vrt)),deltaTime) 
					RightHip.C0 = Lerp(RightHip.C0,cfMul(cf(1, -1, 0),angles(1.5707963267948966 - 0.08726646259971647 * sin((sine + 0.5) * 4), 1.6580627893946132 - 0.06981317007977318 * sin((sine + 0.25) * 4), -1.5707963267948966)),deltaTime) 
					--Torso,0,0,0,4,-85,0,0,4,0,0,0,4,0,0,0,4,0,0,0,4,-180,0,0,4,RightArm,1,0,0,4,230,-5,0.5,4,0.5,0,0,4,100,5,0.25,4,0,0,0,4,-90,0,0,4,LeftLeg,-1,0,0,4,90,-5,0.5,4,-1,0,0,4,-95,4,0.25,4,0,0,0,4,90,0,0,4,LeftArm,-1,0,0,4,230,-5,0.5,4,0.5,0,0,4,-100,-5,0.25,4,0,0,0,4,90,0,0,4,Head,0,0,0,4,-80,0,0.5,4,1,0,0,4,0,0,0.25,4,0,0,0,4,-180,0,0,4,RightLeg,1,0,0,4,90,-5,0.5,4,-1,0,0,4,95,-4,0.25,4,0,0,0,4,-90,0,0,4
				end,
				fall = function()
					local Vfw, Vrt = velbycfrvec()
		
					local Cfw, Crt = velchgbycfrvec()
		
					RootJoint.C0 = Lerp(RootJoint.C0,cfMul(cf(Crt * 3, 0, Cfw * -3),angles(-1.6580627893946132 + Vfw * 0.1 - Cfw, Vrt * -0.05 + Crt, -3.141592653589793)),deltaTime) 
					RightShoulder.C0 = Lerp(RightShoulder.C0,cfMul(cf(1, 0.5, 0),angles(4.014257279586958 - 0.08726646259971647 * sin((sine + 0.5) * 4), 1.7453292519943295 + 0.08726646259971647 * sin((sine + 0.25) * 4), -1.5707963267948966)),deltaTime) 
					LeftHip.C0 = Lerp(LeftHip.C0,cfMul(cf(-1, -1, 0),angles(1.5707963267948966 - 0.08726646259971647 * sin((sine + 0.5) * 4), -1.6580627893946132 + 0.06981317007977318 * sin((sine + 0.25) * 4), 1.5707963267948966)),deltaTime) 
					LeftShoulder.C0 = Lerp(LeftShoulder.C0,cfMul(cf(-1, 0.5, 0),angles(4.014257279586958 - 0.08726646259971647 * sin((sine + 0.5) * 4), -1.7453292519943295 - 0.08726646259971647 * sin((sine + 0.25) * 4), 1.5707963267948966)),deltaTime) 
					Neck.C0 = Lerp(Neck.C0,cfMul(cf(0, 1, 0),angles(-1.7453292519943295, 0, -3.141592653589793 - Vrt)),deltaTime) 
					RightHip.C0 = Lerp(RightHip.C0,cfMul(cf(1, -1, 0),angles(1.5707963267948966 - 0.08726646259971647 * sin((sine + 0.5) * 4), 1.6580627893946132 - 0.06981317007977318 * sin((sine + 0.25) * 4), -1.5707963267948966)),deltaTime) 
					--Torso,0,0,0,4,-95,0,0,4,0,0,0,4,0,0,0,4,0,0,0,4,-180,0,0,4,RightArm,1,0,0,4,230,-5,0.5,4,0.5,0,0,4,100,5,0.25,4,0,0,0,4,-90,0,0,4,LeftLeg,-1,0,0,4,90,-5,0.5,4,-1,0,0,4,-95,4,0.25,4,0,0,0,4,90,0,0,4,LeftArm,-1,0,0,4,230,-5,0.5,4,0.5,0,0,4,-100,-5,0.25,4,0,0,0,4,90,0,0,4,Head,0,0,0,4,-100,0,0.5,4,1,0,0,4,0,0,0.25,4,0,0,0,4,-180,0,0,4,RightLeg,1,0,0,4,90,-5,0.5,4,-1,0,0,4,95,-4,0.25,4,0,0,0,4,-90,0,0,4
				end
			})
		
			addmode("q", {
				idle = function()
					local Cfw, Crt = velchgbycfrvec()
		
					LeftShoulder.C0 = Lerp(LeftShoulder.C0,cfMul(cf(-1, 0.75, -0.2),angles(2.705260340591211 - 0.08726646259971647 * sin((sine + 0.1) * 2), -2.792526803190927, -0.6981317007977318)),deltaTime) 
					RightShoulder.C0 = Lerp(RightShoulder.C0,cfMul(cf(1, 0.75, -0.2),angles(2.705260340591211 - 0.08726646259971647 * sin((sine + 0.1) * 2), 2.792526803190927, 0.6981317007977318)),deltaTime) 
					Neck.C0 = Lerp(Neck.C0,cfMul(cf(0, 1, 0),angles(-1.9198621771937625 - 0.10471975511965978 * sin((sine + 0.3) * 2), 0, 3.141592653589793)),deltaTime) 
					RootJoint.C0 = Lerp(RootJoint.C0,cfMul(cf(Crt * 3, -2.45 - 0.05 * sin(sine * 2), Cfw * -3),angles(0.03490658503988659 * sin(sine * 2) - Cfw, Crt, 3.141592653589793)),deltaTime) 
					RightHip.C0 = Lerp(RightHip.C0,cfMul(cf(1, -1, 0),angles(1.3962634015954636 - 0.03490658503988659 * sin(sine * 2), 1.3089969389957472, -0.9599310885968813)),deltaTime) 
					LeftHip.C0 = Lerp(LeftHip.C0,cfMul(cf(-1, -1, 0),angles(1.5707963267948966 - 0.03490658503988659 * sin(sine * 2), -1.3089969389957472, 1.5707963267948966)),deltaTime) 
					--LeftArm,-1,0,0,2,155,-5,0.1,2,0.75,0,0,2,-160,0,0,2,-0.2,0,0,2,-40,0,0,2,RightArm,1,0,0,2,155,-5,0.1,2,0.75,0,0,2,160,0,0,2,-0.2,0,0,2,40,0,0,2,Head,0,0,0,2,-110,-6,0.3,2,1,0,0,2,-0,0,0,2,0,0,0,2,180,0,0,2,Torso,0,0,0,2,0,2,0,2,-2.45,-0.05,0,2,-0,0,0,2,0,0,0,2,180,0,0,2,RightLeg,1,0,0,2,80,-2,0,2,-1,0,0,2,75,0,0,2,0,0,0,2,-55,0,0,2,LeftLeg,-1,0,0,2,90,-2,0,2,-1,0,0,2,-75,0,0,2,0,0,0,2,90,0,0,2
				end
			})
			addmode("e", {
				idle = function()
					local Cfw, Crt = velchgbycfrvec()
		
					LeftShoulder.C0 = Lerp(LeftShoulder.C0,cfMul(cf(-0.9, 0.4 + 0.1 * sin(sine * 2), 0.3 - 0.15 * sin(sine * 2)),angles(-1.0471975511965976 - 0.12217304763960307 * sin(sine * 2), -1.3962634015954636, -0.6981317007977318)),deltaTime) 
					RootJoint.C0 = Lerp(RootJoint.C0,cfMul(cf(Crt * 3, -1.85 - 0.1 * sin((sine + 0.2) * 2), Cfw * -3),angles(-1.3962634015954636 + 0.03490658503988659 * sin(sine * 2) - Cfw, -0.08726646259971647 + Crt, 3.141592653589793)),deltaTime) 
					RightShoulder.C0 = Lerp(RightShoulder.C0,cfMul(cf(1, 0.4 + 0.1 * sin(sine * 2), 0.2 - 0.15 * sin(sine * 2)),angles(0.6108652381980153 - 0.12217304763960307 * sin(sine * 2), 1.2217304763960306, -0.7853981633974483)),deltaTime) 
					Neck.C0 = Lerp(Neck.C0,cfMul(cf(0, 1, 0),angles(-1.6580627893946132 - 0.03490658503988659 * sin((sine + 0.6) * 2), 0.10471975511965978 + 0.06981317007977318 * sin(sine * 0.66), 3.141592653589793 + 0.3490658503988659 * sin(sine * 0.66))),deltaTime) 
					RightHip.C0 = Lerp(RightHip.C0,cfMul(cf(1, 0.2 + 0.15 * sin((sine + 0.2) * 2), -0.7 + 0.1 * sin(sine * 2)),angles(1.4835298641951802 + 0.03490658503988659 * sin(sine * 2), 1.4835298641951802, -1.5707963267948966)),deltaTime) 
					LeftHip.C0 = Lerp(LeftHip.C0,cfMul(cf(-1, -0.75 + 0.1 * sin((sine + 0.2) * 2), -0.5),angles(1.3962634015954636 - 0.03490658503988659 * sin(sine * 2), -1.6580627893946132, 0)),deltaTime) 
					--LeftArm,-0.9,0,0,2,-60,-7,0,2,0.4,0.1,0,2,-80,0,0,2,0.3,-0.15,0,2,-40,0,0,2,Torso,0,0,0,2,-80,2,0,2,-1.85,-0.1,0.2,2,-5,0,0,2,0,0,0,2,180,0,0,2,RightArm,1,0,0,2,35,-7,0,2,0.4,0.1,0,2,70,0,0,2,0.2,-0.15,0,2,-45,0,0,2,Head,0,0,0,2,-95,-2,0.6,2,1,0,0,2,6,4,0,0.66,0,0,0,2,180,20,0,0.66,RightLeg,1,0,0,2,85,2,0,2,0.2,0.15,0.2,2,85,0,0,2,-0.7,0.1,0,2,-90,0,0,2,LeftLeg,-1,0,0,2,80,-2,0,2,-0.75,0.1,0.2,2,-95,0,0,2,-0.5,0,0,2,0,0,0,2
				end
			})
			addmode("r", {
				idle = function()
					local Cfw, Crt = velchgbycfrvec()
		
					RightHip.C0 = Lerp(RightHip.C0,cfMul(cf(1, -0.9 - 0.2 * sin(sine * 2), 0),angles(1.5707963267948966, 1.6580627893946132 - 0.17453292519943295 * sin(sine + 0.8), -1.5707963267948966)),deltaTime) 
					RootJoint.C0 = Lerp(RootJoint.C0,cfMul(cf(0.3 * sin(sine + 0.8) + Crt * 3, -0.1 + 0.2 * sin(sine * 2), Cfw * -3),angles(-1.5707963267948966 - Cfw, Crt, -3.141592653589793)),deltaTime) 
					Neck.C0 = Lerp(Neck.C0,cfMul(cf(0, 1, 0),angles(-1.5707963267948966 + 0.08726646259971647 * sin((sine - 0.5) * 2), 0.08726646259971647 * sin(sine - 1), -3.141592653589793 + 0.2617993877991494 * sin(sine * 5))),deltaTime) 
					LeftShoulder.C0 = Lerp(LeftShoulder.C0,cfMul(cf(-1 + 0.1 * sin(sine * 7), 0.2 - 0.1 * sin(sine + 0.8), -0.25),angles(1.5707963267948966 + 0.5235987755982988 * sin(sine * 7), -0.6981317007977318, 0.3490658503988659 * sin(sine * 7))),deltaTime) 
					LeftHip.C0 = Lerp(LeftHip.C0,cfMul(cf(-1, -0.9 - 0.2 * sin(sine * 2), 0),angles(1.5707963267948966, -1.6580627893946132 - 0.17453292519943295 * sin(sine + 0.8), 1.5707963267948966)),deltaTime) 
					RightShoulder.C0 = Lerp(RightShoulder.C0,cfMul(cf(1 + 0.1 * sin(sine * 7), 0.2 + 0.1 * sin(sine + 0.8), -0.25),angles(1.5707963267948966 - 0.5235987755982988 * sin(sine * 7), 0.6981317007977318, 0.3490658503988659 * sin(sine * 7))),deltaTime) 
					--RightLeg,1,0,0,1,90,0,0,1,-0.9,-0.2,0,2,95,-10,0.8,1,0,0,0,1,-90,0,0,1,Torso,0,0.3,0.8,1,-90,0,0,1,-0.1,0.2,0,2,0,0,0,1,0,0,0,1,-180,0,0,1,Head,0,0,0,1,-90,5,-0.5,2,1,0,0,1,0,5,-1,1,0,0,0,1,-180,15,0,5,Fedora_Handle,8.657480066176504e-09,0,0,1,-6,0,0,1,-0.15052366256713867,0,0,1,0,0,0,1,-0.010221302509307861,0,0,1,0,0,0,1,LeftArm,-1,0.1,0,7,90,30,0,7,0.2,-0.1,0.8,1,-40,0,0,1,-0.25,0,0,1,0,20,0,7,LeftLeg,-1,0,0,1,90,0,0,1,-0.9,-0.2,0,2,-95,-10,0.8,1,0,0,0,1,90,0,0,1,RightArm,1,0.1,0,7,90,-30,0,7,0.2,0.1,0.8,1,40,0,0,1,-0.25,0,0,1,-0,20,0,7
				end
			})
			addmode("t", {
				idle = function()
					local Cfw, Crt = velchgbycfrvec()
		
					LeftShoulder.C0 = Lerp(LeftShoulder.C0,cfMul(cf(-1, 0.5, 0),angles(1.5707963267948966, -1.6580627893946132 + 0.08726646259971647 * sin((sine - 0.3) * 4), 1.5707963267948966)),deltaTime) 
					RightShoulder.C0 = Lerp(RightShoulder.C0,cfMul(cf(1 + 0.15 * sin((sine - 0.4) * 4), 1.42, 0),angles(1.5707963267948966, 1.4835298641951802 - 0.3490658503988659 * sin((sine - 0.4) * 4), 1.5707963267948966)),deltaTime) 
					Neck.C0 = Lerp(Neck.C0,cfMul(cf(0, 1, 0),angles(-1.4835298641951802, 0.04363323129985824 - 0.08726646259971647 * sin((sine + 0.1) * 4), -3.141592653589793 + 0.04363323129985824 * sin(sine * 4))),deltaTime) 
					RootJoint.C0 = Lerp(RootJoint.C0,cfMul(cf(0.1 * sin(sine * 4) + Crt * 3, 0, Cfw * -3),angles(-1.5707963267948966 - Cfw, -0.08726646259971647 + 0.08726646259971647 * sin(sine * 4) + Crt, -3.141592653589793)),deltaTime) 
					RightHip.C0 = Lerp(RightHip.C0,cfMul(cf(1, -1.1 + 0.1 * sin(sine * 4), 0),angles(1.5707963267948966, 1.5707963267948966 + 0.08726646259971647 * sin(sine * 4), -1.5707963267948966)),deltaTime) 
					LeftHip.C0 = Lerp(LeftHip.C0,cfMul(cf(-1 - 0.02 * sin(sine * 4), -0.925 - 0.07 * sin(sine * 4), 0),angles(1.5707963267948966, -1.7453292519943295 + 0.08726646259971647 * sin(sine * 4), 1.5707963267948966)),deltaTime) 
					--LeftArm,-1,0,0,4,90,0,0,4,0.5,0,0,4,-95,5,-0.3,4,0,0,0,4,90,0,0,4,RightArm,1,0.15,-0.4,4,90,0,0,4,1.42,0,0,4,85,-20,-0.4,4,0,0,0,4,90,0,0,4,Head,0,0,0,4,-85,0,0,4,1,0,0,4,2.5,-5,0.1,4,0,0,0,4,-180,2.5,0,4,Torso,0,0.1,0,4,-90,0,0,4,0,0,0,4,-5,5,0,4,0,0,0,4,-180,0,0,4,RightLeg,1,0,0,4,90,0,0,4,-1.1,0.1,0,4,90,5,0,4,0,0,0,4,-90,0,0,4,LeftLeg,-1,-0.02,0,4,90,0,0,4,-0.925,-0.07,0,4,-100,5,0,4,0,0,0,4,90,0,0,4
				end
			})
			addmode("y", {
				idle = function()
					local Cfw, Crt = velchgbycfrvec()
		
					LeftShoulder.C0 = Lerp(LeftShoulder.C0,cfMul(cf(-1.5, 0.5, 0),angles(-1.7453292519943295, 0.17453292519943295 - 0.04363323129985824 * sin(sine * 2), -1.4835298641951802)),deltaTime) 
					RightHip.C0 = Lerp(RightHip.C0,cfMul(cf(1, -0.9000000953674316 - 0.1 * sin(sine * 2), 0),angles(-1.3962634015954636, 1.3962634015954636, 1.5707963267948966)),deltaTime) 
					LeftHip.C0 = Lerp(LeftHip.C0,cfMul(cf(-1, -1.0000001192092896 - 0.1 * sin(sine * 2), 0),angles(-1.5707963267948966, -1.3962634015954636, -1.5707963267948966)),deltaTime) 
					Neck.C0 = Lerp(Neck.C0,cfMul(cf(0, 1, 0),angles(-2.0943951023931953 + 0.08726646259971647 * sin((sine - 1) * 2), -0.08726646259971647, 2.792526803190927)),deltaTime) 
					RightShoulder.C0 = Lerp(RightShoulder.C0,cfMul(cf(1, 1.2000000476837158, 0),angles(2.6179938779914944 + 0.08726646259971647 * sin((sine - 1) * 2), 0.6981317007977318, -1.3962634015954636)),deltaTime) 
					RootJoint.C0 = Lerp(RootJoint.C0,cfMul(cf(Crt * 3, 0.1 * sin(sine * 2), Cfw * -3),angles(-1.6580627893946132 - Cfw, 0.08726646259971647 + Crt, 3.0543261909900767)),deltaTime) 
					--LeftArm,-1.5,0,0,2,-100,0,0,2,0.5,0,0,2,10,-2.5,0,2,0,0,0,2,-85,0,0,2,RightLeg,1,0,0,2,-80,0,0,2,-0.9000000953674316,-0.1,0,2,80,0,0,2,0,0,0,2,90,0,0,2,LeftLeg,-1,0,0,2,-90,0,0,2,-1.0000001192092896,-0.1,0,2,-80,0,0,2,0,0,0,2,-90,0,0,2,Fedora_Handle,8.657480066176504e-09,0,0,2,-6,0,0,2,-0.15052366256713867,0,0,2,0,0,0,2,-0.010221302509307861,0,0,2,0,0,0,2,Head,0,0,0,2,-120,5,-1,2,1,0,0,2,-5,0,0,2,0,0,0,2,160,0,0,2,RightArm,1,0,0,2,150,5,-1,2,1.2000000476837158,0,0,2,40,0,0,2,0,0,0,2,-80,0,0,2,Torso,0,0,0,2,-95,0,0,2,0,0.1,0,2,5,0,0,2,0,0,0,2,175,0,0,2
				end
			})
			addmode("u", {
				idle = function()
					local Cfw, Crt = velchgbycfrvec()
		
					RootJoint.C0 = Lerp(RootJoint.C0,cfMul(cf(Crt * 3, 0.75 + 0.25 * sin(sine * 2), Cfw * -3),angles(-1.5707963267948966 - Cfw, Crt, 3.141592653589793)),deltaTime) 
					Neck.C0 = Lerp(Neck.C0,cfMul(cf(0, 1.5 - 0.1 * sin((sine + 0.2) * 2), 0),angles(-1.5707963267948966 - 0.08726646259971647 * sin((sine + 0.4) * 2), 0, 3.141592653589793 + 0.3490658503988659 * sin(sine * 0.66))),deltaTime) 
					LeftHip.C0 = Lerp(LeftHip.C0,cfMul(cf(-0.5 - 1 * sin((sine + 0.2) * 2.2), -0.75 - 0.25 * sin(sine * 2), 1 * sin((sine + 0.95) * 2.2)),angles(0, -1.5707963267948966, 0)),deltaTime) 
					RightHip.C0 = Lerp(RightHip.C0,cfMul(cf(0.5 + 1 * sin((sine + 0.2) * 2.2), -0.75 - 0.25 * sin(sine * 2), -1 * sin((sine + 0.95) * 2.2)),angles(0, 1.5707963267948966, 0)),deltaTime) 
					RightShoulder.C0 = Lerp(RightShoulder.C0,cfMul(cf(-0.5 - 1.85 * sin(sine * 2), 0.8 - 0.5 * sin(sine * 2), -1.85 * sin((sine + 0.75) * 2)),angles(0, 1.5707963267948966, 0)),deltaTime) 
					LeftShoulder.C0 = Lerp(LeftShoulder.C0,cfMul(cf(0.5 + 1.85 * sin(sine * 2), 0.8 - 0.5 * sin(sine * 2), 1.85 * sin((sine + 0.75) * 2)),angles(0, -1.5707963267948966, 0)),deltaTime) 
					--Torso,0,0,0,2,-90,0,0,2,0.75,0.25,0,2,-0,0,0,2,0,0,0,2,180,0,0,2,Fedora_Handle,8.657480066176504e-09,0,0,2,-6,0,0,2,-0.15052366256713867,0,0,2,0,0,0,2,-0.010221302509307861,0,0,2,0,0,0,2,Head,0,0,0,2,-90,-5,0.4,2,1.5,-0.1,0.2,2,-0,0,0,2,0,0,0,2,180,20,0,0.66,LeftLeg,-0.5,-1,0.2,2.2,-0,0,0,2,-0.75,-0.25,0,2,-90,0,0,2,0,1,0.95,2.2,0,0,0,2,RightLeg,0.5,1,0.2,2.2,0,0,0,2,-0.75,-0.25,0,2,90,0,0,2,0,-1,0.95,2.2,0,0,0,2,RightArm,-0.5,-1.85,0,2,0,0,0,2,0.8,-0.5,0,2,90,0,0,2,0,-1.85,0.75,2,0,0,0,2,LeftArm,0.5,1.85,0,2,-0,0,0,2,0.8,-0.5,0,2,-90,0,0,2,0,1.85,0.75,2,0,0,0,2
				end
			})
			addmode("i", {
				idle = function()
					local Cfw, Crt = velchgbycfrvec()
		
					LeftShoulder.C0 = Lerp(LeftShoulder.C0,cfMul(cf(-0.5, 0.5 + 0.1 * sin((sine - 0.4444444444444444) * 9), 0),angles(2.9670597283903604 + 0.17453292519943295 * sin((sine - 0.17777777777777778) * 9), -0.5235987755982988, 1.5707963267948966 + 0.17453292519943295 * sin(sine * 4.5))),deltaTime) 
					LeftHip.C0 = Lerp(LeftHip.C0,cfMul(cf(-1, -0.5 + 0.1 * sin((sine + 0.26666666666666666) * 4.5), -0.5),angles(1.7453292519943295 - 1.0471975511965976 * sin(sine * 4.5), -1.5707963267948966 + 0.03490658503988659 * sin(sine * 4.5), 1.5707963267948966)),deltaTime) 
					RootJoint.C0 = Lerp(RootJoint.C0,cfMul(cf(Crt * 3, -0.5 + 0.5 * sin((sine + 0.17777777777777778) * 9), Cfw * -3),angles(-1.3962634015954636 - 0.03490658503988659 * sin((sine + 0.17777777777777778) * 9) - Cfw, -0.05235987755982989 * sin(sine * 4.5) + Crt, 3.141592653589793 + 0.03490658503988659 * sin(sine * 4.5))),deltaTime) 
					Neck.C0 = Lerp(Neck.C0,cfMul(cf(0, 1 + 0.2 * sin(sine * 9), 0),angles(-1.5707963267948966 + 0.08726646259971647 * sin(sine * 9), 0.08726646259971647 * sin(sine * 4.5), 3.141592653589793 - 0.06981317007977318 * sin(sine * 4.5))),deltaTime) 
					RightShoulder.C0 = Lerp(RightShoulder.C0,cfMul(cf(0.5, 0.5 + 0.1 * sin((sine - 0.4444444444444444) * 9), 0),angles(2.9670597283903604 + 0.17453292519943295 * sin((sine - 0.17777777777777778) * 9), 0.5235987755982988, -1.5707963267948966 + 0.17453292519943295 * sin(sine * 4.5))),deltaTime) 
					RightHip.C0 = Lerp(RightHip.C0,cfMul(cf(1, -0.5 + 0.1 * sin((sine - 0.26666666666666666) * 4.5), -0.5),angles(1.7453292519943295 + 1.0471975511965976 * sin(sine * 4.5), 1.5707963267948966 + 0.03490658503988659 * sin(sine * 4.5), -1.5707963267948966)),deltaTime) 
					--LeftArm,-0.5,0,0,4.5,170,10,-0.17777777777777778,9,0.5,0.1,-0.4444444444444444,9,-30,0,0,4.5,0,0,0,4.5,90,10,0,4.5,LeftLeg,-1,0,0,4.5,100,-60,0,4.5,-0.5,0.1,0.26666666666666666,4.5,-90,2,0,4.5,-0.5,0,0,4.5,90,0,0,4.5,Torso,0,0,0,4.5,-80,-2,0.17777777777777778,9,-0.5,0.5,0.17777777777777778,9,-0,-3,0,4.5,0,0,0,4.5,180,2,0,4.5,Head,0,0,0,4.5,-90,5,0,9,1,0.2,0,9,-0,5,0,4.5,0,0,0,4.5,180,-4,0,4.5,RightArm,0.5,0,0,4.5,170,10,-0.17777777777777778,9,0.5,0.1,-0.4444444444444444,9,30,0,0,4.5,0,0,0,4.5,-90,10,0,4.5,RightLeg,1,0,0,4.5,100,60,0,4.5,-0.5,0.1,-0.26666666666666666,4.5,90,2,0,4.5,-0.5,0,0,4.5,-90,0,0,4.5
				end,
			})
			addmode("o", {
				idle = function()
					local rY, lY = raycastlegs()
		
					local Cfw, Crt = velchgbycfrvec()
		
					LeftHip.C0 = Lerp(LeftHip.C0,cfMul(cf(-1, -1 + lY, lY * -0.5),angles(-1.8325957145940461 - 0.08726646259971647 * sin(sine * 2), -1.4835298641951802, -1.5707963267948966)),deltaTime) 
					RootJoint.C0 = Lerp(RootJoint.C0,cfMul(cf(Crt, 0, 0.09 * sin(sine * 2) - Cfw * 3),angles(-1.3962634015954636 + 0.08726646259971647 * sin(sine * 2) - Cfw, -0.08726646259971647 + Crt, 3.141592653589793)),deltaTime) 
					LeftShoulder.C0 = Lerp(LeftShoulder.C0,cfMul(cf(-1, 0.5, 0),angles(2.9670597283903604 + 0.08726646259971647 * sin(sine * 1), -1.5707963267948966 + 0.08726646259971647 * sin((sine + 0.6) * 1), 1.5707963267948966)),deltaTime) 
					RightHip.C0 = Lerp(RightHip.C0,cfMul(cf(1, -1.1 + rY, rY * -0.5),angles(-1.7453292519943295 - 0.08726646259971647 * sin(sine * 2), 1.5707963267948966, 1.5707963267948966)),deltaTime) 
					Neck.C0 = Lerp(Neck.C0,cfMul(cf(0, 1, 0),angles(-1.2217304763960306 - 0.08726646259971647 * sin((sine + 0.3) * 2), -0.2617993877991494 - 0.08726646259971647 * sin(sine * 2), 3.141592653589793)),deltaTime) 
					RightShoulder.C0 = Lerp(RightShoulder.C0,cfMul(cf(1, 0.5, 0),angles(2.8797932657906435 + 0.08726646259971647 * sin(sine * 1), 1.5707963267948966 - 0.08726646259971647 * sin((sine + 0.6) * 1), -1.5707963267948966)),deltaTime) 
					--LeftLeg,-1,0,0,2,-105,-5,0,2,-1,0,0,2,-85,0,0,2,0,0,0,2,-90,0,0.75,2,Torso,0,0,0,2,-80,5,0,2,0,0,0,2,-5,0,0,2,0,0.09,0,2,180,0,0,2,LeftArm,-1,0,0,2,170,5,0,1,0.5,0,0,2,-90,5,0.6,1,0,0,0,2,90,0,0,2,RightLeg,1,0,0,2,-100,-5,0,2,-1.1,0,0,2,90,0,0,2,0,0,0,2,90,0,0.75,2,Head,0,0,0,2,-70,-5,0.3,2,1,0,0,2,-15,-5,0,2,0,0,0,2,180,0,0,2,RightArm,1,0,0,2,165,5,0,1,0.5,0,0,2,90,-5,0.6,1,0,0,0,2,-90,0,0,2
				end,
				walk = function()
					local Vfw, Vrt = velbycfrvec()
		
					local rY, lY = raycastlegs()
		
					local Cfw, Crt = velchgbycfrvec()
		
					Neck.C0 = Lerp(Neck.C0,cfMul(cf(0, 1, 0),angles(-1.5707963267948966 + 0.04363323129985824 * sin(sine * 16), 0, 3.141592653589793 + 0.08726646259971647 * sin(sine * 8) - Vrt)),deltaTime) 
					RightHip.C0 = Lerp(RightHip.C0,cfMul(cf(1, -1 - 0.3 * sin((sine + 0.15) * 8) + rY, rY * -0.5),angles(-1.5707963267948966 - 0.6981317007977318 * sin(sine * 8) * Vfw, 1.5707963267948966 + 0.6981317007977318 * sin(sine * 8) * Vrt, 1.5707963267948966)),deltaTime) 
					RightShoulder.C0 = Lerp(RightShoulder.C0,cfMul(cf(1, 0.5, 0),angles(0.08726646259971647 * sin((sine - 0.05) * 16), 1.5707963267948966 + 0.08726646259971647 * sin(sine * 8) - Vrt/3, 1.5707963267948966)),deltaTime) 
					LeftShoulder.C0 = Lerp(LeftShoulder.C0,cfMul(cf(-1, 0.5, 0),angles(0.08726646259971647 * sin((sine - 0.05) * 16), -1.5707963267948966 + 0.08726646259971647 * sin(sine * 8) - Vrt/3, -1.5707963267948966)),deltaTime) 
					RootJoint.C0 = Lerp(RootJoint.C0,cfMul(cf(Crt * 3, 0.1 * sin((sine + 0.1) * 16), Cfw * -3),angles(-1.5707963267948966 - Cfw, Crt, 3.141592653589793 - 0.08726646259971647 * sin(sine * 8))),deltaTime) 
					LeftHip.C0 = Lerp(LeftHip.C0,cfMul(cf(-1, -1 + 0.3 * sin((sine + 0.15) * 8) + lY, lY * -0.5),angles(1.5707963267948966 + 0.6981317007977318 * sin(sine * 8) * Vfw, -1.5707963267948966 + 0.6981317007977318 * sin(sine * 8) * Vrt, 1.5707963267948966)),deltaTime) 
					--Head,0,0,0,8,-90,2.5,0,16,1,0,0,8,-0,0,0,8,0,0,0,8,180,5,0,8,RightLeg,1,0,0,8,-90,-40,0,8,-1,-0.3,0.15,8,90,40,0,8,0,0,0,8,90,0,0,8,RightArm,1,0,0,8,0,5,-0.05,16,0.5,0,0,8,90,5,0,8,0,0,0,8,90,0,0,8,LeftArm,-1,0,0,8,0,5,-0.05,16,0.5,0,0,8,-90,5,0,8,0,0,0,8,-90,0,0,8,Torso,0,0,0,8,-90,0,0,8,0,0.1,0.1,16,-0,0,0,8,0,0,0,8,180,-5,0,8,LeftLeg,-1,0,0,8,90,40,0,8,-1,0.3,0.15,8,-90,40,0,8,0,0,0,8,90,0,0,8
				end
			})
			addmode("p", {
				idle = function()
					local Cfw, Crt = velchgbycfrvec()
		
					RightShoulder.C0 = Lerp(RightShoulder.C0,cfMul(cf(1.5, 0.5, 0),angles(1.5707963267948966, 3.141592653589793, -1.5707963267948966)),deltaTime) 
					RightHip.C0 = Lerp(RightHip.C0,cfMul(cf(1, -1, 0),angles(0, 1.5707963267948966, 0)),deltaTime) 
					LeftShoulder.C0 = Lerp(LeftShoulder.C0,cfMul(cf(-1.5, 0.5, 0),angles(1.5707963267948966, 3.141592653589793, 1.5707963267948966)),deltaTime) 
					LeftHip.C0 = Lerp(LeftHip.C0,cfMul(cf(-1, -1, 0),angles(0, -1.5707963267948966, 0)),deltaTime) 
					Neck.C0 = Lerp(Neck.C0,cfMul(cf(0, 1, 0),angles(-1.5707963267948966, 0, -3.141592653589793)),deltaTime) 
					RootJoint.C0 = Lerp(RootJoint.C0,cfMul(cf(Crt * 3, 0, Cfw * -3),angles(-1.5707963267948966 - Cfw, Crt, -3.141592653589793)),deltaTime) 
					--RightArm,1.5,0,0,1,90,0,0,1,0.5,0,0,1,180,0,0,1,0,0,0,1,-90,0,0,1,RightLeg,1,0,0,1,0,0,0,1,-1,0,0,1,90,0,0,1,0,0,0,1,0,0,0,1,Fedora_Handle,8.657480066176504e-09,0,0,1,-6,0,0,1,-0.15052366256713867,0,0,1,0,0,0,1,-0.010221302509307861,0,0,1,0,0,0,1,LeftArm,-1.5,0,0,1,90,0,0,1,0.5,0,0,1,180,0,0,1,0,0,0,1,90,0,0,1,LeftLeg,-1,0,0,1,-0,0,0,1,-1,0,0,1,-90,0,0,1,0,0,0,1,0,0,0,1,Head,0,0,0,1,-90,0,0,1,1,0,0,1,0,0,0,1,0,0,0,1,-180,0,0,1,Torso,0,0,0,1,-90,0,0,1,0,0,0,1,0,0,0,1,0,0,0,1,-180,0,0,1
				end
			})
			addmode("f", {
				idle = function()
					local Cfw, Crt = velchgbycfrvec()
		
					LeftShoulder.C0 = Lerp(LeftShoulder.C0,cfMul(cf(-1, 0.5, 0),angles(-3.0543261909900767 - 0.17453292519943295 * sin((sine + 1.5) * 1), -1.5707963267948966 + 0.08726646259971647 * sin((sine + 0.6) * 1), -1.5707963267948966)),deltaTime) 
					RightShoulder.C0 = Lerp(RightShoulder.C0,cfMul(cf(1, 0.5, 0),angles(3.141592653589793 - 0.08726646259971647 * sin(sine * 1), 0.3490658503988659 + 0.08726646259971647 * sin((sine + 0.3) * 1), -1.9198621771937625 + 0.08726646259971647 * sin((sine + 1) * 1))),deltaTime) 
					Neck.C0 = Lerp(Neck.C0,cfMul(cf(0, 1, 0),angles(-1.3089969389957472 - 0.2617993877991494 * sin((sine + 1.2) * 1), 0.08726646259971647 * sin((sine + 0.2) * 0.5), -2.9670597283903604)),deltaTime) 
					RootJoint.C0 = Lerp(RootJoint.C0,cfMul(cf(Crt * 3, 5 - 0.5 * sin((sine - 0.2) * 1), 0.2 * sin((sine - 1.2) * 1) - Cfw * 3),angles(-0.08726646259971647 + 0.17453292519943295 * sin((sine + 1.2) * 1) - Cfw, 0.08726646259971647 * sin(sine * 0.5) + Crt, 3.141592653589793)),deltaTime) 
					LeftHip.C0 = Lerp(LeftHip.C0,cfMul(cf(-1, -1, 0),angles(1.3962634015954636 + 0.12217304763960307 * sin((sine + 1.5) * 1), -1.2217304763960306 + 0.08726646259971647 * sin((sine + 0.2) * 0.5), 1.5707963267948966)),deltaTime) 
					RightHip.C0 = Lerp(RightHip.C0,cfMul(cf(1, -1, 0),angles(1.9198621771937625 + 0.12217304763960307 * sin((sine + 1.5) * 1), 1.2217304763960306 + 0.08726646259971647 * sin((sine + 0.2) * 0.5), -1.5707963267948966)),deltaTime) 
					--LeftArm,-1,0,0,1,-175,-10,1.5,1,0.5,0,0,1,-90,5,0.6,1,0,0,0,1,-90,0,0,1,RightArm,1,0,0,1,180,-5,0,1,0.5,0,0,1,20,5,0.3,1,0,0,0,1,-110,5,1,1,Head,0,0,0,1,-75,-15,1.2,1,1,0,0,1,-0,5,0.2,0.5,0,0,0,1,-170,0,0,1,Torso,0,0,0,1,-5,10,1.2,1,5,-0.5,-0.2,1,-0,5,0,0.5,0,0.2,-1.2,1,180,0,0,1,LeftLeg,-1,0,0,1,80,7,1.5,1,-1,0,0,1,-70,5,0.2,0.5,0,0,0,1,90,0,0,1,RightLeg,1,0,0,1,110,7,1.5,1,-1,0,0,1,70,5,0.2,0.5,0,0,0,1,-90,0,0,1
				end,
				walk = function()
					local Vfw, Vrt = velbycfrvec()
		
					local Cfw, Crt = velchgbycfrvec()
		
					LeftShoulder.C0 = Lerp(LeftShoulder.C0,cfMul(cf(-1, 0.5, 0),angles(-3.0543261909900767 - 0.17453292519943295 * sin((sine + 1.5) * 1) - Vfw * 0.1, -1.5707963267948966 + 0.08726646259971647 * sin((sine + 0.6) * 1) + Vrt * 0.2, -1.5707963267948966)),deltaTime) 
					RightShoulder.C0 = Lerp(RightShoulder.C0,cfMul(cf(1, 0.5, 0),angles(3.141592653589793 - 0.08726646259971647 * sin(sine * 1), 0.3490658503988659 + 0.08726646259971647 * sin((sine + 0.3) * 1), -1.9198621771937625 + 0.08726646259971647 * sin((sine + 1) * 1))),deltaTime) 
					Neck.C0 = Lerp(Neck.C0,cfMul(cf(0, 1, 0),angles(-1.3089969389957472 - 0.2617993877991494 * sin((sine + 1.2) * 1) + Vfw * 0.1, 0.08726646259971647 * sin((sine + 0.2) * 0.5) - Vrt * 0.2, -2.9670597283903604)),deltaTime) 
					RootJoint.C0 = Lerp(RootJoint.C0,cfMul(cf(Crt * 3, 5 - 0.5 * sin((sine - 0.2) * 1), 0.2 * sin((sine - 1.2) * 1) - Cfw * 3),angles(-0.08726646259971647 + 0.17453292519943295 * sin((sine + 1.2) * 1) - Vfw * 0.2 - Cfw, 0.08726646259971647 * sin(sine * 0.5) + Crt, 3.141592653589793 - Vrt * 0.2)),deltaTime) 
					LeftHip.C0 = Lerp(LeftHip.C0,cfMul(cf(-1, -1, 0),angles(1.3962634015954636 + 0.12217304763960307 * sin((sine + 1.5) * 1) - Vfw * 0.2, -1.2217304763960306 + 0.08726646259971647 * sin((sine + 0.2) * 0.5), 1.5707963267948966)),deltaTime) 
					RightHip.C0 = Lerp(RightHip.C0,cfMul(cf(1, -1, 0),angles(1.9198621771937625 + 0.12217304763960307 * sin((sine + 1.5) * 1) - Vfw * 0.2, 1.2217304763960306 + 0.08726646259971647 * sin((sine + 0.2) * 0.5), -1.5707963267948966)),deltaTime) 
					--LeftArm,-1,0,0,1,-175,-10,1.5,1,0.5,0,0,1,-90,5,0.6,1,0,0,0,1,-90,0,0,1,RightArm,1,0,0,1,180,-5,0,1,0.5,0,0,1,20,5,0.3,1,0,0,0,1,-110,5,1,1,Head,0,0,0,1,-75,-15,1.2,1,1,0,0,1,-0,5,0.2,0.5,0,0,0,1,-170,0,0,1,Torso,0,0,0,1,-5,10,1.2,1,5,-0.5,-0.2,1,-0,5,0,0.5,0,0.2,-1.2,1,180,0,0,1,LeftLeg,-1,0,0,1,80,7,1.5,1,-1,0,0,1,-70,5,0.2,0.5,0,0,0,1,90,0,0,1,RightLeg,1,0,0,1,110,7,1.5,1,-1,0,0,1,70,5,0.2,0.5,0,0,0,1,-90,0,0,1
				end
			})
			addmode("g", {
				idle = function()
					local Cfw, Crt = velchgbycfrvec()
		
					LeftShoulder.C0 = Lerp(LeftShoulder.C0,cfMul(cf(-0.9 + 0.4 * sin(sine * 8), 0.5, 0.5 * sin((sine + 0.25) * 4)),angles(1.5707963267948966, -1.5707963267948966 + 1.0471975511965976 * sin(sine * 8), 1.5707963267948966 + 0.6981317007977318 * sin((sine + 0.25) * 4))),deltaTime) 
					RootJoint.C0 = Lerp(RootJoint.C0,cfMul(cf(0.3 * sin((sine + 0.4) * 8) + Crt * 3, 0, Cfw * -3),angles(-1.5707963267948966 - Cfw, 0.3490658503988659 * sin(sine * 8) + Crt, -3.141592653589793)),deltaTime) 
					Neck.C0 = Lerp(Neck.C0,cfMul(cf(0, 1, 0),angles(-1.5707963267948966 + 0.061086523819801536 * sin((sine + 0.125) * 16), -0.3839724354387525 * sin(sine * 8), -3.141592653589793)),deltaTime) 
					RightHip.C0 = Lerp(RightHip.C0,cfMul(cf(1, -1 + 0.4 * sin((sine - 0.01) * 8), 0),angles(1.5707963267948966, 1.7453292519943295 + 0.6981317007977318 * sin(sine * 8), -1.5707963267948966)),deltaTime) 
					LeftHip.C0 = Lerp(LeftHip.C0,cfMul(cf(-1, -1 - 0.4 * sin((sine - 0.01) * 8), 0),angles(1.5707963267948966, -1.7453292519943295 + 0.6981317007977318 * sin(sine * 8), 1.5707963267948966)),deltaTime) 
					RightShoulder.C0 = Lerp(RightShoulder.C0,cfMul(cf(0.9 + 0.4 * sin(sine * 8), 0.5, -0.5 * sin((sine - 0.35) * 4)),angles(1.5707963267948966 + 0.6981317007977318 * sin(sine * 4), 1.5707963267948966 + 1.0471975511965976 * sin(sine * 8), -1.5707963267948966 + 0.17453292519943295 * sin((sine - 0.35) * 4))),deltaTime) 
					--LeftArm,-0.9,0.4,0,8,90,0,0.25,4,0.5,0,0,8,-90,60,0,8,0,0.5,0.25,4,90,40,0.25,4,Torso,0,0.3,0.4,8,-90,0,0,8,0,0,0,4,0,20,0,8,0,0,0,8,-180,0,0,8,Head,0,0,0,8,-90,3.5,0.125,16,1,0,0,8,0,-22,0,8,0,0,0,8,-180,0,0,1.1,RightLeg,1,0,0,8,90,0,0,8,-1,0.4,-0.01,8,100,40,0,8,0,0,0,8,-90,0,0,8,LeftLeg,-1,0,0,8,90,0,0,8,-1,-0.4,-0.01,8,-100,40,0,8,0,0,0,8,90,0,0,8,RightArm,0.9,0.4,0,8,90,40,0,4,0.5,0,0,8,90,60,0,8,0,-0.5,-0.35,4,-90,10,-0.35,4
				end
			})
			addmode("h", {
				idle = function()
					local Cfw, Crt = velchgbycfrvec()
		
					Neck.C0 = Lerp(Neck.C0,cfMul(cf(0, 1, 0),angles(-1.5707963267948966, -0.4363323129985824 * sin(sine * 8), -3.141592653589793)),deltaTime) 
					RightHip.C0 = Lerp(RightHip.C0,cfMul(cf(1, -1 + 0.3 * sin(sine * 8), 0),angles(1.5707963267948966, 1.5707963267948966 + 0.5235987755982988 * sin(sine * 8), -1.5707963267948966)),deltaTime) 
					LeftShoulder.C0 = Lerp(LeftShoulder.C0,cfMul(cf(-0.5, 1, 0),angles(-0.5235987755982988, -1.5707963267948966 - 0.5235987755982988 * sin(sine * 8), 3.141592653589793)),deltaTime) 
					RightShoulder.C0 = Lerp(RightShoulder.C0,cfMul(cf(0.5, 1, 0),angles(-0.5235987755982988, 1.5707963267948966 - 0.5235987755982988 * sin(sine * 8), 3.141592653589793)),deltaTime) 
					RootJoint.C0 = Lerp(RootJoint.C0,cfMul(cf(-0.1 * sin(sine * 8) + Crt * 3, 0.2 * sin((sine + 0.1) * 16), Cfw * -3),angles(-1.5707963267948966 - Cfw, 0.2617993877991494 * sin(sine * 8) + Crt, -3.141592653589793)),deltaTime) 
					LeftHip.C0 = Lerp(LeftHip.C0,cfMul(cf(-1, -1 - 0.3 * sin(sine * 8), 0),angles(1.5707963267948966, -1.5707963267948966 + 0.5235987755982988 * sin(sine * 8), 1.5707963267948966)),deltaTime) 
					--Head,0,0,0,8,-90,0,0,8,1,0,0,8,0,-25,0,8,0,0,0,8,-180,0,0,8,RightLeg,1,0,0,8,90,0,0,8,-1,0.3,0,8,90,30,0,8,0,0,0,8,-90,0,0,8,LeftArm,-0.5,0,0,8,-30,0,0,8,1,0,0,8,-90,-30,0,8,0,0,0,8,180,0,0,8,RightArm,0.5,0,0,8,-30,0,0,8,1,0,0,16,90,-30,0,8,0,0,0,8,180,0,0,8,Torso,0,-0.1,0,8,-90,0,0,8,0,0.2,0.1,16,0,15,0,8,0,0,0,8,-180,0,0,8,LeftLeg,-1,0,0,8,90,0,0,8,-1,-0.3,0,8,-90,30,0,8,0,0,0,8,90,0,0,8,Fedora_Handle,8.657480066176504e-09,0,0,8,-6,0,0,8,-0.15052366256713867,0,0,8,0,0,0,8,-0.010221302509307861,0,0,8,0,0,0,8
				end
			})
			addmode("j", {
				idle = function()
					local Cfw, Crt = velchgbycfrvec()
		
					LeftHip.C0 = Lerp(LeftHip.C0,cfMul(cf(-0.8, -1, -0.1),angles(0.17453292519943295, -0.6981317007977318, 0)),deltaTime) 
					LeftShoulder.C0 = Lerp(LeftShoulder.C0,cfMul(cf(-1.2, 0.5, 0),angles(-0.3490658503988659 + 0.08726646259971647 * sin((sine + 0.1) * 4), 0, 0.6981317007977318 + 0.08726646259971647 * sin((sine + 0.1) * 4))),deltaTime) 
					RightHip.C0 = Lerp(RightHip.C0,cfMul(cf(1.1, -1, 0),angles(1.5707963267948966, 1.7453292519943295, -1.5707963267948966)),deltaTime) 
					Neck.C0 = Lerp(Neck.C0,cfMul(cf(0, 1, 0),angles(-1.5707963267948966 + 0.08726646259971647 * sin((sine + 0.1) * 4), 0, 2.792526803190927)),deltaTime) 
					RootJoint.C0 = Lerp(RootJoint.C0,cfMul(cf(Crt * 3, -1.7 + 0.5 * sin(sine * 4), 0.15 * sin(sine * 4) - Cfw * 3),angles(3.3161255787892263 + 0.17453292519943295 * sin(sine * 4) - Cfw, Crt, 3.6651914291880923)),deltaTime) 
					RightShoulder.C0 = Lerp(RightShoulder.C0,cfMul(cf(0.8 + 0.4 * sin(sine * 4), 0.6 + 0.1 * sin(sine * 4), 0.4 - 0.25 * sin(sine * 4)),angles(2.9670597283903604, 2.2689280275926285 - 0.17453292519943295 * sin(sine * 4), -1.4835298641951802 - 0.17453292519943295 * sin(sine * 4))),deltaTime) 
					--GalaxyBeautifulHair_Handle,-0.15000000596046448,0,0,1,0,0,0,1,0.10000000149011612,0,0,1,0,0,0,1,0,0,0,1,0,0,0,1,LeftLeg,-0.8,0,0,4,10,0,0,4,-1,0,0,4,-40,0,0,4,-0.1,0,0,4,0,0,0,4,LeftArm,-1.2,0,0,4,-20,5,0.1,4,0.5,0,0,4,0,0,0,4,0,0,0,4,40,5,0.1,4,Fedora_Handle,8.657480066176504e-09,0,0,1,-6,0,0,1,-0.15052366256713867,0,0,1,0,0,0,1,-0.010221302509307861,0,0,1,0,0,0,1,ValkyrieHelm_Handle,8.658389560878277e-09,0,0,1,-15,0,0,1,-0.2433757781982422,0,0,1,0,0,0,1,-0.2657628059387207,0,0,1,0,0,0,1,RightLeg,1.1,0,0,4,90,0,0,4,-1,0,0,4,100,0,0,4,0,0,0,4,-90,0,0,4,BlackIronAntlers_Handle,8.658389560878277e-09,0,0,1,0,0,0,1,-0.6500000953674316,0,0,1,0,0,0,1,0.19972775876522064,0,0,1,0,0,0,1,DevAwardsAdurite_Handle,0,0,0,1,0,0,0,1,-0.25,0,0,1,0,0,0,1,0,0,0,1,0,0,0,1,SilverthornAntlers_Handle,8.658389560878277e-09,0,0,1,0,0,0,1,-0.6500000953674316,0,0,1,0,0,0,1,0.19972775876522064,0,0,1,0,0,0,1,Head,0,0,0,4,-90,5,0.1,4,1,0,0,4,-0,0,0,4,0,0,0,4,160,0,0,4,Torso,0,0,0,4,190,10,0,4,-1.70,0.5,0,4,-0,0,0,4,0,0.15,0,4,210,0,0,4,RightArm,0.8,0.4,0,4,170,0,0,4,0.6,0.1,0,4,130,-10,0,4,0.4,-0.25,0,4,-85,-10,0,4
				end
			})
			addmode("k", {
				idle = function()
					local Cfw, Crt = velchgbycfrvec()
		
					Neck.C0 = Lerp(Neck.C0,cfMul(cf(0, 1, 0),angles(-1.6580627893946132 - 0.08726646259971647 * sin((sine + 0.3333333333333333) * 12), -0.08726646259971647 * sin((sine + 0.2) * 6), 3.141592653589793)),deltaTime) 
					LeftHip.C0 = Lerp(LeftHip.C0,cfMul(cf(-1, -0.5 - 0.5 * sin((sine + 0.39999999999999997) * 12), -0.5),angles(1.7453292519943295 - 1.0471975511965976 * sin(sine * 6), -1.5707963267948966 + 0.1308996938995747 * sin(sine * 6), 1.5707963267948966)),deltaTime) 
					RightHip.C0 = Lerp(RightHip.C0,cfMul(cf(1, -0.5 - 0.5 * sin((sine + 0.39999999999999997) * 12), -0.5),angles(1.7453292519943295 + 1.0471975511965976 * sin(sine * 6), 1.5707963267948966 + 0.1308996938995747 * sin(sine * 6), -1.5707963267948966)),deltaTime) 
					RootJoint.C0 = Lerp(RootJoint.C0,cfMul(cf(Crt * 3, -0.5 + 0.3 * sin((sine + 0.16666666666666666) * 12), Cfw * -3),angles(-1.3962634015954636 + 0.08726646259971647 * sin((sine + 0.3333333333333333) * 12) - Cfw, 0.08726646259971647 * sin((sine + 0.06666666666666667) * 6) + Crt, 3.141592653589793)),deltaTime) 
					LeftShoulder.C0 = Lerp(LeftShoulder.C0,cfMul(cf(-0.8 - 0.1 * sin(sine * 6), 0.5 + 0.1 * sin(sine * 6), -0.2),angles(3.141592653589793 - 0.17453292519943295 * sin((sine + 0.39999999999999997) * 12), -0.17453292519943295, 1.5707963267948966)),deltaTime) 
					RightShoulder.C0 = Lerp(RightShoulder.C0,cfMul(cf(0.8 - 0.1 * sin(sine * 6), 0.5 - 0.1 * sin(sine * 6), -0.2),angles(3.141592653589793 - 0.17453292519943295 * sin((sine + 0.39999999999999997) * 12), 0.17453292519943295, -1.5707963267948966)),deltaTime) 
					--GalaxyBeautifulHair_Handle,-0.15000000596046448,0,0,1.5,0,0,0,1.5,0.10000000149011612,0,0,1.5,0,0,0,1.5,0,0,0,1.5,0,0,0,1.5,Head,0,0,0,6,-95,-5,0.3333333333333333,12,1,0,0,6,-0,-5,0.2,6,0,0,0,6,180,0,0,6,ValkyrieHelm_Handle,8.658389560878277e-09,0,0,1.5,-15,0,0,1.5,-0.2433757781982422,0,0,1.5,0,0,0,1.5,-0.2657628059387207,0,0,1.5,0,0,0,1.5,SilverthornAntlers_Handle,8.658389560878277e-09,0,0,1.5,0,0,0,1.5,-0.6500000953674316,0,0,1.5,0,0,0,1.5,0.19972775876522064,0,0,1.5,0,0,0,1.5,BlackIronAntlers_Handle,8.658389560878277e-09,0,0,1.5,0,0,0,1.5,-0.6500000953674316,0,0,1.5,0,0,0,1.5,0.19972775876522064,0,0,1.5,0,0,0,1.5,Fedora_Handle,8.657480066176504e-09,0,0,1.5,-6,0,0,1.5,-0.15052366256713867,0,0,1.5,0,0,0,1.5,-0.010221302509307861,0,0,1.5,0,0,0,1.5,LeftLeg,-1,0,0,6,100,-60,0,6,-0.5,-0.5,0.39999999999999997,12,-90,7.5,0,6,-0.5,0,0,6,90,0,0,6,EyelessSmileHead_Handle,-0.00043487548828125,0,0,1.5,180,0,0,1.5,0.6000361442565918,0,0,1.5,0,0,0,1.5,0.0003204345703125,0,0,1.5,180,0,0,1.5,RightLeg,1,0,0,6,100,60,0,6,-0.5,-0.5,0.39999999999999997,12,90,7.5,0,6,-0.5,0,0,6,-90,0,0,6,DevAwardsAdurite_Handle,0,0,0,1.5,0,0,0,1.5,-0.25,0,0,1.5,0,0,0,1.5,0,0,0,1.5,0,0,0,1.5,Torso,0,0,0,6,-80,5,0.3333333333333333,12,-0.5,0.3,0.16666666666666666,12,-0,5,0.06666666666666667,6,0,0,0,6,180,0,0,6,LeftArm,-0.8,-0.1,0,6,180,-10,0.39999999999999997,12,0.5,0.1,0,6,-10,0,0,6,-0.2,0,0,6,90,0,0,6,RightArm,0.8,-0.1,0,6,180,-10,0.39999999999999997,12,0.5,-0.1,0,6,10,0,0,6,-0.2,0,0,6,-90,0,0,6
				end
			})
			addmode("l", {
				idle = function()
					local Cfw, Crt = velchgbycfrvec()
		
					Neck.C0 = Lerp(Neck.C0,cfMul(cf(0, 1, 0),angles(-1.5707963267948966 + 0.04363323129985824 * sin((sine + 0.1) * 1), -0.17453292519943295 * sin((sine + 0.1) * 5), -3.141592653589793)),deltaTime) 
					RightHip.C0 = Lerp(RightHip.C0,cfMul(cf(1, -1 + 0.2 * sin(sine * 5), -0.2 + 0.2 * sin(sine * 5)),angles(2.181661564992912 - 0.8726646259971648 * sin(sine * 5), 1.9198621771937625 - 0.3490658503988659 * sin(sine * 5), -1.5707963267948966)),deltaTime) 
					RightShoulder.C0 = Lerp(RightShoulder.C0,cfMul(cf(0.7, 0.8, 0),angles(1.0471975511965976 + 0.03490658503988659 * sin(sine * 10), 2.0943951023931953 + 0.10471975511965978 * sin((sine + 0.1) * 5), 1.5707963267948966)),deltaTime) 
					LeftHip.C0 = Lerp(LeftHip.C0,cfMul(cf(-1, -1 - 0.2 * sin(sine * 5), -0.2 - 0.2 * sin(sine * 5)),angles(2.181661564992912 + 0.8726646259971648 * sin(sine * 5), -1.9198621771937625 - 0.3490658503988659 * sin(sine * 5), 1.5707963267948966)),deltaTime) 
					RootJoint.C0 = Lerp(RootJoint.C0,cfMul(cf(Crt * 3, 0.15 + 0.4 * sin((sine - 0.5) * 10), Cfw * -3),angles(-1.4835298641951802 - Cfw, 0.17453292519943295 * sin(sine * 5) + Crt, -3.141592653589793)),deltaTime) 
					LeftShoulder.C0 = Lerp(LeftShoulder.C0,cfMul(cf(-0.7, 0.5, -0.3),angles(1.7453292519943295, -0.8726646259971648, 1.5707963267948966)),deltaTime) 
					--Head,0,0,0,5,-90,2.5,0.1,1,1,0,0,4,0,-10,0.1,5,0,0,0,4,-180,0,0,4,RightLeg,1,0,0,4,125,-50,0,5,-1,0.2,0,5,110,-20,0,5,-0.2,0.2,0,5,-90,0,0,4,RightArm,0.7,0,0,4,60,2,0,10,0.8,0,0,4,120,6,0.1,5,0,0,0,4,90,0,0,4,LeftLeg,-1,0,0,4,125,50,0,5,-1,-0.2,0,5,-110,-20,0,5,-0.2,-0.2,0,5,90,0,0,4,Torso,0,0,0,4,-85,0,0,4,0.15,0.4,-0.5,10,0,10,0,5,0,0,0,4,-180,0,0,4,LeftArm,-0.7,0,0,4,100,0,0,4,0.5,0,0,4,-50,0,0,4,-0.3,0,0,4,90,0,0,4
				end
			})
		
			addmode("x", {
				idle = function()
					local Cfw, Crt = velchgbycfrvec()
		
					RightShoulder.C0 = Lerp(RightShoulder.C0,cfMul(cf(1, 0.5, 0),angles(0, 1.5707963267948966, 0)),deltaTime) 
					Neck.C0 = Lerp(Neck.C0,cfMul(cf(0, 1, 0),angles(-1.5707963267948966, 0, 3.141592653589793)),deltaTime) 
					RightHip.C0 = Lerp(RightHip.C0,cfMul(cf(1, -1, 0),angles(0, 1.5707963267948966, 0)),deltaTime) 
					LeftHip.C0 = Lerp(LeftHip.C0,cfMul(cf(-1, -1, 0),angles(0, -1.5707963267948966, 0)),deltaTime) 
					RootJoint.C0 = Lerp(RootJoint.C0,cfMul(cf(Crt * 3, 0, Cfw * -3),angles(-1.5707963267948966 - Cfw, Crt, 3.141592653589793)),deltaTime) 
					LeftShoulder.C0 = Lerp(LeftShoulder.C0,cfMul(cf(-1, 0.5, 0),angles(0, -1.5707963267948966, 0)),deltaTime) 
					--RightArm,1,0,0,1,0,0,0,1,0.5,0,0,1,90,0,0,1,0,0,0,1,0,0,0,1,Fedora_Handle,8.657480066176504e-09,0,0,1,-6,0,0,1,-0.15052366256713867,0,0,1,0,0,0,1,-0.010221302509307861,0,0,1,0,0,0,1,Head,0,0,0,1,-90,0,0,1,1,0,0,1,-0,0,0,1,0,0,0,1,180,0,0,1,RightLeg,1,0,0,1,0,0,0,1,-1,0,0,1,90,0,0,1,0,0,0,1,0,0,0,1,LeftLeg,-1,0,0,1,-0,0,0,1,-1,0,0,1,-90,0,0,1,0,0,0,1,0,0,0,1,Torso,0,0,0,1,-90,0,0,1,0,0,0,1,-0,0,0,1,0,0,0,1,180,0,0,1,LeftArm,-1,0,0,1,-0,0,0,1,0.5,0,0,1,-90,0,0,1,0,0,0,1,0,0,0,1
				end,
				walk = function()
					local Cfw, Crt = velchgbycfrvec()
		
					RightShoulder.C0 = Lerp(RightShoulder.C0,cfMul(cf(1, 0.5, 0),angles(0, 1.5707963267948966, 0)),deltaTime) 
					Neck.C0 = Lerp(Neck.C0,cfMul(cf(0, 1, 0),angles(-1.5707963267948966, 0, 3.141592653589793)),deltaTime) 
					RightHip.C0 = Lerp(RightHip.C0,cfMul(cf(1, -1, 0),angles(0, 1.5707963267948966, 0)),deltaTime) 
					LeftHip.C0 = Lerp(LeftHip.C0,cfMul(cf(-1, -1, 0),angles(0, -1.5707963267948966, 0)),deltaTime) 
					RootJoint.C0 = Lerp(RootJoint.C0,cfMul(cf(Crt * 3, 0, Cfw * -3),angles(-1.5707963267948966 - Cfw, Crt, 3.141592653589793)),deltaTime) 
					LeftShoulder.C0 = Lerp(LeftShoulder.C0,cfMul(cf(-1, 0.5, 0),angles(0, -1.5707963267948966, 0)),deltaTime) 
					--RightArm,1,0,0,1,0,0,0,1,0.5,0,0,1,90,0,0,1,0,0,0,1,0,0,0,1,Fedora_Handle,8.657480066176504e-09,0,0,1,-6,0,0,1,-0.15052366256713867,0,0,1,0,0,0,1,-0.010221302509307861,0,0,1,0,0,0,1,Head,0,0,0,1,-90,0,0,1,1,0,0,1,-0,0,0,1,0,0,0,1,180,0,0,1,RightLeg,1,0,0,1,0,0,0,1,-1,0,0,1,90,0,0,1,0,0,0,1,0,0,0,1,LeftLeg,-1,0,0,1,-0,0,0,1,-1,0,0,1,-90,0,0,1,0,0,0,1,0,0,0,1,Torso,0,0,0,1,-90,0,0,1,0,0,0,1,-0,0,0,1,0,0,0,1,180,0,0,1,LeftArm,-1,0,0,1,-0,0,0,1,0.5,0,0,1,-90,0,0,1,0,0,0,1,0,0,0,1
				end
			})
		end,
		function(t)
			local raycastlegs=t.raycastlegs
			local velbycfrvec=t.velbycfrvec
			local addmode=t.addmode
			local getJoint=t.getJoint
			local RootJoint=getJoint("RootJoint")
			local RightShoulder=getJoint("Right Shoulder")
			local LeftShoulder=getJoint("Left Shoulder")
			local RightHip=getJoint("Right Hip")
			local LeftHip=getJoint("Left Hip")
			local Neck=getJoint("Neck")
			addmode("default", {
				idle = function()
					local rY, lY = raycastlegs()
		
					RightShoulder.C0 = Lerp(RightShoulder.C0,cfMul(cf(1, 0.3 + 0.1 * sin(sine * 2), -0.1),angles(-0.5235987755982988 + 0.05235987755982989 * sin((sine + 1.5) * 2), 1.0471975511965976 + 0.08726646259971647 * sin((sine + 0.5) * 2), 0.5235987755982988)),deltaTime) 
					Neck.C0 = Lerp(Neck.C0,cfMul(cf(0, 1, 0),angles(-1.6580627893946132 + 0.08726646259971647 * sin((sine + 0.6) * 2), 0, 3.141592653589793 + 0.2617993877991494 * sin((sine - 1.2) * 1))),deltaTime) 
					RootJoint.C0 = Lerp(RootJoint.C0,cfMul(cf(0, 0.1 * sin(sine * 2), 0),angles(-1.5707963267948966 + 0.08726646259971647 * sin(sine * 2), 0, 3.141592653589793)),deltaTime) 
					RightHip.C0 = Lerp(RightHip.C0,cfMul(cf(1, -1 - 0.1 * sin(sine * 2) + rY, 0.1 * sin(sine * 2) - rY * 0.5),angles(-0.6981317007977318 - 0.08726646259971647 * sin(sine * 2), 1.0471975511965976, 0.5235987755982988)),deltaTime) 
					LeftShoulder.C0 = Lerp(LeftShoulder.C0,cfMul(cf(-1, 0.6 + 0.1 * sin(sine * 2), 0),angles(3.141592653589793 + 0.05235987755982989 * sin((sine + 0.5) * 2), -2.705260340591211 + 0.017453292519943295 * sin((sine + 1.5) * 2), -1.2217304763960306 + 0.05235987755982989 * sin((sine + 1.5) * 2))),deltaTime) 
					LeftHip.C0 = Lerp(LeftHip.C0,cfMul(cf(-1, -1 - 0.1 * sin(sine * 2) + lY, 0.1 * sin(sine * 2) - lY * 0.5),angles(-0.3490658503988659 - 0.08726646259971647 * sin(sine * 2), -1.0471975511965976, -0.5235987755982988)),deltaTime) 
					--RightArm,1,0,0,2,-30,3,1.5,2,0.3,0.1,0,2,60,5,0.5,2,-0.1,0,0,2,30,0,0,2,Head,0,0,0,2,-95,5,0.6,2,1,0,0,2,-0,0,0,1,0,0,0,2,180,15,-1.2,1,Torso,0,0,0,2,-90,5,0,2,0,0.1,0,2,-0,0,0,2,0,0,0,2,180,0,0,2,RightLeg,1,0,0,2,-40,-5,0,2,-1,-0.1,0,2,60,0,0,2,0,0.1,0,2,30,0,0,2,Meshes/TrollFaceHeadAccessory_Handle,0.01043701171875,0,0,1,0,0,0,1,0.43610429763793945,0,0,1,0,0,0,1,-0.01102447509765625,0,0,1,0,0,0,1,LeftArm,-1,0,0,2,180,3,0.5,2,0.6,0.1,0,2,-155,1,1.5,2,0,0,0,2,-70,3,1.5,2,LeftLeg,-1,0,0,2,-20,-5,0,2,-1,-0.1,0,2,-60,0,0,2,0,0.1,0,2,-30,0,0,2
				end,
				walk = function()
					local fw, rt = velbycfrvec()
		
					local rY, lY = raycastlegs()
		
					RootJoint.C0 = Lerp(RootJoint.C0,cfMul(cf(0, -0.2 + 0.2 * sin(sine * 16), 0),angles(-1.6580627893946132 + 0.04363323129985824 * sin(sine * 16) - fw * 0.15, 0.03490658503988659 * sin(sine * 8) + rt * 0.15, -3.141592653589793 - 0.08726646259971647 * sin((sine + 0.25) * 8) - rt * 0.1)),deltaTime) 
					RightHip.C0 = Lerp(RightHip.C0,cfMul(cf(1, -0.8 + 0.4 * sin((sine + 0.125) * 8) + rY, -0.15 * fw + 0.4 * sin((sine + 10) * 8) * fw + rY * -0.5),angles(1.3962634015954636 + 0.6981317007977318 * sin(sine * 8)*fw, 1.5707963267948966 + 0.6981317007977318 * sin(sine * 8)*rt, -1.5707963267948966 + 0.2617993877991494 * sin(sine * 8))),deltaTime) 
					LeftShoulder.C0 = Lerp(LeftShoulder.C0,cfMul(cf(-1, 0.35 - 0.1 * sin(sine * 8), 0),angles(0.5235987755982988 * sin(sine * 8)*fw, -1.5707963267948966 - 0.5235987755982988 * sin(sine * 8)*fw, -0.5235987755982988 * sin(sine * 8)*fw)),deltaTime) 
					RightShoulder.C0 = Lerp(RightShoulder.C0,cfMul(cf(1, 0.35 + 0.1 * sin(sine * 8), 0),angles(-0.5235987755982988 * sin(sine * 8)*fw, 1.5707963267948966 - 0.5235987755982988 * sin(sine * 8)*fw, -0.5235987755982988 * sin(sine * 8)*fw)),deltaTime) 
					LeftHip.C0 = Lerp(LeftHip.C0,cfMul(cf(-1, -0.8 - 0.4 * sin((sine + 0.125) * 8) + lY, -0.15 * fw - 0.4 * sin((sine + 10) * 8) * fw + lY * -0.5),angles(1.3962634015954636 - 0.6981317007977318 * sin(sine * 8)*fw, -1.5707963267948966 - 0.6981317007977318 * sin(sine * 8)*rt, 1.5707963267948966 + 0.2617993877991494 * sin(sine * 8))),deltaTime) 
					Neck.C0 = Lerp(Neck.C0,cfMul(cf(0, 1, 0),angles(-1.5707963267948966 + 0.08726646259971647 * sin((sine + 10) * 16) + fw * 0.15, -0.08726646259971647 * sin(sine * 8) + rt * -0.1, 3.141592653589793 - 0.05235987755982989 * sin((sine + 5) * 8) - rt * 0.5)),deltaTime) 
					--Torso,0,0,0,8,-95,2.5,0,16,-0.2,0.2,0,16,0,5,0,8,0,0,0,8,-180,-5,0.25,8,RightArm,1,0,0,1,0,-30,0,8,0.35,0.1,0,8,90,-30,0,8,0,0,0,8,0,-30,0,8,RightLeg,1,0,0,8,80,40,0,8,-0.8,0.4,0.125,8,90,40,0,8,-0.15,0.4,10,8,-90,15,0,8,LeftLeg,-1,0,0,8,80,-40,0,8,-0.8,-0.4,0.125,8,-90,-40,0,8,-0.15,-0.4,10,8,90,15,0,8,Head,0,0,0,1,-90,2.5,10,16,1,0,0,1,-0,-5,0,8,0,0,0,1,180,-3,5,8,LeftArm,-1,0,0,1,0,30,0,8,0.35,-0.1,0,8,-90,-30,0,8,0,-0.4,0,8,0,-30,0,8
				end,
				jump = function()
					local fw, rt = velbycfrvec()
		
					RootJoint.C0 = Lerp(RootJoint.C0,cfMul(cf_0,angles(-1.4835298641951802 + fw * 0.1, rt * -0.05, -3.141592653589793)),deltaTime) 
					RightShoulder.C0 = Lerp(RightShoulder.C0,cfMul(cf(1, 0.5, 0),angles(4.014257279586958 - 0.08726646259971647 * sin((sine + 0.5) * 4), 1.7453292519943295 + 0.08726646259971647 * sin((sine + 0.25) * 4), -1.5707963267948966)),deltaTime) 
					LeftHip.C0 = Lerp(LeftHip.C0,cfMul(cf(-1, -1, 0),angles(1.5707963267948966 - 0.08726646259971647 * sin((sine + 0.5) * 4), -1.6580627893946132 + 0.06981317007977318 * sin((sine + 0.25) * 4), 1.5707963267948966)),deltaTime) 
					LeftShoulder.C0 = Lerp(LeftShoulder.C0,cfMul(cf(-1, 0.5, 0),angles(4.014257279586958 - 0.08726646259971647 * sin((sine + 0.5) * 4), -1.7453292519943295 - 0.08726646259971647 * sin((sine + 0.25) * 4), 1.5707963267948966)),deltaTime) 
					Neck.C0 = Lerp(Neck.C0,cfMul(cf(0, 1, 0),angles(-1.3962634015954636, 0, -3.141592653589793 - rt)),deltaTime) 
					RightHip.C0 = Lerp(RightHip.C0,cfMul(cf(1, -1, 0),angles(1.5707963267948966 - 0.08726646259971647 * sin((sine + 0.5) * 4), 1.6580627893946132 - 0.06981317007977318 * sin((sine + 0.25) * 4), -1.5707963267948966)),deltaTime) 
					--Torso,0,0,0,4,-85,0,0,4,0,0,0,4,0,0,0,4,0,0,0,4,-180,0,0,4,RightArm,1,0,0,4,230,-5,0.5,4,0.5,0,0,4,100,5,0.25,4,0,0,0,4,-90,0,0,4,LeftLeg,-1,0,0,4,90,-5,0.5,4,-1,0,0,4,-95,4,0.25,4,0,0,0,4,90,0,0,4,LeftArm,-1,0,0,4,230,-5,0.5,4,0.5,0,0,4,-100,-5,0.25,4,0,0,0,4,90,0,0,4,Head,0,0,0,4,-80,0,0.5,4,1,0,0,4,0,0,0.25,4,0,0,0,4,-180,0,0,4,RightLeg,1,0,0,4,90,-5,0.5,4,-1,0,0,4,95,-4,0.25,4,0,0,0,4,-90,0,0,4
				end,
				fall = function()
					local fw, rt = velbycfrvec()
		
					RootJoint.C0 = Lerp(RootJoint.C0,cfMul(cf_0,angles(-1.6580627893946132 + fw * 0.1, rt * -0.05, -3.141592653589793)),deltaTime) 
					RightShoulder.C0 = Lerp(RightShoulder.C0,cfMul(cf(1, 0.5, 0),angles(4.014257279586958 - 0.08726646259971647 * sin((sine + 0.5) * 4), 1.7453292519943295 + 0.08726646259971647 * sin((sine + 0.25) * 4), -1.5707963267948966)),deltaTime) 
					LeftHip.C0 = Lerp(LeftHip.C0,cfMul(cf(-1, -1, 0),angles(1.5707963267948966 - 0.08726646259971647 * sin((sine + 0.5) * 4), -1.6580627893946132 + 0.06981317007977318 * sin((sine + 0.25) * 4), 1.5707963267948966)),deltaTime) 
					LeftShoulder.C0 = Lerp(LeftShoulder.C0,cfMul(cf(-1, 0.5, 0),angles(4.014257279586958 - 0.08726646259971647 * sin((sine + 0.5) * 4), -1.7453292519943295 - 0.08726646259971647 * sin((sine + 0.25) * 4), 1.5707963267948966)),deltaTime) 
					Neck.C0 = Lerp(Neck.C0,cfMul(cf(0, 1, 0),angles(-1.7453292519943295, 0, -3.141592653589793 - rt)),deltaTime) 
					RightHip.C0 = Lerp(RightHip.C0,cfMul(cf(1, -1, 0),angles(1.5707963267948966 - 0.08726646259971647 * sin((sine + 0.5) * 4), 1.6580627893946132 - 0.06981317007977318 * sin((sine + 0.25) * 4), -1.5707963267948966)),deltaTime) 
					--Torso,0,0,0,4,-95,0,0,4,0,0,0,4,0,0,0,4,0,0,0,4,-180,0,0,4,RightArm,1,0,0,4,230,-5,0.5,4,0.5,0,0,4,100,5,0.25,4,0,0,0,4,-90,0,0,4,LeftLeg,-1,0,0,4,90,-5,0.5,4,-1,0,0,4,-95,4,0.25,4,0,0,0,4,90,0,0,4,LeftArm,-1,0,0,4,230,-5,0.5,4,0.5,0,0,4,-100,-5,0.25,4,0,0,0,4,90,0,0,4,Head,0,0,0,4,-100,0,0.5,4,1,0,0,4,0,0,0.25,4,0,0,0,4,-180,0,0,4,RightLeg,1,0,0,4,90,-5,0.5,4,-1,0,0,4,95,-4,0.25,4,0,0,0,4,-90,0,0,4
				end
			})
		
			addmode("q", {
				idle = function()
					LeftShoulder.C0 = Lerp(LeftShoulder.C0,cfMul(cf(-1, 0.75, -0.2),angles(2.705260340591211 - 0.08726646259971647 * sin((sine + 0.1) * 2), -2.792526803190927, -0.6981317007977318)),deltaTime) 
					RightShoulder.C0 = Lerp(RightShoulder.C0,cfMul(cf(1, 0.75, -0.2),angles(2.705260340591211 - 0.08726646259971647 * sin((sine + 0.1) * 2), 2.792526803190927, 0.6981317007977318)),deltaTime) 
					Neck.C0 = Lerp(Neck.C0,cfMul(cf(0, 1, 0),angles(-1.9198621771937625 - 0.10471975511965978 * sin((sine + 0.3) * 2), 0, 3.141592653589793)),deltaTime) 
					RootJoint.C0 = Lerp(RootJoint.C0,cfMul(cf(0, -2.45 - 0.05 * sin(sine * 2), 0),angles(0.03490658503988659 * sin(sine * 2), 0, 3.141592653589793)),deltaTime) 
					RightHip.C0 = Lerp(RightHip.C0,cfMul(cf(1, -1, 0),angles(1.3962634015954636 - 0.03490658503988659 * sin(sine * 2), 1.3089969389957472, -0.9599310885968813)),deltaTime) 
					LeftHip.C0 = Lerp(LeftHip.C0,cfMul(cf(-1, -1, 0),angles(1.5707963267948966 - 0.03490658503988659 * sin(sine * 2), -1.3089969389957472, 1.5707963267948966)),deltaTime) 
					--LeftArm,-1,0,0,2,155,-5,0.1,2,0.75,0,0,2,-160,0,0,2,-0.2,0,0,2,-40,0,0,2,RightArm,1,0,0,2,155,-5,0.1,2,0.75,0,0,2,160,0,0,2,-0.2,0,0,2,40,0,0,2,Head,0,0,0,2,-110,-6,0.3,2,1,0,0,2,-0,0,0,2,0,0,0,2,180,0,0,2,Torso,0,0,0,2,0,2,0,2,-2.45,-0.05,0,2,-0,0,0,2,0,0,0,2,180,0,0,2,RightLeg,1,0,0,2,80,-2,0,2,-1,0,0,2,75,0,0,2,0,0,0,2,-55,0,0,2,LeftLeg,-1,0,0,2,90,-2,0,2,-1,0,0,2,-75,0,0,2,0,0,0,2,90,0,0,2
				end
			})
			addmode("e", {
				idle = function()
					LeftShoulder.C0 = Lerp(LeftShoulder.C0,cfMul(cf(-0.9, 0.4 + 0.1 * sin(sine * 2), 0.3 - 0.15 * sin(sine * 2)),angles(-1.0471975511965976 - 0.12217304763960307 * sin(sine * 2), -1.3962634015954636, -0.6981317007977318)),deltaTime) 
					RootJoint.C0 = Lerp(RootJoint.C0,cfMul(cf(0, -1.85 - 0.1 * sin((sine + 0.2) * 2), 0),angles(-1.3962634015954636 + 0.03490658503988659 * sin(sine * 2), -0.08726646259971647, 3.141592653589793)),deltaTime) 
					RightShoulder.C0 = Lerp(RightShoulder.C0,cfMul(cf(1, 0.4 + 0.1 * sin(sine * 2), 0.2 - 0.15 * sin(sine * 2)),angles(0.6108652381980153 - 0.12217304763960307 * sin(sine * 2), 1.2217304763960306, -0.7853981633974483)),deltaTime) 
					Neck.C0 = Lerp(Neck.C0,cfMul(cf(0, 1, 0),angles(-1.6580627893946132 - 0.03490658503988659 * sin((sine + 0.6) * 2), 0.10471975511965978 + 0.06981317007977318 * sin(sine * 0.66), 3.141592653589793 + 0.3490658503988659 * sin(sine * 0.66))),deltaTime) 
					RightHip.C0 = Lerp(RightHip.C0,cfMul(cf(1, 0.2 + 0.15 * sin((sine + 0.2) * 2), -0.7 + 0.1 * sin(sine * 2)),angles(1.4835298641951802 + 0.03490658503988659 * sin(sine * 2), 1.4835298641951802, -1.5707963267948966)),deltaTime) 
					LeftHip.C0 = Lerp(LeftHip.C0,cfMul(cf(-1, -0.75 + 0.1 * sin((sine + 0.2) * 2), -0.5),angles(1.3962634015954636 - 0.03490658503988659 * sin(sine * 2), -1.6580627893946132, 0)),deltaTime) 
					--LeftArm,-0.9,0,0,2,-60,-7,0,2,0.4,0.1,0,2,-80,0,0,2,0.3,-0.15,0,2,-40,0,0,2,Torso,0,0,0,2,-80,2,0,2,-1.85,-0.1,0.2,2,-5,0,0,2,0,0,0,2,180,0,0,2,RightArm,1,0,0,2,35,-7,0,2,0.4,0.1,0,2,70,0,0,2,0.2,-0.15,0,2,-45,0,0,2,Head,0,0,0,2,-95,-2,0.6,2,1,0,0,2,6,4,0,0.66,0,0,0,2,180,20,0,0.66,RightLeg,1,0,0,2,85,2,0,2,0.2,0.15,0.2,2,85,0,0,2,-0.7,0.1,0,2,-90,0,0,2,LeftLeg,-1,0,0,2,80,-2,0,2,-0.75,0.1,0.2,2,-95,0,0,2,-0.5,0,0,2,0,0,0,2
				end
			})
			addmode("r", {
				idle = function()
					RightHip.C0 = Lerp(RightHip.C0,cfMul(cf(1, -0.9 - 0.2 * sin(sine * 2), 0),angles(1.5707963267948966, 1.6580627893946132 - 0.17453292519943295 * sin(sine + 0.8), -1.5707963267948966)),deltaTime) 
					RootJoint.C0 = Lerp(RootJoint.C0,cfMul(cf(0.3 * sin(sine + 0.8), -0.1 + 0.2 * sin(sine * 2), 0),angles(-1.5707963267948966, 0, -3.141592653589793)),deltaTime) 
					Neck.C0 = Lerp(Neck.C0,cfMul(cf(0, 1, 0),angles(-1.5707963267948966 + 0.08726646259971647 * sin((sine - 0.5) * 2), 0.08726646259971647 * sin(sine - 1), -3.141592653589793 + 0.2617993877991494 * sin(sine * 5))),deltaTime) 
					LeftShoulder.C0 = Lerp(LeftShoulder.C0,cfMul(cf(-1 + 0.1 * sin(sine * 7), 0.2 - 0.1 * sin(sine + 0.8), -0.25),angles(1.5707963267948966 + 0.5235987755982988 * sin(sine * 7), -0.6981317007977318, 0.3490658503988659 * sin(sine * 7))),deltaTime) 
					LeftHip.C0 = Lerp(LeftHip.C0,cfMul(cf(-1, -0.9 - 0.2 * sin(sine * 2), 0),angles(1.5707963267948966, -1.6580627893946132 - 0.17453292519943295 * sin(sine + 0.8), 1.5707963267948966)),deltaTime) 
					RightShoulder.C0 = Lerp(RightShoulder.C0,cfMul(cf(1 + 0.1 * sin(sine * 7), 0.2 + 0.1 * sin(sine + 0.8), -0.25),angles(1.5707963267948966 - 0.5235987755982988 * sin(sine * 7), 0.6981317007977318, 0.3490658503988659 * sin(sine * 7))),deltaTime) 
					--RightLeg,1,0,0,1,90,0,0,1,-0.9,-0.2,0,2,95,-10,0.8,1,0,0,0,1,-90,0,0,1,Torso,0,0.3,0.8,1,-90,0,0,1,-0.1,0.2,0,2,0,0,0,1,0,0,0,1,-180,0,0,1,Head,0,0,0,1,-90,5,-0.5,2,1,0,0,1,0,5,-1,1,0,0,0,1,-180,15,0,5,Fedora_Handle,8.657480066176504e-09,0,0,1,-6,0,0,1,-0.15052366256713867,0,0,1,0,0,0,1,-0.010221302509307861,0,0,1,0,0,0,1,LeftArm,-1,0.1,0,7,90,30,0,7,0.2,-0.1,0.8,1,-40,0,0,1,-0.25,0,0,1,0,20,0,7,LeftLeg,-1,0,0,1,90,0,0,1,-0.9,-0.2,0,2,-95,-10,0.8,1,0,0,0,1,90,0,0,1,RightArm,1,0.1,0,7,90,-30,0,7,0.2,0.1,0.8,1,40,0,0,1,-0.25,0,0,1,-0,20,0,7
				end
			})
			addmode("t", {
				idle = function()
					LeftShoulder.C0 = Lerp(LeftShoulder.C0,cfMul(cf(-1, 0.5, 0),angles(1.5707963267948966, -1.6580627893946132 + 0.08726646259971647 * sin((sine - 0.3) * 4), 1.5707963267948966)),deltaTime) 
					RightShoulder.C0 = Lerp(RightShoulder.C0,cfMul(cf(1 + 0.15 * sin((sine - 0.4) * 4), 1.42, 0),angles(1.5707963267948966, 1.4835298641951802 - 0.3490658503988659 * sin((sine - 0.4) * 4), 1.5707963267948966)),deltaTime) 
					Neck.C0 = Lerp(Neck.C0,cfMul(cf(0, 1, 0),angles(-1.4835298641951802, 0.04363323129985824 - 0.08726646259971647 * sin((sine + 0.1) * 4), -3.141592653589793 + 0.04363323129985824 * sin(sine * 4))),deltaTime) 
					RootJoint.C0 = Lerp(RootJoint.C0,cfMul(cf(0.1 * sin(sine * 4), 0, 0),angles(-1.5707963267948966, -0.08726646259971647 + 0.08726646259971647 * sin(sine * 4), -3.141592653589793)),deltaTime) 
					RightHip.C0 = Lerp(RightHip.C0,cfMul(cf(1, -1.1 + 0.1 * sin(sine * 4), 0),angles(1.5707963267948966, 1.5707963267948966 + 0.08726646259971647 * sin(sine * 4), -1.5707963267948966)),deltaTime) 
					LeftHip.C0 = Lerp(LeftHip.C0,cfMul(cf(-1 - 0.02 * sin(sine * 4), -0.925 - 0.07 * sin(sine * 4), 0),angles(1.5707963267948966, -1.7453292519943295 + 0.08726646259971647 * sin(sine * 4), 1.5707963267948966)),deltaTime) 
					--LeftArm,-1,0,0,4,90,0,0,4,0.5,0,0,4,-95,5,-0.3,4,0,0,0,4,90,0,0,4,RightArm,1,0.15,-0.4,4,90,0,0,4,1.42,0,0,4,85,-20,-0.4,4,0,0,0,4,90,0,0,4,Head,0,0,0,4,-85,0,0,4,1,0,0,4,2.5,-5,0.1,4,0,0,0,4,-180,2.5,0,4,Torso,0,0.1,0,4,-90,0,0,4,0,0,0,4,-5,5,0,4,0,0,0,4,-180,0,0,4,RightLeg,1,0,0,4,90,0,0,4,-1.1,0.1,0,4,90,5,0,4,0,0,0,4,-90,0,0,4,LeftLeg,-1,-0.02,0,4,90,0,0,4,-0.925,-0.07,0,4,-100,5,0,4,0,0,0,4,90,0,0,4
				end
			})
			addmode("y", {
				idle = function()
					LeftShoulder.C0 = Lerp(LeftShoulder.C0,cfMul(cf(-1.5, 0.5, 0),angles(-1.7453292519943295, 0.17453292519943295 - 0.04363323129985824 * sin(sine * 2), -1.4835298641951802)),deltaTime) 
					RightHip.C0 = Lerp(RightHip.C0,cfMul(cf(1, -0.9000000953674316 - 0.1 * sin(sine * 2), 0),angles(-1.3962634015954636, 1.3962634015954636, 1.5707963267948966)),deltaTime) 
					LeftHip.C0 = Lerp(LeftHip.C0,cfMul(cf(-1, -1.0000001192092896 - 0.1 * sin(sine * 2), 0),angles(-1.5707963267948966, -1.3962634015954636, -1.5707963267948966)),deltaTime) 
					Neck.C0 = Lerp(Neck.C0,cfMul(cf(0, 1, 0),angles(-2.0943951023931953 + 0.08726646259971647 * sin((sine - 1) * 2), -0.08726646259971647, 2.792526803190927)),deltaTime) 
					RightShoulder.C0 = Lerp(RightShoulder.C0,cfMul(cf(1, 1.2000000476837158, 0),angles(2.6179938779914944 + 0.08726646259971647 * sin((sine - 1) * 2), 0.6981317007977318, -1.3962634015954636)),deltaTime) 
					RootJoint.C0 = Lerp(RootJoint.C0,cfMul(cf(0, 0.1 * sin(sine * 2), 0),angles(-1.6580627893946132, 0.08726646259971647, 3.0543261909900767)),deltaTime) 
					--LeftArm,-1.5,0,0,2,-100,0,0,2,0.5,0,0,2,10,-2.5,0,2,0,0,0,2,-85,0,0,2,RightLeg,1,0,0,2,-80,0,0,2,-0.9000000953674316,-0.1,0,2,80,0,0,2,0,0,0,2,90,0,0,2,LeftLeg,-1,0,0,2,-90,0,0,2,-1.0000001192092896,-0.1,0,2,-80,0,0,2,0,0,0,2,-90,0,0,2,Fedora_Handle,8.657480066176504e-09,0,0,2,-6,0,0,2,-0.15052366256713867,0,0,2,0,0,0,2,-0.010221302509307861,0,0,2,0,0,0,2,Head,0,0,0,2,-120,5,-1,2,1,0,0,2,-5,0,0,2,0,0,0,2,160,0,0,2,RightArm,1,0,0,2,150,5,-1,2,1.2000000476837158,0,0,2,40,0,0,2,0,0,0,2,-80,0,0,2,Torso,0,0,0,2,-95,0,0,2,0,0.1,0,2,5,0,0,2,0,0,0,2,175,0,0,2
				end
			})
			addmode("u", {
				idle = function()
					RootJoint.C0 = Lerp(RootJoint.C0,cfMul(cf(0, 0.75 + 0.25 * sin(sine * 2), 0),angles(-1.5707963267948966, 0, 3.141592653589793)),deltaTime) 
					Neck.C0 = Lerp(Neck.C0,cfMul(cf(0, 1.5 - 0.1 * sin((sine + 0.2) * 2), 0),angles(-1.5707963267948966 - 0.08726646259971647 * sin((sine + 0.4) * 2), 0, 3.141592653589793 + 0.3490658503988659 * sin(sine * 0.66))),deltaTime) 
					LeftHip.C0 = Lerp(LeftHip.C0,cfMul(cf(-0.5 - 1 * sin((sine + 0.2) * 2.2), -0.75 - 0.25 * sin(sine * 2), 1 * sin((sine + 0.95) * 2.2)),angles(0, -1.5707963267948966, 0)),deltaTime) 
					RightHip.C0 = Lerp(RightHip.C0,cfMul(cf(0.5 + 1 * sin((sine + 0.2) * 2.2), -0.75 - 0.25 * sin(sine * 2), -1 * sin((sine + 0.95) * 2.2)),angles(0, 1.5707963267948966, 0)),deltaTime) 
					RightShoulder.C0 = Lerp(RightShoulder.C0,cfMul(cf(-0.5 - 1.85 * sin(sine * 2), 0.8 - 0.5 * sin(sine * 2), -1.85 * sin((sine + 0.75) * 2)),angles(0, 1.5707963267948966, 0)),deltaTime) 
					LeftShoulder.C0 = Lerp(LeftShoulder.C0,cfMul(cf(0.5 + 1.85 * sin(sine * 2), 0.8 - 0.5 * sin(sine * 2), 1.85 * sin((sine + 0.75) * 2)),angles(0, -1.5707963267948966, 0)),deltaTime) 
					--Torso,0,0,0,2,-90,0,0,2,0.75,0.25,0,2,-0,0,0,2,0,0,0,2,180,0,0,2,Fedora_Handle,8.657480066176504e-09,0,0,2,-6,0,0,2,-0.15052366256713867,0,0,2,0,0,0,2,-0.010221302509307861,0,0,2,0,0,0,2,Head,0,0,0,2,-90,-5,0.4,2,1.5,-0.1,0.2,2,-0,0,0,2,0,0,0,2,180,20,0,0.66,LeftLeg,-0.5,-1,0.2,2.2,-0,0,0,2,-0.75,-0.25,0,2,-90,0,0,2,0,1,0.95,2.2,0,0,0,2,RightLeg,0.5,1,0.2,2.2,0,0,0,2,-0.75,-0.25,0,2,90,0,0,2,0,-1,0.95,2.2,0,0,0,2,RightArm,-0.5,-1.85,0,2,0,0,0,2,0.8,-0.5,0,2,90,0,0,2,0,-1.85,0.75,2,0,0,0,2,LeftArm,0.5,1.85,0,2,-0,0,0,2,0.8,-0.5,0,2,-90,0,0,2,0,1.85,0.75,2,0,0,0,2
				end
			})
			addmode("i", {
				idle = function()
					LeftShoulder.C0 = Lerp(LeftShoulder.C0,cfMul(cf(-0.5, 0.5 + 0.1 * sin((sine - 0.4444444444444444) * 9), 0),angles(2.9670597283903604 + 0.17453292519943295 * sin((sine - 0.17777777777777778) * 9), -0.5235987755982988, 1.5707963267948966 + 0.17453292519943295 * sin(sine * 4.5))),deltaTime) 
					LeftHip.C0 = Lerp(LeftHip.C0,cfMul(cf(-1, -0.5 + 0.1 * sin((sine + 0.26666666666666666) * 4.5), -0.5),angles(1.7453292519943295 - 1.0471975511965976 * sin(sine * 4.5), -1.5707963267948966 + 0.03490658503988659 * sin(sine * 4.5), 1.5707963267948966)),deltaTime) 
					RootJoint.C0 = Lerp(RootJoint.C0,cfMul(cf(0, -0.5 + 0.5 * sin((sine + 0.17777777777777778) * 9), 0),angles(-1.3962634015954636 - 0.03490658503988659 * sin((sine + 0.17777777777777778) * 9), -0.05235987755982989 * sin(sine * 4.5), 3.141592653589793 + 0.03490658503988659 * sin(sine * 4.5))),deltaTime) 
					Neck.C0 = Lerp(Neck.C0,cfMul(cf(0, 1 + 0.2 * sin(sine * 9), 0),angles(-1.5707963267948966 + 0.08726646259971647 * sin(sine * 9), 0.08726646259971647 * sin(sine * 4.5), 3.141592653589793 - 0.06981317007977318 * sin(sine * 4.5))),deltaTime) 
					RightShoulder.C0 = Lerp(RightShoulder.C0,cfMul(cf(0.5, 0.5 + 0.1 * sin((sine - 0.4444444444444444) * 9), 0),angles(2.9670597283903604 + 0.17453292519943295 * sin((sine - 0.17777777777777778) * 9), 0.5235987755982988, -1.5707963267948966 + 0.17453292519943295 * sin(sine * 4.5))),deltaTime) 
					RightHip.C0 = Lerp(RightHip.C0,cfMul(cf(1, -0.5 + 0.1 * sin((sine - 0.26666666666666666) * 4.5), -0.5),angles(1.7453292519943295 + 1.0471975511965976 * sin(sine * 4.5), 1.5707963267948966 + 0.03490658503988659 * sin(sine * 4.5), -1.5707963267948966)),deltaTime) 
					--LeftArm,-0.5,0,0,4.5,170,10,-0.17777777777777778,9,0.5,0.1,-0.4444444444444444,9,-30,0,0,4.5,0,0,0,4.5,90,10,0,4.5,LeftLeg,-1,0,0,4.5,100,-60,0,4.5,-0.5,0.1,0.26666666666666666,4.5,-90,2,0,4.5,-0.5,0,0,4.5,90,0,0,4.5,Torso,0,0,0,4.5,-80,-2,0.17777777777777778,9,-0.5,0.5,0.17777777777777778,9,-0,-3,0,4.5,0,0,0,4.5,180,2,0,4.5,Head,0,0,0,4.5,-90,5,0,9,1,0.2,0,9,-0,5,0,4.5,0,0,0,4.5,180,-4,0,4.5,RightArm,0.5,0,0,4.5,170,10,-0.17777777777777778,9,0.5,0.1,-0.4444444444444444,9,30,0,0,4.5,0,0,0,4.5,-90,10,0,4.5,RightLeg,1,0,0,4.5,100,60,0,4.5,-0.5,0.1,-0.26666666666666666,4.5,90,2,0,4.5,-0.5,0,0,4.5,-90,0,0,4.5
				end,
			})
			addmode("o", {
				idle = function()
					local rY, lY = raycastlegs()
		
					LeftHip.C0 = Lerp(LeftHip.C0,cfMul(cf(-1, -1 + lY, lY * -0.5),angles(-1.8325957145940461 - 0.08726646259971647 * sin(sine * 2), -1.4835298641951802, -1.5707963267948966)),deltaTime) 
					RootJoint.C0 = Lerp(RootJoint.C0,cfMul(cf(0, 0, 0.09 * sin(sine * 2)),angles(-1.3962634015954636 + 0.08726646259971647 * sin(sine * 2), -0.08726646259971647, 3.141592653589793)),deltaTime) 
					LeftShoulder.C0 = Lerp(LeftShoulder.C0,cfMul(cf(-1, 0.5, 0),angles(2.9670597283903604 + 0.08726646259971647 * sin(sine * 1), -1.5707963267948966 + 0.08726646259971647 * sin((sine + 0.6) * 1), 1.5707963267948966)),deltaTime) 
					RightHip.C0 = Lerp(RightHip.C0,cfMul(cf(1, -1.1 + rY, rY * -0.5),angles(-1.7453292519943295 - 0.08726646259971647 * sin(sine * 2), 1.5707963267948966, 1.5707963267948966)),deltaTime) 
					Neck.C0 = Lerp(Neck.C0,cfMul(cf(0, 1, 0),angles(-1.2217304763960306 - 0.08726646259971647 * sin((sine + 0.3) * 2), -0.2617993877991494 - 0.08726646259971647 * sin(sine * 2), 3.141592653589793)),deltaTime) 
					RightShoulder.C0 = Lerp(RightShoulder.C0,cfMul(cf(1, 0.5, 0),angles(2.8797932657906435 + 0.08726646259971647 * sin(sine * 1), 1.5707963267948966 - 0.08726646259971647 * sin((sine + 0.6) * 1), -1.5707963267948966)),deltaTime) 
					--LeftLeg,-1,0,0,2,-105,-5,0,2,-1,0,0,2,-85,0,0,2,0,0,0,2,-90,0,0.75,2,Torso,0,0,0,2,-80,5,0,2,0,0,0,2,-5,0,0,2,0,0.09,0,2,180,0,0,2,LeftArm,-1,0,0,2,170,5,0,1,0.5,0,0,2,-90,5,0.6,1,0,0,0,2,90,0,0,2,RightLeg,1,0,0,2,-100,-5,0,2,-1.1,0,0,2,90,0,0,2,0,0,0,2,90,0,0.75,2,Head,0,0,0,2,-70,-5,0.3,2,1,0,0,2,-15,-5,0,2,0,0,0,2,180,0,0,2,RightArm,1,0,0,2,165,5,0,1,0.5,0,0,2,90,-5,0.6,1,0,0,0,2,-90,0,0,2
				end,
				walk = function()
					local fw, rt = velbycfrvec()
		
					local rY, lY = raycastlegs()
		
					Neck.C0 = Lerp(Neck.C0,cfMul(cf(0, 1, 0),angles(-1.5707963267948966 + 0.04363323129985824 * sin(sine * 16), 0, 3.141592653589793 + 0.08726646259971647 * sin(sine * 8) - rt)),deltaTime) 
					RightHip.C0 = Lerp(RightHip.C0,cfMul(cf(1, -1 - 0.3 * sin((sine + 0.15) * 8) + rY, rY * -0.5),angles(-1.5707963267948966 - 0.6981317007977318 * sin(sine * 8) * fw, 1.5707963267948966 + 0.6981317007977318 * sin(sine * 8) * rt, 1.5707963267948966)),deltaTime) 
					RightShoulder.C0 = Lerp(RightShoulder.C0,cfMul(cf(1, 0.5, 0),angles(0.08726646259971647 * sin((sine - 0.05) * 16), 1.5707963267948966 + 0.08726646259971647 * sin(sine * 8) - rt/3, 1.5707963267948966)),deltaTime) 
					LeftShoulder.C0 = Lerp(LeftShoulder.C0,cfMul(cf(-1, 0.5, 0),angles(0.08726646259971647 * sin((sine - 0.05) * 16), -1.5707963267948966 + 0.08726646259971647 * sin(sine * 8) - rt/3, -1.5707963267948966)),deltaTime) 
					RootJoint.C0 = Lerp(RootJoint.C0,cfMul(cf(0, 0.1 * sin((sine + 0.1) * 16), 0),angles(-1.5707963267948966, 0, 3.141592653589793 - 0.08726646259971647 * sin(sine * 8))),deltaTime) 
					LeftHip.C0 = Lerp(LeftHip.C0,cfMul(cf(-1, -1 + 0.3 * sin((sine + 0.15) * 8) + lY, lY * -0.5),angles(1.5707963267948966 + 0.6981317007977318 * sin(sine * 8) * fw, -1.5707963267948966 + 0.6981317007977318 * sin(sine * 8) * rt, 1.5707963267948966)),deltaTime) 
					--Head,0,0,0,8,-90,2.5,0,16,1,0,0,8,-0,0,0,8,0,0,0,8,180,5,0,8,RightLeg,1,0,0,8,-90,-40,0,8,-1,-0.3,0.15,8,90,40,0,8,0,0,0,8,90,0,0,8,RightArm,1,0,0,8,0,5,-0.05,16,0.5,0,0,8,90,5,0,8,0,0,0,8,90,0,0,8,LeftArm,-1,0,0,8,0,5,-0.05,16,0.5,0,0,8,-90,5,0,8,0,0,0,8,-90,0,0,8,Torso,0,0,0,8,-90,0,0,8,0,0.1,0.1,16,-0,0,0,8,0,0,0,8,180,-5,0,8,LeftLeg,-1,0,0,8,90,40,0,8,-1,0.3,0.15,8,-90,40,0,8,0,0,0,8,90,0,0,8
				end
			})
			addmode("p", {
				idle = function()
					RightShoulder.C0 = Lerp(RightShoulder.C0,cfMul(cf(1.5, 0.5, 0),angles(1.5707963267948966, 3.141592653589793, -1.5707963267948966)),deltaTime) 
					RightHip.C0 = Lerp(RightHip.C0,cfMul(cf(1, -1, 0),angles(0, 1.5707963267948966, 0)),deltaTime) 
					LeftShoulder.C0 = Lerp(LeftShoulder.C0,cfMul(cf(-1.5, 0.5, 0),angles(1.5707963267948966, 3.141592653589793, 1.5707963267948966)),deltaTime) 
					LeftHip.C0 = Lerp(LeftHip.C0,cfMul(cf(-1, -1, 0),angles(0, -1.5707963267948966, 0)),deltaTime) 
					Neck.C0 = Lerp(Neck.C0,cfMul(cf(0, 1, 0),angles(-1.5707963267948966, 0, -3.141592653589793)),deltaTime) 
					RootJoint.C0 = Lerp(RootJoint.C0,cfMul(cf_0,angles(-1.5707963267948966, 0, -3.141592653589793)),deltaTime) 
					--RightArm,1.5,0,0,1,90,0,0,1,0.5,0,0,1,180,0,0,1,0,0,0,1,-90,0,0,1,RightLeg,1,0,0,1,0,0,0,1,-1,0,0,1,90,0,0,1,0,0,0,1,0,0,0,1,Fedora_Handle,8.657480066176504e-09,0,0,1,-6,0,0,1,-0.15052366256713867,0,0,1,0,0,0,1,-0.010221302509307861,0,0,1,0,0,0,1,LeftArm,-1.5,0,0,1,90,0,0,1,0.5,0,0,1,180,0,0,1,0,0,0,1,90,0,0,1,LeftLeg,-1,0,0,1,-0,0,0,1,-1,0,0,1,-90,0,0,1,0,0,0,1,0,0,0,1,Head,0,0,0,1,-90,0,0,1,1,0,0,1,0,0,0,1,0,0,0,1,-180,0,0,1,Torso,0,0,0,1,-90,0,0,1,0,0,0,1,0,0,0,1,0,0,0,1,-180,0,0,1
				end
			})
			addmode("f", {
				idle = function()
					LeftShoulder.C0 = Lerp(LeftShoulder.C0,cfMul(cf(-1, 0.5, 0),angles(-3.0543261909900767 - 0.17453292519943295 * sin((sine + 1.5) * 1), -1.5707963267948966 + 0.08726646259971647 * sin((sine + 0.6) * 1), -1.5707963267948966)),deltaTime) 
					RightShoulder.C0 = Lerp(RightShoulder.C0,cfMul(cf(1, 0.5, 0),angles(3.141592653589793 - 0.08726646259971647 * sin(sine * 1), 0.3490658503988659 + 0.08726646259971647 * sin((sine + 0.3) * 1), -1.9198621771937625 + 0.08726646259971647 * sin((sine + 1) * 1))),deltaTime) 
					Neck.C0 = Lerp(Neck.C0,cfMul(cf(0, 1, 0),angles(-1.3089969389957472 - 0.2617993877991494 * sin((sine + 1.2) * 1), 0.08726646259971647 * sin((sine + 0.2) * 0.5), -2.9670597283903604)),deltaTime) 
					RootJoint.C0 = Lerp(RootJoint.C0,cfMul(cf(0, 5 - 0.5 * sin((sine - 0.2) * 1), 0.2 * sin((sine - 1.2) * 1)),angles(-0.08726646259971647 + 0.17453292519943295 * sin((sine + 1.2) * 1), 0.08726646259971647 * sin(sine * 0.5), 3.141592653589793)),deltaTime) 
					LeftHip.C0 = Lerp(LeftHip.C0,cfMul(cf(-1, -1, 0),angles(1.3962634015954636 + 0.12217304763960307 * sin((sine + 1.5) * 1), -1.2217304763960306 + 0.08726646259971647 * sin((sine + 0.2) * 0.5), 1.5707963267948966)),deltaTime) 
					RightHip.C0 = Lerp(RightHip.C0,cfMul(cf(1, -1, 0),angles(1.9198621771937625 + 0.12217304763960307 * sin((sine + 1.5) * 1), 1.2217304763960306 + 0.08726646259971647 * sin((sine + 0.2) * 0.5), -1.5707963267948966)),deltaTime) 
					--LeftArm,-1,0,0,1,-175,-10,1.5,1,0.5,0,0,1,-90,5,0.6,1,0,0,0,1,-90,0,0,1,RightArm,1,0,0,1,180,-5,0,1,0.5,0,0,1,20,5,0.3,1,0,0,0,1,-110,5,1,1,Head,0,0,0,1,-75,-15,1.2,1,1,0,0,1,-0,5,0.2,0.5,0,0,0,1,-170,0,0,1,Torso,0,0,0,1,-5,10,1.2,1,5,-0.5,-0.2,1,-0,5,0,0.5,0,0.2,-1.2,1,180,0,0,1,LeftLeg,-1,0,0,1,80,7,1.5,1,-1,0,0,1,-70,5,0.2,0.5,0,0,0,1,90,0,0,1,RightLeg,1,0,0,1,110,7,1.5,1,-1,0,0,1,70,5,0.2,0.5,0,0,0,1,-90,0,0,1
				end,
				walk = function()
					local fw, rt = velbycfrvec()
		
					LeftShoulder.C0 = Lerp(LeftShoulder.C0,cfMul(cf(-1, 0.5, 0),angles(-3.0543261909900767 - 0.17453292519943295 * sin((sine + 1.5) * 1) - fw * 0.1, -1.5707963267948966 + 0.08726646259971647 * sin((sine + 0.6) * 1) + rt * 0.2, -1.5707963267948966)),deltaTime) 
					RightShoulder.C0 = Lerp(RightShoulder.C0,cfMul(cf(1, 0.5, 0),angles(3.141592653589793 - 0.08726646259971647 * sin(sine * 1), 0.3490658503988659 + 0.08726646259971647 * sin((sine + 0.3) * 1), -1.9198621771937625 + 0.08726646259971647 * sin((sine + 1) * 1))),deltaTime) 
					Neck.C0 = Lerp(Neck.C0,cfMul(cf(0, 1, 0),angles(-1.3089969389957472 - 0.2617993877991494 * sin((sine + 1.2) * 1) + fw * 0.1, 0.08726646259971647 * sin((sine + 0.2) * 0.5) - rt * 0.2, -2.9670597283903604)),deltaTime) 
					RootJoint.C0 = Lerp(RootJoint.C0,cfMul(cf(0, 5 - 0.5 * sin((sine - 0.2) * 1), 0.2 * sin((sine - 1.2) * 1)),angles(-0.08726646259971647 + 0.17453292519943295 * sin((sine + 1.2) * 1) - fw * 0.2, 0.08726646259971647 * sin(sine * 0.5), 3.141592653589793 - rt * 0.2)),deltaTime) 
					LeftHip.C0 = Lerp(LeftHip.C0,cfMul(cf(-1, -1, 0),angles(1.3962634015954636 + 0.12217304763960307 * sin((sine + 1.5) * 1) - fw * 0.2, -1.2217304763960306 + 0.08726646259971647 * sin((sine + 0.2) * 0.5), 1.5707963267948966)),deltaTime) 
					RightHip.C0 = Lerp(RightHip.C0,cfMul(cf(1, -1, 0),angles(1.9198621771937625 + 0.12217304763960307 * sin((sine + 1.5) * 1) - fw * 0.2, 1.2217304763960306 + 0.08726646259971647 * sin((sine + 0.2) * 0.5), -1.5707963267948966)),deltaTime) 
					--LeftArm,-1,0,0,1,-175,-10,1.5,1,0.5,0,0,1,-90,5,0.6,1,0,0,0,1,-90,0,0,1,RightArm,1,0,0,1,180,-5,0,1,0.5,0,0,1,20,5,0.3,1,0,0,0,1,-110,5,1,1,Head,0,0,0,1,-75,-15,1.2,1,1,0,0,1,-0,5,0.2,0.5,0,0,0,1,-170,0,0,1,Torso,0,0,0,1,-5,10,1.2,1,5,-0.5,-0.2,1,-0,5,0,0.5,0,0.2,-1.2,1,180,0,0,1,LeftLeg,-1,0,0,1,80,7,1.5,1,-1,0,0,1,-70,5,0.2,0.5,0,0,0,1,90,0,0,1,RightLeg,1,0,0,1,110,7,1.5,1,-1,0,0,1,70,5,0.2,0.5,0,0,0,1,-90,0,0,1
				end
			})
			addmode("g", {
				idle = function()
					LeftShoulder.C0 = Lerp(LeftShoulder.C0,cfMul(cf(-0.9 + 0.4 * sin(sine * 8), 0.5, 0.5 * sin((sine + 0.25) * 4)),angles(1.5707963267948966, -1.5707963267948966 + 1.0471975511965976 * sin(sine * 8), 1.5707963267948966 + 0.6981317007977318 * sin((sine + 0.25) * 4))),deltaTime) 
					RootJoint.C0 = Lerp(RootJoint.C0,cfMul(cf(0.3 * sin((sine + 0.4) * 8), 0, 0),angles(-1.5707963267948966, 0.3490658503988659 * sin(sine * 8), -3.141592653589793)),deltaTime) 
					Neck.C0 = Lerp(Neck.C0,cfMul(cf(0, 1, 0),angles(-1.5707963267948966 + 0.061086523819801536 * sin((sine + 0.125) * 16), -0.3839724354387525 * sin(sine * 8), -3.141592653589793)),deltaTime) 
					RightHip.C0 = Lerp(RightHip.C0,cfMul(cf(1, -1 + 0.4 * sin((sine - 0.01) * 8), 0),angles(1.5707963267948966, 1.7453292519943295 + 0.6981317007977318 * sin(sine * 8), -1.5707963267948966)),deltaTime) 
					LeftHip.C0 = Lerp(LeftHip.C0,cfMul(cf(-1, -1 - 0.4 * sin((sine - 0.01) * 8), 0),angles(1.5707963267948966, -1.7453292519943295 + 0.6981317007977318 * sin(sine * 8), 1.5707963267948966)),deltaTime) 
					RightShoulder.C0 = Lerp(RightShoulder.C0,cfMul(cf(0.9 + 0.4 * sin(sine * 8), 0.5, -0.5 * sin((sine - 0.35) * 4)),angles(1.5707963267948966 + 0.6981317007977318 * sin(sine * 4), 1.5707963267948966 + 1.0471975511965976 * sin(sine * 8), -1.5707963267948966 + 0.17453292519943295 * sin((sine - 0.35) * 4))),deltaTime) 
					--LeftArm,-0.9,0.4,0,8,90,0,0.25,4,0.5,0,0,8,-90,60,0,8,0,0.5,0.25,4,90,40,0.25,4,Torso,0,0.3,0.4,8,-90,0,0,8,0,0,0,4,0,20,0,8,0,0,0,8,-180,0,0,8,Head,0,0,0,8,-90,3.5,0.125,16,1,0,0,8,0,-22,0,8,0,0,0,8,-180,0,0,1.1,RightLeg,1,0,0,8,90,0,0,8,-1,0.4,-0.01,8,100,40,0,8,0,0,0,8,-90,0,0,8,LeftLeg,-1,0,0,8,90,0,0,8,-1,-0.4,-0.01,8,-100,40,0,8,0,0,0,8,90,0,0,8,RightArm,0.9,0.4,0,8,90,40,0,4,0.5,0,0,8,90,60,0,8,0,-0.5,-0.35,4,-90,10,-0.35,4
				end
			})
			addmode("h", {
				idle = function()
					Neck.C0 = Lerp(Neck.C0,cfMul(cf(0, 1, 0),angles(-1.5707963267948966, -0.4363323129985824 * sin(sine * 8), -3.141592653589793)),deltaTime) 
					RightHip.C0 = Lerp(RightHip.C0,cfMul(cf(1, -1 + 0.3 * sin(sine * 8), 0),angles(1.5707963267948966, 1.5707963267948966 + 0.5235987755982988 * sin(sine * 8), -1.5707963267948966)),deltaTime) 
					LeftShoulder.C0 = Lerp(LeftShoulder.C0,cfMul(cf(-0.5, 1, 0),angles(-0.5235987755982988, -1.5707963267948966 - 0.5235987755982988 * sin(sine * 8), 3.141592653589793)),deltaTime) 
					RightShoulder.C0 = Lerp(RightShoulder.C0,cfMul(cf(0.5, 1, 0),angles(-0.5235987755982988, 1.5707963267948966 - 0.5235987755982988 * sin(sine * 8), 3.141592653589793)),deltaTime) 
					RootJoint.C0 = Lerp(RootJoint.C0,cfMul(cf(-0.1 * sin(sine * 8), 0.2 * sin((sine + 0.1) * 16), 0),angles(-1.5707963267948966, 0.2617993877991494 * sin(sine * 8), -3.141592653589793)),deltaTime) 
					LeftHip.C0 = Lerp(LeftHip.C0,cfMul(cf(-1, -1 - 0.3 * sin(sine * 8), 0),angles(1.5707963267948966, -1.5707963267948966 + 0.5235987755982988 * sin(sine * 8), 1.5707963267948966)),deltaTime) 
					--Head,0,0,0,8,-90,0,0,8,1,0,0,8,0,-25,0,8,0,0,0,8,-180,0,0,8,RightLeg,1,0,0,8,90,0,0,8,-1,0.3,0,8,90,30,0,8,0,0,0,8,-90,0,0,8,LeftArm,-0.5,0,0,8,-30,0,0,8,1,0,0,8,-90,-30,0,8,0,0,0,8,180,0,0,8,RightArm,0.5,0,0,8,-30,0,0,8,1,0,0,16,90,-30,0,8,0,0,0,8,180,0,0,8,Torso,0,-0.1,0,8,-90,0,0,8,0,0.2,0.1,16,0,15,0,8,0,0,0,8,-180,0,0,8,LeftLeg,-1,0,0,8,90,0,0,8,-1,-0.3,0,8,-90,30,0,8,0,0,0,8,90,0,0,8,Fedora_Handle,8.657480066176504e-09,0,0,8,-6,0,0,8,-0.15052366256713867,0,0,8,0,0,0,8,-0.010221302509307861,0,0,8,0,0,0,8
				end
			})
			addmode("j", {
				idle = function()
					LeftHip.C0 = Lerp(LeftHip.C0,cfMul(cf(-0.8, -1, -0.1),angles(0.17453292519943295, -0.6981317007977318, 0)),deltaTime) 
					LeftShoulder.C0 = Lerp(LeftShoulder.C0,cfMul(cf(-1.2, 0.5, 0),angles(-0.3490658503988659 + 0.08726646259971647 * sin((sine + 0.1) * 4), 0, 0.6981317007977318 + 0.08726646259971647 * sin((sine + 0.1) * 4))),deltaTime) 
					RightHip.C0 = Lerp(RightHip.C0,cfMul(cf(1.1, -1, 0),angles(1.5707963267948966, 1.7453292519943295, -1.5707963267948966)),deltaTime) 
					Neck.C0 = Lerp(Neck.C0,cfMul(cf(0, 1, 0),angles(-1.5707963267948966 + 0.08726646259971647 * sin((sine + 0.1) * 4), 0, 2.792526803190927)),deltaTime) 
					RootJoint.C0 = Lerp(RootJoint.C0,cfMul(cf(0, -1.7 + 0.5 * sin(sine * 4), 0.15 * sin(sine * 4)),angles(3.3161255787892263 + 0.17453292519943295 * sin(sine * 4), 0, 3.6651914291880923)),deltaTime) 
					RightShoulder.C0 = Lerp(RightShoulder.C0,cfMul(cf(0.8 + 0.4 * sin(sine * 4), 0.6 + 0.1 * sin(sine * 4), 0.4 - 0.25 * sin(sine * 4)),angles(2.9670597283903604, 2.2689280275926285 - 0.17453292519943295 * sin(sine * 4), -1.4835298641951802 - 0.17453292519943295 * sin(sine * 4))),deltaTime) 
					--GalaxyBeautifulHair_Handle,-0.15000000596046448,0,0,1,0,0,0,1,0.10000000149011612,0,0,1,0,0,0,1,0,0,0,1,0,0,0,1,LeftLeg,-0.8,0,0,4,10,0,0,4,-1,0,0,4,-40,0,0,4,-0.1,0,0,4,0,0,0,4,LeftArm,-1.2,0,0,4,-20,5,0.1,4,0.5,0,0,4,0,0,0,4,0,0,0,4,40,5,0.1,4,Fedora_Handle,8.657480066176504e-09,0,0,1,-6,0,0,1,-0.15052366256713867,0,0,1,0,0,0,1,-0.010221302509307861,0,0,1,0,0,0,1,ValkyrieHelm_Handle,8.658389560878277e-09,0,0,1,-15,0,0,1,-0.2433757781982422,0,0,1,0,0,0,1,-0.2657628059387207,0,0,1,0,0,0,1,RightLeg,1.1,0,0,4,90,0,0,4,-1,0,0,4,100,0,0,4,0,0,0,4,-90,0,0,4,BlackIronAntlers_Handle,8.658389560878277e-09,0,0,1,0,0,0,1,-0.6500000953674316,0,0,1,0,0,0,1,0.19972775876522064,0,0,1,0,0,0,1,DevAwardsAdurite_Handle,0,0,0,1,0,0,0,1,-0.25,0,0,1,0,0,0,1,0,0,0,1,0,0,0,1,SilverthornAntlers_Handle,8.658389560878277e-09,0,0,1,0,0,0,1,-0.6500000953674316,0,0,1,0,0,0,1,0.19972775876522064,0,0,1,0,0,0,1,Head,0,0,0,4,-90,5,0.1,4,1,0,0,4,-0,0,0,4,0,0,0,4,160,0,0,4,Torso,0,0,0,4,190,10,0,4,-1.70,0.5,0,4,-0,0,0,4,0,0.15,0,4,210,0,0,4,RightArm,0.8,0.4,0,4,170,0,0,4,0.6,0.1,0,4,130,-10,0,4,0.4,-0.25,0,4,-85,-10,0,4
				end
			})
			addmode("k", {
				idle = function()
					Neck.C0 = Lerp(Neck.C0,cfMul(cf(0, 1, 0),angles(-1.6580627893946132 - 0.08726646259971647 * sin((sine + 0.3333333333333333) * 12), -0.08726646259971647 * sin((sine + 0.2) * 6), 3.141592653589793)),deltaTime) 
					LeftHip.C0 = Lerp(LeftHip.C0,cfMul(cf(-1, -0.5 - 0.5 * sin((sine + 0.39999999999999997) * 12), -0.5),angles(1.7453292519943295 - 1.0471975511965976 * sin(sine * 6), -1.5707963267948966 + 0.1308996938995747 * sin(sine * 6), 1.5707963267948966)),deltaTime) 
					RightHip.C0 = Lerp(RightHip.C0,cfMul(cf(1, -0.5 - 0.5 * sin((sine + 0.39999999999999997) * 12), -0.5),angles(1.7453292519943295 + 1.0471975511965976 * sin(sine * 6), 1.5707963267948966 + 0.1308996938995747 * sin(sine * 6), -1.5707963267948966)),deltaTime) 
					RootJoint.C0 = Lerp(RootJoint.C0,cfMul(cf(0, -0.5 + 0.3 * sin((sine + 0.16666666666666666) * 12), 0),angles(-1.3962634015954636 + 0.08726646259971647 * sin((sine + 0.3333333333333333) * 12), 0.08726646259971647 * sin((sine + 0.06666666666666667) * 6), 3.141592653589793)),deltaTime) 
					LeftShoulder.C0 = Lerp(LeftShoulder.C0,cfMul(cf(-0.8 - 0.1 * sin(sine * 6), 0.5 + 0.1 * sin(sine * 6), -0.2),angles(3.141592653589793 - 0.17453292519943295 * sin((sine + 0.39999999999999997) * 12), -0.17453292519943295, 1.5707963267948966)),deltaTime) 
					RightShoulder.C0 = Lerp(RightShoulder.C0,cfMul(cf(0.8 - 0.1 * sin(sine * 6), 0.5 - 0.1 * sin(sine * 6), -0.2),angles(3.141592653589793 - 0.17453292519943295 * sin((sine + 0.39999999999999997) * 12), 0.17453292519943295, -1.5707963267948966)),deltaTime) 
					--GalaxyBeautifulHair_Handle,-0.15000000596046448,0,0,1.5,0,0,0,1.5,0.10000000149011612,0,0,1.5,0,0,0,1.5,0,0,0,1.5,0,0,0,1.5,Head,0,0,0,6,-95,-5,0.3333333333333333,12,1,0,0,6,-0,-5,0.2,6,0,0,0,6,180,0,0,6,ValkyrieHelm_Handle,8.658389560878277e-09,0,0,1.5,-15,0,0,1.5,-0.2433757781982422,0,0,1.5,0,0,0,1.5,-0.2657628059387207,0,0,1.5,0,0,0,1.5,SilverthornAntlers_Handle,8.658389560878277e-09,0,0,1.5,0,0,0,1.5,-0.6500000953674316,0,0,1.5,0,0,0,1.5,0.19972775876522064,0,0,1.5,0,0,0,1.5,BlackIronAntlers_Handle,8.658389560878277e-09,0,0,1.5,0,0,0,1.5,-0.6500000953674316,0,0,1.5,0,0,0,1.5,0.19972775876522064,0,0,1.5,0,0,0,1.5,Fedora_Handle,8.657480066176504e-09,0,0,1.5,-6,0,0,1.5,-0.15052366256713867,0,0,1.5,0,0,0,1.5,-0.010221302509307861,0,0,1.5,0,0,0,1.5,LeftLeg,-1,0,0,6,100,-60,0,6,-0.5,-0.5,0.39999999999999997,12,-90,7.5,0,6,-0.5,0,0,6,90,0,0,6,EyelessSmileHead_Handle,-0.00043487548828125,0,0,1.5,180,0,0,1.5,0.6000361442565918,0,0,1.5,0,0,0,1.5,0.0003204345703125,0,0,1.5,180,0,0,1.5,RightLeg,1,0,0,6,100,60,0,6,-0.5,-0.5,0.39999999999999997,12,90,7.5,0,6,-0.5,0,0,6,-90,0,0,6,DevAwardsAdurite_Handle,0,0,0,1.5,0,0,0,1.5,-0.25,0,0,1.5,0,0,0,1.5,0,0,0,1.5,0,0,0,1.5,Torso,0,0,0,6,-80,5,0.3333333333333333,12,-0.5,0.3,0.16666666666666666,12,-0,5,0.06666666666666667,6,0,0,0,6,180,0,0,6,LeftArm,-0.8,-0.1,0,6,180,-10,0.39999999999999997,12,0.5,0.1,0,6,-10,0,0,6,-0.2,0,0,6,90,0,0,6,RightArm,0.8,-0.1,0,6,180,-10,0.39999999999999997,12,0.5,-0.1,0,6,10,0,0,6,-0.2,0,0,6,-90,0,0,6
				end
			})
			addmode("l", {
				idle = function()
					Neck.C0 = Lerp(Neck.C0,cfMul(cf(0, 1, 0),angles(-1.5707963267948966 + 0.04363323129985824 * sin((sine + 0.1) * 1), -0.17453292519943295 * sin((sine + 0.1) * 5), -3.141592653589793)),deltaTime) 
					RightHip.C0 = Lerp(RightHip.C0,cfMul(cf(1, -1 + 0.2 * sin(sine * 5), -0.2 + 0.2 * sin(sine * 5)),angles(2.181661564992912 - 0.8726646259971648 * sin(sine * 5), 1.9198621771937625 - 0.3490658503988659 * sin(sine * 5), -1.5707963267948966)),deltaTime) 
					RightShoulder.C0 = Lerp(RightShoulder.C0,cfMul(cf(0.7, 0.8, 0),angles(1.0471975511965976 + 0.03490658503988659 * sin(sine * 10), 2.0943951023931953 + 0.10471975511965978 * sin((sine + 0.1) * 5), 1.5707963267948966)),deltaTime) 
					LeftHip.C0 = Lerp(LeftHip.C0,cfMul(cf(-1, -1 - 0.2 * sin(sine * 5), -0.2 - 0.2 * sin(sine * 5)),angles(2.181661564992912 + 0.8726646259971648 * sin(sine * 5), -1.9198621771937625 - 0.3490658503988659 * sin(sine * 5), 1.5707963267948966)),deltaTime) 
					RootJoint.C0 = Lerp(RootJoint.C0,cfMul(cf(0, 0.15 + 0.4 * sin((sine - 0.5) * 10), 0),angles(-1.4835298641951802, 0.17453292519943295 * sin(sine * 5), -3.141592653589793)),deltaTime) 
					LeftShoulder.C0 = Lerp(LeftShoulder.C0,cfMul(cf(-0.7, 0.5, -0.3),angles(1.7453292519943295, -0.8726646259971648, 1.5707963267948966)),deltaTime) 
					--Head,0,0,0,5,-90,2.5,0.1,1,1,0,0,4,0,-10,0.1,5,0,0,0,4,-180,0,0,4,RightLeg,1,0,0,4,125,-50,0,5,-1,0.2,0,5,110,-20,0,5,-0.2,0.2,0,5,-90,0,0,4,RightArm,0.7,0,0,4,60,2,0,10,0.8,0,0,4,120,6,0.1,5,0,0,0,4,90,0,0,4,LeftLeg,-1,0,0,4,125,50,0,5,-1,-0.2,0,5,-110,-20,0,5,-0.2,-0.2,0,5,90,0,0,4,Torso,0,0,0,4,-85,0,0,4,0.15,0.4,-0.5,10,0,10,0,5,0,0,0,4,-180,0,0,4,LeftArm,-0.7,0,0,4,100,0,0,4,0.5,0,0,4,-50,0,0,4,-0.3,0,0,4,90,0,0,4
				end
			})
		end,
		function(t)
			local velbycfrvec=t.velbycfrvec
			local raycastlegs=t.raycastlegs
			local getJoint=t.getJoint
			local RootJoint=getJoint("RootJoint")
			local RightShoulder=getJoint("Right Shoulder")
			local LeftShoulder=getJoint("Left Shoulder")
			local RightHip=getJoint("Right Hip")
			local LeftHip=getJoint("Left Hip")
			local Neck=getJoint("Neck")
			t.addmode("default", {
				idle = function()
					local rY, lY = raycastlegs()
		
					RightShoulder.C0 = Lerp(RightShoulder.C0,cfMul(cf(1, 0.5, 0),angles(0.6981317007977318 * sin((sine + 0.5) * 4), 1.5707963267948966 - 0.3490658503988659 * sin(sine * 4), 0)),deltaTime) 
					LeftShoulder.C0 = Lerp(LeftShoulder.C0,cfMul(cf(-1, 0.5, 0),angles(0.6981317007977318 * sin((sine + 0.5) * 4), -1.5707963267948966 + 0.3490658503988659 * sin(sine * 4), 0)),deltaTime) 
					RightHip.C0 = Lerp(RightHip.C0,cfMul(cf(1, -1 + rY, 0),angles(1.5707963267948966 - 1.0471975511965976 * sin(sine * 4), 1.6580627893946132, -1.5707963267948966)),deltaTime) 
					RootJoint.C0 = Lerp(RootJoint.C0,cfMul(cf(0, -0.2 + 0.2 * sin((sine + 1) * 8), 0),angles(-1.5707963267948966 + 0.6981317007977318 * sin(sine * 4), 0, 3.141592653589793)),deltaTime) 
					LeftHip.C0 = Lerp(LeftHip.C0,cfMul(cf(-1, -1 + lY, 0),angles(1.5707963267948966 - 1.0471975511965976 * sin(sine * 4), -1.6580627893946132, 1.5707963267948966)),deltaTime) 
					Neck.C0 = Lerp(Neck.C0,cfMul(cf(0, 1, 0),angles(-1.5707963267948966 - 0.8726646259971648 * sin((sine + 0.25) * 4), 0, 3.141592653589793)),deltaTime) 
					--RightArm,1,0,0,4,0,40,0.5,4,0.5,0,0,4,90,-20,0,4,0,0,0,4,0,0,0,4,LeftArm,-1,0,0,4,-0,40,0.5,4,0.5,0,0,4,-90,20,0,4,0,0,0,4,0,0,0,4,RightLeg,1,0,0,4,90,-60,0,4,-1,0,0,4,95,0,0,4,0,0,0,4,-90,0,0,4,Torso,0,0,0,4,-90,40,0,4,-0.2,0.2,1,8,-0,0,0,4,0,0,0,4,180,0,0,4,LeftLeg,-1,0,0,4,90,-60,0,4,-1,0,0,4,-95,0,0,4,0,0,0,4,90,0,0,4,Head,0,0,0,4,-90,-50,0.25,4,1,0,0,4,-0,0,0,4,0,0,0,4,180,0,0,4,CPlusPlusTextbook_Handle,8.658389560878277e-09,0,0,4,0,0,0,4,-0.25,0,0,4,0,0,0,4,-0.0002722442150115967,0,0,4,0,0,0,4
				end,
				walk = function()
					local fw, rt = velbycfrvec()
		
					Neck.C0 = Lerp(Neck.C0,cfMul(cf(0, 1, 0),angles(-1.5707963267948966 + 0.5235987755982988 * sin((sine + 0.45) * 8), 0, 3.141592653589793)),deltaTime) 
					RightShoulder.C0 = Lerp(RightShoulder.C0,cfMul(cf(1, 0.5, 0),angles(2.0943951023931953 - 1.7453292519943295 * sin((sine - 0.1) * 4), 1.9198621771937625, -1.5707963267948966)),deltaTime) 
					RootJoint.C0 = Lerp(RootJoint.C0,cfMul(cf(0, 0.25 + 0.5 * sin((sine - 0.125) * 8), 0),angles(-1.5707963267948966 + 0.17453292519943295 * sin(sine * 8), 0, 3.141592653589793)),deltaTime) 
					LeftHip.C0 = Lerp(LeftHip.C0,cfMul(cf(-1, -1 - 1 * sin(sine * 4), 0),angles(1.5707963267948966 - 1.2217304763960306 * sin((sine - 0.15) * 4) * fw, -1.5707963267948966 - 0.6108652381980153 * sin((sine - 0.15) * 4) * rt, 1.5707963267948966)),deltaTime) 
					RightHip.C0 = Lerp(RightHip.C0,cfMul(cf(1, -1 + 1 * sin(sine * 4), 0),angles(1.5707963267948966 + 1.2217304763960306 * sin((sine - 0.15) * 4) * fw, 1.5707963267948966 + 0.6108652381980153 * sin((sine - 0.15) * 4) * rt, -1.5707963267948966)),deltaTime) 
					LeftShoulder.C0 = Lerp(LeftShoulder.C0,cfMul(cf(-1, 0.5, 0),angles(2.0943951023931953 + 1.7453292519943295 * sin((sine - 0.1) * 4), -1.7453292519943295, 1.5707963267948966)),deltaTime) 
					--Head,0,0,0,4,-90,30,0.45,8,1,0,0,4,-0,0,0,4,0,0,0,4,180,0,0,4,CPlusPlusTextbook_Handle,8.658389560878277e-09,0,0,4,0,0,0,4,-0.25,0,0,4,0,0,0,4,-0.0002722442150115967,0,0,4,0,0,0,4,RightArm,1,0,0,4,120,-100,-0.1,4,0.5,0,0,4,110,0,0,4,0,0,0,4,-90,0,0,4,Torso,0,0,0,4,-90,10,0,8,0.25,0.5,-0.125,8,-0,0,0,4,0,0,0,4,180,0,0,4,LeftLeg,-1,0,0,4,90,-70,-0.15,4,-1,-1,0,4,-90,-35,-0.15,4,0,0,0,4,90,0,0,4,RightLeg,1,0,0,4,90,70,-0.15,4,-1,1,0,4,90,35,-0.15,4,0,0,0,4,-90,0,0,4,LeftArm,-1,0,0,4,120,100,-0.1,4,0.5,0,0,4,-100,0,0,4,0,0,0,4,90,0,0,4
				end
			})
		end,
		function(t)
			local addmode=t.addmode
			local getJoint=t.getJoint
			local RootJoint=getJoint("RootJoint")
			local RightShoulder=getJoint("Right Shoulder")
			local LeftShoulder=getJoint("Left Shoulder")
			local RightHip=getJoint("Right Hip")
			local LeftHip=getJoint("Left Hip")
			local Neck=getJoint("Neck")
			local setWalkSpeed=t.setWalkSpeed
			local setJumpPower=t.setJumpPower
			setWalkSpeed(20)
			setJumpPower(50)
		
			local ROOTC0=angles(-1.5707963267948966,0,3.141592653589793)
			local NECKC0=cfMul(cf(0,1,0),angles(-1.5707963267948966,0,3.141592653589793))
			local RIGHTSHOULDERC0=cfMul(cf(-0.5,0,0),angles(0,1.5707963267948966,0))
			local LEFTSHOULDERC0=cfMul(cf(0.5,0,0),angles(0,-1.5707963267948966,0))
			local rad=math.rad
		
			--bruh yeah shackluster had a lot of math.rad(0) instead of just 0
			--and a lot of multyplying by angles(0, 0, 0)
			--and he had ArtificialHB
			--and he had a sine value increasing by 2/3 each frame
			--and a lot of variables with names saying other things
			--and he had both C0 and C1 lerps for the same animations
		
			local jumplerps=function()
				local Animation_Speed = 0.45 / deltaTime
				RootJoint.C1 = Lerp(RootJoint.C1,ROOTC0, 0.2 / Animation_Speed)
				Neck.C1 = Lerp(Neck.C1,cfMul(cf(0, -0.5, 0),angles(-1.5707963267948966, 0, 3.141592653589793)), 0.2 / Animation_Speed)
				RightHip.C1 = Lerp(RightHip.C1,cfMul(cf(0.5, 1, 0),angles(0, 1.5707963267948966, 0)), 0.7 / Animation_Speed)
				LeftHip.C1 = Lerp(LeftHip.C1,cfMul(cf(-0.5, 1, 0),angles(0, -1.5707963267948966, 0)), 0.7 / Animation_Speed)
		
				RootJoint.C0 = Lerp(RootJoint.C0,ROOTC0, 0.2 / Animation_Speed)
				Neck.C0 = Lerp(Neck.C0,cfMul(NECKC0,angles(-0.3490658503988659, 0, 0)), 0.2 / Animation_Speed)
				RightShoulder.C0 = Lerp(RightShoulder.C0,cfMul(cfMul(cf(1.5, 0.5, 0),angles(-0.6981317007977318, 0, 0.3490658503988659)), RIGHTSHOULDERC0), 0.2 / Animation_Speed)
				LeftShoulder.C0 = Lerp(LeftShoulder.C0,cfMul(cfMul(cf(-1.5, 0.5, 0),angles(-0.6981317007977318, 0, -0.3490658503988659)), LEFTSHOULDERC0), 0.2 / Animation_Speed)
				RightHip.C0 = Lerp(RightHip.C0,cfMul(cf(1, -1, -0.3),angles(0, 1.5707963267948966, 0),angles(-0.08726646259971647, 0, -0.3490658503988659)), 0.2 / Animation_Speed)
				LeftHip.C0 = Lerp(LeftHip.C0,cfMul(cf(-1, -1, -0.3),angles(0, -1.5707963267948966, 0),angles(-0.08726646259971647, 0, 0.3490658503988659)), 0.2 / Animation_Speed)	
			end
			local falllerps=function()
				local Animation_Speed = 0.45 / deltaTime
				RootJoint.C1 = Lerp(RootJoint.C1,ROOTC0, 0.2 / Animation_Speed)
				Neck.C1 = Lerp(Neck.C1,cfMul(cf(0, -0.5, 0),angles(-1.5707963267948966, 0, 3.141592653589793)), 0.2 / Animation_Speed)
				RightHip.C1 = Lerp(RightHip.C1,cfMul(cf(0.5, 1, 0),angles(0, 1.5707963267948966, 0)), 0.7 / Animation_Speed)
				LeftHip.C1 = Lerp(LeftHip.C1,cfMul(cf(-0.5, 1, 0),angles(0, -1.5707963267948966, 0)), 0.7 / Animation_Speed)
		
				RootJoint.C0 = Lerp(RootJoint.C0,ROOTC0, 0.2 / Animation_Speed)
				Neck.C0 = Lerp(Neck.C0,cfMul(NECKC0,angles(0.3490658503988659, 0, 0)), 0.2 / Animation_Speed)
				RightShoulder.C0 = Lerp(RightShoulder.C0,cfMul(cfMul(cf(1.5, 0.5, 0),angles(0, 0, 1.0471975511965976)), RIGHTSHOULDERC0), 0.2 / Animation_Speed)
				LeftShoulder.C0 = Lerp(LeftShoulder.C0,cfMul(cfMul(cf(-1.5, 0.5, 0),angles(0, 0, -1.0471975511965976)), LEFTSHOULDERC0), 0.2 / Animation_Speed)
				RightHip.C0 = Lerp(RightHip.C0,cfMul(cfMul(cf(1, -1, 0),angles(0, 1.5707963267948966, 0)),angles(0, 0, 0.3490658503988659)), 0.2 / Animation_Speed)
				LeftHip.C0 = Lerp(LeftHip.C0,cfMul(cfMul(cf(-1, -1, 0),angles(0, -1.5707963267948966, 0)),angles(0, 0, 0.17453292519943295)), 0.2 / Animation_Speed)
			end
		
			local idleOverwrite=nil
		
			addmode("default",{ --mode 1
				modeLeft=function() --enter mode 0
					setWalkSpeed(0)
					setJumpPower(0)
					idleOverwrite=function()
						local sine = sine * 40
						local Animation_Speed = 0.45 / deltaTime
						RootJoint.C1 = Lerp(RootJoint.C1,ROOTC0, 0.2 / Animation_Speed)
						Neck.C1 = Lerp(Neck.C1,cfMul(cf(0, -0.5, 0),angles(-1.5707963267948966, 0, 3.141592653589793)), 0.2 / Animation_Speed)
						RightHip.C1 = Lerp(RightHip.C1,cfMul(cf(0.5, 1, 0),angles(0, 1.5707963267948966, 0)), 0.7 / Animation_Speed)
						LeftHip.C1 = Lerp(LeftHip.C1,cfMul(cf(-0.5, 1, 0),angles(0, -1.5707963267948966, 0)), 0.7 / Animation_Speed)
		
						RootJoint.C0 = Lerp(RootJoint.C0,ROOTC0 * cf(0, 0, 0.05 * cos(sine / 12)), 1 / Animation_Speed)
						Neck.C0 = Lerp(Neck.C0, NECKC0, 1 / Animation_Speed)
						RightShoulder.C0 = Lerp(RightShoulder.C0, cf(1.5, 0.5, 0) * angles(0, 0, 0.4363323129985824) * RIGHTSHOULDERC0, 1 / Animation_Speed)
						LeftShoulder.C0 = Lerp(LeftShoulder.C0, cf(-1.5, 0.5, 0) * angles(0, 0, -0.4363323129985824) * LEFTSHOULDERC0, 1 / Animation_Speed)
						RightHip.C0 = Lerp(RightHip.C0, cf(1, -1 - 0.05 * cos(sine / 12), -0.01) * angles(0, 1.4486232791552935, 0), 1 / Animation_Speed)
						LeftHip.C0 = Lerp(LeftHip.C0, cf(-1, -1 - 0.05 * cos(sine / 12), -0.01) * angles(0, -1.4486232791552935, 0), 1 / Animation_Speed)
					end
					twait(0.15)
					idleOverwrite=function()
						local sine = sine * 40
						local Animation_Speed = 0.45 / deltaTime
						RootJoint.C1 = Lerp(RootJoint.C1,ROOTC0, 0.2 / Animation_Speed)
						Neck.C1 = Lerp(Neck.C1,cfMul(cf(0, -0.5, 0),angles(-1.5707963267948966, 0, 3.141592653589793)), 0.2 / Animation_Speed)
						RightHip.C1 = Lerp(RightHip.C1,cfMul(cf(0.5, 1, 0),angles(0, 1.5707963267948966, 0)), 0.7 / Animation_Speed)
						LeftHip.C1 = Lerp(LeftHip.C1,cfMul(cf(-0.5, 1, 0),angles(0, -1.5707963267948966, 0)), 0.7 / Animation_Speed)
		
						RootJoint.C0 = Lerp(RootJoint.C0,ROOTC0 * cf(0, 0, 0.05 * cos(sine / 12)), 1 / Animation_Speed)
						Neck.C0 = Lerp(Neck.C0, NECKC0 * angles(0.08726646259971647, 0, 0), 1 / Animation_Speed)
						RightShoulder.C0 = Lerp(RightShoulder.C0, cf(1.25, 0.5, -0.5) * angles(1.7453292519943295, 0, -1.2217304763960306) * RIGHTSHOULDERC0, 1 / Animation_Speed)
						LeftShoulder.C0 = Lerp(LeftShoulder.C0, cf(-1.25, 0.35, -0.35) * angles(1.2217304763960306, 0, 1.3962634015954636) * LEFTSHOULDERC0, 1 / Animation_Speed)
						RightHip.C0 = Lerp(RightHip.C0, cf(1, -1 - 0.05 * cos(sine / 12), -0.01) * angles(0, 1.4486232791552935, 0), 1 / Animation_Speed)
						LeftHip.C0 = Lerp(LeftHip.C0, cf(-1, -1 - 0.05 * cos(sine / 12), -0.01) * angles(0, -1.4486232791552935, 0), 1 / Animation_Speed)
					end
					twait(0.5)
					--CreateSound(363808674, Torso, 6, 1, false)
					idleOverwrite=function()
						local sine = sine * 40
						local Animation_Speed = 0.45 / deltaTime
						RootJoint.C1 = Lerp(RootJoint.C1,ROOTC0, 0.2 / Animation_Speed)
						Neck.C1 = Lerp(Neck.C1,cfMul(cf(0, -0.5, 0),angles(-1.5707963267948966, 0, 3.141592653589793)), 0.2 / Animation_Speed)
						RightHip.C1 = Lerp(RightHip.C1,cfMul(cf(0.5, 1, 0),angles(0, 1.5707963267948966, 0)), 0.7 / Animation_Speed)
						LeftHip.C1 = Lerp(LeftHip.C1,cfMul(cf(-0.5, 1, 0),angles(0, -1.5707963267948966, 0)), 0.7 / Animation_Speed)
		
						RootJoint.C0 = Lerp(RootJoint.C0,ROOTC0 * cf(0, 0, 0.05 * cos(sine / 12)), 1 / Animation_Speed)
						Neck.C0 = Lerp(Neck.C0, NECKC0 * angles(0.08726646259971647, 0.4363323129985824, 0), 1 / Animation_Speed)
						RightShoulder.C0 = Lerp(RightShoulder.C0, cf(1.25, 0.5, -0.5) * angles(1.7453292519943295, 0, -0.8726646259971648) * RIGHTSHOULDERC0, 1 / Animation_Speed)
						LeftShoulder.C0 = Lerp(LeftShoulder.C0, cf(-1.25, 0.35, -0.35) * angles(1.2217304763960306, 0, 1.0471975511965976) * LEFTSHOULDERC0, 1 / Animation_Speed)
						RightHip.C0 = Lerp(RightHip.C0, cf(1, -1 - 0.05 * cos(sine / 12), -0.01) * angles(0, 1.4486232791552935, 0), 1 / Animation_Speed)
						LeftHip.C0 = Lerp(LeftHip.C0, cf(-1, -1 - 0.05 * cos(sine / 12), -0.01) * angles(0, -1.4486232791552935, 0), 1 / Animation_Speed)
					end
					twait(0.3)
					--CreateSound(363808674, Torso, 6, 1, false)
					idleOverwrite=function()
						local sine = sine * 40
						local Animation_Speed = 0.45 / deltaTime
						RootJoint.C1 = Lerp(RootJoint.C1,ROOTC0, 0.2 / Animation_Speed)
						Neck.C1 = Lerp(Neck.C1,cfMul(cf(0, -0.5, 0),angles(-1.5707963267948966, 0, 3.141592653589793)), 0.2 / Animation_Speed)
						RightHip.C1 = Lerp(RightHip.C1,cfMul(cf(0.5, 1, 0),angles(0, 1.5707963267948966, 0)), 0.7 / Animation_Speed)
						LeftHip.C1 = Lerp(LeftHip.C1,cfMul(cf(-0.5, 1, 0),angles(0, -1.5707963267948966, 0)), 0.7 / Animation_Speed)
		
						RootJoint.C0 = Lerp(RootJoint.C0,ROOTC0 * cf(0, 0, 0.05 * cos(sine / 12)), 1 / Animation_Speed)
						Neck.C0 = Lerp(Neck.C0, NECKC0 * angles(0.08726646259971647, -0.4363323129985824, 0), 1 / Animation_Speed)
						RightShoulder.C0 = Lerp(RightShoulder.C0, cf(1.25, 0.5, -0.5) * angles(1.7453292519943295, 0, -1.5707963267948966) * RIGHTSHOULDERC0, 1 / Animation_Speed)
						LeftShoulder.C0 = Lerp(LeftShoulder.C0, cf(-1.25, 0.35, -0.35) * angles(1.2217304763960306, 0, 1.5707963267948966) * LEFTSHOULDERC0, 1 / Animation_Speed)
						RightHip.C0 = Lerp(RightHip.C0, cf(1, -1 - 0.05 * cos(sine / 12), -0.01) * angles(0, 1.4486232791552935, 0), 1 / Animation_Speed)
						LeftHip.C0 = Lerp(LeftHip.C0, cf(-1, -1 - 0.05 * cos(sine / 12), -0.01) * angles(0, -1.4486232791552935, 0), 1 / Animation_Speed)
					end
					twait(0.3)
					idleOverwrite=nil
					setWalkSpeed(20)
					setJumpPower(50)
				end,
				idle = function()
					if idleOverwrite then 
						return idleOverwrite()
					end
		
					local Animation_Speed = 0.45 / deltaTime
					local sine = sine * 40
		
					RootJoint.C1 = Lerp(RootJoint.C1,ROOTC0, 0.2 / Animation_Speed)
					Neck.C1 = Lerp(Neck.C1,cfMul(cf(0, -0.5, 0),angles(-1.5707963267948966, 0, 3.141592653589793)), 0.2 / Animation_Speed)
					RightHip.C1 = Lerp(RightHip.C1,cfMul(cf(0.5, 1, 0),angles(0, 1.5707963267948966, 0)), 0.7 / Animation_Speed)
					LeftHip.C1 = Lerp(LeftHip.C1,cfMul(cf(-0.5, 1, 0),angles(0, -1.5707963267948966, 0)), 0.7 / Animation_Speed)
		
					RootJoint.C0 = Lerp(RootJoint.C0,cfMul(ROOTC0, cf(0.05 * cos(sine / 12), 0, 0.05 * sin(sine / 12))), 0.15 / Animation_Speed)
					Neck.C0 = Lerp(Neck.C0,cfMul(NECKC0, angles(rad(15 - 2.5 * sin(sine / 12)), 0, -0.4363323129985824)), 1 / Animation_Speed)
					RightShoulder.C0 = Lerp(RightShoulder.C0,cfMul(cfMul(cf(1.25, 0.5, 0.3),angles(-0.7853981633974483, 0, -0.7853981633974483)), RIGHTSHOULDERC0), 1 / Animation_Speed)
					LeftShoulder.C0 = Lerp(LeftShoulder.C0,cfMul(cfMul(cf(-1.25, 0.5, 0.3),angles(-0.6981317007977318, 0, 0.7853981633974483)), LEFTSHOULDERC0), 1 / Animation_Speed)
					RightHip.C0 = Lerp(RightHip.C0,cfMul(cfMul(cf(1 + 0.05 * cos(sine / 12), -1 - 0.05 * sin(sine / 12), -0.01),angles(0, 1.4835298641951802, 0)),angles(-0.017453292519943295, 0, 0)), 0.15 / Animation_Speed)
					LeftHip.C0 = Lerp(LeftHip.C0,cfMul(cfMul(cf(-1 + 0.05 * cos(sine / 12), -1 - 0.05 * sin(sine / 12), -0.01),angles(0, -1.4835298641951802, 0)),angles(-0.017453292519943295, 0, 0)), 0.15 / Animation_Speed)
				end,
				walk = function()
					local Animation_Speed = 0.45 / deltaTime
					local sine = sine * 40
					RootJoint.C1 = Lerp(RootJoint.C1,cfMul(ROOTC0, cf(0, 0, 0.05 * cos(sine / (2.4)))), 2 * 1.25 / Animation_Speed)
					Neck.C1 = Lerp(Neck.C1,cfMul(cf(0, -0.5, 0),angles(-1.5707963267948966, 0, 3.141592653589793)), 0.2 * 1.25 / Animation_Speed)
					RightHip.C1 = Lerp(RightHip.C1,cfMul(cfMul(cf(0.5, 0.875 - 0.125 * sin(sine / 4.8) - 0.15 * cos(sine / 2.4), 0),angles(0, 1.5707963267948966, 0)),angles(0, 0, rad(35 * cos(sine / 4.8)))), 0.6 / Animation_Speed)
					LeftHip.C1 = Lerp(LeftHip.C1,cfMul(cfMul(cf(-0.5, 0.875 + 0.125 * sin(sine / 4.8) - 0.15 * cos(sine / 2.4), 0),angles(0, -1.5707963267948966, 0)),angles(0, 0, rad(35 * cos(sine / 4.8)))), 0.6 / Animation_Speed)
		
					RootJoint.C0 = Lerp(RootJoint.C0,cfMul(ROOTC0, cf(0, 0, -0.05)), 0.15 / Animation_Speed)
					Neck.C0 = Lerp(Neck.C0,cfMul(NECKC0,angles(0.08726646259971647, 0, 0)), 0.15 / Animation_Speed)
					RightShoulder.C0 = Lerp(RightShoulder.C0,cfMul(cfMul(cf(1.25, 0.5 + 0.05 * sin(sine / (2.4)), 0.3),angles(-0.7853981633974483, 0, -0.7853981633974483)), RIGHTSHOULDERC0), 1 / Animation_Speed)
					LeftShoulder.C0 = Lerp(LeftShoulder.C0,cfMul(cfMul(cf(-1.25, 0.5 + 0.05 * sin(sine / (2.4)), 0.3),angles(-0.6981317007977318, 0, 0.7853981633974483)), LEFTSHOULDERC0), 1 / Animation_Speed)
					RightHip.C0 = Lerp(RightHip.C0,cfMul(cfMul(cf(1, -1, 0),angles(0, 1.3962634015954636, 0)),angles(0, 0, -0.08726646259971647)), 2 / Animation_Speed)
					LeftHip.C0 = Lerp(LeftHip.C0,cfMul(cfMul(cf(-1, -1, 0),angles(0, -1.3962634015954636, 0)),angles(0, 0, 0.08726646259971647)), 2 / Animation_Speed)
				end,
				jump = jumplerps,
				fall = falllerps
			})
		
			addmode("f",{ --mode 0
				modeLeft=function() --enter mode 1
					setWalkSpeed(0)
					setJumpPower(0)
					--CreateSound(147722227, Torso, 4, 1.3, false)
					idleOverwrite=function()
						local sine = sine * 40
						local Animation_Speed = 0.45 / deltaTime
						RootJoint.C1 = Lerp(RootJoint.C1,ROOTC0, 0.2 / Animation_Speed)
						Neck.C1 = Lerp(Neck.C1,cfMul(cf(0, -0.5, 0),angles(-1.5707963267948966, 0, 3.141592653589793)), 0.2 / Animation_Speed)
						RightHip.C1 = Lerp(RightHip.C1,cfMul(cf(0.5, 1, 0),angles(0, 1.5707963267948966, 0)), 0.7 / Animation_Speed)
						LeftHip.C1 = Lerp(LeftHip.C1,cfMul(cf(-0.5, 1, 0),angles(0, -1.5707963267948966, 0)), 0.7 / Animation_Speed)
		
						RootJoint.C0 = Lerp(RootJoint.C0,ROOTC0 * cf(0, 0, 0.05 * cos(sine / 12)), 1 / Animation_Speed)
						Neck.C0 = Lerp(Neck.C0, NECKC0 * angles(0.6108652381980153, 0, 0), 1 / Animation_Speed)
						RightShoulder.C0 = Lerp(RightShoulder.C0, cf(1.5, 0.5, 0) * angles(0, 0, 0.4363323129985824) * RIGHTSHOULDERC0, 1 / Animation_Speed)
						LeftShoulder.C0 = Lerp(LeftShoulder.C0, cf(-1.5, 0.5, 0) * angles(0, 0, -0.4363323129985824) * LEFTSHOULDERC0, 1 / Animation_Speed)
						RightHip.C0 = Lerp(RightHip.C0, cf(1, -1 - 0.05 * cos(sine / 12), -0.01) * angles(0, 1.4486232791552935, 0), 1 / Animation_Speed)
						LeftHip.C0 = Lerp(LeftHip.C0, cf(-1, -1 - 0.05 * cos(sine / 12), -0.01) * angles(0, -1.4486232791552935, 0), 1 / Animation_Speed)
					end
					twait(0.15)
					idleOverwrite=nil
					setWalkSpeed(20)
					setJumpPower(50)
				end,
				idle = function()
					if idleOverwrite then 
						return idleOverwrite()
					end
		
					local Animation_Speed = 0.45 / deltaTime
					local sine = sine * 40
		
					RootJoint.C1 = Lerp(RootJoint.C1,ROOTC0, 0.2 / Animation_Speed)
					Neck.C1 = Lerp(Neck.C1,cfMul(cf(0, -0.5, 0),angles(-1.5707963267948966, 0, 3.141592653589793)), 0.2 / Animation_Speed)
					RightHip.C1 = Lerp(RightHip.C1,cfMul(cf(0.5, 1, 0),angles(0, 1.5707963267948966, 0)), 0.7 / Animation_Speed)
					LeftHip.C1 = Lerp(LeftHip.C1,cfMul(cf(-0.5, 1, 0),angles(0, -1.5707963267948966, 0)), 0.7 / Animation_Speed)
		
					RootJoint.C0 = Lerp(RootJoint.C0,cfMul(ROOTC0, cf(0, 0, 0.05 * cos(sine / 12))), 1 / Animation_Speed)
					Neck.C0 = Lerp(Neck.C0,cfMul(NECKC0,angles(rad(-5 - 2.5 * cos(sine / 12)), 0, 0.4363323129985824)), 1 / Animation_Speed)
					RightShoulder.C0 = Lerp(RightShoulder.C0,cfMul(cfMul(cf(0.9, 0.5 + 0.05 * sin(sine / 12), -0.5),angles(1.7453292519943295, 0, -1.2217304763960306)), RIGHTSHOULDERC0), 1 / Animation_Speed)
					LeftShoulder.C0 = Lerp(LeftShoulder.C0,cfMul(cfMul(cf(-0.9, 0.25 + 0.05 * sin(sine / 12), -0.35),angles(1.2217304763960306, 0, 1.3962634015954636)), LEFTSHOULDERC0), 1 / Animation_Speed)
					RightHip.C0 = Lerp(RightHip.C0,cfMul(cf(1, -1 - 0.05 * cos(sine / 12), -0.01),angles(0, 1.3962634015954636, 0)), 1 / Animation_Speed)
					LeftHip.C0 = Lerp(LeftHip.C0,cfMul(cf(-1, -1 - 0.05 * cos(sine / 12), -0.01),angles(0, -1.3962634015954636, 0)), 1 / Animation_Speed)
				end,
				walk = function()
					local Animation_Speed = 0.45 / deltaTime
					local sine = sine * 40
					RootJoint.C1 = Lerp(RootJoint.C1,cfMul(ROOTC0, cf(0, 0, 0.05 * cos(sine / (2.4)))), 2 * 1.25 / Animation_Speed)
					Neck.C1 = Lerp(Neck.C1,cfMul(cf(0, -0.5, 0),angles(-1.5707963267948966, 0, 3.141592653589793)), 0.2 * 1.25 / Animation_Speed)
					RightHip.C1 = Lerp(RightHip.C1,cfMul(cfMul(cf(0.5, 0.875 - 0.125 * sin(sine / 4.8) - 0.15 * cos(sine / 2.4), 0),angles(0, 1.5707963267948966, 0)),angles(0, 0, rad(35 * cos(sine / 4.8)))), 0.6 / Animation_Speed)
					LeftHip.C1 = Lerp(LeftHip.C1,cfMul(cfMul(cf(-0.5, 0.875 + 0.125 * sin(sine / 4.8) - 0.15 * cos(sine / 2.4), 0),angles(0, -1.5707963267948966, 0)),angles(0, 0, rad(35 * cos(sine / 4.8)))), 0.6 / Animation_Speed)
		
					RootJoint.C0 = Lerp(RootJoint.C0,cfMul(ROOTC0, cf(0, 0, -0.05)), 0.15 / Animation_Speed)
					Neck.C0 = Lerp(Neck.C0,cfMul(NECKC0,angles(0.08726646259971647, 0, 0)), 0.15 / Animation_Speed)
					RightShoulder.C0 = Lerp(RightShoulder.C0,cfMul(cfMul(cf(0.9, 0.5 + 0.05 * sin(sine / (2.4)), -0.5),angles(1.7453292519943295, 0, -1.2217304763960306)), RIGHTSHOULDERC0), 1 / Animation_Speed)
					LeftShoulder.C0 = Lerp(LeftShoulder.C0,cfMul(cfMul(cf(-0.9, 0.25 + 0.05 * sin(sine / (2.4)), -0.35),angles(1.2217304763960306, 0, 1.3962634015954636)), LEFTSHOULDERC0), 1 / Animation_Speed)
					RightHip.C0 = Lerp(RightHip.C0,cfMul(cfMul(cf(1, -1, 0),angles(0, 1.3962634015954636, 0)),angles(0, 0, -0.08726646259971647)), 2 / Animation_Speed)
					LeftHip.C0 = Lerp(LeftHip.C0,cfMul(cfMul(cf(-1, -1, 0),angles(0, -1.3962634015954636, 0)),angles(0, 0, 0.08726646259971647)), 2 / Animation_Speed)
				end,
				jump = jumplerps,
				fall = falllerps
			})
		end,
		function(t)
			local addmode=t.addmode
			local getJoint=t.getJoint
			local velbycfrvec=t.velbycfrvec
			local RootJoint=getJoint("RootJoint")
			local RightShoulder=getJoint("Right Shoulder")
			local LeftShoulder=getJoint("Left Shoulder")
			local RightHip=getJoint("Right Hip")
			local LeftHip=getJoint("Left Hip")
			local Neck=getJoint("Neck")
			t.setWalkSpeed(4.5)
		
			addmode("default",{
				idle=function()
					Neck.C0=Lerp(Neck.C0,cfMul(cf(0,1,0),angles(-1.7453292519943295-0.08726646259971647*sin(sine*8),-0.12217304763960307*sin((sine+0.2)*4),2.8797932657906435+0.2007128639793479*sin((sine+0.15)*4))),deltaTime) 
					RightHip.C0=Lerp(RightHip.C0,cfMul(cf(1,-1+0.1*sin(sine*4),0),angles(1.5707963267948966,1.5707963267948966+0.17453292519943295*sin(sine*4),-1.5707963267948966)),deltaTime) 
					RightShoulder.C0=Lerp(RightShoulder.C0,cfMul(cf(1,0.3,0),angles(2.530727415391778+0.20943951023931956*sin((sine+0.4)*8),1.5707963267948966-0.4363323129985824*sin((sine+0.2)*4),-1.5707963267948966)),deltaTime) 
					LeftShoulder.C0=Lerp(LeftShoulder.C0,cfMul(cf(-1,0.5,0),angles(1.0471975511965976,-1.2217304763960306+0.08726646259971647*sin((sine+0.2)*4),1.5707963267948966)),deltaTime) 
					LeftHip.C0=Lerp(LeftHip.C0,cfMul(cf(-1,-1-0.1*sin(sine*4),0),angles(1.5707963267948966,-1.5707963267948966+0.17453292519943295*sin(sine*4),1.5707963267948966)),deltaTime) 
					RootJoint.C0=Lerp(RootJoint.C0,cfMul(cf(-0.1 * sin(sine*4),0,0),angles(-1.5707963267948966,0.08726646259971647*sin(sine*4),3.141592653589793)),deltaTime) 
					--MW_animatorProgressSave: Fedora_Handle,8.657480066176504e-09,0,0,4,-6,0,0,4,-0.15052366256713867,0,0,4,0,0,0,4,-0.010221302509307861,0,0,4,0,0,0,4,Bandana_Handle,3.9362930692732334e-09,0,0,4,0,0,0,4,0.3000001907348633,0,0,4,0,0,0,4,-0.6002722978591919,0,0,4,0,0,0,4,Head,0,0,0,4,-100,-5,0,8,1,0,0,4,-0,-7,0.2,4,0,0,0,4,165,11.5,0.15,4,RightLeg,1,0,0,4,90,0,0,4,-1,0.1,0,4,90,10,0,4,0,0,0,4,-90,0,0,4,RightArm,1,0,0,4,145,12,0.4,8,0.3,0,0,4,90,-25,0.2,4,0,0,0,4,-90,0,0,4,LeftArm,-1,0,0,4,60,0,0,4,0.5,0,0,4,-70,5,0.2,4,0,0,0,4,90,0,0,4,LeftLeg,-1,0,0,4,90,0,0,4,-1,-0.1,0,4,-90,10,0,4,0,0,0,4,90,0,0,4,Torso,0,-0.1,0,4,-90,0,0,4,0,0,0,4,-0,5,0,4,0,0,0,4,180,0,0,4
				end,
				walk=function()
					local fw,rt=velbycfrvec()
		
					Neck.C0=Lerp(Neck.C0,cfMul(cf(0,1,0),angles(-1.5707963267948966+0.08726646259971647*sin((sine-0.1)*8),0.3490658503988659*sin((sine-0.07)*4),3.141592653589793-0.4363323129985824*sin((sine-0.4)*4))),deltaTime) 
					RightHip.C0=Lerp(RightHip.C0,cfMul(cf(1,-1+0.3*sin((sine + 0.3)*4),0),angles(1.5707963267948966,1.5707963267948966+0.6981317007977318*sin(sine*4)*rt,-1.5707963267948966+0.6981317007977318*sin(sine*4)*fw)),deltaTime) 
					RightShoulder.C0=Lerp(RightShoulder.C0,cfMul(cf(1,0.5,0),angles(-0.5235987755982988*sin((sine+0.2)*4),1.5707963267948966-0.3490658503988659*sin(sine*4),0)),deltaTime) 
					LeftShoulder.C0=Lerp(LeftShoulder.C0,cfMul(cf(-1,0.5,0),angles(0.5235987755982988*sin((sine+0.2)*4),-1.5707963267948966-0.3490658503988659*sin(sine*4),0)),deltaTime) 
					LeftHip.C0=Lerp(LeftHip.C0,cfMul(cf(-1,-1-0.3*sin((sine + 0.3)*4),0),angles(1.5707963267948966,-1.5707963267948966-0.6981317007977318*sin(sine*4)*rt,1.5707963267948966+0.6981317007977318*sin(sine*4)*fw)),deltaTime) 
					RootJoint.C0=Lerp(RootJoint.C0,cfMul(cf(0,0.05+0.2*sin((sine + 0.15)*8),0),angles(-1.5707963267948966,0,3.141592653589793)),deltaTime) 
					--MW_animatorProgressSave: Fedora_Handle,8.657480066176504e-09,0,0,4,-6,0,0,4,-0.15052366256713867,0,0,4,0,0,0,4,-0.010221302509307861,0,0,4,0,0,0,4,Bandana_Handle,3.9362930692732334e-09,0,0,4,0,0,0,4,0.3000001907348633,0,0,4,0,0,0,4,-0.6002722978591919,0,0,4,0,0,0,4,Head,0,0,0,4,-90,5,-0.1,8,1,0,0,4,-0,20,-0.07,4,0,0,0,4,180,-25,-0.4,4,RightLeg,1,0,0,4,90,0,0,4,-1,0.3,0.3,4,90,40,0,4,0,0,0,4,-90,40,0,4,RightArm,1,0,0,4,0,-30,0.2,4,0.5,0,0,4,90,-20,0,4,0,0,0,4,0,0,0,4,LeftArm,-1,0,0,4,0,30,0.2,4,0.5,0,0,4,-90,-20,0,4,0,0,0,4,0,0,0,4,LeftLeg,-1,0,0,4,90,0,0,4,-1,-0.3,0.3,4,-90,-40,0,4,0,0,0,4,90,40,0,4,Torso,0,0,0,4,-90,0,0,4,0.05,0.2,0.15,8,-0,0,0,4,0,0,0,4,180,0,0,4
				end
			})
		end,
		function(t)
			local getJoint=t.getJoint
			local map = {
				RootJoint=getJoint("RootJoint"),
				RightShoulder=getJoint("Right Shoulder"),
				LeftShoulder=getJoint("Left Shoulder"),
				RightHip=getJoint("Right Hip"),
				LeftHip=getJoint("Left Hip"),
				Neck=getJoint("Neck"),
			}
			local function apply(n, j)
				local function a(t)
					return t[1] + t[2] * math.sin((sine * animatorcfg.change + t[4]) * t[3])
				end
				local t = animatorcfg[n]
				j.C0 = Lerp(cfMul(cf(a(t.x), a(t.y), a(t.z)), angles(math.rad(a(t.rx)), math.rad(a(t.ry)), math.rad(a(t.rz)))), j.C0, math.exp(-animatorcfg.speed * deltaTime))
			end
			t.addmode("default", {
				idle=function()
					for k,v in map do apply(k, v) end
				end,
			})
		end,
	}

	m.AnimIndex = 1
	m.Config = function(parent: GuiBase2d)
		local btn = function(txt, f)
			local i1 = Instance.new("TextLabel") 
			local i2 = Instance.new("TextButton")
			i1.BackgroundTransparency = 1
			i1.Font = Enum.Font.SourceSans
			i1.TextSize = 18
			i1.Text = txt
			i1.Position = UDim2.new(0, 0, 0, 0)
			i1.Size = UDim2.new(1, 0, 1, 0)
			i1.TextColor3 = Color3.new(0.0941177, 0.317647, 0.878431)
			i1.Name = RandomString()
			i1.Parent = i2
			i2.BackgroundTransparency = 1
			i2.TextTransparency = 1
			i2.Size = UDim2.new(1, 0, 0, 18)
			i2.LayoutOrder = 67
			i2.Name = RandomString()
			if f then
				i2.MouseButton1Click:Connect(f)
			end
			i2.Parent = parent
			return i1, i2
		end
		local lbl = function(txt)
			local i1 = Instance.new("TextLabel") 
			local i2 = Instance.new("Frame")
			i1.BackgroundTransparency = 1
			i1.Font = Enum.Font.SourceSans
			i1.TextSize = 18
			i1.Text = txt
			i1.Position = UDim2.new(0, 0, 0, 0)
			i1.Size = UDim2.new(1, 0, 1, 0)
			i1.TextColor3 = Color3.new(0.560784, 0.560784, 0.560784)
			i1.Name = RandomString()
			i1.Parent = i2
			i2.BackgroundTransparency = 1
			i2.Size = UDim2.new(1, 0, 0, 18)
			i2.Name = RandomString()
			i2.LayoutOrder = 67
			i2.Parent = parent
			return i1, i2
		end
		local lbls = {}
		local update = function()
			for i=1, #lbls do
				if i == m.AnimIndex then
					lbls[i][2].Text = lbls[i][1] .. " (ACTIVE)"
				else
					lbls[i][2].Text = lbls[i][1]
				end
			end
		end
		local animsel = function(txt)
			local idx = #lbls + 1
			table.insert(lbls, {txt, btn(txt, function()
				m.AnimIndex = idx
				update()
			end)})
			update()
		end
		btn("patchma hub lite")
		lbl("real patchma hub by MyWorld")
		lbl("their discord: discord.gg/QMy5f6DrbH")
		lbl("ported to Uhhhhhh by STEVETHEREALONE")
		animsel("creepy crawler")
		animsel("nameless animations V8")
		lbl("^ my personal favorite right here ^")
		animsel("nameless animations V7")
		animsel("nameless animations V6")
		lbl("Immortality Lord is already added as")
		lbl("a moveset, as well as Lightning Cannon")
		lbl("why not use those if ur lookin for em?")
		animsel("goofy trolus (goofy)")
		animsel("good cop bad cop animations")
		lbl("original by shackluster")
		lbl("the classics never die")
		animsel("metamorphosis vibe")
		lbl("INTERWORLD - METAMORPHOSIS")
		lbl("was listening to ^^ and animating")
		animsel("empty reanimate (no animations)")
		lbl("print(\"optimise the optimised\")")
		lbl("")
		lbl("hey myworld if u see this can u")
		lbl("shoot me a pm for whatever quote")
		lbl("u wanna add here? idk i just think")
		lbl("u got some ideas/wanna add stuff here")
		lbl("")
		lbl("vv use empty reanimate vv")
		local animatorbtn = nil
		_, animatorbtn = btn("open MW animator lite", function()
			animatorbtn:Destroy()
			local mmhm = nil
			local update = {}
			local sig = function(x)
				x = tostring(x):lower()
				local exp = x:split("e")
				x = exp[1]
				local dec = x:split(".")
				if #dec > 1 then
					x = dec[1]
					dec = dec[2]:sub(1, 3)
					while dec:sub(-1, -1) == "0" do
						dec = dec:sub(1, -2)
					end
					if #dec > 0 then
						x ..= "." .. dec
					end
				end
				if #exp > 1 then
					x ..= "e" .. exp[2]
				end
				return x
			end
			local lmao = function(k, t, i)
				if mmhm == "mmhm" then
					k.Text = sig(t[i])
					return
				end
				if #k.Text > 0 then
					t[i] = tonumber(k.Text) or t[i]
				end
				if k:IsFocused() then return end
				k.Text = sig(t[i])
			end
			local prop = function(txt, a, b)
				local fr = Instance.new("Frame")
				fr.BackgroundTransparency = 1
				fr.Size = UDim2.new(1, 0, 0, 18)
				fr.Name = RandomString()
				fr.LayoutOrder = 67
				fr.Parent = parent
				local lol = function(cl, x, txt)
					local i1 = Instance.new(cl)
					i1.BackgroundTransparency = 1
					i1.Font = Enum.Font.SourceSans
					i1.TextSize = 18
					i1.Text = txt
					i1.AnchorPoint = Vector2.new(0.5, 0)
					i1.Position = UDim2.new(0.5, x, 0, 0)
					i1.Size = UDim2.new(0, 45, 1, 0)
					i1.TextColor3 = Color3.new(0.560784, 0.560784, 0.560784)
					i1.Name = RandomString()
					i1.Parent = fr
					return i1
				end
				local i1 = lol("TextLabel", -100, txt)
				i1.TextXAlignment = "Right"
				local val = lol("TextBox", -50, "")
				val.PlaceholderText = "0"
				val.ClearTextOnFocus = false
				val.PlaceholderColor3 = Color3.new(0.2, 0.2, 0.2)
				local sval = lol("TextBox", 0, "")
				sval.PlaceholderText = "0"
				sval.ClearTextOnFocus = false
				sval.PlaceholderColor3 = Color3.new(0.2, 0.2, 0.2)
				local smul = lol("TextBox", 50, "")
				smul.PlaceholderText = "0"
				smul.ClearTextOnFocus = false
				smul.PlaceholderColor3 = Color3.new(0.2, 0.2, 0.2)
				local soff = lol("TextBox", 100, "")
				soff.PlaceholderText = "0"
				soff.ClearTextOnFocus = false
				soff.PlaceholderColor3 = Color3.new(0.2, 0.2, 0.2)
				local this = function()
					local t = animatorcfg[a][b]
					lmao(val, t, 1)
					lmao(sval, t, 2)
					lmao(smul, t, 3)
					lmao(soff, t, 4)
				end
				this()
				val:GetPropertyChangedSignal("Text"):Connect(this)
				sval:GetPropertyChangedSignal("Text"):Connect(this)
				smul:GetPropertyChangedSignal("Text"):Connect(this)
				soff:GetPropertyChangedSignal("Text"):Connect(this)
				val.FocusLost:Connect(this)
				sval.FocusLost:Connect(this)
				smul.FocusLost:Connect(this)
				soff.FocusLost:Connect(this)
				table.insert(update, this)
			end
			local prop1 = function(txt, a)
				local fr = Instance.new("Frame")
				fr.BackgroundTransparency = 1
				fr.Size = UDim2.new(1, 0, 0, 18)
				fr.Name = RandomString()
				fr.LayoutOrder = 67
				fr.Parent = parent
				local lol = function(cl, x, txt)
					local i1 = Instance.new(cl)
					i1.BackgroundTransparency = 1
					i1.Font = Enum.Font.SourceSans
					i1.TextSize = 18
					i1.Text = txt
					i1.AnchorPoint = Vector2.new(0.5, 0)
					i1.Position = UDim2.new(0.5, x, 0, 0)
					i1.Size = UDim2.new(0, 45, 1, 0)
					i1.TextColor3 = Color3.new(0.560784, 0.560784, 0.560784)
					i1.Name = RandomString()
					i1.Parent = fr
					return i1
				end
				local i1 = lol("TextLabel", -25, txt)
				i1.TextXAlignment = "Right"
				local val = lol("TextBox", 25, "")
				val.PlaceholderText = "0"
				val.ClearTextOnFocus = false
				local this = function()
					if mmhm == "mmhm" then
						val.Text = sig(animatorcfg[a])
						return
					end
					if #val.Text > 0 then
						animatorcfg[a] = tonumber(val.Text) or animatorcfg[a]
					end
					if val:IsFocused() then return end
					val.Text = sig(animatorcfg[a])
				end
				this()
				val:GetPropertyChangedSignal("Text"):Connect(this)
				val.FocusLost:Connect(this)
				table.insert(update, this)
			end
			local txtbox = function(txt, ptxt, func)
				local fr = Instance.new("Frame")
				fr.BackgroundTransparency = 1
				fr.Size = UDim2.new(1, 0, 0, 18)
				fr.Name = RandomString()
				fr.LayoutOrder = 67
				fr.Parent = parent
				local lol = function(cl, x, txt)
					local i1 = Instance.new(cl)
					i1.BackgroundTransparency = 1
					i1.Font = Enum.Font.SourceSans
					i1.TextSize = 18
					i1.Text = txt
					i1.AnchorPoint = Vector2.new(0.5, 0)
					i1.Position = UDim2.new(0.5, x, 0, 0)
					i1.Size = UDim2.new(0, 45, 1, 0)
					i1.TextColor3 = Color3.new(0.560784, 0.560784, 0.560784)
					i1.Name = RandomString()
					i1.Parent = fr
					return i1
				end
				local i1 = lol("TextLabel", -100, txt)
				i1.TextXAlignment = "Right"
				local val = lol("TextBox", 12, "")
				val.PlaceholderText = ptxt
				val.Size = UDim2.new(0, 195, 1, 0)
				val:GetPropertyChangedSignal("Text"):Connect(function()
					func(val.Text)
				end)
			end
			btn("x1/2 speed", function()
				for _,k in {"RootJoint", "Neck", "RightShoulder", "LeftShoulder", "RightHip", "LeftHip"} do
					local v = animatorcfg[k]
					for _,w in v do
						w[3] /= 2
						w[4] *= 2
					end
				end
				mmhm = "mmhm"
				for _,v in update do v() end
				mmhm = nil
			end)
			btn("x2 speed", function()
				for _,k in {"RootJoint", "Neck", "RightShoulder", "LeftShoulder", "RightHip", "LeftHip"} do
					local v = animatorcfg[k]
					for _,w in v do
						w[3] *= 2
						w[4] /= 2
					end
				end
				mmhm = "mmhm"
				for _,v in update do v() end
				mmhm = nil
			end)
			btn("reset animator", function()
				animatorreset()
				mmhm = "mmhm"
				for _,v in update do v() end
				mmhm = nil
			end)
			local prop2 = function(name, joint)
				prop(name .. " X", joint, "x")
				prop("Y", joint, "y")
				prop("Z", joint, "z")
				prop("Rot X", joint, "rx")
				prop("Rot Y", joint, "ry")
				prop("Rot Z", joint, "rz")
			end
			prop1("Lerp Speed", "speed")
			prop1("Time Change", "change")
			do
				local fr = Instance.new("Frame")
				fr.BackgroundTransparency = 1
				fr.Size = UDim2.new(1, 0, 0, 18)
				fr.Name = RandomString()
				fr.LayoutOrder = 67
				fr.Parent = parent
				local lol = function(x, txt)
					local i1 = Instance.new("TextLabel")
					i1.BackgroundTransparency = 1
					i1.Font = Enum.Font.SourceSans
					i1.TextSize = 18
					i1.Text = txt
					i1.AnchorPoint = Vector2.new(0.5, 0)
					i1.Position = UDim2.new(0.5, x, 0, 0)
					i1.Size = UDim2.new(0, 45, 1, 0)
					i1.TextColor3 = Color3.new(0.560784, 0.560784, 0.560784)
					i1.Name = RandomString()
					i1.Parent = fr
				end
				lol(-50, "value")
				lol(0, "sinval")
				lol(50, "sinspeed")
				lol(100, "sinoff")
			end
			prop2("Torso", "RootJoint")
			prop2("Head", "Neck")
			prop2("Left Arm", "LeftShoulder")
			prop2("Right Arm", "RightShoulder")
			prop2("Left Leg", "LeftHip")
			prop2("Right Leg", "RightHip")
			txtbox("Load Save", "name,0,0,1,0,7,6,4,5...", function(val)
				val = string.split(val, ",")
				local map = {
					Torso = "RootJoint",
					Head = "Neck",
					RightArm = "RightShoulder",
					LeftArm = "LeftShoulder",
					RightLeg = "RightHip",
					LeftLeg = "LeftHip",
				}
				local function getval()
					local lol = {
						tonumber(table.remove(val, 1)) or 0,
						tonumber(table.remove(val, 1)) or 0,
						tonumber(table.remove(val, 1)) or 0,
						tonumber(table.remove(val, 1)) or 1,
					}
					lol[4], lol[3] = lol[3], lol[4]
					return lol
				end
				while #val >= 25 do
					local n2 = table.remove(val, 1)
					if map[n2] then
						local t = animatorcfg[map[n2]]
						t.x = getval()
						t.rx = getval()
						t.y = getval()
						t.ry = getval()
						t.z = getval()
						t.rz = getval()
					else
						for _=1, 6 do getval() end
					end
				end
				mmhm = "mmhm"
				for _,v in update do v() end
				mmhm = nil
			end)
			btn("copy lerps to clipboard", function()
				local MW_animatorProgressSave = {}
				local function applyj(n, n2)
					local x = `{n}.C0=Lerp({n}.C0,`
					local t = animatorcfg[n]
					local zero = function(k)
						if t[k][1] == 0 then
							if t[k][3] == 0 then
								return true
							elseif t[k][2] == 0 then
								return true
							end
						end
						return false
					end
					local conv = function(k, mul)
						mul = mul or 1
						local t = t[k]
						if t[1] == 0 then
							if t[2] == 0 then
								return "0"
							else
								if t[3] == 0 then
									return "0"
								elseif t[3] == 1 then
									return sig(t[2] * mul) .. "*sin(sine+" .. sig(t[4] % (math.pi * 2)) .. ")"
								elseif t[3] == -1 then
									return sig(t[2] * mul) .. "*sin(" .. sig(-t[4] % (math.pi * 2)) .. "-sine)"
								else
									return sig(t[2] * mul) .. "*sin(sine*" .. sig(t[3]) .. "+" .. sig((t[4] * t[3]) % (math.pi * 2)) .. ")"
								end
							end
						else
							if t[2] == 0 then
								return "0"
							else
								if t[3] == 0 then
									return sig(t[1] * mul)
								elseif t[3] == 1 then
									return sig(t[1] * mul) .. "+" .. sig(t[2] * mul) .. "*sin(sine+" .. sig(t[4] % (math.pi * 2)) .. ")"
								elseif t[3] == -1 then
									return sig(t[1] * mul) .. "+" .. sig(t[2] * mul) .. "*sin(" .. sig(-t[4] % (math.pi * 2)) .. "-sine)"
								else
									return sig(t[1] * mul) .. "+" .. sig(t[2] * mul) .. "*sin(sine*" .. sig(t[3]) .. "+" .. sig((t[4] * t[3]) % (math.pi * 2)) .. ")"
								end
							end
						end
					end
					local conv2 = function(k)
						table.insert(MW_animatorProgressSave, sig(t[k][1]))
						table.insert(MW_animatorProgressSave, sig(t[k][2]))
						table.insert(MW_animatorProgressSave, sig(t[k][4]))
						table.insert(MW_animatorProgressSave, sig(t[k][3]))
					end
					if not (zero("x") and zero("y") and zero("z") and zero("rx") and zero("ry") and zero("rz")) then
						x ..= `cfMul(cf({conv("x")},{conv("y")},{conv("z")}),angles({conv("rx", math.pi / 180)},{conv("ry", math.pi / 180)},{conv("rz", math.pi / 180)}))`
					elseif not (zero("rx") and zero("ry") and zero("rz")) then
						x ..= `angles({conv("rx", math.pi / 180)},{conv("ry", math.pi / 180)},{conv("rz", math.pi / 180)})`
					elseif not (zero("x") and zero("y") and zero("z")) then
						x ..= `cf({conv("x")},{conv("y")},{conv("z")})`
					else
						x ..= `cf()`
					end
					x ..= ",deltaTime)"
					table.insert(MW_animatorProgressSave, n2)
					conv2("x") conv2("rx") conv2("y") conv2("ry") conv2("z") conv2("rz")
					return x
				end
				local codegen = ""
				codegen ..= applyj("RootJoint", "Torso") .. "\n"
				codegen ..= applyj("Neck", "Head") .. "\n"
				codegen ..= applyj("RightShoulder", "RightArm") .. "\n"
				codegen ..= applyj("LeftShoulder", "LeftArm") .. "\n"
				codegen ..= applyj("RightHip", "RightLeg") .. "\n"
				codegen ..= applyj("LeftHip", "LeftLeg") .. "\n"
				codegen ..= "--MW_animatorProgressSave: " .. table.concat(MW_animatorProgressSave, ",")
				setclipboard(codegen)
			end)
			btn("copy steve lerps to clipboard", function()
				local MW_animatorProgressSave = {}
				local function applyj(n, n2, n3)
					local x = `{n3} = `
					local t = animatorcfg[n]
					local zero = function(k)
						if t[k][1] == 0 then
							if t[k][3] == 0 then
								return true
							elseif t[k][2] == 0 then
								return true
							end
						end
						return false
					end
					local conv = function(k, mul)
						mul = mul or 1
						local t = t[k]
						if t[1] == 0 then
							if t[2] == 0 then
								return "0"
							else
								if t[3] == 0 then
									return "0"
								elseif t[3] == 1 then
									return sig(t[2] * mul) .. " * math.sin(timingsine + " .. sig(t[4] % (math.pi * 2)) .. ")"
								elseif t[3] == -1 then
									return sig(t[2] * mul) .. " * math.sin(" .. sig(-t[4] % (math.pi * 2)) .. " - timingsine)"
								else
									return sig(t[2] * mul) .. " * math.sin(timingsine * " .. sig(t[3]) .. " + " .. sig((t[4] * t[3]) % (math.pi * 2)) .. ")"
								end
							end
						else
							if t[2] == 0 then
								return "0"
							else
								if t[3] == 0 then
									return sig(t[1] * mul)
								elseif t[3] == 1 then
									return sig(t[1] * mul) .. " + " .. sig(t[2] * mul) .. " * math.sin(timingsine + " .. sig(t[4] % (math.pi * 2)) .. ")"
								elseif t[3] == -1 then
									return sig(t[1] * mul) .. " + " .. sig(t[2] * mul) .. " * math.sin(" .. sig(-t[4] % (math.pi * 2)) .. " - timingsine)"
								else
									return sig(t[1] * mul) .. " + " .. sig(t[2] * mul) .. " * math.sin(timingsine * " .. sig(t[3]) .. " + " .. sig((t[4] * t[3]) % (math.pi * 2)) .. ")"
								end
							end
						end
					end
					local conv2 = function(k)
						table.insert(MW_animatorProgressSave, sig(t[k][1]))
						table.insert(MW_animatorProgressSave, sig(t[k][2]))
						table.insert(MW_animatorProgressSave, sig(t[k][4]))
						table.insert(MW_animatorProgressSave, sig(t[k][3]))
					end
					if not (zero("x") and zero("y") and zero("z") and zero("rx") and zero("ry") and zero("rz")) then
						x ..= `CFrame.new({conv("x")},{conv("y")},{conv("z")}) * CFrame.fromEulerAnglesXYZ({conv("rx", math.pi / 180)},{conv("ry", math.pi / 180)},{conv("rz", math.pi / 180)}))`
					elseif not (zero("rx") and zero("ry") and zero("rz")) then
						x ..= `CFrame.fromEulerAnglesXYZ({conv("rx", math.pi / 180)},{conv("ry", math.pi / 180)},{conv("rz", math.pi / 180)})`
					elseif not (zero("x") and zero("y") and zero("z")) then
						x ..= `CFrame.new({conv("x")},{conv("y")},{conv("z")})`
					else
						x ..= `CFrame.identity`
					end
					table.insert(MW_animatorProgressSave, n2)
					conv2("x") conv2("rx") conv2("y") conv2("ry") conv2("z") conv2("rz")
					return x
				end
				local codegen = "animationOverride = function(timingsine, rt, nt, rst, lst, rht, lht)\n\t"
				codegen ..= applyj("RootJoint", "Torso", "rt") .. "\n\t"
				codegen ..= applyj("Neck", "Head", "nt") .. "\n\t"
				codegen ..= applyj("RightShoulder", "RightArm", "rst") .. "\n\t"
				codegen ..= applyj("LeftShoulder", "LeftArm", "lst") .. "\n\t"
				codegen ..= applyj("RightHip", "RightLeg", "rht") .. "\n\t"
				codegen ..= applyj("LeftHip", "LeftLeg", "lht") .. "\n\treturn rt, nt, rst, lst, rht, lht, " .. sig(animatorcfg.speed) .. "\nend\n"
				codegen ..= "--MW_animatorProgressSave: " .. table.concat(MW_animatorProgressSave, ",")
				setclipboard(codegen)
			end)
		end)
	end
	m.LoadConfig = function(save: any)
		m.AnimIndex = save.AnimIndex or m.AnimIndex
	end
	m.SaveConfig = function()
		return {
			AnimIndex = m.AnimIndex
		}
	end

	local rcp = RaycastParams.new()
	rcp.FilterType = Enum.RaycastFilterType.Exclude
	rcp.RespectCanCollide = true
	rcp.IgnoreWater = true
	local function PhysicsRaycast(origin, direction)
		return workspace:Raycast(origin, direction, rcp)
	end

	local buttonsui = nil
	local oldanimindex = -1
	local joints = {}
	local defaultmode = {
		idle = emptyfunction,
		walk = emptyfunction,
		jump = emptyfunction,
		fall = emptyfunction,
	}
	local modes = {}
	local currentmode = defaultmode
	local onkeypress = function(key)
		if modes[key] then
			currentmode.modeLeft()
			if currentmode == modes[key] then
				currentmode = defaultmode
			else
				currentmode = modes[key]
			end
			currentmode.modeEntered()
		end
	end
	local port = {
		getJoint = function(name)
			return joints[name] or {}
		end,
		addmode = function(key, mode)
			if key == "default" then
				defaultmode.idle = mode.idle or emptyfunction
				defaultmode.walk = mode.walk or mode.idle or emptyfunction
				defaultmode.jump = mode.jump or mode.fall or mode.idle or emptyfunction
				defaultmode.fall = mode.fall or mode.jump or mode.idle or emptyfunction
				defaultmode.modeEntered = mode.modeEntered or emptyfunction
				defaultmode.modeLeft = mode.modeLeft or emptyfunction
				defaultmode.modeEntered()
			else
				modes[key] = modes[key] or {}
				modes[key].idle = mode.idle or defaultmode.idle or emptyfunction
				modes[key].walk = mode.walk or defaultmode.walk or emptyfunction
				modes[key].jump = mode.jump or defaultmode.jump or emptyfunction
				modes[key].fall = mode.fall or defaultmode.fall or emptyfunction
				modes[key].modeEntered = mode.modeEntered or emptyfunction
				modes[key].modeLeft = mode.modeLeft or emptyfunction
				local mb = Instance.new("Frame", buttonsui)
				mb.BackgroundTransparency = 1
				local button = Instance.new("ImageButton", mb)
				button.Size = UDim2.new(0, 32, 0, 32)
				button.Image = "https://www.roblox.com/asset/?id=97166444"
				button.BackgroundTransparency = 1
				local txt = Instance.new("TextLabel", button)
				txt.Position = UDim2.new(0, 0, 0, 0)
				txt.Size = UDim2.new(1, 0, 1, 0)
				txt.BackgroundTransparency = 1
				txt.Font = Enum.Font.SourceSansBold
				txt.TextSize = 18
				txt.TextColor3 = Color3.new(1, 1, 1)
				txt.TextStrokeTransparency = 0
				txt.TextStrokeColor3 = Color3.new(0, 0, 0)
				txt.Text = key:upper()
				button.Activated:Connect(function()
					onkeypress(key)
				end)
			end
		end,
	}
	local resetanim = function(figure)
		rcp.FilterDescendantsInstances = {figure}
		local hum = figure:FindFirstChild("Humanoid")
		if not hum then return end
		local root = figure:FindFirstChild("HumanoidRootPart")
		if not root then return end
		local torso = figure:FindFirstChild("Torso")
		if not torso then return end
		port.raycastlegs = function()
			local scale = figure:GetScale()
			local rayl = PhysicsRaycast(root.CFrame * (Vector3.new(-1, -1, 0) * scale), Vector3.new(0, -2 * scale, 0))
			local rayr = PhysicsRaycast(root.CFrame * (Vector3.new(1, -1, 0) * scale), Vector3.new(0, -2 * scale, 0))
			if rayl then
				rayl = (rayl.Position.Y - (root.Position.Y - 3 * scale)) / scale
			else
				rayl = 0
			end
			if rayr then
				rayr = (rayr.Position.Y - (root.Position.Y - 3 * scale)) / scale
			else
				rayr = 0
			end
			return rayr, rayl
		end
		port.velbycfrvec = function()
			return root.CFrame.LookVector:Dot(root.Velocity) / hum.WalkSpeed, root.CFrame.RightVector:Dot(root.Velocity) / hum.WalkSpeed
		end
		local lastvel = Vector3.zero
		local velchg1 = Vector3.zero
		port.velchgbycfrvec = function()
			local scale = figure:GetScale()
			local xzvel = (root.Velocity * Vector3.new(1, 0, 1)) / scale
			velchg1 = velchg1 + (lastvel - xzvel)
			lastvel = xzvel
			velchg1 = velchg1 * (1 - deltaTime / 2)
			local fw = root.CFrame.LookVector:Dot(velchg1) / 32
			local rt = root.CFrame.RightVector:Dot(velchg1) / 32
			return fw, rt
		end
		local lastYvel = 0
		local velYchg1 = 0
		port.velYchg = function()
			local scale = figure:GetScale()
			local Yvel = root.Velocity.Y / scale
			velYchg1 = math.clamp(velYchg1 + (lastYvel - Yvel), -50, 50)
			lastYvel = Yvel
			velYchg1 = velYchg1 * (1 - deltaTime / 2)
			return velYchg1
		end
		port.setWalkSpeed = function(n)
			local scale = figure:GetScale()
			if type(n) ~= "number" then
				n = 16
			end
			hum.WalkSpeed = n * scale
		end
		port.setWalkSpeed()
		port.setJumpPower = function(n)
			local scale = figure:GetScale()
			if type(n) ~= "number" then
				n = 50
			end
			hum.JumpPower = n * scale
		end
		port.setJumpPower()
		port.setGravity = emptyfunction
		port.setCfr = function(v)
			if typeof(v) == "CFrame" then
				root.CFrame = v
			elseif typeof(v) == "Vector3" then
				root.CFrame = root.CFrame.Rotation + v
			end
		end
		port.getVel = function()
			local scale = figure:GetScale()
			return root.Velocity / scale
		end
		port.getCamCF = function()
			if workspace.CurrentCamera then
				return workspace.CurrentCamera.CFrame
			end
			return CFrame.identity
		end
		local rj = root:FindFirstChild("RootJoint")
		local nj = torso:FindFirstChild("Neck")
		local rsj = torso:FindFirstChild("Right Shoulder")
		local lsj = torso:FindFirstChild("Left Shoulder")
		local rhj = torso:FindFirstChild("Right Hip")
		local lhj = torso:FindFirstChild("Left Hip")
		joints = {
			["RootJoint"] = {
				C0 = CFrame.new(0, 0, 0, -1, 0, 0, 0, 0, 1, 0, 1, 0),
				C1 = CFrame.new(0, 0, 0, -1, 0, 0, 0, 0, 1, 0, 1, 0),
				Reference = rj,
			},
			["Neck"] = {
				C0 = CFrame.new(0, 1, 0, -1, 0, 0, 0, 0, 1, 0, 1, 0),
				C1 = CFrame.new(0, -0.5, 0, -1, 0, 0, 0, 0, 1, 0, 1, 0),
				Reference = nj,
			},
			["Right Shoulder"] = {
				C0 = CFrame.new(1, 0.5, 0, 0, 0, 1, 0, 1, 0, -1, 0, 0),
				C1 = CFrame.new(-0.5, 0.5, 0, 0, 0, 1, 0, 1, 0, -1, 0, 0),
				Reference = rsj,
			},
			["Left Shoulder"] = {
				C0 = CFrame.new(-1, 0.5, 0, 0, 0, -1, 0, 1, 0, 1, 0, 0),
				C1 = CFrame.new(0.5, 0.5, 0, 0, 0, -1, 0, 1, 0, 1, 0, 0),
				Reference = lsj,
			},
			["Right Hip"] = {
				C0 = CFrame.new(1, -1, 0, 0, 0, 1, 0, 1, 0, -1, 0, 0),
				C1 = CFrame.new(0.5, 1, 0, 0, 0, 1, 0, 1, 0, -1, 0, 0),
				Reference = rhj,
			},
			["Left Hip"] = {
				C0 = CFrame.new(-1, -1, 0, 0, 0, -1, 0, 1, 0, 1, 0, 0),
				C1 = CFrame.new(-0.5, 1, 0, 0, 0, -1, 0, 1, 0, 1, 0, 0),
				Reference = lhj,
			},
		}
		defaultmode = {
			idle = emptyfunction,
			walk = emptyfunction,
			jump = emptyfunction,
			fall = emptyfunction,
		}
		modes = {}
		currentmode = defaultmode
	end
	local uiskeypress = nil
	local cellsize = 40

	m.Init = function(figure: Model)
		if buttonsui then
			buttonsui = buttonsui:Destroy()
		end
		buttonsui = Instance.new("Frame", HiddenGui)
		buttonsui.BackgroundTransparency = 1
		buttonsui.Name = RandomString()
		buttonsui.AnchorPoint = Vector2.new(1, 1)
		buttonsui.Position = UDim2.new(1, -130 + cellsize, 1, -130 + cellsize)
		buttonsui.Size = UDim2.new(0, cellsize * 20, 0, cellsize * 3)
		oldanimindex = -1
		if uiskeypress then
			uiskeypress:Disconnect()
		end
		uiskeypress = UserInputService.InputBegan:Connect(function(input, gpe)
			if input.UserInputType == Enum.UserInputType.Keyboard and not UserInputService:GetFocusedTextBox() then
				onkeypress(input.KeyCode.Name:lower())
			end
		end)
	end
	m.Update = function(dt: number, figure: Model)
		local t = os.clock()
		local i = m.AnimIndex
		if i ~= oldanimindex then
			if anims[i] == nil then
				m.AnimIndex = 1
				i = 1
			end
			oldanimindex = i
			resetanim(figure)
			buttonsui:ClearAllChildren()
			local grid = Instance.new("UIGridLayout", buttonsui)
			grid.CellPadding = UDim2.new(0, 0, 0, 0)
			grid.CellSize = UDim2.new(0, cellsize, 0, cellsize)
			grid.HorizontalAlignment = Enum.HorizontalAlignment.Right
			grid.VerticalAlignment = Enum.VerticalAlignment.Bottom
			grid.FillDirection = Enum.FillDirection.Vertical
			anims[i](port)
		end
		local touch = not UserInputService.KeyboardEnabled
		if buttonsui.Visible ~= touch then
			buttonsui.Visible = touch
		end
		sine = t
		deltaTime = math.min(dt * 10, 1)
		local scale = figure:GetScale()
		local hum = figure:FindFirstChild("Humanoid")
		if not hum then return end
		local root = figure:FindFirstChild("HumanoidRootPart")
		if not root then return end
		local torso = figure:FindFirstChild("Torso")
		if not torso then return end
		local xz = (root.Velocity * Vector3.new(1, 0, 1)).Magnitude
		local y = root.Velocity.Y
		if hum.FloorMaterial ~= Enum.Material.Air then
			if xz > 0.1 then
				currentmode.walk()
			else
				currentmode.idle()
			end
		else
			if y > 0 then
				currentmode.jump()
			else
				currentmode.fall()
			end
		end
		for _,j in joints do
			SetC0C1Joint(j.Reference, j.C0, j.C1, scale)
		end
	end
	m.Destroy = function(figure: Model?)
		if buttonsui then
			buttonsui = buttonsui:Destroy()
		end
		if uiskeypress then
			uiskeypress:Disconnect()
		end
	end
	return m
end)

return modules