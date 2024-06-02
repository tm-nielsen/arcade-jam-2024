shader_type canvas_item;

global uniform vec3 background_colour;

void fragment() {
  COLOR.rgb = background_colour;
  COLOR.a = step(0.01, COLOR.a);
}