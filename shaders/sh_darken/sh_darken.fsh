//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform float amount;

void main()
{
	
	vec4 col = v_vColour * texture2D( gm_BaseTexture, v_vTexcoord );
	
	// The amount of darkness applied follows the curve:
	// a * (1 - c)
	// where c is the original colour and a is the amount applied
	
	float new_r = col.r - amount*col.r;
	col.r = new_r;
	
	float new_g = col.g - amount*col.g;
	col.g = new_g;
	
	float new_b = col.b - amount*col.b;
	col.b = new_b;
	
    gl_FragColor = col;
	
}
