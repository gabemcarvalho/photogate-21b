/// @description CRT Shader

#region PIXEL MANIPULATION
// Pixel Manipulation Layer
surface_set_target(surf_pixel_manipulation);
draw_clear_alpha(c_black,0);
if shockwave_on {
	shader_set(sh_shockwave2);
		shader_set_uniform_f(uni_shock_time, shockwave_time);
		var sx = (VIEW_WIDTH/2+shockwave_x-o_camera.x)*2;
		var sy = (VIEW_HEIGHT/2+shockwave_y-o_camera.y)*2;
		shader_set_uniform_f(uni_shock_pos,sx,sy);
		shader_set_uniform_f(uni_shock_resolution,288,162);
		shader_set_uniform_f(uni_shock_amp,0.2*shockwave_direction);
		shader_set_uniform_f(uni_shock_refraction,1.0/shockwave_distance);
		shader_set_uniform_f(uni_shock_width,0.1); // does nothing
	
		draw_surface_part_ext(application_surface, 0, 0, view_wport[0], view_hport[0], 0, 0, 1, 1, c_white, 1);
	shader_reset();
} else {
	draw_surface_part_ext(application_surface, 0, 0, view_wport[0], view_hport[0], 0, 0, 1, 1, c_white, 1);
}
surface_reset_target();
#endregion

#region HUD
// Draw transitions
surface_set_target(surf_pixel_manipulation);
draw_surface_stretched(surf_trans,0,0,288,162);
surface_reset_target();
surface_set_target(surf_trans);
draw_clear_alpha(c_white, 0);
surface_reset_target();

// Draw the HUD
var hud_height = 9;
surface_set_target(surf_pixel_manipulation);
draw_surface_stretched(surf_hud,0,0,288,18);//288,18
surface_reset_target();
surface_set_target(surf_hud);
draw_clear_alpha(c_white, 0);
surface_reset_target();

// Draw cutscene bar
surface_set_target(surf_pixel_manipulation);
draw_surface_stretched(surf_bar,0,162-2*cs_bar_height,288,2*cs_bar_height);
surface_reset_target();
#endregion

#region COLOUR SHADERS
// Colour effect layer
surface_set_target(surf_shader);
draw_clear_alpha(c_black,0);
shader_set(sh_master);
	/*
	Shader settings:
		Normal: 0.0, 0.0, 1.05, 0.10, 0.03
		Trippy: 0.0, 0.1, 1.0, 3.0,  0.2
		Deepfry (w/ bloom): 1.0, -0.15, 2.0, 0.3, 0.2 (good for optimal gold)
	*/
	shader_set_uniform_f(uni_master_aberration,aberration_amount);
	shader_set_uniform_f(uni_master_brightness,0.0);
	shader_set_uniform_f(uni_master_contrast,1.05);
	shader_set_uniform_f(uni_master_saturation,0.10);
	shader_set_uniform_f(uni_master_noise,0.025);
	shader_set_uniform_f(uni_master_gold,screen_gold);
	shader_set_uniform_f(uni_master_random_factor,random_range(0.9,1.1));
	draw_surface(surf_pixel_manipulation,0,0);
shader_reset();
surface_reset_target();
#endregion

#region CRT SHADER
// Apply CRT effect
if draw_crt {
	shader_set(shader_to_use);
	  shader_set_uniform_f(uni_crt_sizes, surface_width, surface_height,crt_surface_width, crt_surface_height);
	  shader_set_uniform_f(distort, var_distort);
	  shader_set_uniform_f(distortion, var_distortion_ammount);
	  shader_set_uniform_f(border, var_border);
	  draw_surface(surf_shader,0,0)
	shader_reset();
} else {
	draw_surface(surf_shader,0,0);
}
#endregion