/// @description Initialize the game
#macro VIEW_WIDTH 144//96,144
#macro VIEW_HEIGHT 81//54,81
#macro LEFT -1
#macro RIGHT 1
#macro UP -1
#macro DOWN 1
#macro RESTART 0
#macro DIRECT 0 // Camera modes
#macro NORMAL 1
#macro FAST 2
#macro FREEZE 3
#macro CRYSTAL 4
#macro NONE 127
#macro LAUNCHING 2
#macro RETRACTING 3
#macro RED 21
#macro BLUE 22
#macro PURPLE 23
#macro IN -1
#macro OUT 1

// Global Variables
global.r_name = "Name Not Set";
global.door_transition = false;
global.respawn_photon = false;
global.level = 0;
global.room_number = 0;
global.continue_room = r_a1_altar;//r_00;//r_a1_2_v2;
global.camera_y_offset = false;

// Custom Colours
global.col_tron_blue = make_colour_rgb(100,120,200);
global.col_hot_pink = make_colour_rgb(178,0,105);
global.col_amethyst_purple = make_colour_rgb(110,87,173);

// Music
global.bgm_audiogroup = audiogroup_vgm1;
audio_group_load(global.bgm_audiogroup);
global.music_master_gain = 0.0;//0.5
audio_group_load(audiogroup_photon);

// Textboxes
global.message[0] = "You shouldn't be seeing this message.";
global.message[1] = 0;
global.active_npc = noone;
// Text Colours
global.cl_blue = make_colour_rgb(82,99,204);
global.cl_red = make_colour_rgb(172,51,51);

// Buttons
global.red_active = false;
global.blue_active = false;
global.purple_active = false;

// Local Variables
// Doors
last_room = r_init_controller;
ground_y = 4;
spawn_side = LEFT;
door_x = 0;
door_boost = false;
door_hspd = 0;
door_vspd = 0;

// HUD
draw_hud = true;

// Layer names
global.layer_bk_fixed =				"bk_grid";
global.layer_bk_parallax_close =	"bk_crystals_back";
global.layer_bk_parallax_far =		"bk_crystals_back_far";
global.bk_parallax_y =				false;

// Misc
white_flash = 0;
cs_bar_height = 0;
blur_on = true;
global.f_neural = font_add_sprite_ext(s_neural_bitfont,"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890 .,!?:;()-'",true,1);
light_tile_alpha = 0.9;
light_tile_period = room_speed*20;
light_tile_timer = 0;
screen_gold = false;

// Particles
#region PARTICLES
// Create the particle system
global.p_sys = part_system_create_layer("particles",true);
part_system_automatic_draw(global.p_sys,false);

// White Pixel Type 3 (long life, directed up)
global.p_white_pixel_3 = part_type_create();
part_type_sprite(global.p_white_pixel_3,s_white_pixel,false,false,false);
part_type_life(global.p_white_pixel_3,100,200);
part_type_speed(global.p_white_pixel_3,0.1,0.3,0,0);
part_type_direction(global.p_white_pixel_3,80,100,0,20);

// Boost Door Particle
global.p_boost = part_type_create();
part_type_sprite(global.p_boost,s_p_boost_door,false,false,true);
part_type_life(global.p_boost,25,45);
part_type_alpha3(global.p_boost, 1.0, 0.7, 0);
part_type_size(global.p_boost, 1, 2, 0, 0);
part_type_speed(global.p_boost,-0.5,2.5,0,0);
part_type_direction(global.p_boost,60,120,0,0);
part_type_gravity(global.p_boost,0.3,270);

// Boost Door Particle 2 (white pixel)
global.p_boost_2 = part_type_create();
part_type_sprite(global.p_boost_2,s_green_pixel,false,false,false);
part_type_life(global.p_boost_2,25,45);
part_type_speed(global.p_boost_2,-0.5,2.5,0,0);
part_type_direction(global.p_boost_2,60,120,0,0);
part_type_gravity(global.p_boost_2,0.3,270);

// Photon walking particles
global.p_walking = part_type_create();
part_type_sprite(global.p_walking,s_white_pixel,false,false,false);
part_type_size(global.p_walking, 1, 2, 0.01, 0);
part_type_alpha2(global.p_walking, 0.8, 0);
part_type_life(global.p_walking,15,40);
part_type_speed(global.p_walking,0.1,0.2,0,0);
part_type_direction(global.p_walking,45,135,0,0);

// Photon ceiling particles
global.p_ceiling = part_type_create();
part_type_sprite(global.p_ceiling,s_white_pixel,false,false,false);
part_type_size(global.p_ceiling, 1, 2, 0.01, 0);
part_type_alpha2(global.p_ceiling, 0.8, 0);
part_type_life(global.p_ceiling,15,40);
part_type_speed(global.p_ceiling,0.1,0.3,0,0);
part_type_direction(global.p_ceiling,240,300,0,0);

// Mirror particle variables
var p_mirror_alpha = 0.7;
var p_mirror_min_spd = 0.5;
var p_mirror_max_spd = 2.5;

// Mirror particles (directed up)
global.p_mirror_up = part_type_create();
part_type_sprite(global.p_mirror_up,s_white_pixel,false,false,false);
part_type_size(global.p_mirror_up, 1, 1, 0, 0);
part_type_alpha3(global.p_mirror_up, p_mirror_alpha/2, p_mirror_alpha, 0);
part_type_life(global.p_mirror_up, 7, 20);
part_type_speed(global.p_mirror_up, p_mirror_min_spd, p_mirror_max_spd, -0.05, 0);
part_type_direction(global.p_mirror_up, 90, 90, 0, 0);

// Mirror particles (directed down)
global.p_mirror_down = part_type_create();
part_type_sprite(global.p_mirror_down,s_white_pixel,false,false,false);
part_type_size(global.p_mirror_down, 1, 1, 0, 0);
part_type_alpha3(global.p_mirror_down, p_mirror_alpha/2, p_mirror_alpha, 0);
part_type_life(global.p_mirror_down, 7, 20);
part_type_speed(global.p_mirror_down, p_mirror_min_spd, p_mirror_max_spd, -0.05, 0);
part_type_direction(global.p_mirror_down, 270, 270, 0, 0);

// Mirror particles (directed to the right)
global.p_mirror_right = part_type_create();
part_type_sprite(global.p_mirror_right,s_white_pixel,false,false,false);
part_type_size(global.p_mirror_right, 1, 1, 0, 0);
part_type_alpha3(global.p_mirror_right, p_mirror_alpha/2, p_mirror_alpha, 0);
part_type_life(global.p_mirror_right, 7, 20);
part_type_speed(global.p_mirror_right, p_mirror_min_spd, p_mirror_max_spd, -0.05, 0);
part_type_direction(global.p_mirror_right, 0, 0, 0, 0);

// Mirror particles (directed to the left)
global.p_mirror_left = part_type_create();
part_type_sprite(global.p_mirror_left,s_white_pixel,false,false,false);
part_type_size(global.p_mirror_left, 1, 1, 0, 0);
part_type_alpha3(global.p_mirror_left, p_mirror_alpha/2, p_mirror_alpha, 0);
part_type_life(global.p_mirror_left, 7, 20);
part_type_speed(global.p_mirror_left, p_mirror_min_spd, p_mirror_max_spd, -0.05, 0);
part_type_direction(global.p_mirror_left, 180, 180, 0, 0);

// Idle crystal particles
global.p_crystal = part_type_create();
part_type_sprite(global.p_crystal,s_white_pixel,false,false,false);
part_type_size(global.p_crystal, 1, 1, 0, 0);
part_type_alpha3(global.p_crystal, 0.9, 0.4, 0);
part_type_life(global.p_crystal, 15, 45);
part_type_speed(global.p_crystal, 0.05, 0.15, 0, 0);
part_type_direction(global.p_crystal, 0, 360, 0, 0);

// Idle crystal particles (large)
global.p_crystal_large = part_type_create();
part_type_sprite(global.p_crystal_large,s_white_pixel,false,false,false);
part_type_size(global.p_crystal_large, 2, 2, 0, 0);
part_type_alpha3(global.p_crystal_large, 0.9, 0.4, 0);
part_type_life(global.p_crystal_large, 15, 45);
part_type_speed(global.p_crystal_large, 0.05, 0.15, 0, 0);
part_type_direction(global.p_crystal_large, 0, 360, 0, 0);

// Moving platform particles
global.p_platform = part_type_create();
part_type_sprite(global.p_platform,s_purple_pixel,false,false,false);
part_type_size(global.p_platform, 1, 1, 0, 0);
part_type_alpha2(global.p_platform, 0.8, 0);
part_type_life(global.p_platform,15,40);
part_type_speed(global.p_platform,0,0.1,0,0);
part_type_direction(global.p_platform,45,315,0,0);

// Platform bottom particles
global.p_plat_bottom = part_type_create();
part_type_sprite(global.p_plat_bottom,s_purple_pixel,false,false,false);
part_type_size(global.p_plat_bottom, 1, 1, 0, 0);
part_type_alpha2(global.p_plat_bottom, 0.8, 0);
part_type_life(global.p_plat_bottom,15,60);
part_type_speed(global.p_plat_bottom,0.1,0.4,0,0);
part_type_direction(global.p_plat_bottom,270,270,0,0);

#endregion


#region PLAYER SPRITE BITMAPS
// THIS WILL TAKE A LONG TIME
// I'm doing this all in the first frame of the game instead of doing it every time it's called
map[0] = 0;

scr_create_sprite_map( char_idle, 0 );
map_idle[0] = 0;
array_copy(map_idle,0,map,0,64);

scr_create_sprite_map( char_up, 0 );
map_up[0] = 0;
array_copy(map_up,0,map,0,64);

scr_create_sprite_map( char_down, 0 );
map_down[0] = 0;
array_copy(map_down,0,map,0,64);

scr_create_sprite_map( char_run, 0 );
map_run0[0] = 0;
array_copy(map_run0,0,map,0,64);

scr_create_sprite_map( char_run, 1 );
map_run1[0] = 0;
array_copy(map_run1,0,map,0,64);

scr_create_sprite_map( char_run, 2 );
map_run2[0] = 0;
array_copy(map_run2,0,map,0,64);

scr_create_sprite_map( char_run, 3 );
map_run3[0] = 0;
array_copy(map_run3,0,map,0,64);

scr_create_sprite_map( char_run_up, 0 );
map_run_up0[0] = 0;
array_copy(map_run_up0,0,map,0,64);

scr_create_sprite_map( char_run_up, 1 );
map_run_up1[0] = 0;
array_copy(map_run_up1,0,map,0,64);

scr_create_sprite_map( char_run_up, 2 );
map_run_up2[0] = 0;
array_copy(map_run_up2,0,map,0,64);

scr_create_sprite_map( char_run_up, 3 );
map_run_up3[0] = 0;
array_copy(map_run_up3,0,map,0,64);

scr_create_sprite_map( char_jump, 0 );
map_jump[0] = 0;
array_copy(map_jump,0,map,0,64);

scr_create_sprite_map( char_fall, 0 );
map_fall[0] = 0;
array_copy(map_fall,0,map,0,64);

scr_create_sprite_map( char_fall_up, 0 );
map_fall_up[0] = 0;
array_copy(map_fall_up,0,map,0,64);

scr_create_sprite_map( char_plumeting, 0 );
map_plumeting[0] = 0;
array_copy(map_plumeting,0,map,0,64);

#endregion

game_loading = true;
draw_crt = true;


debug_overlay_enabled = false;
show_debug_overlay(false);