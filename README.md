[telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) is built on configurable search tools such as
[fd](https://github.com/sharkdp/fd) and [ripgrep](https://github.com/BurntSushi/ripgrep). Both search tools support glob
patterns. This plugin offers some helpers for scoping searches to a custom glob pattern in the current instance of nvim.

This plugin is inspired by a similar vscode feature:

![2024-07-12-14-53-01](https://github.com/user-attachments/assets/6872ef5f-8114-4b4b-b2d8-affb0cb0d34d)

## Usage

- Type in a custom glob with `:GlobUpdate`. If you intend to glob an entire directory, use `:GlobDir` as it will directly place your cursor between the asterisks (e.g. `**/|/**/*`).
- Get a list of glob suggestions with `:Telescope glob`. The suggestions are based on the shape of the current directory. After choosing a glob pattern, future telescope pickers will be scoped to that glob pattern. To clear the pattern, run `:Telescope glob` once more and select "Clear existing glob".

## How it works

This plugin doesn't do a whole lot. This doc probably contain more lines than the actual code, so feel free to rip out the functionality right into your config instead of installing this plugin. But anyways:

1. You give it a glob pattern through commands such as `:GlobUpdate`, `:Telescope glob`, or `require('telescope-glob').set_glob({ value = '**/*.lua' })`.
1. The glob is stored as a string in a global variable.
1. You can ask for the current glob value with `require('telescope-glob').get_glob()`.

## Installation

### 1. Install

```lua
{
  'thenbe/telescope-glob.nvim',
  dependencies = { 'nvim-telescope/telescope.nvim' },
  config = function() require('telescope').load_extension('glob') end,
  keys = {
    { '<leader>fg', '<cmd> Telescope glob <CR>', desc = 'Pick a glob' },
    { '<leader>mgg', '<cmd>GlobUpdate<cr>', desc = 'Enter a glob' },
    { '<leader>mgd', '<cmd>GlobDir<cr>', desc = 'Enter a directory glob' },
    { '<leader>mgc', function() require('telescope-glob').set_glob({ value = '' }) end, desc = 'Clear the glob' },
    { '<leader>mgl', function() require('telescope-glob').set_glob({ value = '**/*.lua' }) end, desc = 'Set the glob (lua)' },
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

### `lualine.nvim` Component

Optional. When configured, it'll show the current glob pattern in the statusline. As per `lualine.nvim` [docs](https://github.com/nvim-lualine/lualine.nvim?tab=readme-ov-file#lua-expressions-as-lualine-component):

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

## Further reading

- Glob tester: https://globster.xyz
- Glob primer: https://github.com/isaacs/node-glob/blob/main/README.md#glob-primer

## Also see

- https://github.com/fdschmidt93/telescope-egrepify.nvim
- https://github.com/axkirillov/easypick.nvim
