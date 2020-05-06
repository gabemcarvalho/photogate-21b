if !instance_exists(o_intro_cutscene) {
	global.r_name = "00 - Altar"
	scr_track_gain(vgm1_drone,1,1000);
}
global.room_number = 0
scr_track_gain(vgm1_chord_chip,0,1000);