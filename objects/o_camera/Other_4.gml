/// @description Initialize the camera
// DON'T MAKE ANY NEW CAMERAS, THE OBJECT IS PERSISTENT NOW
// Enable the use of views
view_enabled = true;
view_set_visible(0, true);

// Set the view dimensions
wview = VIEW_WIDTH;
hview = VIEW_HEIGHT;

// Set the height of the HUD
hud_height = 8;
if room == r_title || room == r_world_map || room == r_ceiling || room == r_a1_fall hud_height = 0;

// Offset the camera from the centre of the screen due to the HUD
if !global.camera_y_offset {
	y_offset = -3;
} else {
	y_offset = -8.5;
}

// Check for a Photon to follow
if instance_exists(o_photon) follow = o_photon else follow = noone;
if follow != noone and instance_exists(follow) {
	fx = follow.x;
	fy = follow.y;
} else {
	fx = 0;
	fy = 0;
}

// Set lookahead variables
x_ext = 0;
y_ext = 0;
xlerp = 0.3;
ylerp = 0.2;
look_ahead_x = 4;
look_ahead_x_lerp = 0.05;
look_ahead_y = 4;
look_up_y = 12;
look_ahead_y_lerp = 0.2;
xdir = 0;
ydir = 0;
freeze = false;

// Screenshake Variables
screenshake = 0;
sc_x = 0;
sc_y = 0;

// Set initial position
x = fx;
y = fy-hud_height/2+y_offset;
x = clamp(x,wview/2,room_width-(wview/2));
y = clamp(y,hview/2+y_offset,room_height-(hview/2));
xTo = x;
yTo = y;

// Set up the camera
camera = camera_create();
view_set_camera(0,camera);
camera_set_view_size(camera,VIEW_WIDTH,VIEW_HEIGHT);