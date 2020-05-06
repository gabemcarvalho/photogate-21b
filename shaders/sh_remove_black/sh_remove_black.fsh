//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

void main()
{
	vec4 Colour = v_vColour * texture2D( gm_BaseTexture, v_vTexcoord );
	
	Colour.a = 4.0*max(Colour.r, max(Colour.g, Colour.b));
	Colour.rgb = vec3(1.0);
	
	gl_FragColor = Colour;
	
	
}

