shader_type canvas_item;

uniform vec4 modulate;
uniform float scroll_speed:hint_range(0.0, 2.0);

void fragment() {
	COLOR = texture(TEXTURE, UV + (TIME * scroll_speed)) + modulate;
}
