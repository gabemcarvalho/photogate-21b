/// @description Draw surfaces
// Draw the background
if instance_exists(o_crystal_background) {
	for (var i = 0; i < ds_list_size(o_crystal_background.crystal_list); i++) {
		with ds_list_find_value(o_crystal_background.crystal_list, i) scr_draw_bk_crystal();
	}
}

// Finish drawing of the asset layers
if !drawn_assets {
	// Layers have been drawn by this point in the step, can turn them off
	drawn_assets = true;
	layer_set_visible("assets_light_front",	false);
	layer_set_visible("assets_light",		false);
	layer_set_visible("assets_light_back",	false);
	layer_set_visible("assets_dark",		false);
	layer_set_visible("assets_dark_back",	false);
	
	// Subtract the dark layer from the back light layer
	surface_set_target(surf_assets_light_back);
		gpu_set_blendmode_ext(bm_zero, bm_inv_src_alpha);
			draw_surface(surf_assets_dark, 0, 0);
		gpu_set_blendmode(bm_normal);
	surface_reset_target();
}

#region MIRROR FLASH
if (ds_list_size(flashing_mirrors) > 0) {
	
	global.flash_exists = false;
	ds_list_sort(flashing_mirrors, true);
	mirror_list_id = "";
	for (var i=0; i<ds_list_size(flashing_mirrors); i++) {
		mirror_list_id += string(flashing_mirrors[|i].id);
	}
	
	with o_mirror_flash {
		if mirror_list_id == other.mirror_list_id {
			image_alpha = 1.0;
			global.flash_exists = true;
		}
	}
	
	if (!global.flash_exists) {
		var mirror_flash = instance_create_layer(flash_x1, flash_y1, "GUI", o_mirror_flash);
		mirror_flash.surface = surface_create(flash_x2 - flash_x1, flash_y2 - flash_y1);
		mirror_flash.mirror_list_id = mirror_list_id;
	
		//// Draw mirrors
		surface_set_target(surf_vblur);
			draw_clear_alpha(c_white, 0.0);
			draw_tilemap(tlmp_blocks, 0, 0);
			draw_tilemap(tlmp_mirror, 0, 0);
			shader_set(sh_1111);
				for (var i=0; i<ds_list_size(flashing_mirrors); i++) {
					var mirror = flashing_mirrors[|i];
					draw_sprite_ext(mirror.sprite_index, mirror.image_index, mirror.x, mirror.y, mirror.image_xscale, mirror.image_yscale, 0, c_white, 1.0);
				}
			shader_reset();
		surface_reset_target();
	
		// Draw to the flash object's surface
		surface_set_target(mirror_flash.surface);
			draw_clear_alpha(c_white, 0.0);
			shader_set(sh_raycast_lite);
			shader_set_uniform_f(uni_raycast_lite_resolution, room_width, room_height);
			shader_set_uniform_f(uni_raycast_lite_transparency, 0.15);
			shader_set_uniform_i(uni_raycast_lite_rays, 64);
			shader_set_uniform_i(uni_raycast_lite_steps, 24);
				draw_surface_part_ext(surf_vblur, flash_x1, flash_y1, flash_x2 - flash_x1, flash_y2 - flash_y1, 0, 0, 1, 1, c_white, 1.0);
			shader_reset();
		surface_reset_target();
	}
	
	ds_list_clear(flashing_mirrors);
	flash_x1 = room_width;
	flash_y1 = room_height;
	flash_x2 = 0;
	flash_y2 = 0;
}
#endregion

#region PHOTON LIGHT
if instance_exists(o_photon) {
	surface_set_target(surf_lightgen_1);
		draw_clear_alpha(c_white, 0.0);
		shader_set(sh_not_white);
			draw_tilemap(tlmp_blocks, 0, 0);
			draw_tilemap(tlmp_mirror, 0, 0);
			draw_surface(surf_block, 0, 0);
			draw_tilemap(tlmp_objects, 0, 0);
		shader_reset();
		shader_set(sh_1111);
			with o_photon draw_self();
		shader_reset();
	surface_reset_target();
	
	// Draw to the light object's surface
	surface_set_target(photon_light.surface);
		draw_clear_alpha(c_white, 0.0);
		shader_set(sh_raycast_lite);
		shader_set_uniform_f(uni_raycast_lite_resolution, room_width,room_height);
		shader_set_uniform_f(uni_raycast_lite_transparency, o_photon.boosting ? 0.3 : 0.5);//0.15, 0.3
		shader_set_uniform_i(uni_raycast_lite_rays, 64);
		shader_set_uniform_i(uni_raycast_lite_steps, photon_light.radius - 10);
			draw_surface_part(surf_lightgen_1,
							o_photon.x - photon_light.radius, o_photon.y - photon_light.radius,
							2*photon_light.radius, 2*photon_light.radius, 0, 0);
		shader_reset();
	surface_reset_target();
	
	photon_light.x = o_photon.x - photon_light.radius;
	photon_light.y = o_photon.y - photon_light.radius;
} else {
	surface_set_target(photon_light.surface);
		draw_clear_alpha(c_white, 0.0);
	surface_reset_target();
}
#endregion

// Draw blocks to the lit surface
surface_set_target(surf_lit);
	draw_surface(surf_block, 0, 0);
surface_reset_target();

// Set up particles for drawing to the preblur surface
surface_set_target(surf_vblur);
	draw_clear_alpha(c_white, 0.0);
	
	part_system_drawit(global.p_sys);
	
	gpu_set_blendmode_ext(bm_zero, bm_inv_src_alpha);
		draw_surface(surf_block, 0, 0);
		draw_tilemap(tm_glowing,0,0);
	gpu_set_blendmode(bm_normal);
surface_reset_target();

// Draw to the preblur surface
surface_set_target(surf_preblur);
	// Add light assets	
	if instance_exists(o_asset_layers) {
		gpu_set_blendmode(bm_add);
			draw_surface(surf_assets_light_front, 0, 0);
		gpu_set_blendmode(bm_normal);
	}
	
	// Particles
	draw_surface(surf_vblur, 0, 0);
	
	// White flash
	if white_flash > 0 {
		draw_set_alpha(white_flash);
		draw_rectangle(0,0,room_width,room_height,false);
		draw_set_alpha(1.0);
		white_flash = max(white_flash-0.02,0);
	}
surface_reset_target();

// Light surface
surface_set_target(surf_light);
	// Add light assets
	if instance_exists(o_asset_layers) {
		gpu_set_blendmode(bm_add);
		draw_surface(surf_assets_light_front, 0, 0);
		gpu_set_blendmode(bm_normal);
	}
	
	// Remove glowing objects
	gpu_set_blendmode_ext(bm_zero, bm_inv_src_alpha);
		draw_tilemap(tm_glowing,0,0);
	
	// Add mirror flash
	gpu_set_blendmode(bm_add);
		with o_mirror_flash {
			if image_alpha > 0 draw_surface_ext(surface, x, y, 1, 1, 0, c_white, image_alpha);
		}
		with photon_light draw_surface(surface, x, y);
	
	// Remove blocks
	gpu_set_blendmode_ext(bm_zero, bm_inv_src_alpha);
		draw_surface(surf_block, 0, 0);
	
	gpu_set_blendmode(bm_normal);
surface_reset_target();


// Draw the photon trail
#region LIGHT TRAIL

if !surface_exists(wisp_trail) {
	wisp_trail = surface_create(room_width,room_height);
	surface_set_target(wisp_trail);
	draw_clear_alpha(c_black,0);
	surface_reset_target();
}

// Get the sprite data from photon
if instance_exists(o_photon) {
	if o_photon.boosting {
		ds_list_insert(trail_list,0,[o_photon.sprite_index, o_photon.image_index, o_photon.x, o_photon.y, o_photon.image_xscale]);
	} else {
		ds_list_insert(trail_list,0,[s_nothing, 0, 0, 0, 1]);
	}
} else {
	ds_list_insert(trail_list,0,[s_nothing, 0, 0, 0, 1]);
}
var trail_length = 15;
if ds_list_size(trail_list) == trail_length+1 ds_list_delete(trail_list, trail_length);

// Draw the trail on the surface
if ds_list_size(trail_list) > 0 {
	surface_set_target(wisp_trail);
		draw_clear_alpha(c_white,0);
		// Draw the trail
		var ts = ds_list_size(trail_list);
		for (var i=ts-1; i>0; i--) { // Go from faintest to brightest
			var data = ds_list_find_value(trail_list,i);
			gpu_set_blendmode_ext(bm_zero, bm_inv_src_alpha); // First anything on top of the current sprite
				draw_sprite_ext(data[0],data[1],data[2],data[3],data[4],1,0,c_white,1);
			gpu_set_blendmode(bm_normal); // Then draw the current sprite at the desired alpha
			shader_set(sh_white);
				draw_sprite_ext(data[0],data[1],data[2],data[3],data[4],1,0,c_white,clamp(1-i/ts, 0, 1));
			shader_reset();
		}
	
		// Draw photon
		with o_photon draw_sprite_ext(sprite_index,image_index,x,y,image_xscale,image_yscale,0,c_white,1);
		// If photon is boosting, draw him again to make him brighter
		if instance_exists(o_photon) {
			if o_photon.boosting {
				gpu_set_blendmode(bm_add);
				with o_photon draw_sprite_ext(sprite_index,image_index,x,y,image_xscale,image_yscale,0,c_white,1);
				gpu_set_blendmode(bm_normal);
			}
		}
	
		// Erase any light crystals from the trail
		gpu_set_blendmode_ext(bm_zero, bm_inv_src_alpha);
			with o_light_crystal draw_sprite(sprite_index,image_index,x,y);
			draw_surface(surf_block, 0, 0);
		gpu_set_blendmode(bm_normal);
	surface_reset_target();
}

// Draw the trail surface to the glow surface
surface_set_target(surf_preblur);
	// Draw wisp trail surface
	gpu_set_blendmode(bm_add);
	draw_surface(wisp_trail,0,0);
	gpu_set_blendmode(bm_normal);
surface_reset_target();

#endregion


// Apply lighting
// Blur the light surfaces
if blur_on {
	// Horizontal blur
	surface_set_target(surf_hblur);
		draw_clear_alpha(c_black, 1.0);
		shader_set(sh_gaussian_horizontal);
		shader_set_uniform_f(uni_resolution_hoz, room_width,room_height);
		shader_set_uniform_f(uni_blur_amount_hoz, var_blur_amount);
			draw_surface(surf_preblur,0,0);	
		shader_reset();
	surface_reset_target();

	// Vertical blur
	surface_set_target(surf_vblur);
		draw_clear_alpha(c_black, 1.0);
		shader_set(sh_gaussian_vertical);
		shader_set_uniform_f(uni_resolution_vert,room_width,room_height);
		shader_set_uniform_f(uni_blur_amount_vert, var_blur_amount);
			draw_surface(surf_hblur,0,0);	
		shader_reset();
	surface_reset_target();

	// Draw the darkened surface
	surface_set_target(surf_hblur); // reuse hblur surface
		draw_clear_alpha(c_white, 0);
		// Draw black box
		draw_set_colour(c_black);
		draw_set_alpha(0.86); // Darkness amount
		draw_rectangle(0,0,room_width,room_height,false);
		draw_set_colour(c_white);
		draw_set_alpha(1.0);
	surface_reset_target()
	
	// Draw the black box onto the background
	draw_surface(surf_hblur, 0, 0);
	
	surface_set_target(surf_hblur);
		// Only retain pixels over the lit layer
		gpu_set_blendmode_ext(bm_zero, bm_src_alpha);
		draw_surface(surf_lit, 0, 0);
				
		// Subtract surfaces and light sources
		gpu_set_blendmode_ext(bm_zero, bm_inv_src_alpha);
			shader_set(sh_make_transparent);
				draw_surface_ext(surf_vblur,0,0,1,1,0,c_white,0.5);//0.5
			shader_reset();
			draw_surface_ext(surf_light,0,0,1,1,0,c_white,light_tile_alpha*0.8); // Light Tiles
		gpu_set_blendmode(bm_normal);
	surface_reset_target();
	
	// Draw the lit surface to the screen
	draw_surface(surf_lit, 0, 0);
	
	// Draw the darkened surface to the screen
	draw_surface(surf_hblur,0,0);
	
	// Draw the blurred surface to the screen
	gpu_set_blendmode_ext(bm_src_alpha, bm_one);
		draw_surface_ext(surf_vblur,0,0,1,1,0,c_white,0.5); // Blurred objects
		draw_surface_ext(surf_light,0,0,1,1,0,c_white,light_tile_alpha * 0.7); // Light Tiles
}

// Draw the pre-blurred surface on top of the blurred surface
gpu_set_blendmode(bm_add);
	draw_surface(surf_preblur,0,0);
gpu_set_blendmode(bm_normal);

// Draw the gui surface
draw_surface(surf_gui,0,0);
surface_set_target(surf_gui);
draw_clear_alpha(c_white, 0);
surface_reset_target();

// Clear the preblur surface
surface_set_target(surf_preblur);
draw_clear_alpha(c_black, 1.0);
surface_reset_target();

// Clear the lit surface
surface_set_target(surf_lit);
draw_clear_alpha(c_white, 0);
surface_reset_target();



// Debug stuff
//draw_clear_alpha(c_black, 1.0);
//with o_mirror_flash {
//	if image_alpha > 0 draw_surface_ext(surface, x, y, 1, 1, 0, c_white, image_alpha);
//}
//draw_surface(surf_block, 0, 0);
//draw_surface(surf_light,0,0);
////with photon_light draw_surface(surface, x, y);

