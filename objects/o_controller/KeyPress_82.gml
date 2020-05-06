/// @description Restart Room
if instance_exists(o_photon) with o_photon {
	scr_photon_vaporize(x,y,false,noone,true);
	audio_play_sound(choose(a_AHHHH,a_death_1,a_death_2,a_death_3,a_death_4,a_death_5),10,false);
	audio_play_sound(a_death_explosion,8,false);
	//instance_create_layer(x, y, "particles", o_photon_burst_flash);
	global.create_photon_flash = true;
	global.photon_death_info = [x, y, sprite_index, image_index, image_xscale, image_yscale];
}
scr_add_screenshake(2,6);
scr_transition(room,0);
global.respawn_photon = true;