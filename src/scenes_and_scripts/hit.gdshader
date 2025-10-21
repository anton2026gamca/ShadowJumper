shader_type canvas_item;


uniform bool enabled = true;


void fragment() {
	if (enabled && COLOR.a > 0.0) {
		COLOR = vec4(1);
	}
}

