surface_set_target(o_controller.surf_light);
gpu_set_blendmode(bm_add);
draw_self();
gpu_set_blendmode(bm_normal);
surface_reset_target();