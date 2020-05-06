/// @description scr_photon_vaporize(sprite_index, image_index);
/// @param sprite_index
/// @param image_index

pix_surf = surface_create(8,8);
surface_set_target(pix_surf);
draw_clear_alpha(c_white, 0);
// Draw photon onto the surface
draw_sprite_ext(argument0,argument1,3,4,1,1,0,c_white,1);
surface_reset_target();

map[0] = 0;

// Createpbits on the sprite
for (var j = 0; j < 8; j++) {
	for (var i = 0; i < 8; i++) {
		var p_col = surface_getpixel_ext(pix_surf,i,j);
		var p_alpha = (p_col>>24)&&255;
		map[i+8*j] = p_alpha == 1 ? 1 : 0;
	}
}

surface_free(pix_surf);