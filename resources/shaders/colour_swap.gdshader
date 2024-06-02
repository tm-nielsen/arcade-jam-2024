shader_type canvas_item;

uniform sampler2D swapGradient: filter_nearest;

void fragment() {
	COLOR.rgb = texture(swapGradient, vec2(COLOR.r, 0)).rgb;
}