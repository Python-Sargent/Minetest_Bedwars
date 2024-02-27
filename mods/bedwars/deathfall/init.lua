minetest.register_globalstep(function()
	for _, player in ipairs(minetest.get_connected_players()) do
        if player and player:get_pos().y < -50 and player:get_hp() > 0 then
			teams.on_dieplayer(player:get_player_name(), "fell")
			player:set_pos({x=0,y=0,z=0})
			player:add_player_velocity(-player:get_velocity())
			teams.respawn(player)
			minetest.after(0.1, function()player:set_hp(20)end)
        end
    end
end)

minetest.register_on_dieplayer(function(player)
	pn = player:get_player_name()
	--minetest.chat_send_all(player:get_player_name() .. minetest.colorize("pink", " died"))
	minetest.close_formspec(pn, "bultin:death")
	minetest.after(1, function()
		minetest.close_formspec(pn, "bultin:death")
	end)
end)