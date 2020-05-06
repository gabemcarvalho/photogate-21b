if !light_crystal_absorb {
	//x = mouse_x;
	//y = mouse_y;
	if x > o_camera.x dir = RIGHT else dir = LEFT;

	// Reassemble photon
	if o_pbit.on_target == false {} else {
		instance_destroy(o_pbit);
		instance_destroy();
		instance_create_layer(x,y,"Player",o_photon);
		o_camera.follow = o_photon;
	}
} else {
	if !instance_exists(o_pbit) {
		lc.photon_in = true;
		lc.in_timer = 2;
		if dir == RIGHT lc.sprite_index = lc.sprite_right else lc.sprite_index = lc.sprite_left;
		lc. dir = dir;
		if dir == RIGHT lc.dir_tot = 5 else lc.dir_tot = 1;
		o_camera.follow = lc;
		scr_camera_mode(CRYSTAL);
		lc.bright_amount = 1;
		instance_destroy();
	}
}