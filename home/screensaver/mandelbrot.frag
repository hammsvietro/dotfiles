#ifdef GL_ES
precision highp float;
#endif

uniform vec2 u_resolution;
uniform float u_time;

const float CYCLE = 8.0;
const float FADE = 0.16;
const float LO = 4.5;
const float HI = 8.0;

vec3 palette(float t) {
    vec3 a = vec3(0.5, 0.5, 0.5);
    vec3 b = vec3(0.5, 0.5, 0.5);
    vec3 c = vec3(1.0, 1.0, 1.0);
    vec3 d = vec3(0.00, 0.10, 0.20);
    return a + b * cos(6.28318 * (c * t + d));
}

// A different boundary location each cycle, so every crossfade lands somewhere new.
vec2 pickCenter(float i) {
    int k = int(mod(i, 6.0));
    if (k == 0) return vec2(-0.743643887037151, 0.131825904205330);
    if (k == 1) return vec2(-0.101096363845620, 0.956286510809140);
    if (k == 2) return vec2( 0.292575500000000, -0.014997700000000);
    if (k == 3) return vec2(-1.250660000000000, 0.020120000000000);
    if (k == 4) return vec2(-0.170337000000000, -1.065060000000000);
    return vec2(-0.235125000000000, 0.827215000000000);
}

vec3 mandel(vec2 uv, vec2 center, float zt) {
    float zoom = exp(-zt);
    vec2 c = center + uv * zoom * 3.0;

    vec2 z = vec2(0.0);
    const int MAX_ITER = 384;
    int iter = 0;
    for (int i = 0; i < MAX_ITER; i++) {
        z = vec2(z.x * z.x - z.y * z.y, 2.0 * z.x * z.y) + c;
        if (dot(z, z) > 256.0) break;
        iter++;
    }

    if (iter >= MAX_ITER) {
        return vec3(0.0);
    }
    float sn = float(iter) - log2(log2(dot(z, z))) + 4.0;
    return palette(0.05 * sn + 0.1 * u_time);
}

vec3 sampleColor(vec2 fragCoord) {
    vec2 uv = (fragCoord - 0.5 * u_resolution.xy) / u_resolution.y;

    // Spin: rotate the sampling grid clockwise so the image spins
    // counter-clockwise (flip the sign of `a` to reverse).
    float a = u_time * 0.15;
    float ca = cos(a), sa = sin(a);
    uv = mat2(ca, -sa, sa, ca) * uv;

    float ph = fract(u_time / CYCLE);
    float cyc = floor(u_time / CYCLE);

    // Current stream keeps zooming in (zt LO -> HI). In the last FADE of the
    // cycle, the next location's stream starts its own zoom-in and we cross-
    // dissolve straight into it — both zooming, never through black. At ph=1
    // the next stream is exactly the current stream at ph=0, so it's seamless.
    vec3 colA = mandel(uv, pickCenter(cyc), mix(LO, HI, ph));
    float w = smoothstep(1.0 - FADE, 1.0, ph);
    if (w > 0.0) {
        vec3 colB = mandel(uv, pickCenter(cyc + 1.0), mix(LO, HI, ph - 1.0));
        return mix(colA, colB, w);
    }
    return colA;
}

void main() {
    const int AA = 2;
    vec3 col = vec3(0.0);
    for (int m = 0; m < AA; m++) {
        for (int n = 0; n < AA; n++) {
            vec2 off = (vec2(float(m), float(n)) + 0.5) / float(AA) - 0.5;
            col += sampleColor(gl_FragCoord.xy + off);
        }
    }
    col /= float(AA * AA);

    gl_FragColor = vec4(col, 1.0);
}
