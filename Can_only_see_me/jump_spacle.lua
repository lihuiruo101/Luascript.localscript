local Players = game:GetService("Players")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

local function createJumpEffect()
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    -- 파티클 폭발 효과 만들기
    local particle = Instance.new("ParticleEmitter")
    particle.Texture = "rbxassetid://241594314"  -- 폭발 느낌 텍스처
    particle.Speed = NumberRange.new(10, 15)
    particle.Lifetime = NumberRange.new(0.5, 1)
    particle.Rate = 100
    particle.Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 3), NumberSequenceKeypoint.new(1, 0)})
    particle.EmissionDirection = Enum.NormalId.Top
    particle.Parent = hrp

    -- 잠시 후 파티클 정리
    delay(0.7, function()
        particle.Enabled = false
        wait(1)
        particle:Destroy()
    end)
end

humanoid.Jumping:Connect(function(active)
    if active then
        createJumpEffect()
    end
end)
