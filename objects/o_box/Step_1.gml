/// @description Move the box
if keyboard_check_pressed(ord("F")) hspd = -4;
// Control Velocity
// Set horizontal check distance for vertical motion
if hspd_platform == 0 {
	var check_distance = 0;
} else {
	if sign(hspd_platform) == sign(hspd) {
		var check_distance = hspd_platform+hspd;
	} else {
		var check_distance = hspd_platform;
	}
}
// Convert platform speed to real speed
if hspd_platform_hard_last > 0 {
	if hspd_platform_hard < hspd_platform_hard_last {
		hspd = max(hspd_platform_hard_last,hspd);
	}
} else if hspd_platform_hard_last < 0 {
	if hspd_platform_hard > hspd_platform_hard_last {
		hspd = min(hspd_platform_hard_last,hspd);
	}
}
// Control vertical motion
if place_meeting(x+check_distance,y+1,o_wall) || place_meeting(x,y+1,o_wall_box_oneway) {
	if !place_meeting(x,y+1,o_wall_mirror) {
		// On the ground
		on_ground = true;
		// If on a moving platform an photon is above, move photon
		if hspd_platform != 0 {
			if place_meeting(x,y-1,o_photon) {
				o_photon.hspd_platform = hspd_platform;
			}
			// Also check for other boxes
			var other_box = instance_place(x,y-1,o_box);
			if other_box != noone {
				other_box.hspd_platform = hspd_platform;
			}
		}
	}
} else {
	// In the air
	if on_ground == true {
		if vspd_platform_last != 0 && vspd == 0 {
			vspd = vspd_platform_last;
		}
		if hspd_platform_last != 0 hspd += hspd_platform_last;
	}
	on_ground = false;
	vspd += grav;
}

// Friction
if on_ground {
	// Don't apply friction if the box is over a mirror
	if !place_meeting(x,y+1,o_wall_mirror) {
		hspd = approach(hspd,0.5,0);
	}
}

// Weird vertical platform case speed
if vspd_next_3 != 0 {
	vspd = vspd_next_3;
	vspd_next_3 = 0;
}

// Drag other boxes on top of photon's head
if place_meeting(x,y+1,o_photon) {
	var box_hit = instance_place(x,y-1,o_box);
	if box_hit != noone {
		box_hit.hspd = hspd;
	}
}

// Horizontal Movement
var collided = false;
var hparticles = true;
if hspd == 0 hparticles = false;
// Hard platform spped limits total speed
if hspd_platform_hard > 0 {
	hspd = max(0,hspd-hspd_platform_hard);
} else if hspd_platform_hard < 0 {
	hspd = min(0,hspd-hspd_platform_hard);
}
var hspd_total = hspd+hspd_platform;
hspd_platform_last = hspd_platform;
hspd_platform_hard_last = hspd_platform_hard;
hspd_platform = 0;
hspd_platform_hard = 0; // Hard platforms move box manually
var moved_h = false;
if hspd_total != 0 {
	for (var i = 0; i < abs(hspd_total); i++) {
		// Move the box and check for collisions with walls/photon
		if !place_meeting(x+sign(hspd_total),y,o_wall) && !place_meeting(x+sign(hspd_total),y,o_photon) {
			x += sign(hspd_total);
			moved_h = true;
		} else {
			if !place_meeting(x+sign(hspd_total),y,o_photon) {
				// Move one pixel up if nessecary
				var top_box = instance_place(x,y-1,o_box);
				if top_box != noone {
					top_box.y -= 1;
				}
				if !place_meeting(x+sign(hspd_total),y-1,o_wall) && vspd >= 0 {
					// Check for a box on top of the box
					if top_box != noone {
						top_box.x += sign(hspd_total);
					}
					// Move up a pixel
					x += sign(hspd_total);
					y -= 1;
				} else {
					if top_box != noone top_box.y += 1;
					// Collided with some type of wall
					collided = true;
				}
			} else {
				// Collided with some type of wall
				collided = true;
			}
		}
	}
	if collided {
		// Check if the wall is a mirror
		var mirror = instance_place(x+sign(hspd_total),y,o_wall_mirror);
		if mirror != noone {
			// Collision with mirror
			hspd = -hspd;
			scr_mirror_flash(mirror);
			audio_play_sound(a_mirror_hit_A2,8,false);
		} else {
			// Check for collision with photon
			var photon_hit = instance_place(x+sign(hspd_total),y,o_photon);
			if photon_hit != noone {
				// Collide with photon
				var hspd_photon = photon_hit.hspd;
				photon_hit.hspd = hspd;
				hspd = hspd_photon;
				photon_hit.move_key_released_midair = false;
			} else {
				// Check for collision with another box
				var box_hit = instance_place(x+sign(hspd_total),y,o_box);
				if box_hit != noone {
					// Collide with the other box
					var hspd_box = box_hit.hspd;
					box_hit.hspd = hspd;
					hspd = hspd_box;
				} else {
					// Collison with regular wall
					hspd = 0;
				}
			}
		}
	}
	// Move down slopes
	if on_ground {
		if !place_meeting(x,y+1,o_wall) {
			if place_meeting(x,y+2,o_wall) {
				y += 1;
			}
		}
	}
}
if moved_h && on_ground && hparticles {
	if irandom(0)==0 part_particles_create(global.p_sys, x+4, y+7, global.p_walking, 1);
}

// Vertical Movement
collided = false;
var int_vspd = round(vspd);
var move_distance = 0;
vspd_platform_last = vspd_platform;
vspd_platform = 0; // Need to reset this every frame
if int_vspd != 0 {
	for (var j = 0; j < abs(int_vspd); j++) {
		if !place_meeting(x,y+sign(int_vspd),o_wall) && !place_meeting(x,y+sign(int_vspd),o_photon) {
			// May have still collided with oneway platform
			var pl_oneway = instance_place(x,y+sign(int_vspd),o_wall_box_oneway);
			if pl_oneway != noone {
				if pl_oneway.y >= y+8 {
					collided = true;
				} else {
					y += sign(int_vspd);
					move_distance++;
				}
			} else {
				y += sign(int_vspd);
				move_distance++;
			}
		} else {
			// Check again and don't collide if a oneway photon wall was hit
			var pl_oneway_photon = instance_place(x,y+sign(int_vspd),o_wall_oneway);
			if pl_oneway_photon != noone {
				// May have still collided with oneway platform
				var pl_oneway = instance_place(x,y+sign(int_vspd),o_wall_box_oneway);
				if pl_oneway != noone {
					if pl_oneway.y >= y+8 {
						collided = true;
					} else {
						y += sign(int_vspd);
						move_distance++;
					}
				} else {
					y += sign(int_vspd);
					move_distance++;
				}
			} else {
				collided = true;
			}
		}
	}
}
if vmirror_collide {
	vmirror_collide = false;
	vspd = vspd_next_2;
	vspd_next_2 = 0;
} else if collided {
	// Check if the wall is a mirror
	var mirror = instance_place(x,y+sign(int_vspd),o_wall_mirror);
	if mirror != noone {
		// Collide with mirror
		if move_distance <= 1 {
			y -= sign(vspd)*move_distance;
			vspd = -vspd;
		} else {
			vmirror_collide = true;
			vspd_next_2 = -vspd;
			vspd = -sign(vspd)*move_distance;
		}
		audio_play_sound(a_mirror_hit_A2,8,false);
		scr_mirror_flash(mirror);
	} else {
		// Check for collision with vertical moving platform ***WHY WAS THIS HERE??
		//var v_plat = instance_place(x,y+sign(int_vspd),o_moving_platform_vertical);
		//if v_plat != noone {
		//	y -= 3;
		//}
		// Check for collision with photon
		var photon_hit = instance_place(x,y+sign(int_vspd),o_photon);
		if photon_hit != noone {
			if vspd_platform_last == 0 {
				// Collide with photon
				var vspd_photon = photon_hit.vspd;
				photon_hit.vspd = vspd;
				vspd = vspd_photon;
				if place_meeting(x,y+sign(vspd),o_wall) vspd = 0;
				// Check if photon is standing on ground, and if so drag the box on photon's head
				with photon_hit {
					if place_meeting(x,y+1,o_wall) && !place_meeting(x,y+1,other) {
						other.hspd = hspd;
					}
				}
			}
		} else {
			// Check for collision with another box
			var box_hit = instance_place(x,y+sign(int_vspd),o_box);
			if box_hit != noone {
				// Collide with the other box
				var vspd_box = box_hit.vspd;
				box_hit.vspd = vspd;
				vspd = vspd_box;
			} else {
				// Collison with regular wall
				vspd = 0;
			}
		}
	}
}
moved_by_v_platform = false;

// Destroy the box
if place_meeting(x,y,o_hazard) {
	audio_play_sound(a_death_explosion,8,false);
	scr_box_explode();
} else {
	var wall = instance_place(x,y,o_wall);
	if wall != noone {
		if wall.object_index != o_wall_oneway {
			audio_play_sound(a_death_explosion,8,false);
			scr_box_explode();
		}
	}
}