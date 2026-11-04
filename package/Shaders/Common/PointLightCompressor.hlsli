#ifndef POINT_LIGHT_COMPRESSOR_HLSLI
#define POINT_LIGHT_COMPRESSOR_HLSLI

#include "Common/Color.hlsli"

#if defined(PSHADER)
namespace PointLightCompressor
{
	static const float KneeWidthStops = 1.0;

	float3 GetIrradiance(float3 lightColor)
	{
#	if defined(TRUE_PBR)
		return lightColor * (Color::VanillaNormalization() / Color::PBRLightingCompensation);
#	else
		return lightColor * Color::VanillaNormalization();
#	endif
	}

	float GetScale(float3 irradiance)
	{
		const float threshold = SharedData::lightLimitFixSettings.CombinedLightThreshold;
		const float ratio = SharedData::lightLimitFixSettings.CombinedLightRatio;
		const float peak = max(irradiance.r, max(irradiance.g, irradiance.b));
		if (threshold <= 0.0 || ratio <= 1.0 || !(peak > threshold))
			return 1.0;

		const float stops = log2(peak / threshold);
		const float curve = stops < KneeWidthStops ? stops * stops / (2.0 * KneeWidthStops) : stops - 0.5 * KneeWidthStops;
		return exp2((1.0 / ratio - 1.0) * curve);
	}
}
#endif

#endif
