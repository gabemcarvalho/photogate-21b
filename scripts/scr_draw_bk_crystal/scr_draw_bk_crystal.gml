x = x_init + o_camera.x * (1 * parallax_value) - VIEW_WIDTH/2;
y = (o_camera.y  - VIEW_HEIGHT/2) + y_init + side_parallax * 5 * (room_height - o_camera.y  - VIEW_HEIGHT/2);
var cx = x - o_camera.x; // distance from centre of camera
draw_sprite_ext(sprite_index, cx < 0 ? 2 : 1, x - round(cx * side_parallax * 2) / 2, y, 1, 1, 0, colour, 1.0);
draw_sprite_ext(sprite_index, 0, x, y, 1, 1, 0, colour, 1.0);