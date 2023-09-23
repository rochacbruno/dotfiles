local fzy = require "fzy"

-- Merge the data given by fzy.filter at each step with the accumulated
-- value of previous steps.
--
-- The first argument is a table containing the filtered lines up to the
-- current iteration and the accumulated information of previous calls
-- to fzy.filter:
--
--     {
--         lines = { line... },
--         matches = { line_number, { match_position... }, score }
--     }
--
-- The second argument is a table containing the data returned by fzy.filter
-- at the current iteration:
--
--     {
--         matches = { line_number, { match_position... }, score }
--     }
--
local function accumulate(accumulated, data)
    local lines = {}

    for i, item in ipairs(data.matches) do
        -- Keep only filtered lines
        local line_number = item[1]
        lines[i] = accumulated.lines[line_number]
        -- Reference the line number of the filtered table, not the original one
        item[1] = i

        if accumulated.matches then
            local accum = accumulated.matches[line_number]
            -- Concatenate table of positions
            item[2] = table.move(item[2], 1, #item[2], #accum[2] + 1, accum[2])
            -- Sum scores
            item[3] = item[3] + accum[3]
        end
    end

    data.lines = lines
    return data
end

-- We are going to filter the candidates based on the text inserted on
-- the prompt. The text is split in words, and each word is used to refine
-- the filter performed using previous words. Each pass does the following
-- steps:
--
--   1. filter lines that match the word;
--   2. for each filtered line, compute its score as an integer based on
--      fzy algorithm (higher is better);
--   3. add such score to the accumulated value of previous iterations;
--   4. for each filtered line, compute the positions of the matches as a table
--      of indices;
--   5. concatenate that table of indices with the accumulated table of
--      previous iterations.
--
-- Steps 1, 2 and 4 are done all at once by the fzy.filter function. It
-- returns a table with the following structure:
--
--     { line_number, { match_position... }, score }
--
-- Steps 3 and 5 are done by the accumulate function.
local function filter(filename, prompt, rank)
    local file = io.open(filename, 'r')

    if not file then
        kak.fail("couldn't open temporary file " .. filename)
        return
    end

    local lines = {}

    for line in file:lines() do
        lines[#lines + 1] = line
    end

    local data = { lines = lines }

    for word in prompt:gmatch("%S+") do
        local matches = fzy.filter(word, data.lines)
        data = accumulate(data, { matches = matches })
    end

    local highest_score = {1, {}, fzy.get_score_min()}

    if rank then
        table.sort(data.matches, function(a, b)
            -- Sort based on the scores. Higher is better.
            return a[3] > b[3]
        end)

    else
        for _, match in ipairs(data.matches) do
            if match[3] > highest_score[3] then
                highest_score = match
            end
        end
    end

    local positions = {}
    local filtered = {}

    for i, item in ipairs(data.matches) do
        positions[i] = item[2]
        filtered[i] = data.lines[item[1]]
    end

    return filtered, positions, highest_score[1]
end

local function range_specs(positions)
    local specs = {}

    for line, chars in ipairs(positions) do
        if line > 200 then break end -- Unlikely that more than 200 lines can be seen

        for _, char in ipairs(chars) do
            specs[#specs + 1] = string.format("%d.%d,%d.%d|@PeneiraMatches", line, char, line, char)
        end
    end

    return specs
end

-- Functions to manipulate ctags data

local function read_tags(file)
    local command = string.format("ctags --output-format=json --fields=+n --sort=no -f - '%s'", file)
    local ctags = io.popen(command)
    local data = ctags:read('a')

    -- Convert JSON objects to lua tables
    data = data:gsub('("[^"]-"):','[%1]='):gsub("\n", ", ")
    local chunk = string.format("return {%s}", data)
    return load(chunk)()
end

return {
    filter = filter,
    range_specs = range_specs,
    read_tags = read_tags,
}
