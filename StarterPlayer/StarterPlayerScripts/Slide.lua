local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")
local Debris = game:GetService("Debris")
local ContentProvider = game:GetService("ContentProvider")

local player = Players.LocalPlayer
local char = script.Parent
local humanoid = char:WaitForChild("Humanoid")
local rootPart = char:WaitForChild("HumanoidRootPart")

local keybind = Enum.KeyCode.Q
local canslide = true

local slideAnim = Instance.new("Animation")
slideAnim.AnimationId = "rbxassetid://132370517371874"

local slideSound = Instance.new("Sound")
slideSound.SoundId = "rbxassetid://105544173943722"
slideSound.Volume = 1
slideSound.Parent = rootPart
ContentProvider:PreloadAsync({slideSound})

local function createSlideTrail()
	local attachment = Instance.new("Attachment")
	attachment.Position = Vector3.new(0,-2.5,0)
	attachment.Parent = rootPart

	local dust = Instance.new("ParticleEmitter")
	dust.Texture = "rbxasset://textures/particles/smoke_main.dds"
	dust.Rate = 80
	dust.Lifetime = NumberRange.new(0.35,0.8)
	dust.Speed = NumberRange.new(1,4)
	dust.SpreadAngle = Vector2.new(35,35)
	dust.Drag = 5
	dust.Rotation = NumberRange.new(0,360)
	dust.RotSpeed = NumberRange.new(-80,80)
	dust.Size = NumberSequence.new({NumberSequenceKeypoint.new(0,0.8),NumberSequenceKeypoint.new(0.5,1.8),NumberSequenceKeypoint.new(1,0)})
	dust.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0,0.25),NumberSequenceKeypoint.new(1,1)})
	dust.Color = ColorSequence.new(Color3.fromRGB(120,120,120))
	dust.Parent = attachment

	task.delay(0.8,function()
		dust.Enabled=false
		Debris:AddItem(attachment,2)
	end)
end

local function performSlide()
	if not canslide then return end
	canslide=false

	humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping,false)
	humanoid.Jump=false

	slideSound:Play()

	local track=humanoid:LoadAnimation(slideAnim)
	track.Priority=Enum.AnimationPriority.Action3
	track:Play()

	createSlideTrail()

	local velocity=Instance.new("BodyVelocity")
	velocity.MaxForce=Vector3.new(1,0,1)*30000
	velocity.Velocity=rootPart.CFrame.LookVector*100
	velocity.Parent=rootPart

	for i=1,12 do
		task.wait(0.08)
		velocity.Velocity*=0.78
		if i%2==0 then createSlideTrail() end
	end

	velocity:Destroy()
	track:Stop()
	humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping,true)

	task.wait(0.5)
	canslide=true
end

UIS.InputBegan:Connect(function(input,processed)
	if processed then return end
	if input.KeyCode==keybind then
		performSlide()
	end
end)

local gui=player:WaitForChild("PlayerGui")
local screenGui=gui:FindFirstChild("ScreenGui")
if screenGui and screenGui:FindFirstChild("SlideButton") then
	screenGui.SlideButton.MouseButton1Click:Connect(performSlide)
end