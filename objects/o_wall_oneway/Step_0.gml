/// @description Control the Platform
if instance_exists(o_photon) {
	if o_photon.y > y-4 || o_photon.vspd < 0 sprite_index = s_nothing else sprite_index = s_wall_oneway;
}
if keyboard_check_pressed(vk_down) {
	sprite_index = s_nothing;
	cooldown = 2;
}
if cooldown > 0 {
	sprite_index = s_nothing;
	cooldown--;
}