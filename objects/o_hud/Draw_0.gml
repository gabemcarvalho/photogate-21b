/// @description Draw the HUD
if o_controller.draw_hud {
	surface_set_target(o_controller.surf_hud);

	draw_set_colour(c_black);
	draw_rectangle(0,0,VIEW_WIDTH,8,false);

	title = global.r_name;
	title_width = string_width(title);
	tx = VIEW_WIDTH/2;//3
	ty = 4;
	//draw_set_font(f_pixelmix);
	draw_set_font(global.f_neural);
	draw_set_halign(fa_middle);
	draw_set_valign(fa_center);

	draw_set_colour(global.col_amethyst_purple);
	//draw_text(tx+1,ty+1,title);
	draw_text(tx+1,ty,title);
	//draw_text(tx,ty+1,title);
	
	// HUD Line
	//draw_line(0,8,VIEW_WIDTH,8);

	//draw_line(-1,11,VIEW_WIDTH,11); // Line at bottom of HUD
	draw_set_colour(c_white);
	draw_text(tx,ty,title);

	surface_reset_target();
}