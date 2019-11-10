shader_type canvas_item;

uniform float r;
uniform vec3 color;
uniform float dr;

float alpha(vec2 coor) {
	float dis = distance(coor, vec2(0.5, 0.5));
	float a = (dis - r) / dr + 1.0;
	float a2 =  clamp(a, 0.0, 1.0);
	return a2 * a2;
}

void fragment() {
	COLOR = vec4(color.rgb, alpha(UV));
}