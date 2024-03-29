fireball = {}
local t = minetest.get_translator("fireball")
local callbacks = {}

minetest.register_craftitem("fireball:fireball", {
  description = ("Fireball"),
  inventory_image = "fireball.png",
  stack_max = 16,
  on_use =
    function(_, player, pointed_thing)
      local throw_starting_pos = vector.add({x=0, y=1.5, z=0}, player:get_pos())
      local fireball = minetest.add_entity(throw_starting_pos, "fireball:thrown_fireball", player:get_player_name())

      minetest.after(0, function() player:get_inventory():remove_item("main", "fireball:fireball") end)
    
      minetest.sound_play("fireball_throw", {max_hear_distance = 15, pos = player:get_pos()})
    end,
  
})

-- entity declaration
local thrown_fireball = {
  initial_properties = {
    hp_max = 1,
    physical = true,
    collide_with_objects = true,
    collisionbox = {-0.4, -0.4, -0.4, 0.4, 0.4, 0.4},
    visual = "wielditem",
    visual_size = {x = 0.5, y = 0.5},
    textures = {"fireball:fireball"},
    spritediv = {x = 1, y = 1},
    initial_sprite_basepos = {x = 0, y = 0},
    pointable = false,
    speed = 35,
    gravity = 0,
    lifetime = 60
  },
  player_name = ""
}

function thrown_fireball:on_step(dtime, moveresult)  
  local collided_with_node = moveresult.collisions[1] and moveresult.collisions[1].type == "node"
  local collided_with_entity = moveresult.collisions[1] and moveresult.collisions[1].type == "entity"

  if collided_with_node or collided_with_entity then
    
    tnt.boom(moveresult.collisions[1].node_pos, {radius = 3, damage_radius = 3})

    for i=1, #callbacks do
      local node = minetest.get_node(moveresult.collisions[1].node_pos)
      callbacks[i](node)
    end

    self.object:remove()
  end
end

function thrown_fireball:on_activate(staticdata)
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
end

minetest.register_entity("fireball:thrown_fireball", thrown_fireball)


--[[-- entity declaration
local fireball = {
  initial_properties = {
    hp_max = 1,
    physical = true,
    collide_with_objects = true,
    collisionbox = {-0.4, -0.4, -0.4, 0.4, 0.4, 0.4},
    visual = "wielditem",
    visual_size = {x = 0.5, y = 0.5},
    textures = {"fireball:fireball"},
    spritediv = {x = 1, y = 1},
    initial_sprite_basepos = {x = 0, y = 0},
    pointable = false,
    speed = 35,
    gravity = 0,
    lifetime = 30
  },
  player_name = ""
}

function fireball:on_step(dtime, moveresult)  
  local collided_with_node = moveresult.collisions[1] and moveresult.collisions[1].type == "node"
  local collided_with_entity = moveresult.collisions[1] and moveresult.collisions[1].type == "entity"

  if collided_with_node or collided_with_entity then
    
    tnt.boom(moveresult.collisions[1].node_pos, {radius = 2, damage_radius = 4})

    for i=1, #callbacks do
      local node = minetest.get_node(moveresult.collisions[1].node_pos)
      callbacks[i](node)
    end

    self.object:remove()
  end
end

function fireball:on_activate(staticdata)
  if not staticdata then
    self.object:remove()
    return
  end

  local lookdir_list = staticdata:split(" ")
  minetest.log(type(staticdata) .. ", : " .. tostring(staticdata))
  minetest.log(type(lookdir_list) .. ", : " .. tostring(lookdir_list))
  minetest.log(type(lookdir_list[0]) .. ", : " .. tostring(lookdir_list[0]))
  local lookdir = vector.new(lookdir_list[0], lookdir_list[1], lookdir_list[2])
  minetest.log(vector.to_string(lookdir))

  self.object:set_rotation({x = lookdir.x, y = lookdir.y, z = 0})
  self.object:set_velocity({
      x=(lookdir.x * self.initial_properties.speed),
      y=(lookdir.x * self.initial_properties.speed),
      z=(lookdir.x * self.initial_properties.speed),
  })
  self.object:set_acceleration({x=lookdir.x*-4, y=-self.initial_properties.gravity, z=lookdir.z*-4})

  minetest.after(self.initial_properties.lifetime, function() self.object:remove() end)
end

minetest.register_entity("fireball:fireball", fireball)]]--


-- on_explode(hit_node)
function fireball.on_explode(func)
  table.insert(callbacks, func)
end
