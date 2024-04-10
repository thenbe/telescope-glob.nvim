---allows updating the glob. (prefill with current value)
---`:let g:glob = "**/*.ts"`
---`:lua vim.g.glob = "**/*.ts"`
vim.api.nvim_create_user_command('GlobUpdate', function()
	-- ALT: vim.ui.input
	local glob = vim.g.glob or ''
	local prefix = ':lua vim.g.glob ='
	vim.api.nvim_input(prefix .. " '" .. glob .. "'")
	-- set cursor before closing quote
	vim.api.nvim_input('<left>')
end, {
	desc = 'Update search glob',
})

---Helper, prefills command line with: :lua vim.g.glob = '**/{cursor_here}/**/*'
vim.api.nvim_create_user_command('GlobDir', function()
	local glob = vim.g.glob or ''
	local prefix = ":lua vim.g.glob = '**/"
	local suffix = "/**/*'"
	vim.api.nvim_input(prefix .. glob .. suffix)
	-- set cursor before closing quote
	vim.api.nvim_input('<left><left><left><left><left><left>')
end, {
	desc = 'Update search glob',
})
