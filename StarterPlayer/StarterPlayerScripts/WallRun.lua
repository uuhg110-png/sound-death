local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Debris = game:GetService("Debris")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local humanoid = char:WaitForChild("Humanoid")

local SETTINGS = {
	Speed = 65,
	MaxTime = 2.5,
	WallDistance = 3.5,
	JumpPower = 75,
	JumpUp = 55
}

local running = false
local timer = 0
local normal

local LA = script:FindFirstChild("RunAnim") and humanoid:LoadAnimation(script.RunAnim)
local RA = script:FindFirstChild("RunRightAnim") and humanoid:LoadAnimation(script.RunRightAnim)

if LA then LA.Priority = Enum.AnimationPriority.Action end
if RA then RA.Priority = Enum.AnimationPriority.Action end

local attachment = Instance.new("Attachment")
attachment.Parent = hrp

local align = Instance.new("AlignOrientation")
align.Attachment0 = attachment
align.Mode = Enum.OrientationAlignmentMode.OneAttachment
align.MaxTorque = 50000
align.Responsiveness = 40
align.Enabled = false
align.Parent = hrp

local function stop()
	running = false
	timer = 0
	align.Enabled = false

	if LA then LA:Stop(.2) end
	if RA then RA:Stop(.2) end

	humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll,true)
end

local function wallRay()
	local params = RaycastParams.new()
	params.FilterType = Enum.RaycastFilterType.Exclude
	params.FilterDescendantsInstances = {char}

	local left = workspace:Raycast(hrp.Position,-hrp.CFrame.RightVector*SETTINGS.WallDistance,params)
	local right = workspace:Raycast(hrp.Position,hrp.CFrame.RightVector*SETTINGS.WallDistance,params)

	return left,right
end

RunService.RenderStepped:Connect(function(dt)
	local left,right = wallRay()
	local hit = left or right

	if hit and hit.Instance.Name == "WallRun" then
		if not running then
			running=true
			timer=0
			humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll,false)
		end

		timer += dt
		if timer > SETTINGS.MaxTime then
			stop()
			return
		end

		normal = hit.Normal
		local dir = Vector3.new(0,1,0):Cross(normal)

		if right then
			dir = -dir
		end

		local current = hrp.AssemblyLinearVelocity
		hrpp = Vector3.new(dir.X*SETTINGS.Speed,5,dir.Z*SETTINGS.Speed)
		hrp.AssemblyLinearVelocity = hrpp

		align.Enabled=true
		align.CFrame=CFrame.lookAt(Vector3.zero,dir,normal)

		if left and LA and not LA.IsPlaying then
			if RA then RA:Stop() end
			LA:Play(.15)
		end

		if right and RA and not RA.IsPlaying then
			if LA then LA:Stop() end
			RA:Play(.15)
		end
	else
		if running then stop() end
	end
end)

humanoid.StateChanged:Connect(function(_,state)
	if running and state == Enum.HumanoidStateType.Jumping then
		local jump = normal and -normal*SETTINGS.JumpPower or hrp.CFrame.LookVector*SETTINGS.JumpPower
		hrp.AssemblyLinearVelocity = jump + Vector3.new(0,SETTINGS.JumpUp,0)
		stop()
	end
end)
