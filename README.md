## Installation

### 1. Install

```lua
{
	'thenbe/telescope-glob.nvim',
	dependencies = { 'nvim-telescope/telescope.nvim' },
	config = function() require('telescope').load_extension('glob') end,
	keys = {
		{ '<leader>fg', '<cmd> Telescope glob <CR>', desc = 'Select glob pattern' },
		{ '<leader>mgg', '<cmd>GlobUpdate<cr>', desc = 'Update glob pattern' },
		{ '<leader>mgd', '<cmd>GlobDir<cr>', desc = 'Enter custom glob pattern' },
		{ '<leader>mgc', function() require('telescope-glob').set_glob({ value = '' }) end, desc = 'Clear glob pattern' },
		-- { '<leader>mgl', function() require('telescope-glob').set_glob({ value = '**/*.lua' }) end, desc = 'Set glob pattern to lua files only' },
	},
}
```

### 2. Apply to pickers of choice

TODO: illustrate how to apply the glob pattern to various telescope pickers.

### (optional) `lualine.nvim` Component

As per `lualine.nvim` [docs](https://github.com/nvim-lualine/lualine.nvim?tab=readme-ov-file#lua-expressions-as-lualine-component):

```lua
sections = {
	lualine_x = {
		-- telescope-glob.nvim
		{
			function()
				local glob_pattern = require('telescope-glob').get_glob()
				return glob_pattern and ('  ' .. glob_pattern) or ''
			end,
			cond = function()
				return package.loaded['telescope'].extensions.glob and require('telescope-glob').get_glob() ~= ''
			end,
		},
	},
}
```
