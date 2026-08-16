shader_type canvas_item;

uniform float flashAmount : hint_range(0.0, 1.0) = 0.0;

void fragment() {
	vec4 texColor = texture(TEXTURE, UV);
	COLOR = vec4(mix(texColor.rgb, vec3(1.0), flashAmount), texColor.a);
}
