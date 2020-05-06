/// @description scr_mirror_flash(mirror)
/// @param mirror
if instance_exists(argument0) {
	with argument0 {
		brightness = 1;
		
		// Check for other mirrors in the four possible directions
		var other_mirror = instance_place(x+8,y,o_wall_mirror);
		if other_mirror != noone {
			if other_mirror.brightness != 1 other_mirror.brightness = 1;
		}
		
		var other_mirror = instance_place(x-8,y,o_wall_mirror);
		if other_mirror != noone {
			if other_mirror.brightness != 1 other_mirror.brightness = 1;
		}
		
		var other_mirror = instance_place(x,y+8,o_wall_mirror);
		if other_mirror != noone {
			if other_mirror.brightness != 1 other_mirror.brightness = 1;
		}
		
		var other_mirror = instance_place(x,y-8,o_wall_mirror);
		if other_mirror != noone {
			if other_mirror.brightness != 1 other_mirror.brightness = 1;
		}
		
	}
}