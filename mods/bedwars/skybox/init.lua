--[[minetest.set_sky({
    base_color = 0x00AAFF,
    type = "skybox",
    textures = {
        "skybox_top.png",
        "skybox_bottom.png",
        "skybox_west.png", -- negative X
        "skybox_east.png", -- positive X
        "skybox_north.png", -- positive Z
        "skybox_south.png", -- negative Z
    },
    clouds = false,
})

minetest.set_moon({
    visible = false
})

minetest.set_sun({
    visible = false
})]]