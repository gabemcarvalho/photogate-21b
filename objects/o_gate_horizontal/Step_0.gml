/// @description Control The Gate
// Colour trigger
switch colour {
	case RED:
		if global.red_active active = true else active = false;
	break;
	case BLUE:
		if global.blue_active active = true else active = false;
	break;
	case PURPLE:
		if global.purple_active active = true else active = false;
	break;
}

// Change bar's height
var height_prev = bar_height;
if active {
	if bar_height > 0 {
		bar_height = approach(bar_height,close_speed,0);
	}
} else {
	if bar_height != bar_height_max {
		bar_height = approach(bar_height,close_speed,bar_height_max);
	}
}
var height_diff = bar_height-height_prev;
// Move the bar one pixel at a time and move things out of the way if necessary
// Only necessary if bar is getting bigger
if height_diff >= 1 {
	for (var i = 1; i <= height_diff; i++) {
		with bar_wall {
			dir = other.dir;
			bar_spd = other.dir*other.close_speed;
			if image_xscale == 0 {
				if other.dir == LEFT image_xscale = 1/8 else image_xscale = -1/8;
			}
			// Check for and move photon
			if place_meeting(x+sign(bar_spd),y,o_photon) {
				o_photon.x += sign(bar_spd);
				o_photon.hspd_platform_hard = bar_spd;
			}
			// Move box out of the way
			with o_box {
				// Only check for collisions if boxes are close to the platform
				if y > other.y-10 && y < other.y+8+10 {
					plat_hspd = other.bar_spd;
					if place_meeting(x-sign(plat_hspd),y,other) {
						// Box pushing photon
						if place_meeting(x+sign(plat_hspd),y,o_photon) {
							o_photon.x += sign(plat_hspd);
							o_photon.hspd_platform_hard = plat_hspd;
							// Box pushing photon pushing box
							with o_photon {
								var other_box = instance_place(x+sign(other.plat_hspd),y,o_box);
								if other_box != noone {
									other_box.x += sign(other.plat_hspd);
									other_box.hspd_platform_hard = other.plat_hspd;
								}
							}
						}
						// Box pushing box
						var other_box = instance_place(x+sign(plat_hspd),y,o_box);
						if other_box != noone {
							other_box.x += sign(plat_hspd);
							other_box.hspd_platform_hard = plat_hspd;
							// Box pushing box pushing photon
							with other_box {
								if place_meeting(x+sign(other.plat_hspd),y,o_photon) {
									o_photon.x += sign(other.plat_hspd);
									o_photon.hspd_platform_hard = other.plat_hspd;
								}
							}
						}
						x += sign(plat_hspd);
						hspd_platform_hard = plat_hspd;
					}
				}
			}
		}
		// Change the bar height
		bar_wall.image_xscale = (height_prev+i)/8;
		if dir == LEFT bar_wall.x = x+8+bar_height_max-(height_prev+i);
	}	
} else {
	bar_wall.image_xscale = bar_height/8;
	if dir == LEFT bar_wall.x = x+8+bar_height_max-bar_height;
}