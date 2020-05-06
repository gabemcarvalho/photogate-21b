/// @description scr_transition(destination, type)
/// @param destination
/// @param type
// Type 0 - Slow Bubbles
// Type 1 - Diagonal Swipe
// Type 2 - Fast Bubbles
// Type 3 - Half Fast Bubbles (does not move to new room)
// Type 4 - Half slow bubbles (goes to new room)
var trans = instance_create_layer(0,0,"GUI",o_transition);
trans.next_room = argument0;
trans.type = argument1;