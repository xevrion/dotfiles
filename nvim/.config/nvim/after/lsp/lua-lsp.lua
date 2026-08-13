-- ~/.config/nvim/after/lsp/lua_ls.lua

return {
  on_init = function(client)
    client.server_capabilities.documentFormattingProvider = false

    if client.workspace_folders then
      local path = client.workspace_folders[1].name
      if path ~= vim.fn.stdpath 'config' and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc')) then return end
    end

    client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
      runtime = {
        version = 'LuaJIT',
        path = { 'lua/?.lua', 'lua/?/init.lua' },
      },
      workspace = {
        checkThirdParty = false,
        library = vim.tbl_extend('force', vim.api.nvim_get_runtime_file('', true), {
          '${3rd}/luv/library',
          '${3rd}/busted/library',
        }),
      },
    })
  end,
  settings = {
    Lua = {
      format = { enable = false },
    },
  },
}
