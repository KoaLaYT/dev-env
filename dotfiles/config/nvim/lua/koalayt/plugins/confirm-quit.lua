local function setup_abbreviations()
  vim.cmd [[
		" FIX(alexmozaidze): Better function name (I am too bad at naming things)
		function! s:solely_in_cmd(command)
			return (getcmdtype() == ':' && getcmdline() ==# a:command)
		endfunction

		cnoreabbrev <expr> q <SID>solely_in_cmd('q') ? 'ConfirmQuit' : 'q'
		cnoreabbrev <expr> wq <SID>solely_in_cmd('wq') ? 'ConfirmQuit' : 'wq'
		cnoreabbrev <expr> qa <SID>solely_in_cmd('qa') ? 'ConfirmQuitAll' : 'qa'
		cnoreabbrev <expr> wqa <SID>solely_in_cmd('wqa') ? 'ConfirmQuitAll' : 'wqa'
	]]
end

return {
  'yutkat/confirm-quit.nvim',
  event = 'CmdlineEnter',
  config = function()
    require 'confirm-quit'.setup({
      overwrite_q_command = false,
    })
    setup_abbreviations()
  end,
}
