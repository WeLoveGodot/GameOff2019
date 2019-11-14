shader_type canvas_item;

uniform vec4 color;
uniform sampler2D holes_tex;
uniform float fdr = 0.05;
uniform uint s;

float get_r(vec4 hole) {
	return hole.r;
}

vec2 get_pos(vec4 hole) {
	return hole.gb;
}

void fragment() {
	bool is_in = false;
	ivec2 size = textureSize(holes_tex, 0); // assert(size.y == 1);
	//COLOR = vec4(float(size.y) / float(1536), 1.0, 1.0, 1.0);

	for (int i = 0; i < size.x; i++ ) {
		vec4 hole = texelFetch(holes_tex, ivec2(i, 0), 0);
		float r = get_r(hole);
		float r2 = float(r) / float(s);
		vec2 pos = get_pos(hole);
		vec2 pos2 = vec2(pos) / float(s) + vec2(0.5, 0.5); // map (0, 0) to (0.5, 0.5)

		if (distance(pos2, UV) < r2) {
			is_in = true;
			break;
		}
	}
	COLOR = vec4(color.rgb, is_in ? 0.0 : 1.0);
}