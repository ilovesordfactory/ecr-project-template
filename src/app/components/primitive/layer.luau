local props = require("@props")
local vide = require("@vide")
local remove_unusable = props.remove_unusable

type LayerProps = {
    name: string?,
    reset_on_spawn: boolean?,
    ignore_gui_inset: boolean?,
    z_index_behavior: Enum.ZIndexBehavior?,
    display_order: number?,
}

local create = vide.create

local function layer(props: LayerProps, children: props.children?)
    return create("ScreenGui")({
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,

        remove_unusable(props, "ScreenGui"),
        children,
    })
end

return layer
