/// @description Draw the Crystal
// Current surface is surf_preblur
shader_set(sh_brighten);
shader_set_uniform_f(uni_brighten_amount,bright_amount);
	// Draw the crystal
	draw_sprite_ext(sprite_index,image_index,x,y,1,1,0,c_white,1);
	if shining draw_sprite(s_light_crystal_shine_d,shine_image,x,y);
shader_reset();

// Draw the indicator arrows
if photon_in {
	surface_reset_target();
	surface_set_target(o_controller.surf_gui);
		switch in_timer {
			case 0: draw_sprite(s_light_crystal_dir_ind_d,dir_tot,x,y); break;
			case 1: draw_sprite(s_light_crystal_dir_ind_d,0,x,y); break;
		}
}

surface_reset_target();
surface_set_target(o_controller.surf_preblur);
// surface is reset after draw event in scr_glow_end