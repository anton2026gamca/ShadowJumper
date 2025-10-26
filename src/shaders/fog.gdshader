shader_type canvas_item;


uniform sampler2D noise_texture: repeat_enable;

uniform float min_fog_value = 0.0;
uniform float max_fog_value = 1.0;
uniform float fog_intensity = 1.0;

uniform vec2 scroll_speed = vec2(0.03, 0.03);
uniform float scroll_scale = 1.0;


void fragment() {
	vec4 color = texture(noise_texture, UV + TIME * scroll_scale * scroll_speed);
	float grayscale = (color.r + color.g + color.b) / 3.0;
	COLOR = vec4(1, 1, 1, (min_fog_value + grayscale * (max_fog_value - min_fog_value)) * fog_intensity);
}
