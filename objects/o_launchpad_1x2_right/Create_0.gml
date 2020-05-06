/// @description Init
x_origin = x;
hspd = 0;
hspd_current = 0;
trigger_timer_max = 5;
trigger_timer = 0;
launch_speed = 4;
launch_height = 16;
retract_timer_max = 10;
retract_timer = 0;
state = DOWN;

manual = false;
colour = RED;

// Create a regular wall on top of the launchpad
base_wall = instance_create_layer(x,y,"walls",o_wall);
base_wall.image_xscale = sprite_width*image_xscale/8;
base_wall.image_yscale = sprite_height*image_yscale/8;