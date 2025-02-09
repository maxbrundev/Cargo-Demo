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

void main()
{
    gl_Position = ubo_Projection * ubo_View * ubo_Model * vec4(geo_Pos, 1.0);
}

#shader fragment
#version 460 core

layout (std140) uniform EngineUBO
{
    mat4    ubo_Model;
    mat4    ubo_View;
    mat4    ubo_Projection;
    vec3    ubo_ViewPos;
    float   ubo_Time;
    mat4    ubo_UserMatrix;
};

out vec4 FRAGMENT_COLOR;

void main()
{
    vec3 color = normalize(ubo_UserMatrix[3].rgb);
    FRAGMENT_COLOR = vec4(color, 1.0);
}