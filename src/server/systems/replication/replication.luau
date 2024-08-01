-- General replication of components and entities
local components = require("@cts")
local ecr = require("@ecr")
local network = require("@server/network")
local player_utils = require("@utils/players")

local REPLICATED_COMPONENTS = {
    "Client",
}

local function replication(world: ecr.Registry)
    local replication_map = {}

    local function get_component_map(component_name)
        local component_map = replication_map[component_name]

        if not component_map then
            component_map = {
                set = {},
                ids = {},
                removed = {},
            }

            replication_map[component_name] = component_map
        end

        return component_map
    end

    player_utils.player_added(function(player)
        local payload = {}

        for _, component_name in REPLICATED_COMPONENTS do
            -- manually add the new component map
            local component = components[component_name]
            local component_map = {
                set = {},
                ids = {},
            }

            payload[component_name] = component_map

            local pool = world:storage(component)
            local entities = ecr.buffer_to_array(pool.entities, pool.size)

            for _, entity in entities do
                local data = world:get(entity, component)
                table.insert(component_map.set, data)
                table.insert(component_map.ids, entity)
            end
        end

        print("sending initial payload to", player, ":", payload)
        network.replicate.fire(player, payload)
    end)

    for _, component_name in REPLICATED_COMPONENTS do
        local component = components[component_name]

        assert(component, `component not found {component_name}`)

        world:on_add(component):connect(function(entity, data)
            local component_map = get_component_map(component_name)
            -- they should be at the same index, so we can just push the data to the set and the id to the ids
            table.insert(component_map.set, data)
            table.insert(component_map.ids, entity)
        end)
        world:on_change(component):connect(function(entity, data)
            local component_map = get_component_map(component_name)
            table.insert(component_map.set, data)
            table.insert(component_map.ids, entity)
        end)
        world:on_remove(component):connect(function(entity)
            local component_map = get_component_map(component_name)
            table.insert(component_map.removed, entity)
        end)
    end

    return function(dt)
        if not next(replication_map) then
            return
        end

        -- todo add event firing
        network.replicate.fire_all(replication_map)

        replication_map = {}
    end
end

return {
    fn = replication,
    event = "heartbeat",
    priority = 999,
}
