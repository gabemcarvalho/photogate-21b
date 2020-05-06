/// @description Draw the platform
surface_set_target(o_controller.surf_preblur);
draw_sprite(s_moving_platform_2x1,1,x,y);
//draw_text(o_camera.x,o_camera.y,x_equilib+pos_amp*sin(v_omega*osc_timer)); // Draws variable
surface_reset_target();
draw_sprite(s_moving_platform_2x1,0,x,y);