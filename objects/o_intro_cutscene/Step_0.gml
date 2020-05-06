/// @description Control the Cutscene
step++;

if step > 40 && step mod 4 == 0 && step < 94 {
	var text_step = (step - 40) div 4;
	if map_label != "Fluxia_" {
		text_step = min(text_step,6)
		map_label = string_copy("Fluxia",1,text_step)+"_";
	} else {
		map_label = "Fluxia";
	}
}
if step > 130 && step mod 4 == 0 && step < 190 {
	if map_label != "" {
		map_label = string_copy(map_label,1,string_length(map_label)-1);
	}
}

if step == 90 || step == 125 || step == 200 scr_add_screenshake(1,12);

if step == 110 || step == 230 || step == 560 thundering = true;

if step > 140 && step < 260 {
	map_y += 0.25;
}
if step == 250 {
	scr_transition(r_ceiling,2);
}


if step > 340 && step < 707 {
	scr_add_screenshake(1,1);
}
if step > 360 && step <= 440 {
	ceil_step = (step - 360)/4;
} else if step == 480 {
	var cs_photon = instance_create_layer(74,30,"Player",o_photon);
	cs_photon.canmove = false;
	cs_photon.grav = 0;
	cs_photon.boosting = true;
	cs_photon.vspd = 8;
	cs_photon.sprite_index = char_plumeting;
} else if step == 500 {
	scr_transition(r_world_map,2);
	o_controller.blur_on = false;
	map_label = "";
	line_length = 5;
	map_y = 35;
}

if step > 510 {
	line_length += 0.15;
	if step > 530 {
		map_y -= 0.15;
		line_length -= 0.05;
	}
	
	if step == 600 {
		scr_transition(r_a1_fall,2);
	}
}

if step == 608 o_controller.blur_on = true;

if step > 610  && step < 700 && instance_exists(o_photon) {
	with o_photon {
		repeat(5) part_particles_create(global.p_sys,x+random_range(-72,72),y+random_range(-40,40),global.p_white_pixel_3,1);
	}
}
if step == 707 {
	o_controller.white_flash = 1;
	instance_destroy(o_photon);
	room_goto(r_a1_altar);
}
if step > 707 && step < 710 o_controller.white_flash = 1;

if step == 805 {
	dots = 1;
} else if step == 820 {
	dots = 2;
} else if step == 835 {
	dots = 3;
} else if step == 865 {
	dots = 4;
	o_photon.sprite_index = char_jump;
	o_photon.y -= 3;
} else if step == 869 {
	o_photon.sprite_index = char_fall;
} else if step == 873 {
	o_photon.sprite_index = char_jump;
} else if step == 877 {
	o_photon.sprite_index = char_fall;
} else if step == 890 {
	dots = 0;
	o_photon.canmove = true;
	o_photon.grav = 0.5;
	scr_track_gain(vgm1_drone,1,1000);
	
}

if step >= 890 && step < 926 o_controller.cs_bar_height -= 0.25;

if step == 708 {
	o_camera.hud_height = 8;
}

if step > 930 && step < 960 {
	var text_step = (step - 930) div 2;
	if global.r_name != "00 - Altar" {
		global.r_name = string_copy("00 - Altar",1,text_step);
	}
}

if step < 890 scr_camera_mode(DIRECT);

if step == 1000 instance_destroy();