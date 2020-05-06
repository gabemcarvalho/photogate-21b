/// @description Draw the map
map_y -= 0.25*(keyboard_check(vk_down)-keyboard_check(vk_up));
map_y = max(map_y,0);
map_y = min(map_y,35)

//surface_set_target(o_controller.surf_preblur);

draw_sprite(s_world_map_grid,0,0,map_y*0.2);
draw_sprite(s_world_map_crystals,0,0,map_y);
draw_sprite(s_world_map_cliffs,0,0,map_y*1.2);

//surface_reset_target();
