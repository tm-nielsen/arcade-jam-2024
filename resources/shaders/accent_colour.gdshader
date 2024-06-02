shader_type canvas_item;

global uniform vec3 accent_colour;

void fragment() {
  COLOR.rgb = accent_colour;
  COLOR.a = step(0.01, COLOR.a);
}