//
// This just makes sure the colours are NOT white
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

void main()
{
     vec4 col = v_vColour * texture2D( gm_BaseTexture, v_vTexcoord );
	 col.rgb *= 0.9;
	 gl_FragColor = col;
}
