shader_type canvas_item;

uniform int num_colors : hint_range(1, 128, 1) = 4;
uniform bool invert = false;
uniform sampler2D base_palette;
uniform sampler2D new_palette;
uniform sampler2D screen_texture : hint_screen_texture;

vec4 get_palette_color(sampler2D palette, int idx){
	idx = clamp(idx, 0, num_colors - 1);
	float size = 1.0 / float(num_colors);
	float hsize = size * 0.5;
	vec2 uv = vec2((size * float(idx)) + hsize, 0.5);
	return texture(palette, uv);
}

void fragment() {
	vec4 color = texture(screen_texture, SCREEN_UV);
	for (int i = 0; i < num_colors; i++){
		vec4 pal = get_palette_color(base_palette, i);
		if (distance(pal, color) < 0.001){
			color = get_palette_color(new_palette, (invert) ? num_colors - (i + 1) : i);
			break;
		}
	}
	COLOR = color;
}
