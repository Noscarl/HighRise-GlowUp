--!Type(Module)
local GameManager = require("GameModuleManager")

lobbyMaxPlayerCount = 3
lobbyPlayerCount = 0

lobbyTimer = 10
charSelectTimer = 20

local runwayCategories = {
    "Idol",
    "Street Style",
    "Glam Night",
    "Sporty Chic",
    "Retro Rewind",
    "Fantasy Characters",
    "Beachwear",
    "Winter Wonderland",
    "Eco-Friendly",
    "Mix and Match"
}


function setPlayerCount(player)
    lobbyPlayerCount = player
    GameManager.LobbyUIScript.setUILobbyCount(lobbyPlayerCount, lobbyMaxPlayerCount)
end
