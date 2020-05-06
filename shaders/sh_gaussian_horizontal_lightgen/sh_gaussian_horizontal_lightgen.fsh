varying vec2 v_vTexcoord;
varying vec4 v_vsum;

uniform vec2 resolution;
uniform float blur_amount;

void main()
{ 
float blurSize = 1.0/resolution.x * blur_amount;

	vec4 sum = vec4(0.0);
	sum += texture2D(gm_BaseTexture, vec2(v_vTexcoord.x - 4.0*blurSize,	v_vTexcoord.y)) * 0.06;
	sum += texture2D(gm_BaseTexture, vec2(v_vTexcoord.x - 3.0*blurSize,	v_vTexcoord.y)) * 0.09;
	sum += texture2D(gm_BaseTexture, vec2(v_vTexcoord.x - 2.0*blurSize,	v_vTexcoord.y)) * 0.12;
	sum += texture2D(gm_BaseTexture, vec2(v_vTexcoord.x - blurSize,		v_vTexcoord.y)) * 0.15;
	sum += texture2D(gm_BaseTexture, v_vTexcoord)										* 0.16;
	sum += texture2D(gm_BaseTexture, vec2(v_vTexcoord.x + blurSize,		v_vTexcoord.y)) * 0.15;
	sum += texture2D(gm_BaseTexture, vec2(v_vTexcoord.x + 2.0*blurSize,	v_vTexcoord.y)) * 0.12;
	sum += texture2D(gm_BaseTexture, vec2(v_vTexcoord.x + 3.0*blurSize,	v_vTexcoord.y)) * 0.09;
	sum += texture2D(gm_BaseTexture, vec2(v_vTexcoord.x + 4.0*blurSize,	v_vTexcoord.y)) * 0.06;
   
	gl_FragColor = sum;
}

