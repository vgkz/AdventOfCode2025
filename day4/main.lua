function splitString(s)
    -- split string into table of characters
    local res = {}
    for i = 1, string.len(s) do
        res[i] = string.sub(s, i, i)
    end
    return res
end

function splitTable(t)
    -- split table of strings into table of table of characters
    local res = {}
    for i, v in ipairs(t) do
        res[i] = splitString(v)
    end
    return res
end

function filter(t, min, max)
    -- filter values in table that are outside range (min, max)
    local newt = {}
    for i, v in ipairs(t) do
        if v>min and v<max
            then
                table.insert(newt, v)
        end
    end
    return newt
end

function countNeighbors(t, iy, ix, max_x, max_y)
    -- count how many neighbor rolls a position has
    local nxs = {ix-1, ix, ix+1}
    local nys = {iy-1, iy, iy+1}
    nxs = filter(nxs, 0, (max_x+1))
    nys = filter(nys, 0, (max_y+1))
    local count = 0
    for _, x in ipairs(nxs) do
        for _, y in ipairs(nys) do
            local val = t[y][x]
            if val == "@"
                then
                    count = count+1
            end
        end
    end
    return count-1
end

function tableLength(t)
    -- return how many entries a table has 
    local count = 0
    for _ in pairs(t) do
        count = count + 1
    end
    return count
end

function countAccessableRolls(t)
    -- count how many rolls in table are accessable (neightbors<4)
    local max_x = tableLength(t[1])
    local max_y = tableLength(t)
    local count = 0
    for y, row in ipairs(t) do
        for x, val in ipairs(row) do
            if val == "@"
                then
                    local c = countNeighbors(t, y, x, max_x, max_y)
                    if c < 4
                        then
                            count = count + 1
                    end
            end
        end
    end
    return count
end

function findAccessableRolls(t)
    -- return coordinates of rolls that are accessable
    local max_x = tableLength(t[1])
    local max_y = tableLength(t)
    local accessable_rolls = {}
    for y, row in ipairs(t) do
        for x, val in ipairs(row) do
            if val == "@"
                then
                local c = countNeighbors(t, y, x, max_x, max_y)
                if c < 4
                    then
                        table.insert(accessable_rolls, {x, y})
                end
            end
        end
    end
    return accessable_rolls
end

function removeAccessableRolls(t, accessable_rolls)
    -- remove rolls at coordinates in accessable_rolls, return new table
    for i, coord in ipairs(accessable_rolls) do
        t[coord[2]][coord[1]] = "."
    end
    return t
end

-- solve puzzle
do
    -- read data
    local file = "data.txt"
    local lines = {}
    for line in io.lines(file) do
        lines[#lines+1] = line
    end
    local puzzle_input = splitTable(lines)
    -- solve part 1
    local count_part1 = countAccessableRolls(puzzle_input)
    print(count_part1)

    -- solve part 2
    local in_loop = true
    local count_part2 = 0
    while in_loop == true do
        local accs_rolls = findAccessableRolls(puzzle_input)
        count_part2 = count_part2 + tableLength(accs_rolls)
        puzzle_input = removeAccessableRolls(puzzle_input, accs_rolls)
        if tableLength(accs_rolls) == 0
            then
                in_loop = false
        end
    end
    print(count_part2)
end
