local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")
local Debris = game:GetService("Debris")
local ContentProvider = game:GetService("ContentProvider")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local humanoid = char:WaitForChild("Humanoid")
local root = char:WaitForChild("HumanoidRootPart")

local canSlide = true
local key = Enum.KeyCode.Q

local slideAnim = Instance.new("Animation")
slideAnim.AnimationId = "rbxassetid://132370517371874"

local sound = Instance.new("Sound")
sound.SoundId = "rbxassetid://105544173943722"
sound.Volume = 1
sound.Parent = root
ContentProvider:PreloadAsync({sound})

local function dust()
	local a = Instance.new("Attachment")
	a.Position = Vector3.new(0,-2.5,0)
	a.Parent = root
	local p = Instance.new("ParticleEmitter")
	p.Texture = "rbxasset://textures/particles/smoke_main.dds"
	p.Rate = 80
	p.Lifetime = NumberRange.new(.35,.8)
	p.Speed = NumberRange.new(1,4)
	p.Parent = a
	task.delay(.8,function()
		p.Enabled=false
		Debris:AddItem(a,2)
	end)
end

local function slide()
	if not canSlide then return end
	canSlide=false

	humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping,false)
	sound:Play()

	local track=humanoid:LoadAnimation(slideAnim)
	track.Priority=Enum.AnimationPriority.Action3
	track:Play()
	dust()

	local bv=Instance.new("BodyVelocity")
	bv.Name="SlideVelocity"
	bv.MaxForce=Vector3.new(1,0,1) * 30000
	bv.Velocity=root.CFrame.LookVector*100
	bv.Parent=root

	for i=1,12 do
		task.wait(.08)
		bv.Velocity*=.78
		if i%2==0 then dust() end
	end

	bv:Destroy()
	track:Stop()
	humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping,true)
	task.wait(.5)
	canSlide=true
end

UIS.InputBegan:Connect(function(input,processed)
	if processed then return end
	if input.KeyCode==key then
		slide()
	end
end)
