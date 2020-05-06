/// @description Draw the textbox
// Draw the box
//var cx = o_camera.x-(VIEW_WIDTH/2);
//var cy = o_camera.y-(VIEW_HEIGHT/2);
var cx = 0;
var cy = 0;//-52
surface_set_target(o_controller.surf_trans);

draw_nineslice(s_textbox_default,cx+box_x1,cy+box_y1,cx+box_x1+box_width,cy+box_y1+box_height);

//if text_char[0] == 0 {game_end()}

// Set the draw properties
draw_set_font(global.f_neural);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_colour(col_default);

// Get the length of the text
var length = string_length(text);

if growing == 0 {
    if state != 2 {
        // Scroll the text
        if place <= length {
            if counter > 0 {
                counter--;
            } else {
                // Scroll the text
                // Determine the next character in the text
                // Skip spaces and line breaks
                while (string_char_at(text,place) == " " || string_char_at(text,place) == "#") {
                    if (string_char_at(text,place) == " ") {
                        // If there is a space, add to the last x position
						text_x_last += space_width;
                        colour = col_default;
                    } else if (string_char_at(text,place) == "#") {
                        // If there is a line break, reset the last x position and add to the last y position
                        text_y_last += line_height;
                        colour = col_default;
                        
                        // If there are more than 3 lines, scroll everything up
                        if text_y_last > text_y_default+(line_height*2) {
							// If the top line is at the top of the textbox
							if text_y[3] == text_y_default {
	                            /// Delete the first line
	                            // Get the number of characters in the first line
	                            var i = 0;
	                            while (string_char_at(message[current],i) != "#") {
	                                i++;
	                            }
                            
	                            // Get the length of the original message
	                            var length_old = string_length(message[current]);
                            
	                            // Delete the first line of the message
	                            message[current] = string_copy(message[current],i+1,string_length(message[current])-i);
                            
	                            // Delete the first line of character strings
	                            for (e = 0; e <= i; e++) {
	                                text_char[e] = " ";
	                                text_x[e] = 0;
	                                text_y[e] = 0;
	                                text_colour[e] = col_default;
	                            }
                            
	                            // Get the number of displayed characters after the first line
	                            var n = place - i;
	                            i++;
                            
	                            // Recalculate the text string
	                            text = string_copy(message[current],0,length-i+1);
                            
	                            // Move all the characters after the first line to the beginning of the array
	                            var p = 0;
	                            while (text_char[p+i-1] != 0) {
	                                // Move the p + i value to the p value in the list
	                                text_char[p] = text_char[p+i-1];
	                                text_char[p+i-1] = " ";
	                                text_colour[p] = text_colour[p+i-1];
	                                text_colour[p+i-1] = col_default;
	                                text_x[p] = text_x[p+i-1];
	                                text_x[p+i-1] = 0;
	                                text_y[p] = text_y[p+i-1];
	                                text_y[p+i-1] = 0;
	                                p++;
	                            }
	                            text_y_last -= line_height;
                            
	                            // Recalculate text string and place
	                            place = n;
	                            length = string_length(text);
								
							} else {
								// Set the current character to the default values
		                        text_char[place] = " ";
		                        text_x[place] = 0;
		                        text_y[place] = 0;
		                        text_colour[place] = col_default;
							}
                            
							// Change the state
							state = 2;
                            
                        } else {
                            text_x_last = text_x_default;
                        }
                    }    
                    
                    if state != 2 {
                        // Set the current character to the default values
                        text_char[place] = " ";
                        text_x[place] = 0;
                        text_y[place] = text_y_last;
                        text_colour[place] = col_default;
                    }
                    
	                // Increase the place
	                text_char[place+1] = 0;
	                place++;
					
                }
                
                if state != 2 {
                    /// Check for a colour character
                    // ^ = red
                    // & = blue
                    // ~ = black
                    var char = string_char_at(text,place);
                    if (char == "^") {
                        // Increase the place, set the colour value
                        colour = col_red;
                        text_char[place] = " ";
                        text_x[place] = 0;
                        text_y[place] = text_y_last;
                        text_colour[place] = col_default;
                        place++;
                        text_char[place+1] = 0;
                        text_colour[place] = col_red;
                    } else if (char == "&") {
                        // Increase the place, set the colour value
                        colour = col_blue;
                        text_char[place] = " ";
                        text_x[place] = 0;
                        text_y[place] = text_y_last;
                        text_colour[place] = col_default;
                        place++;
                        text_char[place+1] = 0;
                        text_colour[place] = col_blue;
                    } else if (char == "~") {
                        // Increase the place, set the colour value
                        colour = col_default;
                        text_char[place] = " ";
                        text_x[place] = 0;
                        text_y[place] = text_y_last;
                        text_colour[place] = col_default;
                        place++;
                        text_char[place+1] = 0;
                        text_colour[place] = col_default;
                    } else {
                        // Set the default colour value
                        text_colour[place] = colour;
                    }
                    
                    // Add the next character
                    text_char[place] = string_copy(text,place,1);
                    text_x[place] = text_x_last;
                    text_y[place] = text_y_last;
                    
                    // Set a new x value
                    text_x_last += string_width(string_char_at(text,place));
                    
                    // Increase the place
                    place++;
                    text_char[place+1] = 0;
                    text_x[place+1] = 0;
                    text_y[place+1] = 0;
                    text_colour[place+1] = col_default;
                    
                    // Increase the counter
                    counter = counter_default;
                    if (place < length) {
                        char = text_char[place-1];
                        next_char = string_char_at(text,place);
                        if next_char != "#" {
                            if (char == "." || char == "," || char == "!" || char == "?") {
                                counter += grammar_delay;
                            }
                        }
                    }
                }
                
            }
        } else {
            // The text is done scrolling
            done = true;
        }
    } else { // State 2
        // Continue scrolling the text up
        if text_y[3] > text_y_default {
			for (s = 0; text_char[s] != 0; s++) {
				if text_y[s] > text_y_default+line_height {
					text_y[s] -= scroll_speed;
					text_y[s] = max(text_y[s],(text_y_default+line_height));
				} else {
					text_y[s] -= scroll_speed;
					text_y[s] = max(text_y[s],text_y_default);
				}
				
            }
            text_y_last -= scroll_speed;
            text_y_last = max(text_y_last,text_y_default);
        } else {
            state = 1;
            text_x_last = text_x_default;
            text_y_last = text_y_default+((line_height)*2);
        }
    }


    // Draw the text
    var h = 0;
    while (h < place) {
        
		//draw_set_colour(c_black);
		//draw_text(cx+text_x[h]+1,cy+text_y[h]+1,text_char[h]);
		//draw_text(cx+text_x[h],cy+text_y[h]+1,text_char[h]);
		
		draw_set_colour(text_colour[h]);
        //draw_set_colour(choose(col_red,c_orange,c_yellow,c_green,c_blue,c_purple));
        draw_text(cx+text_x[h],cy+text_y[h],text_char[h]);
        h++;
        draw_set_colour(c_white);
    }
    
    // Draw the text cursor
    if state != 2 && done {
        if close_counter > floor(close_counter_max/2) {    
            draw_sprite(s_textbox_cursor,0,cx+text_x_last,cy+text_y_last);
        }
        close_counter--;
        if close_counter == 0 {
            close_counter = close_counter_max;
        }
    }
}

// Set the draw properties back to default
draw_set_colour(c_white);

surface_reset_target();

// Debug Screen
/*
var xview = o_camera.x-VIEW_WIDTH/2;
var yview = o_camera.y-VIEW_HEIGHT/2;

// Draw the full text
//draw_text(xview+1,yview+1,text);

draw_text(xview+1,yview+48,string(place));
draw_text(xview+30,yview+48,string(string_length(text)));
draw_text(xview+140,yview+48,string_char_at(text,place));
draw_text(xview+60,yview+48,string(string_length(message[current])));

// Draw text_y at place
draw_text(xview+1,yview+36,"y[place] = "+string(text_y[place-1]));

// Draw text_y at 3
if place > 3 draw_text(xview+80,yview+36,"y[3] = "+string(text_y[3]));
if place > 3 draw_text(xview+80,yview+24,"char[3] = "+string(text_char[3]));

// Draw the state
draw_text(xview+1,yview+72,"State "+string(state));

// Show the first character with a vaule of 0
var z = 0;
while (text_char[z] != 0) {z++;}
draw_text(xview+90,yview+60,"First 0: "+string(z));

// Draw the first and second characters
draw_text(xview+1,yview+60,string(text_char[0]));
draw_text(xview+10,yview+60,string(text_char[1]));



