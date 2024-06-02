shader_type canvas_item;

global uniform vec3 accent_colour;

uniform float cutoff: hint_range(0.0, 1.0) = 0.5;
uniform sampler2D noiseTex: hint_default_white, filter_nearest;

void fragment() {
  COLOR.rgb = accent_colour;
  COLOR.a = step(0.01, COLOR.a);
  
  COLOR *= step(texture(noiseTex, UV).r, cutoff);
}