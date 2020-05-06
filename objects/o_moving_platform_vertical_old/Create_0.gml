/// @description Init
vspd = 0;
vspd_current = 0;
vspd_last = 0;
osc_amp = 2;
osc_period = 40;
osc_timer = 0;
photon_moved = false;

platform_width = 2; // Number of blocks the platform is
max_speed = 3;

// Calculate the bounds of the path based on sprite
bound_top = y;
bound_bottom = y+sprite_height-8;
y_equilib = bound_top+(bound_bottom+8-bound_top)/2-4;
y = y_equilib;
// Trig stuff
pos_amp = (bound_bottom-bound_top)/2;
v_omega = max_speed/pos_amp;

sprite_index = s_moving_platform_2x1;
image_yscale = 1;