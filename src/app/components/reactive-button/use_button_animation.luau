local springs = require("@consts/springs")
local use_motion = require("@composables/use_motion")
local vide = require("@vide")

local untrack = vide.untrack
local effect = vide.effect

local function use_button_animation(pressed: () -> boolean, hovered: () -> boolean)
    local press_motion = use_motion(0)
    local hover_motion = use_motion(0)
    local hover_exclusive_motion = use_motion(0)
    local position_motion = use_motion(0)

    effect(function()
        press_motion(if pressed() then 1 else 0, springs.responsive)
        hover_exclusive_motion(if hovered() and not pressed() then 1 else 0, springs.responsive)
    end)

    effect(function()
        hover_motion(if hovered() then 1 else 0, springs.responsive)
    end)

    effect(function()
        if pressed() then
            position_motion(1, springs.responsive)
        elseif untrack(hovered) then
            position_motion(-1, {
                tension = springs.bubbly.tension,
                friction = springs.bubbly.friction,
                impulse = -0.1,
            })
        else
            position_motion(0, {
                tension = springs.bubbly.tension,
                friction = springs.bubbly.friction,
                impulse = -0.07,
            })
        end
    end)

    effect(function()
        if hovered() then
            position_motion(1, springs.responsive)
        else
            position_motion(0, springs.responsive)
        end
    end)

    return {
        press = press_motion,
        hover = hover_motion,
        hover_exclusive = hover_exclusive_motion,
        position = position_motion,
    }
end

return use_button_animation
