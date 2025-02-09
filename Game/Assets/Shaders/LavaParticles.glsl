#shader vertex
#version 460 core

layout (location = 0) in vec3 geo_Pos;
layout (location = 1) in vec2 geo_TexCoords;
layout (location = 2) in vec3 geo_Normal;

layout (std140) uniform EngineUBO
{
    mat4    ubo_Model;
    mat4    ubo_View;
    mat4    ubo_Projection;
    vec3    ubo_ViewPos;
    float   ubo_Time;
};

out VS_OUT
{
    vec2 TexCoords;
    flat float Alpha;
} vs_out;

void main()
{
    vec3 offset = vec3(0.0);
    offset.x = (gl_InstanceID % 25) * 5 + cos((ubo_Time  + gl_InstanceID) * 10.0f) * 0.1f + gl_InstanceID % 3;
    offset.y = (ubo_Time * 0.1f + gl_InstanceID * 0.2f + gl_InstanceID % 8) * (14.0f + gl_InstanceID / 20.0f);
    offset.z = (gl_InstanceID * 2) / 10  + gl_InstanceID % 6;

    offset.y = mod(offset.y, 20.0);

    float theta = gl_InstanceID * 100;
    float phi = 1.0f;
    float radius = 10.0f;

    offset += vec3(cos(theta) * cos(phi) * radius, sin(theta) * cos(phi) * radius, sin(phi) * radius);

    vs_out.TexCoords = geo_TexCoords;
    vs_out.Alpha = (20.0 - offset.y) / 20.0;

    float size = clamp(1 - (5.0 - offset.y) / 5.0, 0.0, 1.0) * 2;

    vec3 scale = vec3
    (
        length(vec3(ubo_Model[0][0], ubo_Model[0][1], ubo_Model[0][2])),
        length(vec3(ubo_Model[1][0], ubo_Model[1][1], ubo_Model[1][2])),
        length(vec3(ubo_Model[2][0], ubo_Model[2][1], ubo_Model[2][2]))
    );
    
    mat4 model = ubo_Model;

    model[3][0] += offset.x * scale.x;
    model[3][1] += offset.y * scale.y;
    model[3][2] += offset.z * scale.z;

    mat4 modelView = ubo_View * model;

    // Column 0:
    modelView[0][0] = 1;
    modelView[0][1] = 0;
    modelView[0][2] = 0;

    // Column 1:
    modelView[1][0] = 0;
    modelView[1][1] = 1;
    modelView[1][2] = 0;

    // Column 2:
    modelView[2][0] = 0;
    modelView[2][1] = 0;
    modelView[2][2] = 1;

    gl_Position = ubo_Projection * modelView * vec4((geo_Pos) * (scale * size * vec3(1,1,0)), 1.0);
}

#shader fragment
#version 460 core

out vec4 FRAGMENT_COLOR;

in VS_OUT
{
    vec2 TexCoords;
    flat float Alpha;
} fs_in;

uniform vec4        u_Diffuse = vec4(1.0, 1.0, 1.0, 1.0);
uniform sampler2D   u_DiffuseMap;
uniform vec2        u_TextureTiling;
uniform vec2        u_TextureOffset;

void main()
{
    FRAGMENT_COLOR = textureLod(u_DiffuseMap, u_TextureOffset + vec2(mod(fs_in.TexCoords.x * u_TextureTiling.x, 1), mod(fs_in.TexCoords.y * u_TextureTiling.y, 1)), 2) * u_Diffuse;
    FRAGMENT_COLOR.a *= fs_in.Alpha;
}