/// @description Draw Tiles
// Draw the block layer
// Note: other objects draw to this surface before the Draw End event
surface_set_target(surf_block);
	draw_clear_alpha(c_black, 0);
	draw_tilemap(tm_blocks,0,0);
	
	gpu_set_blendmode_ext(bm_zero, bm_inv_src_alpha);
	with o_light_crystal draw_sprite(sprite_index, 0, x, y);
	gpu_set_blendmode(bm_normal);
surface_reset_target();

// Generate lights if necessary
if !generated_lights {
	// Draw light tilemap
	surface_set_target(surf_lightgen_1);
		draw_clear_alpha(c_black, 0.0);
		draw_tilemap(tlmp_blocks, 0, 0);
		draw_tilemap(tlmp_mirror, 0, 0);
		draw_tilemap(tlmp_objects, 0, 0);
	surface_reset_target();
	
	// Apply the raycast shader
	surface_set_target(surf_lightgen_2);
		draw_clear_alpha(c_white, 0.0);
		shader_set(sh_raycast);
		shader_set_uniform_f(uni_raycast_resolution, room_width,room_height);
			draw_surface(surf_lightgen_1, 0, 0);
		shader_reset();
	surface_reset_target();
	
	// Generate block outline
	surface_set_target(surf_lightgen_1);
		draw_clear_alpha(c_black, 0.0);
		draw_tilemap(tlmp_blocks, 0, 0);
		draw_tilemap(tlmp_mirror, 0, 0);
	surface_reset_target();
	
	surface_set_target(surf_outline);
		draw_clear_alpha(c_white, 0.0);
		shader_set(sh_outline);
		shader_set_uniform_f(uni_outline_resolution, room_width,room_height);
			draw_surface(surf_lightgen_1, 0, 0);
		shader_reset();
		
		// Change outline around light crystals
		gpu_set_blendmode_ext(bm_one, bm_zero);
		with o_light_crystal draw_sprite(sprite_outline, 0, x, y);
		gpu_set_blendmode(bm_normal);
	surface_reset_target();
	
	// Generate lights for crystals
	with o_light_crystal {
		var x1 = max(x - 40, 0);
		var y1 = max(y - 40, 0);
		var x2 = min(x + 40, room_width);
		var y2 = min(y + 40, room_height);
		
		surface_set_target(other.surf_lightgen_1);
			// surface is already set up from drawing the outline
			shader_set(sh_1111);
				draw_self();
			shader_reset();
		surface_reset_target();
		
		light_flash.surface = surface_create(x2 - x1, y2 - y1);
		surface_set_target(light_flash.surface);
			draw_clear_alpha(c_white, 0.0);
			shader_set(sh_raycast_lite);
			shader_set_uniform_f(other.uni_raycast_lite_resolution, room_width, room_height);
			shader_set_uniform_f(other.uni_raycast_lite_transparency, 0.0);
			shader_set_uniform_i(other.uni_raycast_lite_rays, 64);
			shader_set_uniform_i(other.uni_raycast_lite_steps, 24);
				draw_surface_part_ext(other.surf_lightgen_1, x1, y1, x2 - x1, y2 - y1, 0, 0, 1, 1, c_white, 1.0);
			shader_reset();
		surface_reset_target();	
		light_flash.image_alpha = 0.0;
		light_flash.fade_spd = 0.0;
		
		surface_set_target(other.surf_lightgen_1);
			gpu_set_blendmode_ext(bm_zero, bm_inv_src_alpha);
				draw_self();
			gpu_set_blendmode(bm_normal);
		surface_reset_target();
	}
	
	generated_lights = true;
}

// Photon death flash
if global.create_photon_flash {
	var radius = 64;
	var photon_flash = instance_create_layer(global.photon_death_info[0] - radius, global.photon_death_info[1] - radius, "GUI", o_mirror_flash);
	photon_flash.surface = surface_create(2*radius, 2*radius);
	photon_flash.image_alpha = 1.4;
	
	surface_set_target(surf_lightgen_1);
		draw_clear_alpha(c_white, 0.0);
		draw_tilemap(tlmp_blocks, 0, 0);
		draw_tilemap(tlmp_mirror, 0, 0);
		draw_tilemap(tlmp_objects, 0, 0);
		shader_set(sh_1111);
			draw_sprite_ext(global.photon_death_info[2], global.photon_death_info[4],
							global.photon_death_info[0], global.photon_death_info[1],
							global.photon_death_info[4], global.photon_death_info[5],
							0, c_white, 1.0);
		shader_reset();
	surface_reset_target();
	
	// Draw to the flash object's surface
	surface_set_target(photon_flash.surface);
		draw_clear_alpha(c_white, 0.0);
		shader_set(sh_raycast_lite);
		shader_set_uniform_f(uni_raycast_lite_resolution, room_width,room_height);
		shader_set_uniform_f(uni_raycast_lite_transparency, 0.1);
		shader_set_uniform_i(uni_raycast_lite_rays, 64);
			shader_set_uniform_i(uni_raycast_lite_steps, radius - 10);
			draw_surface_part(surf_lightgen_1,
							global.photon_death_info[0] - radius, global.photon_death_info[1] - radius,
							2*radius, 2*radius, 0, 0);
		shader_reset();
		shader_set(sh_white);
		draw_sprite_ext(global.photon_death_info[2], global.photon_death_info[4],
						radius, radius,
						global.photon_death_info[4], global.photon_death_info[5],
						0, c_white, 0.9);
		shader_reset();
	surface_reset_target();
	
	global.create_photon_flash = false;
}

// Light tile surface
surface_set_target(surf_light);
	draw_clear_alpha(c_black, 0);
	gpu_set_blendmode(bm_add);
		draw_surface(surf_lightgen_2, 0, 0);
	gpu_set_blendmode(bm_normal);
surface_reset_target();

// Draw tile layers to the lighting surface
surface_set_target(surf_preblur);
	draw_tilemap(tlmp_mirror, 0, 0);
	draw_surface(surf_outline,0,0);
	draw_tilemap(tm_glowing,0,0);
	
	if instance_exists(o_asset_layers) { // Draw assets
		gpu_set_blendmode(bm_add);
			draw_surface(surf_assets_light_back, 0, 0);
			draw_surface(surf_assets_light, 0, 0);
		gpu_set_blendmode(bm_normal);
	}
	
	// Draw mirrors that have lit up (in place of their draw event)
	with o_wall_mirror draw_sprite_ext(s_wall_white,0,x,y,image_xscale,image_yscale,0,c_white,brightness);
surface_reset_target();

// If asset layers have not been drawn, clear them
if !drawn_assets {	
	surface_set_target(surf_assets_light_front);
	draw_clear_alpha(c_white, 0);
	surface_reset_target();
	surface_set_target(surf_assets_light);
	draw_clear_alpha(c_white, 0);
	surface_reset_target();
	surface_set_target(surf_assets_light_back);
	draw_clear_alpha(c_white, 0);
	surface_reset_target();
	surface_set_target(surf_assets_dark);
	draw_clear_alpha(c_white, 0);
	surface_reset_target();
	surface_set_target(surf_assets_dark_back);
	draw_clear_alpha(c_white, 0);
	surface_reset_target();
}

// Draw onto the lit surface
surface_set_target(surf_lit);
	draw_tilemap(tm_crystals_large,0,0);
	draw_tilemap(tm_ground,0,0);
	draw_tilemap(tm_crystals_small,0,0);
	if instance_exists(o_asset_layers) {
		draw_surface(surf_assets_dark_back, 0, 0);
		draw_surface(surf_assets_dark, 0, 0);
	}
surface_reset_target();

// TODO: tis is where a check for the asset layers should go, to be safe ***********************************