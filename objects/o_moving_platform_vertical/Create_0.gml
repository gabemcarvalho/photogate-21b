/// @description Init
// *********** Set "osc_period", "max_spd" and "platform_width" in creation code to control platform **********
osc_period = room_speed*3;
max_spd = 1;
platform_width = image_xscale*2;

vspd = max_spd;
vspd_current = vspd;
vspd_last = 0;
osc_timer = 0;

photon_moved = false;

// Calculate the bounds of the path based on sprite
bound_top = y;
bound_bottom = y+sprite_height-8;

// Calculate the center point of the path
y_equilib = bound_top+(bound_bottom+8-bound_top)/2-4;
y = y_equilib;

// Trig stuff
pos_amp = (bound_bottom-bound_top)/2;
v_omega = 2*pi/osc_period;
y_trig = y;

// Set the sprite
if platform_width == 2 {
	sprite_index = s_moving_platform_2x1;
} else if platform_width == 3 {
	sprite_index = s_moving_platform_3x1;
}
image_yscale = 1;
image_xscale = 1;

stopped = 0;