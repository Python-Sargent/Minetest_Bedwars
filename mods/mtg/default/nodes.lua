-- mods/default/nodes.lua

-- support for MT game translation.
local S = default.get_translator

--[[ Node name convention:

Although many node names are in combined-word form, the required form for new
node names is words separated by underscores. If both forms are used in written
language (for example pinewood and pine wood) the underscore form should be used.

--]]


--[[ Index:

Stone
-----
(1. Material 2. Cobble variant 3. Brick variant 4. Modified forms)

default:stone
default:cobble
default:stonebrick

default:sandstone
default:sandstonebrick

default:obsidian

Soft / Non-Stone
----------------
(1. Material 2. Modified forms)

default:dirt
default:dirt_with_grass

default:sand

default:ice

Mineral Blocks
--------------
default:steelblock
default:mese
default:diamondblock

Trees
-----
(1. Trunk 2. Fabricated trunk 3. Leaves 4. Sapling 5. Fruits)

default:tree
default:wood

Liquids
-------
(1. Source 2. Flowing)

default:water_source
default:water_flowing

default:lava_source
default:lava_flowing

Tools / "Advanced" crafting / Non-"natural"
-------------------------------------------

default:ladder_wood

default:glass

default:brick

default:meselamp
default:mese_post_light

Misc
----

default:cloud

--]]

-- Required wrapper to allow customization of default.after_place_leaves
local function after_place_leaves(...)
	return default.after_place_leaves(...)
end

-- Required wrapper to allow customization of default.grow_sapling
local function grow_sapling(...)
	return default.grow_sapling(...)
end

default.can_dig_map = function(pos, player)
	if player and player:is_player() then
		local privs = minetest.get_player_privs(player:get_player_name())
		if privs.creative == true then
			return true
		end
	else
		return false
	end
end

--can_dig = function(pos, [player]),

--
-- Stone
--

minetest.register_node("default:stone", {
	description = S("Stone"),
	tiles = {"default_stone.png"},
	groups = {cracky = 3, stone = 1},
	legacy_mineral = true,
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("default:cobble", {
	description = S("Cobblestone"),
	tiles = {"default_cobble.png"},
	is_ground_content = false,
	groups = {map_node = 1, stone = 2},
	sounds = default.node_sound_stone_defaults(),
	on_blast = function() end,
	can_dig = default.can_dig_map,
})

minetest.register_node("default:stonebrick", {
	description = S("Stone Brick"),
	paramtype2 = "facedir",
	place_param2 = 0,
	tiles = {"default_stone_brick.png"},
	is_ground_content = false,
	groups = {map_node = 1, stone = 1},
	sounds = default.node_sound_stone_defaults(),
	on_blast = function() end,
	can_dig = default.can_dig_map,
})

minetest.register_node("default:sandstone", {
	description = S("Sandstone"),
	tiles = {"default_sandstone.png"},
	groups = {sandstone = 1, cracky = 2},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("default:sandstonebrick", {
	description = S("Sandstone Brick"),
	paramtype2 = "facedir",
	place_param2 = 0,
	tiles = {"default_sandstone_brick.png"},
	is_ground_content = false,
	groups = {map_node = 1},
	sounds = default.node_sound_stone_defaults(),
	on_blast = function() end,
	can_dig = default.can_dig_map,
})

minetest.register_node("default:obsidian", {
	description = S("Obsidian"),
	tiles = {"default_obsidian.png"},
	sounds = default.node_sound_stone_defaults(),
	groups = {cracky = 1, level = 2},
	on_blast = function() end,
})

--
-- Soft / Non-Stone
--

minetest.register_node("default:dirt", {
	description = S("Dirt"),
	tiles = {"default_dirt.png"},
	groups = {map_node = 1, soil = 1},
	sounds = default.node_sound_dirt_defaults(),
	on_blast = function() end,
	can_dig = default.can_dig_map,
})

minetest.register_node("default:dirt_with_grass", {
	description = S("Dirt with Grass"),
	tiles = {"default_grass.png", "default_dirt.png",
		{name = "default_dirt.png^default_grass_side.png",
			tileable_vertical = false}},
	groups = {map_node = 1},
	sounds = default.node_sound_dirt_defaults({
		footstep = {name = "default_grass_footstep", gain = 0.25},
	}),
	on_blast = function() end,
	can_dig = default.can_dig_map,
})

minetest.register_node("default:ice", {
	description = S("Ice"),
	tiles = {"default_ice.png"},
	is_ground_content = false,
	paramtype = "light",
	groups = {map_node = 1, cools_lava = 1, slippery = 3},
	sounds = default.node_sound_ice_defaults(),
	on_blast = function() end,
	can_dig = default.can_dig_map,
})

--
-- Trees
--

minetest.register_node("default:tree", {
	description = S("Apple Tree"),
	tiles = {"default_tree_top.png", "default_tree_top.png", "default_tree.png"},
	paramtype2 = "facedir",
	is_ground_content = false,
	groups = {tree = 1, map_node = 1},
	sounds = default.node_sound_wood_defaults(),

	on_place = minetest.rotate_node,
	on_blast = function() end,
	can_dig = default.can_dig_map,
})

minetest.register_node("default:wood", {
	description = S("Apple Wood Planks"),
	paramtype2 = "facedir",
	place_param2 = 0,
	tiles = {"default_wood.png"},
	is_ground_content = false,
	groups = {map_node = 1, wood = 1},
	sounds = default.node_sound_wood_defaults(),
	on_blast = function() end,
	can_dig = default.can_dig_map,
})

--
-- Liquids
--

minetest.register_node("default:water_source", {
	description = S("Water Source"),
	drawtype = "liquid",
	waving = 3,
	tiles = {
		{
			name = "default_water_source_animated.png",
			backface_culling = false,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 2.0,
			},
		},
		{
			name = "default_water_source_animated.png",
			backface_culling = true,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 2.0,
			},
		},
	},
	use_texture_alpha = "blend",
	paramtype = "light",
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	is_ground_content = false,
	drop = "",
	drowning = 1,
	liquidtype = "source",
	liquid_alternative_flowing = "default:water_flowing",
	liquid_alternative_source = "default:water_source",
	liquid_viscosity = 1,
	post_effect_color = {a = 103, r = 30, g = 60, b = 90},
	groups = {water = 3, liquid = 3, cools_lava = 1},
	sounds = default.node_sound_water_defaults(),
	on_blast = function() end,
})

minetest.register_node("default:water_flowing", {
	description = S("Flowing Water"),
	drawtype = "flowingliquid",
	waving = 3,
	tiles = {"default_water.png"},
	special_tiles = {
		{
			name = "default_water_flowing_animated.png",
			backface_culling = false,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 0.5,
			},
		},
		{
			name = "default_water_flowing_animated.png",
			backface_culling = true,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 0.5,
			},
		},
	},
	use_texture_alpha = "blend",
	paramtype = "light",
	paramtype2 = "flowingliquid",
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	is_ground_content = false,
	drop = "",
	drowning = 1,
	liquidtype = "flowing",
	liquid_alternative_flowing = "default:water_flowing",
	liquid_alternative_source = "default:water_source",
	liquid_viscosity = 1,
	post_effect_color = {a = 103, r = 30, g = 60, b = 90},
	groups = {water = 3, liquid = 3, not_in_creative_inventory = 1,
		cools_lava = 1},
	sounds = default.node_sound_water_defaults(),
	on_blast = function() end,
})

minetest.register_node("default:lava_source", {
	description = S("Lava Source"),
	drawtype = "liquid",
	tiles = {
		{
			name = "default_lava_source_animated.png",
			backface_culling = false,
			animation = {
				type = "vertical_frames",
				aspect_w = 32,
				aspect_h = 32,
				length = 5.0,
			},
		},
		{
			name = "default_lava_source_animated.png",
			backface_culling = true,
			animation = {
				type = "vertical_frames",
				aspect_w = 32,
				aspect_h = 32,
				length = 4.0,
			},
		},
	},
	paramtype = "light",
	light_source = default.LIGHT_MAX - 1,
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	is_ground_content = false,
	drop = "",
	drowning = 1,
	liquidtype = "source",
	liquid_alternative_flowing = "default:lava_flowing",
	liquid_alternative_source = "default:lava_source",
	liquid_viscosity = 7,
	liquid_renewable = false,
	damage_per_second = 4 * 2,
	post_effect_color = {a = 191, r = 255, g = 64, b = 0},
	groups = {lava = 3, liquid = 2, igniter = 1},
	on_blast = function() end,
})

minetest.register_node("default:lava_flowing", {
	description = S("Flowing Lava"),
	drawtype = "flowingliquid",
	tiles = {"default_lava.png"},
	special_tiles = {
		{
			name = "default_lava_flowing_animated.png",
			backface_culling = false,
			animation = {
				type = "vertical_frames",
				aspect_w = 32,
				aspect_h = 32,
				length = 3.3,
			},
		},
		{
			name = "default_lava_flowing_animated.png",
			backface_culling = true,
			animation = {
				type = "vertical_frames",
				aspect_w = 32,
				aspect_h = 32,
				length = 3.3,
			},
		},
	},
	paramtype = "light",
	paramtype2 = "flowingliquid",
	light_source = default.LIGHT_MAX - 1,
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	is_ground_content = false,
	drop = "",
	drowning = 1,
	liquidtype = "flowing",
	liquid_alternative_flowing = "default:lava_flowing",
	liquid_alternative_source = "default:lava_source",
	liquid_viscosity = 7,
	liquid_renewable = false,
	damage_per_second = 4 * 2,
	post_effect_color = {a = 191, r = 255, g = 64, b = 0},
	groups = {lava = 3, liquid = 2, igniter = 1, not_in_creative_inventory = 1},
	on_blast = function() end,
})

--
-- Tools / "Advanced" crafting / Non-"natural"
--

local function register_sign(material, desc, def)
	minetest.register_node("default:sign_wall_" .. material, {
		description = desc,
		drawtype = "nodebox",
		tiles = {"default_sign_wall_" .. material .. ".png"},
		inventory_image = "default_sign_" .. material .. ".png",
		wield_image = "default_sign_" .. material .. ".png",
		paramtype = "light",
		paramtype2 = "wallmounted",
		sunlight_propagates = true,
		is_ground_content = false,
		walkable = false,
		use_texture_alpha = "opaque",
		node_box = {
			type = "wallmounted",
			wall_top    = {-0.4375, 0.4375, -0.3125, 0.4375, 0.5, 0.3125},
			wall_bottom = {-0.4375, -0.5, -0.3125, 0.4375, -0.4375, 0.3125},
			wall_side   = {-0.5, -0.3125, -0.4375, -0.4375, 0.3125, 0.4375},
		},
		groups = def.groups,
		legacy_wallmounted = true,
		sounds = def.sounds,
		can_dig = default.can_dig_map,
		on_blast = function() end,
		on_construct = function(pos)
			local meta = minetest.get_meta(pos)
			meta:set_string("formspec", "field[text;;${text}]")
		end,
		on_receive_fields = function(pos, formname, fields, sender)
			local player_name = sender:get_player_name()
			if minetest.is_protected(pos, player_name) then
				minetest.record_protection_violation(pos, player_name)
				return
			end
			local text = fields.text
			if not text then
				return
			end
			if #text > 512 then
				minetest.chat_send_player(player_name, S("Text too long"))
				return
			end
			text = text:gsub("[%z-\8\11-\31\127]", "") -- strip naughty control characters (keeps \t and \n)
			default.log_player_action(sender, ("wrote %q to the sign at"):format(text), pos)
			local meta = minetest.get_meta(pos)
			meta:set_string("text", text)

			if #text > 0 then
				meta:set_string("infotext", S('"@1"', text))
			else
				meta:set_string("infotext", '')
			end
		end,
	})
end

register_sign("wood", S("Wooden Sign"), {
	sounds = default.node_sound_wood_defaults(),
	groups = {choppy = 2, attached_node = 1, flammable = 2, oddly_breakable_by_hand = 3}
})

register_sign("steel", S("Steel Sign"), {
	sounds = default.node_sound_metal_defaults(),
	groups = {cracky = 2, attached_node = 1}
})

minetest.register_node("default:ladder", {
	description = S("Ladder"),
	drawtype = "signlike",
	tiles = {"default_ladder_wood.png"},
	inventory_image = "default_ladder_wood.png",
	wield_image = "default_ladder_wood.png",
	paramtype = "light",
	paramtype2 = "wallmounted",
	sunlight_propagates = true,
	walkable = false,
	climbable = true,
	is_ground_content = false,
	selection_box = {
		type = "wallmounted",
		--wall_top = = <default>
		--wall_bottom = = <default>
		--wall_side = = <default>
	},
	groups = {map_node = 1, flammable = 2},
	legacy_wallmounted = true,
	sounds = default.node_sound_wood_defaults(),
	on_blast = function() end,
	can_dig = default.can_dig_map,
})

minetest.register_node("default:glass", {
	description = S("Glass"),
	drawtype = "glasslike_framed_optional",
	tiles = {"default_glass.png", "default_glass_detail.png"},
	use_texture_alpha = "clip", -- only needed for stairs API
	paramtype = "light",
	sunlight_propagates = true,
	is_ground_content = false,
	groups = {map_node = 1},
	sounds = default.node_sound_glass_defaults(),
	on_blast = function() end,
	can_dig = default.can_dig_map,
})

minetest.register_node("default:brick", {
	description = S("Brick Block"),
	paramtype2 = "facedir",
	place_param2 = 0,
	tiles = {
		"default_brick.png^[transformFX",
		"default_brick.png",
	},
	is_ground_content = false,
	groups = {map_node = 1},
	sounds = default.node_sound_stone_defaults(),
	on_blast = function() end,
	can_dig = default.can_dig_map,
})

minetest.register_node("default:meselamp", {
	description = S("Mese Lamp"),
	drawtype = "glasslike",
	tiles = {"default_meselamp.png"},
	paramtype = "light",
	sunlight_propagates = true,
	is_ground_content = false,
	groups = {map_node = 1},
	sounds = default.node_sound_glass_defaults(),
	light_source = default.LIGHT_MAX,
	on_blast = function() end,
	can_dig = default.can_dig_map,
})

default.register_mesepost("default:mese_post_light", {
	description = S("Mese Post Light"),
	texture = "default_wood.png",
	material = "default:wood",
})

--
-- Misc
--

minetest.register_node("default:cloud", {
	description = S("Cloud"),
	tiles = {"default_cloud.png"},
	is_ground_content = false,
	sounds = default.node_sound_defaults(),
	groups = {not_in_creative_inventory = 1},
	on_blast = function() end,
	can_dig = default.can_dig_map,
})

minetest.register_node("default:barrier", {
	description = S("Barrier (WIP don't use yet)"),
	drawtype = "airlike",
	pointable = false,
	sounds = default.node_sound_defaults(),
	groups = {map_node=1},
	on_blast = function() end,
	can_dig = default.can_dig_map,
})