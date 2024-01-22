enderchest = {}

enderchest.show_formspec = function(pn, name, formspec)
	minetest.show_formspec(pn, name, formspec)
end

function enderchest.get_chest_formspec(pn)
	local formspec =
		"size[8,9]" ..
		"list[detached:enderchest_" .. pn .. ";enderchest;0,0.3;8,4;]" ..
		"list[current_player;main;0,4.85;8,1;]" ..
		"list[current_player;main;0,6.08;8,3;8]" ..
		"listring[detached:enderchest_" .. pn .. ";enderchest]" ..
		"listring[current_player;main]" ..
		default.get_hotbar_bg(0,4.85)
	return formspec
end

enderchest.create_inventory = function(pn)
	local dinv = minetest.create_detached_inventory("enderchest_" .. pn, {
		allow_move = function(inv, from_list, from_index, to_list, to_index, count, player)
			return count -- allow moving
		end,

		allow_put = function(inv, listname, index, stack, player)
			return stack:get_count() -- allow putting
		end,

		allow_take = function(inv, listname, index, stack, player)
			return stack:get_count() -- allow taking
		end,
	})
    dinv:set_size('enderchest', 8*4)
end

enderchest.delete_inventory = function(player)
	minetest.remove_detached_inventory("enderchest_" .. player)
end

minetest.register_on_joinplayer(function(player, last_login)
	enderchest.create_inventory(player:get_player_name())
end)

minetest.register_on_leaveplayer(function(player, timed_out)
	enderchest.delete_inventory(player:get_player_name())
end)

minetest.register_node("enderchest:enderchest", {
	description = "Ender Chest",
	tiles = {
		"default_enderchest_top.png",
		"default_enderchest_top.png",
		"default_enderchest_side.png",
		"default_enderchest_side.png",
		"default_enderchest_side.png",
		"default_enderchest_front.png"
	},
	drawtype = "normal",
	paramtype = "light",
	paramtype2 = "facedir",
	legacy_facedir_simple = true,
	is_ground_content = false,
	sounds = default.node_sound_wood_defaults(),
	groups = {map_node = 1},
	on_blast = function() end,
	on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
		if not default.can_interact_with_node(clicker, pos) then
			return itemstack
		end

		local cn = clicker:get_player_name()
		enderchest.show_formspec(cn, "enderchest:enderchest", enderchest.get_chest_formspec(cn))
	end
})
