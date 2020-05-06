/// @description Draw Room Name
tx = o_camera.x;
ty = o_camera.y;
var y_offset = -30;
surf_x = tx-title_width/2-3;
surf_y = ty-5+y_offset;

surf_x = tx+VIEW_WIDTH/2-title_width-5;
surf_y = ty+VIEW_HEIGHT/2-13;

if step == 0 {
	// Create the title surface
	surf_title = surface_create(title_width+6,10);
	surface_set_target(surf_title);
	
	draw_clear_alpha(c_white,0);
	draw_set_font(f_thinpixel7);
	draw_set_halign(fa_middle);
	draw_set_valign(fa_center);
	//draw_set_colour(make_colour_rgb(150,170,255));
	draw_set_colour(make_colour_rgb(120,140,220));
	draw_text(title_width/2+3+1,5+1,title);
	draw_text(title_width/2+3+1,5,title);
	draw_text(title_width/2+3,5+1,title);
	draw_set_colour(c_white);
	draw_text(title_width/2+3,5,title);

	surface_reset_target();
}

var step_eff = step-1.5*room_speed;

// Turn pixels into particles
if step_eff >= 0 {
	surface_set_target(surf_title);
	gpu_set_blendmode(bm_subtract);
	
	// Dissolve Horizontally
	
	for (var i = max(0,step_eff-step_spd); i <= min(step_eff,title_width+5); i++) {
		//var j = step_eff;
		for (var j = 0; j <= 9; j++) {
			var p_col = surface_getpixel_ext(surf_title,i,j);
			var p_alpha = (p_col>>24)&&255;
			if p_alpha == 1 {
				draw_point_colour(i,j,c_white);
				part_particles_create(global.p_sys,i+surf_x,j+surf_y,global.p_white_pixel_4,1);
			}
		}
	}
	// Dissolve Vertically
	/*
	for (var i = 0; i <= title_width+5; i++) {
		var j = step_eff;
		if surface_getpixel(surf_title,i,j) != 0 {
			draw_point_colour(i,j,c_white);
			part_particles_create(global.p_sys,i+surf_x,j+surf_y,global.p_white_pixel_4,1);
		}
	}
	*/
	gpu_set_blendmode(bm_normal);
	surface_reset_target();
}




// Draw the surface
surface_set_target(o_controller.surf_gui);
draw_surface(surf_title,surf_x,surf_y);
surface_reset_target();

step += step_spd;

if step_eff > title_width+6+10 {
	// Destroy the title object
	surface_free(surf_title);
	instance_destroy();
}
