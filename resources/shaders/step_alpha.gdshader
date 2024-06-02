shader_type canvas_item;

void fragment() {
  COLOR.a = step(0.01, COLOR.a);
}