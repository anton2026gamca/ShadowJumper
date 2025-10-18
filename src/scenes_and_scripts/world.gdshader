shader_type canvas_item;

uniform float night_intensity : hint_range(0.0, 1.0) = 0.0; // Transition parameter: 0.0 = full day, 1.0 = full night
uniform float night_darkness : hint_range(0.0, 1.0) = 1; // How much to darken the scene at night
uniform float night_contrast : hint_range(0.5, 2.0) = 2; // Contrast adjustment for night
uniform vec3 night_tint = vec3(0.2, 0.3, 0.8); // Night color tinting
uniform float tint_shift : hint_range(0.0, 1.0) = 1; // Tint shift intensity

void fragment() {
	vec4 original_color = texture(TEXTURE, UV); // Get the original color
	float luminance = dot(original_color.rgb, vec3(0.299, 0.587, 0.114)); // Calculate luminance for preserving brightness relationships
	vec3 contrasted = pow(original_color.rgb, vec2(night_contrast).xxx); // Apply contrast adjustment
	vec3 night_color = mix(contrasted, contrasted * night_tint, tint_shift); // Create night color by shifting towards blue/purple
	night_color *= mix(1.0, (1.0 - night_darkness) + luminance * 0.3, night_intensity); // Preserve some of the original brightness but darken overall
	vec3 ambient_night = vec3(0.1, 0.15, 0.3) * night_intensity; // Add a subtle blue ambient light to maintain visibility
	night_color += ambient_night * (1.0 - luminance);
	vec3 final_color = mix(original_color.rgb, night_color, night_intensity); // Mix between day and night based on transition value
	final_color = max(final_color, vec3(0.05, 0.05, 0.1) * night_intensity); // Ensure we don't go completely black
	// Don't apply shader for pixels with a = 127/255
	if (COLOR.a == 0.4980392157) {
		COLOR.a = 1.0;
	} else {
		COLOR = vec4(final_color, original_color.a);
	}
}

void light() {
	LIGHT = mix(vec4(0), texture(TEXTURE, UV), night_intensity * LIGHT_ENERGY * LIGHT_COLOR);
}