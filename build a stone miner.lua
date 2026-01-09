local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = game:GetService("Players").LocalPlayer
local MainF = ReplicatedStorage.MainF
local MainR = ReplicatedStorage.Main

local Optionss = {"Cobalt", "Diamond", "Gold", "Herostone", "Platinum", "Pyroium", "Voidium", "Uranium"}
local AMOUNT_TO_GIVE = 300

local GivingMoney = false
local GivingTickets = false
local SpinningWheel = false
local GivingChests = false
local OpeningChests = false
local AutoPlotting = false
local GivingOres = {Cobalt = false, Diamond = false, Gold = false, Herostone = false, Platinum = false, Pyroium = false, Voidium = false, Uranium = false}

local function ToggleTickets(value)
	GivingTickets = value
	if not value then return end
	task.spawn(function()
		while GivingTickets do
			for i = 1, AMOUNT_TO_GIVE do
				if not GivingTickets then break end
				task.spawn(function()
					if GivingTickets then
						MainF:InvokeServer("gainChest", "Ticket", 1)
					end
				end)
			end
			task.wait()
		end
	end)
end

local function ToggleMoney(value)
	GivingMoney = value
	if not value then return end
	task.spawn(function()
		while GivingMoney do
			local MaxEarn = 50000
			local mainGui = LocalPlayer.PlayerGui:FindFirstChild("Main")
			if mainGui then
				local frame = mainGui:FindFirstChild("Frame")
				if frame then
					local VA = frame:FindFirstChild("VA")
					if VA then
						local splitText = string.split(VA.Text, "/")
						MaxEarn = tonumber(splitText[2]) or 50000
					end
				end
			end
			task.spawn(function()
				if GivingMoney then
					MainF:InvokeServer("earned", MaxEarn)
				end
			end)
			task.wait()
		end
	end)
end

local function ToggleOreLoop()
    while true do
        local activeList = {}
        for oreName, isEnabled in GivingOres do
            if isEnabled then
                table.insert(activeList, oreName)
            end
        end

        if #activeList == 0 then break end

        for i = 1, AMOUNT_TO_GIVE do
            local currentActive = {}
            for oreName, isEnabled in GivingOres do
                if isEnabled then table.insert(currentActive, oreName) end
            end
            if #currentActive == 0 then break end

            local randomOre = currentActive[math.random(1, #currentActive)]
            
            task.spawn(function()
                MainR:FireServer("gainedOre", randomOre)
            end)
        end
        
        task.wait()
    end
end

local function ToggleAllOres(selectedTable)
    local wasAnyActive = false
    for _, isEnabled in GivingOres do
        if isEnabled then wasAnyActive = true break end
    end

    for _, oreName in Optionss do
        GivingOres[oreName] = table.find(selectedTable, oreName) ~= nil
    end

    local isAnyActiveNow = #selectedTable > 0

    if isAnyActiveNow and not wasAnyActive then
        task.spawn(ToggleOreLoop)
    end
end

local function ToggleWheelSpin(value)
	SpinningWheel = value
	if not value then return end
	task.spawn(function()
		while SpinningWheel do
			for i = 1, math.floor(AMOUNT_TO_GIVE/2) do
				if not SpinningWheel then break end
				task.spawn(function()
					if SpinningWheel then
						MainF:InvokeServer("attemptSpin")
						task.wait()
						MainF:InvokeServer("claimSpinReward")
					end
				end)
			end
			task.wait()
		end
	end)
end

local function ToggleChests(value)
	GivingChests = value
	if not value then return end
	task.spawn(function()
		while GivingChests do
			for i = 1, AMOUNT_TO_GIVE do
				if not GivingChests then break end
				task.spawn(function()
					if GivingChests then
						MainF:InvokeServer("gainChest", "Golden", 1)
					end
				end)
			end
			task.wait()
		end
	end)
end

local function ToggleOpenChests(value)
	OpeningChests = value
	if not value then return end
	task.spawn(function()
		while OpeningChests do
			for i = 1, AMOUNT_TO_GIVE do
				if not OpeningChests then break end
				task.spawn(function()
					if OpeningChests then
						MainF:InvokeServer("openChest")
					end
				end)
			end
			task.wait()
		end
	end)
end

local function ToggleAutoPlot(Value)
    AutoPlotting = Value
	if not Value then return end
	while AutoPlotting do
		MainR:FireServer("plotdone")
		task.wait(0.05)
	end
end

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Build a Stone Miner! ⚒️",
   Icon = 0, -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
   LoadingTitle = "Loading miner",
   LoadingSubtitle = "by System",
   ShowText = "Rayfield", -- for mobile users to unhide rayfield, change if you'd like
   Theme = "Default", -- Check https://docs.sirius.menu/rayfield/configuration/themes

   ToggleUIKeybind = "K", -- The keybind to toggle the UI visibility (string like "K" or Enum.KeyCode)

   DisableRayfieldPrompts = true,
   DisableBuildWarnings = true, -- Prevents Rayfield from warning when the script has a version mismatch with the interface

   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil, -- Create a custom folder for your hub/game
      FileName = "Big Hub"
   },

   Discord = {
      Enabled = true, -- Prompt the user to join your Discord server if their executor supports it
      Invite = "2xwvmHSjAJ", -- The Discord invite code, do not include discord.gg/. E.g. discord.gg/ ABCD would be ABCD
      RememberJoins = true -- Set this to false to make them join the discord every time they load it up
   },

   KeySystem = false, -- Set this to true to use our key system
   KeySettings = {
      Title = "Untitled",
      Subtitle = "Key System",
      Note = "No method of obtaining the key is provided", -- Use this to tell the user how to get a key
      FileName = "Key", -- It is recommended to use something unique as other scripts using Rayfield may overwrite your key file
      SaveKey = true, -- The user's key will be saved, but if you change the key, they will be unable to use your script
      GrabKeyFromSite = false, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
      Key = {"Hello"} -- List of keys that will be accepted by the system, can be RAW file links (pastebin, github etc) or simple strings ("hello","key22")
   }
})

local Tab1 = Window:CreateTab("Credits", 4483362458)
Tab1:CreateParagraph({Title = "By System", Content = "The code is open source, joined the discord for more."})

local Tab2 = Window:CreateTab("Main", 4483362458)

local Paragraph = Tab2:CreateParagraph({Title = "How to get more money", Content = "Every second or so you get money as if you completed the whole plot. Mine the whole plot area to unlock the next one and ger more money."})
Tab2:CreateToggle({
	Name = "Give Money",
	CurrentValue = false,
	Flag = "",
	Callback = ToggleMoney
})

Tab2:CreateToggle({
	Name = "Give Tickets",
	CurrentValue = false,
	Flag = "",
	Callback = ToggleTickets
})

Tab2:CreateToggle({
	Name = "Wheel Spin",
	CurrentValue = false,
	Flag = "",
	Callback = ToggleWheelSpin
})

Tab2:CreateToggle({
	Name = "Give Chests",
	CurrentValue = false,
	Flag = "",
	Callback = ToggleChests
})

Tab2:CreateToggle({
	Name = "Open Chests",
	CurrentValue = false,
	Flag = "",
	Callback = ToggleOpenChests
})

local Paragraph = Tab2:CreateParagraph({Title = "How does this work", Content = "Does the same as clearing the plot. Keep this on a bit then you can use the money generator to get tons more money."})
Tab2:CreateToggle({
	Name = "Autoplot",
	CurrentValue = false,
	Flag = "",
	Callback = ToggleAutoPlot
})

Tab2:CreateDropdown({
	Name = "Give Ores",
	Options = Optionss,
	CurrentOption = {},
	MultipleOptions = true,
	Flag = "OreDropdown",
	Callback = ToggleAllOres,
})

local Paragraph = Tab2:CreateParagraph({Title = "How does this work", Content = "Bigger number = you get more stuff but more lag. Default = 10"})
Tab2:CreateSlider({
	Name = "How Much Each Frame",
	Range = {1, 30},
	Increment = 1,
	Suffix = "Actions",
	CurrentValue = 10,
	Flag = "HowMuch",
	Callback = function(Value)
		AMOUNT_TO_GIVE = Value
	end,
})

local Button = Tab2:CreateButton({
   Name = "Infinite Yield Admin",
   Callback = function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
   end,
})



