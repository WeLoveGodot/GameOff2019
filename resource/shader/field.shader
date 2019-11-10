shader_type canvas_item;

uniform float r;
uniform vec3 color;

bool is_in(vec2 coor) {
  return distance(coor, vec2(0.5, 0.5)) <= r;
}

void fragment() {
	COLOR = vec4(color.rgb, is_in(UV) ? 0.0 : 1.0);
}