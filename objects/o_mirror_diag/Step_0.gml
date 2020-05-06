/// @description Change brightness
if brightness > 0 brightness -= 0.05;
brightness = max(min(brightness,1),0);
/*
if instance_exists(o_photon) {
	if o_photon.crystal_cooldown == 0 {
		if o_photon.y == y {
			vbox.sprite_index = s_diag_collision_vertical;
		} else {
			vbox.sprite_index = s_nothing;
		}
		hbox.sprite_index = s_diag_collision_horizontal;
		
	} else {
		hbox.sprite_index = s_nothing;
		vbox.sprite_index = s_nothing;
	}
}