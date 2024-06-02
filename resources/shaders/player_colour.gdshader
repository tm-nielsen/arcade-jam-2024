shader_type canvas_item;

global uniform vec3 player_colour;
global uniform vec3 black_colour;
uniform int player_count: hint_range(1, 2) = 1;

void fragment() {
	if (COLOR.r > 0.0)
  {
    if (player_count == 1)
      COLOR.rgb = player_colour;
  }
  else
    COLOR.rgb = black_colour;
}
