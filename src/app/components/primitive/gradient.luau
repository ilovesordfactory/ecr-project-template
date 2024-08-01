local props = require("@props")
local remove_unusable = props.remove_unusable
local vide = require("@vide")

type Derivable<T> = props.Derivable<T>

type GradientProps = {
    color: Derivable<(Color3 | ColorSequence)>?,
    rotation: Derivable<number>?,
    offset: Derivable<Vector2>?,
    transparency: Derivable<number>?,
}

local create = vide.create

local function gradient(props: GradientProps)
    return create("UIGradient")({
        remove_unusable(props, "UIGradient"),
    })
end

return gradient
