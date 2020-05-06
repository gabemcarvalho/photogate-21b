/// @description Init
thundering = false;
thunder_step = 0;
thunder_timer_default = 400;
thunder_timer = thunder_timer_default+random_range(-200,100);
thunder_chance = 400; // unused

grid_id = layer_background_get_id("bk_grid");