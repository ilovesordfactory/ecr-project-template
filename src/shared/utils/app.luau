local deep_copy = require("./table").deep_copy
local vide = require("@vide")

local function map_props(props)
    if not props then
        return props
    end

    local new_props = {}

    for i, v in props do
        if typeof(v) == "table" then
            new_props[i] = map_props(v)
            continue
        end

        new_props[i] = nil

        local new_prop = ""
        local split = string.split(i, "_")

        for i, v in split do
            new_prop = new_prop .. string.sub(v, 1, 1):upper() .. string.sub(v, 2)
        end

        new_props[new_prop:gsub("%s", "")] = v
    end

    return new_props
end

local function remove_unusable_props(props, instance_name)
    local test_instance = Instance.new(instance_name)
    local new_props = {}
    local cloned_props = map_props(deep_copy(props))

    for k, v in cloned_props do
        local ok = pcall(function()
            if typeof(v) == "function" then
                test_instance[k] = v()
                return
            end

            test_instance[k] = v
        end)

        if ok then
            new_props[k] = v
        end
    end

    test_instance:Destroy()

    return new_props
end

return {
    map_props = map_props,
    remove_unusable_props = remove_unusable_props,
}
