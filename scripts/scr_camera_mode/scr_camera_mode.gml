/// @description scr_camera_mode(mode)
/// @param mode
var mode = argument0;
if instance_exists(o_camera) with o_camera {
	switch mode {
		case DIRECT:
			// Mode 0 - Follow Directly
			freeze = false;
			xlerp = 0.3;
			ylerp = 0.3;
			look_ahead_x = 0;
			look_ahead_x_lerp = 0.1;
			look_ahead_y = 0;
			look_ahead_y_lerp = 0.1;
		break;
		case NORMAL:
			// Mode 1 - Regular Movement
			freeze = false;
			xlerp = 0.3;
			ylerp = 0.2;
			look_ahead_x = 6;
			look_ahead_x_lerp = 0.05;
			look_ahead_y = 4;
			look_ahead_y_lerp = 0.2;
		break;
		case FAST:
			// Mode 2 = Fast Movement
			freeze = false;
			xlerp = 0.8;
			ylerp = 0.3;
			look_ahead_x = 10;//24
			look_ahead_x_lerp = 0.1;
			look_ahead_y = 4;
			look_ahead_y_lerp = 0.2;
		break;
		case FREEZE:
			freeze = true;
		break;
		case CRYSTAL:
			freeze = false;
			xlerp = 0.1;
			ylerp = 0.2;
			look_ahead_x = 6;//20
			look_ahead_x_lerp = 0.1;
			look_ahead_y = 12;
			look_ahead_y_lerp = 0.1;
		break;
	}
}