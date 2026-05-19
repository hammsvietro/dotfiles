precision mediump float;
varying vec2 v_texcoord;
uniform sampler2D tex;

vec3 saturateColor(vec3 color, float amount) {
    const vec3 luminanceWeight = vec3(0.2126, 0.7152, 0.0722);
    float luminance = dot(color, luminanceWeight);
    return mix(vec3(luminance), color, amount);
}

void main() {
    vec4 pixel = texture2D(tex, v_texcoord);
    pixel.rgb = saturateColor(pixel.rgb, 1.55);
    gl_FragColor = pixel;
}
