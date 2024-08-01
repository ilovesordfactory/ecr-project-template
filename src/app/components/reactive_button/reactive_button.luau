local props = require("@props")
local px = require("@composables/px")
local use_button_animation = require("./use_button_animation")
local use_button_state = require("./use_button_state")
local use_motion = require("@composables/use_motion")
local vide = require("@vide")

type ReactiveButtonProps = {
    on_click: (() -> ())?,
    on_mouse_down: (() -> ())?,
    on_mouse_up: (() -> ())?,
    on_mouse_enter: (() -> ())?,
    on_mouse_leave: (() -> ())?,
    on_hover: ((hovered: boolean) -> ())?,
    on_press: ((pressed: boolean) -> ())?,

    enabled: boolean?,
    corner_radius: props.Derivable<UDim>?,
    animate_position: boolean?,
    animate_size: boolean?,
    animate_position_strength: props.Derivable<number>?,
    animate_position_direction: props.Derivable<Vector2>?,
    animate_size_strength: props.Derivable<number>?,
} & props.layout & props.appearance

local button = require("@ui/primitive/button")
local corner = require("@ui/primitive/corner")
local frame = require("@ui/primitive/frame")

local read = vide.read
local effect = vide.effect

local function reactive_button(props: ReactiveButtonProps, children: props.children?)
    props.animate_size = props.animate_size or true
    props.animate_position = props.animate_position or true
    -- typecasted to any because of weird error with derivables
    props.animate_position_strength = props.animate_position_strength or 1 :: any
    props.animate_position_direction = props.animate_position_direction or Vector2.new(0, 1) :: any
    props.animate_size_strength = props.animate_size_strength or 1 :: any

    local size_motion = use_motion(0)
    local pressed, hovered, events = use_button_state(props.enabled)
    local animation = use_button_animation(pressed, hovered)

    local function call_event(event_name: string)
        if (props :: any)[event_name] then
            (props :: any)[event_name]()
        end
    end

    effect(function()
        if pressed() then
            size_motion(-0.1, { tension = 300 })
        else
            size_motion(0, { tension = 300, impulse = 0.01 })
        end
    end)

    effect(function()
        local pressed = pressed()

        if props.on_press then
            props.on_press(pressed)
        end
    end)

    effect(function()
        local hovered = hovered()

        if props.on_hover then
            props.on_hover(hovered)
        end
    end)

    return button({
        on_click = props.on_click,
        on_mouse_down = function()
            events.on_mouse_down()
            call_event("on_mouse_down")
        end,
        on_mouse_up = function()
            events.on_mouse_up()
            call_event("on_mouse_up")
        end,
        on_mouse_enter = function()
            events.on_mouse_enter()
            call_event("on_mouse_enter")
        end,
        on_mouse_leave = function()
            events.on_mouse_leave()
            call_event("on_mouse_leave")
        end,

        background_transparency = 1,

        size = props.size,
        position = props.position,
        anchor_point = props.anchor_point,
        z_index = props.z_index,
        layout_order = props.layout_order,
    }, {
        frame({
            anchor_point = Vector2.new(0.5, 0.5),

            background_color_3 = function()
                local hover = animation.hover_exclusive()
                local press = animation.press()
                local color: Color3 = read(props.background_color_3 or Color3.new(1, 1, 1))

                return color:Lerp(Color3.new(1, 1, 1), hover * 0.15):Lerp(Color3.new(), press * 0.1)
            end,

            position = function()
                local animate_position = props.animate_position
                local position_motion = if animate_position then animation.position() else 0
                local animate_position_strength = read(props.animate_position_strength)
                local animate_position_direction = read(props.animate_position_direction)

                return UDim2.fromScale(0.5, 0.5):Lerp(
                    UDim2.new(
                        0.5,
                        (3 + px(1.6, false)) * animate_position_strength * animate_position_direction.X,
                        0.5,
                        (3 + px(1.6, false)) * animate_position_strength * animate_position_direction.Y
                    ),
                    position_motion
                )
            end,

            size = function()
                local animate_size = props.animate_size
                local size_motion = if animate_size then size_motion() else 0
                local animate_size_strength = read(props.animate_size_strength)

                return UDim2.fromScale(1, 1):Lerp(
                    UDim2.new(1, px(32 * animate_size_strength, false), 1, px(32 * animate_size_strength, false)),
                    size_motion
                )
            end,
        }, {
            corner(props),
            children,
        }),
    })
end

return reactive_button
