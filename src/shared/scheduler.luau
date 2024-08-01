local RunService = game:GetService("RunService")
local ecr = require("@ecr")

type ScheduledFunction = (registry: ecr.Registry) -> (dt: number) -> nil

type ScheduledSystem = {
    fn: ScheduledFunction,
    priority: number,
    event: "heartbeat" | "render" | "stepped",
    name: string?,
}

local functions = {
    stepped = {},
    heartbeat = {},
    render = {},
}

local function schedule_function(
    func: ScheduledFunction,
    event: ("stepped" | "heartbeat" | "render")?,
    priority: number?,
    name: string?
)
    table.insert(functions[event or "heartbeat"], {
        fn = func,
        event = event or "heartbeat",
        priority = priority or 1,
        name = name or "unnamed",
    })
end

local function schedule_container(container: Folder)
    for _, child in container:GetDescendants() do
        if not child:IsA("ModuleScript") then
            continue
        end

        local ok, system: ScheduledSystem = pcall(require, child)

        assert(ok, `failed to load system {system}`)
        assert(system.fn, `system from {child.Name} is missing a valid function`)

        schedule_function(system.fn, system.event, system.priority, child.Name)
    end
end

local function schedule_containers(...: Folder)
    for _, container in { ... } do
        if typeof(container) ~= "Instance" or not container:IsA("Folder") then
            continue
        end

        schedule_container(container)
    end
end

local function run_scheduler(registry: ecr.Registry)
    for event, functions in pairs(functions) do
        table.sort(functions, function(a, b)
            return a.priority < b.priority
        end)
    end

    local run_per_frame = {}

    local function run_functions(functions: { ScheduledSystem }, dt: number)
        for _, system in ipairs(functions) do
            if not run_per_frame[system.fn] then
                run_per_frame[system.fn] = system.fn(registry)
            end

            run_per_frame[system.fn](dt)
        end
    end

    if RunService:IsClient() then
        RunService.RenderStepped:Connect(function(dt)
            run_functions(functions.render, dt)
        end)
    elseif RunService:IsServer() and #functions.render > 0 then
        warn("render functions are not supported on the server")

        -- migrate to heartbeat
        for _, system in functions.render do
            schedule_function(system.fn, "heartbeat", system.priority, system.name)
        end
    end

    RunService.Heartbeat:Connect(function(dt)
        run_functions(functions.heartbeat, dt)
    end)

    RunService.Stepped:Connect(function(_, dt)
        run_functions(functions.stepped, dt)
    end)
end

return {
    schedule_function = schedule_function,
    schedule_container = schedule_container,
    schedule_containers = schedule_containers,
    run_scheduler = run_scheduler,
}
