function splitString(s)
    local res = {}
    for i = 1, string.len(s) do
        res[i] = string.sub(s, i, i)
    end
    return res
end

function splitTable(t)
    local res = {}
    for i, v in ipairs(t) do
        res[i] = splitString(v)
    end
    return res
end

function filter(t, min, max)
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
    local count = 0
    for _ in pairs(t) do
        count = count + 1
    end
    return count
end

function countAccessableRolls(t)
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

test_input = {"..@@.@@@@.",
              "@@@.@.@.@@",
              "@@@@@.@.@@",
              "@.@@@@..@.",
              "@@.@@@@.@@",
              ".@@@@@@@.@",
              ".@.@.@.@@@",
              "@.@@@.@@@@",
              ".@@@@@@@@.",
              "@.@.@@@.@."}

test_input = splitTable(test_input)

-- solve part 1
do
    local file = "data.txt"
    local lines = {}
    for line in io.lines(file) do
        lines[#lines+1] = line
    end
    local puzzle_input = splitTable(lines)
    local count = countAccessableRolls(puzzle_input)
    print(count)
end
