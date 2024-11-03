bows = {}

bows.projectiles = {}

bows.projectiles["arrow"] = {
    initial_properties = {
        hp_max = 1,
        physical = true,
        collide_with_objects = true,
        collisionbox = {-0.1, -0.1, -0.4, 0.1, 0.1, 0.4},
        visual = "mesh",
        mesh = "bows_arrow.obj",
        visual_size = {x = 1, y = 1},
        textures = {"bows_arrow.png"},
        pointable = false,
        speed = 40,
        gravity = 10,
        lifetime = 60
    },
    player_name = "",
    on_step = function(dtime, moveresult)
        local collided_with_node = moveresult.collisions[1] and moveresult.collisions[1].type == "node"
        local collided_with_entity = moveresult.collisions[1] and moveresult.collisions[1].type == "entity"
        
        if collided_with_node then
            minetest.add_item(moveresult.collisions[1].node_pos, "bows:arrow")
            self.object:remove()
        else if collided_with_entity then
            
        end
        end
    end,
        
    on_activate = function(staticdata)
        if not staticdata or not minetest.get_player_by_name(staticdata) then
            self.object:remove()
            return
        end
        
        self.player_name = staticdata
        local player = minetest.get_player_by_name(staticdata)
        local yaw = player:get_look_horizontal()
        local pitch = player:get_look_vertical()
        local dir = player:get_look_dir()
        
        self.object:set_rotation({x = -pitch, y = yaw, z = 0})
        self.object:set_velocity({
            x=(dir.x * self.initial_properties.speed),
            y=(dir.y * self.initial_properties.speed),
            z=(dir.z * self.initial_properties.speed),
        })
        self.object:set_acceleration({x=dir.x*-4, y=-self.initial_properties.gravity, z=dir.z*-4})
        
        minetest.after(self.initial_properties.lifetime, function() self.object:remove() end)
    end,
}

minetest.register_entity("bows:arrow", bows.projectiles["arrow"])

minetest.register_craftitem("bows:arrow", {
    description = ("Arrow"),
    inventory_image = "bows_arrow_inv.png",
    stack_max = 16,
})

minetest.register_tool("bows:bow", {
    description = ("Bow"),
    inventory_image = "bows_bow.png",
    on_use = function(itemstack, user, pointed_thing)
        itemstack.set_wear(65535)
        minetest.after(0.5, itemstack.set_wear, 65535 / 2)
        minetest.after(1, itemstack.set_wear, 4)
        minetes.after(1.1, itemstack.replace, "bows:bow_charged")
        return itemstack
    end
})

minetest.register_tool("bows:bow_drawn", {
    description = ("Bow (Drawn)"),
    inventory_image = "bows_bow_drawn.png",
    groups = {not_in_creative_inventory=true},
    on_use = function(itemstack, player, pointed_thing)
        local throw_starting_pos = vector.add({x=0, y=1.5, z=0}, player:get_pos())
        local arrow = minetest.add_entity(throw_starting_pos, "bows:arrow_basic", player:get_player_name())
    
        minetest.after(0, function() player:get_inventory():remove_item("main", "bows:arrow_basic") end)
        
        minetest.sound_play("bows_shoot", {max_hear_distance = 15, pos = player:get_pos()})
        itemstack.replace("bows:bow")
        return itemstack
    end,
})