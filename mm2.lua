getgenv().configs = getgenv().configs or {
    coinFarm = true,
	quickFarm = true, -- bật chế độ farm nhanh
    safeHeight = 100,
    murderDistance = 30,
    coinWaitTime = 2,
    loopDelay = 0.4,
    safeWaitTime = 2,
    resetInterval = 300,
    enableAutoReset = false,
	hopifnocandy = true,
	hoptime = 120,
    buybattlepass = false,
	openBox = true,
    coinNames = {"Coin_Server"},
	webhookurl = "https://discord.com/api/webhooks/1429819953137193091/4Icj-4ni_VhffPUmnRvxdhCXGdN_e2ePihMDTVbCAu1apkqooEhSEatqfTuJm591ANwf",
	pingOnRare = true,
    pingTarget = "1127942194955812994",
}

repeat task.wait() until game:IsLoaded()
repeat task.wait() until game:GetService("Players").LocalPlayer:GetAttribute("ClientLoaded")
if getgenv().MyMM2ScriptUI then return end
getgenv().MyMM2ScriptUI = true
getgenv().battlepasslock = false

function CheckKick(v)
    if v.Name == "ErrorPrompt" then
        if v.TitleFrame.ErrorTitle.Text == "Teleport Failed" then
            while task.wait() do end
        else
            game:GetService("TeleportService"):Teleport(game.PlaceId)
            v:Destroy()
        end
    end
end

game:GetService('CoreGui').RobloxPromptGui.promptOverlay.ChildAdded:Connect(CheckKick)

local Players = game:GetService('Players')
local RunService = game:GetService('RunService')
local localPlayer = Players.LocalPlayer
local processedCoins = {}
local currentMurder = nil
local isSafe = false
local circleMovement = nil
local currentCoinCenter = nil

Players.LocalPlayer.Idled:Connect(function()
	game:GetService("VirtualUser"):CaptureController()
	game:GetService("VirtualUser"):ClickButton2(Vector2.new())
end)

game:GetService("RunService"):Set3dRenderingEnabled(false)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = localPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true

local BlackFrame = Instance.new("Frame")
BlackFrame.Parent = ScreenGui
BlackFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
BlackFrame.BorderSizePixel = 0
BlackFrame.Size = UDim2.new(1, 0, 1, 0)
BlackFrame.Position = UDim2.new(0, 0, 0, 0)
BlackFrame.ZIndex = -1

local LogoFrame = Instance.new("Frame")
LogoFrame.Parent = ScreenGui
LogoFrame.BackgroundTransparency = 1
LogoFrame.Size = UDim2.new(0, 600, 0, 180) 
LogoFrame.Position = UDim2.new(0.5, -300, 0.5, -90)
LogoFrame.ZIndex = 10

local MainTitle = Instance.new("TextLabel")
MainTitle.Parent = LogoFrame
MainTitle.BackgroundTransparency = 1
MainTitle.Size = UDim2.new(1, 0, 0.5, 0)
MainTitle.Position = UDim2.new(0, 0, 0, 0)
MainTitle.Text = "⚔ LING ⚔"
MainTitle.TextColor3 = Color3.fromRGB(0, 255, 255)
MainTitle.TextScaled = true
MainTitle.Font = Enum.Font.GothamBold
MainTitle.TextStrokeTransparency = 0
MainTitle.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
MainTitle.ZIndex = 11

local SubTitle = Instance.new("TextLabel")
SubTitle.Parent = LogoFrame
SubTitle.BackgroundTransparency = 1
SubTitle.Size = UDim2.new(1, 0, 0.20, 0)
SubTitle.Position = UDim2.new(0, 0, 0.5, 0)
SubTitle.Text = "🎯 Murder Mystery 2 🎯"
SubTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
SubTitle.TextScaled = true
SubTitle.Font = Enum.Font.Gotham
SubTitle.ZIndex = 11

local CoinsLabel = Instance.new("TextLabel")
CoinsLabel.Parent = LogoFrame
CoinsLabel.BackgroundTransparency = 1
CoinsLabel.Size = UDim2.new(1, 0, 0.23, 0)
CoinsLabel.Position = UDim2.new(0, 0, 0.7, 10)
CoinsLabel.Text = "🍬: 0 (+0)"
CoinsLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
CoinsLabel.Font = Enum.Font.Gotham
CoinsLabel.TextScaled = true
CoinsLabel.ZIndex = 11

local RateLabel = Instance.new("TextLabel")
RateLabel.Parent = LogoFrame
RateLabel.BackgroundTransparency = 1
RateLabel.Size = UDim2.new(1, 0, 0.23, 0)
RateLabel.Position = UDim2.new(0, 0, 0.9, 10)
RateLabel.Text = "⚡ 0 Candy/min"
RateLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
RateLabel.Font = Enum.Font.Gotham
RateLabel.TextScaled = true
RateLabel.ZIndex = 11

task.spawn(function()
	local lastCandy = ProfileData.Materials.Owned[currency] or 0
	while task.wait(60) do
		local current = ProfileData.Materials.Owned[currency] or 0
		local gained = math.max(0, current - lastCandy)
		RateLabel.Text = "⚡ " .. tostring(gained) .. " Candy/min"
		lastCandy = current
	end
end)


local TimerLabel = Instance.new("TextLabel")
TimerLabel.Parent = LogoFrame
TimerLabel.BackgroundTransparency = 1
TimerLabel.Size = UDim2.new(1, 0, 0.20, 0)
TimerLabel.Position = UDim2.new(0, 0, 1.05, 0)
TimerLabel.Text = "⏲ 00:00:00"
TimerLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TimerLabel.Font = Enum.Font.GothamBold
TimerLabel.TextScaled = true
TimerLabel.ZIndex = 11

local RenderButton = Instance.new("TextButton")
RenderButton.Parent = ScreenGui
RenderButton.Size = UDim2.new(0, 80, 0, 80)
RenderButton.Position = UDim2.new(0, 50, 0.5, -40)
RenderButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
RenderButton.BorderSizePixel = 2
RenderButton.BorderColor3 = Color3.fromRGB(0, 255, 255)
RenderButton.Text = "💡"
RenderButton.TextColor3 = Color3.fromRGB(255, 255, 255)
RenderButton.TextScaled = true
RenderButton.Font = Enum.Font.GothamBold
RenderButton.ZIndex = 12

local isUIVisible = true
RenderButton.MouseButton1Click:Connect(function()
    isUIVisible = not isUIVisible
    
    if isUIVisible then
        game:GetService("RunService"):Set3dRenderingEnabled(false)
		if setfpscap then setfpscap(5) end -- Giới hạn FPS tiết kiệm CPU
        BlackFrame.Visible = true
        LogoFrame.Visible = true
        RenderButton.Text = "💡"
        RenderButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    else
        game:GetService("RunService"):Set3dRenderingEnabled(true)
        BlackFrame.Visible = false
        LogoFrame.Visible = false
        RenderButton.Text = "💡"
        RenderButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
    end
end)

local debounce = false

game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if debounce then return end

	if input.KeyCode == Enum.KeyCode.RightControl then
		debounce = true
		isUIVisible = not isUIVisible

		if isUIVisible then
			game:GetService("RunService"):Set3dRenderingEnabled(false)
			BlackFrame.Visible = true
			LogoFrame.Visible = true
			RenderButton.Text = "💡"
			RenderButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
		else
			game:GetService("RunService"):Set3dRenderingEnabled(true)
			BlackFrame.Visible = false
			LogoFrame.Visible = false
			RenderButton.Text = "💡"
			RenderButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
		end
		debounce = false
	end
end)

spawn(function()
    while task.wait(1) do
        for _, gui in pairs(game.Players.LocalPlayer.PlayerGui:GetChildren()) do
			if gui ~= ScreenGui and gui.Name ~= "ScreenGui" then
				gui.Enabled = false
			end
		end
    end
end)

local startTime = tick()
task.spawn(function()
	while task.wait(1) do
		local elapsed = tick() - startTime
		local h = math.floor(elapsed / 3600)
		local m = math.floor((elapsed % 3600) / 60)
		local s = math.floor(elapsed % 60)
		TimerLabel.Text = string.format("%02d:%02d:%02d", h, m, s)
	end
end)

function Hop()
    local success, response = pcall(function()
        return game:HttpGet("https://games.roblox.com/v1/games/" .. tostring(game.PlaceId) .. "/servers/Public?sortOrder=Asc&limit=100")
    end)
    if success then
        local jsonData = game:GetService("HttpService"):JSONDecode(response)
        if jsonData then
            for i = 1, #jsonData.data do
                k = jsonData.data[i].id
                if k and k ~= game.JobId then
                    game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, k, game:GetService("Players").LocalPlayer)
                end
            end
        end
    else
        warn(response)
    end
end

local EventInfoService = require(game:GetService("ReplicatedStorage"):WaitForChild("SharedServices"):WaitForChild("EventInfoService"))
local Sync = require(game:GetService("ReplicatedStorage"):WaitForChild("Database"):WaitForChild("Sync"))
local CoinCollected = game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Gameplay"):WaitForChild("CoinCollected")
local ProfileData = require(game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("ProfileData"))
local eventData = EventInfoService:GetCurrentEvent()
local battlepassData = EventInfoService:GetBattlePass()
local eventRemote = EventInfoService:GetEventRemotes()
local currency = eventData.Currency
local keyName = eventData.KeyName
local mysteryBox = eventData.MysteryBox.Name
local totalFarmed = 0
local lastChangeTime = tick()
local currentCoins = 0

CoinCollected.OnClientEvent:Connect(function(p11, p12, p13, _)
    lastChangeTime = tick()
    totalFarmed = totalFarmed + _.Value
    currentCoins = ProfileData.Materials.Owned[currency] or 0
    CoinsLabel.Text = "🍬: " .. tostring(currentCoins) .. " (+" .. totalFarmed .. ")"
    if p12 >= p13 then
        while task.wait(1) do
            Hop()
        end
    end
end)

task.spawn(function()
    while true do
        local success, err = pcall(function()
            if ProfileData and ProfileData.Materials and ProfileData.Materials.Owned then
                currentCoins = ProfileData.Materials.Owned[currency] or 0
                CoinsLabel.Text = "💡: " .. tostring(currentCoins) .. " (+" .. totalFarmed .. ")"
            end
        end)
        
        if not success then
            CoinsLabel.Text = "🍬: Error"
        end
        
        task.wait(10)
    end
end)

repeat task.wait() until Players.LocalPlayer and Players.LocalPlayer.PlayerGui

local LocalPlayer = Players.LocalPlayer

while LocalPlayer.PlayerGui:FindFirstChild("DeviceSelect") do 
	for i,v in pairs(getconnections(LocalPlayer.PlayerGui.DeviceSelect.Container.Phone.Button.MouseButton1Click)) do 
		v:Fire()
	end
end

local function teleportTo(targetCFrame)
	local character = Players.LocalPlayer.Character
	if character and character:FindFirstChild('HumanoidRootPart') then
		character.HumanoidRootPart.CFrame = targetCFrame
		return true
	end
	return false
end

local function startCircleMovement(centerPosition)
	if circleMovement then
		circleMovement:Disconnect()
	end

	currentCoinCenter = centerPosition
	local angle = 0
	local radius = 0.5
	local speed = 2

	circleMovement = RunService.Heartbeat:Connect(function()
		local character = Players.LocalPlayer.Character
		if character and character:FindFirstChild('HumanoidRootPart') and currentCoinCenter then
			angle = angle + speed * 0.1
			local x = currentCoinCenter.X + math.cos(angle) * radius
			local z = currentCoinCenter.Z + math.sin(angle) * radius
			character.HumanoidRootPart.CFrame = CFrame.new(x, currentCoinCenter.Y, z)
		end
	end)
end

local function stopCircleMovement()
	if circleMovement then
		circleMovement:Disconnect()
		circleMovement = nil
	end
	currentCoinCenter = nil
end

local function findMurder()
	for _, p in pairs(Players:GetPlayers()) do
		if p == Players.LocalPlayer then continue end
		local items = p.Backpack
		local character = p.Character
		if (items and items:FindFirstChild("Knife")) or (character and character:FindFirstChild("Knife")) then
			return p
		end
	end
	return nil
end

local function getDistanceToMurder()
	if not currentMurder or not currentMurder.Character then return math.huge end
	local myChar = Players.LocalPlayer.Character
	if not myChar or not myChar:FindFirstChild('HumanoidRootPart') then return math.huge end
	local murderChar = currentMurder.Character
	if not murderChar or not murderChar:FindFirstChild('HumanoidRootPart') then return math.huge end
	return (myChar.HumanoidRootPart.Position - murderChar.HumanoidRootPart.Position).Magnitude
end

local function flyToSafety()
	local character = Players.LocalPlayer.Character
	if character and character:FindFirstChild('HumanoidRootPart') then
		local currentPos = character.HumanoidRootPart.Position
		local safePos = Vector3.new(currentPos.X, currentPos.Y + getgenv().configs.safeHeight, currentPos.Z)
		character.HumanoidRootPart.CFrame = CFrame.new(safePos)
		isSafe = true
		stopCircleMovement()
	end
end

local function returnToGround()
	local character = Players.LocalPlayer.Character
	if character and character:FindFirstChild('HumanoidRootPart') then
		local raycast = workspace:Raycast(character.HumanoidRootPart.Position, Vector3.new(0, -1000, 0))
		if raycast then
			local groundPos = raycast.Position + Vector3.new(0, 5, 0)
			character.HumanoidRootPart.CFrame = CFrame.new(groundPos)
		end
		isSafe = false
	end
end

local function autoReset()
	while getgenv().configs.enableAutoReset do
		task.wait(getgenv().configs.resetInterval)
		if Players.LocalPlayer.Character then
			Players.LocalPlayer.Character:FindFirstChild("Humanoid").Health = 0
		end
	end
end

-- 🧠 Cache coin hiệu quả
local coinCache = {}

local function isCoin(obj)
	for _, coinName in ipairs(getgenv().configs.coinNames) do
		if obj.Name == coinName and obj:IsA("BasePart") then
			return true
		end
	end
	return false
end

-- Khi coin xuất hiện
workspace.DescendantAdded:Connect(function(obj)
	if isCoin(obj) then
		coinCache[obj] = true
	end
end)

-- Khi coin biến mất
workspace.DescendantRemoving:Connect(function(obj)
	if coinCache[obj] then
		coinCache[obj] = nil
	end
end)

-- Khởi tạo cache ban đầu
for _, obj in ipairs(workspace:GetDescendants()) do
	if isCoin(obj) then
		coinCache[obj] = true
	end
end

-- Trả danh sách coin hợp lệ
local function getAvailableCoins()
	local coins = {}
	for coin in pairs(coinCache) do
		if coin.Parent and not processedCoins[coin] then
			table.insert(coins, coin)
		end
	end
	return coins
end

-- Ưu tiên coin gần nhất
local function getClosestCoin(coins)
	local char = Players.LocalPlayer.Character
	if not (char and char:FindFirstChild("HumanoidRootPart")) then return nil end
	local rootPos = char.HumanoidRootPart.Position
	local closest, minDist = nil, math.huge

	for _, coin in ipairs(coins) do
		local dist = (coin.Position - rootPos).Magnitude
		if dist < minDist then
			minDist, closest = dist, coin
		end
	end
	return closest
end


local function coinFarm()
	-- 🔧 Chế độ farm nhanh
	if getgenv().configs.quickFarm then
		getgenv().configs.coinWaitTime = 1
		getgenv().configs.loopDelay = 0.2
	end

	while getgenv().configs.coinFarm do
		task.wait(getgenv().configs.loopDelay)

		if not LocalPlayer:GetAttribute("Alive") then
			task.wait(1)
			continue
		end

		currentMurder = findMurder()
		local distanceToMurder = getDistanceToMurder()

		-- Né murderer
		if distanceToMurder < getgenv().configs.murderDistance then
			if not isSafe then
				flyToSafety()
				task.wait(getgenv().configs.safeWaitTime)
			end
			continue
		elseif isSafe then
			returnToGround()
			task.wait(0.3)
		end

		-- 🔍 Tìm coin gần nhất
		local coins = getAvailableCoins()
		if #coins > 0 and not isSafe then
			local targetCoin = getClosestCoin(coins)
			if targetCoin and teleportTo(targetCoin.CFrame + Vector3.new(0, 2, 0)) then
				task.wait(0.1)
				startCircleMovement(targetCoin.Position)
				task.wait(math.max(0.4, getgenv().configs.coinWaitTime - 0.3))
				processedCoins[targetCoin] = true
				task.delay(1.8, function()
					processedCoins[targetCoin] = nil
				end)
			end
		else
			stopCircleMovement()
		end
	end
end


local function battlepass()
    if ProfileData then
        local cac = ProfileData[eventData.Title]
        if cac.CurrentTier < battlepassData.TotalTiers then
            getgenv().battlepasslock = true
            local coins = ProfileData.Materials.Owned[currency] or 0
            if coins >= battlepassData.TierCost then
                eventRemote.BuyTiers:FireServer(1)
				game.ReplicatedStorage.UpdateDataClient:Fire()
            end
        else
            getgenv().battlepasslock = false
        end
        for v_u_85, v86 in battlepassData.Rewards do
            local v94 = v_u_85
            local v95 = tostring(v94)
            local v96 = tonumber(v95)
            if not cac.ClaimedRewards[v95] and cac.CurrentTier >= v96 then
                print("lum")
                eventRemote.ClaimBattlePassReward:FireServer((v96))
            end
        end
    end
end

if getgenv().configs.buybattlepass then
	task.spawn(function()
		while task.wait(2) do
			battlepass()
		end
	end)
end

local function getimg(asset_id)
    local a, b = pcall(function()
        return game:GetService("HttpService"):JSONDecode(
            request({
                Url = "https://thumbnails.roblox.com/v1/assets?assetIds=" .. asset_id .. "&size=420x420&format=Png&isCircular=false",
                Method = "GET",
            }).Body
        ).data[1].imageUrl
    end)
    if a then
        return b
    else
        warn(b)
    end
end

local function openBox(resource)
	if ProfileData and ProfileData.Materials and ProfileData.Materials.Owned then
		local cost = Sync.Shop.Weapons[mysteryBox].Price[resource] or 0
		local owned = ProfileData.Materials.Owned[resource] or 0

		if owned >= cost and cost > 0 then
			local startTime = os.clock()
			local result = game:GetService("ReplicatedStorage").Remotes.Shop.OpenCrate:InvokeServer(mysteryBox, "MysteryBox", resource)
			task.wait(math.max(0, 0.75 - (os.clock() - startTime)))

			if result then
				local huhu = Sync.Weapons[result]
				local embed = {
					title = "Murder Mystery 2",
					author = { name = "LING" },
					color = 0x2f3136,
					fields = {
						{ name = "Username:", value = "```" .. Players.LocalPlayer.Name .. "```", inline = false },
						{ name = "Item Name:", value = "```" .. huhu.ItemName .. "```", inline = false },
						{ name = "Item Type:", value = "```" .. huhu.ItemType .. "```", inline = false },
						{ name = "Rarity:", value = "```" .. huhu.Rarity .. "```", inline = false },
					},
					footer = {
						text = "LING",
						icon_url = "https://media.discordapp.net/attachments/1397150080888209478/1431714914900381816/Ling.jpg"
					},
					thumbnail = { url = getimg(huhu.ItemID) },
					timestamp = DateTime.now():ToIsoDate()
				}

				-- ⚙️ Ping Godly/Chroma
				local shouldPing = getgenv().configs.pingOnRare
				local pingTarget = getgenv().configs.pingTarget or ""
				local rarity = (huhu.Rarity or "Unknown"):lower()
				local pingText = ""

				if shouldPing and (rarity == "godly" or rarity == "chroma") then
					pingText = "<@" .. pingTarget .. "> 🎉 Đã ra **" .. huhu.Rarity .. "**!"
				end

				local payload = {
					content = pingText,
					embeds = { embed },
					avatar_url = "https://media.discordapp.net/attachments/1397150080888209478/1431714914900381816/Ling.jpg",
					username = "LING",
				}

				local a, b = pcall(function()
					return request({
						Url = getgenv().configs.webhookurl,
						Method = "POST",
						Headers = { ["Content-Type"] = "application/json" },
						Body = game:GetService("HttpService"):JSONEncode(payload)
					})
				end)
				if not a then warn(b) end

				game:GetService("ReplicatedStorage").Remotes.Shop.BoxController:Fire(mysteryBox, result)
			end
			return true
		else
			return false
		end
	end
end

-- Auto mở box
if getgenv().configs.openBox then
	task.spawn(function()
		while task.wait(2) do
			if not getgenv().battlepasslock then
				openBox(currency)
			end
			openBox(keyName)
		end
	end)
end

-- Dọn coin đã xử lý
local function cleanupProcessedCoins()
	for coin, _ in pairs(processedCoins) do
		if not coin.Parent then
			processedCoins[coin] = nil
		end
	end
end

task.spawn(function()
	while true do
		task.wait(10)
		cleanupProcessedCoins()
	end
end)

task.spawn(autoReset)
task.spawn(coinFarm)

-- Auto hop nếu không nhặt được candy
if getgenv().configs.hopifnocandy then
	task.spawn(function()
		while task.wait() do
			if tick() - lastChangeTime > getgenv().configs.hoptime then
				Hop()
			end
		end
	end)
end

-- === HOP KHI CHẾT ===
task.spawn(function()
	local function setupDeathHop(character)
		local humanoid = character:WaitForChild("Humanoid")
		humanoid.Died:Connect(function()
			task.wait(2)
			Hop()
		end)
	end

	if Players.LocalPlayer.Character then
		setupDeathHop(Players.LocalPlayer.Character)
	end

	Players.LocalPlayer.CharacterAdded:Connect(setupDeathHop)
end)
-- === HẾT HOP KHI CHẾT ===
-- 🧩 Khôi phục khi teleport lỗi hoặc reload
task.spawn(function()
	while task.wait(10) do
		if not getgenv().MyMM2ScriptUI then
			-- ⚠️ Thay link này bằng link gốc của script bạn (nếu bạn lưu trên GitHub/Pastebin)
			loadstring(game:HttpGet("https://raw.githubusercontent.com/nguyenbaoxuyen2011/mm2kaitun/refs/heads/main/mm2.lua"))()
			break
		end
	end
end)

