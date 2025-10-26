//
//  Shaders.metal
//  Antikythera
//
//  Metal shaders for rendering the Antikythera Mechanism
//

#include <metal_stdlib>
using namespace metal;

// MARK: - Structures

struct Uniforms {
    float4x4 modelViewProjectionMatrix;
    float4 color;
};

struct VertexIn {
    float3 position [[attribute(0)]];
};

struct VertexOut {
    float4 position [[position]];
    float4 color;
};

// MARK: - Vertex Shader

vertex VertexOut vertex_main(VertexIn in [[stage_in]],
                             constant Uniforms &uniforms [[buffer(1)]]) {
    VertexOut out;

    // Transform vertex position by MVP matrix
    out.position = uniforms.modelViewProjectionMatrix * float4(in.position, 1.0);

    // Pass color through to fragment shader
    out.color = uniforms.color;

    return out;
}

// MARK: - Fragment Shader

fragment float4 fragment_main(VertexOut in [[stage_in]]) {
    return in.color;
}
