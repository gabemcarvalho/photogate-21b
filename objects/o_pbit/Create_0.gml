/// @description Set up variables
xrel = 0;
yrel = 0;
spd_max = 3 + random_range(-1,1);
accel = 0.3+ random_range(-0.1,0.2);
spd = 0;

xtarget = 0;
ytarget = 0;

on_target = false;

explode = false;
hspd = 0;
vspd = 0;
grav = 0.2;