/*------------------.
| :: Description :: |
'-------------------/

	Template (version 1.0)

	Author: 
	License: 

	About:
  

	Ideas for future improvement:
	* 
	* 
	
	History:
	(*) Feature (+) Improvement	(x) Bugfix (-) Information (!) Compatibility

	Version 1.0
	* 

*/


/*---------------.
| :: Includes :: |
'---------------*/

#include "ReShade.fxh"

/*---------------.
| :: Settings :: |
'---------------*/

uniform int combo
<
	ui_type = "combo";
	ui_label = "combo";
	ui_tooltip = "Choose one";
	//ui_category = "";
	ui_items = 
	"Option 1\0"
	"Option 2\0"
	"Option 3\0";
>
= 0;

uniform float3 color_option
< 
	ui_type = "color";
	ui_label = "Color";
>
= float3(1.00, 0.50, 0.00);

uniform bool Boolean
<
	ui_label = "Boolean";
	ui_tooltip = "On/Off";
>
= false;

uniform float Slider
<
	ui_type = "slider";
	ui_label = "slider";
	ui_tooltip = "Slide";
	ui_min = 0.0; ui_max = 1.0; ui_step = 0.1;
>
= 0.5;

/*---------------.
| :: Textures :: |
'---------------*/

/*---------------.
| :: Samplers :: |
'---------------*/

/*----------------.
| :: Functions :: |
'----------------*/

float3 TemplatePS(float4 vpos : SV_Position, float2 texcoord : TexCoord) : SV_Target
{
  // Sample the color from the framebuffer
	float3 color = tex2D(ReShade::BackBuffer, texcoord).rgb;

  // Do stuff to it


  // Return the result
  return saturate(color);
}

/*-----------------.
| :: Techniques :: |
'-----------------*/

technique Template
{
	pass
	{
		VertexShader = PostProcessVS; // in ReShade.fxh
		PixelShader = TemplatePS;
	}
}

/*-------------.
| :: Footer :: |
'--------------/

A footer can be a good place to place:
* Technical illustrations
* Links to online resources on the subject
* The full text of your license
* Credits if they are long (otherwise I like to put them in the header)
* Anything else that might clutter up the code, but you feel should still be included in the file.

*/
