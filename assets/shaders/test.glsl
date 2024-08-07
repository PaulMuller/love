extern vec2 iResolution;
extern vec2 iMouse;
// extern float iTime;
extern vec2 waveOrigin;
extern float waveDirection;

vec4 effect(vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords)
{
    vec2 u = screen_coords;
    vec2 R = iResolution;
    vec2 M = length(iMouse) > 10.0 ? iMouse / R : vec2(0.55, 0.7);
    float d = 2.0 / R.y;
    vec4 O = vec4(0.0);

    // Calculate direction vector
    vec2 dir = vec2(cos(waveDirection), sin(waveDirection));

    for(float x = 0.0; x < 5.0; x += d)
    {
        // Calculate position relative to wave origin
        vec2 pos = (u - waveOrigin) / R.y;
        
        // Project position onto direction vector
        float proj = dot(pos, dir);

        // Calculate wave effect
        float l = length(pos - dir * (proj - x + 1.2));
        float v = (l - 2.0 * M.x) / exp2(7.0 + 5.0 * M.y);
        O -= cos(27.8 * x / sqrt(l)) / l / exp(v * v * 3e6) * d * 0.34;
    }

    return O + 0.5;
}