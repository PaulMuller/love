extern float iTime;
extern vec2 iResolution;
extern vec2 iMouse;

vec4 effect(vec4 color, Image tex, vec2 texcoord, vec2 pixel_coords)
{
    // float waveStrength = 0.02;
    // float frequency = 30.0;
    // float waveSpeed = 5.0;
    // vec4 sunlightColor = vec4(1.0, 0.91, 0.75, 1.0);
    // float sunlightStrength = 5.0;
    // float centerLight = 2.0;
    // float oblique = 0.25;

    // vec2 tapPoint = vec2(iMouse.x, iMouse.y);
    // vec2 uv = texcoord.xy / iResolution.xy;
    // float modifiedTime = iTime * waveSpeed;
    // float aspectRatio = iResolution.x / iResolution.y;
    // vec2 distVec = uv - tapPoint;
    // distVec.x *= aspectRatio;
    // float distance = length(distVec);

    // float multiplier = (distance < 1.0) ? ((distance - 1.0) * (distance - 1.0)) : 0.0;
    // float addend = (sin(frequency * distance - modifiedTime) + centerLight) * waveStrength * multiplier;
    // vec2 newTexCoord = uv + addend * oblique;

    // vec4 colorToAdd = sunlightColor * sunlightStrength * addend;

    // vec4 Color = Texel(tex, texcoord);
    // return Color;
}