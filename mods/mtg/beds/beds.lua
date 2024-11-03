-- beds/beds.lua

-- support for MT game translation.
local S = beds.get_translator

local dyes = dye.dyes

local ratio = 185

for i = 1, #dyes do
	local name, desc = unpack(dyes[i])

	local color_group = "color_" .. name
	
	beds.register_bed("beds:bed_" .. name, {
		description = S(name .. " Bed"),
		inventory_image = "beds_bed.png^[colorize:" .. name .. ":" .. ratio .. "^beds_bed_overlay.png",
		wield_image = "beds_bed.png^[colorize:" .. name .. ":" .. ratio .. "^beds_bed_overlay.png",
		tiles = {
			bottom = {
				"beds_bed_top_bottom.png^[transformR90^[colorize:" .. name .. ":" .. ratio,
				"beds_bed_under.png",
				"beds_bed_side_bottom_r.png^[colorize:" .. name .. ":" .. ratio .. "^beds_bed_side_bottom_r_overlay.png",
				"beds_bed_side_bottom_r.png^[colorize:" .. name .. ":" .. ratio .. "^beds_bed_side_bottom_r_overlay.png^[transformfx",
				"beds_transparent.png",
				"beds_bed_side_bottom.png^[colorize:" .. name .. ":" .. ratio .. "^beds_bed_side_bottom_overlay.png"
			},
			top = {
				"beds_bed_top_top.png^[colorize:" .. name .. ":" .. ratio .. "^beds_bed_top_top_overlay.png^[transformR90",
				"beds_bed_under.png",
				"beds_bed_side_top_r.png^[colorize:" .. name .. ":" .. ratio .. "^beds_bed_side_top_r_overlay.png",
				"beds_bed_side_top_r.png^[colorize:" .. name .. ":" .. ratio .. "^beds_bed_side_top_r_overlay.png^[transformfx",
				"beds_bed_side_top.png^[colorize:" .. name .. ":" .. ratio .. "^beds_bed_side_top_overlay.png",
				"beds_transparent.png",
			}
		},
		team = name, -- store what teams bed this is
		nodebox = {
			bottom = {-0.5, -0.5, -0.5, 0.5, 0.0625, 0.5},
			top = {-0.5, -0.5, -0.5, 0.5, 0.0625, 0.5},
		},
		selectionbox = {-0.5, -0.5, -0.5, 0.5, 0.0625, 1.5},
		groups = {bed = 1, [color_group] = 1},
		can_dig = function(pos, player) 
			if teams.get_team(player:get_player_name()) ~= beds.get_team(pos) and beds.get_team(pos) ~= nil then
				return true
			else
				minetest.chat_send_player(player:get_player_name(), "This is your bed")
			end
			return false
		end,
	})
end
