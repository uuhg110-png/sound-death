local soundFolder = script.Parent

local function playRandomDeathSound(player)
	local sounds = {}

	for _, sound in ipairs(soundFolder:GetChildren()) do
		if sound:IsA("Sound") then
			table.insert(sounds, sound)
		end
	end

	if #sounds == 0 then
		warn("No death sounds found")
		return
	end

	local chosen = sounds[math.random(1, #sounds)]:Clone()
	chosen.Parent = workspace
	chosen:Play()

	chosen.Ended:Connect(function()
		chosen:Destroy()
	end)
end

local function setupDeathSound(player, character)
	local humanoid = character:FindFirstChild("Humanoid")
	if not humanoid then return end

	-- Disable default Roblox death sound
	humanoid.Died:Connect(function()
		playRandomDeathSound(player)
	end)
end

local Players = game:GetService("Players")

Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function(character)
		setupDeathSound(player, character)
	end)
end)

for _, player in ipairs(Players:GetPlayers()) do
	if player.Character then
		setupDeathSound(player, player.Character)
	end
end