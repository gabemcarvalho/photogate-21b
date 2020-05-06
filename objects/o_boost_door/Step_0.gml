/// @description Destroy the door
if active {
	if death_timer < room_speed*0.3 {
		death_timer++;
	} else {
		// Destroy the door
		for (var i = 0; i < sprite_get_width(sprite_index); i+=2) {
			for (var j = 0; j < sprite_get_height(sprite_index); j+=2) {
				part_particles_create(global.p_sys,x+i,y+j,global.p_boost,1);
				if choose(1,2)==1 part_particles_create(global.p_sys,x+i,y+j,global.p_boost_2,1);
			}
		}
		scr_add_screenshake(2,8);
		destroy = true;
	}
}

if global.level > global.room_number instance_destroy() else sprite_index = sprite_normal;