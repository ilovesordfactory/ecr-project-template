local props = require("@props")
local map = props.map
local vide = require("@vide")

type StrokeProps = {
    color: Color3,
    thickness: number,
    transparency: number,
}

local create = vide.create

local function stroke(props: StrokeProps, children: props.children?)
    return create("UIStroke")({
        map(props),
        children,
    })
end

return stroke
