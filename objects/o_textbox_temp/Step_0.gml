/// @description Insert description here
if !instance_exists(o_textbox) && keyboard_check_pressed(vk_down) {
	message[0] = "Test test test.#Test,";
	message[1] = "Test?";
	message[2] = 0;
	textbox_show(message);
	o_photon.canmove = false;
}