--!Type(UI)
local GameManager = require("GameModuleManager").SetHud(self)
--!Bind
local myLabel : UILabel = nil

function setUILobbyCount(playerCount, maxPlayerCount)
    local message = "Player " .. tostring(playerCount) .. " / " .. tostring(maxPlayerCount)
    if myLabel then
        myLabel:SetPrelocalizedText(message, false) 
    else
        print("UILabel 'myLabel' is not initialized. Check the binding configuration.")
    end
end
