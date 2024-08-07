extern vec2 iResolution;
extern vec2 center;
extern float zoom;

vec2 grad(ivec2 z) {
    int n = z.x + z.y * 11666;

    int temp = n * 4096;
    n = temp - n;
    n = (n - (n / 65536) * 65536);

    temp = n * n;
    temp = temp * 25338;
    temp = temp + 784521;
    temp = temp + 135635569;
    n = (temp - (temp / 65536) * 65536);
    n = (n - (n / 65536) * 65536);

    n = n - (n / 8) * 8;

    vec2 gr;
    float odd = float((n - (n / 2) * 2));
    float halfy = float(n / 2);

    if (n >= 6) {
        gr = vec2(0.0, odd * 2.0 - 1.0);
    } else if (n >= 4) {
        gr = vec2(odd * 2.0 - 1.0, 0.0);
    } else {
        gr = vec2(odd * 2.0 - 1.0, halfy * 2.0 - 1.0);
    }

    return gr;
}

float noise( in vec2 p )
{
    p *= 0.1;
    ivec2 i = ivec2(floor(p));
    vec2 f = fract(p);
    vec2 u = f * f * f * (f * (f * 6.0 - 15.0) + 10.0);
    return mix(mix(dot(grad(i + ivec2(0, 0)), f - vec2(0.0, 0.0)),
                   dot(grad(i + ivec2(1, 0)), f - vec2(1.0, 0.0)), u.x),
               mix(dot(grad(i + ivec2(0, 1)), f - vec2(0.0, 1.0)),
                   dot(grad(i + ivec2(1, 1)), f - vec2(1.0, 1.0)), u.x), u.y);
}

float heightLines(float height, float dist, float width, int steps)
{
    height /= dist;
    float ret = 0.0;
    float dec = 1.0;
    
    for (int i = 0; i < steps; i++)
    {
        int step = int(height);
        if (height - float(step) < width * dec)
            ret += 1.0 / float(steps);
        dec /= 1.2;
        height *= 10.0;
    }
    return clamp(ret, 0.0, 1.0);
}

float heightmap(vec2 uv)
{
    float h = 0.0;
    mat2 m = mat2(1.6, 1.2, -1.2, 1.6) * 0.75;
    int steps = 25;
    float a = 1.0;
    float decay = 1.2;
    for (int i = 0; i < steps; i++)
    {
        h += a * noise(uv); 
        uv = m * uv;
        a /= decay;
        decay += 0.02;
    }
    float exp = 2.0;
    if (h > 0.0)
        h = pow(h, exp);
    else
        h = -pow(-h, exp);
    h = 0.5 + 0.5 * h;
    return h;
}

vec4 effect(vec4 color, Image tex, vec2 texcoord, vec2 pixel_coords)
{
    vec2 p = (texcoord + center/iResolution.xy) / (zoom * iResolution.xy) - vec2(0.5, 0.5);
    vec2 uv = p * vec2(iResolution.x / iResolution.y, 1.0);
    
    float h = heightmap(uv);

    float light = mix(0.3, 1.0, 0.2);
    float col = light * h;


    vec4 colWater = vec4(1, 1, 0.4 * h + 0.88, 1.0);
    h = col + 0.2 * heightLines(0.0, h, 0.04, 4);
       
    if (h < 0.9)
    {
        vec4 colWater = vec4(0.3, 0.4, 0.4 * h + 0.88, 1.0);
        h = col + 0.4 * heightLines(h, 0.2, 0.04, 4);
        color = mix(Texel(tex, texcoord), vec4(h, h, h, 1.0), 0.5);
    }
    else    
    {
        h = col + 0.2 * heightLines(0.0, h, 0.04, 4);
        color =  vec4(h, h, h, 1.0);;
    }

    return color;
}