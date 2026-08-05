local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local humanoid = char:WaitForChild("Humanoid")

local wallRunning = false
local leftPlaying = false
local rightPlaying = false

local LA = script:FindFirstChild("RunAnim") and humanoid:LoadAnimation(script.RunAnim)
local RA = script:FindFirstChild("RunRightAnim") and humanoid:LoadAnimation(script.RunRightAnim)

local vel = Instance.new("BodyVelocity")
vel.Name = "WallRunForce"
vel.MaxForce = Vector3.zero
vel.Parent = hrp

local gyro = Instance.new("BodyGyro")
gyro.Name = "WallRunRotation"
gyro.P = 10000
gyro.D = 100
gyro.MaxTorque = Vector3.zero
gyro.Parent = hrp

local function stop()
	wallRunning=false
	vel.MaxForce=Vector3.zero
gyro.MaxTorque=Vector3.zero
	if LA then LA:Stop() end
	if RA then RA:Stop() end
	leftPlaying=false
	rightPlaying=false
end

RunService.RenderStepped:Connect(function()
	local params=RaycastParams.new()
	params.FilterDescendantsInstances={char}
	params.FilterType=Enum.RaycastFilterType.Exclude

	local left=workspace:Raycast(hrp.Position,-hrp.CFrame.RightVector*3,params)
	local right=workspace:Raycast(hrp.Position,hrp.CFrame.RightVector*3,params)
	local hit=left or right

	if hit and hit.Instance.Name=="WallRun" then
		wallRunning=true
		local dir=Vector3.new(0,1,0):Cross(hit.Normal)
		if right then dir=-dir end

		gyro.MaxTorque=Vector3.new(math.huge,math.huge,math.huge)
		gyro.CFrame=CFrame.lookAt(hrp.Position,hrp.Position+dir)
		vel.MaxForce=Vector3.new(math.huge,math.huge,math.huge)
		vel.Velocity=dir*50

		if left and LA and not leftPlaying then
			LA:Play(); leftPlaying=true
		end
		if right and RA and not rightPlaying then
			RA:Play(); rightPlaying=true
		end
	else
		if wallRunning then stop() end
	end
end)
