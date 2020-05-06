/// @description Control the platform
// Change the hspd
hspd = osc_amp*sin(2*pi/osc_period*osc_timer);

var hspd_current = hspd;
var photon_speed = 0;
var photon_riding = place_meeting(x,y-1,o_photon);
for (var i = 0; i < abs(hspd_current); i++) {
	// Move photon out of the way
	if place_meeting(x+sign(hspd_current),y,o_photon) {
		o_photon.x += sign(hspd_current);
		o_photon.hspd_platform_hard = hspd_current;
	}
	// Move the platform
	if !place_meeting(x+sign(hspd_current),y,o_wall) {
		x += sign(hspd_current);
		// Give photon platform speed
		photon_speed++;
	} else {
		hspd = 0;
	}
}
if hspd == 0 hspd = -hspd_current;

if photon_riding o_photon.hspd_platform = sign(hspd_current)*photon_speed;


// Change the vspd
vspd = round(-osc_amp*sin(2*pi/osc_period*osc_timer));
osc_timer++;
if osc_timer == osc_period osc_timer = 0;

var vspd_current = vspd;
var photon_speed = 0;
for (var i = 0; i < abs(vspd_current); i++) {
	// Move photon out of the way
	if place_meeting(x,y+sign(vspd_current),o_photon) {
		o_photon.y += sign(vspd_current);
		o_photon.vspd_platform = vspd_current;
		// Limit photon's speed if hit from above
		if vspd_current > 0 {
			o_photon.vspd = min(o_photon.vspd,vspd_current);
		} else {
			o_photon.vspd = 0;
		}
	}
	// Pull photon downward
	if sign(vspd_current) == 1 && place_meeting(x,y-sign(vspd_current),o_photon) {
		// Check if the acceleration is less than that of gravity
		if round(-osc_amp*osc_amp*cos(2*pi/osc_period*osc_timer)) <= 4 {
			o_photon.y += sign(vspd_current);
			o_photon.vspd_platform = vspd_current;
		}
	}
	// Move the platform
	if !place_meeting(x,y+sign(vspd_current),o_wall) {
		y += sign(vspd_current);
	} else {
		vspd_current = 0;
	}
}