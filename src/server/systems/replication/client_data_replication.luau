local components = require("@cts")
local data_template = require("@defs/datastore-template")
local ecr = require("@ecr")
local net = require("@net/server")
local player_utils = require("@utils/players")

local function client_data_replication(world: ecr.Registry)
    -- a set of datastore saved components to replicate
    local components_to_replicate = {}

    -- populate set
    for component_name, _ in data_template do
        components_to_replicate[component_name] = true
    end

    local function send_set_event(component_name, entity, data)
        local client = world:try_get(entity, components.Client)

        if not client then
            return
        end

        net.replicate.fire(client, {
            [component_name] = {
                set = { data },
                ids = { entity },
            },
        })
    end

    for component_name in components_to_replicate do
        local component = components[component_name]

        if not component then
            continue
        end

        world:on_add(component):connect(function(entity, data)
            send_set_event(component_name, entity, data)
        end)

        world:on_change(component):connect(function(entity, data)
            send_set_event(component_name, entity, data)
        end)

        world:on_remove(component):connect(function(entity)
            local client = world:try_get(entity, components.Client)

            if not client then
                return
            end

            net.replicate.fire(client, {
                [component_name] = {
                    ids = {},
                    set = {},
                    removed = { entity },
                },
            })
        end)
    end

    return function() end
end

return {
    fn = client_data_replication,
    priority = 1000,
}
