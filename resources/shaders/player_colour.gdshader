shader_type canvas_item;

global uniform vec3 player_colour;
global uniform vec3 black_colour;
global uniform int player_count;

uniform bool use_only_primary_colour = false;
uniform bool step_alpha = false;

void fragment() {
  if (use_only_primary_colour)
    COLOR.rgb = player_colour;
  else
  {
   	if (COLOR.r > 0.0)
    {
      if (player_count == 1)
        COLOR.rgb = player_colour;
    }
    else
      COLOR.rgb = black_colour;
  }
  if (step_alpha)
    COLOR.a = step(0.01, COLOR.a);
}
