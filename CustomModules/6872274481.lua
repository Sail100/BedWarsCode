-- Vars--
local placeID = game.PlaceId




-- Duels
local DuelsCombatSection = CombatTabDuels:NewSection("Combat")
local DuelsBlantantSection = BlatantTabDuels:NewSection("Blantant")
local DuelsUl = UiltlityTabDuels:NewSection("Uiltlity")
local DuelsWorld = WorldTabDuels:NewSection("World")
-- Lobby
local LobbyCombat = CombatTabLobby:NewSection("Combat")
local LobbyBlantant = BlatantTabLobby:NewSection("Blantant")
local LobbyUl = UiltlityTabLobby:NewSection("Uiltlity")
local LobbyWorld = WorldTabLobby:NewSection("World")LobbyWorld = WorldTabLobby:NewSection("World")

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
local UtilityTabLobby = LobbyWindow:NewTab("Utility")
local WorldTabLobby = LobbyWindow:NewTab("World")
-- Duels or Solos--
local CombatTabDuels = GameWin1:NewTab("Combat")
local RenderTabDuels = GameWin1:NewTab("Render")
local UtilityTabDuels = GameWin1:NewTab("Utility")
local WorldTabDuels = GameWin1:NewTab("World")
--Bedwars Doubles, Squads, LuckyBlock Squads, LuckyBlock Doubles, SkyWars Doubles
local CombatTabDoubles = GameWin2:NewTab("Combat")
local BlatantTabDoubles = GameWin2:NewTab("Blantant")
local UtilityTabDoubles = GameWin2:NewTab("Utility")
local WorldTabDoubles = GameWin2:NewTab("World")
-- 30v30
local CombatTab = GameWin3:NewTab("Combat")
local BlatantTab  = GameWin3:NewTab("Blantant")
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

-- Lobby --
LobbyCombat:NewToggle("Sprint", "Sprint = true", function(state)
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
   DuelsBlantantSection:NewToggle("Inf Jump", "Keep jumping.", function(state)
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


local KillauraNoSwing = {Enabled = false}
	local KillauraNoSound = {Enabled = false}
	local killaurarange = {Value = 23}
	local Killaura = {Enabled = false}
	local killauraremote = bedwars.ClientHandler:Get(bedwars.AttackRemote)
	local function attackEntity(plr)
		local root = plr.Character.HumanoidRootPart
		if not root then
			return nil
		end
		local selfrootpos = lplr.Character.HumanoidRootPart.Position
		local selfpos = selfrootpos + (killaurarange.Value > 14 and (selfrootpos - root.Position).magnitude > 14 and (CFrame.lookAt(selfrootpos, root.Position).lookVector * 4) or Vector3.zero)
		local sword = getCurrentSword()
		killauraremote:SendToServer({
			["weapon"] = sword ~= nil and sword.tool,
			["entityInstance"] = plr.Character,
			["validate"] = {
				["raycast"] = {
					["cameraPosition"] = hashvec(cam.CFrame.Position),
					["cursorDirection"] = hashvec(Ray.new(cam.CFrame.Position, root.CFrame.Position).Unit.Direction)
				},
				["targetPosition"] = hashvec(root.CFrame.Position),
				["selfPosition"] = hashvec(selfpos)
			},
			["chargedAttack"] = {
				["chargeRatio"] = 0}
		})
		if not KillauraNoSwing.Enabled then
			if Killaura.Enabled then
				playAnimation("rbxassetid://4947108314")
			end
		end
		if not KillauraNoSound.Enabled then
			if Killaura.Enabled then
				playSound("rbxassetid://6760544639", 0.5)
			end
		end
	end
DuelsBlantantSection:NewToggle("Killaura", "u should know", function(state)
    if state then
       RunLoops:BindToHeartbeat("Killaura", 1, function()
					local plrs = GetAllNearestHumanoidToPosition(killaurarange.Value - 0.0001, 1)
					SwitchTool(getCurrentSword().tool)
					for i,plr in pairs(plrs) do
						task.spawn(attackEntity, plr)
					end
				end) 
    else
        RunLoops:UnbindFromHeartbeat("Killaura")
    end
end)
DuelsBlantantSection:NewToggle("NoFall", "", function(state)
    if state then
       task.spawn(function()
					repeat
						task.wait()
						game:GetService("ReplicatedStorage").rbxts_include.node_modules["@rbxts"].net.out._NetManaged.GroundHit:FireServer()
					until (not NoFall.Enabled)
				end) 
    else
        print("E")
    end
end)

local antivoidpart
	local antivoidconnection
	local antivoiding = false
	local antitransparent = {Value = 50}
	local anticolor = {["Hue"] = 0.44, ["Sat"] = 1, ["Value"] = 1}
	local AntiVoid = {Enabled = false}
      DuelsUl:NewToggle("AntiVoid", "", function(state)
    if state then
					task.spawn(function()
			
					antivoidpart = Instance.new("Part")
					antivoidpart.CanCollide = false
					antivoidpart.Size = Vector3.new(10000, 1, 10000)
					antivoidpart.Anchored = true
					antivoidpart.Material = Enum.Material.Neon
					antivoidpart.Color = Color3.fromHSV(anticolor["Hue"], anticolor["Sat"], anticolor["Value"])
					antivoidpart.Transparency = 1 - (antitransparent.Value / 100)
					antivoidpart.Position = lplr.Character.HumanoidRootPart.Position - Vector3.new(0, 21, 0)
					antivoidpart.Parent = workspace
					antivoidconnection = antivoidpart.Touched:Connect(function(touched)
						if touched.Parent == lplr.Character and isAlive(lplr) then
							if (not antivoiding) and lplr.Character.Humanoid.Health > 0 then
								antivoiding = true
								lplr.Character.HumanoidRootPart.Velocity = Vector3.new(0, 150, 0)
								antivoiding = false
							  end
							end
						end
					end)
    else
        if antivoidconnection then antivoidconnection:Disconnect() end
					if antivoidpart then
	end					antivoidpart:Remove()
    end
end)
	
local params = RaycastParams.new()
  params.IgnoreWater = true
  function BreakFunction(part)
    local raycastResult = game:GetService("Workspace"):Raycast(part.Position + Vector3.new(0,24,0),Vector3.new(0,-27,0),params)
    if raycastResult then
      local targetblock = raycastResult.Instance
      for i,v in pairs(targetblock:GetChildren()) do
        if v:IsA("Texture") then
          v:Destroy()
        end
      end
      replicatedStorageService.rbxts_include.node_modules["@easy-games"]["block-engine"].node_modules["@rbxts"].net.out._NetManaged.DamageBlock:InvokeServer({
        ["blockRef"] = {
          ["blockPosition"] = Vector3.new(math.round(targetblock.Position.X/3),math.round(targetblock.Position.Y/3),math.round(targetblock.Position.Z/3))
        },
        ["hitPosition"] = Vector3.new(math.round(targetblock.Position.X/3),math.round(targetblock.Position.Y/3),math.round(targetblock.Position.Z/3)),
        ["hitNormal"] = Vector3.new(math.round(targetblock.Position.X/3),math.round(targetblock.Position.Y/3),math.round(targetblock.Position.Z/3))
      })
    end
  end
  function GetBeds()
    local beds = {}
    for i,v in pairs(game:GetService("Workspace"):GetChildren()) do
      if string.lower(v.Name) == "bed" and v:FindFirstChild("Covers") ~= nil and v:FindFirstChild("Covers").BrickColor ~= lplr.Team.TeamColor then
        table.insert(beds,v)
      end
    end
    return beds
  end
  local BreakerRange = {Value = 30}
  local Breaker = {Enabled = false}
DuelsWorld:NewToggle("Nuker", "Breaks beds.", function(state)
    if state then
        task.spawn(function()
          while task.wait() do
            if not Breaker.Enabled then return end
            task.spawn(function()
              if lplr:GetAttribute("DenyBlockBreak") == true then
                lplr:SetAttribute("DenyBlockBreak",nil)
              end
            end)
            if isAlive() then
              local beds = GetBeds()
              for i,v in pairs(beds) do
                local mag = (v.Position - lplr.Character.PrimaryPart.Position).Magnitude
                if mag < BreakerRange.Value then
                  BreakFunction(v)
                end
              end
            end
          end
        end)
    else
        print("Toggle Off")
    end
end)

--Bedwars Doubles, Squads, LuckyBlock Squads, LuckyBlock Doubles, SkyWars Doubles


-- 30v30

spawn(function()
	repeat
	  wait(0.5)
		writefile("BedWarsScript/Profiles/6872274481.json",game:GetService("HttpService"):JSONEncode(Settings))
	until false
end)
local suc, res = pcall(function()
	return game:GetService("HttpService"):JSONDecode(readfile("BedWarsScript/Profiles/6872274481.json"))
end)
