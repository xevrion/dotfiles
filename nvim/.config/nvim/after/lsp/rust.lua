-- ~/.config/nvim/after/lsp/rust_analyzer.lua

return {
  settings = {
    ['rust-analyzer'] = {
      checkOnSave = true,
      check = {
        command = 'clippy',
      },
    },
  },
}
