-- Disable legacy format-on-save and popup windows from `ziglang/zig.vim`
vim.g.zig_fmt_parse_errors = 0
vim.g.zig_fmt_autosave = 0

local zig_group = vim.api.nvim_create_augroup('ZigFormatAndCheck', { clear = true })

vim.api.nvim_create_autocmd('BufWritePre', {
  group = zig_group,
  pattern = { '*.zig', '*.zon' },
  callback = function() vim.lsp.buf.format() end,
})

return {
  settings = {
    zls = {
      enable_build_on_save = true,

      inlay_hints_hide_redundant_param_names = true,
      inlay_hints_hide_redundant_param_names_last_token = true,

      warn_style = true
    },
  },
}
