local RunService = game:GetService("RunService")

local components = require("@cts")
local data_template = require("@defs/datastore-template")
local ecr = require("@ecr")
local player_utils = require("@utils/players")
local profile_service = require("@spkg/profile_service")
local store_config = require("@configs/datastore-configs")
local store_constants = require("@consts/datastore-constants")

local store = profile_service.GetProfileStore(store_constants.STORE_KEY, data_template)

if store_config.use_mock == "always" then
    store = store.Mock
elseif store_config.use_mock == "dev" and RunService:IsStudio() then
    store = store.Mock
end

return function(world: ecr.Registry)
    -- Loads the profile and creates the entity for the player
    -- with the client component and the components from the profile
    local function load_data(player: Player)
        local profile = store:LoadProfileAsync(`{player.UserId}`, "ForceLoad")

        if not profile then
            player:Kick("failed to get profile")
            return
        end

        profile:Reconcile()
        profile:AddUserId(player.UserId)

        local entity = world:create()

        world:set(entity, components.Client, player)

        for component_name, component_data in profile.Data do
            local component = components[component_name]

            if not component then
                player:Kick(`failed to fetch {component_name}...`)
            end

            world:set(entity, component, component_data)
        end

        player_utils
            .promise_disconnect(player)
            :andThen(function()
                for component_name in profile.Data do
                    local component = components[component_name]

                    local current_data = world:try_get(entity, component)

                    if not current_data then
                        task.spawn(error, `failed to get data for {component_name} for {player.Name}`)
                        continue
                    end

                    profile.Data[component_name] = current_data
                end
            end)
            :finally(function()
                world:destroy(entity)
                print("saved session data, destroyed entity", profile.Data)
            end)

        return entity
    end

    local function add_components(player: Player, entity: number) end

    local function side_effects(player: Player, entity: number) end

    player_utils.player_added(function(player)
        local entity = load_data(player)
        add_components(player, entity)
        side_effects(player, entity)
    end)
end
