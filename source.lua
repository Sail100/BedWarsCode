-- Vars--
local placeID = game.PlaceId
local DuelsCombatSection = CombatTabDuels:NewSection("Combat")
local DuelsBlantantSection = BlatantTabDuels:NewSection("Blantant")
local InputService = game:GetService("UserInputService")
local playersService = game:GetService("Players")
local lplr = playersService.LocalPlayer
local cam = game:GetService("Workspace").CurrentCamera
local mainchar = lplr.Character
local replicatedStorageService = game:GetService("ReplicatedStorage")

local bedwars = {}
local bedwarsdata = {}

local function isAlive(plr)
  plr = plr or lplr
	if plr then
		return plr and plr.Character and plr.Character.Parent ~= nil and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character:FindFirstChild("Head") and plr.Character:FindFirstChild("Humanoid")
	end
end

local RunLoops = {RenderStepTable = {}, StepTable = {}, HeartTable = {}}
do
	function RunLoops:BindToRenderStep(name, num, func)
		if RunLoops.RenderStepTable[name] == nil then
			RunLoops.RenderStepTable[name] = game:GetService("RunService").RenderStepped:Connect(func)
		end
	end

	function RunLoops:UnbindFromRenderStep(name)
		if RunLoops.RenderStepTable[name] then
			RunLoops.RenderStepTable[name]:Disconnect()
			RunLoops.RenderStepTable[name] = nil
		end
	end

	function RunLoops:BindToStepped(name, num, func)
		if RunLoops.StepTable[name] == nil then
			RunLoops.StepTable[name] = game:GetService("RunService").Stepped:Connect(func)
		end
	end

	function RunLoops:UnbindFromStepped(name)
		if RunLoops.StepTable[name] then
			RunLoops.StepTable[name]:Disconnect()
			RunLoops.StepTable[name] = nil
		end
	end

	function RunLoops:BindToHeartbeat(name, num, func)
		if RunLoops.HeartTable[name] == nil then
			RunLoops.HeartTable[name] = game:GetService("RunService").Heartbeat:Connect(func)
		end
	end

	function RunLoops:UnbindFromHeartbeat(name)
		if RunLoops.HeartTable[name] then
			RunLoops.HeartTable[name]:Disconnect()
			RunLoops.HeartTable[name] = nil
		end
	end
end

local function hashvec(vec)
	return {value = vec}
end

local function getremote(tab)
	for i,v in pairs(tab) do
		if v == "Client" then
			return tab[i + 1]
		end
	end
	return ""
end

local KnitClient = debug.getupvalue(require(lplr.PlayerScripts.TS.knit).setup, 6)
	local Client = require(game:GetService("ReplicatedStorage").TS.remotes).default.Client
	local InventoryUtil = require(game:GetService("ReplicatedStorage").TS.inventory["inventory-util"]).InventoryUtil
	bedwars = {
		AttackRemote = getremote(debug.getconstants(getmetatable(KnitClient.Controllers.SwordController).sendServerRequest)),
		BlockController = require(game:GetService("ReplicatedStorage")["rbxts_include"]["node_modules"]["@easy-games"]["block-engine"].out).BlockEngine,
		BlockController2 = require(game:GetService("ReplicatedStorage")["rbxts_include"]["node_modules"]["@easy-games"]["block-engine"].out.client.placement["block-placer"]).BlockPlacer,
		BlockEngine = require(lplr.PlayerScripts.TS.lib["block-engine"]["client-block-engine"]).ClientBlockEngine,
		ChestController = KnitClient.Controllers.ChestController,
		ClientHandler = Client,
		getCurrentInventory = function(plr)
			local plr = plr or lplr
			local suc, result = pcall(function()
				return InventoryUtil.getInventory(plr)
			end)
			return (suc and result or {
				["items"] = {},
				["armor"] = {},
				["hand"] = nil
			})
		end,
		ItemMeta = debug.getupvalue(require(game:GetService("ReplicatedStorage").TS.item["item-meta"]).getItemMeta, 1),
		ItemTable = debug.getupvalue(require(replicatedStorageService.TS.item["item-meta"]).getItemMeta, 1),
		KnockbackUtil = require(game:GetService("ReplicatedStorage").TS.damage["knockback-util"]).KnockbackUtil,
		PickupMetdl = getremote(debug.getconstants(debug.getproto(KnitClient.Controllers.MetalDetectorController.KnitStart, 1))),
		PickupRemote = getremote(debug.getconstants(KnitClient.Controllers.ItemDropController.checkForPickup)),
		QueryUtil = require(replicatedStorageService["rbxts_include"]["node_modules"]["@easy-games"]["game-core"].out).GameQueryUtil,
		QueueCard = require(lplr.PlayerScripts.TS.controllers.global.queue.ui["queue-card"]).QueueCard,
		QueueMeta = require(replicatedStorageService.TS.game["queue-meta"]).QueueMeta,
		SprintCont = KnitClient.Controllers.SprintController,
		SwordController = KnitClient.Controllers.SwordController
	}
end)

local function targetCheck(plr, check)
	return (check and plr.Character.Humanoid.Health > 0 and plr.Character:FindFirstChild("ForceField") == nil or check == false)
end

local function isPlayerTargetable(plr, target)
	return plr.Team ~= lplr.Team and plr and isAlive(plr) and targetCheck(plr, target)
end

local function GetAllNearestHumanoidToPosition(distance, amount)
	local returnedplayer = {}
	local currentamount = 0
	if isAlive(lplr) then -- alive check
		for i,v in pairs(game.Players:GetChildren()) do -- loop through players
			if isPlayerTargetable((v), true, true, v.Character ~= nil) and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Head") and currentamount < amount then -- checks
				local mag = (lplr.Character.HumanoidRootPart.Position - v.Character:FindFirstChild("HumanoidRootPart").Position).magnitude
				if mag <= distance then -- mag check
					table.insert(returnedplayer, v)
					currentamount = currentamount + 1
				end
			end
		end
		for i2,v2 in pairs(game:GetService("CollectionService"):GetTagged("Monster")) do -- monsters
			if v2:FindFirstChild("HumanoidRootPart") and currentamount < amount and v2.Name ~= "Duck" then -- no duck
				local mag = (lplr.Character.HumanoidRootPart.Position - v2.HumanoidRootPart.Position).magnitude
				if mag <= distance then -- magcheck
					table.insert(returnedplayer, {Name = (v2 and v2.Name or "Monster"), UserId = 1443379645, Character = v2}) -- monsters are npcs so I have to create a fake player for target info
					currentamount = currentamount + 1
				end
			end
		end
		for i2,v2 in
		pairs(game:GetService("CollectionService"):GetTagged("DiamondGuardian")) do --monsters
			if v2:FindFirstChild("HumanoidRootPart") and currentamount < amount and
			v2.Name ~= "DiamondGuardian" then -- no duck
				local mag = (lplr.Character.HumanoidRootPart.Position - v2.HumanoidRootPart.Position).magnitude
				if mag <= distance then -- magcheck
					table.insert(returnedplayer, {Name = (v2 and v2.Name or "DiamondGuardian"), UserId = 1443379645, Character = v2}) -- monsters are npcs so I have to create a fake player for target info
					currentamount = currentamount + 1
				end
			end
		end
	end
	return returnedplayer -- table of attackable entities
end


local function playSound(id, volume) 
	local sound = Instance.new("Sound")
	sound.Parent = workspace
	sound.SoundId = id
	sound.PlayOnRemove = true 
	if volume then 
		sound.Volume = volume
	end
	sound:Destroy()
end

function SwitchTool(tool)
  game:GetService("ReplicatedStorage").rbxts_include.node_modules["@rbxts"].net.out._NetManaged.SetInvItem:InvokeServer({
    ["hand"] = tool,
  })
  repeat task.wait() until lplr.Character.HandInvItem == tool
end

local function playAnimation(id) 
	if lplr.Character.Humanoid.Health > 0 then 
		local animation = Instance.new("Animation")
		animation.AnimationId = id
		local animatior = lplr.Character.Humanoid.Animator
		animatior:LoadAnimation(animation):Play()
	end
end

local function getCurrentSword()
	local sword, swordslot, swordrank = nil, nil, 0
	for i5, v5 in pairs(bedwars.getCurrentInventory().items) do
		if v5.itemType:lower():find("sword") or v5.itemType:lower():find("blade") or v5.itemType:lower():find("dao") then
			if bedwars.ItemMeta[v5.itemType].sword.damage > swordrank then
				sword = v5
				swordslot = i5
				swordrank = bedwars.ItemMeta[v5.itemType].sword.damage
			end
		end
	end
	return sword, swordslot
end

-- Loadstring
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
-- Windows --
if placeID == 6872265039 then
 local LobbyWindow = Library.CreateLib("Bedwars -- Lobby", "Ocean")
end

if placeID == 8560631822 then
 local GameWin1 = Library.CreateLib("Bedwars -- Duels Or Solos", "Ocean")
end

if placeID == 6872274481 then
 local GameWin2 = Library.CreateLib("Bedwars - Game", "Ocean")
end

if placeID == 8444591321 then
 local GameWin3 = Library.CreateLib("Bedwars - 30v30", "Ocean")
end

-- Tabs --
-- Lobby
local CombatTabLobby = LobbyWindow:NewTab("Combat")
local BlatantTabLobby = LobbyWindow:NewTab("Blantant")
local RenderTabLobby = LobbyWindow:NewTab("Render")
local UtilityTabLobby = LobbyWindow:NewTab("Utility")
local WorldTabLobby = LobbyWindow:NewTab("World")
-- Duels or Solos--
local CombatTabDuels = GameWin1:NewTab("Combat")
local BlatantTabDuels = GameWin1:NewTab("Blantant")
local RenderTabDuels = GameWin1:NewTab("Render")
local UtilityTabDuels = GameWin1:NewTab("Utility")
local WorldTabDuels = GameWin1:NewTab("World")
--Bedwars Doubles, Squads, LuckyBlock Squads, LuckyBlock Doubles, SkyWars Doubles
local CombatTabDoubles = GameWin2:NewTab("Combat")
local BlatantTabDoubles = GameWin2:NewTab("Blantant")
local RenderTabDoubles = GameWin2:NewTab("Render")
local UtilityTabDoubles = GameWin2:NewTab("Utility")
local WorldTabDoubles = GameWin2:NewTab("World")
-- 30v30
local CombatTab = GameWin3:NewTab("Combat")
local BlatantTab  = GameWin3:NewTab("Blantant")
local RenderTab = GameWin3:NewTab("Render")
local UtilityTab = GameWin3:NewTab("Utility")
local WorldTab = GameWin3:NewTab("World")
-- Game Checker --
local GamesSupported = {
    ["6872265039"] = true, --Bedwars Lobby
    ["8560631822"] = true, --Bedwars Solos, Duels 2v2
    ["6872274481"] = true, --Bedwars Doubles, Squads, LuckyBlock Squads, LuckyBlock Doubles, SkyWars Doubles
    ["8444591321"] = true, --Bedwars 30vs30
    ["855499080"] = true, --Skywars
}

-- Code --

-- Lobby

-- Duels or Solos
local func
local func2
DuelsCombatSection:NewToggle("No Knockback", "Removes knockback.", function(state)
    if state then
    func = bedwars.KnockbackUtil.applyKnockbackDirection
				func2 = bedwars.KnockbackUtil.applyKnockback
				bedwars.KnockbackUtil.applyKnockbackDirection = function(...) end
				bedwars.KnockbackUtil.applyKnockback = function(...) end
    else
				bedwars.KnockbackUtil.applyKnockbackDirection = func
				bedwars.KnockbackUtil.applyKnockback = func2 
    end
end)


DuelsCombatSection:NewButton("HitFix", "Fix's raycast shit and gives more reach.", function()
    debug.setconstant(bedwars.SwordController.swingSwordAtMouse, 27, "raycast")
				debug.setupvalue(bedwars.SwordController.swingSwordAtMouse, 4, bedwars.QueryUtil)
end)

DuelsCombatSection:NewToggle("ClickDelay", "No slow clicks.", function(state)
    if state then
         func = bedwars.SwordController.isClickingTooFast
				     bedwars.SwordController.isClickingTooFast = function(self)
				   	self.lastSwing = tick()
					      return false
        end
 else
         bedwars.SwordController.isClickingTooFast = func
   end
end)

DuelsCombatSection:NewToggle("Sprint", "Sprint = true", function(state)
    if state then
          task.spawn(function()
					repeat
					task.wait()
					         	if (not bedwars.SprintCont.sprinting) then
					       		bedwars.SprintCont:startSprinting()
					      	   end
				  	until (not Sprint.Enabled)
	end)
    else
        bedwars.SprintCont:stopSprinting()
    end
end)

   local InfiniteJumpConnection
   local InfJump = true
   Section:NewToggle("Inf Jump", "Keep jumping.", function(state)
    if state then
        spawn(function()
    			InfiniteJumpConnection = InputService.JumpRequest:connect(function(jump)
		    		if InfJump then
		    			mainchar:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    				end
		    	end)
				end)
    else
       InfiniteJumpConnection:Disconnect() 
    end
end)

--Bedwars Doubles, Squads, LuckyBlock Squads, LuckyBlock Doubles, SkyWars Doubles


-- 30v30
