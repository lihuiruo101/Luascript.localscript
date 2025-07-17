local Players = game:GetService("Players")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "CloakGui"

local button = Instance.new("TextButton", gui)
button.Size = UDim2.new(0, 180, 0, 50)
button.Position = UDim2.new(0, 20, 0, 100)
button.Text = "투명 망토 ON"
button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
button.TextColor3 = Color3.new(1,1,1)
button.Font = Enum.Font.GothamBold
button.TextSize = 22

local cloaked = false

local function setTransparency(state)
    for _, part in pairs(character:GetChildren()) do
        if part:IsA("BasePart") then
            part.Transparency = state and 0.6 or 0
        elseif part:IsA("Decal") then
            part.Transparency = state and 0.6 or 0
        end
    end
end

local function setWalkSound(state)
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        if state then
            humanoid.WalkSpeed = 12 -- 살짝 느리게
        else
            humanoid.WalkSpeed = 16 -- 기본값으로
        end
    end
end

button.MouseButton1Click:Connect(function()
    cloaked = not cloaked
    if cloaked then
        button.Text = "투명 망토 OFF"
        setTransparency(true)
        setWalkSound(true)
    else
        button.Text = "투명 망토 ON"
        setTransparency(false)
        setWalkSound(false)
    end
end)
