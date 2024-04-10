local actions = require('telescope.actions')
local finders = require('telescope.finders')
local pickers = require('telescope.pickers')
local conf = require('telescope.config').values
local action_state = require('telescope.actions.state')
local glob = require('telescope-glob.init')
local util = require('telescope-glob.util')

local function picker(opts)
	---@type candidate_entry[]
	local candidates = util.table_concat(
		glob.find_candidates({ flags = { '--max-depth=2', '--min-depth=2' } }),
		glob.find_candidates({ flags = { '--max-depth=1', '--min-depth=1' } }),
		{
			{ value = '**/*.nix' },
			{ value = '**/*.lua' },
			{ value = '**/*.ts' },
			{ value = '**/*.svelte' },
		}
	)

	-- if candidates == nil then
	-- 	vim.notify('No candidates', vim.log.levels.ERROR)
	-- 	return nil
	-- end
	--
	-- if next(candidates) == nil then
	-- 	vim.notify('No candidates found', vim.log.levels.INFO)
	-- 	return nil
	-- end

	-- include an option that clears the existing glob
	table.insert(candidates, 1, glob.CLEAR_CANDIDATE)

	pickers
		.new(opts, {
			prompt_title = 'Globs',
			sorter = conf.generic_sorter(opts),
			finder = finders.new_table({
				results = candidates,
				entry_maker = function(entry)
					return {
						value = entry.value,
						display = entry.display or entry.value,
						ordinal = entry.value,
					}
				end,
			}),
			attach_mappings = function(prompt_bufnr, _)
				actions.select_default:replace(function()
					actions.close(prompt_bufnr)
					local selection = action_state.get_selected_entry()
					glob.set_glob({ value = selection.value })
				end)
				return true
			end,
		})
		:find()
end

return picker
