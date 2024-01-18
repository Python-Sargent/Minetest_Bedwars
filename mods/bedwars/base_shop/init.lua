shop = {}

shop.basic_formspec = "size[8,9]item_image_button[0,0;1,1;default:sword_diamond;diamond_sword;Sword]list[current_player;main;0,5;8,4;]"

local replace_item = function(inv, type, level)
	if type == "sword" then
		if inv:contains_item("main", "default:sword_diamond") then inv:remove_item("main", ItemStack("default:sword_diamond")) end
		if inv:contains_item("main", "default:sword_wood") then inv:remove_item("main", ItemStack("default:sword_wood")) end
		if inv:contains_item("main", "default:sword_stone") then inv:remove_item("main", ItemStack("default:sword_stone")) end
		if inv:contains_item("main", "default:sword_steel") then inv:remove_item("main", ItemStack("default:sword_steel")) end
	end

	if type == "pick" then
		if inv:contains_item("main", "default:pick_diamond") then inv:remove_item("main", ItemStack("default:pick_diamond")) end
		if inv:contains_item("main", "default:pick_stone") then inv:remove_item("main", ItemStack("default:pick_stone")) end
		if inv:contains_item("main", "default:pick_steel") then inv:remove_item("main", ItemStack("default:pick_steel")) end
	end

	if type == "axe" then
		if inv:contains_item("main", "default:axe_diamond") then inv:remove_item("main", ItemStack("default:axe_diamond")) end
		if inv:contains_item("main", "default:axe_stone") then inv:remove_item("main", ItemStack("default:axe_stone")) end
		if inv:contains_item("main", "default:axe_steel") then inv:remove_item("main", ItemStack("default:axe_steel")) end
	end
end

shop.buy_item = function(inv, player, cost, item, type, reqtext)
	if inv:contains_item("main", cost) then
		if type then replace_item(inv, type) end -- just pass in nil if you don't want to replace anything
		player:get_inventory():add_item("main", item)
		inv:remove_item("main", ItemStack(cost))
	else
		minetest.chat_send_player(player:get_player_name(), "You need to have " .. reqtext .. " in order to buy this item.")
	end
end

shop.register_shop = function(def)
	minetest.register_node("base_shop:" .. tostring(def.shop_name) .. "_shop", {
		description = tostring(def.shop_type) .. " Shop",
		drawtype = "nodebox",
		nodebox = {
			fixed = {
				{-0.5, -0.5, -0.45, 0.5, 0.5, 0.5},
			},
		},
		tiles = {
			"base_shop_side.png",
			"base_shop_side.png",
			"base_shop_side.png",
			"base_shop_side.png",
			"base_shop_front.png",
			"base_shop_side.png",
		},
		paramtype = "light",
		paramtype2 = "4dir",
		groups = {map_node = 1, shop = 1},
		on_blast = function() end,
		can_dig = default.can_dig_map,
		on_rightclick = function(pos, _, clicker)
			local name = clicker:get_player_name()
			local formspec_begin = "size[8,9]"
			local formspec_end = "list[current_player;main;0,5;8,4;]"
			local formspec_mid = "item_image_button[0,0;1,1;default:sword_stone;stone_sword;Sword]" ..
								 "item_image_button[1,0;1,1;default:sword_steel;steel_sword;Sword]" ..
								 "item_image_button[2,0;1,1;default:sword_diamond;diamond_sword;Sword]" ..
								 "item_image_button[3,0;1,1;default:pick_stone;stone_pick;Pick]" ..
								 "item_image_button[4,0;1,1;default:pick_steel;steel_pick;Pick]" ..
								 "item_image_button[5,0;1,1;default:pick_diamond;diamond_pick;Pick]" ..
								 "item_image_button[0,1;1,1;default:stone;stone;Block]" ..
								 "item_image_button[1,1;1,1;wool:" .. teams.get_team(name) .. ";wool;Wool]" ..
								 "item_image_button[2,1;1,1;default:sandstone;sandstone;Block]"

			--item_image_button[0,0;1,1;default:sword_diamond;diamond_sword;Sword]
			if name then
				minetest.show_formspec(name, "base_shop:" .. def.shop_type, formspec_begin .. formspec_mid .. formspec_end)
			else
				minetest.chat_send_all("Player " .. name .. " attempted to use shop >> WARNING: variable 'name' is nil in function on_rightclick")
			end
		end,
	})

	minetest.register_on_player_receive_fields(function(player, formname, fields)
		if formname ~= "base_shop:" .. def.shop_type then
			return
		end
		
		local inv = player:get_inventory()
		if fields.diamond_sword then
			shop.buy_item(inv, player, "default:mese_crystal 4", "default:sword_diamond", "sword", "4 Mese Crystal")
		end
		if fields.steel_sword then
			shop.buy_item(inv, player, "default:mese_crystal 1", "default:sword_steel", "sword", "1 Mese Crystal")
		end
		if fields.stone_sword then
			shop.buy_item(inv, player, "default:gold_ingot 4", "default:sword_stone", "sword", "4 Gold Ingot")
		end
		if fields.diamond_pick then
			shop.buy_item(inv, player, "default:mese_crystal 3", "default:pick_diamond", "pick", "3 Mese Crystal")
		end
		if fields.steel_pick then
			shop.buy_item(inv, player, "default:gold_ingot 12", "default:pick_steel", "pick", "12 Gold Ingot")
		end
		if fields.stone_pick then
			shop.buy_item(inv, player, "default:gold_ingot 5", "default:pick_stone", "pick", "5 Gold Ingot")
		end
		if fields.wool then
			shop.buy_item(inv, player, "default:steel_ingot 4", "wool:" .. teams.get_team(player:get_player_name()) .." 16", nil, "4 Steel Ingot")
		end
		if fields.sandstone then
			shop.buy_item(inv, player, "default:steel_ingot 24", "default:sandstone 12", nil, "24 Steel Ingot")
		end
		if fields.stone then
			shop.buy_item(inv, player, "default:gold_ingot 12", "default:stone 8", nil, "12 Gold Ingot")
		end
	end)
end

shop.register_shop({
	shop_type = "Basic",
	shop_name = "basic",
})

--player:get_inventory():add_item("main", "default:sword_diamond 1")