/// @description Draw the Cutscene
switch room {
	case r_ceiling:

		var panel_x = max(ceil_step-8,0);

		surface_set_target(o_controller.surf_preblur);

		draw_set_colour(c_white);
		draw_sprite(s_ceiling_light,0,0,0);
		draw_sprite(s_ceiling_left_panel,0,-panel_x,0);
		draw_sprite(s_ceiling_right_panel,0,panel_x,0);
		draw_sprite(s_ceiling_cells,0,0,0);

		if ceil_step > 0 {
			draw_set_alpha(0.5);
			if ceil_step > 6 draw_rectangle(66-panel_x,56,66+panel_x,85,false);
			draw_set_alpha(1);
			draw_sprite_part(s_ceiling_right_light,0,max(6-ceil_step,0),0,min(2*ceil_step,12),85,panel_x+67+max(6-ceil_step,0),0);
		}

		surface_reset_target();
	
	break;
	case r_world_map:
		
		map_y = max(map_y,0);
		
		// Control Thunder
		if thundering {
			thunder_step++;
			switch thunder_step {
				case 1:
				grid_image = 1;
				break;
				case 3:
				grid_image = 0;
				break;
				case 5:
				grid_image = 1;
				break;
				case 10:
				grid_image = 0;
				break;
				case 13:
				grid_image = 1;
				break;
				case 17:
				grid_image = 0;
				thundering = false;
				thunder_step = 0;
				break;
			}
		}
		
		// Draw backgrounds
		draw_sprite(s_world_map_grid,grid_image,0,map_y*0.2);
		draw_sprite(s_world_map_ceiling,0,0,-12+map_y*0.2);
		draw_sprite(s_world_map_crystals,0,0,map_y);
		draw_sprite(s_world_map_cliffs,0,0,map_y*1.2);
		
		// Draw text
		draw_set_font(f_thinpixel7);
		draw_set_halign(fa_left);
		draw_set_valign(fa_center);
		draw_text(104,15,map_label);
		
		// Draw line (photon)
		if line_length > 0 {
			draw_sprite_ext(s_white_pixel,0,20,8,1,line_length,0,c_white,1);
		}
		
	break;
	case r_a1_altar:
		
		surface_set_target(o_controller.surf_preblur);
		if dots > 0 && dots < 4 {
			draw_sprite(s_white_pixel,0,101,111);
			if dots > 1 draw_sprite(s_white_pixel,0,104,111);
			if dots > 2 draw_sprite(s_white_pixel,0,107,111);
		} else if dots == 4 {
			draw_sprite(s_white_pixel,0,102,107);
			draw_sprite_ext(s_white_pixel,0,103,102,1,4,0,c_white,1);
		}
		surface_reset_target();
		
	break;
}