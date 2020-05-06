varying vec2 v_vTexcoord;
varying vec4 v_vColour;

void main()
{
    vec4 base_col = v_vColour * texture2D( gm_BaseTexture, v_vTexcoord );
	base_col.a = max(0.0, base_col.a - 0.001);
    gl_FragColor = base_col;
	
}
