shader_type canvas_item;


uniform bool enable = false;


void fragment() {
	if (enable && COLOR.r < 0.1 && COLOR.g < 0.1 && COLOR.b < 0.1) {
		COLOR.rgb = vec3(1.0, 1.0, 1.0);
	}
}