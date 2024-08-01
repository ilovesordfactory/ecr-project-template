local Players = game:GetService("Players")
local app = require("./app")
local vide = require("@vide")

local mount = vide.mount

local function init()
    mount(app, Players.LocalPlayer:WaitForChild("PlayerGui"))
end

return {
    init = init,
}
