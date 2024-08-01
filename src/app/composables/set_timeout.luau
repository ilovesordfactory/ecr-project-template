local RunService = game:GetService("RunService")

local function set_timeout(callback: () -> (), interval: number): () -> ()
    local elapsed = 0
    local connection = nil

    connection = RunService.Heartbeat:Connect(function(dt)
        elapsed += dt

        if elapsed >= interval then
            connection:Disconnect()
            callback()
        end
    end)

    return function()
        connection:Disconnect()
    end
end

return set_timeout
