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

In order for the selected glob pattern to take effect, we need to apply it to our pickers.

The process may be slightly different for every picker. For instance, the `find_files` picker uses [`fd`](https://github.com/sharkdp/fd) under the hood. On the command line, applying a custom glob to `fd` looks like this: `fd --full-path --glob **/mydir/**/*.lua`. Therefore, we must tell telescope to pass similar flags to `fd`.

Below are some examples on how to apply our glob pattern to some of the popular telescope pickers.

#### find_files

```lua
find_files = {
  find_command = function()
    local args = {
      'fd',
      '--no-ignore',
      '--hidden',
      '--type',
      'f',
      '--strip-cwd-prefix',

      -- glob config:
      '--full-path',
      '--glob',
      require('telescope-glob').get_glob() or '',
    }
    return args
  end,
},
```

To filter the results, see the `fd` [docs](https://github.com/sharkdp/fd?tab=readme-ov-file#excluding-specific-files-or-directories).

#### live_grep

```lua
live_grep = {
  additional_args = function()
    local args = {
      '--no-ignore',
      '--hidden',
      '--glob',
      require('telescope-glob').get_glob() or '**/*',
    }
    return args
  end,
},
```

To filter the results, see the `ripgrep` [docs](https://github.com/BurntSushi/ripgrep/blob/master/GUIDE.md#manual-filtering-globs).

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
