local px = require("@composables/px")
local vide = require("@vide")

local mount = vide.mount

local button = require("@ui/primitive/button")

return function(target)
    return mount(function()
        px.use_px(target)

        return button({
            layout = {
                position = UDim2.fromScale(0.5, 0.5),
                anchor_point = Vector2.new(0.5, 0.5),
            },
        })
    end, target)
end
