local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

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
local wallNormal

local LA = script:FindFirstChild("RunAnim") and humanoid:LoadAnimation(script.RunAnim)
local RA = script:FindFirstChild("RunRightAnim") and humanoid:LoadAnimation(script.RunRightAnim)

if LA then LA.Priority = Enum.AnimationPriority.Action end
if RA then RA.Priority = Enum.AnimationPriority.Action end

local att = Instance.new("Attachment", hrp)

local align = Instance.new("AlignOrientation")
align.Attachment0 = att
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

local function rays()
	local p = RaycastParams.new()
	p.FilterType = Enum.RaycastFilterType.Exclude
	p.FilterDescendantsInstances = {char}
	return workspace:Raycast(hrp.Position,-hrp.CFrame.RightVector*SETTINGS.WallDistance,p), workspace:Raycast(hrp.Position,hrp.CFrame.RightVector*SETTINGS.WallDistance,p)
end

RunService.RenderStepped:Connect(function(dt)
	local left,right = rays()
	local hit = left or right

	if hit and hit.Instance.Name == "WallRun" then
		if not running then
			running=true
			humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll,false)
		end

		timer += dt
		if timer > SETTINGS.MaxTime then stop() return end

		wallNormal = hit.Normal
		local dir = Vector3.new(0,1,0):Cross(wallNormal)
		if right then dir = -dir end

		hrpp = Vector3.new(dir.X*SETTINGS.Speed,5,dir.Z*SETTINGS.Speed)
		hrp.AssemblyLinearVelocity = hrpp

		align.Enabled=true
		align.CFrame=CFrame.lookAt(Vector3.zero,dir,wallNormal)

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
		hrp.AssemblyLinearVelocity = (-wallNormal*SETTINGS.JumpPower)+Vector3.new(0,SETTINGS.JumpUp,0)
		stop()
	end
end)
