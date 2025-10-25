shader_type canvas_item;


uniform float night_intensity 		: hint_range(0.0, 1.0) 	= 0.0;
uniform float night_darkness 		: hint_range(0.0, 1.0) 	= 1;
uniform float night_contrast 		: hint_range(0.5, 2.0) 	= 2;
uniform vec3 night_tint				: source_color 			= vec3(0.2, 0.3, 0.8);
uniform float tint_shift 			: hint_range(0.0, 1.0) 	= 1;
uniform vec3 ambient_light_color 	: source_color 			= vec3(0.2, 0.3, 0.8);
uniform float ambient_light_value 	: hint_range(0.0, 1.0) 	= 0.4;
uniform vec3 luminance_weights 		: source_color			= vec3(0.299, 0.587, 0.114);

varying vec4 modulate;


void vertex() {
	modulate = COLOR;
}

void fragment() {
	float luminance = dot(COLOR.rgb, vec3(luminance_weights));
	vec3 contrasted = pow(COLOR.rgb, vec2(night_contrast).xxx);
	vec3 night_color = mix(contrasted, contrasted * night_tint, tint_shift);
	night_color *= 1.0 - night_darkness + luminance * 0.3;
	
	vec3 ambient_light = ambient_light_value * night_intensity * ambient_light_color;
	night_color += ambient_light * (1.0 - luminance);
	
	vec3 final_color = mix(COLOR.rgb, night_color, night_intensity);
	
	if (COLOR.a == 0.4980392157) {
		COLOR.a = 1.0; // Don't apply shader for pixels with a = 127/255
	} else {
		COLOR.rgb = final_color;
	}
	
	COLOR *= modulate;
}

void light() {
	LIGHT = mix(vec4(0), (texture(TEXTURE, UV) - vec4(COLOR.rgb, 0)) * modulate, night_intensity * LIGHT_ENERGY * LIGHT_COLOR);
}