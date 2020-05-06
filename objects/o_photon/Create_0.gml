/// @description Initialize Photon
// Movement variables
hspd = 0;
vspd = 0;
dir = RIGHT;
walk_spd = 2;
run_spd = 4;
jump_power = 4;
grav = 0.5;
hangtime_max = 0;
hangtime = 0;
on_ground = false;
vspd_max = 10;
pre_jump = false;
can_fall = true;
hspd_next = 0; // used for diagonal mirrors
vspd_next = 0;
vmirror_collide = false;
vspd_next_2 = 0;
canmove = true;

// Moving platforms
hspd_platform = 0;
hspd_platform_hard = 0;
hspd_platform_last = 0;
hspd_platform_hard_last = 0;
vspd_platform = 0;
vspd_platform_last = 0;
moved_by_v_platform = false;
moved_by_v_platform_box = false;
plat_hspd = 0; // used when pushing blocks

// Other
crystal_cooldown = 5;
boosting = false;
mirror_next_frame = false;

// Sprites
sprite_idle = char_idle;
sprite_run = char_run;
wall_hit_frame = false;
sprite_jump = char_jump;
sprite_fall = char_fall;
sprite_down = char_down;
sprite_up = char_up;
sprite_run_up = char_run_up;
sprite_fall_up = char_fall_up;
idle_timer = 0;
idle_target = 100;

// Keyboard Input
key_right = false;
key_right_released = false;
key_left = false;
key_left_released = false;
move_key_released_midair = false; // used for moving while jumping
key_jump = false;
key_jump_pressed = false;
moving = false;
key_down = false;
key_up = false;

// Sounds
stepping = false;
