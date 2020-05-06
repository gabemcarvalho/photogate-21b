/// @descrip scr_setup_plat(osc_period, max_spd, platform_width);
/// @param osc_period
/// @param max_spd
/// @param platform_width
/// @param dir
osc_period = argument0;
max_spd = argument1;
platform_width = argument2;

if self.object_index == o_moving_platform_horizontal {
	// Set hspd
	hspd = max_spd;
	hspd_current = hspd;
	
	// Calculate the bounds of the path
	bound_right = bound_left+32*original_xscale-platform_width*8;
	
	// Calculate the center point of the path
	x_equilib = (bound_right+bound_left)/2;
	x = x_equilib;

	// Trig stuff
	pos_amp = (bound_right-bound_left)/2;
	x_trig = x;
} else {
	// Set vspd
	vspd = max_spd;
	vspd_current = vspd;
}

// Trig stuff
v_omega = 2*pi/osc_period;

if argument3 == LEFT osc_timer += osc_period/2;

// Set the sprite
switch platform_width {
	case 2:
		sprite_index = s_moving_platform_2x1;
		break;
	case 3:
		sprite_index = s_moving_platform_3x1;
		break;
	case 4:
		sprite_index = s_moving_platform_4x1;
		break;
	case 8:
		sprite_index = s_moving_platform_8x1;
		break;
}