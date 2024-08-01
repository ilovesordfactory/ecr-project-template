-- lightweight syntax sugar for the imagelabel instance
local props = require("@props")
local vide = require("@vide")
local remove_unusable = props.remove_unusable

type Derivable<T> = props.Derivable<T>

type ImageProps = {
    image: Derivable<string>,
    image_transparency: Derivable<number>?,
    image_color_3: Derivable<Color3>?,
    image_rect_size: Derivable<Vector2>?,
    image_rect_offset: Derivable<Vector2>?,
    scale_type: Derivable<Enum.ScaleType>?,
    slice_center: Derivable<Rect>?,
    slice_scale: Derivable<number>?,

    corner_radius: Derivable<UDim>?,
} & props.layout & props.appearance

local create = vide.create

local function image(props: ImageProps, children: props.children?)
    return create("ImageLabel")({
        BackgroundTransparency = 1,

        remove_unusable(props, "ImageLabel"),

        children,
    })
end

return image
