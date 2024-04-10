local util = require('telescope-glob.util')
require('telescope-glob.commands')

local M = {}

---@class set_glob_args
---@field value string
---@param args set_glob_args
---To clear the existing pattern, pass an empty string as the `value`.
M.set_glob = function(args)
	local glob = args.value
	-- TODO: rename global arg
	vim.g.glob = glob
end

M.get_glob = function() return vim.g.glob end

---@class candidate_entry
---@field value string
---@field display string|nil

---@class find_candidates_args
---@field flags string[] flags for `fd` (e.g. `{ '--max-depth=2' }`)
---@param args find_candidates_args
---@return candidate_entry[]
M.find_candidates = function(args)
	local cmd_prefix = { 'fd', '--type=directory' }
	local cmd = util.table_concat(cmd_prefix, args.flags)
	local result = vim.system(cmd, { text = true }):wait()
	-- parse string into table of strings
	local stdout = vim.split(result.stdout, '\n', { trimempty = true })
	-- P({ result, stdout })
	local candidates = vim.tbl_map(function(pattern)
		-- map over each result, converting it to a proper glob pattern
		return { value = '**/' .. pattern .. '**/*' }
	end, stdout)
	-- P({ candidates })
	return candidates
end

---@type candidate_entry
M.CLEAR_CANDIDATE = { display = 'Clear existing glob', value = '' }

return M
