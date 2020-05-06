/// @description Draw text on the title screen
// Set up text
draw_set_font(global.f_neural);
draw_set_halign(fa_middle);
draw_set_valign(fa_center);
draw_set_colour(c_white)

start_timer++;
if start_timer == start_timer_max start_timer = 0;

if mode == 0 {
	// First Screen
	// Set the surface
	surface_set_target(o_controller.surf_preblur);

	// Draw the title
	draw_sprite(s_title_demo,0,0,26);

	// Draw flashing text
	if start_timer <= start_timer_max*0.6 draw_text(VIEW_WIDTH/2,round(VIEW_HEIGHT*0.6),"(press z)");
	
	// Reset surface
	surface_reset_target();
} else if mode == 1 {
	// Option selection screen
	// Set the surface
	surface_set_target(o_controller.surf_preblur);

	// Draw the title
	draw_sprite(s_title_demo,0,0,16);

	// Timer for blinking
	if z_pressed {
		blink_timer++;
		if blink_timer mod 4 == 0 blink = !blink;
	}
	
	// Draw text
	draw_set_halign(fa_left);
	if selection == 0 draw_set_colour(c_white) else draw_set_colour(c_gray);
	if blink || selection != 0 draw_text(VIEW_WIDTH/2-12,round(VIEW_HEIGHT*0.5),"New Game");
	if selection == 1 draw_set_colour(c_white) else draw_set_colour(c_gray);
	if blink || selection != 1 draw_text(VIEW_WIDTH/2-12,round(VIEW_HEIGHT*0.6),"Continue");
	if selection == 2 draw_set_colour(c_white) else draw_set_colour(c_gray);
	if blink || selection != 2 draw_text(VIEW_WIDTH/2-12,round(VIEW_HEIGHT*0.7),"Exit");
	draw_set_colour(c_white);
	
	// Draw arrow
	if start_timer <= start_timer_max*0.6 || z_pressed draw_sprite(s_selection_arrow,0,VIEW_WIDTH/2-20,round(VIEW_HEIGHT*(0.5+0.1*selection)));
	
	// Reset surface
	surface_reset_target();
}