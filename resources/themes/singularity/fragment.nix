{ extlib, ... }: let
    inherit (extlib.colourUtils) rgb255ToFloat hexToRgb rgbFloatToVec4;
    hexToVec4 = colour: rgbFloatToVec4 (rgb255ToFloat (hexToRgb colour));
in activeTheme: let
    col_bg = hexToVec4 activeTheme.colour.mainBg;
    col_fg = hexToVec4 activeTheme.colour.mainFg;
in ''
// SOURCE : https://www.shadertoy.com/view/3csSWB

uniform float time;
uniform float scale;
uniform vec2 resolution;

#define COL_BG ${col_bg}
#define COL_MAIN ${col_fg}

#define PIX_FACTOR (72.0)
#define PIX_BLEND_FACTOR (0.75)
#define IGN_BLEND_FACTOR (0.6)
#define IGN_SCALE (2.0)

float interleaved_gradient_noise(vec2 p)
{
    return fract(52.9829189 * fract(0.06711056 * p.x + 0.00583715 * p.y));
}

void main(void) {
    vec2 uv = gl_FragCoord.xy;
    vec4 col = vec4(0.0), pcol = vec4(0.0);

    float i = 0.2, pi = 0.2, a, pa;

    vec2 p = (uv + uv - resolution) / resolution.y / 0.6 / scale,
         pp = floor(p * PIX_FACTOR) / PIX_FACTOR,
         d = vec2(-0.75, 0.75 + 0.25 * sin(time * 0.2)) + 0.05 * sin(time * 2.0) * vec2(1.0, -1.0),
         f = -d,
         b = p - i * d,
         pb = pp - i * d,
         c = p * mat2(1, 1, d / (0.1 + i / dot(b, b))),
         pc = pp * mat2(1, 1, d / (0.1 + i / dot(pb, pb))),
         v = c * mat2(cos(0.5 * log(a = dot(c, c)) + time * 0.5 * i + vec4(0, 33, 11, 0))) / i,
         pv = pc * mat2(cos(0.5 * log(pa = dot(pc,pc)) + time * 0.5 * i + vec4(0, 33, 11, 0))) / i,
         w, pw;

    for (; i++ < 9.0; w += 1.0 + sin(v)) {
        v += 0.7 * sin(v.yx * i + time * 0.5) / i + 0.5;
    }

	for(; pi++ < 9.0; pw += 1.0 + sin(pv)) {
        pv += 0.7 * sin(pv.yx * pi + time * 0.5) / pi + 0.5;
	}

    i = length(sin(v / 0.3) * 0.4 + c * (3.0 + d));
    pi = length(sin(pv / 0.3) * 0.4 + pc * (3.0 + d));

    col = 1.0 - exp(-exp(c.x * vec4(0.6, -0.4, -1.0, 0))
          / w.xyyx
          / (2.0 + i * i / 4.0 - i)
          / (0.5 + 1.0 / a)
          / (0.03 + abs(length(p) - 0.7))
        );

    pcol = 1.0 - exp(-exp(pc.x * vec4(0.6, -0.4, -1.0, 0))
          / pw.xyyx
          / (2.0 + pi * pi / 4.0 - pi)
          / (0.5 + 1.0 / pa)
          / (0.03 + abs(length(pp) - 0.7))
        );

    col = mix(COL_BG, COL_MAIN, (col.x + col.y + col.z) / 3.5);
    col = max(col, COL_BG);

    pcol = mix(COL_BG, COL_MAIN, (pcol.x + pcol.y + pcol.z) / 3.5);
    pcol = max(pcol, COL_BG);

	vec4 ign_col = mix(col, col * interleaved_gradient_noise(p * PIX_FACTOR * IGN_SCALE + 0.5), IGN_BLEND_FACTOR);
    col = mix(ign_col, pcol, PIX_BLEND_FACTOR);

    gl_FragColor = col;
}
''
