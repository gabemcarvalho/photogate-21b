/// @description Set up variables
var angle = random(2*pi);
var spd = random(1.5);
hspd = 0.8 * spd * sin(angle);
vspd = -1 + spd * cos(angle);

if instance_exists(o_photon) {
	if o_photon.hspd != 0 hspd += sign(o_photon.hspd);
	if o_photon.vspd != 0 vspd += sign(o_photon.vspd);
}

grav = 0.2;

image_xscale = irandom(3) + 1;
image_yscale = image_xscale;
image_alpha = random(1);