
--A basic arrow
minetest.register_craftitem("projectile:arrow", {
	description = "Arrow",
	inventory_image = "projectile_arrow.png",
})

--Three sticks, to create the shape of the bow itself, and three strings in a diagonal line, makes a bow.
minetest.register_craft({
	output = "projectile:bow",
	recipe = {
		{"group:stick", "group:stick", "farming:string"},
		{"group:stick", "farming:string", ""},
		{"farming:string", "", ""}
	}
})

--Regular arrows are made from flint, a stick, and a feather.
--The feather can be provided by multiple mob mods.
--Arrows are also materials in the stronger ammo options for bows.
minetest.register_craft({
	output = "projectile:arrow",
	recipe = {
		{"default:flint", "", ""},
		{"", "group:stick", ""},
		{"", "", "mobs:chicken_feather"}
	}
})
minetest.register_craft({
	output = "projectile:arrow",
	recipe = {
		{"default:flint", "", ""},
		{"", "group:stick", ""},
		{"", "", "animalmaterials:feather"}
	}
})
minetest.register_craft({
	output = "projectile:arrow",
	recipe = {
		{"default:flint", "", ""},
		{"", "group:stick", ""},
		{"", "", "creatures:feather"}
	}
})
