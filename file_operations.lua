-- file_operations.lua
-- A collection of functions for dealing with files 
--
-- J.Kunze
-- 23-09-01

local file_operations = {}

local function write_points_to_file(filename, points, mode)
    mode = mode or 'w'
    outfile = assert(io.open(filename, mode))
    if mode == 'w' then
        outfile:write(string.format('# %s - written by file_operations.write_points_to_file %s\n', filename, os.date("%c")))
        header = string.format('# ')
    end
    i = 1
    coordinates = ''
    keys = {}
    for key, value in pairs(points[1]) do
        header = header .. string.format('%d:%s ', i, key)
        coordinates = coordinates .. string.format('%e ', value)
        keys[#keys+1] = key
        i = i + 1
    end
    if mode == 'w' then
        outfile:write(header .. '\n')
    end
    outfile:write(coordinates  .. '\n')
    for i=2, #points do
        coordinates = ''
        for j, key in ipairs(keys) do
            coordinates = coordinates .. string.format('%e ', points[i][key])
        end
        outfile:write(coordinates  .. '\n')
    end

    outfile:close()
end

return {write_points_to_file=write_points_to_file}
