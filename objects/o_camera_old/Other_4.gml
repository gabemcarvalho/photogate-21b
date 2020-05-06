/// @description Initialize the camera
// DON'T MAKE ANY NEW CAMERAS, THE OBJECT IS PERSISTENT NOW
// Enable the use of views
view_enabled = true;
view_set_visible(0, true);

// Set the view
wview = VIEW_WIDTH;
hview = VIEW_HEIGHT;
hud_height = 8;

if room == r_title || room == r_world_map || room == r_ceiling || room == r_a1_fall hud_height = 0;

// Offset the camera from the centre of the screen due to the HUD
//y_offset = -3;//-8
//if room == r_a1_village y_offset = -8.5;
if !global.camera_y_offset {
	y_offset = -3;
} else {
	y_offset = -8.5;
}

// Follow the player
if instance_exists(o_photon) follow = o_photon else follow = noone;
if follow != noone and instance_exists(follow) {
	fx = follow.x;
	fy = follow.y;
} else {
	fx = 0;
	fy = 0;
}

x_ext = 0;
y_ext = 0;

// Set outer buffer
xlerp = 0.3;
ylerp = 0.2;
look_ahead_x = 4;//4
look_ahead_x_lerp = 0.05;//0.05
look_ahead_y = 4;
look_up_y = 12;
look_ahead_y_lerp = 0.2;
xdir = 0;
ydir = 0;
freeze = false;

// Set initial position
// Set initial position
x = fx+x_ext;
y = fy-hud_height/2+y_offset;
x = clamp(x,wview/2,room_width-(wview/2));
y = clamp(y,hview/2+y_offset,room_height-(hview/2));

xTo = x;
yTo = y;


x = 0;
y = 0;

// Set up the camera
camera = camera_create();
view_set_camera(0,camera);
//view_camera[0] = camera_create();

var view_matrix = matrix_build_lookat(x,y,-10,x,y,0,0,1,0);
var projection_matrix = matrix_build_projection_ortho(wview,hview,-10000,10000);

//camera_set_view_mat(camera,view_matrix);
//camera_set_proj_mat(camera,projection_matrix);
camera_set_view_size(camera,VIEW_WIDTH,VIEW_HEIGHT);


screenshake = 0;
sc_x = 0;
sc_y = 0;
