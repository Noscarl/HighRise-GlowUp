--!Type(Module)

--!SerializeField
local playerID : number = 0
--!SerializeField
local playerName : string = ""

function setPlayerData(_playerID, _playerName)
    playerID = _playerID
    playerName = _playerName
    print("Player ID " .. playerID .. " Player Name: " .. playerName)
end
