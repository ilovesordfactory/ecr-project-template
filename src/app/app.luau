local px = require("@composables/px")
local vide = require("@vide")

local layer = require("@ui/primitive/layer")

local create = vide.create

local function App()
    -- starts the scaling
    px.use_px(workspace.CurrentCamera)

    return {
        layer({
            name = "menus",
        }),

        layer({
            name = "overlay",
        }),
    }
end

return App
