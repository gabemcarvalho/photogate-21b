/// @description Init
hspd = 0;
hspd_current = 0;
osc_amp = 2;
osc_period = 40;
osc_timer = 0;
photon_speed = 0;

platform_width = 2; // Number of blocks the platform is
max_speed = 3;

// Calculate the bounds of the path based on sprite
bound_left = x;
bound_right = x+sprite_width-platform_width*8;
x_equilib = bound_left+(bound_right+platform_width*8-bound_left)/2-platform_width*8/2;
x = x_equilib;
// Trig stuff
pos_amp = (bound_right-bound_left)/2;
v_omega = max_speed/pos_amp;

sprite_index = s_moving_platform_2x1;
image_xscale = 1;

// Can either set max speed or path period to determine parameters
// Use scr_plat_spd() or scr_plat_period()

