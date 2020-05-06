/// @description Press the button
if place_meeting(x,y-1,o_photon) || place_meeting(x,y-1,o_box) {
	pressed = true;
	if colour == RED {
		global.red_active = true;
	} else if colour == BLUE {
		global.blue_active = true;
	} else if colour == PURPLE {
		global.purple_active = true;
	}
} else {
	pressed = false;
}