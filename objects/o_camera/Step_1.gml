/// @description Control the camera
if room == r_a1_village ylerp = 0.15;

if instance_exists(follow) && !freeze {
	
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
			y_ext = approach(y_ext,1,ydir*look_ahead_y);
		} else {
			// Look higher if no horizontal direction is being held
			y_ext = lerp(y_ext,ydir*look_up_y,look_ahead_y_lerp);
			y_ext = approach(y_ext,1,ydir*look_up_y);
		}
	} else {
		y_ext = lerp(y_ext,0,look_ahead_y_lerp);
		y_ext = approach(y_ext,1,0);
	}
	
	// Case where follow is NOT noone
	if (follow != noone) {
		xTo = follow.x+x_ext;
		yTo = follow.y+y_ext-hud_height/2+y_offset;
	}
	
}

// Set the camera position
var lerp_lim_x = 0.5;
var lerp_lim_y = 0.2;
if abs(lerp(x,xTo,xlerp)-x) > lerp_lim_x x = lerp(x,xTo,xlerp) else x = approach(x,lerp_lim_x,xTo);
if abs(lerp(y,yTo,ylerp)-y) > lerp_lim_y y = lerp(y,yTo,ylerp) else y = approach(y,lerp_lim_y,yTo);

// Screenshake
sc_x = random_range(-screenshake,screenshake);
sc_y = random_range(-screenshake,screenshake);

// Clamp the view
x = clamp(x,wview/2,room_width-(wview/2));
y = clamp(y+sc_y,hview/2-hud_height,room_height-(hview/2));

// Set camera position
var cx = clamp(x+sc_x,wview/2,room_width-(wview/2));
var cy = clamp(y+sc_y,hview/2-hud_height,room_height-(hview/2));
camera_set_view_pos(camera,cx-wview/2,cy-hview/2);

// Move the background
var fixed_layer = global.layer_bk_fixed;
var fixed_layer_sprite = layer_background_get_sprite(layer_background_get_id(fixed_layer));
layer_x(fixed_layer, x - sprite_get_width(fixed_layer_sprite)/2);
layer_y(fixed_layer, clamp(y, hview/2 - hud_height, room_height - hview/2) - sprite_get_height(fixed_layer_sprite)/2 + hud_height/2);

layer_x(global.layer_bk_parallax_close, x*0.4);
layer_y(global.layer_bk_parallax_close, y - hview/2 + hud_height);
layer_x(global.layer_bk_parallax_far, x*0.6);
layer_y(global.layer_bk_parallax_far, y - hview/2 + hud_height);

if global.bk_parallax_y layer_y(global.layer_bk_parallax_close, y*0.5);