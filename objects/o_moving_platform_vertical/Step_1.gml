/// @description Control the platform
// Change the vspd
// Change the hspd
var new_pos = y_equilib+pos_amp*sin(v_omega*osc_timer);
vspd = floor(new_pos-y_trig);
y_trig += vspd;
if osc_timer < round(osc_period*1/4) || osc_timer >= round(osc_period*3/4) {
	if y < bound_bottom vspd = min(max(vspd,1),max_spd) else vspd = 0;
} else {
	if y > bound_top vspd = max(min(vspd,-1),-max_spd) else vspd = 0;
}

// Control timer
osc_timer++;
if osc_timer > osc_period osc_timer = 0;

// Check if just stopped (for particles)
if vspd == 0 {
	if stopped == 0 {
		stopped = 1;
	} else {
		stopped = 2;
	}
} else {
	stopped = 0;
}

// Move the platform
photon_moved = false;
vspd_current = vspd;
if (!place_meeting(x,y+sign(vspd_current),o_wall) || room!=r_a2_15) { // This case makes the room filled with moving platforms work
	for (var i = 0; i < abs(vspd_current); i++) {
		// Move photon out of the way
		if place_meeting(x,y+sign(vspd_current),o_photon) {
			if o_photon.moved_by_v_platform == false {
				// Check for box on top of photon
				with o_photon {
					var other_box = instance_place(x,y+sign(other.vspd_current),o_box);
					if other_box != noone {
						// Move the box
						other_box.y += sign(other.vspd_current);
						other_box.vspd_platform = other.vspd_current;
						// Limit photon's speed if hit from above
						if other.vspd_current > 0 {
							other_box.vspd = min(other_box.vspd,other.vspd_current);
						} else {
							other_box.vspd = 0;
						}
					}
				}
				// Move photon
				o_photon.y += sign(vspd_current);
				o_photon.vspd_platform = vspd_current;
				// Limit photon's speed if hit from above
				if vspd_current > 0 {
					o_photon.vspd = min(o_photon.vspd,vspd_current);
				} else {
					o_photon.vspd = 0;
				}
				photon_moved = true;
			}
		}
		// Pull photon downward
		if sign(vspd_current) == 1 && place_meeting(x,y-sign(vspd_current),o_photon) {
			if o_photon.moved_by_v_platform == false {
				// Check if the acceleration is less than that of gravity
				if vspd_current-vspd_last <= 1 {
					// Check that there isn't already a platform underneath photon
					y++;
					with o_photon if !place_meeting(x,y+1,o_wall) {
						y += sign(other.vspd_current);
						vspd_platform = other.vspd_current;
						other.pulled = true;
						other.photon_moved = true;
					}
					y--;
				}
			
			}
		}
		#region BOXES
		// Move boxes out of the way
		// ** this may cause lag with large numbers of boxes or platforms **
		with o_box {
			photon_moved_box = noone;
			// Only check for collision with boxes in the right vertical column
			if x > other.x-10 && x < other.x+other.sprite_width*other.image_xscale+10 {
				plat_vspd = other.vspd_current;
				if place_meeting(x,y-sign(plat_vspd),other) {
					// Check for and move photon if necessary
					if place_meeting(x,y+sign(plat_vspd),o_photon) {
						if o_photon.moved_by_v_platform_box == noone || o_photon.moved_by_v_platform_box == self {
							o_photon.y += sign(plat_vspd);
							o_photon.vspd_platform = plat_vspd;
							// Limit photon's speed if hit from above
							if plat_vspd > 0 {
								o_photon.vspd = min(o_photon.vspd,plat_vspd);
							} else {
								o_photon.vspd = 0;
							}
							photon_moved_box = self;
						}
					}
					// Check for photon under box
					if place_meeting(x,y+1,o_photon) {
						// Collide with photon
						o_photon.y += 1;
						o_photon.vspd_platform = plat_vspd;
						if vspd == 0 vspd_next_3 = o_photon.vspd;
						if place_meeting(x,y+sign(vspd),o_wall) vspd = 0;
						// Limit photon's speed
						if plat_vspd > 0 {
							o_photon.vspd = max(o_photon.vspd,plat_vspd);
						} else {
							o_photon.vspd = 0;
						}	
					}
					#region BOX ON BOX
					// Check for another box
					var other_box = instance_place(x,y+sign(plat_vspd),o_box);
					if other_box != noone {
						// Check for and move photon if necessary
						with other_box {
							if place_meeting(x,y+sign(other.plat_vspd),o_photon) {
								if o_photon.moved_by_v_platform_box == noone || o_photon.moved_by_v_platform_box == self {
									o_photon.y += sign(other.plat_vspd);
									o_photon.vspd_platform = other.plat_vspd;
									// Limit photon's speed if hit from above
									if other.plat_vspd > 0 {
										o_photon.vspd = min(o_photon.vspd,other.plat_vspd);
									} else {
										o_photon.vspd = 0;
									}
									other.photon_moved_box = self;
								}
							}
							// Check for photon under box
							if place_meeting(x,y+1,o_photon) {
								// Collide with photon
								o_photon.y += 1;
								o_photon.vspd_platform = other.plat_vspd;
								if vspd == 0 vspd_next_3 = o_photon.vspd;
								// Limit photon's speed
								if other.plat_vspd > 0 {
									o_photon.vspd = max(o_photon.vspd,other.plat_vspd);
								} else {
									o_photon.vspd = 0;
								}	
							}
						}
						// Move the box
						other_box.y += sign(plat_vspd);
						other_box.vspd_platform = plat_vspd;
						// Limit box's speed if hit from above
						if plat_vspd > 0 {
							other_box.vspd = min(other_box.vspd,plat_vspd);
						} else {
							other_box.vspd = 0;
						}
					}
					#endregion
					// Move the box
					y += sign(plat_vspd);
					vspd_platform = plat_vspd;
					// Limit box's speed if hit from above
					if plat_vspd > 0 {
						vspd = min(vspd,plat_vspd);
					} else {
						vspd = 0;
					}
				}
				// Pull box downward
				if sign(plat_vspd) == 1 && place_meeting(x,y+sign(plat_vspd),other) {
					// Check if the acceleration is less than that of gravity
					if plat_vspd-other.vspd_last <= 1 {
						// Check that there isn't already a platform underneath the box
						other.y++;
						if !place_meeting(x,y+1,o_wall) {
							// Check for and pull photon down if necessary
							if place_meeting(x,y-sign(plat_vspd),o_photon) {
								if o_photon.moved_by_v_platform_box == noone || o_photon.moved_by_v_platform_box == self {
										o_photon.y += sign(plat_vspd);
										o_photon.vspd_platform = plat_vspd;
										o_photon.vspd = 0;
										photon_moved_box = self;
								}
							}
							#region BOX ON BOX
							// Check for another box
							var other_box = instance_place(x,y-sign(plat_vspd),o_box);
							if other_box != noone {
								// Check for and pull photon down if necessary
								with other_box {
									if place_meeting(x,y-sign(other.plat_vspd),o_photon) {
										if o_photon.moved_by_v_platform_box == noone || o_photon.moved_by_v_platform_box == self {
											o_photon.y += sign(other.plat_vspd);
											o_photon.vspd_platform = other.plat_vspd;
											o_photon.vspd = 0;
											other.photon_moved_box = self;
										}
									}
								}
								// Move the box
								other_box.y += sign(plat_vspd);
								other_box.vspd_platform = plat_vspd;
								other_box.vspd = 0;
								// Also check for photon below the box, and bounce if necessary
								with other_box {
									if place_meeting(x,y+1,o_photon) {
										if o_photon.moved_by_v_platform_box == noone || o_photon.moved_by_v_platform_box == self {
											// Collide with photon
											o_photon.y += sign(other.plat_vspd);
											o_photon.vspd_platform = other.plat_vspd;
											if vspd == 0 vspd = o_photon.vspd;
											// Limit photon's speed
											if other.plat_vspd > 0 {
												o_photon.vspd = max(o_photon.vspd,other.plat_vspd);
											} else {
												o_photon.vspd = 0;
											}
											photon_moved_box = self;
										}
									}
								}
							}
							#endregion
							y += sign(plat_vspd);
							vspd_platform = plat_vspd;
						}
						other.y--;
					}
				}
				// Also check for photon below the box, and bounce if necessary
				if place_meeting(x,y+1,o_photon) && place_meeting(x,y+1,other) {
					if o_photon.moved_by_v_platform_box == noone || o_photon.moved_by_v_platform_box == self {
						// Collide with photon
						o_photon.y += sign(plat_vspd);
						o_photon.vspd_platform = plat_vspd;
						if vspd == 0 vspd = o_photon.vspd;
						if place_meeting(x,y+sign(vspd),o_wall) vspd = 0;
						// Limit photon's speed
						if plat_vspd > 0 {
							o_photon.vspd = max(o_photon.vspd,plat_vspd);
						} else {
							o_photon.vspd = 0;
						}
						photon_moved_box = self;
					}
				}
			}
			if photon_moved_box != noone o_photon.moved_by_v_platform_box = photon_moved_box;
		}
		#endregion
		// Move the platform
		if !place_meeting(x,y+sign(vspd_current),o_wall) {
			y += sign(vspd_current);
		} else {
			vspd_current = 0;
		}
		// Generate particles
		if irandom(3 / platform_width) == 0 part_particles_create(global.p_sys, x + irandom(platform_width*8-1), y + (vspd_current>0?0:7), global.p_plat_bottom, 1);
	}
}
vspd_last = vspd;

if photon_moved == true o_photon.moved_by_v_platform = true;

// Generate particles
if stopped == 1 {
	var part_number = round( random_range( platform_width, 3*platform_width ) );
	for (var i = 0; i < part_number; i++) {
		part_particles_create(global.p_sys, x + irandom(platform_width*8-1), y+7, global.p_plat_bottom, 1);
	}
}