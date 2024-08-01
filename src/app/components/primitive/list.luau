local props = require("@props")
local vide = require("@vide")
local remove_unusable = props.remove_unusable

type ListProps = {
    fill_direction: props.Derivable<Enum.FillDirection>?,
    horizontal_alignment: props.Derivable<Enum.HorizontalAlignment>?,
    vertical_alignment: props.Derivable<Enum.VerticalAlignment>?,
    padding: props.Derivable<UDim>?,
    sort_order: props.Derivable<Enum.SortOrder>?,
    wraps: props.Derivable<boolean>?,
    horizontal_flex: props.Derivable<Enum.UIFlexAlignment>?,
    vertical_flex: props.Derivable<Enum.UIFlexAlignment>?,
    item_line_alignment: props.Derivable<Enum.ItemLineAlignment>?,
}

local create = vide.create

local function list(props: ListProps, children: props.children?)
    return create("UIListLayout")({
        remove_unusable(props, "UIListLayout"),
        children,
    })
end

return list
