/// @description Start a Door
if global.door_transition {
	if instance_exists(o_door) with o_door {
		if other_room == o_controller.last_room {
			if vertical {
				other.x = x-o_controller.door_x;
				other.y = y-8*o_controller.spawn_side;
				if o_controller.spawn_side == 1 {
					if other.vspd > -4 {other.vspd = -4};
				} else {
					other.vspd = 1;
				}
			} else {
				other.x = x+o_controller.spawn_side*6;
				other.y = (y+8*image_yscale)-o_controller.ground_y;
				other.dir = o_controller.spawn_side;
				other.vspd = o_controller.door_vspd;
			}
		}
	}
	
	boosting = o_controller.door_boost;
	hspd = o_controller.door_hspd;

	with o_camera {
		// Set initial position
		x_ext = 0;
		x = follow.x+x_ext;
		y = follow.y-hud_height/2+y_offset;
		x = clamp(x,VIEW_WIDTH/2,room_width-(VIEW_WIDTH/2));
		y = clamp(y,VIEW_HEIGHT/2,room_height-(VIEW_HEIGHT/2));

		xTo = x;
		yTo = y;
		
		// Set camera position
		var view_matrix = matrix_build_lookat(x,y,-10,x,y,0,0,1,0);
		camera_set_view_mat(camera,view_matrix);
	}
	
	global.door_transition = false;

}