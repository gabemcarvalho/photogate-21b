/// @description scr_mirror_flash(mirror)
/// @param mirror
if instance_exists(argument0) {
	with argument0 {
		brightness = 1;
		ds_list_add(o_controller.flashing_mirrors, self);
		var flash_x1 = max(x - o_controller.flash_buffer, 0);
		var flash_y1 = max(y - o_controller.flash_buffer, 0);
		var flash_x2 = min(x + 8 * abs(image_xscale) + o_controller.flash_buffer, room_width);
		var flash_y2 = min(y + 8 * abs(image_yscale) + o_controller.flash_buffer, room_height);
		o_controller.flash_x1 = min(flash_x1, o_controller.flash_x1);
		o_controller.flash_y1 = min(flash_y1, o_controller.flash_y1);
		o_controller.flash_x2 = max(flash_x2, o_controller.flash_x2);
		o_controller.flash_y2 = max(flash_y2, o_controller.flash_y2);
		
		var adj_mirrors = ds_list_create();
		
		// Check for connected light crystals
		var crystals = ds_list_create();
		var crystal_nbr = instance_place_list(x,y,o_light_crystal,crystals,false);
		if crystal_nbr != 0 {
			for (var i = 0; i < crystal_nbr; i++) {
				with crystals[|i] {
					bright_amount = max(bright_amount,0.7);
				}
			}
		}
		ds_list_destroy(crystals);
		
		// Check for other mirrors in the four possible directions
		var mirror_nbr = instance_place_list(x+8,y,o_wall_mirror,adj_mirrors,false);
		if mirror_nbr != 0 {
			for (var i = 0; i < mirror_nbr; i++) {
				with adj_mirrors[| i] {
					if brightness != 1 {
						scr_mirror_flash(self);
						brightness = 1;
					}
				}
			}
		}
		
		ds_list_clear(adj_mirrors);
		
		var mirror_nbr = instance_place_list(x-8,y,o_wall_mirror,adj_mirrors,false);
		if mirror_nbr != 0 {
			for (var i = 0; i < mirror_nbr; i++) {
				with adj_mirrors[| i] {
					if brightness != 1 {
						scr_mirror_flash(self);
						brightness = 1;
					}
				}
			}
		}
		
		ds_list_clear(adj_mirrors);
		
		var mirror_nbr = instance_place_list(x,y+8,o_wall_mirror,adj_mirrors,false);
		if mirror_nbr != 0 {
			for (var i = 0; i < mirror_nbr; i++) {
				with adj_mirrors[| i] {
					if brightness != 1 {
						scr_mirror_flash(self);
						brightness = 1;
					}
				}
			}
		}
		
		ds_list_clear(adj_mirrors);
		
		var mirror_nbr = instance_place_list(x,y-8,o_wall_mirror,adj_mirrors,false);
		if mirror_nbr != 0 {
			for (var i = 0; i < mirror_nbr; i++) {
				with adj_mirrors[| i] {
					if brightness != 1 {
						scr_mirror_flash(self);
						brightness = 1;
					}
				}
			}
		}
		
		ds_list_clear(adj_mirrors);
		
		// Check for diagonal mirrors in the four possible directions
		var mirror_nbr = instance_place_list(x+8,y,o_mirror_diag,adj_mirrors,false);
		if mirror_nbr != 0 {
			for (var i = 0; i < mirror_nbr; i++) {
				with adj_mirrors[| i] {
					if brightness != 1 {
						scr_mirror_flash(self);
						brightness = 1;
					}
				}
			}
		}
		
		ds_list_clear(adj_mirrors);
		
		var mirror_nbr = instance_place_list(x-8,y,o_mirror_diag,adj_mirrors,false);
		if mirror_nbr != 0 {
			for (var i = 0; i < mirror_nbr; i++) {
				with adj_mirrors[| i] {
					if brightness != 1 {
						scr_mirror_flash(self);
						brightness = 1;
					}
				}
			}
		}
		
		ds_list_clear(adj_mirrors);
		
		var mirror_nbr = instance_place_list(x,y+8,o_mirror_diag,adj_mirrors,false);
		if mirror_nbr != 0 {
			for (var i = 0; i < mirror_nbr; i++) {
				with adj_mirrors[| i] {
					if brightness != 1 {
						scr_mirror_flash(self);
						brightness = 1;
					}
				}
			}
		}
		
		ds_list_clear(adj_mirrors);
		
		var mirror_nbr = instance_place_list(x,y-8,o_mirror_diag,adj_mirrors,false);
		if mirror_nbr != 0 {
			for (var i = 0; i < mirror_nbr; i++) {
				with adj_mirrors[| i] {
					if brightness != 1 {
						scr_mirror_flash(self);
						brightness = 1;
					}
				}
			}
		}
		
		ds_list_destroy(adj_mirrors);
		
	}
}