/*------------------.
| :: Description :: |
'-------------------/

	Nostalgia (version 1.4)

	Author: CeeJay.dk
	License: MIT

	About:
	In this effect I try to recreate the looks of systems from a bygone era.
	I've started with reducing the color to that of systems with 16 color palette.

	Ideas for future improvement:
	* Try HSL / HCY / Lab or other colorspaces. I'm not sure RGB is the best choice for color matching.
	* Pixelation
	* CRT patterns
	* Curvature
	* More Dithering (Bayer matrix etc.)
	* Levels (might be needed because older system were often displayed on televisions and older monitors - not modern monitors)

	History:
	(*) Feature (+) Improvement (x) Bugfix (-) Information (!) Compatibility
	
	Version 1.0 by CeeJay.dk
	* Color reduction to C64 palette

	Version 1.1 by CeeJay.dk
	* Added ability to set a custom palette
	* Added EGA palette
	+ Improved settings UI
	- Commented much of the code

	Version 1.2 by microdee
	+ Added more color palettes from wikipedia
	+ Palettes can have different color counts

	Version 1.3 by CeeJay.dk
	* Added Aek16 palette
	+ Made Nostalgia do color matching in linear space which improves color matching
	* Added checker board dithering
	* Added scanlines

	Version 1.4 (optimized)
	* Dither now works independently of color reduction, and has a strength slider
	* Added "Quantize" color reduction (levels per channel)
	* Added "Color reduction strength" slider
	* Scanlines reworked: 6 distinct types + size and strength sliders
	+ Palette list trimmed to accurate ones (Custom, C64, EGA, CGA, ZX Spectrum, Game Boy)
	x Palettes are now converted to linear space when Nostalgia_linear = 1,
	  so the displayed colors match the palette values (before they came out too bright)
	x ZX Spectrum no longer has a duplicate black
	+ Game Boy palette is matched by brightness instead of RGB distance
*/


/*---------------.
| :: Includes :: |
'---------------*/

#include "ReShade.fxh"
#include "ReShadeUI.fxh"

/*--------------.
| :: Defines :: |
'--------------*/

// Linear color space. Can be changed in ReShade's "Preprocessor definitions"
// (1 = work in linear space, 0 = work directly on the gamma-encoded image).
#ifndef Nostalgia_linear
	#define Nostalgia_linear 1
#endif

/*------------------.
| :: UI Settings :: |
'------------------*/

uniform int Nostalgia_scanlines
<
	ui_type = "combo";
	ui_label = "Scanlines";
	ui_tooltip = "Size is ignored by the Aperture grille type. With Size = 2 the 'Thin lines' and 'Hard bands' types look the same; increase Size to see the difference.";
	ui_items = 
	"None\0"
	"Soft (sine wave)\0"
	"CRT (bright areas bleed over lines)\0"
	"Thin lines (1 px)\0"
	"Hard bands (50% dark)\0"
	"Aperture grille (vertical RGB stripes)\0"
	"Shadow mask (RGB dots)\0";
> = 2;

uniform int Nostalgia_scanline_size
<
	ui_type = "slider";
	ui_label = "Scanline size";
	ui_tooltip = "Distance between lines in pixels.";
	ui_min = 2; ui_max = 8; ui_step = 1;
> = 2;

uniform float Nostalgia_scanline_strength
<
	ui_type = "slider";
	ui_label = "Scanline strength";
	ui_min = 0.0; ui_max = 1.0; ui_step = 0.01;
> = 0.5;

uniform int Nostalgia_color_reduction
<
	ui_type = "combo";
	ui_label = "Color reduction type";
	ui_items = 
	"None\0"
	"Palette\0"
	"Quantize (levels per channel)\0";
> = 0;

uniform float Nostalgia_reduction_strength
<
	ui_type = "slider";
	ui_label = "Color reduction strength";
	ui_tooltip = "0.0 = original image, 1.0 = fully reduced colors. Lower values give a softer, less distorted look.";
	ui_min = 0.0; ui_max = 1.0; ui_step = 0.01;
> = 1.0;

uniform int Nostalgia_palette <
	ui_type = "combo";
	ui_label = "Palette";
	ui_tooltip = "Used when 'Color reduction type' is Palette.";
	ui_items = 
	"Custom\0"
	"C64 (16 colors)\0"
	"EGA (16 colors)\0"
	"CGA (4 colors, cyan/magenta)\0"
	"ZX Spectrum (15 colors)\0"
	"Game Boy (4 greens)\0";
> = 0;

uniform int Nostalgia_levels
<
	ui_type = "slider";
	ui_label = "Quantize levels";
	ui_tooltip = "Number of brightness levels per color channel (used when 'Color reduction type' is Quantize).\n2 = 8 colors, 4 = 64 colors, 8 = 512 colors.";
	ui_min = 2; ui_max = 16; ui_step = 1;
> = 4;

uniform bool Nostalgia_dither 
<
	ui_label = "Dither";
	ui_tooltip = "Checkerboard dither. Works with any color reduction type, and also on its own.";
> = 0;

uniform float Nostalgia_dither_strength
<
	ui_type = "slider";
	ui_label = "Dither strength";
	ui_min = 0.0; ui_max = 0.3; ui_step = 0.005;
> = 0.08;

uniform float3 Nostalgia_color_0 < __UNIFORM_COLOR_FLOAT3
	ui_label = "Color 0";
	ui_category = "Custom palette";
> = float3(  0. ,   0. ,   0. ); //Black;

uniform float3 Nostalgia_color_1 < __UNIFORM_COLOR_FLOAT3
	ui_label = "Color 1";
	ui_category = "Custom palette"; > 
= float3(255. , 255. , 255. ) / 255.; //White

uniform float3 Nostalgia_color_2 < __UNIFORM_COLOR_FLOAT3
	ui_label = "Color 2";
	ui_category = "Custom palette";
> = float3(136. ,   0. ,   0. ) / 255.; //Red;

uniform float3 Nostalgia_color_3 < __UNIFORM_COLOR_FLOAT3
	ui_label = "Color 3";
	ui_category = "Custom palette";
> = float3(170. , 255. , 238. ) / 255.; //Cyan

uniform float3 Nostalgia_color_4 < __UNIFORM_COLOR_FLOAT3
	ui_label = "Color 4";
	ui_category = "Custom palette";
> = float3(204. ,  68. , 204. ) / 255.; //Violet

uniform float3 Nostalgia_color_5 < __UNIFORM_COLOR_FLOAT3
	ui_label = "Color 5";
	ui_category = "Custom palette";
> = float3(  0. , 204. ,  85. ) / 255.; //Green

uniform float3 Nostalgia_color_6 < __UNIFORM_COLOR_FLOAT3
	ui_label = "Color 6";
	ui_category = "Custom palette";
> = float3(  0. ,   0. , 170. ) / 255.; //Blue

uniform float3 Nostalgia_color_7 < __UNIFORM_COLOR_FLOAT3
	ui_label = "Color 7";
	ui_category = "Custom palette";
> = float3(238. , 238. , 119. ) / 255.; //Yellow 1

uniform float3 Nostalgia_color_8 < __UNIFORM_COLOR_FLOAT3
	ui_label = "Color 8";
	ui_category = "Custom palette";
> = float3(221. , 136. ,  85. ) / 255.; //Orange

uniform float3 Nostalgia_color_9 < __UNIFORM_COLOR_FLOAT3
	ui_label = "Color 9";
	ui_category = "Custom palette";
> = float3(102. ,  68. ,   0. ) / 255.; //Brown

uniform float3 Nostalgia_color_10 < __UNIFORM_COLOR_FLOAT3
	ui_label = "Color 10";
	ui_category = "Custom palette";
> = float3(255. , 119. , 119. ) / 255.; //Yellow 2

uniform float3 Nostalgia_color_11 < __UNIFORM_COLOR_FLOAT3
	ui_label = "Color 11";
	ui_category = "Custom palette";
> = float3( 51. ,  51. ,  51. ) / 255.; //Grey 1

uniform float3 Nostalgia_color_12 < __UNIFORM_COLOR_FLOAT3
	ui_label = "Color 12";
	ui_category = "Custom palette";
> = float3(119. , 119. , 119. ) / 255.; //Grey 2

uniform float3 Nostalgia_color_13 < __UNIFORM_COLOR_FLOAT3
	ui_label = "Color 13";
	ui_category = "Custom palette";
> = float3(170. , 255. , 102. ) / 255.; //Lightgreen

uniform float3 Nostalgia_color_14 < __UNIFORM_COLOR_FLOAT3
	ui_label = "Color 14";
	ui_category = "Custom palette";
> = float3(  0. , 136. , 255. ) / 255.; //Lightblue

uniform float3 Nostalgia_color_15 < __UNIFORM_COLOR_FLOAT3
	ui_label = "Color 15";
	ui_category = "Custom palette";
> = float3(187. , 187. , 187. ) / 255.;  //Grey 3

/*--------------.
| :: Sampler :: |
'--------------*/

sampler Linear
{
	Texture = ReShade::BackBufferTex;
	SRGBTexture = true;
};

// 16x1 texture holding the selected palette already converted to the working
// (linear) space. It is filled by a tiny pass once per frame, so the main pass
// doesn't need to rebuild the palette or run pow() on it for every pixel.
texture NostalgiaPaletteTex
{
	Width = 16;
	Height = 1;
	Format = RGBA16F;
};

sampler NostalgiaPaletteSampler
{
	Texture = NostalgiaPaletteTex;
	MagFilter = POINT;
	MinFilter = POINT;
	MipFilter = POINT;
	AddressU = CLAMP;
	AddressV = CLAMP;
};

/*---------------.
| :: Functions :: |
'---------------*/

// Exact sRGB curves (same ones the GPU uses for SRGBTexture / SRGBWriteEnable)
float3 SRGBToLinear(float3 c)
{
	c = saturate(c);
	return lerp(c / 12.92, pow((c + 0.055) / 1.055, 2.4), step(0.04045, c));
}

float3 LinearToSRGB(float3 c)
{
	c = saturate(c);
	return lerp(c * 12.92, 1.055 * pow(c, 1.0 / 2.4) - 0.055, step(0.0031308, c));
}

// Working space -> "what you see on screen" values (0-1, gamma encoded)
float3 ToDisplay(float3 c)
{
	#if Nostalgia_linear == 1
		return LinearToSRGB(c);
	#else
		return c;
	#endif
}

// "What you see on screen" values -> working space
float3 FromDisplay(float3 c)
{
	#if Nostalgia_linear == 1
		return SRGBToLinear(c);
	#else
		return c;
	#endif
}

/*----------------------.
| :: Palette helpers :: |
'----------------------*/

// Number of colors in the selected palette
int PaletteCount()
{
	if (Nostalgia_palette == 3) return 4;  // CGA
	if (Nostalgia_palette == 4) return 15; // ZX Spectrum
	if (Nostalgia_palette == 5) return 4;  // Game Boy
	return 16;
}

// Reads color i of the palette (already in the working space)
float3 GetPalette(int i)
{
	return tex2Dlod(NostalgiaPaletteSampler, float4((float(i) + 0.5) / 16.0, 0.5, 0.0, 0.0)).rgb;
}

// Returns palette color i as you want to SEE it on screen (gamma-encoded values)
float3 GetPaletteDisplayColor(int i)
{
	float3 palette[16] = //Custom palette
	{
		Nostalgia_color_0,
		Nostalgia_color_1,
		Nostalgia_color_2,
		Nostalgia_color_3,
		Nostalgia_color_4,
		Nostalgia_color_5,
		Nostalgia_color_6,
		Nostalgia_color_7,
		Nostalgia_color_8,
		Nostalgia_color_9,
		Nostalgia_color_10,
		Nostalgia_color_11,
		Nostalgia_color_12,
		Nostalgia_color_13,
		Nostalgia_color_14,
		Nostalgia_color_15
	};



	// All palette values below are the colors as you want to SEE them on screen.
	// They are converted to the working space when matching/outputting.

	if (Nostalgia_palette == 1) //C64 palette from http://www.c64-wiki.com/index.php/Color
	{
		palette[0]  = float3(  0. ,   0. ,   0. ) / 255.; //Black
		palette[1]  = float3(255. , 255. , 255. ) / 255.; //White
		palette[2]  = float3(136. ,   0. ,   0. ) / 255.; //Red
		palette[3]  = float3(170. , 255. , 238. ) / 255.; //Cyan
		palette[4]  = float3(204. ,  68. , 204. ) / 255.; //Violet
		palette[5]  = float3(  0. , 204. ,  85. ) / 255.; //Green
		palette[6]  = float3(  0. ,   0. , 170. ) / 255.; //Blue
		palette[7]  = float3(238. , 238. , 119. ) / 255.; //Yellow 1
		palette[8]  = float3(221. , 136. ,  85. ) / 255.; //Orange
		palette[9]  = float3(102. ,  68. ,   0. ) / 255.; //Brown
		palette[10] = float3(255. , 119. , 119. ) / 255.; //Yellow 2
		palette[11] = float3( 51. ,  51. ,  51. ) / 255.; //Grey 1
		palette[12] = float3(119. , 119. , 119. ) / 255.; //Grey 2
		palette[13] = float3(170. , 255. , 102. ) / 255.; //Lightgreen
		palette[14] = float3(  0. , 136. , 255. ) / 255.; //Lightblue
		palette[15] = float3(187. , 187. , 187. ) / 255.; //Grey 3
	}

	if (Nostalgia_palette == 2) //EGA palette
	{
		palette[0] 	= float3(0.0,		0.0,		0.0		); //Black
		palette[1] 	= float3(0.0,		0.0,		0.666667); //Blue
		palette[2] 	= float3(0.0,		0.666667,	0.0		); //Green
		palette[3] 	= float3(0.0,		0.666667,	0.666667); //Cyan
		palette[4] 	= float3(0.666667,	0.0,		0.0		); //Red
		palette[5] 	= float3(0.666667,	0.0,		0.666667); //Magenta
		palette[6] 	= float3(0.666667,	0.333333,	0.0		); //Brown 
		palette[7] 	= float3(0.666667,	0.666667,	0.666667); //Light gray
		palette[8] 	= float3(0.333333,	0.333333,	0.333333); //Dark gray
		palette[9] 	= float3(0.333333,	0.333333,	1.0		); //Bright blue
		palette[10]	= float3(0.333333,	1.0,		0.333333); //Bright green
		palette[11]	= float3(0.333333,	1.0,		1.0		); //Bright cyan
		palette[12]	= float3(1.0,		0.333333,	0.333333); //Bright red
		palette[13]	= float3(1.0,		0.333333,	1.0		); //Bright magenta
		palette[14]	= float3(1.0,		1.0,		0.333333); //Bright yellow
		palette[15]	= float3(1.0,		1.0,		1.0		); //White
	}

	if (Nostalgia_palette == 3) //CGA 4-color mode, palette 1 high intensity
	{
		palette[0] = float3(0.0,		0.0,		0.0		); //Black
		palette[1] = float3(0.333333,	1.0,		1.0		); //Cyan
		palette[2] = float3(1.0,		0.333333,	1.0		); //Magenta
		palette[3] = float3(1.0,		1.0,		1.0		); //White
	}

	if (Nostalgia_palette == 4) //ZX Spectrum palette (15 unique colors, black exists only once)
	{
		// Normal intensity (0xD7)
		palette[0]  = float3(0.0,		0.0,		0.0		); //Black
		palette[1]  = float3(0.0,		0.0,		0.843137); //Blue
		palette[2]  = float3(0.0,		0.843137,	0.0		); //Green
		palette[3]  = float3(0.0,		0.843137,	0.843137); //Cyan
		palette[4]  = float3(0.843137,	0.0,		0.0		); //Red
		palette[5]  = float3(0.843137,	0.0,		0.843137); //Magenta
		palette[6]  = float3(0.843137,	0.843137,	0.0		); //Yellow
		palette[7]  = float3(0.843137,	0.843137,	0.843137); //White
		// Bright (0xFF)
		palette[8]  = float3(0.0,		0.0,		1.0		); //Bright blue
		palette[9]  = float3(0.0,		1.0,		0.0		); //Bright green
		palette[10] = float3(0.0,		1.0,		1.0		); //Bright cyan
		palette[11] = float3(1.0,		0.0,		0.0		); //Bright red
		palette[12] = float3(1.0,		0.0,		1.0		); //Bright magenta
		palette[13] = float3(1.0,		1.0,		0.0		); //Bright yellow
		palette[14] = float3(1.0,		1.0,		1.0		); //Bright white
	}

	if (Nostalgia_palette == 5) //Game Boy (DMG), from darkest to lightest
	{
		palette[0] = float3( 15. ,  56. ,  15. ) / 255.; //#0F380F
		palette[1] = float3( 48. ,  98. ,  48. ) / 255.; //#306230
		palette[2] = float3(139. , 172. ,  15. ) / 255.; //#8BAC0F
		palette[3] = float3(155. , 188. ,  15. ) / 255.; //#9BBC0F
	}

	return palette[clamp(i, 0, 15)];
}

// Runs on a 16x1 render target: one pixel per palette color
float4 PS_Palette(float4 vpos : SV_Position, float2 texcoord : TEXCOORD) : SV_Target
{
	return float4(FromDisplay(GetPaletteDisplayColor(int(vpos.x))), 1.0);
}

/*-------------.
| :: Effect :: |
'-------------*/

float3 PS_Nostalgia(float4 vpos : SV_Position, float2 texcoord : TEXCOORD) : SV_Target
{
	#if Nostalgia_linear == 1
		float3 color = tex2D(Linear, texcoord.xy).rgb;
	#else
		float3 color = tex2D(ReShade::BackBuffer, texcoord.xy).rgb;
	#endif

	uint2 pixel = uint2(vpos.xy);

	// :: Dither :: //
	// Checkerboard shift, applied in gamma space so the strength looks even in
	// dark and bright areas. Independent of the color reduction setting.

	[branch] if (Nostalgia_dither)
	{
		float checker = float((pixel.x + pixel.y) % 2u) * 2.0 - 1.0; // -1 or +1
		color = FromDisplay(saturate(ToDisplay(color) + checker * Nostalgia_dither_strength));
	}

	// :: Color reduction :: //

	[branch] if (Nostalgia_color_reduction == 1) // Palette
	{
		float3 reduced;

		[branch] if (Nostalgia_palette == 5)
		{
			// All four colors are greens, so RGB distance would pick colors by hue.
			// Match by brightness instead - this is what gives the real Game Boy look.
			float grey = dot(ToDisplay(color), float3(0.299, 0.587, 0.114));
			int idx = min(int(saturate(grey) * 4.0), 3);
			reduced = GetPalette(idx);
		}
		else
		{
			// :: Color matching (in the working space) :: //

			int colorCount = PaletteCount();
			float3 closest_color = GetPalette(0);
			float3 diff = color - closest_color;
			float closest_dist = dot(diff, diff); //squared distance - no need for the square root

			[loop] for (int i = 1; i < colorCount; i++)
			{
				float3 pal = GetPalette(i);
				diff = color - pal;
				float dist = dot(diff, diff);

				if (dist < closest_dist)
				{
					closest_dist = dist;
					closest_color = pal;
				}
			}

			reduced = closest_color;
		}

		color = lerp(color, reduced, Nostalgia_reduction_strength);
	}

	[branch] if (Nostalgia_color_reduction == 2) // Quantize
	{
		float steps = float(max(Nostalgia_levels, 2)) - 1.0;
		float3 d = ToDisplay(color);
		d = floor(d * steps + 0.5) / steps;
		color = lerp(color, FromDisplay(d), Nostalgia_reduction_strength);
	}

	// :: Scanlines :: //

	[branch] if (Nostalgia_scanlines > 0)
	{
		uint size = uint(max(Nostalgia_scanline_size, 2));
		uint row = pixel.y;
		uint col = pixel.x;
		float phase = float(row % size) / float(size); // 0.0 .. <1.0 inside one line period
		float strength = Nostalgia_scanline_strength;

		[branch] if (Nostalgia_scanlines <= 4)
		{
			float mask = 0.0; // 0 = untouched, 1 = fully dark

			[branch] if (Nostalgia_scanlines == 1) // Soft (sine wave)
			{
				mask = 0.5 - 0.5 * cos(phase * 6.2831853);
			}
			else if (Nostalgia_scanlines == 2) // CRT: bright pixels bleed over the dark lines
			{
				float grey = dot(ToDisplay(color), float3(0.299, 0.587, 0.114));
				mask = (0.5 - 0.5 * cos(phase * 6.2831853)) * (1.0 - 0.75 * grey);
			}
			else if (Nostalgia_scanlines == 3) // Thin lines (1 px)
			{
				mask = ((row % size) == (size - 1u)) ? 1.0 : 0.0;
			}
			else // Hard bands (50% dark)
			{
				mask = (phase >= 0.5) ? 1.0 : 0.0;
			}

			color *= 1.0 - strength * mask;
		}
		else
		{
			// RGB stripe / dot masks. Dim the two other channels and compensate the
			// average brightness so the picture does not get much darker.
			float dim = 0.4;
			float comp = (1.0 + 2.0 * dim) / 3.0;
			uint idx;
			float gap = 1.0;

			[branch] if (Nostalgia_scanlines == 5) // Aperture grille (vertical RGB stripes)
			{
				idx = col % 3u;
			}
			else // Shadow mask (RGB dots, every other row shifted, dark gap between rows)
			{
				idx = (col + 2u * ((row / size) % 2u)) % 3u;
				gap = ((row % size) == (size - 1u)) ? 0.5 : 1.0;
			}

			float3 ch = float3(idx == 0u ? 1.0 : 0.0, idx == 1u ? 1.0 : 0.0, idx == 2u ? 1.0 : 0.0);
			float3 stripe = (dim + (1.0 - dim) * ch) / comp * gap;

			color *= lerp(float3(1.0, 1.0, 1.0), stripe, strength);
		}
	}

	return saturate(color); //return the pixel
}


/*----------------.
| :: Technique :: |
'----------------*/

technique Nostalgia
{
	// Pass 1: builds the (linear) palette texture - only 16 pixels
	pass PalettePass
	{
		VertexShader = PostProcessVS;
		PixelShader = PS_Palette;
		RenderTarget = NostalgiaPaletteTex;
	}

	// Pass 2: the actual effect
	pass NostalgiaPass
	{
		VertexShader = PostProcessVS;
		PixelShader = PS_Nostalgia;
		
		#if Nostalgia_linear == 1
			SRGBWriteEnable = true;
		#endif	
		
		ClearRenderTargets = false;
	}
}
