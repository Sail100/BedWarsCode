-- Vars--
local placeID = game.PlaceId

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
local CombatTabLobby = GameWin1:NewTab("Combat")
local BlatantTabLobby = GameWin1:NewTab("Blantant")
local RenderTabLobby = GameWin1:NewTab("Render")
local UtilityTabLobby = GameWin1:NewTab("Utility")
local WorldTabLobby = GameWin1:NewTab("World")
--Bedwars Doubles, Squads, LuckyBlock Squads, LuckyBlock Doubles, SkyWars Doubles
local CombatTabLobby = GameWin2:NewTab("Combat")
local BlatantTabLobby = GameWin2:NewTab("Blantant")
local RenderTabLobby = GameWin2:NewTab("Render")
local UtilityTabLobby = GameWin2:NewTab("Utility")
local WorldTabLobby = GameWin2:NewTab("World")
-- 30v30
local CombatTabLobby = GameWin3:NewTab("Combat")
local BlatantTabLobby = GameWin3:NewTab("Blantant")
local RenderTabLobby = GameWin3:NewTab("Render")
local UtilityTabLobby = GameWin3:NewTab("Utility")
local WorldTabLobby = GameWin3:NewTab("World")
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
