--!nocheck
local fs = require("@lune/fs")
local process = require("@lune/process")

if fs.metadata("Packages").exists == false then
    process.spawn("lune", {
        "run",
        "scripts/install-packages.luau",
    })
end

process.spawn("zap", {
    "net.zap",
}, {
    stdio = "forward",
})

process.spawn("rojo", {
    "sourcemap",
    "default.project.json",
    "-o",
    "sourcemap.json",
})

process.spawn("darklua", {
    "process",
    "--config",
    ".darklua.json",
    "src/",
    "dist/",
}, {
    env = {
        "ROBLOX_DEV=false",
    },
    stdio = "forward",
})
