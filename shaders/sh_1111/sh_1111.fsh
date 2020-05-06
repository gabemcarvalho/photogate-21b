//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

void main()
{
    vec4 base_col = v_vColour * texture2D( gm_BaseTexture, v_vTexcoord );
	if (base_col.a > 0.0) {
		base_col.a *= 2.5;
	}
    gl_FragColor = vec4(1.0, 1.0, 1.0, base_col.a);
	
}
