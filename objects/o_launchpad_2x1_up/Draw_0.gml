/// @description Draw the platform
if colour == RED {
	var colour_image_offset = 0;
} else if colour == BLUE {
	var colour_image_offset = 2;
} else if colour == PURPLE {
	var colour_image_offset = 4;
}
// Draw the base
surface_set_target(o_controller.surf_block);
draw_sprite(s_launchpad_base,0,x,y_origin);
// Draw the pad (dark portion)
draw_sprite(sprite_index,0,x,y);
// draw the shaft
var shaft_length = (y_origin) - (y+8);
if shaft_length >= 1 {
	draw_sprite_ext(s_launchpad_shaft,0,x+3,y+8,1,shaft_length,0,c_white,1);
	draw_sprite_ext(s_launchpad_shaft,0,x+12,y+8,1,shaft_length,0,c_white,1);
}
surface_reset_target();

// Draw the pad (light portion)
surface_set_target(o_controller.surf_preblur);
if state == DOWN && trigger_timer == 0 var colour_index = 1 else var colour_index = 2;

draw_sprite(s_launchpad_base,1+colour_image_offset,x,y_origin);

draw_sprite(sprite_index,colour_index+colour_image_offset,x,y);
// draw the shaft (light)
if shaft_length >= 1 {
	draw_sprite_ext(s_green_pixel,0,x+2,y+8,1,shaft_length,0,c_white,1);
	draw_sprite_ext(s_green_pixel,0,x+13,y+8,1,shaft_length,0,c_white,1);
}

surface_reset_target();