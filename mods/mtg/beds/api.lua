
local reverse = true

local function destruct_bed(pos, n)
	local node = minetest.get_node(pos)
	local other

	if n == 2 then
		local dir = minetest.facedir_to_dir(node.param2)
		other = vector.subtract(pos, dir)
	elseif n == 1 then
		local dir = minetest.facedir_to_dir(node.param2)
		other = vector.add(pos, dir)
	end

	if reverse then
		reverse = not reverse
		minetest.remove_node(other)
		minetest.check_for_falling(other)
	else
		reverse = not reverse
	end
end

function beds.register_bed(name, def)
	minetest.register_node(name .. "_bottom", {
		description = def.description,
		inventory_image = def.inventory_image,
		wield_image = def.wield_image,
		drawtype = "nodebox",
		tiles = def.tiles.bottom,
		use_texture_alpha = "clip",
		paramtype = "light",
		paramtype2 = "facedir",
		is_ground_content = false,
		stack_max = 1,
		drops = "",
		groups = def.groups,
		_team = def.team,
		sounds = def.sounds or default.node_sound_leaves_defaults(),
		node_box = {
			type = "fixed",
			fixed = def.nodebox.bottom,
		},
		selection_box = {
			type = "fixed",
			fixed = def.selectionbox,
		},

		on_place = function(itemstack, placer, pointed_thing)
			local under = pointed_thing.under
			local node = minetest.get_node(under)
			local udef = minetest.registered_nodes[node.name]
			if udef and udef.on_rightclick and
					not (placer and placer:is_player() and
					placer:get_player_control().sneak) then
				return udef.on_rightclick(under, node, placer, itemstack,
					pointed_thing) or itemstack
			end

			local pos
			if udef and udef.buildable_to then
				pos = under
			else
				pos = pointed_thing.above
			end

			local player_name = placer and placer:get_player_name() or ""

			if minetest.is_protected(pos, player_name) and
					not minetest.check_player_privs(player_name, "protection_bypass") then
				minetest.record_protection_violation(pos, player_name)
				return itemstack
			end

			local node_def = minetest.registered_nodes[minetest.get_node(pos).name]
			if not node_def or not node_def.buildable_to then
				return itemstack
			end

			local dir = placer and placer:get_look_dir() and
				minetest.dir_to_facedir(placer:get_look_dir()) or 0
			local botpos = vector.add(pos, minetest.facedir_to_dir(dir))

			if minetest.is_protected(botpos, player_name) and
					not minetest.check_player_privs(player_name, "protection_bypass") then
				minetest.record_protection_violation(botpos, player_name)
				return itemstack
			end

			local botdef = minetest.registered_nodes[minetest.get_node(botpos).name]
			if not botdef or not botdef.buildable_to then
				return itemstack
			end

			minetest.set_node(pos, {name = name .. "_bottom", param2 = dir})
			minetest.set_node(botpos, {name = name .. "_top", param2 = dir})

			if not minetest.is_creative_enabled(player_name) then
				itemstack:take_item()
			end
			return itemstack
		end,
		
		after_dig_node = function(pos, oldnode, oldmetadata, digger)
			teams.on_digbed(digger:get_player_name(), beds.get_team_by_name(oldnode.name))
		end,

		on_destruct = function(pos)
			destruct_bed(pos, 1)
		end,

		on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
			beds.on_rightclick(pos, clicker)
			return itemstack
		end,
		
		can_dig = def.can_dig,
		
		on_blast = def.on_blast,
	})

	minetest.register_node(name .. "_top", {
		drawtype = "nodebox",
		tiles = def.tiles.top,
		use_texture_alpha = "clip",
		paramtype = "light",
		paramtype2 = "facedir",
		is_ground_content = false,
		pointable = false,
		groups = groups,
		sounds = def.sounds or default.node_sound_wood_defaults(),
		drop = name .. "_bottom",
		node_box = {
			type = "fixed",
			fixed = def.nodebox.top,
		},
		_team = def.team,
		on_blast = def.on_blast,
		on_destruct = function(pos)
			destruct_bed(pos, 2)
		end,
		after_dig_node = function(pos, oldnode, oldmetadata, digger)
			teams.on_digbed(digger:get_player_name(), beds.get_team_by_name(oldnode.name))
		end,
		can_dig = def.can_dig,
	})

	minetest.register_alias(name, name .. "_bottom")
end

beds.get_team = function(pos)
	nodedef = minetest.registered_nodes[minetest.get_node(pos)._name]
	if nodedef.team ~= nil then
		return nodedef.team
	else
		minetest.log("missing team variable on node of type " .. minetest.get_node(pos)._name)
	end
	return ""
end

beds.get_team_by_name = function(name)
	nodedef = minetest.registered_nodes[name]
	if nodedef.team ~= nil then
		return nodedef.team
	else
		minetest.log("missing team variable on node of type " .. name)
	end
	return "red"
end

beds.on_rightclick = function(pos, clicker)
	if clicker and clicker:is_player() then
		team = beds.get_team(pos)
		if team ~= nil then
			minetest.chat_send_player(clicker:get_player_name(), team .. " team's bed")
		else
			minetest.chat_send_player(clicker:get_player_name(), "unknown" .. " team's bed")
		end
	end
end