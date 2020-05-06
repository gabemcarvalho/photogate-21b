/// @description Move towards target
if !explode {
	if instance_exists(o_pbit_controller) {
		xtarget = round(o_pbit_controller.x)+xrel;
		ytarget = round(o_pbit_controller.y)+yrel;
	}

	if o_pbit_controller.light_crystal_absorb == true {
		if place_meeting(x,y,o_light_crystal) {
			instance_destroy();
			o_pbit_controller.lc.bright_amount += 0.04;
		}
	}

	if spd < spd_max spd += accel;

	if x == xtarget && y == ytarget {
		on_target = true;
	} else {
		on_target = false;
	
		var dis = max(distance_to_point(xtarget,ytarget),0.1);
		var xspd = max(spd*abs(x-xtarget)/dis,0.1);
		var yspd = max(spd*abs(y-ytarget)/dis,0.1);
	
		if x != xtarget x = approach(x,xspd,xtarget);
		if y != ytarget y = approach(y,yspd,ytarget);
	}
} else {
	if place_meeting(x+hspd,y,o_object) {
		while !place_meeting(x+sign(hspd),y,o_object) {
			x+=sign(hspd);
		}
		hspd = 0;
	} else {
		x += hspd;
	}
	if place_meeting(x,y+vspd,o_object) {
		while !place_meeting(x,y+sign(vspd),o_object) {
			y+=sign(vspd)
		}
		if vspd > 0 grav = 0;
		hspd = 0;
		vspd = 0;
	} else {
		y += vspd;
	}
	vspd += grav;
}

// Get destroyed if in wall
if place_meeting(x,y,o_object) sprite_index = s_nothing;