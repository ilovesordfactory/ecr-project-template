local props = require("@props")
local vide = require("@vide")
local remove_unusable = props.remove_unusable

type GroupProps = props.layout?

local create = vide.create

local function group(props: GroupProps, children: props.children?)
    return create("Frame")({
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Size = UDim2.new(1, 0, 1, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0),

        remove_unusable(props, "Frame"),

        children,
    })
end

return group
