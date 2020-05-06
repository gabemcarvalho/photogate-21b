/// @description Draw a simple textbox
/*
if keyboard_check(vk_up) {
	surface_set_target(o_controller.surf_trans);
	
	draw_set_alpha(1.0);
	draw_sprite(s_textbox_test,0,0,VIEW_HEIGHT-17);
	draw_set_alpha(1.0);
	
	draw_set_font(global.f_neural);
	draw_set_halign(fa_left);
	draw_set_valign(fa_top);

	//draw_set_colour(global.col_amethyst_purple);
	//draw_text(4,3,"This is a test");
	//draw_text(4,9,"This is a test");
	//draw_text(4,15,"This is a test");
	
	draw_set_colour(c_white);
	draw_text(3,VIEW_HEIGHT-17+2,"Who... are you?");
	draw_text(3,VIEW_HEIGHT-17+9,"Where did you come from?");
	
	surface_reset_target();
}