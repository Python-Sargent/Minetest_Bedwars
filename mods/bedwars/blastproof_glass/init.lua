-- wool/init.lua

-- Load support for MT game translation.
local S = minetest.get_translator("blastproof_glass")

local dyes = dye.dyes

for i = 1, #dyes do
	local name, desc = unpack(dyes[i])

	local color_group = "color_" .. name

	minetest.register_node("blastproof_glass:" .. name, {
		description = S(desc .. " Blastproof Glass"),
		drawtype = "glasslike_framed_optional",
		paramtype = "light",
		tiles = {"blastproof_glass.png^[colorize:" .. name .. ":185"},
		use_texture_alpha = "clip",
		is_ground_content = false,
		sunlight_propogates = true,
		groups = {cracky = 1, glass = 1, [color_group] = 1, oddly_breakable_by_hand = 2, not_in_creative_inventory = 1},
		sounds = default.node_sound_glass_defaults(),
		on_blast = function() end,
	})
end
