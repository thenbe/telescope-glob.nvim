local has_telescope, telescope = pcall(require, 'telescope')
local picker = require('telescope-glob.picker')

if not has_telescope then
	error('Install nvim-telescope/telescope.nvim to use telescope-glob.nvim.')
end

local opts = {}
local default_opts = {
	-- candidates = {}
}

return telescope.register_extension({
	setup = function(external_opts, _) opts = vim.tbl_extend('force', default_opts, external_opts) end,
	exports = {
		glob = function() picker(opts) end,
	},
})
