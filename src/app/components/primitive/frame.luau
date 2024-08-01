local props = require("@props")
local vide = require("@vide")
local remove_unusable = props.remove_unusable

type FrameProps = {
    corner_radius: props.Derivable<UDim>?,
} & props.layout & props.appearance & props.misc

local corner = require("@ui/primitive/corner")

local create = vide.create

local function frame(props: FrameProps, children: props.children?)
    local useable_props = remove_unusable(props, "Frame")

    return create("Frame")({

        corner(props),
        useable_props,
        children,

        table.unpack(props),
    })
end

return frame
