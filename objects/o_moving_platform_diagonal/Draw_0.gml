/// @description Draw the platform
surface_set_target(o_controller.surf_preblur);
draw_sprite(sprite_index,1,x,y);
surface_reset_target();
draw_sprite(sprite_index,0,x,y);