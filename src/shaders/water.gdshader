shader_type canvas_item;


uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, filter_nearest;

uniform sampler2D noise1: repeat_enable;
uniform vec2 scroll1 = vec2(0.1, 0.1);
uniform float weight1 = 0.007;

uniform sampler2D noise2: repeat_enable;
uniform vec2 scroll2 = vec2(-0.05, -0.02);
uniform float weight2 = 0.007;


void fragment() {
	if (COLOR.a > 0.0) {
		vec2 uv_shift_1 = texture(noise1, SCREEN_UV + TIME * scroll1).rg * weight1;
		vec2 uv_shift_2 = texture(noise2, SCREEN_UV + TIME * scroll2).rg * weight2;
		vec2 uv_shift = uv_shift_1 - uv_shift_2;
		COLOR = texture(TEXTURE, UV) * texture(SCREEN_TEXTURE, SCREEN_UV + uv_shift);
	}
}
