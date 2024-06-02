shader_type canvas_item;

global uniform vec3 enemy_colour;
global uniform vec3 black_colour;

void fragment() {
  if (COLOR.r > 0.0)
    COLOR.rgb = enemy_colour;
  else
    COLOR.rgb = black_colour;
}
