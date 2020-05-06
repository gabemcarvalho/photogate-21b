/// @description Init
// *********** Set "osc_period", "max_spd" and "platform_width" in creation code to control platform **********
osc_period = room_speed*3;
max_spd = 1;
platform_width = 2;

hspd = max_spd;
hspd_current = hspd;

osc_timer = 0;

photon_speed = 0;

// Calculate the bounds of the path based on sprite
original_xscale = image_xscale;
bound_left = x;
bound_right = x+sprite_width-platform_width*8;

// Calculate the center point of the path
x_equilib = (bound_right+bound_left)/2;
x = x_equilib;

// Trig stuff
pos_amp = (bound_right-bound_left)/2;
v_omega = 2*pi/osc_period;
x_trig = x;

// Set the sprite
if platform_width == 2 sprite_index = s_moving_platform_2x1;
image_xscale = 1;

stopped = 0;