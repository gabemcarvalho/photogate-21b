/// @description Control the title screen
if !z_pressed && mode == 1 {
	if keyboard_check_pressed(vk_down) {
		start_timer = 0;
		selection++;
		if selection > 2 {
			selection = 2;
		}
	}
	if keyboard_check_pressed(vk_up) {
		start_timer = 0;
		selection--;
		if selection < 0 {
			selection = 0;
		}
	}
}

if keyboard_check_pressed(ord("Z")) && !z_pressed {
	start_timer = 0;
	
	if mode == 0 {
		mode = 1;
	} else if mode == 1 {
		if selection == 0 {
			scr_transition(r_world_map,0);
			z_pressed = true;
		} else if selection == 1 {
			scr_transition(global.continue_room,0);
			global.respawn_photon = true;
			o_controller.last_room = r_init_controller;
			z_pressed = true;
		} else if selection == 2 {
			game_end();
		}
	}
}