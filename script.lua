local scriptSource = [[
local Players = game:GetService("Players")
local TextChatService = game:GetService("TextChatService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- ID hoạt ảnh chính xác của gói adidas aura R15
local adidasAuraIds = {
	idle = {"18903513386", "18903513386"},
	walk = "18903522201",
	run = "18903518384",
	jump = "18903515320",
	fall = "18903511874",
	climb = "18903510003",
	swim = "18903519881"
}

local function setupAdidasAura(char)
	local oldAnimate = char:FindFirstChild("Animate")
	if oldAnimate then
		oldAnimate:Destroy() -- Xóa bỏ kịch bản hoạt ảnh cũ đang bị lỗi xung đột
	end

	-- Khởi tạo kịch bản hoạt ảnh mới chuẩn R15 cấu trúc Roblox
	local newAnimate = Instance.new("LocalScript")
	newAnimate.Name = "Animate"

	local function createAnimFolder(name, ids)
		local folder = Instance.new("StringValue")
		folder.Name = name
		folder.Parent = newAnimate
		
		if type(ids) == "table" then
			for i, id in ipairs(ids) do
				local anim = Instance.new("Animation")
				anim.Name = name .. i
				anim.AnimationId = "rbxassetid://" .. id
				anim.Parent = folder
			end
		else
			local anim = Instance.new("Animation")
			anim.Name = name .. "Anim"
			anim.AnimationId = "rbxassetid://" .. ids
			anim.Parent = folder
		end
	end

	-- Nạp toàn bộ ID adidas aura vào kịch bản mới
	createAnimFolder("idle", adidasAuraIds.idle)
	createAnimFolder("walk", adidasAuraIds.walk)
	createAnimFolder("run", adidasAuraIds.run)
	createAnimFolder("jump", adidasAuraIds.jump)
	createAnimFolder("fall", adidasAuraIds.fall)
	createAnimFolder("climb", adidasAuraIds.climb)
	createAnimFolder("swim", adidasAuraIds.swim)

	newAnimate.Parent = char
	
	-- Kích hoạt lại Humanoid để nhận diện bộ hoạt ảnh mới ngay lập tức
	local humanoid = char:FindFirstChildOfClass("Humanoid")
	if humanoid then
		humanoid:ChangeState(Enum.HumanoidStateType.Land)
		for _, track in pairs(humanoid:GetPlayingAnimationTracks()) do
			track:Stop()
		end
	end
end

player.CharacterAdded:Connect(function(newCharacter)
	character = newCharacter
	task.wait(0.6)
	setupAdidasAura(character)
end)

----------------------------------------------------------------
-- GIAO DIỆN MENU (GUI) - HIỆN NGAY LẬP TỨC
----------------------------------------------------------------
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AdidasAuraMenuGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = player:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 260, 0, 140)
MainFrame.Position = UDim2.new(0.5, -130, 0.4, -70)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
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
Title.Text = "ADIDAS AURA TRY-ON"
Title.TextColor3 = Color3.fromRGB(0, 255, 128)
Title.TextSize = 15
Title.Font = Enum.Font.SourceSansBold
Title.Parent = MainFrame

local ApplyBtn = Instance.new("TextButton")
ApplyBtn.Size = UDim2.new(0, 180, 0, 40)
ApplyBtn.Position = UDim2.new(0.5, -90, 0.45, 0)
ApplyBtn.BackgroundColor3 = Color3.fromRGB(0, 128, 255)
ApplyBtn.BorderSizePixel = 0
ApplyBtn.Text = "BẬT ADIDAS AURA"
ApplyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ApplyBtn.TextSize = 14
ApplyBtn.Font = Enum.Font.SourceSansBold
ApplyBtn.Parent = MainFrame

local BtnCorner = Instance.new("UICorner")
BtnCorner.CornerRadius = UDim.new(0, 6)
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
		setupAdidasAura(character)
		ApplyBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
		ApplyBtn.Text = "ĐÃ KÍCH HOẠT"
		task.wait(1.5)
		ApplyBtn.BackgroundColor3 = Color3.fromRGB(0, 128, 255)
		ApplyBtn.Text = "BẬT ADIDAS AURA"
	end
end)
]]

assert(loadstring(scriptSource))()
