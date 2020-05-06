/// @description scr_mirror_particles(object_id, direction)
/// @param object_id
/// @param direction
var object_id = argument0;
var part_dir = argument1;

with object_id {
	if part_dir == RIGHT {
		var xpos = 8*image_xscale;
		for (var i = 0; i < 8*image_yscale; i++) {
			if round(random(10))==1 {
				part_particles_create(global.p_sys,x+xpos-1,y+i,global.p_white_pixel_2r,1);
			}
		}
		
	} else {
		var xpos = 0;
		for (var i = 0; i < 8*image_yscale; i++) {
			if round(random(10))==1 {
				part_particles_create(global.p_sys,x+xpos,y+i,global.p_white_pixel_2l,1);
			}
		}
	}
	
	
}