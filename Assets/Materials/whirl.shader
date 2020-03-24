shader_type canvas_item;

uniform float speed = 20.0; 
uniform float freq = 80.0;
uniform float amp = 0.004;

void fragment() {
	float time = TIME;
    
	//gl_FragCoord.xy / resolution.xy é o mesmo que SCREEN_UV
	vec2 uv = SCREEN_UV;
    
    vec2 ripple = vec2(cos((length(uv-0.5)*freq)+(-time*speed)),sin((length(uv-0.5)*freq)+(-time*speed)))*amp;
    //Version (Stronger at center, weaker at outside):
    ripple = vec2(cos((length(uv-0.5)*freq)+(-time*speed)),sin((length(uv-0.5)*freq)+(-time*speed)))*(clamp(1.-(length(uv-0.5)*1.5),0.,1.)*amp);
	
    //TIP: If you don't want them to go around in circles but make them go foward and backwards at 45 degrees, just change cos to sin.
    
    COLOR = vec4(texture(SCREEN_TEXTURE,uv+ripple));
}
