---Helper for setting a new glob pattern. Prefills command prompt with
---boilerplate:
---```vim
---:lua require('telescope-glob.init').set_glob({ value = '$CURSOR_HERE' })
---```
vim.api.nvim_create_user_command('GlobUpdate', function()
	-- ALT: vim.ui.input
	local glob = require('telescope-glob.init')
	local glob_value = glob.get_glob() or ''
	local prefix = ":lua require('telescope-glob.init').set_glob({ value = '"
	local suffix = "' })"
	vim.api.nvim_input(prefix .. glob_value .. suffix)
	-- set cursor in correct position
	vim.api.nvim_input('<left><left><left><left>')
end, {
	desc = 'Update search glob',
})

---Helper for setting a new glob pattern to a custom directory. Prefills command
---prompt with boilerplate:
---```vim
---:lua require('telescope-glob.init').set_glob({ value = '**/$CURSOR_HERE/**/*' })
---```
vim.api.nvim_create_user_command('GlobDir', function()
	local glob = require('telescope-glob.init')
	local glob_value = glob.get_glob() or ''
	local prefix = ":lua require('telescope-glob.init').set_glob({ value = '**/"
	local suffix = "/**/*' })"
	vim.api.nvim_input(prefix .. glob_value .. suffix)
	-- set cursor in correct position
	vim.api.nvim_input('<left><left><left><left><left><left><left><left><left>')
end, {
	desc = 'Update search glob',
})
