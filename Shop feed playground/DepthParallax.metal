#include <metal_stdlib>
using namespace metal;

/// Displaces pixels based on a depth map and device tilt to create a parallax effect.
/// Near objects (white in depth map) shift more; far objects (black) stay anchored.
[[ stitchable ]] float2 depthParallax(
    float2 position,
    float4 bounds,
    texture2d<half, access::sample> depthMap,
    float2 tilt,
    float intensity
) {
    float2 size = bounds.zw;
    float2 origin = bounds.xy;
    float2 uv = (position - origin) / size;
    uv = clamp(uv, float2(0.0), float2(1.0));

    constexpr sampler s(filter::linear, address::clamp_to_edge);
    float depth = float(depthMap.sample(s, uv).r);

    float2 offset = tilt * depth * intensity;
    return position + offset;
}
