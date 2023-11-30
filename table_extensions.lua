-- table_extensions.lua
--
-- A lua module for useful table operations
--
-- Author:
--  J.Kunze
--
--  2020-09-02: First functions, copy_table and 
--              compare_indexed_tables
--  2020-09-10: Adding function to create a set
--              as shown under 11.5 in programming
--              in lua on lua.org 
--              Second function that swaps keys and
--              values
--  2023-08-22: Added has_value function and changed
--              name to table_extensions.lua
--              usage changed to dofile(table_extensions.lua)
--              instead of the require command
---------------------------------------------------------------
-- Functions

function table.copy(table)
    t_copy = {}
    
    for i,v in pairs(table) do
        t_copy[i] = v 
        print(i, t_copy[i], '\t\t', v)
    end
    return t_copy
end

function table.compare_indexed_tables(table1, table2)
    -- an attempt to quickly compare two numerically 
    -- indexed tables
    --
    -- a few simple checks return false without having
    -- to compare all elements
    --
    -- returns false if the tables are not equal
    
    -- check that both tables contain an element at index one first
    if #table1 == 0 or #table2 == 0 then print('One of the tables has no elements or does not start at index 1') return false end

    -- check if the tables have the same length
    if #table1 ~= #table2 then print('The tables don\'t have the same number of elements') return false end

    -- loop over the elements and compare them
    for i=1, #table1 do
        if table1[i] ~= table2[i] then
            print('element ' .. i .. ' does not match, table1[' .. i .. '] = ' .. table1[i] .. ', table2[' .. i .. '] = ' .. table2[i])
            return false
        end
    end

    -- if everything was in order return true
    return true
end

function table.set(list)
    -- create a set which has the contents
    -- of the passed list as keys
    local set = {}
    for _, l in ipairs(list) do 
        set[l] = true
    end
    return set
end

function table.swap_key_and_value(list)
    local swapped = {}
    for i, l in pairs(list) do 
        swapped[l] = i
    end
    return swapped
end

function table.has_value(tab, val)
    -- check if a table contains a specific value
    for index, value in ipairs(tab) do
        if value == val then return true end
    end

    return false
end

function table.concatenate(t1,t2)
    for i=1,#t2 do
        t1[#t1+1] = t2[i]
    end
    return t1
end

function table.sort_by_x(t1,t2)
    -- A table of points is sorted according to the x-value
    -- of each point when used with table.sort
    -- Syntax: table.sort(table, table.sort_by_x)
    local a = t1.x
    local b = t2.x
    return a < b
end

function table.print(t, option)
    local prefix = ''
    if option == 'indent' then prefix = '\t' end
    for i, v in pairs(t) do
        print(prefix .. i, v)
    end
end

function table.deepcopy(obj)
    if type(obj) ~= 'table' then return obj end
    local res = setmetatable({}, getmetatable(obj))
    for k, v in pairs(obj) do res[table.deepcopy(k)] = table.deepcopy(v) end
    return res
end

return table
