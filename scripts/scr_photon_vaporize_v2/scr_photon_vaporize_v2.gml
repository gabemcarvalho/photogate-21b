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

// Get the array to access
switch sprite_index {
	case char_idle:			var target_map = o_controller.map_idle;			break;
	case char_up:			var target_map = o_controller.map_up;			break;
	case char_down:			var target_map = o_controller.map_down;			break;
	case char_run:		
		switch floor(image_index) {
			case 0:			var target_map = o_controller.map_run0;			break;
			case 1:			var target_map = o_controller.map_run1;			break;
			case 2:			var target_map = o_controller.map_run2;			break;
			case 3:			var target_map = o_controller.map_run3;			break;
			default:		var target_map = o_controller.map_run0;			break;
		}		
		break;
	case char_run_up:		
		switch floor(image_index) {
			case 0:			var target_map = o_controller.map_run_up0;		break;
			case 1:			var target_map = o_controller.map_run_up1;		break;
			case 2:			var target_map = o_controller.map_run_up2;		break;
			case 3:			var target_map = o_controller.map_run_up3;		break;
			default:		var target_map = o_controller.map_run_up0;		break;
		}		
		break;
	case char_jump:			var target_map = o_controller.map_jump;			break;
	case char_fall:			var target_map = o_controller.map_fall;			break;
	case char_fall_up:		var target_map = o_controller.map_fall_up;		break;
	case char_plumeting:	var target_map = o_controller.map_plumeting;	break;
	default:				var target_map = o_controller.map_idle;			break;
}

var dir_offset = 0;
if dir == RIGHT dir_offset = -2;

// Createpbits on the sprite
for (var j = 0; j < 8; j++) {
	for (var i = 0; i < 8; i++) {
		if target_map[i+8*j + (dir==RIGHT?8-2*i-1:0)] == 1 { // read from right to left if photon is facing to the right
			var newbit = instance_create_layer(x-3+i+dir_offset,y-4+j,"Player",o_pbit);
			if !absorb {
				newbit.xrel = -3+i+dir_offset;
				newbit.yrel = -4+j;
			}
			if explode {
				newbit.explode = true;
				var angle = random(2*pi);
				var spd = random(2) + 1;
				newbit.hspd = 0.8 * spd * sin(angle);
				newbit.vspd = -1 + spd * cos(angle);
				
				var newbit2 = instance_create_layer(x-3+i+dir_offset,y-4+j,"Player",o_pbit);
				newbit2.explode = true;
				angle = random(2*pi);
				spd = random(2) + 1;
				newbit2.hspd = 0.8 * spd * sin(angle);
				newbit2.vspd = -1 + spd * cos(angle);
				
				var newbit3 = instance_create_layer(x-3+i+dir_offset,y-4+j,"Player",o_pbit);
				newbit3.explode = true;
				angle = random(2*pi);
				spd = random(2) + 1;
				newbit3.hspd = 0.8 * spd * sin(angle);
				newbit3.vspd = -1 + spd * cos(angle);
			}
		}
	}
}
instance_destroy();