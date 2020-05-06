//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

void main()
{
    //gl_FragColor = v_vColour * texture2D( gm_BaseTexture, v_vTexcoord );
    //gl_FragColor.rgb *= vec3(2.0,2.0,2.0);//this doubles the red, green and blue values
	
	vec4 Colour = v_vColour * texture2D( gm_BaseTexture, v_vTexcoord );
	
	//float blackness = (col.r + col.g + col.b) / 3.0;
	float blackness = max(Colour.r, max(Colour.g, Colour.b));	
	Colour.a = blackness;
	
	gl_FragColor = Colour;
	
	
}

