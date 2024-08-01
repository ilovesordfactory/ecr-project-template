local props = require("@props")
local vide = require("@vide")

local create = vide.create

local function corner(props: {
    corner_radius: props.Derivable<UDim>?,
})
    return if props.corner_radius
        then create("UICorner")({
            CornerRadius = props.corner_radius,
        })
        else nil
end

return corner
