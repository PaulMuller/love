extern number zoom;
extern number textureOffsetX;
extern number textureOffsetY;

vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords){
    float zoomedCoordsX = textureOffsetX + texture_coords.x / zoom;
    float zoomedCoordsY = textureOffsetY + texture_coords.y / zoom;

    vec2 tiledCoords = fract(vec2(zoomedCoordsX, zoomedCoordsY));

    return Texel(texture, tiledCoords) * color;
}