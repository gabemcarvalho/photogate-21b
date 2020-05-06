/// @description Draw moving platforms
var hplatform_exists = instance_exists(o_moving_platform_horizontal);
var vplatform_exists = instance_exists(o_moving_platform_vertical);

if hplatform_exists || vplatform_exists {
	surface_set_target(o_controller.surf_preblur);
		if hplatform_exists  { with o_moving_platform_horizontal {
			draw_sprite(sprite_index,1,x,y);
		} }
		if vplatform_exists  { with o_moving_platform_vertical {
			draw_sprite(sprite_index,1,x,y);
		} }
	surface_reset_target();
	
	surface_set_target(o_controller.surf_block)
		if hplatform_exists  { with o_moving_platform_horizontal {
			draw_sprite(sprite_index,0,x,y);
		} }
		if vplatform_exists  { with o_moving_platform_vertical {
			draw_sprite(sprite_index,0,x,y);
		} }
	surface_reset_target();
}
