local vide = require("@vide")

local cleanup = vide.cleanup

local function use_event(signal: RBXScriptSignal, callback)
    local connection = signal:Connect(callback)

    cleanup(function()
        connection:Disconnect()
    end)
end

return use_event
