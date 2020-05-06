/// @description Control the platform
// Change the hspd
// Calculate hspd by finding the change in position
// This assures that the platforms stays on its correct path
var new_pos = x_equilib+pos_amp*sin(v_omega*osc_timer);
hspd = floor(new_pos-x);
osc_timer++;



// Move the platform
hspd_current = hspd;
photon_speed = 0;
var photon_riding = place_meeting(x,y-1,o_photon);
// Check all boxes and indicate if they are riding the platform
with o_box {
	riding_platform = noone;
	if place_meeting(x,y+1,other) {
		riding_platform = other;
	}
}
// Movement loop
for (var i = 0; i < abs(hspd_current); i++) {
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
		// Only check for collisions if boxes are close to the platform
		if y > other.y-10 && y < other.y+8+10 {
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
	if !place_meeting(x+sign(hspd_current),y,o_wall) {
		x += sign(hspd_current);
		// Give photon platform speed
		photon_speed++;
	} else {
		hspd = 0;
	}
}
if hspd == 0 hspd = -hspd_current;

if photon_riding o_photon.hspd_platform = sign(hspd_current)*photon_speed;
with o_box {
	if riding_platform == other {
		hspd_platform = sign(other.hspd_current)*other.photon_speed;
	}
}