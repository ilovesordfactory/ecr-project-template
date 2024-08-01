local ripple = require("@pkg/ripple")
local config = ripple.config
local config_springs = config.spring

return {
    default = config_springs.default,
    molasses = config_springs.molasses,
    slow = config_springs.slow,
    stiff = config_springs.stiff,
    wobbly = config_springs.wobbly,
    bubbly = { tension = 400, friction = 14 },
    responsive = { tension = 400 },
    gentle = { tension = 250, friction = 30 },
}
