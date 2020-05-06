/// @description Launch Photon
// Control the state of the launchpad
if state == DOWN {
	if manual {
		#region MANUAL TRIGGER MECHANISM
		if trigger_timer == 0 {
			// unactive state, check for photon
			if place_meeting(x,y-1,o_photon) {
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
	if y != y_origin-launch_height {
		vspd = -launch_speed;
	} else {
		vspd = 0;
		state = UP;
		// Set photon's vspd
		if place_meeting(x,y-1,o_photon) {
			o_photon.vspd += -launch_speed;
			o_photon.can_fall = false;
			o_photon.on_ground = false;
			// Check for box on top of photon
			with o_box {
				if x > other.x-10 && x < other.x+other.sprite_width*other.image_xscale+10 {
					if place_meeting(x,y+1,o_photon) {
						vspd += -other.launch_speed;
						on_ground = false;
					}
				}
			}
		}
		// Set boxes' vspd
		with o_box {
			if x > other.x-10 && x < other.x+other.sprite_width*other.image_xscale+10 {
				if place_meeting(x,y+1,other) {
					vspd += -other.launch_speed;
					on_ground = false;
					// Check for photon on top of box
					if place_meeting(x,y-1,o_photon) {
						o_photon.vspd += -other.launch_speed;
						o_photon.can_fall = false;
						o_photon.on_ground = false;
					}
					// Check for box on top of box
					var other_box = instance_place(x,y-1,o_box);
					if other_box != noone {
						other_box.vspd += -other.launch_speed;
						other_box.on_ground = false;
					}
				}
			}
		}
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
	if y != y_origin {
		vspd = launch_speed;
	} else {
		vspd = 0;
		state = DOWN;
	}
}

// Move the launchpad
var vspd_current = vspd;
if vspd != 0 {
	for (var i = 0; i < abs(vspd_current); i++) {
		// Move photon out of the way
		if place_meeting(x,y+sign(vspd_current),o_photon) {
			#region BOX ON PHOTON
			// Check for box on top of photon
			with o_box {
				if x > other.x-10 && x < other.x+other.sprite_width*other.image_xscale+10 {
					plat_vspd = other.vspd;
					if place_meeting(x,y-sign(plat_vspd),o_photon) {
						// Check for box on top of box
						var other_box = instance_place(x,y-1,o_box);
						if other_box != noone {
							other_box.y += sign(plat_vspd);
							other_box.vspd_platform = plat_vspd;
							// Limit box's speed if hit from above
							if plat_vspd > 0 {
								other_box.vspd = min(other_box.vspd,plat_vspd);
							} else {
								other_box.vspd = 0;
							}
						}
						// Move box
						y += sign(plat_vspd);
						vspd_platform = plat_vspd;
						// Limit box's speed if hit from above
						if plat_vspd > 0 {
							vspd = min(vspd,plat_vspd);
						} else {
							vspd = 0;
						}
					}
				}
			}
			#endregion
			// Move photon
			o_photon.y += sign(vspd_current);
			o_photon.vspd_platform = vspd_current;
			// Limit photon's speed if hit from above
			if vspd_current > 0 {
				o_photon.vspd = min(o_photon.vspd,vspd_current);
			} else {
				o_photon.vspd = 0;
			}
		}
		#region BOXES
		// Move boxes
		with o_box {
			if x > other.x-10 && x < other.x+other.sprite_width*other.image_xscale+10 {
				plat_vspd = other.vspd;
				if place_meeting(x,y-sign(plat_vspd),other) {
					// Check for photon on top of box
					if place_meeting(x,y-1,o_photon) {
						o_photon.y += sign(plat_vspd);
						o_photon.vspd_platform = plat_vspd;
						// Limit photon's speed if hit from above
						if plat_vspd > 0 {
							o_photon.vspd = min(o_photon.vspd,plat_vspd);
						} else {
							o_photon.vspd = 0;
						}
					}
					// Check for box on top of box
					var other_box = instance_place(x,y-1,o_box);
					if other_box != noone {
						other_box.y += sign(plat_vspd);
						other_box.vspd_platform = plat_vspd;
						// Limit photon's speed if hit from above
						if plat_vspd > 0 {
							other_box.vspd = min(other_box.vspd,plat_vspd);
						} else {
							other_box.vspd = 0;
						}
					}
					// Move box
					y += sign(plat_vspd);
					vspd_platform = plat_vspd;
					// Limit box's speed if hit from above
					if plat_vspd > 0 {
						vspd = min(vspd,plat_vspd);
					} else {
						vspd = 0;
					}
				}
			}
		}
		#endregion
		// Move the platform
		y += sign(vspd_current);
	}
}