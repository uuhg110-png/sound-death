local Players=game:GetService("Players")
local Debris=game:GetService("Debris")

local player=Players.LocalPlayer
local char=player.Character or player.CharacterAdded:Wait()
local hrp=char:WaitForChild("HumanoidRootPart")

local function dust()
	local a=Instance.new("Attachment")
	a.Parent=hrp

	local p=Instance.new("ParticleEmitter")
	p.Texture="rbxasset://textures/particles/smoke_main.dds"
	p.Rate=60
	p.Lifetime=NumberRange.new(.2,.5)
	p.Speed=NumberRange.new(2,5)
	p.Parent=a

	task.delay(.15,function()
		p.Enabled=false
	end)

	Debris:AddItem(a,1)
end

while task.wait(.12) do
	if hrp:FindFirstChild("WallRunOrientation") then
		dust()
	end
end
