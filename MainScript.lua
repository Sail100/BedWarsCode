repeat task.wait() until game:IsLoaded()
local isfile = isfile or function(path)
	local suc, res = pcall(function() return readfile(path) end)
	return suc and res ~= nil 
end

local entityLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/7GrandDadPGN/VapeV4ForRoblox/main/Libraries/entityHandler.lua", true))()
shared.vapeentity = entityLibrary
local FunctionsLibrary = loadstring(game:HttpGet("https://github.com/Sail100/BedWarsCode/blob/main/Libraries/FunctionsHandler.lua", true))()
shared.funcslib = FunctionsLibrary

local queueteleport = queue_on_teleport

local TeleportString = [[
  loadstring(game:HttpGet("https://github.com/Sail100/BedWarsCode/blob/main/MainScript.lua", true))
]]

queueteleport(TeleportString)

if isfolder("BedWarsScript") == false then
	makefolder("BedWarsScript")
end

if isfolder("BedwarsScript/assets") == false then
	makefolder("BedWarsScript/assets")
end

if isfolder("BedwarsScript/Profiles") == false then
  makefolder("BedwarsScript/Profiles")
end
if isfolder("BedWarsScript/CustomModules") == false then
	makefolder("BedWarsScript/CustomModules")
end

function MainLoaded()
  local customModuleURL = "https://github.com/Sail100/BedWarsCode/tree/main/CustomModules/"..game.PlaceId..".lua"
  local customModuleScript = game:HttpGet(customModuleURL, true)
  if customModuleScript then
    local success, error = pcall(function()
      loadstring(customModuleScript)()
    end)
    if not success then
      warn("Failed To Loaded Modules: " .. tostring(error))
    end
  else
  end
end

--[[
function MainLoaded()
  if game:HttpGet("https://github.com/Sail100/BedWarsCode/tree/main/CustomModules/"..game.PlaceId..".lua") then
  	loadstring(game:HttpGet("https://github.com/Sail100/BedWarsCode/tree/main/CustomModules/"..game.PlaceId..".lua", true))()
  elseif isfile("BedWarsScript/CustomModules/"..game.PlaceId..".lua") then
    loadstring(readfile("BedWarsScript/CustomModules/"..game.PlaceId..".lua"))()
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
