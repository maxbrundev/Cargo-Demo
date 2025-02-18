#shader vertex
#version 460 core

layout (location = 0) in vec3 geo_Pos;

void main()
{
    gl_Position = vec4(geo_Pos * 2.0, 1.0);
}

#shader fragment
#version 460 core

out vec4 FRAGMENT_COLOR;

layout (std140) uniform EngineUBO
{
    mat4    ubo_Model;
    mat4    ubo_View;
    mat4    ubo_Projection;
    vec3    ubo_ViewPos;
    float   ubo_Time;
    mat4    ubo_UserData;
};

uniform vec3 u_FadeColor = vec3(1.0);

void main()
{
    FRAGMENT_COLOR = vec4(u_FadeColor, ubo_UserData[0][0]);
}