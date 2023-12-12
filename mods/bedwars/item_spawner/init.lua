
minetest.register_abm({
	nodenames = {"default:diamondblock"},
	interval = 45,
	chance = 1,
	action = function(pos, node, active_object_count, active_object_count_wider)
		minetest.add_item({x = pos.x, y = pos.y + 1, z = pos.z}, "default:diamond")
	end
})

minetest.register_abm({
	nodenames = {"default:mese"},
	interval = 75,
	chance = 1,
	action = function(pos, node, active_object_count, active_object_count_wider)
		minetest.add_item({x = pos.x, y = pos.y + 1, z = pos.z}, "default:mese_crystal")
	end
})

minetest.register_abm({
	nodenames = {"default:steelblock"},
	interval = 0.25,
	chance = 1,
	action = function(pos, node, active_object_count, active_object_count_wider)
		minetest.add_item({x = pos.x, y = pos.y + 1, z = pos.z}, "default:steel_ingot")
	end
})

minetest.register_abm({
	nodenames = {"default:steelblock"},
	interval = 8,
	chance = 1,
	action = function(pos, node, active_object_count, active_object_count_wider)
		minetest.add_item({x = pos.x, y = pos.y + 1, z = pos.z}, "default:gold_ingot")
	end
})