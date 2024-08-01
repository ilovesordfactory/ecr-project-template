local ripple = require("@pkg/ripple")
local set_timeout = require("@composables/set_timeout")
local vide = require("@vide")
local source = vide.source
local cleanup = vide.cleanup

type NonStrict<T> = T | number

local function use_motion<T>(initial: NonStrict<T>, debug: boolean?)
    debug = debug or false
    local motion = ripple.createMotion(initial)
    local state = source(initial)
    local last_call = nil

    local function log(...)
        if debug then
            print(...)
        end
    end

    motion:onStep(state)
    motion:start()

    cleanup(function()
        motion:stop()
    end)

    return setmetatable({
        state = state,
        motion = motion,
    }, {
        __call = function(_, ...)
            local args = { ... }

            if #args == 0 then
                log("no args, providing current state")
                return state()
            elseif #args == 2 then
                log("two args, springing")
                motion:spring(args[1], args[2])
            elseif #args == 3 then
                if typeof(last_call) == "function" then
                    last_call()
                end

                log("three args, springing with delay", args[3])

                last_call = set_timeout(function()
                    motion:spring(args[1], args[2])
                end, args[3])
            end
        end,
    })
end

return use_motion
