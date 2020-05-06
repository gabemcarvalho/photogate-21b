/// @description Control the Crystal
// Shine randomly
if !shining {
	if shine_time > 0 {
		shine_time--;
	} else {
		if round(random(room_speed))==1 {
			shining = true;
		}
	}
} else {
	if shine_image < 5 {
		shine_image += shine_spd;
	} else {
		shine_image = 0;
		shining = false;
		shine_time = shine_time_max;
	}
}

// Create particles randomly
var rate = photon_in ? 2 : 4;
if (irandom(rate)==0) {
	var part_type = choose(global.p_crystal, global.p_crystal_large);
	if irandom(2) == 0 {
		part_particles_create(global.p_sys, x-8+irandom(16), y+5+irandom(6), part_type, 1);
	} else {
		part_particles_create(global.p_sys, x+choose(1,-1)*(4+irandom(6)), y-10+irandom(16), part_type, 1);
	}
}

if photon_in {
	// Photon is in the crystal
	// Visual effects
	bright_amount = max(bright_amount,0.1);	
	
	// Get directional inputs
	var key_right = keyboard_check(vk_right);
	var key_left = keyboard_check(vk_left);
	var key_up = keyboard_check(vk_up);
	var key_down = keyboard_check(vk_down);
	
	dir_x = key_right-key_left;
	dir_y = key_down-key_up;
	
	if dir_x == RIGHT dir = RIGHT;
	if dir_x == LEFT dir = LEFT;
	
	if dir_x == RIGHT sprite_index = sprite_right;
	if dir_x == LEFT sprite_index = sprite_left;
	
	// Find the total direction
	if key_down {
		if dir_x == RIGHT && key_right {
			dir_tot = 4;
		} else if dir_x == LEFT && key_left {
			dir_tot = 2;
		} else {
			dir_tot = 3;
		}
	} else {
		if dir_x == RIGHT && key_right {
			dir_tot = 5;
		} else if dir_x == LEFT && key_left {
			dir_tot = 1;
		}
	}
	
	// Control the camera
	o_camera.xdir = dir;
	o_camera.ydir = key_down-key_up;
	if dir_tot == 3 {
		if !key_up o_camera.ydir = DOWN;
		o_camera.xdir = 0;
	}
	
	// Launch Photon
	if keyboard_check(ord("Z")) {
		
		var new_photon = instance_create_layer(x,y-3,"Player",o_photon);
		
		switch dir_tot {
			case 1: // LEFT
			new_photon.hspd = -4;
			break;
			case 2:
			new_photon.hspd = -4;
			new_photon.vspd = 2;
			break;
			case 3: // DOWN
			new_photon.vspd = 4;
			break;
			case 4:
			new_photon.hspd = 4;
			new_photon.vspd = 2;
			break;
			case 5: // RIGHT
			new_photon.hspd = 4;
			break;
		}
		
		new_photon.boosting = true;
		new_photon.dir = dir;
		
		audio_play_sound(a_crystal_launch,8,false);
		
		photon_in = false;
		sprite_index = s_light_crystal_static_d;
		o_camera.follow = new_photon;
		scr_camera_mode(FAST);
		
		// Visual effects
		bright_amount = 1.0;
		scr_shockwave(x, y, OUT, 1.0, 0.4);
		//var burst = instance_create_layer(x, y, "Particles", o_light_crystal_burst_flash);
		//burst.image_angle = 180;
		
		for (var i = 0; i < 30; i++) {
			instance_create_layer(x-6+irandom(11),y-6+irandom(11),"Player",o_crystal_projectile);
		}
	}
	if in_timer > 0 in_timer--;
}

// Decrease the brightness of the crystal
if bright_amount > 0 bright_amount -= photon_in ? light_absorb_spd_photon : light_absorb_spd;
bright_amount = max(min(bright_amount,1), photon_in ? photon_resting_brightness : 0);
light_flash.image_alpha = bright_amount;
