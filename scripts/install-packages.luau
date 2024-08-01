--!nocheck
local process = require("@lune/process")

process.spawn("wally", {
	"install",
})

process.spawn("rojo", {
	"sourcemap",
	"default.project.json",
	"-o",
	"sourcemap.json",
})

process.spawn("wally-package-types", {
	"--sourcemap",
	"sourcemap.json",
	"./Packages",
})

process.spawn("wally-package-types", {
	"--sourcemap",
	"sourcemap.json",
	"./ServerPackages",
})
