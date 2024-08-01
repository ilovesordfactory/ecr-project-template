local app_utils = require("@utils/app")
local map_props = app_utils.map_props
local remove_unusable_props = app_utils.remove_unusable_props

export type Derivable<T> = () -> T | T

export type layout = {
    position: Derivable<UDim2>?,
    size: Derivable<UDim2>?,
    layout_order: Derivable<number>?,
    z_index: Derivable<number>?,
    anchor_point: Derivable<Vector2>?,
}

export type appearance = {
    background_color_3: Derivable<Color3>?,
    background_transparency: Derivable<number>?,
    border_color_3: Derivable<Color3>?,
    border_size_pixel: Derivable<number>?,
    clip_descendants: Derivable<boolean>?,
}

export type text = {
    text: Derivable<string>?,
    text_color_3: Derivable<Color3>?,
    text_size: Derivable<number>?,
    text_scaled: Derivable<boolean>?,
    font: Derivable<Enum.Font>?,
    font_face: Derivable<Font>?,
    text_x_alignment: Derivable<Enum.TextXAlignment>?,
    text_y_alignment: Derivable<Enum.TextYAlignment>?,
    text_truncate: Derivable<Enum.TextTruncate>?,
    text_wrapped: Derivable<boolean>?,
}

export type children = ({ Instance } | () -> { Instance })?

export type misc = {
    [string]: Derivable<any>,
}

return {
    map = map_props,
    remove_unusable = remove_unusable_props,
}
