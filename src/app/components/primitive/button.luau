local props = require("@props")
local vide = require("@vide")
local remove_unusable = props.remove_unusable

type ButtonProps = {
    on_click: (() -> ())?,
    on_mouse_enter: (() -> ())?,
    on_mouse_leave: (() -> ())?,
    on_mouse_up: (() -> ())?,
    on_mouse_down: (() -> ())?,

    corner_radius: props.Derivable<UDim>?,
} & props.layout & props.appearance & props.misc

local corner = require("@ui/primitive/corner")

local create = vide.create

local function button(props: ButtonProps, children: props.children)
    local useable_props = remove_unusable(props, "TextButton")

    return create("TextButton")({
        Text = "",

        corner(props),

        useable_props,

        Activated = props.on_click,
        MouseEnter = props.on_mouse_enter,
        MouseLeave = props.on_mouse_leave,
        MouseButton1Up = props.on_mouse_up,
        MouseButton1Down = props.on_mouse_down,

        children,

        table.unpack(props),
    })
end

return button
