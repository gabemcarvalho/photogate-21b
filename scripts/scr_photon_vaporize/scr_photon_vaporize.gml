/// @description scr_photon_vaporize(xtarget, ytarget, absorb, crystal_id, explode);
/// @param xtarget
/// @param ytarget
/// @param absorb
/// @param crystal_id
/// @param explode

var xt = argument0;
var yt = argument1;
var absorb = argument2;
var crysal_id = argument3;
var explode = argument4;

vap_surf = surface_create(8,8);
surface_set_target(vap_surf);
draw_clear_alpha(c_white, 0);
// Draw photon onto the surface
draw_sprite_ext(sprite_index,image_index,3,4,image_xscale,image_yscale,0,c_white,1);
surface_reset_target();

// Create the pbit controller
instance_create_layer(xt,yt,"Player",o_pbit_controller);
o_pbit_controller.dir = dir;
if absorb {
	o_pbit_controller.light_crystal_absorb = true;
	o_pbit_controller.lc = crysal_id;
	scr_camera_mode(CRYSTAL);
}
o_camera.follow = o_pbit_controller;
if explode scr_camera_mode(DIRECT);

// Createpbits on the sprite
for (var j = 0; j < 8; j++) {
	for (var i = 0; i < 8; i++) {
		var p_col = surface_getpixel_ext(vap_surf,i,j);
		var p_alpha = (p_col>>24)&&255;
		if p_alpha == 1 {
			var newbit = instance_create_layer(x-3+i,y-4+j,"Player",o_pbit);
			if !absorb {
				newbit.xrel = -3+i;
				newbit.yrel = -4+j;
			}
			if explode {
				newbit.explode = true;
				var angle = random(2*pi);
				var spd = random(2) + 1;
				newbit.hspd = 0.8 * spd * sin(angle);
				newbit.vspd = -1 + spd * cos(angle);
				
				var newbit2 = instance_create_layer(x-3+i,y-4+j,"Player",o_pbit);
				newbit2.explode = true;
				angle = random(2*pi);
				spd = random(2) + 1;
				newbit2.hspd = 0.8 * spd * sin(angle);
				newbit2.vspd = -1 + spd * cos(angle);
				
				var newbit3 = instance_create_layer(x-3+i,y-4+j,"Player",o_pbit);
				newbit3.explode = true;
				angle = random(2*pi);
				spd = random(2) + 1;
				newbit3.hspd = 0.8 * spd * sin(angle);
				newbit3.vspd = -1 + spd * cos(angle);
			}
		}
	}
}

surface_free(vap_surf);
instance_destroy();