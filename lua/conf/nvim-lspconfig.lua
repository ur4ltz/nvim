-- vim: ts=4 sw=4 et:

local api = vim.api
local lspconfig = require('lspconfig')

-- local M = {}

local custom_attach = function(client)
    require('completion').on_attach(client)
    -- require('diagnostic').on_attach(client)
end

local function get_lua_runtime()
    local result = {}
    for _, path in pairs(api.nvim_list_runtime_paths()) do
        local lua_path = path .. "/lua/";
        if vim.fn.isdirectory(lua_path) then
            result[lua_path] = true
        end
    end
    result[vim.fn.expand("$VIMRUNTIME/lua")] = true
    return result;
end

local system_name = 'Linux'
local sumneko_root_path = vim.fn.expand('$HOME/github/lua-language-server')
local sumneko_binary = sumneko_root_path.."/bin/"..system_name.."/lua-language-server"
local servers = {
    bashls = {},
    ccls = {},
    vimls = {},
    pyls = {},
    sumneko_lua = {
        cmd = {sumneko_binary, '-E', sumneko_root_path .. '/main.lua'},
        settings = {
            Lua = {
                runtime = {
                    version = 'LuaJIT',
                    path = vim.split(package.path, ";")
                },
                completion = {
                    keywordSnippet = 'Disable'
                },
                diagnostics = {
                    workspaceDelay = -1,
                    enable = true,
                    globals = {'vim', 'map', 'range', 'reduce', 'tail', 'nth', 'use'},
                    -- disable = {'unused-local', 'unused-vararg', 'lowercase-global'}
                },
                workspace = {
                    library = get_lua_runtime()
                }
            }
        }
    },
}

for server, config in pairs(servers) do
    config.on_attach = custom_attach
    lspconfig[server].setup(config)
end
