/// @description Create Emitter
floor_emitter = part_emitter_create(global.p_sys);
part_emitter_region(global.p_sys,floor_emitter,x,x+8*image_xscale,y+8*image_yscale,y+8*image_yscale,ps_shape_rectangle,ps_distr_linear);

part_chance = 200/image_xscale;