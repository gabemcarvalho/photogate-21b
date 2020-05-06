/// @description Go Through Doors
var door = instance_place(x,y,o_door);
if door != noone {
	o_controller.last_room = room;
	global.door_transition = true;
	if door.allow_boosting o_controller.door_boost = boosting else o_controller.door_boost = false;
	
	o_controller.door_hspd = hspd;
	o_controller.door_vspd = vspd;
	
	if door.vertical == true {
		o_controller.spawn_side = -sign(door.y-y);
		o_controller.door_x = door.x-x;
		if door.centre_photon {
			o_controller.door_x = -door.image_xscale*4;//*8/2
			o_controller.door_hspd = 0;
		}
	} else {
		o_controller.ground_y = (door.y+8*door.image_yscale)-y;
		o_controller.spawn_side = sign(door.x-x);
	}
	
	scr_transition(door.other_room,3);
	room_goto(door.other_room);
}