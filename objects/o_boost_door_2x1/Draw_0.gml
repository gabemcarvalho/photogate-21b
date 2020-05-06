/// @description Draw the door
if destroy {
	surface_reset_target();
	surface_set_target(o_controller.surf_outline);
		draw_sprite_ext(s_white_pixel, 0, x - 1, y + 1,
			1, sprite_get_height(sprite_index) - 2, 0, c_white, 1.0);
		draw_sprite_ext(s_white_pixel, 0, x + sprite_get_width(sprite_index), y + 1,
			1, sprite_get_height(sprite_index) - 2, 0, c_white, 1.0);
	surface_reset_target();
	surface_set_target(o_controller.surf_preblur);
	instance_destroy();
} else {
	if !active draw_sprite(sprite_index,1,x,y) else draw_sprite(sprite_index,2,x,y);
	surface_reset_target();
	surface_set_target(o_controller.surf_block);
	draw_sprite(sprite_index,0,x,y);
	surface_reset_target();

	if !initialized {
		surface_set_target(o_controller.surf_outline);
		gpu_set_blendmode_ext(bm_zero, bm_inv_src_alpha);
			draw_sprite_ext(s_white_pixel, 0, x - 1, y + 1,
				1, sprite_get_height(sprite_index) - 2, 0, c_white, 1.0);
			draw_sprite_ext(s_white_pixel, 0, x + sprite_get_width(sprite_index), y + 1,
				1, sprite_get_height(sprite_index) - 2, 0, c_white, 1.0);
		gpu_set_blendmode(bm_normal);
		surface_reset_target();	
		initialized = true;
	}

	surface_set_target(o_controller.surf_preblur);
}