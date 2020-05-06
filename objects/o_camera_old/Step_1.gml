/// @description Control the camera
if keyboard_check(ord("W")) wview -= 4;
if keyboard_check(ord("S")) wview += 4;
wview = min(max(wview,96),144);
hview = wview*9/16;

if room == r_a1_village ylerp = 0.15;

if instance_exists(follow) && !freeze {
	
	x = lerp(x,xTo,xlerp);
	y = lerp(y,yTo,ylerp);
	
	// Look ahead in the x direction
	if xdir != 0 {
		x_ext = lerp(x_ext,xdir*look_ahead_x,look_ahead_x_lerp);
		x_ext = approach(x_ext,0.5,xdir*look_ahead_x);
	} else {
		x_ext = lerp(x_ext,0,look_ahead_x_lerp);
		x_ext = approach(x_ext,0.5,0);
	}
	// Look ahead in the y direction
	if ydir != 0 {
		if xdir != 0 {
			y_ext = lerp(y_ext,ydir*look_ahead_y,look_ahead_y_lerp);
			y_ext = approach(y_ext,0.5,ydir*look_ahead_y);
		} else {
			// Look higher if no horizontal direction is being held
			y_ext = lerp(y_ext,ydir*look_up_y,look_ahead_y_lerp);
			y_ext = approach(y_ext,0.5,ydir*look_up_y);
		}
	} else {
		y_ext = lerp(y_ext,0,look_ahead_y_lerp);
		y_ext = approach(y_ext,0.5,0);
	}
	
	// Case where follow is NOT noone
	if (follow != noone) {
		xTo = follow.x+x_ext;
		yTo = follow.y+y_ext-hud_height/2+y_offset;
	}
	
	xTo = clamp(xTo,wview/2,room_width-(wview/2));
	yTo = clamp(yTo,hview/2-hud_height,room_height-(hview/2));

}

// Screenshake
sc_x = random_range(-screenshake,screenshake);
sc_y = random_range(-screenshake,screenshake);

// Clamp the view
var vx = clamp(x+sc_x,wview/2,room_width-(wview/2));
var vy = clamp(y+sc_y,hview/2-hud_height,room_height-(hview/2));

// Set camera position
view_matrix = matrix_build_lookat(vx,vy,-10,vx,vy,0,0,1,0);
projection_matrix = matrix_build_projection_ortho(wview,hview,1.0,10000.0);


//camera_set_view_mat(camera,view_matrix);
//camera_set_proj_mat(camera,projection_matrix);
camera_set_view_pos(camera,vx-wview/2,vy-hview/2); ///////////// WHY DOES THIS WORK??

// Change the speed of the parallax background
layer_x("bk_crystals_back",x*0.5);
if !instance_exists(o_bk_thunder) layer_y("bk_crystals_back",y*0.5);
layer_x("bk_grid",x-(sprite_get_width(bk_fluxia_large)/2));
//layer_y("bk_grid",y-(sprite_get_height(bk_fluxia_large)/2));
layer_y("bk_grid",clamp(y,hview/2-hud_height,room_height-(hview/2))-sprite_get_height(bk_fluxia_large)/2+hud_height/2);