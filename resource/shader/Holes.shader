shader_type canvas_item;

uniform vec4 color;
uniform sampler2D holes_tex;
uniform float fdr = 0.8;
uniform uint s;

float get_r(vec4 hole) {
	return hole.r;
}

vec2 get_pos(vec4 hole) {
	return hole.gb;
}

float get_hole_alpha(vec4 hole) {
	return hole.a;
}

float mix_alpha(float a1, float a2) {
	return min(a1, a2);
}

float dis_alpha(float hole_alpha, float dis, float rr, float rr2) {
	float a  = (1. - hole_alpha) / pow(rr - rr2, 2.) * pow(dis - rr2, 2.) + hole_alpha;
	if (dis > rr2) {
		return a;
	} else {
		return hole_alpha;
	}
}

void fragment() {
	ivec2 size = textureSize(holes_tex, 0); // assert(size.y == 1);
	float fs = float(s);
	float alpha = 1.;
	for (int i = 0; i < size.x; i++ ) {
		vec4 hole = texelFetch(holes_tex, ivec2(i, 0), 0);
		float r = get_r(hole);
		float rr = r / fs;
		float rr2 = rr * fdr;
		vec2 pos = get_pos(hole);
		vec2 pos2 = vec2(pos) / fs + vec2(0.5, 0.5); // map (0, 0) to (0.5, 0.5)

		float dis = distance(pos2, UV);
		alpha = mix_alpha(alpha, dis_alpha(get_hole_alpha(hole), dis, rr, rr2));
		if (alpha == 0.) {
			break;
		}
	}
	COLOR = vec4(color.rgb, alpha);
}