local scriptSource = [[
local Players = game:GetService("Players")
local TextChatService = game:GetService("TextChatService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- Bảng lưu trữ ID hoạt ảnh mặc định (adidas aura trong ảnh của bạn)
local anims = {
	idle = "18903513386",
	walk = "18903522201",
	run = "18903518384",
	jump = "18903515320",
	fall = "18903511874",
	climb = "18903510003",
	swim = "18903519881"
}

local function applyAnimations(char)
	local animate = char:WaitForChild("Animate", 5)
	if animate then
		-- Thao tác ghi đè lên các giá trị hoạt ảnh của R15
		pcall(function()
			animate.idle.Animation1.AnimationId = "rbxassetid://" .. anims.idle
			animate.idle.Animation2.AnimationId = "rbxassetid://" .. anims.idle
			animate.walk.WalkAnim.AnimationId = "rbxassetid://" .. anims.walk
			animate.run.RunAnim.AnimationId = "rbxassetid://" .. anims.run
			animate.jump.JumpAnim.AnimationId = "rbxassetid://" .. anims.jump
			animate.fall.FallAnim.AnimationId = "rbxassetid://" .. anims.fall
			animate.climb.ClimbAnim.AnimationId = "rbxassetid://" .. anims.climb
			animate.swim.SwimAnim.AnimationId = "rbxassetid://" .. anims.swim
		end)
		
		-- Làm mới hoạt ảnh đang chạy của nhân vật để kích hoạt ngay lập tức
		local humanoid = char:FindFirstChildOfClass("Humanoid")
		if humanoid then
			for _, track in pairs(humanoid:GetPlayingAnimationTracks()) do
				track:Stop()
			end
		end
	end
end

player.CharacterAdded:Connect(function(newCharacter)
	character = newCharacter
	task.wait(0.5)
	applyAnimations(character)
end)

----------------------------------------------------------------
-- GIAO DIỆN MENU (GUI)
----------------------------------------------------------------
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AnimMenuGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = player:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 260, 0, 160)
MainFrame.Position = UDim2.new(0.5, -130, 0.4, -80)
MainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = true
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 35)
Title.BackgroundTransparency = 1
Title.Text = "R15 ANIMATION TRY-ON"
Title.TextColor3 = Color3.fromRGB(0, 255, 128)
Title.TextSize = 14
Title.Font = Enum.Font.SourceSansBold
Title.Parent = MainFrame

local InputBox = Instance.new("TextBox")
InputBox.Size = UDim2.new(0, 160, 0, 35)
InputBox.Position = UDim2.new(0.5, -80, 0.35, 0)
InputBox.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
InputBox.BorderSizePixel = 0
InputBox.Text = "adidas aura"
InputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
InputBox.TextSize = 14
InputBox.Font = Enum.Font.SourceSansBold
InputBox.ClearTextOnFocus = false
InputBox.Parent = MainFrame

local InputCorner = Instance.new("UICorner")
InputCorner.CornerRadius = UDim.new(0, 5)
InputCorner.Parent = InputBox

local ApplyBtn = Instance.new("TextButton")
ApplyBtn.Size = UDim2.new(0, 140, 0, 35)
ApplyBtn.Position = UDim2.new(0.5, -70, 0.65, 5)
ApplyBtn.BackgroundColor3 = Color3.fromRGB(0, 128, 255)
ApplyBtn.BorderSizePixel = 0
ApplyBtn.Text = "THỬ HOẠT ẢNH"
ApplyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ApplyBtn.TextSize = 14
ApplyBtn.Font = Enum.Font.SourceSansBold
ApplyBtn.Parent = MainFrame

local BtnCorner = Instance.new("UICorner")
BtnCorner.CornerRadius = UDim.new(0, 5)
BtnCorner.Parent = ApplyBtn

local HintText = Instance.new("TextLabel")
HintText.Size = UDim2.new(1, 0, 0, 20)
HintText.Position = UDim2.new(0, 0, 1, -20)
HintText.BackgroundTransparency = 1
HintText.Text = "Gõ '/speed' trong chat để ẩn/hiện"
HintText.TextColor3 = Color3.fromRGB(150, 150, 150)
HintText.TextSize = 11
HintText.Font = Enum.Font.SourceSansItalic
HintText.Parent = MainFrame

local function toggleMenu(msg)
	if msg:lower() == "/speed" then
		MainFrame.Visible = not MainFrame.Visible
	end
end

player.Chatted:Connect(toggleMenu)
pcall(function()
	TextChatService.MessageReceived:Connect(function(message)
		if message.TextSource and message.TextSource.UserId == player.UserId then
			toggleMenu(message.Text)
		end
	end)
end)

ApplyBtn.MouseButton1Click:Connect(function()
	if character then
		applyAnimations(character)
		ApplyBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
		ApplyBtn.Text = "ĐÃ ĐỔI ANIMATION"
		task.wait(1.5)
		ApplyBtn.BackgroundColor3 = Color3.fromRGB(0, 128, 255)
		ApplyBtn.Text = "THỬ HOẠT ẢNH"
	end
end)
]]

assert(loadstring(scriptSource))()

