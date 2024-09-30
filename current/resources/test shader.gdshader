shader_type canvas_item;
uniform float start_time = 0.0;
uniform vec2 direction = vec2(1,1);

//rewrite entire shader once deciding general direction of it, currently a hit / damage effect based on https://godotshaders.com/shader/shock-damage/ which is under CC0, most of the code here is modified and will be totally rewritten at some point although the original post code will be used as reference. Current code contains some modifications used as refrence
void vertex() {
	vec2 test = vec2(5,5);
	float timer = mod(TIME-start_time, 3.0)/2.0;
	VERTEX.y += -200.0*clamp(VERTEX.y, -1.0, 1.0)*exp(-3.0*timer);
	VERTEX.x += -200.0*clamp(VERTEX.x, -1.0, 1.0)*exp(-3.0*timer);
	VERTEX.x += -direction.x * 300.0 * exp(-3.0*timer) * sin(10.0*timer);
	VERTEX.y += -direction.y * 300.0 * exp(-3.0*timer) * sin(10.0*timer);
}
void fragment() {
	vec3 shock_color = vec3(1.0, 0.0, 0.0);
	float timer = mod(TIME, 3.0)/2.0;
	vec3 normal_color = texture(TEXTURE, UV).rgb;
	COLOR.rgb = normal_color + shock_color * exp(-3.0*timer);
}