/// @description Thunder
if !thundering {
	if thunder_timer > 0 {
		thunder_timer--;
	} else {
		thundering = true;
		audio_play_sound(choose(a_thunder_1,a_thunder_2,a_thunder_3),8,false);
	}
} else {
	thunder_step++;
	switch thunder_step {
		case 1:
		layer_background_index(grid_id,1);
		break;
		case 3:
		layer_background_index(grid_id,0);
		break;
		case 5:
		layer_background_index(grid_id,1);
		break;
		case 10:
		layer_background_index(grid_id,0);
		break;
		case 13:
		layer_background_index(grid_id,1);
		break;
		case 17:
		layer_background_index(grid_id,0);
		thundering = false;
		thunder_step = 0;
		thunder_timer = thunder_timer_default+random_range(-200,400);
		break;
	}
}