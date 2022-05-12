local gps_status, gps = pcall(require, "nvim-gps")
if not gps_status then
  print('no gps')
  return
end

gps.setup({

	disable_icons = false,           -- Setting it to true will disable all icons

	icons = {
		["class-name"] = " ",      -- Classes and class-like objects
		["function-name"] = " ",   -- Functions
		["method-name"] = " ",     -- Methods (functions inside class-like objects)
		["container-name"] = ' ',  -- Containers (example: lua tables)
		["tag-name"] = '炙'         -- Tags (example: html tags)
	},

	-- Add custom configuration per language or
	-- Disable the plugin for a language
	-- Any language not disabled here is enabled by default
	languages = {
		-- Some languages have custom icons
		["json"] = {
			icons = {
				["array-name"] = ' ',
				["object-name"] = ' ',
				["null-name"] = '[] ',
				["boolean-name"] = 'ﰰﰴ ',
				["number-name"] = '# ',
				["string-name"] = ' '
			}
		},
		["latex"] = {
			icons = {
				["title-name"] = "# ",
				["label-name"] = " ",
			},
		},
	},

	separator = ' > ',

	-- limit for amount of context shown
	-- 0 means no limit
	depth = 0,

	-- indicator used when context hits depth limit
	depth_limit_indicator = ".."
})
