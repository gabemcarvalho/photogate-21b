varying vec2 v_texcoord;

uniform float time;

uniform vec2 mouse_pos;
uniform vec2 resolution;

uniform float shock_amplitude;
uniform float shock_refraction;
uniform float shock_width;

void main()
{ 
    vec2 A = vec2( mouse_pos.x/resolution.x, mouse_pos.y/resolution.y ); // Origin of circle
	vec2 B = v_texcoord; // Point to warp
	
	vec2 AB = B - A; // Vector from origin to point
	
	float d_AB = sqrt(pow(AB.x, 2.0) + pow(AB.y, 2.0)); // Distance between origin and point
	vec2 dir = AB / d_AB; // Unit direction from origin to point
	
	float d = abs(d_AB - time); // Shortest distance from circle to point
	
	// Convert distance to gaussian distribution
	float time_coefficient = (1.0 + pow(time*2.0, 2.0)) * shock_refraction;
	float width = 0.003 * time_coefficient;
	float refraction = 0.1 / time_coefficient;
	float gaussian = refraction * exp(-pow(d, 2.0) / width);
	
	// Drop off quickly in the middle
	if (d_AB < 0.12) {
		gaussian /= pow(0.12/d_AB, 3.0);
	}
	
	vec2 texCoord = v_texcoord - shock_amplitude*dir*gaussian;
 
	//gl_FragColor = vec4(vec3( gaussian ),1.0); // black/white test
    gl_FragColor = texture2D(gm_BaseTexture,texCoord);
}