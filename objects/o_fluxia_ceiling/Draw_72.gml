/// @description Draw the map
ceil_step += 0.25*(keyboard_check(vk_right)-keyboard_check(vk_left));
ceil_step = max(ceil_step,0);
ceil_step = min(ceil_step,12+8);

var panel_x = max(ceil_step-8,0);

if keyboard_check(vk_space) scr_add_screenshake(1,5);

//o_camera.x = 3+VIEW_WIDTH/2;
//o_camera.y = 2+VIEW_HEIGHT/2;

surface_set_target(o_controller.surf_preblur);

draw_set_colour(c_white);
draw_sprite(s_ceiling_light,0,0,0);
draw_sprite(s_ceiling_left_panel,0,-panel_x,0);
draw_sprite(s_ceiling_right_panel,0,panel_x,0);
draw_sprite(s_ceiling_cells,0,0,0);

if ceil_step > 0 {
	draw_set_alpha(0.5);
	if ceil_step > 6 draw_rectangle(66-panel_x,56,66+panel_x,85,false);
	draw_set_alpha(1);
	draw_sprite_part(s_ceiling_right_light,0,max(6-ceil_step,0),0,min(2*ceil_step,12),85,panel_x+67+max(6-ceil_step,0),0);
}

surface_reset_target();