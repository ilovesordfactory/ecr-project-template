local function deep_copy(t)
    local copy = {}
    for k, v in pairs(t) do
        if type(v) == "table" then
            copy[k] = deep_copy(v)
        else
            copy[k] = v
        end
    end
    return copy
end

local function diff_tables(left, right)
    if not left or not right then
        return true
    end

    if left == right then
        return false
    end

    local size = 0

    for index, value in next, left do
        local right_index = right[index]
        if typeof(right_index) ~= typeof(value) then
            return true
        elseif typeof(value) == "table" then
            if diff_tables(value, right_index) then
                return true
            end
        elseif value ~= right_index then
            return true
        end

        size += 1
    end

    for _ in right do
        size -= 1
    end

    if size ~= 0 then
        return true
    end

    return false
end

return {
    deep_copy = deep_copy,
    diff_tables = diff_tables,
}
