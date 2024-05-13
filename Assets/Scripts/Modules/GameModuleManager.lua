--!Type(Module)
LobbyDataModule = require("LobbyData")
PlayerDataModule = require("PlayerData")
LobbyUIScript = nil

function SetHud(lobbyUIscript)
    LobbyUIScript = lobbyUIscript
    --print("Set UI HUD " .. LobbyUIScript.name)
end