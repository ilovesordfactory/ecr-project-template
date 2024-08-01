local UserInputService = game:GetService("UserInputService")
local use_event = require("@composables/use_event")
local vide = require("@vide")

local source = vide.source

local function get_input_type(input_type: Enum.UserInputType?): "keyboard" | "touch" | "gamepad"
    input_type = input_type or UserInputService:GetLastInputType()

    if input_type == Enum.UserInputType.Keyboard or input_type == Enum.UserInputType.MouseMovement then
        return "keyboard"
    elseif input_type == Enum.UserInputType.Touch then
        return "touch"
    elseif input_type == Enum.UserInputType.Gamepad1 then
        return "gamepad"
    end

    return "keyboard"
end

local function use_input_device()
    local state = source("keyboard")

    use_event(UserInputService.LastInputTypeChanged, function(input_type)
        state(get_input_type(input_type))
    end)

    return state
end

return use_input_device
