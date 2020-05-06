varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform vec2 resolution;

void main()
{	
	vec2 d = vec2(1.0/resolution.x, 1.0/resolution.y);
	vec4 c = texture2D(gm_BaseTexture, v_vTexcoord );
	float alpha = 0.0;
	
	if (c.a > 0.0) {
		if			(texture2D(gm_BaseTexture, vec2(v_vTexcoord.x + d.x,	v_vTexcoord.y			)).a == 0.0) {
			alpha = 1.0;
		} else if	(texture2D(gm_BaseTexture, vec2(v_vTexcoord.x,			v_vTexcoord.y + d.y		)).a == 0.0) {
			alpha = 1.0;
		} else if	(texture2D(gm_BaseTexture, vec2(v_vTexcoord.x - d.x,	v_vTexcoord.y			)).a == 0.0) {
			alpha = 1.0;
		} else if	(texture2D(gm_BaseTexture, vec2(v_vTexcoord.x,			v_vTexcoord.y - d.y		)).a == 0.0) {
			alpha = 1.0;
		} else if	(texture2D(gm_BaseTexture, vec2(v_vTexcoord.x + d.x,	v_vTexcoord.y + d.y		)).a == 0.0) {
			if		(texture2D(gm_BaseTexture, vec2(v_vTexcoord.x + d.x * 2.0,v_vTexcoord.y)).a > 0.0 && texture2D(gm_BaseTexture, vec2(v_vTexcoord.x, v_vTexcoord.y + d.y * 2.0)).a > 0.0) {
				alpha = 1.0;
			}
		} else if	(texture2D(gm_BaseTexture, vec2(v_vTexcoord.x + d.x,	v_vTexcoord.y - d.y		)).a == 0.0) {
			if		(texture2D(gm_BaseTexture, vec2(v_vTexcoord.x + d.x * 2.0,v_vTexcoord.y)).a > 0.0 && texture2D(gm_BaseTexture, vec2(v_vTexcoord.x, v_vTexcoord.y - d.y * 2.0)).a > 0.0) {
				alpha = 1.0;
			}
		} else if	(texture2D(gm_BaseTexture, vec2(v_vTexcoord.x - d.x,	v_vTexcoord.y + d.y		)).a == 0.0) {
			if		(texture2D(gm_BaseTexture, vec2(v_vTexcoord.x - d.x * 2.0,v_vTexcoord.y)).a > 0.0 && texture2D(gm_BaseTexture, vec2(v_vTexcoord.x, v_vTexcoord.y + d.y * 2.0)).a > 0.0) {
				alpha = 1.0;
			}
		} else if	(texture2D(gm_BaseTexture, vec2(v_vTexcoord.x - d.x,	v_vTexcoord.y - d.y		)).a == 0.0) {
			if		(texture2D(gm_BaseTexture, vec2(v_vTexcoord.x - d.x * 2.0,v_vTexcoord.y)).a > 0.0 && texture2D(gm_BaseTexture, vec2(v_vTexcoord.x, v_vTexcoord.y - d.y * 2.0)).a > 0.0) {
				alpha = 1.0;
			}
		}
	}
	
	gl_FragColor = vec4(1.0, 1.0, 1.0, alpha);
}
