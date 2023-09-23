-- This executable is an auxiliary tool for peneira-symbols and peneira-lines.
--
-- For peneira-symbols, it builds a tree of tags from ctags output to print
-- it to stdout.
--
-- For peneira-lines, it prefixes each line from the temp file with its
-- number, padding them as necessary.

local peneira = require 'peneira'

-- A scope tree --
------------------

-- We are going to build a tree of scopes from the data fetched from
-- ctags. Each tag is potentially also a new scope. The structure of a
-- scope is:
--
--     {
--         tag...
--
--         parent           = _parent scope_,
--         ordered_children = _ordered (as in the file) table of children_,
--         children         = _children table keyed by kind and then name_,
--         scope_path       = _ordered table of scopes, from the parents to
--                             the current one_
--     }


local function add_to_scope(tag, scope)
    scope.ordered_children[#scope.ordered_children + 1] = tag

    local kind = scope.children[tag.kind] or {}
    kind[tag.name] = tag
    scope.children[tag.kind] = kind

    return scope
end

string.split = function(s, separator)
    local segments = {}
    local start = 1

    repeat
        local first, last = s:find(separator, start)

        if not first then
            first, last = #s + 1, #s + 1
        end

        segments[#segments + 1] = s:sub(start, first - 1)
        start = last + 1
    until start > #s

    return segments
end

local function path_from_scope_field(tag)
    if not tag.scope then return {} end

    -- Some filetypes (e.g. markup languages for documentation) use `""`
    -- as a scope separator since they can have any of `:`, `.` and `/`
    -- on their headings.
    --
    -- To avoid interpreting those characters as scopes separators (risking
    -- entering an infinite recursion), we will make the assumption that
    -- any scope name containing spaces is using `""` as a separator.
    if tag.scope:find([[""]]) or tag.scope:find("%s") then
        return tag.scope:split([[""]])
    end

    return tag.scope:split("[:./]")
end

-- Every tag can potentially define a new scope
local function new_scope_from_tag(tag, parent)
    tag.children = {}
    tag.ordered_children = {}
    tag.parent = parent
    tag.scope_path = path_from_scope_field(tag)
    tag.scope_path[#tag.scope_path + 1] = tag.name

    return tag
end

-- Sometimes a scope is referenced but doesn't have an associated tag in
-- the source file. So we create a dummy tag to represent the referenced scope.
local function new_scope(name, kind, index, parent)
    local scope_path = table.move(parent.scope_path, 1, #parent.scope_path, 1, {})
    scope_path[#scope_path + 1] = name

    local tag = {
        name = name,
        kind = kind,
        index = index,
        parent = parent,
        children = {},
        ordered_children = {},
        scope_path = scope_path,
    }

    add_to_scope(tag, parent)
    return tag
end

local function is_scope(tag)
    return tag.children
end

local function find_parent(tags, index, scope)
    if not scope then return nil end

    local tag = tags[index]

    if tag.scopeKind == scope.kind then return scope end

    for i = index, 1, -1 do
        local previous = tags[i]

        if previous and tag.scopeKind == previous.kind then
            if is_scope(previous) then return previous end
            return new_scope_from_tag(previous, scope)
        end
    end
end

local function scope_path(tags, index, scope)
    local tag = tags[index]

    if not tag.scope then
        -- Ctags can't properly handle scopes from tags whose names have
        -- spaces (like headings on an asciidoc file). If the tag doesn't
        -- have a `scope` field but does have a `scopeKind` field (in which
        -- case it does belong to some scope), we probably are dealing with
        -- this ctags limitation. So we look for a parent scope with the
        -- same kind as `scopeKind`.
        if tag.scopeKind then
            local parent = find_parent(tags, index, scope)
            if not parent then return {} end
            tag.scope = table.concat(parent.scope_path, [[""]])

            return parent.scope_path
        end

        return {}
    end

    return path_from_scope_field(tag)
end

local function find_tag(name, scope)
    for i = #scope.ordered_children, 1, -1 do
        local tag = scope.ordered_children[i]
        if tag.name == name then return tag end
    end
end

local function subscope(name, kind, index, scope)
    local tag
    local scope_kind = scope.children[kind]

    if scope_kind then
        tag = scope_kind[name]

    else
        tag = find_tag(name, scope)
    end

    if not tag then
        tag = new_scope(name, kind, index, scope)
    end

    if is_scope(tag) then return tag end

    return new_scope_from_tag(tag, scope)
end

local function same_scope(path1, path2)
    if #path1 ~= #path2 then return false end

    for i in ipairs(path1) do
        if path1[i] ~= path2[i] then return false end
    end

    return true
end

local function add_tag_to_scope(tags, index, scope)
    if index > #tags then return end

    local tag = tags[index]

    if tag.name:sub(1, 6) == "__anon" then
        -- Ignore anonymous fields
        return add_tag_to_scope(tags, index + 1, scope)
    end

    tag.index = index
    local tag_scope_path = scope_path(tags, index, scope)

    if #tag_scope_path < #scope.scope_path then
        return add_tag_to_scope(tags, index, scope.parent)
    end

    if #tag_scope_path > #scope.scope_path then
        local name = tag_scope_path[#scope.scope_path + 1]
        return add_tag_to_scope(tags, index, subscope(name, tag.scopeKind, index, scope))
    end

    -- At this point, we guarantee we are at a scope with the same level as
    -- the scope the tag belongs to.

    if same_scope(tag_scope_path, scope.scope_path) then
        add_to_scope(tag, scope)
        return add_tag_to_scope(tags, index + 1, scope)
    end

    -- If the current scope is not the scope the tag belongs to, search for
    -- a sibling scope.
    return add_tag_to_scope(tags, index, scope.parent)
end

local function build_tree(tags)
    local toplevel = { children = {}, ordered_children = {}, scope_path = {} }
    add_tag_to_scope(tags, 1, toplevel)
    return toplevel
end

local function print_tag(tag, scope_level)
    local indent = string.rep(" ", 4 * scope_level)
    local type = tag.typeref and " : " .. tag.typeref:sub(10) or ""
    local scope = tag.scope and string.format(" (%s)", tag.scope) or ""
    local info = string.format("%s%s %s%s%s %d", indent, tag.name, tag.kind, type, scope, tag.index)
    print(info)
end

local function print_tree(tree, scope_level)
    if not tree.ordered_children then return end

    scope_level = scope_level or 0

    for i, tag in ipairs(tree.ordered_children) do
        local previous = tree.ordered_children[i-1]

        -- Visually group each scope.
        if previous and (previous.ordered_children or tag.ordered_children) then
            print("")
        end

        print_tag(tag, scope_level)
        print_tree(tag, scope_level + 1)
    end
end

-- When this file is invoked with a subcommand, the global function
-- corresponding to that subcommand will be executed. E.g.:
--
--    filters symbols filename
--
-- will call the `symbols` function passing `filename` as its argument.


-- Print symbols --
-------------------

function symbols(filename)
    local tags = peneira.read_tags(filename)
    local tree = build_tree(tags)
    print_tree(tree)
end

-- Number lines --
------------------

function lines(filename)
    local file = io.open(filename, 'r')
    if not file then return end

    local lines = {}

    for line in file:lines() do
        lines[#lines + 1] = line
    end

    -- We are going to compute the padding needed for displaying
    -- the line numbers.
    local log = math.log10 or function(x) return math.log(x, 10) end
    local number_of_digits = math.floor(log(#lines)) + 1
    -- The format will become "%{#digits}d %s", where {#digits}
    -- is the number of digits in the biggest line number
    local format = string.format("%%%dd %%s", number_of_digits)

    for i, line in ipairs(lines) do
        print(string.format(format, i, line))
    end
end

local command = table.remove(arg, 1)
local unpack = unpack or table.unpack
_G[command](unpack(arg))
