/// @description Control Photon
// Check buttons
if keyboard_check(vk_left) && canmove key_left = 1 else key_left = 0;
if keyboard_check(vk_right) && canmove key_right = 1 else key_right = 0;
if keyboard_check_released(vk_left) && canmove key_left_released = 1 else key_left_released = 0;
if keyboard_check_released(vk_right) && canmove key_right_released = 1 else key_right_released = 0;
if keyboard_check_pressed(ord("Z")) && canmove key_jump_pressed = true else key_jump_pressed = false;
if keyboard_check(ord("Z")) && canmove key_jump = true else key_jump = false;
key_down = keyboard_check(vk_down);
key_up = keyboard_check(vk_up);

// Set direction
var dir_prev = dir;
if canmove {
	if key_right-key_left != 0 moving = true else moving = false;
	if boosting {
		if moving && !crystal_cooldown && on_ground dir = key_right-key_left;
	} else {
		if moving && !crystal_cooldown dir = key_right-key_left;
	}
} else {
	moving = false;
}

image_xscale = -dir;

// Weird edge case for collisions
if dir_prev == RIGHT && dir == LEFT {
	if place_meeting(x-1,y,o_wall) {
		x++;
	}
}

#region MOVEMENT
// Control Horizontal Movement
if boosting {
	if on_ground {
		var mvspd = run_spd;
		hspd = mvspd*dir
	} else {
		hspd = hspd;
	}
} else { 
	var mvspd = walk_spd;
	if moving && crystal_cooldown == 0 {
		if abs(hspd) < walk_spd {
			//hspd += dir;
			hspd = approach(hspd,1,walk_spd*dir);
			// Weird case while pushing two blocks
			if place_meeting(x+dir,y,o_box) && hspd == dir {
				hspd += dir;
			}
		} else {
			if abs(hspd+dir) < abs(hspd) hspd += dir;
		}
	} else {
		if crystal_cooldown == 0 {
			if on_ground && vspd == 0 {
				//hspd = 0;
				hspd = approach(hspd,1,0);
			} else {
				// Only slow down if photon is at walking speed and stops holding a key
				if abs(hspd) <= walk_spd {
					if key_left_released || key_right_released move_key_released_midair = true;
					if move_key_released_midair {
						hspd = approach(hspd,1,0);
					}
				}
			}
		}
	}
}


// Control Vertical Movement
if hspd_platform == 0 {
	var check_distance = 0;
} else {
	if sign(hspd_platform) == sign(hspd) {
		var check_distance = hspd_platform+hspd;
	} else {
		var check_distance = hspd_platform;
	}
}
if place_meeting(x+check_distance,y+1,o_wall) {
	// Weird vspd case correction
	if vspd == -0.5 || vspd == 0.5  vspd = 0; // This may break some things

	if !place_meeting (x,y+1,o_wall_mirror) || ( vspd == 0 && hspd <= walk_spd ) || (boosting && vspd == 0) {
		if on_ground == false && choose(1,2,3,4)!=1 && canmove audio_play_sound(choose(a_land_1,a_land_2,a_land_3,a_land_4,a_land_5,a_land_6),10,false);
		on_ground = true;
		//vspd = 0; // this might break things
		if key_jump_pressed || pre_jump {
			// Jump
			vspd = -jump_power+vspd_platform/2;
			move_key_released_midair = false;
			// Convert platform speed to real speed
			hspd += hspd_platform+hspd_platform_hard;
			hspd_platform = 0;
			hspd_platform_hard = 0;
			can_fall = true;
			// Play sound
			audio_play_sound(choose(a_jump_1,a_jump_2,a_jump_3,a_jump_4,a_jump_5),10,false);
			// Check for a box above photon and move the box accordingly
			var head_box = instance_place(x,y-1,o_box);
			if head_box != noone {
				head_box.vspd = vspd;
				vspd = vspd/2;
			}
			// Ground particles
			for (var i = 0; i < 4; i++) {
				part_particles_create(global.p_sys, x-3+irandom(6)-dir, y+3, global.p_walking, 1);
			}
		}
		pre_jump = false;
	}
	if !place_meeting (x,y+1,o_wall_mirror) move_key_released_midair = false;
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
} else {
	// In the air
	pre_jump = false;
	if on_ground = true {
		if key_jump_pressed {
			// Jump
			vspd = -jump_power+vspd_platform/2-grav;
			move_key_released_midair = false;
			// Convert platform speed to real speed
			hspd += hspd_platform+hspd_platform_hard;
			hspd_platform = 0;
			hspd_platform_hard = 0;
			can_fall = true;
			// Play sound
			audio_play_sound(choose(a_jump_1,a_jump_2,a_jump_3,a_jump_4,a_jump_5),10,false);
		} else {
			if vspd_platform_last != 0 && vspd == 0 {
				vspd = vspd_platform_last;
				can_fall = false;
			}
			if hspd_platform_last != 0 hspd += hspd_platform_last;
		}
	} else if key_jump_pressed {
		pre_jump = true;
	}
	on_ground = false;
	
	// Check if directional key has been released
	if key_left_released || key_right_released move_key_released_midair = true;
	
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
	
	
	if vspd < 0 {
		// Fall faster if btton is not held (must have jumped manually)
		if !key_jump && can_fall {
			//vspd = max(vspd,-jump_power/2);
			var vspd_new = lerp(vspd,0,0.3);
			if vspd_new-vspd > 0.8 vspd += 0.8 else vspd = vspd_new;
		}
		// Accelerate down
		if vspd+grav >= 0 {
			vspd = 0 hangtime = hangtime_max;
		} else {
			vspd += grav;
		}
	} else if vspd == 0 {
		if hangtime > 0 hangtime-- else vspd += grav;
	} else {
		// vspd > 0
		//if key_jump vspd += grav*0.7 else vspd += grav;
		vspd += grav;//*0.7
	}
	vspd = max(vspd,-vspd_max);
	vspd = min(vspd,vspd_max);
}

// Collide with diagonal mirror
if mirror_next_frame == true {
	mirror_next_frame = false;
	hspd = hspd_next;
	vspd = vspd_next;
	if vspd < 0 {
		on_ground = false;
		can_fall = false;
	}
}

var diag_mirror = instance_place(x+hspd,y+vspd,o_mirror_diag);
if diag_mirror != noone && crystal_cooldown == 0 {
	// Move to the mirror
	var vi = sign(hspd);
	if place_meeting(x+hspd,y,diag_mirror) {
		while !place_meeting(x+vi,y,diag_mirror) {
			vi+=sign(hspd);
		}
	}
	var vj = sign(vspd);
	if place_meeting(x,y+vspd,diag_mirror) {
		while !place_meeting(x,y+vj,diag_mirror) {
			vj+=sign(vspd);
		}
	}
	
	var pre_hspd = hspd;
	var pre_vspd = vspd;
	
	if vspd == 0 {
		if boosting vspd = -6.2*diag_mirror.image_yscale else vspd = -abs(pre_hspd)*diag_mirror.image_yscale*2;
		x-=diag_mirror.image_xscale;
	} else {
		dir = diag_mirror.image_xscale;
		if boosting vspd = -abs(pre_hspd)*diag_mirror.image_yscale*2 else vspd = -abs(pre_hspd)*diag_mirror.image_yscale;
	}
	
	hspd = abs(pre_vspd)*diag_mirror.image_xscale;
	if abs(hspd) > 0 {
		if hspd > 0 hspd = max(hspd,2) else hspd = min(hspd,-2);
	}
	
	// The determined resulting values for hspd and vspd will be applied on the next frame
	// This frame, photon moves toward the mirror
	hspd_next = hspd;
	vspd_next = vspd;
	hspd = vi;
	vspd = vj;
	
	// Play sound
	audio_play_sound(choose(a_bounce_1,a_bounce_2,a_bounce_3),10,false);
	audio_play_sound(a_mirror_hit_A2,8,false);
	
	diag_mirror.brightness = 1;
	scr_mirror_flash(diag_mirror);
	crystal_cooldown = 3;
	mirror_next_frame = true;
}

// Move Photon
#region OLD CODE
/*
if place_meeting(x+hspd,y,o_wall) {
	while !place_meeting(x+sign(hspd),y,o_wall) x += sign(hspd);
	
	#region MIRRORS
	// Check if the wall is a mirror
	var mirror = instance_place(x+sign(hspd),y,o_wall_mirror);
	if mirror != noone {
		// Collision with mirror
		dir = -dir;
		hspd = -hspd;
		crystal_cooldown = 5;
		scr_mirror_flash(mirror);
	} else {
		// Collison with regular wall
		hspd = 0;
		if boosting boosting = false;
	}
	#endregion
	
} else {
	x += hspd;
}
*/
#endregion
// Horizontal Movement
var moved = false;
var collided = false;
var hparticles = true;
if hspd == 0 hparticles = false;
// Hard platform speed limits total speed
if hspd_platform_hard > 0 {
	hspd = max(0,hspd-hspd_platform_hard);
} else if hspd_platform_hard < 0 {
	hspd = min(0,hspd-hspd_platform_hard);
}
var hspd_total = hspd+hspd_platform;
hspd_platform_last = hspd_platform;
hspd_platform_hard_last = hspd_platform_hard;
hspd_platform = 0;
hspd_platform_hard = 0; // Hard platforms move photon manually
if hspd_total != 0 {
	// Move horizontally
	for (var i = 0; i < abs(hspd_total); i++) {
		if !place_meeting(x+sign(hspd_total),y,o_wall) {
			x += sign(hspd_total);
			moved = true;
		} else {
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
		}
	}	
	// Assess collided object
	if collided {
		#region MIRRORS
		// Extend run animation by 1 frame if moving platform is hit
		if place_meeting(x+sign(hspd),y,o_moving_platform_horizontal) wall_hit_frame = 1;
		// Check if the wall is a mirror
		var mirror = instance_place(x+sign(hspd_total),y,o_wall_mirror);
		if mirror != noone {
			// Collision with mirror
			dir = -dir;
			hspd = -hspd;
			crystal_cooldown = 5;
			scr_mirror_flash(mirror);
			audio_play_sound(choose(a_bounce_1,a_bounce_2,a_bounce_3),10,false);
			audio_play_sound(a_mirror_hit_A2,8,false);
			// Mirror particles
			var mirror_y2 = mirror.y + 8*mirror.image_yscale;
			if hspd_total > 0 {
				for (var i = 0; i < 20; i++) {
					var py = y-3+irandom(6);
					if (py < mirror.y || py > mirror_y2) continue;
					part_particles_create(global.p_sys, mirror.x+2, py, global.p_mirror_left, 1);
				}
			} else {
				for (var i = 0; i < 20; i++) {
					var py = y-3+irandom(6);
					if (py < mirror.y || py > mirror_y2) continue;
					part_particles_create(global.p_sys, mirror.x+8*mirror.image_xscale-2, py, global.p_mirror_right, 1);
				}
			}
		} else {
			// Check for collision with a box
			var box_hit = instance_place(x+sign(hspd_total),y,o_box);
			if box_hit != noone {
				// Collide horizontally with a box
				/*	Note that this will be taken as a collision where momentum is conserved
					Both Photon and the box will have the same mass
					This means their speeds will simply swap
				*/
				if sign(box_hit.hspd) != sign(hspd) || abs(hspd) > abs(box_hit.hspd) {
					var hspd_box = box_hit.hspd;
					box_hit.hspd = hspd;
					if sign(hspd_box) != sign(hspd) hspd = hspd_box;
					move_key_released_midair = false;
					
					if on_ground wall_hit_frame = 2;
					
					if boosting {
						boosting = false;
						//hspd = hspd_box;
						if hspd == 0 crystal_cooldown = 2;
						// Play sound
						audio_play_sound(choose(a_land_1,a_land_2,a_land_3,a_land_4,a_land_5,a_land_6),10,false);
					}
				}
			} else {
				// Collison with regular wall
				var boost_door = instance_place(x+sign(hspd_total),y,o_boost_door);
				if boost_door != noone && boosting {
					boost_door.active = true;
					scr_add_screenshake(1,6);
					boosting = false;
					hspd = 2*sign(x-boost_door.x);
					if vspd == 0 vspd = -1.5*sign(y-boost_door.y);
					crystal_cooldown = 5;
					on_ground = false;
					// Make particles
					for (var i = 0; i < 4; i++) {
						part_particles_create(global.p_sys, x+dir, y-3+irandom(6), global.p_walking, 1);
					}
				} else {
					hspd = 0;
				}
				if boosting {
					boosting = false;
					hspd = -sign(hspd_total);
					if vspd == 0 vspd = -1.5;
					// Play sound
					audio_play_sound(choose(a_land_1,a_land_2,a_land_3,a_land_4,a_land_5,a_land_6),10,false);
					scr_add_screenshake(1, 4);
					// Make particles
					for (var i = 0; i < 4; i++) {
						part_particles_create(global.p_sys, x+dir, y-3+irandom(6), global.p_walking, 1);
					}
				}
			}
		}
		#endregion
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
// Ground particles
if moved && on_ground {
	if hparticles {
		if irandom(4)==1 part_particles_create(global.p_sys, x, y+3, global.p_walking, 1);
	}
}

#region OLD CODE
/*
var int_vspd = round(vspd);
if place_meeting(x,y+int_vspd,o_wall) {
	while !place_meeting(x,y+sign(int_vspd),o_wall) y += sign(int_vspd);
	// Check if the wall is a mirror
	var mirror = instance_place(x,y+sign(vspd),o_wall_mirror);
	if mirror != noone {
		// Collide with mirror
		vspd = -vspd-grav;
		can_fall = false;
		scr_mirror_flash(mirror);
	} else {
		vspd = 0;
	}
	
} else {
	y += int_vspd;
}
*/
#endregion
// Vertical Movement
collided = false;
var int_vspd = round(vspd);
var move_distance = 0;
vspd_platform_last = vspd_platform;
vspd_platform = 0; // Need to reset this every frame
if int_vspd != 0 {
	for (var j = 0; j < abs(int_vspd); j++) {
		if !place_meeting(x,y+sign(int_vspd),o_wall) {
			y += sign(int_vspd);
			move_distance++;
		} else {
			collided = true;
		}
	}
}
if vmirror_collide {
	vmirror_collide = false;
	vspd = vspd_next_2;
	vspd_next_2 = 0;
} else if collided {
	// Check if the wall is a mirror
	var mirror = instance_place(x,y+sign(vspd),o_wall_mirror);
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
		audio_play_sound(choose(a_bounce_1,a_bounce_2,a_bounce_3),10,false);
		audio_play_sound(a_mirror_hit_A2,8,false);
		can_fall = false;
		scr_mirror_flash(mirror);
		
		// Mirror particles
		var mirror_x2 = mirror.x + 8*mirror.image_xscale;
		if int_vspd > 0 {
			for (var i = 0; i < 20; i++) {
				var px = x-3+irandom(5)-dir;
				if (px < mirror.x || px > mirror_x2) continue;
				part_particles_create(global.p_sys, px, mirror.y + 2, global.p_mirror_up, 1);
			}
		} else {
			for (var i = 0; i < 20; i++) {
				var px = x-3+irandom(5)-dir;
				if (px < mirror.x || px > mirror_x2) continue;
				part_particles_create(global.p_sys, px, mirror.y + 8*mirror.image_yscale - 2, global.p_mirror_down, 1);
			}
		}
	} else {
		// Check for collision with a box
		var box_hit = instance_place(x,y+sign(int_vspd),o_box);
		if box_hit != noone {
			if box_hit.vspd_platform_last == 0 { // no collision for the case where vspd_platform != 0
				// Collide vertically with a box
				var vspd_box = box_hit.vspd;
				box_hit.vspd = vspd;
				with box_hit if place_meeting(x,y+sign(vspd),o_wall) vspd = 0;
				//if sign(hspd_box) != sign(hspd) hspd = hspd_box;
				vspd = vspd_box;
				
				if boosting {
					boosting = false;
					crystal_cooldown = 2;
					// Play sound
					audio_play_sound(choose(a_land_1,a_land_2,a_land_3,a_land_4,a_land_5,a_land_6),10,false);
				}
			}
		} else {
			var boost_door = instance_place(x,y+sign(vspd),o_boost_door);
			if boost_door != noone && boosting {
				boost_door.active = true;
				scr_add_screenshake(1,6);
				boosting = false;
				vspd = 3*sign(y-boost_door.y);
				hspd = 0;
				crystal_cooldown = 5;
				on_ground = false;
				scr_shockwave(x, y, OUT, 1.0, 0.4);
			} else {
				vspd = 0;
			}
		}
		// Ceiling particles
		if int_vspd < 0 {
			for (var i = 0; i < 3; i++) {
				part_particles_create(global.p_sys, x-3+irandom(6)-dir, y-4, global.p_ceiling, 1);
			}
		}
	}
}
// Used for moving platforms
moved_by_v_platform = false;
moved_by_v_platform_box = noone;
// Ground particles
if place_meeting(x, y+1, o_wall) && !on_ground && !place_meeting(x, y+1, o_wall_mirror) {
	for (var i = 0; i < 5; i++) {
		part_particles_create(global.p_sys, x-3+irandom(6)-dir, y+3, global.p_walking, 1);
	}
}

#endregion

// Control the sprite
if sprite_index != sprite_idle {
	sprite_idle = char_idle;
	idle_timer = 0;
	idle_target = room_speed * random_range(2, 5);
} else {
	idle_timer++;
	if idle_timer >= idle_target {
		image_index = 0;
		sprite_idle = choose(	char_blink, char_blink, char_blink, char_blink, char_blink, char_blink,
								char_blink, char_blink, char_blink, char_blink, char_blink, char_blink,
								char_dance1, char_down, char_dance2, char_dance3 );
		idle_timer = 0;
		idle_target = room_speed * random_range(2, 5);
	}
}
if canmove {
	if place_meeting(x,y+1,o_wall) {
		if hspd != 0 {
			sprite_index = key_up ? sprite_run_up : sprite_run;
		} else {
			if wall_hit_frame == 0 {
				if key_up {
					sprite_index = sprite_up; // looking up
				} else if key_down {
					sprite_index = sprite_down; // crouching
				} else {
					sprite_index = sprite_idle;
				}
			} else {
				sprite_index = key_up ? sprite_run_up : sprite_run;
				wall_hit_frame--;
			}
		}
	} else {
		if vspd <= 0 sprite_index = sprite_jump else sprite_index = key_up ? sprite_fall_up : sprite_fall;
	}
}
if boosting {
	image_speed = 2;
} else {
	image_speed = 25/15;
}

// Play movement sounds
if ( sprite_index == sprite_run || sprite_index == sprite_run_up ) && floor(image_index) == 2 {
	 if stepping == false {
		stepping = true;
		audio_play_sound(choose(a_step_1,a_step_2,a_step_3,a_step_4,a_step_5),10,false);
	 }
} else {
	stepping = false;
}

// Set the camera mode
if boosting {
	scr_camera_mode(FAST);
} else {
	scr_camera_mode(NORMAL);
}
// Set the camera's direction
o_camera.xdir = dir;
if boosting && !on_ground && hspd == 0 o_camera.xdir = 0;
if vspd > 0 {
	o_camera.ydir = DOWN;
} else if vspd < 0 {
	o_camera.ydir = UP;
} else {
	o_camera.ydir = 0;
}

// Collide with light crystal
if crystal_cooldown > 0 crystal_cooldown--;
var lc = instance_place(x,y,o_light_crystal);
if lc != noone && crystal_cooldown == 0 {
	// Vaporize into crystal
	scr_photon_vaporize_v2(lc.x,lc.y,true,lc,false);
	// Play sound
	audio_play_sound(a_enter_crystal,10,false);
	// Create a shockwave
	scr_shockwave(x, y, IN, 0.5, 0.2);
}

// Hit a hazard
// Can also die by getting stuck in a wall
if place_meeting(x,y,o_hazard) || place_meeting(x,y,o_wall) {
	// Kill Photon
	scr_photon_vaporize_v2(x,y,false,noone,true);
	// Play death sound
	audio_play_sound(choose(a_AHHHH,a_death_1,a_death_2,a_death_3,a_death_4,a_death_5),10,false);
	audio_play_sound(a_death_explosion,8,false);
	// Distort the screen
	scr_screen_distort(0.05);
	// Create a shockwave
	scr_shockwave(x, y, OUT, 1.0, 0.5);
	// Set timer to restart room
	o_controller.alarm[RESTART] = room_speed;
	scr_add_screenshake(3,7);
	//instance_create_layer(x, y, "particles", o_photon_burst_flash);
	global.create_photon_flash = true;
	global.photon_death_info = [x, y, sprite_index, image_index, image_xscale, image_yscale];
	global.respawn_photon = true;
}

// Talk to an npc
if instance_exists(o_npc_indicator) && on_ground && canmove {
	if place_meeting(x,y,o_npc_indicator.follow) {
		o_npc_indicator.countdown = 1;
		// Interact with npc
		if keyboard_check_pressed(vk_down) {
			var npc = o_npc_indicator.follow;
			sprite_index = sprite_idle;
			moving = false;
			canmove = false;
			npc.canmove = false;
			npc.sprite_index = npc.sprite_idle;
			if x != npc.x {
				dir = sign(npc.x-x);
			}
			npc.dir = -dir;
			global.active_npc = npc;
			textbox_show(npc.message);
		}
	}
} else {
	var npc = instance_place(x,y,o_npc_parent);
	if npc != noone && on_ground && canmove {
		// Near an npc
		instance_create_layer(0,0,"GUI",o_npc_indicator);
		o_npc_indicator.follow = npc;
		o_npc_indicator.countdown = 1;
	}	
}

// Hit an unboost area
if place_meeting(x,y,o_unboost) boosting = false;


// Emit Type 1 Particles
//if boosting {
//	part_particles_create(global.p_sys,x,y-1+random_range(-2,2),global.p_white_pixel_1,2+random(2));
//}

// Vaporize
if keyboard_check_pressed(vk_space) {scr_photon_vaporize_v2(mouse_x,mouse_y,false,noone,false)}