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
active = !active;

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
		// *note: the bar is moving in the opposite direction as the gate's direction
		with bar_wall {
			dir = other.dir;
			bar_spd = -other.dir*other.close_speed;
			if image_yscale == 0 {
				if other.dir == UP image_yscale = -1/8 else image_yscale = 1/8;
			}
			// Check for and move photon
			if place_meeting(x,y-other.dir,o_photon) {
				// Check for box on top of photon
				with o_photon {
					var other_box = instance_place(x,y+sign(other.bar_spd),o_box);
					if other_box != noone {
						// Move the box
						other_box.y += sign(other.bar_spd);
						other_box.vspd_platform = other.bar_spd;
						// Limit photon's speed if hit from above
						if other.bar_spd > 0 {
							other_box.vspd = min(other_box.vspd,other.bar_spd);
						} else {
							other_box.vspd = 0;
						}
					}
				}
				
				// Move photon
				o_photon.y += sign(bar_spd);
				o_photon.vspd_platform = bar_spd;
				// Limit photon's speed if hit from above
				if bar_spd > 0 {
					o_photon.vspd = min(o_photon.vspd,bar_spd);
				} else {
					o_photon.vspd = 0;
				}
			}
			// Check for and move box
			with o_box {
				// Only check for collisions if the box is close to the bar
				if x > other.x-10 && x < other.x+18 {
					if place_meeting(x,y+other.dir,other) {
						// Check for and move photon
						if place_meeting(x,y+sign(other.bar_spd),o_photon) {
							// Move photon
							o_photon.y += sign(other.bar_spd);
							o_photon.vspd_platform = other.bar_spd;
							// Limit photon's speed if hit from above
							if other.bar_spd > 0 {
								o_photon.vspd = min(o_photon.vspd,other.bar_spd);
							} else {
								o_photon.vspd = 0;
							}
						}
						// Move the box
						y += sign(other.bar_spd);
						vspd_platform = other.bar_spd;
						// Limit box's speed if hit from above
						if other.bar_spd > 0 {
							vspd = min(vspd,other.bar_spd);
						} else {
							vspd = 0;
						}
					}
				}
			}
		}
		
		// Change the bar height
		bar_wall.image_yscale = (height_prev+i)/8;
		if dir == DOWN bar_wall.y = y+8+bar_height_max-(height_prev+i);
	}
} else {
	bar_wall.image_yscale = bar_height/8;
	if dir == DOWN bar_wall.y = y+8+bar_height_max-bar_height;
}