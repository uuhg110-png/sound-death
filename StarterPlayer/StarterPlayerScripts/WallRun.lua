local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local humanoid = char:WaitForChild("Humanoid")

local running = false

local LA = script:FindFirstChild("RunAnim") and humanoid:LoadAnimation(script.RunAnim)
local RA = script:FindFirstChild("RunRightAnim") and humanoid:LoadAnimation(script.RunRightAnim)

local Vel = Instance.new("BodyVelocity")
Vel.Name = "WallRunVelocity"
Vel.MaxForce = Vector3.zero
Vel.Parent = hrp

local BGO = Instance.new("BodyGyro")
BGO.Name = "WallRunGyro"
BGO.D = 100
BGO.P = 10000
BGO.MaxTorque = Vector3.zero
BGO.Parent = hrp

local function stop()
	running=false
	Vel.MaxForce=Vector3.zero
	BGO.MaxTorque=Vector3.zero
	if LA then LA:Stop() end
	if RA then RA:Stop() end
end

RunService.RenderStepped:Connect(function()
	local params=RaycastParams.new()
	params.FilterDescendantsInstances={char}
	params.FilterType=Enum.RaycastFilterType.Exclude

	local left=workspace:Raycast(hrp.Position,-hrp.CFrame.RightVector*3,params)
	local right=workspace:Raycast(hrp.Position,hrp.CFrame.RightVector*3,params)
	local hit=left or right

	if hit and hit.Instance.Name=="WallRun" then
		running=true
		local dir=Vector3.new(0,1,0):Cross(hit.Normal)
		if right then dir=-dir end

		BGO.MaxTorque=Vector3.new(math.huge,math.huge,math.huge)
		BGO.CFrame=CFrame.lookAt(hrp.Position,hrp.Position+dir)
		Vel.MaxForce=Vector3.new(math.huge,math.huge,math.huge)
		Vel.Velocity=dir*50

		if left and LA then LA:Play() end
		if right and RA then RA:Play() end
	else
		if running then stop() end
	end
end)
