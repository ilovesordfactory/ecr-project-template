local client_state = require("@client/state")
local components = require("@cts")
local ecr = require("@ecr")
local net_utils = require("@utils/net")
local network = require("@client/network")

local DEBUG_MODE = true

local function debug_message(...)
    if DEBUG_MODE then
        print(...)
    end
end

local function receive_replication(world: ecr.Registry)
    local entity_id_map = client_state.entity_id_map
    local packet_queue = net_utils.event_queue(network.replicate)

    local function process_set(component_name, set, ids)
        if #set == 0 then
            return
        end

        local component = components[component_name]

        for i, server_entity_id in ids do
            local client_entity_id = entity_id_map[server_entity_id]

            if client_entity_id then
                world:set(client_entity_id, component, set[i])
            else
                client_entity_id = world:create()
                entity_id_map[server_entity_id] = client_entity_id
                world:set(client_entity_id, component, set[i])
            end

            debug_message("Replication Received", {
                client_entity = client_entity_id,
                server_entity = server_entity_id,
                component_name = component_name,
                data = set[i],
            })
        end
    end

    local function process_removed(component_name, removed)
        if #removed == 0 then
            return
        end

        local component = components[component_name]

        for _, server_entity_id in removed do
            local client_entity_id = entity_id_map[server_entity_id]
            if client_entity_id then
                world:remove(client_entity_id, component)

                debug_message("Replication Removed", {
                    client_entity = client_entity_id,
                    server_entity = server_entity_id,
                    component_name = component_name,
                })

                if world:has_none(client_entity_id) then
                    world:destroy(client_entity_id)
                    entity_id_map[server_entity_id] = nil

                    debug_message("Entity Destroyed", {
                        client_entity = client_entity_id,
                        server_entity = server_entity_id,
                    })
                end
            end
        end
    end

    return function()
        for packet in packet_queue do
            for component_name, component_data in packet do
                process_set(component_name, component_data.set, component_data.ids)
                process_removed(component_name, component_data.removed or {})
            end
        end
    end
end

return {
    fn = receive_replication,
    priority = -math.huge,
}
