repeat task.wait() until game:IsLoaded()
local isfile = isfile or function(path)
	local suc, res = pcall(function() return readfile(path) end)
	return suc and res ~= nil 
end

local kavo
if isfile("BedWarsCode/Libraries/kavo.lua") then
  kavo = loadstring(readfile("BedWarsCode/Libraries/kavo.lua"))()
else
  kavo = loadstring(game:HttpGet("https://github.com/Sail100/BedWarsCode/blob/main/Libraries/kavo.lua", true))() 
end
shared.kavogui = kavo
local Sections = {}
shared.SectionsLoaded = Sections

local entityLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/7GrandDadPGN/VapeV4ForRoblox/main/Libraries/entityHandler.lua", true))()
shared.vapeentity = entityLibrary
local FunctionsLibrary = loadstring(game:HttpGet("https://github.com/Sail100/BedWarsCode/blob/main/Libraries/FunctionsHandler.lua", true))()
shared.funcslib = FunctionsLibrary

local queueteleport = queue_on_teleport

local TeleportString = [[
  loadstring(game:HttpGet("https://github.com/Sail100/BedWarsCode/blob/main/MainScript.lua", true))
]]

queueteleport(TeleportString)

if isfolder("BedWarsCode") == false then
	makefolder("BedWarsCode")
end

if isfolder("BedWarsCode/assets") == false then
	makefolder("BedwarsCode/assets")
end

if isfolder("BedWarsCode/Profiles") == false then
  makefolder("BedWarsCode/Profiles")
end
local AnyGame = [[
loadstring(game:HttpGet("https://raw.githubusercontent.com/NTDCore/NightbedForRoblox/main/AnyGame.lua",
true))()
]]
if isfolder("BedwarsCode/CustomModules") == false then
	makefolder("BedwarsCode/CustomModules")
end

function MainLoaded()
  local customModuleURL = "https://raw.githubusercontent.com/NTDCore/NightbedForRoblox/main/CustomModules/"..game.PlaceId..".lua"
  local customModuleScript = game:HttpGet(customModuleURL, true)
  if customModuleScript then
    local success, error = pcall(function()
      loadstring(customModuleScript)()
    end)
    if not success then
      warn("Failed To Loaded Modules: " .. tostring(error))
      loadstring(AnyGame)()
    end
  else
    loadstring(AnyGame)()
  end
end

--[[
function MainLoaded()
  if game:HttpGet("https://raw.githubusercontent.com/NTDCore/NightbedForRoblox/main/CustomModules/"..game.PlaceId..".lua") then
  	loadstring(game:HttpGet("https://raw.githubusercontent.com/NTDCore/NightbedForRoblox/main/CustomModules/"..game.PlaceId..".lua", true))()
  elseif isfile("Nightbed/CustomModules/"..game.PlaceId..".lua") then
    loadstring(readfile("Nightbed/CustomModules/"..game.PlaceId..".lua"))()
  else
    loadstring(game:HttpGet("https://raw.githubusercontent.com/NTDCore/NightbedForRoblox/main/AnyGame.lua"))()
  end
end
--]]

task.spawn(function()
  MainLoaded()
end)

if not shared.FuncsConnect then
  task.spawn(function()
  	repeat
  	  task.wait()
  		shared.FuncsConnect = true
  	until shared.FuncsConnect
  end)
end
