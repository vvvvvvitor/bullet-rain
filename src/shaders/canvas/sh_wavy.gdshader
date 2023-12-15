shader_type canvas_item;
uniform float strength = 10.0;

void vertex() {
	VERTEX.y = VERTEX.y + (sin(((TIME * 0.2) + VERTEX.x) * strength) * 2.0);
}