varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform vec2 resolution;

void main()
{
	vec2 d = vec2(1.0/resolution.x, 1.0/resolution.y);
	vec4 sum = vec4(0.0);
	
	int rays = 128;//128
	int steps = 28;
	
	float angle = 0.0;
	float lightDistance = float(steps);
	float mixValue = 0.0;
	float totalMix = 0.0;
	
	vec4 c = texture2D(gm_BaseTexture, v_vTexcoord );
	if (c.a == 1.0) {
		sum = vec4(0.0);
	} else {
		float angularStep = 6.283185/float(rays);
		for (float angle = 0.0; angle < 6.283185; angle += angularStep) {
			for (int i = 1; i <= 28; i++) {		
				c = texture2D(gm_BaseTexture, vec2(v_vTexcoord.x + d.x*float(i)*cos(angle), v_vTexcoord.y + d.y*float(i)*sin(angle)) );
				if (c.a > 0.0) {
					if (c.r+c.g+c.b > 0.0) {
						lightDistance = min(lightDistance, float(i));
						mixValue = (1.0 - float(i) / float(steps));
						sum += c * mixValue * max(c.r, max(c.g, c.b));
						totalMix += mixValue;
					}
					break;
				}
			}
		}
		
		sum /= totalMix;
		sum.a = (1.0 - pow(lightDistance / (float(steps)), 1.2));
	}
	
	gl_FragColor = sum;
}
