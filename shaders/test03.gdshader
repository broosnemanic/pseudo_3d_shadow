shader_type canvas_item;

void vertex() {
	VERTEX.xy *= 1.0;
}

varying vec4 c_color;
varying vec4 m_color;
varying vec4 y_color;
varying vec4 t_color;
varying vec4 total_color;
varying float count;
varying float offset;
varying vec2 trig_offset;
varying float angle;
varying vec2 t_pivot;

uniform float offset_magnitude: hint_range(0.0, 0.2, 0.01);
uniform float alpha: hint_range(0.0, 1.0, 0.1);
uniform float angle_div: hint_range(0.25, 4.0, 0.05);

vec2 rotated_uv(vec2 a_uv, vec2 a_pivot, float a_angle)
{
	mat2 rotation = mat2(vec2(sin(a_angle), -cos(a_angle)),
			vec2(cos(a_angle), sin(a_angle)));

    a_uv -= a_pivot;
    a_uv = a_uv * rotation;
    a_uv += a_pivot;
    return a_uv;
}


void fragment() {

	t_pivot = vec2(0.5, 0.5);
	total_color = texture(TEXTURE, 0.5 * (UV - t_pivot));
	c_color = vec4(1.0, 0.0, 1.0, 0.0);
	m_color = vec4(0.0, 1.0, 1.0, 0.0);
	y_color = vec4(1.0, 1.0, 0.0, 0.0);
	t_color = vec4(0.0);
	count = 1.0;
	//offset = offset_magnitude * sin(TIME * 50.0 * offset_magnitude);
	offset = (0.5 * TIME - 1.0 * trunc(0.5 * TIME));

	if (COLOR.a == 0.0){
		if (texture(TEXTURE, 0.7 * (UV - vec2(offset, 0.0))).a > 0.0){
			c_color.a = alpha;
		}
/*		if (texture(TEXTURE, rotated_uv(UV, 0.2 * sin(TIME) + vec2(0.5, 0.5), TIME * PI / angle_div)).a > 0.0){
			c_color.a = alpha;
		}*/
		if (texture(TEXTURE, UV - vec2(-offset, 0.0)).a > 0.0){
			m_color.a = alpha;
		}
		if (texture(TEXTURE, UV - vec2(0.0, -offset)).a > 0.0){
			y_color.a = alpha;
		}
	}
	if(c_color.a > 0.0){
		t_color += c_color;
		count++;
	};
	if(m_color.a > 0.0){
		t_color += m_color;
		count++;
	};
	if(y_color.a > 0.0){
		t_color += y_color;
		count++;
	};
	if(count > 1.0){
		COLOR = t_color / count;
	}
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
