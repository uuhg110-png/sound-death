local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local camera = workspace.CurrentCamera
local player = Players.LocalPlayer

local defaultFov = 70
local targetFov = 70

RunService.RenderStepped:Connect(function()
	local char = player.Character
	if not char then return end

	local root = char:FindFirstChild("HumanoidRootPart")
	if not root then return end

	if root:FindFirstChild("WallRunOrientation") then
		targetFov = 85
		camera.FieldOfView += (targetFov-camera.FieldOfView)*0.12
	else
		targetFov = defaultFov
		camera.FieldOfView += (targetFov-camera.FieldOfView)*0.12
	end
end)
