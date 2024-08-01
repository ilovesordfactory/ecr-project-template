local process = require("@lune/process")

local result = process.spawn("ps", {
    "-ax",
})

if not result then
    error("failed to get the result from ps -ax, exiting")
end

local out = result.stdout

if not out then
    error("failed to get the stdout from ps -ax, exiting")
end

local pids = {}
local pattern = "(%d+).+rojo"

for line in out:gmatch("[^\n]+") do
    local pid = line:match(pattern)
    if pid then
        table.insert(pids, pid)
    end
end

if #pids == 0 then
    error("no rojo processes found, exiting")
end

for _, pid in pids do
    local result = process.spawn("kill", {
        "-9",
        pid,
    })

    if not result then
        error("failed to kill rojo process with pid " .. pid)
    end
end

print("killed " .. #pids .. " rojo processes")
