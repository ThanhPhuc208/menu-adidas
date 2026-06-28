local scriptSource = [[
local Players = game:GetService("Players")
local TextChatService = game:GetService("TextChatService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local rootPart = character:WaitForChild("HumanoidRootPart")

player.CharacterAdded:Connect(function(newCharacter)
	character = newCharacter
	rootPart = newCharacter:WaitForChild("HumanoidRootPart")
end)

-- Biến trạng thái vòng lặp
local autoWinEnabled = false
local autoClickEnabled = false

----------------------------------------------------------------
-- 1. TÌM VỊ TRÍ ĐÍCH (WIN PAD) VÀ BÀN PHÍM TRÊN MAP
----------------------------------------------------------------
local function getWinPart()
	-- Tìm khu vực Đích (Thường đặt tên là Win, End, Finish, Trophy...)
	for _, v in pairs(workspace:GetDescendants()) do
		if v:IsA("BasePart") and (v.Name:lower():match("win") or v.Name:lower():match("finish") or v.Name:lower():match("trophy")) then
			return v
		end
	end
	return nil
end

----------------------------------------------------------------
-- 2. KHỞI TẠO GIAO DIỆN MENU (GUI)
----------------------------------------------------------------
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KeyboardEscapeHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = player:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 260, 0, 200)
MainFrame.Position = UDim2.new(0.5, -130, 0.4, -100)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = true
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1
Title.Text = "KEYBOARD ESCAPE HUB"
Title.TextColor3 = Color3.fromRGB(0, 255, 255)
Title.TextSize = 14
Title.Font = Enum.Font.SourceSansBold
Title.Parent = MainFrame

-- Nút Auto Win (Teleport Farm)
local AutoWinBtn = Instance.new("TextButton")
AutoWinBtn.Size = UDim2.new(0, 220, 0, 40)
AutoWinBtn.Position = UDim2.new(0.5, -110, 0.25, 5)
AutoWinBtn.BackgroundColor3 = Color3.fromRGB(255, 65, 65)
AutoWinBtn.BorderSizePixel = 0
AutoWinBtn.Text = "AUTO WIN: ĐANG TẮT"
AutoWinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
AutoWinBtn.TextSize = 13
AutoWinBtn.Font = Enum.Font.SourceSansBold
AutoWinBtn.Parent = MainFrame

local Corner1 = Instance.new("UICorner")
Corner1.CornerRadius = UDim.new(0, 6)
Corner1.Parent = AutoWinBtn

-- Nút Auto Click / Nhặt Keyboard
local AutoClickBtn = Instance.new("TextButton")
AutoClickBtn.Size = UDim2.new(0, 220, 0, 40)
AutoClickBtn.Position = UDim2.new(0.5, -110, 0.5, 15)
AutoClickBtn.BackgroundColor3 = Color3.fromRGB(255, 65, 65)
AutoClickBtn.BorderSizePixel = 0
AutoClickBtn.Text = "AUTO NHẶT PHÍM: ĐANG TẮT"
AutoClickBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
AutoClickBtn.TextSize = 13
AutoClickBtn.Font = Enum.Font.SourceSansBold
AutoClickBtn.Parent = MainFrame

local Corner2 = Instance.new("UICorner")
Corner2.CornerRadius = UDim.new(0, 6)
Corner2.Parent = AutoClickBtn

local HintText = Instance.new("TextLabel")
HintText.Size = UDim2.new(1, 0, 0, 20)
HintText.Position = UDim2.new(0, 0, 1, -20)
HintText.BackgroundTransparency = 1
HintText.Text = "Gõ '/speed' trong chat để ẩn/hiện"
HintText.TextColor3 = Color3.fromRGB(150, 150, 150)
HintText.TextSize = 11
HintText.Font = Enum.Font.SourceSansItalic
HintText.Parent = MainFrame

----------------------------------------------------------------
-- 3. LOGIC XỬ LÝ VÒNG LẶP CHỨC NĂNG
----------------------------------------------------------------

-- Quản lý ẩn/hiện bằng chat
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

-- Vòng lặp Auto Win (Dịch chuyển liên tục tới đích nhận Wins)
task.spawn(function()
	while task.wait(0.5) do
		if autoWinEnabled and rootPart then
			local winPart = getWinPart()
			if winPart then
				rootPart.CFrame = winPart.CFrame + Vector3.new(0, 2, 0)
			end
		end
	end
end)

-- Vòng lặp Auto Nhặt Bàn Phím/Click vật phẩm tăng tốc độ
task.spawn(function()
	while task.wait(0.1) do
		if autoClickEnabled then
			-- Tự động kích hoạt ClickDetector xung quanh nếu game yêu cầu bấm vào phím
			for _, v in pairs(workspace:GetDescendants()) do
				if v:IsA("ClickDetector") then
					fireclickdetector(v)
				end
			end
			-- Tự động thu thập các Keyboard rơi trên sàn (Touch)
			if rootPart then
				for _, v in pairs(workspace:GetDescendants()) do
					if v:IsA("BasePart") and (v.Name:lower():match("key") or v.Name:lower():match("board") or v.Name:lower():match("speed")) then
						if (rootPart.Position - v.Position).Magnitude < 20 then
							firetouchinterest(rootPart, v, 0)
							firetouchinterest(rootPart, v, 1)
						end
					end
				end
			end
		end
	end
end)

-- Sự kiện nhấn nút Auto Win
AutoWinBtn.MouseButton1Click:Connect(function()
	autoWinEnabled = not autoWinEnabled
	if autoWinEnabled then
		AutoWinBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
		AutoWinBtn.Text = "AUTO WIN: ĐANG BẬT"
	else
		AutoWinBtn.BackgroundColor3 = Color3.fromRGB(255, 65, 65)
		AutoWinBtn.Text = "AUTO WIN: ĐANG TẮT"
	end
end)

-- Sự kiện nhấn nút Auto Nhặt Phím
AutoClickBtn.MouseButton1Click:Connect(function()
	autoClickEnabled = not autoClickEnabled
	if autoClickEnabled then
		AutoClickBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
		AutoClickBtn.Text = "AUTO NHẶT PHÍM: ĐANG BẬT"
	else
		AutoClickBtn.BackgroundColor3 = Color3.fromRGB(255, 65, 65)
		AutoClickBtn.Text = "AUTO NHẶT PHÍM: ĐANG TẮT"
	end
end)
]]

assert(loadstring(scriptSource))()
