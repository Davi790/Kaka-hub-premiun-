-- 📌 Kaka Premium Script (Mobile + PC) - UI centralizada e arrastável

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local savedPosition = nil

-- GUI principal
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "KakaPremium"
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Fundo preto Doing Steal
local effectFrame = Instance.new("Frame")
effectFrame.Size = UDim2.new(1,0,1,0)
effectFrame.BackgroundColor3 = Color3.new(0,0,0)
effectFrame.BackgroundTransparency = 1
effectFrame.Visible = false
effectFrame.ZIndex = 1
effectFrame.Parent = screenGui

local effectText = Instance.new("TextLabel")
effectText.Size = UDim2.new(1,0,1,0)
effectText.Text = "DOING STEAL"
effectText.TextColor3 = Color3.new(1,1,1)
effectText.BackgroundTransparency = 1
effectText.TextScaled = true
effectText.ZIndex = 2
effectText.Parent = effectFrame

-- Fundo preto Salvando Posição
local saveEffect = Instance.new("Frame")
saveEffect.Size = UDim2.new(1,0,1,0)
saveEffect.BackgroundColor3 = Color3.new(0,0,0)
saveEffect.BackgroundTransparency = 1
saveEffect.Visible = false
saveEffect.ZIndex = 1
saveEffect.Parent = screenGui

local saveText = Instance.new("TextLabel")
saveText.Size = UDim2.new(1,0,0.5,0)
saveText.Position = UDim2.new(0,0,0.3,0)
saveText.Text = "SALVANDO POSIÇÃO"
saveText.TextColor3 = Color3.new(1,1,1)
saveText.BackgroundTransparency = 1
saveText.TextScaled = true
saveText.ZIndex = 2
saveText.Parent = saveEffect

local saveSub = Instance.new("TextLabel")
saveSub.Size = UDim2.new(1,0,0.2,0)
saveSub.Position = UDim2.new(0,0,0.6,0)
saveSub.Text = "Espere..."
saveSub.TextColor3 = Color3.fromRGB(200,200,200)
saveSub.BackgroundTransparency = 1
saveSub.TextScaled = true
saveSub.ZIndex = 2
saveSub.Parent = saveEffect

-- Frame principal da UI
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 220, 0, 260)
frame.AnchorPoint = Vector2.new(0.5,0.5)
frame.Position = UDim2.new(0.5,0,0.5,0)
frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
frame.BackgroundTransparency = 0.2
frame.Active = true
frame.Visible = false
frame.Parent = screenGui

-- Tornar arrastável (PC e mobile) para frame
local dragging, dragInput, dragStart, startPos
frame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = frame.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

frame.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		local delta = input.Position - dragStart
		frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
			startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)

-- Criador de botões
local function createButton(text, color, yPos)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0.8,0,0,40)
	btn.Position = UDim2.new(0.1,0,yPos,0)
	btn.BackgroundColor3 = Color3.fromRGB(0,0,0)
	btn.Text = text
	btn.TextScaled = true
	btn.TextColor3 = color
	btn.Font = Enum.Font.FredokaOne
	btn.Parent = frame
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(1,0)
	corner.Parent = btn
	return btn
end

-- Botões
local saveButton = createButton("Salvar Posição", Color3.fromRGB(0,200,0), 0.1)
local tpButton = createButton("Teleportar", Color3.fromRGB(0,150,255), 0.3)
local guideButton = createButton("Teleguiado", Color3.fromRGB(255,200,0), 0.5)
local closeButton = createButton("Fechar", Color3.fromRGB(255,50,50), 0.7)

-- Botão circular para abrir (centralizado)
local openButton = Instance.new("TextButton")
openButton.Size = UDim2.new(0,60,0,60)
openButton.AnchorPoint = Vector2.new(0.5,0.5)
openButton.Position = UDim2.new(0.5,0,0.5,0)
openButton.BackgroundColor3 = Color3.fromRGB(0,0,0)
openButton.Text = "K"
openButton.TextScaled = true
openButton.TextColor3 = Color3.fromRGB(0,255,255)
openButton.Parent = screenGui
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0.5,0)
corner.Parent = openButton

-- Tornar botão circular arrastável
local draggingBtn, dragInputBtn, dragStartBtn, startPosBtn
openButton.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		draggingBtn = true
		dragStartBtn = input.Position
		startPosBtn = openButton.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				draggingBtn = false
			end
		end)
	end
end)

openButton.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		dragInputBtn = input
	end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
	if input == dragInputBtn and draggingBtn then
		local delta = input.Position - dragStartBtn
		openButton.Position = UDim2.new(startPosBtn.X.Scale, startPosBtn.X.Offset + delta.X,
			startPosBtn.Y.Scale, startPosBtn.Y.Offset + delta.Y)
	end
end)

-- Funções dos botões
saveButton.MouseButton1Click:Connect(function()
	local character = player.Character or player.CharacterAdded:Wait()
	local root = character:WaitForChild("HumanoidRootPart")
	savedPosition = root.CFrame

	-- Esconder UI
	frame.Visible = false
	openButton.Visible = false

	saveEffect.Visible = true
	TweenService:Create(saveEffect, TweenInfo.new(0.2), {BackgroundTransparency = 0}):Play()
	task.wait(1.2)
	TweenService:Create(saveEffect, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
	task.wait(0.5)
	saveEffect.Visible = false

	-- Mostrar UI novamente
	frame.Visible = true
	openButton.Visible = true
end)

tpButton.MouseButton1Click:Connect(function()
	if savedPosition then
		local character = player.Character or player.CharacterAdded:Wait()
		local root = character:WaitForChild("HumanoidRootPart")

		-- Esconder UI
		frame.Visible = false
		openButton.Visible = false

		effectFrame.Visible = true
		for i = 1,3 do
			TweenService:Create(effectFrame, TweenInfo.new(0.2), {BackgroundTransparency = 0}):Play()
			task.wait(0.4)
			root.CFrame = savedPosition + Vector3.new(0,2,0)
			TweenService:Create(effectFrame, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
			task.wait(0.4)
		end
		effectFrame.Visible = false

		-- Mostrar UI novamente
		frame.Visible = true
		openButton.Visible = true
	end
end)

guideButton.MouseButton1Click:Connect(function()
	if savedPosition then
		local character = player.Character or player.CharacterAdded:Wait()
		local root = character:WaitForChild("HumanoidRootPart")
		local distance = (savedPosition.Position - root.Position).Magnitude
		local steps = math.min(100, math.floor(distance / 10))
		for i = 1, steps do
			root.CFrame = root.CFrame:Lerp(savedPosition, i/steps)
			task.wait(0.05)
		end
	end
end)

closeButton.MouseButton1Click:Connect(function()
	frame.Visible = false
end)

openButton.MouseButton1Click:Connect(function()
	frame.Visible = true
end)
