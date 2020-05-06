/// @description Draw The Gate
if colour == RED {
	var colour_image_offset = 1;
} else if colour == BLUE {
	var colour_image_offset = 2;
} else if colour == PURPLE {
	var colour_image_offset = 3;
}
// Draw the dark portion
surface_set_target(o_controller.surf_block);
	draw_sprite(s_gate_end_vertical,2*colour_image_offset - (active ? 0 : 1),x,y); // Top
	draw_sprite(s_gate_end_vertical,2*colour_image_offset - (active ? 0 : 1),x,y+8+bar_height_max); // Bottom
	// Bar
	if dir == UP {
		draw_sprite_ext(s_gate_bar_vertical, active ? 0 : 2*colour_image_offset,x+2,y+8,1,bar_height,0,c_white,1);
	} else {
		draw_sprite_ext(s_gate_bar_vertical, active ? 0 : 2*colour_image_offset,x+2,y+8+bar_height_max-bar_height,1,bar_height,0,c_white,1);
	}
surface_reset_target();

// Draw the light portion
surface_set_target(o_controller.surf_preblur);
if !active {
	// Inactive - coloured
	draw_sprite(s_gate_end_vertical,2*colour_image_offset-1,x,y); // Top
	draw_sprite(s_gate_end_vertical,2*colour_image_offset-1,x,y+8+bar_height_max); // Bottom
	// Bar
	if dir == UP {
		draw_sprite_ext(s_gate_bar_vertical,1+2*colour_image_offset,x+2,y+8,1,bar_height,0,c_white,1); // Bar
		if bar_height != 0 && bar_height != bar_height_max {
			draw_sprite_ext(s_button_colour_pixel,colour_image_offset,x+2,y+8+bar_height-1,4,1,0,c_white,1); // Bar end
		}
	} else {
		draw_sprite_ext(s_gate_bar_vertical,1+2*colour_image_offset,x+2,y+8+bar_height_max-bar_height,1,bar_height,0,c_white,1);
		if bar_height != 0 && bar_height != bar_height_max {
			draw_sprite_ext(s_button_colour_pixel,colour_image_offset,x+2,y+8+bar_height_max-bar_height,4,1,0,c_white,1); // Bar end
		}
	}
} else {
	// Active - green
	draw_sprite(s_gate_end_vertical,2*colour_image_offset,x,y); // Top
	draw_sprite(s_gate_end_vertical,2*colour_image_offset,x,y+8+bar_height_max); // Bottom
	// Bar
	if dir == UP {
		draw_sprite_ext(s_gate_bar_vertical,1,x+2,y+8,1,bar_height,0,c_white,1);
		if bar_height != 0 && bar_height != bar_height_max {
			draw_sprite_ext(s_button_colour_pixel,0,x+2,y+8+bar_height-1,4,1,0,c_white,1); // Bar end
		}
	} else {
		draw_sprite_ext(s_gate_bar_vertical,1,x+2,y+8+bar_height_max-bar_height,1,bar_height,0,c_white,1);
		if bar_height != 0 && bar_height != bar_height_max {
			draw_sprite_ext(s_button_colour_pixel,0,x+2,y+8+bar_height_max-bar_height,4,1,0,c_white,1); // Bar end
		}
	}
}

// Draw the bar wall
//draw_sprite_stretched(s_white_pixel,0,bar_wall.x,bar_wall.y,bar_wall.image_xscale*8,bar_wall.image_yscale*8);
surface_reset_target();