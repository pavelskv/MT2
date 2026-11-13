shader_type spatial;

uniform bool enable = true;
uniform sampler2D DEPTH_TEXTURE : hint_depth_texture;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture;
uniform float max_shift = 0.26;
uniform float speed = 0.03;
uniform float min_heathaze_dist = 0.89;


float random( vec2 pos )
{ 
	if (enable) {
		return fract(sin(dot(pos, vec2(12.9898,78.233))) * 43758.5453);
	}
}

float noise( vec2 pos )
{
	if (enable) {
		return random( floor( pos ) );
	}
}

float value_noise( vec2 pos )
{
	if (enable) {
		vec2 p = floor( pos );
		vec2 f = fract( pos );

		float v00 = noise( p + vec2( 0.0, 0.0 ) );
		float v10 = noise( p + vec2( 1.0, 0.0 ) );
		float v01 = noise( p + vec2( 0.0, 1.0 ) );
		float v11 = noise( p + vec2( 1.0, 1.0 ) );

		vec2 u = f * f * ( 3.0 - 2.0 * f );

		return mix( mix( v00, v10, u.x ), mix( v01, v11, u.x ), u.y );
	}
}

void fragment( )
{
	if (enable) 
	{
		float depth = max( texture( DEPTH_TEXTURE, SCREEN_UV ).r - min_heathaze_dist, 0.0 );
		vec2 uv_r = SCREEN_UV + vec2( TIME * speed, 0.0 );
		vec2 uv_g = SCREEN_UV + vec2( -10.0, -TIME * speed );
		vec2 shift = vec2(
			sin(
					value_noise( uv_r * 8.0 ) * 0.2
				+	value_noise( uv_r * 16.0 ) * 0.2
				+	value_noise( uv_r * 32.0 ) * 0.2
				+	value_noise( uv_r * 64.0 ) * 0.2
				+	value_noise( uv_r * 128.0 ) * 0.2
			) - 0.5
		,	sin(
				value_noise( uv_g * 8.0 ) * 0.2
			+	value_noise( uv_g * 16.0 ) * 0.2
			+	value_noise( uv_g * 32.0 ) * 0.2
			+	value_noise( uv_g * 64.0 ) * 0.2
			+	value_noise( uv_g * 128.0 ) * 0.2
			) - 0.5
		) * ( depth * max_shift );
		ALBEDO = texture( SCREEN_TEXTURE, SCREEN_UV + shift ).rgb;
		float depth_shifted = texture( DEPTH_TEXTURE, SCREEN_UV + shift ).r - min_heathaze_dist;

		ALPHA = float( 0.0 < depth_shifted );
		//DEPTH = 0.0;
	}
	else
	{
		ALBEDO = texture( SCREEN_TEXTURE, SCREEN_UV).rgb;
		ALPHA = float(0);
	}
}
