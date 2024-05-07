-- file_operations.lua
-- A collection of functions for dealing with files 
--
-- J.Kunze
-- 23-09-01

local function write_points_to_file(filename, points, mode, keys)
    mode = mode or 'w'
    keys = keys or nil
    outfile = assert(io.open(filename, mode))
    if mode == 'w' then
        outfile:write(string.format('# %s - written by file_operations.write_points_to_file %s\n', filename, os.date("%c")))
        header = string.format('#')
    end
    i = 1
    if not keys then
        -- find keys
        keys = {}
        for key, value in pairs(points[1]) do
            header = header .. string.format(' %d:%s', i, key)
            keys[#keys+1] = key
            i = i + 1
        end
    else
        for i=1, #keys do
            header = header .. string.format(' %d:%s', i, keys[i])
        end
    end
    if mode == 'w' then
        outfile:write(header .. '\n')
    end
    for i=1, #points do
        for _, key in ipairs(keys) do
            outfile:write(string.format('%e ', points[i][key]))
        end
        outfile:write('\n')
    end

    outfile:close()
end

return {write_points_to_file=write_points_to_file}
