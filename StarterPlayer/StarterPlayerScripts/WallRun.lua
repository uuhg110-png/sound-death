local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local humanoid = char:WaitForChild("Humanoid")

local canWallRun = true
local wallRunning = false

local velocity = Instance.new("BodyVelocity")
velocity.Name = "WallRunVelocity"
velocity.MaxForce = Vector3.zero
velocity.Parent = hrp

local gyro = Instance.new("BodyGyro")
gyro.Name = "WallRunGyro"
gyro.MaxTorque = Vector3.zero
gyro.P = 10000
gyro.Parent = hrp

local function stopWallRun()
	wallRunning = false
	velocity.MaxForce = Vector3.zero
	gyro.MaxTorque = Vector3.zero
end

local function update()
	if not canWallRun then return end

	local rayParams = RaycastParams.new()
	rayParams.FilterDescendantsInstances = {char}
	rayParams.FilterType = Enum.RaycastFilterType.Exclude

	local left = workspace:Raycast(hrp.Position, -hrp.CFrame.RightVector * 3, rayParams)
	local right = workspace:Raycast(hrp.Position, hrp.CFrame.RightVector * 3, rayParams)
	local hit = left or right

	if hit and hit.Instance.Name == "WallRun" then
		wallRunning = true

		local normal = hit.Normal
		local direction = Vector3.new(0,1,0):Cross(normal)

		if right then
			direction = -direction
		end

		gyro.MaxTorque = Vector3.new(math.huge,math.huge,math.huge)
		gyro.CFrame = CFrame.lookAt(hrp.Position, hrp.Position + direction)

		velocity.MaxForce = Vector3.new(math.huge,math.huge,math.huge)
		velocity.Velocity = direction * 50
	else
		if wallRunning then
			stopWallRun()
		end
	end
end

RunService.RenderStepped:Connect(update)
