shader_type canvas_item;
uniform bool started = false; //If initialized
uniform float cur_time = 0.0; //Time from an outside source
uniform vec2 direction = vec2(0,0); //Normalize this before inputting, difference of two values
uniform float strength = 0.0;
uniform float length = 2.0;

void vertex() {
	float timer = mod(5.0*cur_time, 50.0);
	VERTEX.y += 200.0*clamp(VERTEX.y, -1.0, 1.0)*exp(-3.0*timer);
	VERTEX.x += 200.0*clamp(VERTEX.x, -1.0, 1.0)*exp(-3.0*timer);
	VERTEX.x += -direction.x * 600.0 * exp(-timer) * sin(100.0*timer);
	VERTEX.y += -direction.y * 600.0 * exp(-timer) * sin(100.0*timer);
}

void fragment() {
	vec3 shock_color = vec3(1.0, 0.0, 0.0);
	float time = cur_time;
	float timer = mod((time), 3.0)/2.0;
	vec3 normal_color = texture(TEXTURE, UV).rgb;
	COLOR.rgb = normal_color + shock_color * exp(-3.0*timer);
}