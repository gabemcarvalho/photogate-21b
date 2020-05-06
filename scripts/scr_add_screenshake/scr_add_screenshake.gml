/// @description scr_add_screenshake(amount, duration)
/// @param amount
/// @param duration
if instance_exists(o_camera) {
	o_camera.screenshake = argument0;
	o_camera.alarm[0] = argument1;
}