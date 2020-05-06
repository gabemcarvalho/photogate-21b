varying vec2 v_vTexcoord;
varying vec4 v_vColour;

vec3 rgb2hsv(vec3 RGB) {
 	float Cmax = max(RGB.r, max(RGB.g, RGB.b));
 	float Cmin = min(RGB.r, min(RGB.g, RGB.b));
 	float delta = Cmax - Cmin;

 	vec3 hsv = vec3(0., 0., Cmax);

 	if (Cmax > Cmin) {
 		hsv.y = delta / Cmax;

 		if (RGB.r == Cmax)
 			hsv.x = (RGB.g - RGB.b) / delta;
 		else {
 			if (RGB.g == Cmax)
 				hsv.x = 2. + (RGB.b - RGB.r) / delta;
 			else
 				hsv.x = 4. + (RGB.r - RGB.g) / delta;
 		}
 		hsv.x = fract(hsv.x / 6.);
 	}
 	return hsv;
}

vec3 hsv2rgb(vec3 c)
{
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

void main()
{
	vec4 Colour = v_vColour * texture2D( gm_BaseTexture, v_vTexcoord );
	
	vec3 colHSV = rgb2hsv(Colour.rgb);
	//colHSV.y = 1.0;
	//Colour.a = colHSV.z;
	float v = colHSV.z;
	colHSV.z = 1.0;
	//Colour.rgb = hsv2rgb(colHSV);

	gl_FragColor = vec4(hsv2rgb(colHSV), v);
}
