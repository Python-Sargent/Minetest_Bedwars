-- wool/init.lua

-- Load support for MT game translation.
local S = minetest.get_translator("wool")

local dyes = dye.dyes

for i = 1, #dyes do
	local name, desc = unpack(dyes[i])

	local color_group = "color_" .. name

	minetest.register_node("wool:" .. name, {
		description = S(desc .. " Wool"),
		tiles = {"wool.png^[colorize:" .. name .. ":185"},
		is_ground_content = false,
		stack_max = 64,
		groups = {flammable = 3, wool = 1, [color_group] = 1, not_in_creative_inventory = 1},
		sounds = default.node_sound_leaves_defaults(),
		on_blast = function(pos)
			minetest.remove_node(pos)
		end,
	})
	
	minetest.register_node("wool:" .. name .. "_map", {
		description = S(desc .. " Wool (Map)"),
		tiles = {"wool.png^[colorize:" .. name .. ":185"},
		is_ground_content = false,
		groups = {map_node = 1, [color_group] = 1},
		sounds = default.node_sound_leaves_defaults(),
		on_blast = function() end,
		can_dig = can_dig_map,
	})
end
