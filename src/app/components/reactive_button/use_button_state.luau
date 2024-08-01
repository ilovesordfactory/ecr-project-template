local UserInputService = game:GetService("UserInputService")
local set_timeout = require("@composables/set_timeout")
local use_event = require("@composables/use_event")
local use_input_device = require("@composables/use_input_device")
local vide = require("@vide")

local source = vide.source
local derive = vide.derive

local function use_button_state(enabled)
    local press, hover = source(false), source(false)

    local on = function()
        return enabled
    end

    local touch = derive(function()
        return use_input_device() == "touch"
    end)

    local events = {
        on_mouse_down = function()
            press(true)
        end,
        on_mouse_up = function()
            press(false)
        end,
        on_mouse_enter = function()
            hover(true and not touch())
        end,
        on_mouse_leave = function()
            hover(false)
            press(false)
        end,
    }

    use_event(UserInputService.InputEnded, function(input: InputObject)
        if input.UserInputType == Enum.UserInputType.Touch then
            set_timeout(function()
                press(false)
                hover(false)
            end, 0)
        end
    end)

    return press, hover, events
end

return use_button_state
