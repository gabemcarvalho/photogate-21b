/// @description Draw the transition
if type == 0 or type == 2 {
	var in_sprite = s_transition;
	var out_sprite = s_transition;
} else {
	var in_sprite = s_transition_fast_1;
	var out_sprite = s_transition_fast_2;
}

// Scroll across screen horizontally and vertically
surface_set_target(o_controller.surf_trans);
for (var i = 0; i < h_tiles; i++) {
	for (var j = 0; j < v_tiles; j++) {
		var trans_sprite_index = trans_step - i - j;
		if type == 0 or type == 2 {
			trans_sprite_index = max(min(trans_sprite_index,8),0);
		} else {
			trans_sprite_index = max(min(trans_sprite_index,2),0);
		}
		if type == 0 or type == 1 {
			if !in_new_room {
				draw_sprite(in_sprite,trans_sprite_index,8*i,8*j);
			} else {
				draw_sprite(out_sprite,trans_sprite_index,8*(h_tiles-i-1),8*(v_tiles-j-1));
			}
		} else {
			draw_sprite(in_sprite,min(trans_step,8),8*i,8*j);
		}
	}
}

surface_reset_target();
