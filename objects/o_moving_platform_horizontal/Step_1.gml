/// @description Control the platform
// Change the hspd
var new_pos = x_equilib+pos_amp*sin(v_omega*osc_timer);
hspd = floor(new_pos-x_trig);
x_trig += hspd;
if osc_timer < round(osc_period*1/4) || osc_timer >= round(osc_period*3/4) {
	if x < bound_right hspd = min(max(hspd,1),max_spd) else hspd = 0;
} else {
	if x > bound_left hspd = max(min(hspd,-1),-max_spd) else hspd = 0;
}

// Control timer
osc_timer++;
if osc_timer > osc_period osc_timer = 0;

// Check if just stopped (for particles)
if hspd == 0 {
	if stopped == 0 {
		stopped = 1;
	} else {
		stopped = 2;
	}
} else {
	stopped = 0;
}

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
	// Generate particles
	if irandom(2) == 0 part_particles_create(global.p_sys, x + (hspd_current>0?0:8*platform_width), y+1+irandom(6), global.p_platform, 1);
}

// Generate particles
if stopped == 1 {
	var part_number = round( random_range( platform_width, 3*platform_width ) );
	for (var i = 0; i < part_number; i++) {
		part_particles_create(global.p_sys, x + irandom(platform_width*8-1), y+7, global.p_plat_bottom, 1);
	}
}

if photon_riding o_photon.hspd_platform = sign(hspd_current)*photon_speed;
with o_box {
	if riding_platform == other {
		hspd_platform = sign(other.hspd_current)*other.photon_speed;
	}
}