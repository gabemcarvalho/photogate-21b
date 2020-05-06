/// @description Launch Photon
// Control the state of the launchpad
if state == DOWN {
	if manual {
		#region MANUAL TRIGGER MECHANISM
		if trigger_timer == 0 {
			// unactive state, check for photon
			if place_meeting(x-1,y,o_photon) {
				trigger_timer++;
			}
		} else if trigger_timer < trigger_timer_max {
			trigger_timer++;
		} else {
			trigger_timer = 0;
			state = LAUNCHING;
		}
		#endregion
	}
	// Colour trigger
	if colour == RED && global.red_active {
		trigger_timer = 0;
		state = LAUNCHING;
	} else if colour == BLUE && global.blue_active {
		trigger_timer = 0;
		state = LAUNCHING;
	} else if colour == PURPLE && global.purple_active {
		trigger_timer = 0;
		state = LAUNCHING;
	}
} else if state == LAUNCHING {
	if x != x_origin+launch_height {
		hspd = launch_speed;
	} else {
		hspd = 0;
		state = UP;
	}
} else if state == UP {
	if manual {
		#region AUTOMATIC RETRACT
		if retract_timer < retract_timer_max {
			retract_timer++;
		} else {
			retract_timer = 0;
			state = RETRACTING;
		}
		#endregion
	}
	// Colour trigger
	if colour == RED && !global.red_active {
		retract_timer = 0;
			state = RETRACTING;
	} else if colour == BLUE && !global.blue_active {
		retract_timer = 0;
			state = RETRACTING;
	} else if colour == PURPLE && !global.purple_active {
		retract_timer = 0;
			state = RETRACTING;
	}
} else if state == RETRACTING {
	if x != x_origin {
		hspd = -launch_speed;
	} else {
		hspd = 0;
		state = DOWN;
	}
}

// Move the launchpad
hspd_current = hspd;
var photon_speed = 0;
var photon_riding = place_meeting(x,y-1,o_photon);
for (var i = 0; i < abs(hspd_current); i++) {
	// Move photon out of the way
	//if place_meeting(x+sign(hspd_current),y,o_photon) {
	//	o_photon.x += sign(hspd_current);
	//	o_photon.hspd_platform_hard = hspd_current;
	//}
	// Move photon out of the way
	if place_meeting(x+sign(hspd_current),y,o_photon) {
		o_photon.x += sign(hspd_current);
		o_photon.hspd_platform_hard = hspd_current;
		#region PHOTON PUSHING BOXES
		// Check for boxes behind photon and push them out of the way
		with o_box {
			plat_hspd = other.hspd_current;
			if place_meeting(x-sign(plat_hspd),y,o_photon) {
				x += sign(plat_hspd);
				hspd_platform_hard = plat_hspd;
				var other_other_box = instance_place(x+sign(plat_hspd),y,o_box);
				if other_other_box != noone {
					other_other_box.x += sign(plat_hspd);
					other_other_box.hspd_platform_hard = plat_hspd;
				}
			}
		}
		#endregion
	}
	#region BOXES
	// Move box out of the way
	with o_box {
		// Only check for collisions if boxes are close to the launcher
		if y > other.y-10 && y < other.y+16+10 {
			plat_hspd = other.hspd_current;
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
	#endregion
	}
	// Move the platform
	x += sign(hspd_current);
	photon_speed++;
}
if hspd == 0 hspd = -hspd_current;

if photon_riding o_photon.hspd_platform = sign(hspd_current)*photon_speed;