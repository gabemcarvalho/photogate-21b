/// @description Determine Colour Signals
global.red_active = false;
global.blue_active = false;
global.purple_active = false;

with o_button_floor {
	if pressed {
		if colour == RED {
			global.red_active = true;
		} else if colour == BLUE {
			global.blue_active = true;
		} else if colour == PURPLE {
			global.purple_active = true;
		}
	}
}