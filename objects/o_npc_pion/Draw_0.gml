/// @description Draw the NPC
surface_set_target(o_controller.surf_preblur);
	// Block out light behind the NPC
	gpu_set_blendmode_ext(bm_zero, bm_inv_src_alpha);
	draw_sprite_ext(sprite_index,image_index,round(x),y,-dir,image_yscale,0,c_white,1);
	gpu_set_blendmode(bm_normal);
	// Draw eyes
	if sprite_index == sprite_idle && floor(image_index) == 2 {
		draw_sprite_ext(sprite_eyes,0,round(x)+dir,y+1,-dir,image_yscale,0,c_white,1);
	} else {
		draw_sprite_ext(sprite_eyes,0,round(x)+dir,y,-dir,image_yscale,0,c_white,1);
	}
surface_reset_target();

surface_set_target(o_controller.surf_lit);
	draw_sprite_ext(sprite_index,image_index,round(x),y,-dir,image_yscale,0,c_white,1);
surface_reset_target();