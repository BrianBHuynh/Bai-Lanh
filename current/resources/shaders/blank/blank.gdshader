shader_type canvas_item;
uniform bool started = false; //If initialized
uniform float cur_time = 0.0; //Time from an outside source
uniform vec2 direction = vec2(0,0); //Normalize this before inputting, difference of two values
uniform float strength = 0.0;
uniform float shader_length = 2.0;
uniform vec4 modulate = vec4(0.0, 0.0, 0.0, 0.0);

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
