shop = {}

shop.basic_formspec = "size[8,9]list[detached:shop;shop;0,0;8,4;]list[current_player;main;0,5;8,4;]"

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
		after_place_node = function(pos, placer)
			local meta = minetest.get_meta(pos)
			meta:set_string("formspec", shop.basic_formspec)
		end,
	})
end

shop.register_shop({
	shop_type = "Basic",
	shop_name = "basic",
})