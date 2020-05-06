/// @description Init
colour = RED;

bar_height_max = sprite_width-16;
bar_height = bar_height_max;

active = false;

bar_wall = instance_create_layer(x+8,y+2,"walls",o_wall);
bar_wall.image_yscale = 0.5;
bar_wall.image_xscale = bar_height/8;

close_speed = 3;
dir = RIGHT;

/* NOTES:
- In the creation code, set the COLOUR and DIR
- Can be stretched in the room editor and the sprite will automatically adjust
