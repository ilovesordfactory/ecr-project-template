local vide = require("@vide")

local source = vide.source

local BASE_RESOLUTION = Vector2.new(1920, 1080)
local MIN_SCALE = 0.25
local DOMINANT_AXIS = 0.5

local scale = source(0.5)

local scale_functions = {
    number = function(value)
        return value * scale()
    end,

    number_mode = function(value, mode)
        if mode == "even" then
            return math.floor(value * scale() * 0.5) * 2
        elseif mode == "scale" then
            return value * scale()
        elseif mode == "floor" then
            return math.floor(value * scale())
        elseif mode == "ceil" then
            return math.ceil(value * scale())
        end

        return value
    end,

    UDim = function(value)
        return UDim.new(value.Scale, value.Offset * scale())
    end,

    UDim2 = function(value)
        return UDim2.new(value.X.Scale, value.X.Offset * scale(), value.Y.Scale, value.Y.Offset * scale())
    end,

    Vector2 = function(value)
        return Vector2.new(value.X * scale(), value.Y * scale())
    end,
}

local px = setmetatable({}, {
    __call = function(_, value, mode)
        local arg_type = typeof(value)
        local scale_function = scale_functions[arg_type]

        if arg_type == "number" then
            if mode then
                return scale_functions.number_mode(value, mode)
            else
                return scale_function(value)
            end
        else
            return scale_function(value)
        end
    end,
})

local function use_px(target: Camera | GuiObject)
    target = target or game.Workspace.CurrentCamera
    local property_name = if target:IsA("Camera") then "ViewportSize" else "AbsoluteSize"

    local function update_scale(viewport: Vector2)
        local width = math.log(viewport.X / BASE_RESOLUTION.X, 2)
        local height = math.log(viewport.Y / BASE_RESOLUTION.Y, 2)
        local centered = width + (height - width) * DOMINANT_AXIS

        scale(math.max(2 ^ centered, MIN_SCALE))
    end

    -- have to cast to any because old solver is bad
    target:GetPropertyChangedSignal(property_name):Connect(function()
        update_scale((target :: any)[property_name])
    end)

    update_scale((target :: any)[property_name])
end

-- we are returning it this way, because lets say we have
-- local px = require("px")
-- px(10) -- this will call the __call metamethod and return the value
-- rather tahn
-- local px = require("px")
-- px.px(10) -- this is not as clean
return setmetatable({
    use_px = use_px,
    px = px,
}, {
    __call = function(_, value, mode)
        if typeof(mode) == "boolean" and mode == false then
            return px(value)
        end

        return function()
            return px(value, mode)
        end
    end,
})
