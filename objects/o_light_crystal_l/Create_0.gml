/// @description Init
crystal_type = 3;
shine_time_max = room_speed*4;
shine_time = shine_time_max;
shining = false;
shine_image = 0;
shine_spd = 1/3;

photon_in = false;
dir_x = LEFT;
dir = LEFT;
dir_y = 0;
vdir = 0;
dir_tot = 1;
in_timer = 0;

uni_brighten_amount = shader_get_uniform(sh_brighten,"amount");
bright_amount = 0;
photon_resting_brightness = 0.2;
light_absorb_spd = 0.06;
light_absorb_spd_photon = 0.09;

sprite_right = s_light_crystal_photon_left_l;
sprite_left = s_light_crystal_photon_left_l;
sprite_outline = s_light_crystal_outline_l;

// External light object (generated in controller at the start of the room)
light_flash = instance_create_layer(max(x - 40, 0), max(y - 40, 0), "GUI", o_mirror_flash);