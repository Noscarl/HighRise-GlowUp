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
     
    function OnCharacterInstantiate(playerinfo)
        local player = playerinfo.player
        local character = player.character
        print("Player Name:  " .. player.name .. " - Character Instance:  " .. player.character.name)
    end

    onPlayerJoined(client, OnCharacterInstantiate)
end

function onStartContest(playerCount)
    print("Contest starting with " .. playerCount .. " players.")
end
function onLocalPlayerData(thisPlayer)
    if (thisPlayer == client.localPlayer) then
        -- print("local player: " .. thisPlayer.name)
        GameManager.PlayerDataModule.setPlayerData(thisPlayer.id, thisPlayer.name)
    end
end

-- Server
function self:ServerAwake()
    onPlayerJoined(server)
    server.PlayerDisconnected:Connect(onPlayerLeft)

    -- GameManager.PlayerTrackerModule.TrackPlayers(server)
end
function onPlayerJoined(game, characterCallback)
    scene.PlayerJoined:Connect(function(scene, player)
        table.insert(lobbyQueue, player)
        GameManager.LobbyDataModule.players[player] = {
            player = player,
            score = IntValue.new("score" .. tostring(player.id), 0)
        }
        -- Event: Character Changed
        player.CharacterChanged:Connect(function(player, character)
            local playerinfo = GameManager.LobbyDataModule.players[player]
            -- Check if the character is instantiated
            if character == nil then
                return  -- If no character, exit the function
            end

            -- Call the provided callback function with player info
            if characterCallback then
                characterCallback(playerinfo)
            end
        end)

        checkLobbyContest()
        checkStartContest()
    end)
end


function onPlayerLeft(player)
    for i, p in ipairs(lobbyQueue) do
        if p == player then
            table.remove(lobbyQueue, i)
            GameManager.LobbyDataModule.players[player] = nil
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