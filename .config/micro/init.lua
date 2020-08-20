-- Save this file to ~/.config/micro/init.lua
-- requirements:
--   Python3
--     - isort
--     - black
--     - flake8
--     - ipython
--   Rust
--     - cargo-eval
--     - evcxr_repl
--     - clippy
--     - fmt

VERSION = "0.0.3"

local micro = import("micro")
local config = import("micro/config")
local shell = import("micro/shell")
local buffer = import("micro/buffer")

function init()
    -- this will modify the bindings.json file
    -- true means overwrite any existing binding
    config.TryBindKey("Alt-b", "lua:initlua.build", true)
    config.TryBindKey("Alt-o", "lua:initlua.output", true)
    config.TryBindKey("Alt-t", "lua:initlua.test", true)
    config.TryBindKey("Alt-f", "lua:initlua.format", true)
    config.TryBindKey("Alt-i", "lua:initlua.repl", true)
    config.TryBindKey("Alt-l", "lua:initlua.lint", true)
    config.TryBindKey("Alt-y", "lua:initlua.sort_imports", true)
    config.TryBindKey("CtrlRightSq", "lua:initlua.vsplit_left", true)
    config.TryBindKey("Alt-|", "lua:initlua.new_view", true)
    config.TryBindKey("Alt-z", "lua:initlua.toggleSoftwrap", true)
    -- TODO: Add rename variable utility (example below)
    -- https://github.com/micro-editor/go-plugin/blob/8d7c7dfd4488e25a2e3f5eb37aac3ccacc0143bc/go.lua#L44
end

-- utils

function setContains(set, key)
    return set[key] ~= nil
end

-- below code adds new buffer with "hello content"
-- micro.CurPane():VSplitIndex(buffer.NewBuffer("hello", "filename"), true)

-- actions

function toggleSoftwrap(bp)
    bp.Buf.Settings["softwrap"] = not bp.Buf.Settings["softwrap"]
end

function vsplit_left(bp)
    -- Open a new Vsplit (on the very left)
    -- false means right=false
    micro.CurPane():VSplitIndex(buffer.NewBuffer("", ""), false)
end

function new_view(bp)
    -- Open same file Vsplit (on the very right)
    -- true means right=true
    -- bp.Buf.Type.Readonly = true
    micro.CurPane():VSplitIndex(bp.Buf, true)
    micro.InfoBar():Message("New View same file")
end

function output(bp)
    micro.Log("init.lua script output")
    bp:Save()
    local buf = bp.Buf

    _command = {}
    _command["go"] = "go run " .. buf.Path
    -- cargo install cargo-play
    _command["rust"] = "cargo eval " .. buf.Path
    _command["python"] = "python3 " .. buf.Path

    run_action(bp.Buf, _command, "Output", true) -- false=no bottom panel

end

function build(bp)
    micro.Log("init.lua build")
    bp:Save()
    local buf = bp.Buf

    _command = {}
    _command["go"] = "go run " .. buf.Path
    -- cargo install cargo-play
    _command["rust"] = "cargo eval " .. buf.Path
    _command["python"] = "python3 " .. buf.Path

    -- the true means run in the foreground
    -- the false means send output to stdout (instead of returning it)
    shell.RunInteractiveShell(_command[buf:FileType()], true, false)

end

function test(bp)
    micro.Log("init.lua test")

    bp:Save()
    local buf = bp.Buf

    _command = {}
     _command["go"] = "go test -v " .. buf.Path
    -- TODO: make cargo to run specific file tests
    _command["rust"] = "cargo eval --test " .. buf.Path
    -- _command["rust"] = "cargo test -v --color always "
    _command["python"] = "python3 -m pytest -svx " .. buf.Path

    -- the true means run in the foreground
    -- the false means send output to stdout (instead of returning it)
    -- shell.RunInteractiveShell(_command[buf:FileType()], true, false)

    -- Opens test output in a new bottom panel
    run_action(bp.Buf, _command, "Test", true) -- false=no bottom panel
end

function format(bp)
    micro.Log("init.lua format")

    local buf = bp.Buf
    local filetype = buf:FileType()

    _command = {}
    _command["go"] = "go fmt -w" .. buf.Path
    _command["rust"] = "rustfmt -v -l --backup --edition=2018 " .. buf.Path
    _command["python"] = "black -l 79 " .. buf.Path

    if not setContains(_command, filetype) then
        return
    end

    bp:Save()  -- TODO: is it saving twice
    run_action(bp.Buf, _command, "Format", false) -- false=no bottom panel
    buf:ReOpen()
end

function sort_imports(bp)
    micro.Log("init.lua sort_imports")

    local buf = bp.Buf
    local filetype = buf:FileType()

    _command = {}
    _command["go"] = "goimports -w " .. buf.Path
    _command["python"] = "isort " .. buf.Path

    if not setContains(_command, filetype) then
        return
    end

    bp:Save()  -- TODO: is it saving twice
    run_action(bp.Buf, _command, "SortImports", false) -- false=no bottom panel
    buf:ReOpen()
end

function repl(bp)
    micro.Log("init.lua repl")

    bp:Save()
    local buf = bp.Buf

    _command = {}
    -- _command["go"] = "go ? " .. buf.Path
    -- cargo install evcxr_repl
    _command["rust"] = "evcxr "
    -- TODO: make evcxr interactive? print usage info before opening
    _command["python"] = "ipython -i " .. buf.Path

    -- the true means run in the foreground
    -- the false means send output to stdout (instead of returning it)
     shell.RunInteractiveShell(_command[buf:FileType()], true, false)

end

function lint(bp)
    micro.Log("init.lua lint")

    bp:Save()
    _command = {}
    -- _command["go"] = "go ? " .. buf.Path
    _command["rust"] = "cargo-clippy "
    _command["python"] = "flake8 " .. bp.Buf.Path
    run_action(bp.Buf, _command, "Linter", true)
end

-- function onSave(bp)
    -- micro.Log("init.lua onSave")
    -- sort_imports(bp)
    -- format(bp)

    -- TODO: Use config to decide what to run on save.
    -- example: https://github.com/micro-editor/go-plugin/blob/8d7c7dfd4488e25a2e3f5eb37aac3ccacc0143bc/go.lua#L10
    -- if bp.Buf:FileType() == "go" then
        -- if bp.Buf.Settings["go.goimports"] then
            -- goimports(bp)
        -- elseif bp.Buf.Settings["go.gofmt"] then
            -- gofmt(bp)
        -- end
    -- end
    -- return true
-- end

function onBufferOpen(buf)
	local filetype = buf:FileType()
    micro.Log("Filetype is:" .. filetype)
    _tabs = {}
    _tabs["makefile"] = true
    _tabs["go"] = true
    _tabs["snippets"] = true

    if not setContains(_tabs, filetype) then
        buf:SetOption("tabstospaces", "off")
    else
        buf:SetOption("tabstospaces", "on")
    end
end

function run_action(buf, commands, identifier, bottom_panel)

    micro.Log("init.lua run_action" .. identifier)

    local filetype = buf:FileType()

    if not setContains(commands, filetype) then
        return  -- if filetype does not support action just return
    end

    local output, err = shell.RunCommand(commands[filetype])

    local msg = output
    if err ~= nil then
        msg = msg .. tostring(err)
    end

    if msg ~= "" then
        if bottom_panel then
            local new_buffer = buffer.NewBuffer(msg, '')
            -- -- Looks like it is not a good idea to have it readonly
            -- new_buffer.Settings["filetype"] = filetype
            -- new_buffer.Settings["readonly"] = true
            -- new_buffer.Type.Readonly = true
            micro.CurPane():HSplitIndex(
                new_buffer,
                true -- means bottom split
            )
        else
            if err ~= nil then
                micro.InfoBar():Error(msg)
            else
                micro.InfoBar():Message(msg)
            end
            return
        end
    else
       micro.InfoBar():Message(identifier .. ": all good :)")
    end

end
