--!Type(ClientAndServer)
local GameManager = require("GameModuleManager")

local lobbyPlayerCountRequest = Event.new("LobbyPlayerCountRequest")
local startContest = Event.new("StartContest")

local setPlayerSetting = Event.new("SetPlayerSetting")
local setLobbyCount = Event.new("SetLobbyCount")

local lobbyQueue = {}
local minPlayers = 3

-- Client
function self:ClientAwake()
    
    lobbyPlayerCountRequest:FireServer(#lobbyQueue)
    startContest:Connect(function(arg) 
        onStartContest(arg)
    end)
    setPlayerSetting:Connect(function(arg1, arg2) 
        onLocalPlayerData(arg1)
    end)
    setLobbyCount:Connect(function(arg) 
        GameManager.LobbyDataModule.setPlayerCount(arg)
    end)
     
    -- function OnCharacterInstantiate(playerinfo)
    --     local player = playerinfo.player
    --     local character = player.character
    --     -- print(player.name .. ": " .. tostring(newVal))
    -- end

    -- GameManager.PlayerTrackerModule.TrackPlayers(client, OnCharacterInstantiate)

end

function onStartContest(playerCount)
    print("Contest starting with " .. playerCount .. " players.")
end
function onLocalPlayerData(thisPlayer)
    if (thisPlayer == client.localPlayer) then
        print("local player: " .. thisPlayer.name)
        GameManager.PlayerDataModule.setPlayerData(thisPlayer.id, thisPlayer.name)
    end
end

-- Server
function self:ServerAwake()
    server.PlayerConnected:Connect(onPlayerJoined)
    server.PlayerDisconnected:Connect(onPlayerLeft)

    -- GameManager.PlayerTrackerModule.TrackPlayers(server)
end

function onPlayerJoined(player)
    table.insert(lobbyQueue, player)
    print(player.name .. " Joined " .. #lobbyQueue .. " players.")
    checkLobbyContest()
    checkStartContest()
end

function onPlayerLeft(player)
    for i, p in ipairs(lobbyQueue) do
        if p == player then
            table.remove(lobbyQueue, i)
            print(player.name .. " Left " .. #lobbyQueue .. " players.")
            updateLobbyContest()
            break
        end
    end
end

function checkStartContest()
    if #lobbyQueue >= minPlayers then
        startContest:FireAllClients(#lobbyQueue)
    end
end
function checkLobbyContest()
    lobbyPlayerCountRequest:Connect(function(player, arg)
        setPlayerSetting:FireAllClients(player)
        setLobbyCount:FireAllClients(#lobbyQueue)
    end)
end
function updateLobbyContest()
        setLobbyCount:FireAllClients(#lobbyQueue)
        print("Update Client")
end

