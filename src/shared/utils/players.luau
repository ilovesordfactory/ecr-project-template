local Players = game:GetService("Players")

local promise = require("@pkg/promise")
local spawn = require("@pkg/spawn")

local function player_added(callback: (player: Player) -> ()): () -> ()
    local connection = Players.PlayerAdded:Connect(callback)
    for _, player in Players:GetPlayers() do
        spawn(callback, player)
    end

    return function()
        connection:Disconnect()
    end
end

local function promise_disconnect(player: Player): typeof(promise.new(...))
    return promise.fromEvent(Players.PlayerRemoving, function(removingPlayer)
        return removingPlayer == player
    end)
end

return {
    player_added = player_added,
    promise_disconnect = promise_disconnect,
}
