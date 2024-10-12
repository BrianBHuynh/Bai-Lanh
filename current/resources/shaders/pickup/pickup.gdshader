shader_type canvas_item;
uniform bool started = false; //If initialized
uniform float cur_time = 0.0; //Time from an outside source
uniform vec2 direction = vec2(0,0); //Normalize this before inputting, difference of two values
uniform float strength = 0.0;
uniform float shader_length = -1.0;
uniform vec2 offset = vec2(0.0, 0.0);
uniform vec4 modulate = vec4(0.0, 0.0, 0.0, 0.0);
uniform float Scale = 500.0;
uniform float threshold = 5.0;


void vertex() {
	vec2 difference = VERTEX-offset;
	VERTEX = normalize(abs(difference))*vec2(Scale,Scale)*normalize(VERTEX) + VERTEX;
}

void fragment() {
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
