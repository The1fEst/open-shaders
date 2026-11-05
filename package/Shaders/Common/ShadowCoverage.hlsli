#ifndef SHADOW_COVERAGE_HLSLI
#define SHADOW_COVERAGE_HLSLI

namespace ShadowCoverage
{
	static const float NativeFadeStartFraction = 0.8;
	static const float CascadeBlendStartFraction = 0.8;

	// An implicit float-to-uint select used as a slice coordinate reaches the GPU as the fractional value on DXVK with NVIDIA, which rounds to the far slice at 0.5 while the projection stays on the near cascade.
	uint GetPrimaryCascade(float cascadeSelect)
	{
		return cascadeSelect >= 1.0 ? 1u : 0u;
	}

	float GetCascadeBlendStart(float farCascadeStart, float nearCascadeEnd)
	{
		return min(farCascadeStart, nearCascadeEnd * CascadeBlendStartFraction);
	}
}

#endif
