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
    mat4    ubo_UserMatrix;
};

out VS_OUT
{
    vec2 TexCoords;
} vs_out;

uniform vec2 offset = vec2(0.0);
uniform vec2 scale = vec2(1.0);

void main()
{
    vs_out.TexCoords = geo_TexCoords;

    vec2 realScale = scale * ubo_UserMatrix[0][0];

    gl_Position = vec4((geo_Pos + vec3(offset / realScale, 0.0)) * vec3(realScale, 1.0), 1.0);
}

#shader fragment
#version 460 core

out vec4 FRAGMENT_COLOR;

in VS_OUT
{
    vec2 TexCoords;
} fs_in;

layout (std140) uniform EngineUBO
{
    mat4    ubo_Model;
    mat4    ubo_View;
    mat4    ubo_Projection;
    vec3    ubo_ViewPos;
    float   ubo_Time;
    mat4    ubo_UserMatrix;
};

uniform vec4        u_Diffuse = vec4(1.0, 1.0, 1.0, 1.0);
uniform sampler2D   u_DiffuseMap;
uniform vec2        u_TextureTiling = vec2(1.0, 1.0);
uniform vec2        u_TextureOffset = vec2(0.0, 0.0);

void main()
{
    vec4 finalDiffuse = u_Diffuse;
    finalDiffuse.b = ubo_UserMatrix[0][1];

    FRAGMENT_COLOR = textureLod(u_DiffuseMap, u_TextureOffset + vec2(mod(fs_in.TexCoords.x * u_TextureTiling.x, 1), mod(fs_in.TexCoords.y * u_TextureTiling.y, 1)), 0) * finalDiffuse;
}