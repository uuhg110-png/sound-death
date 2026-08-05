local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")
local Debris = game:GetService("Debris")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local humanoid = char:WaitForChild("Humanoid")
local root = char:WaitForChild("HumanoidRootPart")

local canSlide = true
local key = Enum.KeyCode.Q

local anim = Instance.new("Animation")
anim.AnimationId = "rbxassetid://132370517371874"

local function slide()
	if not canSlide then return end

	-- не ломаем wallrun
	if root:FindFirstChild("WallRunVelocity") or root:FindFirstChild("Anti") then
		return
	end

	canSlide = false

	humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping,false)

	local track = humanoid:LoadAnimation(anim)
	track.Priority = Enum.AnimationPriority.Action3
	track:Play()

	local bv = Instance.new("BodyVelocity")
	bv.Name = "SlideVelocity"
	bv.MaxForce = Vector3.new(5000,0,5000)
	bv.Velocity = root.CFrame.LookVector * 100
	bv.Parent = root

	for i = 1,12 do
		task.wait(.08)
		bv.Velocity *= .78
	end

	bv:Destroy()
	track:Stop()

	humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping,true)

	task.wait(.5)
	canSlide = true
end

UIS.InputBegan:Connect(function(input,processed)
	if processed then return end
	if input.KeyCode == key then
		slide()
	end
end)
