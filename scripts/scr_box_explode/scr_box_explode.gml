/// @description scr_box_explode();
// Create pbits on the sprite
for (var j = 2; j < 8; j++) {
	for (var i = 1; i < 7; i++) {
		var newbit = instance_create_layer(x+i,y+j,"Player",o_pbit);
		
		newbit.explode = true;
		var angle = random(2*pi);
		var spd = random(2) + 1;
		newbit.hspd = 0.8 * spd * sin(angle);
		newbit.vspd = -1 + spd * cos(angle);
				
		var newbit2 = instance_create_layer(x+i,y+j,"Player",o_pbit);
		newbit2.explode = true;
		angle = random(2*pi);
		spd = random(2) + 1;
		newbit2.hspd = 0.8 * spd * sin(angle);
		newbit2.vspd = -1 + spd * cos(angle);
				
		var newbit3 = instance_create_layer(x+i,y+j,"Player",o_pbit);
		newbit3.explode = true;
		angle = random(2*pi);
		spd = random(2) + 1;
		newbit3.hspd = 0.8 * spd * sin(angle);
		newbit3.vspd = -1 + spd * cos(angle);
	}
}
instance_destroy();