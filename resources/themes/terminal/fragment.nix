{ extlib, ... }: let
    inherit (extlib.colourUtils) rgb255ToFloat hexToRgb rgbFloatToVec4;
    hexToVec4 = colour: rgbFloatToVec4 (rgb255ToFloat (hexToRgb colour));
in activeTheme: let
    col_bg = hexToVec4 activeTheme.colour.mainBg;
    col_fg = hexToVec4 activeTheme.colour.mainFg;
in ''
#version 330

uniform vec2 resolution;
uniform float time;
uniform float scale;

const float PI = 3.14159265;

#define PIXELATION 1
#define PIX_RES 150.0

#define COL_BG ${col_bg}
#define COL_MAIN ${col_fg}


float linesegdist(vec2 p, vec2 a, vec2 b)
{
    return distance(p, clamp(dot(p - a, b - a) / dot(b - a, b - a), 0.0, 1.0) * (b - a) + a);
}

vec3 rot(vec3 p, vec3 ax, float angle)
{
    ax = normalize(ax);
    vec3 proj = dot(ax, p) * ax;
    vec3 rejection = p - proj;

    float c = cos(angle);
    float s = sin(angle);

    vec3 normal = cross(ax, p);

    return proj + normal * s + rejection * c;
}

vec2 perspective(vec3 p)
{
    float focal = 5.0;
    return focal * p.xy / (focal + p.z);
}

void main(void)
{
    vec2 uv = (2.0 * gl_FragCoord.xy - resolution.xy) / resolution.y / scale;

    #if PIXELATION
    uv = round(uv * PIX_RES) / PIX_RES;
    #endif

    vec4 color = vec4(0.0);

    float mindist = 9e9;

    float t0 = 0.2 * time;
    float t1 = t0 * 2.0;
    float t2 = t1 * 2.0;

    vec3 rot_axis = vec3(
        -0.75 + 0.25 * sin(0.5 * t2),
        0.0 + 0.15 * sin(0.2 * t2),
        1.0
    );

    float rot_angle = radians(45.0);

    for (int axis = 0; axis < 3; ++axis)
    {
        for (int i = 0; i < 4; ++i)
        {
            vec3 p0, p1;
            vec3 pa, pb;

            p0[(axis + 1) % 3] = float(i & 1) * 2.0 - 1.0;
            p0[(axis + 2) % 3] = float((i / 2) & 1) * 2.0 - 1.0;

            p1 = p0;

            p0[axis] = -1.0;
            p1[axis] = 1.0;

            p0 *= 0.5;
            p1 *= 0.5;

            pa = rot(p0, rot_axis, rot_angle + t0);
            pb = rot(p1, rot_axis, rot_angle + t0);

            float d = linesegdist(uv, perspective(pa), perspective(pb));
            mindist = min(mindist, d);

            p0 *= 0.6;
            p1 *= 0.6;

            pa = rot(p0, rot_axis, rot_angle + t1);
            pb = rot(p1, rot_axis, rot_angle + t1);

            d = linesegdist(uv, perspective(pa), perspective(pb));
            mindist = min(mindist, d);

            p0 *= 0.4;
            p1 *= 0.4;

            pa = rot(p0, rot_axis, rot_angle + t2);
            pb = rot(p1, rot_axis, rot_angle + t2);

            d = linesegdist(uv, perspective(pa), perspective(pb));
            mindist = min(mindist, d);
        }
    }

    const float percent = 0.01;
    float pix_size = 2.0 / resolution.y;

    #if PIXELATION
    pix_size = 1.0 / PIX_RES;
    #endif

    float linethickness = 1.0 * percent;
    float alpha = smoothstep(pix_size + linethickness / 2.0, linethickness / 2.0, mindist);

    color = mix(COL_BG, COL_MAIN, alpha);

    float glow_shift = pix_size + 0.015 + 0.9 * pix_size * sin(2.0 * t2);

    alpha = smoothstep(glow_shift + linethickness / 2.0, linethickness / 2.0, mindist) - 0.8 * alpha;
    color = mix(color, COL_MAIN, 0.3 * alpha);

    gl_FragColor = color;
}
''
