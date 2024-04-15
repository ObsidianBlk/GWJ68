shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture;
uniform sampler2D mask;


void fragment() {
	vec4 tcolor = texture(TEXTURE, UV);
	vec4 scolor = texture(screen_texture, SCREEN_UV);
	float weight = step(0.75, texture(mask, SCREEN_UV).r);
	//COLOR = texture(mask, SCREEN_UV);
	COLOR = mix(scolor, tcolor, weight);
	//COLOR = vec4(texture(screen_texture, SCREEN_UV).rgb, texture(TEXTURE, UV).a);
}

