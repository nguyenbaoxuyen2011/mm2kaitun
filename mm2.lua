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
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
ScreenGui.DisplayOrder = 9999 

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
MainTitle.TextColor3 = Color3.new(0.000000, 1.000000, 0.082353)
MainTitle.TextScaled = true
MainTitle.Font = Enum.Font.GothamBold
MainTitle.TextStrokeTransparency = 0
MainTitle.TextStrokeColor3 = Color3.new(1.000000, 0.007843, 0.007843)
MainTitle.ZIndex = 11

local SubTitle = Instance.new("TextLabel")
SubTitle.Parent = LogoFrame
SubTitle.BackgroundTransparency = 1
SubTitle.Size = UDim2.new(1, 0, 0.20, 0)
SubTitle.Position = UDim2.new(0, 0, 0.5, 0)
SubTitle.Text = "👤" .. game.Players.LocalPlayer.Name
SubTitle.TextColor3 = Color3.new(0.035294, 0.886275, 1.000000)
SubTitle.TextScaled = true
SubTitle.Font = Enum.Font.Gotham
SubTitle.ZIndex = 11

local CoinsLabel = Instance.new("TextLabel")
CoinsLabel.Parent = LogoFrame
CoinsLabel.BackgroundTransparency = 1
CoinsLabel.Size = UDim2.new(1, 0, 0.23, 0)
CoinsLabel.Position = UDim2.new(0, 0, 0.7, 10)
CoinsLabel.Text = "🍬: 0 (+0)"
CoinsLabel.TextColor3 = Color3.new(0.054902, 0.992157, 0.556863)
CoinsLabel.Font = Enum.Font.Gotham
CoinsLabel.TextScaled = true
CoinsLabel.ZIndex = 11

local TimerLabel = Instance.new("TextLabel")
TimerLabel.Parent = LogoFrame
TimerLabel.BackgroundTransparency = 1
TimerLabel.Size = UDim2.new(1, 0, 0.20, 0)
TimerLabel.Position = UDim2.new(0, 0, 1.05, 0)
TimerLabel.Text = "⏲ 00:00:00"
TimerLabel.TextColor3 = Color3.new(1.000000, 1.000000, 1.000000)
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

-- ⚙️ Hop thông minh: không vào trùng server, clone tránh nhau
local serverVisited = {}
local HttpService = game:GetService("HttpService")

math.randomseed(tick() + tonumber(game.Players.LocalPlayer.UserId)) -- mỗi clone có seed riêng

function Hop()
	local placeId = game.PlaceId
	local success, response = pcall(function()
		return game:HttpGet("https://games.roblox.com/v1/games/" .. placeId .. "/servers/Public?sortOrder=Asc&limit=100")
	end)

	if not success then
		warn("[Hop] Lỗi khi tải danh sách server:", response)
		task.wait(5)
		return
	end

	local data = HttpService:JSONDecode(response)
	if not data or not data.data then return end

	local availableServers = {}

	-- lọc server hợp lệ, chưa join
	for _, info in ipairs(data.data) do
		if info.id ~= game.JobId and not serverVisited[info.id] and info.playing < info.maxPlayers then
			table.insert(availableServers, info.id)
		end
	end

	-- hết server → reset danh sách
	if #availableServers == 0 then
		serverVisited = {}
		for _, info in ipairs(data.data) do
			if info.id ~= game.JobId and info.playing < info.maxPlayers then
				table.insert(availableServers, info.id)
			end
		end
	end

	-- chọn ngẫu nhiên 1 server khác
	if #availableServers > 0 then
		local chosen = availableServers[math.random(1, #availableServers)]
		serverVisited[chosen] = true
		print("[Hop] Đang chuyển sang server khác:", chosen)
		game:GetService("TeleportService"):TeleportToPlaceInstance(placeId, chosen, game:GetService("Players").LocalPlayer)
	else
		warn("[Hop] Không có server hợp lệ để join.")
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

task.spawn(function()
    while getgenv().configs.autoHopLowPlayers do
        local playerCount = #game:GetService("Players"):GetPlayers()
        if playerCount < (getgenv().configs.minPlayers or 2) then
            warn("[Hop] Server chỉ có " .. tostring(playerCount) .. " người, hop sang server mới...")
            Hop()
        end
        task.wait(10)
    end
end)


CoinCollected.OnClientEvent:Connect(function(p11, p12, p13, _)
    lastChangeTime = tick()
    totalFarmed = totalFarmed + _.Value
    currentCoins = ProfileData.Materials.Owned[currency] or 0
    CoinsLabel.Text = "🍬: " .. tostring(currentCoins) .. " (+" .. totalFarmed .. ")"

    if getgenv().configs.hopWhenFullCandy and p12 >= p13 then
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
                CoinsLabel.Text = "🍬: " .. tostring(currentCoins) .. " (+" .. totalFarmed .. ")"
            end
        end)
        
        if not success then
            CoinsLabel.Text = "🍬: Error"
        end
        
        task.wait(10)
    end
end)

repeat task.wait() until Players.LocalPlayer and Players.LocalPlayer.PlayerGui
task.spawn(function()
	while task.wait(1) do
		local gui = game.Players.LocalPlayer:FindFirstChild("PlayerGui")
		if gui and gui:FindFirstChild("DeviceSelect") then
			local container = gui.DeviceSelect:FindFirstChild("Container")
			if container then
				local tabletBtn = container:FindFirstChild("Tablet") and container.Tablet:FindFirstChild("Button")
				local phoneBtn = container:FindFirstChild("Phone") and container.Phone:FindFirstChild("Button")

				local choice = math.random(1, 2)
				if choice == 1 and tabletBtn then
					for _, v in pairs(getconnections(tabletBtn.MouseButton1Click)) do
						v:Fire()
					end
					print("[AutoSelect] Clone chọn Tablet ✅")
				elseif phoneBtn then
					for _, v in pairs(getconnections(phoneBtn.MouseButton1Click)) do
						v:Fire()
					end
					print("[AutoSelect] Clone chọn Phone ✅")
				end
			end
		end
	end
end)


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

-- ⚙️ Cache coin hiệu quả
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



local function coinFarm()
	local lastTele = 0
	while getgenv().configs.coinFarm and task.wait(getgenv().configs.loopDelay or 0.1) do
		-- 💀 Né murderer
		currentMurder = findMurder()
		local distanceToMurder = getDistanceToMurder()

		if not LocalPlayer:GetAttribute("Alive") then
			task.wait(0.5)
			continue
		end

		if distanceToMurder < getgenv().configs.murderDistance then
			if not isSafe then
				flyToSafety()
				task.wait(getgenv().configs.safeWaitTime or 1.5)
			end
			continue
		elseif isSafe then
			returnToGround()
			task.wait(0.2)
		end

		-- 🪙 Lấy danh sách coin
		local coins = getAvailableCoins()
		if #coins > 0 then
			local char = LocalPlayer.Character
			local hrp = char and char:FindFirstChild("HumanoidRootPart")
			if hrp then
				local rootPos = hrp.Position
				table.sort(coins, function(a, b)
    				return (a.Position - rootPos).Magnitude < (b.Position - rootPos).Magnitude
				end)

				local pickRange = math.min(3, #coins)
				local targetCoin = coins[math.random(1, pickRange)]

				if not targetCoin then continue end

				processedCoins[targetCoin] = true

				-- ⚙️ Smart teleport để tránh rejoin
				if tick() - lastTele > 0.12 then
					lastTele = tick()
					hrp.CFrame = targetCoin.CFrame + Vector3.new(0, 2, 0)
				end

				startCircleMovement(targetCoin.Position)
				task.wait(getgenv().configs.coinWaitTime or 0.15)
				stopCircleMovement()

				task.spawn(function()
					task.wait(2)
					processedCoins[targetCoin] = nil
				end)
			end
		else
			-- 🧩 Không có coin → "refresh" vị trí để tránh stuck
			local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
			if hrp then
				hrp.CFrame = hrp.CFrame + Vector3.new(0, 1, 0)
			end
			task.wait(0.2)
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

task.spawn(function()
	autoReset()
end)

task.spawn(function()
	coinFarm()
end)

if getgenv().configs.hopifnocandy then
    task.spawn(function()
        while task.wait() do
            if tick() - lastChangeTime > getgenv().configs.hoptime then
                while task.wait(1) do
                    Hop()
                end
            end
        end
    end)
end
