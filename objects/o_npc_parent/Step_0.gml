/// @description Control the npc
if canmove {
	if x == target {
		sprite_index = sprite_idle;
		// npc is on the target, can parform an action
		if cooldown > 0 {
			cooldown--;
		} else if round(random(move_chance))==1 {
			// Possible actions: turning, walk forward, turn and walk
			if choose(1,2,3,4)==1 {
				// Just turn around
				dir = -dir;
			} else {
				// Chose direction
				if x != origin dir = sign(origin-x) else dir = choose(RIGHT,LEFT);
				if choose(1,2,3)==1 dir = -dir;
				// Set the target
				target = x+dir*round(random(range/2)+range/2);
			}
			// If facing a wall turn around
			if place_meeting(x+dir,y,o_wall_npc) {
				dir = -dir;
			}
			cooldown = 15;
		}
	} else {
		sprite_index = sprite_walk;
		if !place_meeting(x+dir*walk_spd,y,o_wall_npc) {
			x+=dir*walk_spd;
		} else {
			target = x;
		}
	}
}