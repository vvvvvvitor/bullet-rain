shader_type spatial;
render_mode unshaded;

uniform sampler2D noise;
uniform float density:hint_range(0.0, 2.0);
uniform float speed;
uniform float size;
uniform float weight:hint_range(0.0, 1.0);

void fragment() {
	vec4 tex = texture(noise, (UV * vec2(textureSize(noise, 1)) * size) + (TIME * speed));


	ALBEDO = tex.rgb - ((tex.rgb * density) / 3.0);
	ALPHA = ((tex.r * tex.g * tex.b) * (density)) + (weight / 3.0);
	
}
