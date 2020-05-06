/// @description Increment Step
if type = 3 {
	in_new_room = true;
	trans_step = 11;
	type = 2;
	//room_goto(next_room);
}

if type = 4 {
	in_new_room = true;
	trans_step = 36;
	type = 0;
	room_goto(next_room);
}

if type == 0 or type == 2 {
	var t_spd = 1;
} else {
	var t_spd = 2;
}

if !in_new_room {
	if type == 0 or type == 1 {
		if trans_step > h_tiles+v_tiles+8 {
			// Go to the new room
			in_new_room = true;
			room_goto(next_room);
		} else {
			trans_step+=t_spd;
		}
	} else {
		if trans_step > 11 {
			// Go to the new room
			in_new_room = true;
			room_goto(next_room);
		} else {
			trans_step+=t_spd;
		}
	}
} else {
	// In new room
	if trans_step > 0 {
		trans_step-=t_spd;
	} else {
		instance_destroy();
	}
}