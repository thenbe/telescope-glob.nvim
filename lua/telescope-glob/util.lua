local M = {}

M.table_concat = function(...)
    local result = {}
    for _, t in ipairs({...}) do
        for _, v in ipairs(t) do
            result[#result + 1] = v
        end
    end
    return result
end

return M
