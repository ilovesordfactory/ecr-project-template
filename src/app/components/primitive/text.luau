local props = require("@props")
local vide = require("@vide")
local remove_unusable = props.remove_unusable

type TextProps = {
    corner_radius: props.Derivable<UDim>?,
} & props.layout & props.appearance & props.text

local corner = require("@ui/primitive/corner")

local create = vide.create

local function text(props: TextProps, children: props.children?)
    local useable_props = remove_unusable(props, "TextLabel")

    return create("TextLabel")({
        corner(props),

        useable_props,
        children,

        table.unpack(props),
    })
end

return text
