crystal_list = ds_list_create();
var col_blue = make_colour_rgb(149, 75, 255);
var col_dark_blue = make_colour_rgb(104, 52, 178);
var col_darker_blue = make_colour_rgb(59, 30, 102);

random_set_seed( room );

// value 0.8 layer
var value = 0.8;
var pos = random_range(-100, 0);
while (pos < room_width) {
	var c = instance_create_layer(0, 0, "walls", o_bk_crystal);
	c.sprite_index = s_bk_crystal_farther;
	c.x_init = pos;
	c.y_init = random_range(12, 20);
	c.parallax_value = value;
	c.side_parallax = 0.05;
	c.colour = col_darker_blue;
	ds_list_add(crystal_list, c);
	pos += sprite_get_width(c.sprite_index) + random_range(-10, 5);
}

// value 0.7 layer
value = 0.7;
pos = random_range(-100, 0);
while (pos < room_width) {
	var c = instance_create_layer(0, 0, "walls", o_bk_crystal);
	c.sprite_index = s_bk_crystal_far;
	c.x_init = pos;
	c.y_init = random_range(20, 28);
	c.parallax_value = value;
	c.side_parallax = 0.06;
	c.colour = col_dark_blue;
	ds_list_add(crystal_list, c);
	pos += sprite_get_width(c.sprite_index) + random_range(-5, 10);
}


// value 0.5 layer
value = 0.5;
pos = random_range(-100, 0);
while (pos < room_width) {
	c = instance_create_layer(0, 0, "walls", o_bk_crystal);
	c.sprite_index = choose(s_bk_crystal, s_bk_crystal_farther);
	c.x_init = pos;
	c.y_init = random_range(28, 36);
	c.parallax_value = value;
	c.side_parallax = 0.1;
	c.colour = col_blue;
	ds_list_add(crystal_list, c);
	pos += sprite_get_width(c.sprite_index) + random_range(-10, 5);
}