local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

local flying = false
local speed = 40

-- GUI 만들기
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
screenGui.Name = "FlyGui"

-- 날기 토글 버튼
local flyButton = Instance.new("TextButton", screenGui)
flyButton.Size = UDim2.new(0, 120, 0, 50)
flyButton.Position = UDim2.new(0, 20, 1, -80)
flyButton.Text = "날기 시작"
flyButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
flyButton.TextColor3 = Color3.new(1,1,1)
flyButton.Font = Enum.Font.GothamBold
flyButton.TextSize = 22

local moveDir = Vector3.new(0,0,0)

-- 방향 버튼 생성 함수
local function createDirectionButton(text, pos, dirVec)
    local btn = Instance.new("TextButton", screenGui)
    btn.Size = UDim2.new(0, 60, 0, 60)
    btn.Position = pos
    btn.Text = text
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 26

    btn.AutoButtonColor = true

    btn.Pressed = false

    btn.TouchStarted:Connect(function()
        btn.Pressed = true
        moveDir = moveDir + dirVec
    end)

    btn.TouchEnded:Connect(function()
        btn.Pressed = false
        moveDir = moveDir - dirVec
    end)

    return btn
end

-- 방향 버튼들: 위, 아래, 좌, 우
local btnUp = createDirectionButton("↑", UDim2.new(1, -90, 1, -150), Vector3.new(0,0,-1))
local btnDown = createDirectionButton("↓", UDim2.new(1, -90, 1, -70), Vector3.new(0,0,1))
local btnLeft = createDirectionButton("←", UDim2.new(1, -150, 1, -110), Vector3.new(-1,0,0))
local btnRight = createDirectionButton("→", UDim2.new(1, -30, 1, -110), Vector3.new(1,0,0))

-- 날기 토글
flyButton.MouseButton1Click:Connect(function()
    flying = not flying
    if flying then
        flyButton.Text = "날기 중지"
        humanoid.PlatformStand = true
    else
        flyButton.Text = "날기 시작"
        humanoid.PlatformStand = false
        rootPart.Velocity = Vector3.new(0,0,0)
    end
end)

-- 날기 루프
RunService.Heartbeat:Connect(function()
    if flying then
        local cameraCFrame = workspace.CurrentCamera.CFrame
        local direction = (cameraCFrame.RightVector * moveDir.X) + (cameraCFrame.LookVector * moveDir.Z)
        direction = Vector3.new(direction.X, 0, direction.Z).Unit
        if direction ~= direction then -- NaN 체크
            direction = Vector3.new(0,0,0)
        end
        rootPart.Velocity = Vector3.new(direction.X * speed, 50, direction.Z * speed)
    end
end)
