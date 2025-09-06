shader_type canvas_item;

// Transition parameter: 0.0 = full day, 1.0 = full night
uniform float night_intensity : hint_range(0.0, 1.0) = 0.0;

// Night color tinting
uniform vec3 night_tint = vec3(0.2, 0.3, 0.8);

// How much to darken the scene at night
uniform float night_darkness : hint_range(0.0, 1.0) = 0.7;

// Contrast adjustment for night
uniform float night_contrast : hint_range(0.5, 2.0) = 1.2;

// Blue shift intensity
uniform float blue_shift : hint_range(0.0, 1.0) = 0.4;

void fragment() {
    // Get the original color
    vec4 original_color = texture(TEXTURE, UV);
    
    // Calculate luminance for preserving brightness relationships
    float luminance = dot(original_color.rgb, vec3(0.299, 0.587, 0.114));
    
    // Apply contrast adjustment
    vec3 contrasted = pow(original_color.rgb, vec2(night_contrast).xxx);
    
    // Create night color by shifting towards blue/purple
    vec3 night_color = mix(contrasted, contrasted * night_tint, blue_shift);
    
    // Preserve some of the original brightness but darken overall
    night_color *= mix(1.0, (1.0 - night_darkness) + luminance * 0.3, night_intensity);
    
    // Add a subtle blue ambient light to maintain visibility
    vec3 ambient_night = vec3(0.1, 0.15, 0.3) * night_intensity;
    night_color += ambient_night * (1.0 - luminance);
    
    // Mix between day and night based on transition value
    vec3 final_color = mix(original_color.rgb, night_color, night_intensity);
    
    // Ensure we don't go completely black
    final_color = max(final_color, vec3(0.05, 0.05, 0.1) * night_intensity);
    
    COLOR = vec4(final_color, original_color.a);
}

void light() {
	LIGHT = mix(vec4(0, 0, 0, 0), texture(TEXTURE, UV), LIGHT_COLOR * night_intensity);
}