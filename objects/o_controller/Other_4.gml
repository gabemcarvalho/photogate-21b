/// @description Set Up Surfaces
// Photon trail variables
wisp_trail = surface_create(room_width,room_height);
surface_set_target(wisp_trail);
draw_clear_alpha(c_black, 0);
surface_reset_target();

trail_list = ds_list_create();

// Glow layer variables
#region GLOW SHADER
uni_resolution_hoz = shader_get_uniform(sh_gaussian_horizontal,"resolution");
uni_resolution_vert = shader_get_uniform(sh_gaussian_vertical,"resolution");

uni_blur_amount_hoz = shader_get_uniform(sh_gaussian_vertical,"blur_amount");
uni_blur_amount_vert = shader_get_uniform(sh_gaussian_horizontal,"blur_amount");
var_blur_amount = 1.0;

surf_preblur =	surface_create(room_width,room_height);
surf_hblur =	surface_create(room_width,room_height);
surf_vblur =	surface_create(room_width,room_height);
surf_light =	surface_create(room_width,room_height);
#endregion

// Other Lighting Shaders and Surfaces
#region LIGHTING
uni_darken_amount = shader_get_uniform(sh_darken,"amount");
dark_amount = 0.2;

// Set the object layers that will glow
layer_script_begin("Instances",scr_glow_begin);
layer_script_end("Instances",scr_surface_reset_target);
layer_script_begin("Player",scr_glow_begin);
layer_script_end("Player",scr_surface_reset_target);

// Set the tile layers that will glow
tm_blocks = layer_tilemap_get_id("blocks");
layer_set_visible("blocks",false);
//tm_outlines = layer_tilemap_get_id("outlines");
layer_set_visible("outlines",false);
tm_glowing = layer_tilemap_get_id("glowing");
layer_set_visible("glowing",false);

// Light layer
generated_lights = false;
//tm_light = layer_tilemap_get_id("light_tiles");
layer_set_visible("light_tiles",false);
surf_lightgen_1 = surface_create(room_width, room_height);
surf_lightgen_2 = surface_create(room_width, room_height);
//uni_resolution_hoz_lightgen = shader_get_uniform(sh_gaussian_horizontal_lightgen,"resolution");
//uni_resolution_vert_lightgen = shader_get_uniform(sh_gaussian_vertical_lightgen,"resolution");
//uni_blur_amount_hoz_lightgen = shader_get_uniform(sh_gaussian_vertical_lightgen,"blur_amount");
//uni_blur_amount_vert_lightgen = shader_get_uniform(sh_gaussian_horizontal_lightgen,"blur_amount");
uni_raycast_resolution = shader_get_uniform(sh_raycast,"resolution");

// Lit layer (can be revealed by lighting)
surf_lit = surface_create(room_width, room_height);

// Block layer
surf_block = surface_create(room_width,room_height);

// GUI Surface
surf_gui = surface_create(room_width,room_height);

// Transition Surface
surf_trans = surface_create(VIEW_WIDTH,VIEW_HEIGHT);

// Tile layers that can be lit
tm_crystals_large = layer_tilemap_get_id("crystals_large");
layer_set_visible("crystals_large",false);
tm_ground = layer_tilemap_get_id("ground");
layer_set_visible("ground",false);
tm_crystals_small = layer_tilemap_get_id("crystals_small");
layer_set_visible("crystals_small",false);

// Assest layers (if needed)
drawn_assets = true;
if instance_exists(o_asset_layers) {
	drawn_assets = false;
	surf_assets_light_front = surface_create(room_width,room_height);
	surf_assets_light = surface_create(room_width,room_height);
	surf_assets_light_back = surface_create(room_width,room_height);
	surf_assets_dark = surface_create(room_width,room_height);
	surf_assets_dark_back = surface_create(room_width,room_height);
	layer_script_begin(	"assets_light_front",	scr_surface_assets_light_front);
	layer_script_begin(	"assets_light",			scr_surface_assets_light);
	layer_script_begin(	"assets_light_back",	scr_surface_assets_light_back);
	layer_script_begin(	"assets_dark",			scr_surface_assets_dark);
	layer_script_begin(	"assets_dark_back",		scr_surface_assets_dark_back);
	layer_script_end(	"assets_light_front",	scr_surface_reset_target);
	layer_script_end(	"assets_light",			scr_surface_reset_target);
	layer_script_end(	"assets_light_back",	scr_surface_reset_target);
	layer_script_end(	"assets_dark",			scr_surface_reset_target);
	layer_script_end(	"assets_dark_back",		scr_surface_reset_target);
}

// Mirror Flash
uni_raycast_lite_resolution = shader_get_uniform(sh_raycast_lite,"resolution");
uni_raycast_lite_transparency = shader_get_uniform(sh_raycast_lite,"transparency");
uni_raycast_lite_rays = shader_get_uniform(sh_raycast_lite,"rays");
uni_raycast_lite_steps = shader_get_uniform(sh_raycast_lite,"steps");
uni_bloom_resolution = shader_get_uniform(shdr_bloom, "resolution");
uni_bloom_intensity = shader_get_uniform(shdr_bloom, "intensity");
flashing_mirrors = ds_list_create();
flash_x1 = room_width;
flash_y1 = room_height;
flash_x2 = 0;
flash_y2 = 0;
flash_buffer = 24;

// Generate Tilemaps
layer_tlmp_blocks = layer_create(0, "tilemap_blocks");
layer_set_visible(layer_tlmp_blocks, false);
tlmp_blocks = layer_tilemap_create(layer_tlmp_blocks, 0, 0, tl_light_blocks, ceil(room_width / 8), ceil(room_height / 8));

layer_tlmp_mirror = layer_create(0, "tilemap_mirror");
layer_set_visible(layer_tlmp_mirror, false);
tlmp_mirror = layer_tilemap_create(layer_tlmp_mirror, 0, 0, tl_light_blocks, ceil(room_width / 8), ceil(room_height / 8));

for (var i=0; i<ceil(room_width / 8); i++) {
	for (var j=0; j<ceil(room_height / 8); j++) {
		var block_index = tile_get_index( tilemap_get(tm_blocks, i, j) );
		// note: index values 4, 5, 15 and 16 are diagonal blocks
		switch block_index {
			case 0: break;
			case 2: 
				tilemap_set(other.tlmp_blocks, 1, i, j);
				tilemap_set(other.tlmp_mirror, 2, i, j);
				break;
			case 4:
				tilemap_set(other.tlmp_mirror, 12, i, j);
				break;
			case 5:
				tilemap_set(other.tlmp_mirror, 13, i, j);
				break;
			case 15:
				tilemap_set(other.tlmp_mirror, 14, i, j);
				break;
			case 16:
				tilemap_set(other.tlmp_mirror, 15, i, j);
				break;
			default:
				tilemap_set(other.tlmp_blocks, 1, i, j);
				break;
		}
	}
}

layer_tlmp_objects = layer_create(0, "tilemap_objects");
layer_set_visible(layer_tlmp_objects, false);
tlmp_objects = layer_tilemap_create(layer_tlmp_objects, 0, 0, tl_light_blocks, ceil(room_width / 8), ceil(room_height / 8));

with o_light_crystal {
	var xpos = x / 8 - 1;
	var ypos = floor(y / 8) - 1;
	
	if abs(frac(xpos) - 0.5) < 0.1 {
		// Crystal is on a half-step x position
		xpos = floor(xpos);
		var tile_index = 20 ;
		switch crystal_type {
			case 0: break;
			case 1: tile_index += 8; break;
			default:
				show_error("you can't place a light crystal on a vertical half-step!", false);
				break;
		}
		tilemap_set(other.tlmp_objects, tile_index, xpos, ypos);
		tilemap_set(other.tlmp_objects, tile_index + 1, xpos + 1, ypos);
		tilemap_set(other.tlmp_objects, tile_index + 2, xpos + 2, ypos);
		tilemap_set(other.tlmp_objects, tile_index + 8, xpos, ypos + 1);
		tilemap_set(other.tlmp_objects, tile_index + 9, xpos + 1, ypos + 1);
		tilemap_set(other.tlmp_objects, tile_index + 10, xpos + 2, ypos + 1);
	} else {
		xpos = floor(xpos);
		var tile_index = 8 * (1 + crystal_type); // this works because of the way the tilemap is set up
		tilemap_set(other.tlmp_objects, tile_index, xpos, ypos);
		tilemap_set(other.tlmp_objects, tile_index + 1, xpos + 1, ypos);
		tilemap_set(other.tlmp_objects, tile_index + 2, xpos, ypos + 1);
		tilemap_set(other.tlmp_objects, tile_index + 3, xpos + 1, ypos + 1);
	}
}

with o_hazard {
	var xpos = floor(x / 8);
	var ypos = floor(y / 8);
	// Hazard blocks will always be bordered by at least one block
	if !vertical {
		var block_index = tile_get_index( tilemap_get(other.tm_blocks, xpos, ypos - 1) );
		if block_index == 0 {
			var offset = 1;
			var index = 4;
		} else {
			var offset = -1;
			var index = 5;
		}
		for (var i=0; i<image_xscale; i++) {
			var current_index = tile_get_index( tilemap_get(other.tlmp_objects, xpos + i, ypos + offset) );
			if current_index != 0 index = 3; // this is not perfect, but will work in 99% of cases
			tilemap_set(other.tlmp_objects, index, xpos + i, ypos + offset);
		}	
	} else {
		var block_index = tile_get_index( tilemap_get(other.tm_blocks, xpos - 1, ypos) );
		if block_index == 0 {
			var offset = 1;
			var index = 6;
		} else {
			var offset = -1;
			var index = 7;
		}
		for (var j=0; j<image_yscale; j++) {
			var current_index = tile_get_index( tilemap_get(other.tlmp_objects, xpos + offset, ypos + j) );
			if current_index != 0 index = 3; // this is not perfect, but will work in 99% of cases
			tilemap_set(other.tlmp_objects, index, xpos + offset, ypos + j);
		}
	}
}

// Block Outline
surf_outline = surface_create(room_width,room_height);
uni_outline_resolution = shader_get_uniform(sh_outline,"resolution");

photon_light = instance_create_layer(0, 0, "GUI", o_photon_light);

#endregion

// CRT Shader
#region CRT SHADER

application_surface_draw_enable(false);

shader_to_use = sh_CRT_Windows_full_shader;

crt_surface_scale = 3;

crt_surface_width  = view_wport[0] * crt_surface_scale;
crt_surface_height = view_hport[0] * crt_surface_scale;

uni_crt_sizes = shader_get_uniform(shader_to_use, "u_crt_sizes");
distort = shader_get_uniform(shader_to_use, "distort");
distortion = shader_get_uniform(shader_to_use, "distortion");
border = shader_get_uniform(shader_to_use, "border");

var_distort = true;
var_distortion_ammount = 0.03;
distort_ammount_default = 0.03;
var_border = true;

surface_width  = view_wport[0];
surface_height = view_hport[0];

surface_resize(application_surface, surface_width, surface_height);
#endregion

// Other shaders
surf_shader = surface_create(288,162);
uni_master_saturation = shader_get_uniform(sh_master,"Saturation");
uni_master_brightness = shader_get_uniform(sh_master,"Brightness");
uni_master_contrast = shader_get_uniform(sh_master,"Contrast");
uni_master_noise = shader_get_uniform(sh_master,"Noise");
uni_master_random_factor = shader_get_uniform(sh_master,"RandomFactor");
uni_master_aberration = shader_get_uniform(sh_master,"Aberration");
uni_master_gold = shader_get_uniform(sh_master,"Gold");

surf_pixel_manipulation = surface_create(288,162);

uni_wave_time = shader_get_uniform(shd_wave,"time");
uni_wave_amount = shader_get_uniform(shd_wave,"wave_amount");
uni_wave_distortion = shader_get_uniform(shd_wave,"wave_distortion");
uni_wave_speed = shader_get_uniform(shd_wave,"wave_speed");

uni_shock_time = shader_get_uniform(sh_shockwave2,"time");
uni_shock_pos = shader_get_uniform(sh_shockwave2,"mouse_pos");
uni_shock_resolution = shader_get_uniform(sh_shockwave2,"resolution");
uni_shock_amp = shader_get_uniform(sh_shockwave2,"shock_amplitude");
uni_shock_refraction = shader_get_uniform(sh_shockwave2,"shock_refraction");
uni_shock_width = shader_get_uniform(sh_shockwave2,"shock_width");

shockwave_on = false;
shockwave_time = 0;
shockwave_x = 0;
shockwave_y = 0;
shockwave_direction = OUT;
shockwave_speed = 1.0;
shockwave_distance = 1.0;

aberration_amount = 0.0;

// Respawn Photon
#region RESPAWN PHOTON
// door > spawner > existing photon
if global.respawn_photon {
	draw_hud = true;
	// If the last room is r_init_controller then don't spawn a photon at a door
	if last_room != r_init_controller {
		// Destroy any other photons
		if instance_exists(o_photon) instance_destroy(o_photon);
		// Spawn New Photon
		if instance_exists(o_door) with o_door {
			if other_room = other.last_room {
				var photon_new = instance_create_layer(0,0,"Player",o_photon);
				photon_new.dir = o_controller.spawn_side
				o_camera.follow = photon_new;
				if vertical {
					photon_new.x = x-other.door_x;
					photon_new.y = y-8*other.spawn_side;
					if other.spawn_side == 1 {
						photon_new.vspd = -4;
					} else {
						photon_new.vspd = 1;
					}
				} else {
					photon_new.x = x+other.spawn_side*16;
					photon_new.y = (y+8*image_yscale)-other.ground_y;
				}
			
				with o_camera {
				// Set initial position
				x_ext = 0;
				x = follow.x+x_ext;
				y = follow.y-8;
				x = clamp(x,VIEW_WIDTH/2,room_width-(VIEW_WIDTH/2));
				y = clamp(y,VIEW_HEIGHT/2,room_height-(VIEW_HEIGHT/2));

				xTo = x;
				yTo = y;
		
				// Set camera position
				var view_matrix = matrix_build_lookat(x,y,-10,x,y,0,0,1,0);
				camera_set_view_mat(camera,view_matrix);
				}
			}
		}
	} else if instance_exists(o_photon_spawner) {
		// Spawn at photon spawner
		if instance_exists(o_photon) instance_destroy(o_photon);
		instance_create_layer(o_photon_spawner.x+3,o_photon_spawner.y+4,"Player",o_photon);
		o_camera.follow = o_photon;
		
		with o_camera {
			// Set initial position
			x_ext = 0;
			x = follow.x+x_ext;
			y = follow.y-8;
			x = clamp(x,VIEW_WIDTH/2,room_width-(VIEW_WIDTH/2));
			y = clamp(y,VIEW_HEIGHT/2,room_height-(VIEW_HEIGHT/2));

			xTo = x;
			yTo = y;
		
			// Set camera position
			var view_matrix = matrix_build_lookat(x,y,-10,x,y,0,0,1,0);
			camera_set_view_mat(view_camera[0],view_matrix);
			
		}
	} else {
		// Don't destroy existing photons
	}
}

global.create_photon_flash = false;
global.photon_death_info = [0, 0, 0, 0, 0, 0];
#endregion

// HUD
surf_hud = surface_create(VIEW_WIDTH,9);//9
surface_set_target(surf_hud);
draw_clear_alpha(c_white, 0);
surface_reset_target();
instance_create_layer(0,0,"GUI",o_hud);

// Cutscene bar
surf_bar = surface_create(VIEW_WIDTH,9);
surface_set_target(surf_bar);
draw_clear_alpha(c_black, 1);
surface_reset_target();

// Room number
global.level = max(global.level,global.room_number);

// Background
global.bk_parallax_y = !instance_exists(o_bk_thunder);

// Platform drawing object
if instance_exists(o_moving_platform_horizontal) || instance_exists(o_moving_platform_vertical) {
	instance_create_layer(0, 0, "GUI", o_moving_platform_drawer);
}