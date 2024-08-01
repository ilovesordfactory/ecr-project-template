local px = require("@composables/px")
local vide = require("@vide")

local mount = vide.mount

local reactive_button = require("@ui/reactive-button")

return function(target)
    return mount(function()
        px.use_px(target)

        return reactive_button({
            position = UDim2.fromScale(0.5, 0.5),
            size = px(UDim2.fromOffset(150, 150)),
            anchor_point = Vector2.new(0.5, 0.5),

            animate_position_direction = Vector2.new(-0.6, 0.6),
        })
    end, target)
end
