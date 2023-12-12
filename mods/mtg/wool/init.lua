-- wool/init.lua

-- Load support for MT game translation.
local S = minetest.get_translator("wool")

local dyes = dye.dyes

for i = 1, #dyes do
	local name, desc = unpack(dyes[i])

	local color_group = "color_" .. name

	minetest.register_node("wool:" .. name, {
		description = S(desc .. " Wool"),
		tiles = {"wool_" .. name .. ".png"},
		is_ground_content = false,
		stack_max = 64,
		groups = {snappy = 3, oddly_breakable_by_hand = 2,
				flammable = 3, wool = 1, [color_group] = 1},
		sounds = default.node_sound_leaves_defaults(),
		on_blast = function(pos)
			minetest.remove_node(pos)
		end,
	})
end
