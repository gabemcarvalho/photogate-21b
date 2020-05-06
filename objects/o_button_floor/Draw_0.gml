/// @description Draw the button
if colour == RED {
	var colour_image_offset = 1;
} else if colour == BLUE {
	var colour_image_offset = 2;
} else if colour == PURPLE {
	var colour_image_offset = 3;
}
if !pressed {
	surface_set_target(o_controller.surf_preblur);
		draw_sprite(sprite_index,1+2*colour_image_offset,x,y); // Glowing part
		draw_sprite(s_gate_end_vertical,2*colour_image_offset-1,x,y+8);
	surface_reset_target();
	surface_set_target(o_controller.surf_block);
		draw_sprite(sprite_index,2*colour_image_offset,x,y); // Dark part
		draw_sprite(s_gate_end_vertical,2*colour_image_offset-1,x,y+8);
	surface_reset_target();
} else {
	surface_set_target(o_controller.surf_preblur);
		draw_sprite(sprite_index,1,x,y); // Glowing part
		draw_sprite(s_gate_end_vertical,2*colour_image_offset,x,y+8);
	surface_reset_target();
	surface_set_target(o_controller.surf_block);
		draw_sprite(sprite_index,1,x,y); // Dark part
		draw_sprite(s_gate_end_vertical,2*colour_image_offset,x,y+8);
	surface_reset_target();
}