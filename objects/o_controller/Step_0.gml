/// @description Control the game audio
if game_loading {
	if audio_group_is_loaded(global.bgm_audiogroup) {
		// Audiogroup is loaded, play the sounds
		vgm1_group = audio_create_sync_group(true);
		audio_play_in_sync_group(vgm1_group, vgm1_arp_chain);
		audio_sound_gain(vgm1_arp_chain,0,0);
		audio_play_in_sync_group(vgm1_group, vgm1_bass);
		audio_sound_gain(vgm1_bass,0,0);
		audio_play_in_sync_group(vgm1_group, vgm1_bass_chain);
		audio_sound_gain(vgm1_bass_chain,0,0);
		audio_play_in_sync_group(vgm1_group, vgm1_bass_pluck);
		audio_sound_gain(vgm1_bass_pluck,0,0);
		audio_play_in_sync_group(vgm1_group, vgm1_chord_chip);
		audio_sound_gain(vgm1_chord_chip,0,0);
		audio_play_in_sync_group(vgm1_group, vgm1_chord_chip_chain);
		audio_sound_gain(vgm1_chord_chip_chain,0,0);
		audio_play_in_sync_group(vgm1_group, vgm1_drums);
		audio_sound_gain(vgm1_drums,0,0);
		audio_play_in_sync_group(vgm1_group, vgm1_sub);
		audio_sound_gain(vgm1_sub,0,0);
		audio_play_in_sync_group(vgm1_group, vgm1_sub_chain);
		audio_sound_gain(vgm1_sub_chain,0,0);
		audio_play_in_sync_group(vgm1_group, vgm1_chord_decay_chain);
		audio_sound_gain(vgm1_chord_decay_chain,0,0);
		audio_play_in_sync_group(vgm1_group, vgm1_lead_chain);
		audio_sound_gain(vgm1_lead_chain,0,0);
		audio_play_in_sync_group(vgm1_group, vgm1_chord_full_chain);
		audio_sound_gain(vgm1_chord_full_chain,0,0);
		audio_play_in_sync_group(vgm1_group, vgm1_drone);
		audio_sound_gain(vgm1_drone,0,0);
		
		audio_start_sync_group(vgm1_group);
		
		//if !audio_is_playing(vgm1_chord_chip) game_end();
		
		game_loading = false;
		scr_transition(r_title,4);
	}
}

// Screen distortion
if var_distortion_ammount != distort_ammount_default {
	var_distortion_ammount = approach(var_distortion_ammount,0.005,distort_ammount_default);
}

// Light intensity randomness
light_tile_alpha = max(0.8,min(0.9 + 0.1*sin(2*pi/light_tile_period*light_tile_timer) + random_range(-0.02,0.02)));
light_tile_timer++;
if light_tile_timer>light_tile_period light_tile_timer=0;

// VFX Controls
if keyboard_check_pressed(ord("G")) screen_gold = !screen_gold;

// Shockwave
if shockwave_on {
	if shockwave_time < 1.5 {
		shockwave_time += 0.05 * shockwave_speed;
	} else {
		shockwave_time = 0;
		shockwave_on = false;
	}
}

// Aberration
aberration_amount = approach(aberration_amount, 0.3, 0.0);

// Debug overlay
if keyboard_check_pressed(vk_f8) {
	debug_overlay_enabled = !debug_overlay_enabled;
	show_debug_overlay(debug_overlay_enabled);
}
