shader_type canvas_item;


uniform float radius : hint_range(0.0, 2.0) = 0.85;
uniform float softness : hint_range(0.0, 1.0) = 0.7;
uniform float intensity : hint_range(0.0, 1.0) = 0.5;
uniform vec2 center = vec2(0.5, 0.5);


void fragment() {
	vec4 tex_color = texture(TEXTURE, UV);
	float dist = distance(UV, center);
	float vignette = smoothstep(radius, radius - softness, dist);
	tex_color.rgb = mix(tex_color.rgb, tex_color.rgb * (1.0 - intensity), 1.0 - vignette);
	COLOR = tex_color;
}
