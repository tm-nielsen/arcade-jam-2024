shader_type canvas_item;

uniform float cutoff: hint_range(0.0, 1.0) = 0.5;
uniform sampler2D noiseTex: hint_default_white, filter_nearest;

void fragment() {
  COLOR *= step(texture(noiseTex, UV).r, cutoff);
}
