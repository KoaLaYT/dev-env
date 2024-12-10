return {
  {
    name = "KoaLaYT's Plugin Lab",
    dir = '~/.local/myfirstplugin.nvim',
    config = function()
      require('myfirstplugin').setup()
    end,
  },
}
