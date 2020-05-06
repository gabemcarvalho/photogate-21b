/// @description Control the textbox
// Startup the textbox
if state == 0 {
    if growing == 1 {
        if box_x1 >= box_xmax+grow_speed {
            box_x1 -= grow_speed*1.5;
            box_width += grow_speed*3;
            if box_width > box_wmax {
                box_width = box_wmax;
            }
        } else {
            growing = 2;
            box_x1 = box_xmax;
            box_width = box_wmax;
            box_y1 -= grow_speed;
            box_height += grow_speed;
        }
    } else if growing == 2 {
        if box_y1 >= box_ymax+grow_speed {
            box_y1 -= grow_speed;
            box_height += grow_speed*2;
            if box_height > box_hmax {
                box_height = box_hmax;
            }
        } else {
            box_y1 = box_ymax;
            box_height = box_hmax;
            alarm[0] = 2;
            state = 1;
        }
    } else if growing == 3 { // Close the textbox
        if box_y1 <= (VIEW_HEIGHT-floor(box_hmax/2)-6) {
            box_y1 += grow_speed;
            box_height -= grow_speed*2;
            if box_height < 2 {
                box_height = 2;
            }
        } else {
            // Destroy the textbox ////////////////////////////////////////////// destroy event
			if global.active_npc != noone {
				global.active_npc.canmove = true;
				global.active_npc.target = global.active_npc.x;
				global.active_npc = noone;
			}
			with o_photon canmove = true;
			instance_destroy();
        }
    }
}

// Check if holding fast scroll key
if keyboard_check(ord("Z")) {
    counter_default = 0;//0
} else {
    counter_default = counter_default_default;
}

// Advance or close the textbox
if done {
    if keyboard_check_pressed(ord("Z")) {
        if (string_length(text) < string_length(message[current])) {
            // Advance the textbox
            get_new_message();
            done = false;
        } else {
            // Go to the next message or close the textbox
            if message[current+1] == 0 {
                // Go to textbox close animation
                done = false;
                state = 0;
                growing = 3;
            } else {
                // Go to the next message
                // Delete the current text
                current++;
                for (i = 0; text_char[i] != 0; i++) {
                    text_char[i] = 0;
                    text_x[i] = -12;
                    text_y[i] = -12;
                    text_colour[i] = col_default;
                }
				
				// Set the first character
				text_char[0] = " ";
				text_char[1] = 0;
				text_x[0] = text_x_last;
				text_y[0] = text_y_last;
				text_colour[0] = col_default;
				
                text_x_last = text_x_default;
                text_y_last = text_y_default+line_height;
                get_new_message();
                counter = 0;
                place = 1;
                wait = 1;
                done = false;
                closeable = false;
                close_counter = close_counter_max/2-1;
                colour = col_default;
            }
        }
    }
}
