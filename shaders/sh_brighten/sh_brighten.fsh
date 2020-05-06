//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform float amount;

void main()
{
	
	vec4 col = v_vColour * texture2D( gm_BaseTexture, v_vTexcoord );
	col.r = col.r + amount - col.r * amount;
	col.g = col.g + amount - col.g * amount;
	col.b = col.b + amount - col.b * amount;
    gl_FragColor = col;
	
}
