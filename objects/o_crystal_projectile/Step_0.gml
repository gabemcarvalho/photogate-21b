/// @description Move towards target
x += hspd;
y += vspd;
vspd += grav;
image_alpha = max( 0, image_alpha - 0.02 * image_xscale );

// Get destroyed if in wall
if place_meeting(x,y,o_wall) || image_alpha == 0 instance_destroy();