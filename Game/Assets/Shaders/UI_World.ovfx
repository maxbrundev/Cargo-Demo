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
} vs_out;

void main()
{
    vs_out.TexCoords = geo_TexCoords;

    vec3 scale = vec3
    (
        length(vec3(ubo_Model[0][0], ubo_Model[0][1], ubo_Model[0][2])),
        length(vec3(ubo_Model[1][0], ubo_Model[1][1], ubo_Model[1][2])),
        length(vec3(ubo_Model[2][0], ubo_Model[2][1], ubo_Model[2][2]))
    );
    
    mat4 model = ubo_Model;

    model[3][0] += scale.x;
    model[3][1] += scale.y;
    model[3][2] += scale.z;

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

    gl_Position = ubo_Projection * modelView * vec4((geo_Pos) * (scale * vec3(1,1,0)), 1.0);
}

#shader fragment
#version 460 core

out vec4 FRAGMENT_COLOR;

in VS_OUT
{
    vec2 TexCoords;
} fs_in;

uniform vec4        u_Diffuse = vec4(1.0, 1.0, 1.0, 1.0);
uniform sampler2D   u_DiffuseMap;
uniform vec2        u_TextureTiling = vec2(1.0, 1.0);
uniform vec2        u_TextureOffset = vec2(0.0, 0.0);

void main()
{
    FRAGMENT_COLOR = textureLod(u_DiffuseMap, u_TextureOffset + vec2(mod(fs_in.TexCoords.x * u_TextureTiling.x, 1), mod(fs_in.TexCoords.y * u_TextureTiling.y, 1)), 0   ) * u_Diffuse;
}