local ecr = require("@ecr")

require("./components")

local cached_registry = nil

local function get(used_cached: boolean?): ecr.Registry
    if used_cached and cached_registry then
        return cached_registry
    end

    local registry = ecr.registry()
    cached_registry = registry
    return registry
end

local function create_entity(): ecr.entity
    local registry = get(true)
    return registry:create()
end

local function run_plugins(...)
    local registry = get(true)
    for _, plugin in ipairs({ ... }) do
        plugin(registry)
    end
end

return {
    get = get,
    create_entity = create_entity,
    run_plugins = run_plugins,
}
