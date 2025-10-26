shader_type canvas_item;


uniform float value: hint_range(0, 1);


void fragment() {
	COLOR = mix(COLOR, vec4(vec3((COLOR.r + COLOR.g + COLOR.b) / 3.0), COLOR.a), value);
}