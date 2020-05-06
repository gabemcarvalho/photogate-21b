varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform vec2 resolution;
uniform int rays; // note: the rays are 3 pixels wide, so multiply this number by 3
uniform int steps;
uniform float transparency;

void main()
{
	// This is meant to be a more lightweight, monochrome version of the raycast shader
	// It only lights surfaces that are pure white
	vec2 d = vec2(1.0/resolution.x, 1.0/resolution.y);
	vec4 sum = vec4(1.0, 1.0, 1.0, 0.0);
	
	float angle = 0.0;
	int hits = 0;
	
	vec4 c = texture2D(gm_BaseTexture, v_vTexcoord );
	if (c.a != 1.0) {
		float angularStep = 6.283185/float(rays);
		for (float angle = 0.0; angle < 6.283185; angle += angularStep) {
			// Wide ray code
			for (int i = 1; i <= steps; i++) {	
				hits = 0;
				
				c = texture2D(gm_BaseTexture, vec2(v_vTexcoord.x + d.x*float(i)*cos(angle), v_vTexcoord.y + d.y*float(i)*sin(angle)) );
				if (c.a > 0.0) {
					if (c.r+c.g+c.b == 3.0) sum.a = max(1.0 - float(i) / float(steps), sum.a);
					hits++;
				}
				
				c = texture2D(gm_BaseTexture, vec2(v_vTexcoord.x + d.x*float(i)*cos(angle + angularStep), v_vTexcoord.y + d.y*float(i)*sin(angle + angularStep)) );
				if (c.a > 0.0) {
					if (c.r+c.g+c.b == 3.0) sum.a = max(1.0 - float(i) / float(steps), sum.a);
					hits++;
				}
				
				c = texture2D(gm_BaseTexture, vec2(v_vTexcoord.x + d.x*float(i)*cos(angle - angularStep), v_vTexcoord.y + d.y*float(i)*sin(angle - angularStep)) );
				if (c.a > 0.0) {
					if (c.r+c.g+c.b == 3.0) sum.a = max(1.0 - float(i) / float(steps), sum.a);
					hits++;
				}
				
				if (hits == 3) break;
			}
		}
		
		sum.a *= (1.0 - transparency);
	}
	
	gl_FragColor = sum;
}
