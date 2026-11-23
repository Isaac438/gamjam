shader_type canvas_item;

void fragment() {
	if (COLOR.r > 0.8 && COLOR.b > 0.8 && COLOR.g > 0.8) {
		COLOR = vec4(0.0, 0.0, 0.0, 0.0);
	}
}
