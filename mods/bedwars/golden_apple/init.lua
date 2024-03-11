minetest.register_craftitem("golden_apple:golden_apple", {
	description = "Golden Apple",
	inventory_image = "golden_apple.png",
	groups = {food = 1},
	on_use = function(itemstack, user, pointed_thing)
		potions.add_effect(user, "absorption", 30, 2)
        return minetest.do_item_eat(4, nil, itemstack, user, pointed_thing)
    end,
})