shader_type canvas_item;
uniform bool started = false;
uniform float start_time = 0.0; //This should be the time when the shader is added, however since this rolls over when > 3600 seconds, there should be checks in the code to deal with this edge case when TIME rolls over and becomes < start_time although would it matter?
uniform float cur_time = 0.0;
uniform vec2 direction = vec2(1,1); //Normalize this before inputting, difference of two values

void vertex() {
	float time = cur_time-start_time;
	float timer = mod(time, 3.0)/2.0;
	VERTEX.y += -200.0*clamp(VERTEX.y, -1.0, 1.0)*exp(-3.0*timer);
	VERTEX.x += -200.0*clamp(VERTEX.x, -1.0, 1.0)*exp(-3.0*timer);
	VERTEX.x += -direction.x * 300.0 * exp(-3.0*timer) * sin(10.0*timer);
	VERTEX.y += -direction.y * 300.0 * exp(-3.0*timer) * sin(10.0*timer);
}

void fragment() {
	if (cur_time > start_time){
		COLOR.rgb = vec3(1.0, 1.0, 1.0);
	}
	else{
	vec3 shock_color = vec3(1.0, 0.0, 0.0);
	float time = cur_time-start_time;
	float timer = mod((time), 3.0)/2.0;
	vec3 normal_color = texture(TEXTURE, UV).rgb;
	COLOR.rgb = normal_color + shock_color * exp(-3.0*timer);
	}
}