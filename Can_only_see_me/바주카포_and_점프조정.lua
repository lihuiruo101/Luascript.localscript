local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local replicatedStorage = game:GetService("ReplicatedStorage")
local starterPack = game:GetService("StarterPack")
local runService = game:GetService("RunService")
local debris = game:GetService("Debris")

-- 기존 GUI 제거
if playerGui:FindFirstChild("점프력GUI") then
	playerGui:FindFirstChild("점프력GUI"):Destroy()
end

-- GUI 만들기
local gui = Instance.new("ScreenGui", playerGui)
gui.Name = "점프력GUI"

local mainFrame = Instance.new("Frame", gui)
mainFrame.Size = UDim2.new(0, 300, 0, 250)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -125)
mainFrame.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
mainFrame.BorderSizePixel = 2
mainFrame.Name = "네모박스"
mainFrame.Draggable = true
mainFrame.Active = true

-- 제목
local title = Instance.new("TextLabel", mainFrame)
title.Text = "점프력 설정 + 바주카포"
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundColor3 = Color3.fromRGB(50, 100, 200)
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextScaled = true

-- 점프력 슬라이더
local jumpPowerLabel = Instance.new("TextLabel", mainFrame)
jumpPowerLabel.Text = "점프력: 50"
jumpPowerLabel.Size = UDim2.new(1, -20, 0, 25)
jumpPowerLabel.Position = UDim2.new(0, 10, 0, 40)
jumpPowerLabel.BackgroundTransparency = 1
jumpPowerLabel.TextScaled = true
jumpPowerLabel.TextColor3 = Color3.new(0, 0, 0)
jumpPowerLabel.Font = Enum.Font.Gotham

local slider = Instance.new("TextButton", mainFrame)
slider.Size = UDim2.new(1, -20, 0, 40)
slider.Position = UDim2.new(0, 10, 0, 70)
slider.BackgroundColor3 = Color3.fromRGB(180, 180, 255)
slider.Text = "현재: 50 → 클릭 시 증가"
slider.TextScaled = true
slider.Font = Enum.Font.Gotham
slider.TextColor3 = Color3.new(0, 0, 0)

-- 바주카포 버튼
local bazookaButton = Instance.new("TextButton", mainFrame)
bazookaButton.Size = UDim2.new(1, -20, 0, 40)
bazookaButton.Position = UDim2.new(0, 10, 0, 130)
bazookaButton.BackgroundColor3 = Color3.fromRGB(255, 150, 150)
bazookaButton.Text = "☢️ 바주카포 지급 ☢️"
bazookaButton.TextScaled = true
bazookaButton.Font = Enum.Font.GothamBold
bazookaButton.TextColor3 = Color3.new(0, 0, 0)

-- 바주카포 실행 버튼
local fireButton = Instance.new("TextButton", mainFrame)
fireButton.Size = UDim2.new(1, -20, 0, 40)
fireButton.Position = UDim2.new(0, 10, 0, 180)
fireButton.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
fireButton.Text = "🔥 발사 (나 빼고 전부 제거)"
fireButton.TextScaled = true
fireButton.Font = Enum.Font.GothamBold
fireButton.TextColor3 = Color3.new(1, 1, 1)

-- 점프력 변수
local jumpPower = 50

-- 점프력 조절 기능
slider.MouseButton1Click:Connect(function()
	jumpPower += 10
	if jumpPower > 200 then
		jumpPower = 50
	end
	jumpPowerLabel.Text = "점프력: " .. jumpPower
	slider.Text = "현재: " .. jumpPower .. " → 클릭 시 증가"
	player.Character.Humanoid.JumpPower = jumpPower
end)

-- 바주카포 생성
local function createBazooka()
	local tool = Instance.new("Tool")
	tool.Name = "바주카포"
	tool.RequiresHandle = true
	tool.CanBeDropped = false

	local handle = Instance.new("Part")
	handle.Name = "Handle"
	handle.Size = Vector3.new(2, 1, 4)
	handle.BrickColor = BrickColor.new("Really black")
	handle.Material = Enum.Material.Metal
	handle.TopSurface = Enum.SurfaceType.Smooth
	handle.BottomSurface = Enum.SurfaceType.Smooth
	handle.Parent = tool

	tool.Equipped:Connect(function(mouse)
		tool.Activated:Connect(function()
			local missile = Instance.new("Part")
			missile.Size = Vector3.new(1, 1, 2)
			missile.BrickColor = BrickColor.new("Bright red")
			missile.CFrame = player.Character.Head.CFrame + Vector3.new(0, 0, -5)
			missile.Anchored = false
			missile.CanCollide = false
			missile.Parent = workspace

			local bv = Instance.new("BodyVelocity", missile)
			bv.Velocity = player.Character.Head.CFrame.lookVector * 200
			bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)

			local explosion = Instance.new("Explosion")
			explosion.BlastRadius = 15
			explosion.Position = missile.Position
			explosion.DestroyJointRadiusPercent = 0

			-- 발사 후 2초 후 터짐
			delay(2, function()
				if missile and missile.Parent then
					explosion.Position = missile.Position
					explosion.Parent = workspace
					missile:Destroy()
				end
			end)

			-- 본인 제외 모두 죽이기
			explosion.Hit:Connect(function(part)
				local character = part:FindFirstAncestorOfClass("Model")
				if character and character ~= player.Character then
					local humanoid = character:FindFirstChildOfClass("Humanoid")
					if humanoid then
						humanoid.Health = 0
					end
				end
			end)

			debris:AddItem(missile, 5)
		end)
	end)

	tool.Parent = player.Backpack
end

bazookaButton.MouseButton1Click:Connect(createBazooka)

-- 발사 버튼은 직접 캐릭터의 위치에서 바주카포처럼 폭발 생성
fireButton.MouseButton1Click:Connect(function()
	local boom = Instance.new("Explosion")
	boom.Position = player.Character.Head.Position + player.Character.Head.CFrame.lookVector * 10
	boom.BlastRadius = 20
	boom.DestroyJointRadiusPercent = 0

	boom.Hit:Connect(function(part)
		local character = part:FindFirstAncestorOfClass("Model")
		if character and character ~= player.Character then
			local humanoid = character:FindFirstChildOfClass("Humanoid")
			if humanoid then
				humanoid.Health = 0
			end
		end
	end)

	boom.Parent = workspace
end)
