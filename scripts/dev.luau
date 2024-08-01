--!nocheck
local fs = require("@lune/fs")
local process = require("@lune/process")
local task = require("@lune/task")

if fs.metadata("Packages").exists == false then
	process.spawn("lune", {
		"run",
		"scripts/install-packages.luau",
	})
end

task.spawn(process.spawn, "rojo", {
	"serve",
	"build.project.json",
}, {
	stdio = "forward",
})

task.spawn(process.spawn, "rojo", {
	"sourcemap",
	"default.project.json",
	"-o",
	"sourcemap.json",
	"--watch",
})

task.spawn(process.spawn, "darklua", {
	"process",
	"--config",
	".darklua.json",
	"--watch",
	"src/",
	"dist/",
}, {
	env = {
		"ROBLOX_DEV=true",
	},
	stdio = "forward",
})
