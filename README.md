 .--------------------------------------------------.
 
          .-.                   .  .---..   .
         (   )                 _|_ |     \ / 
          `-..  .    ._.-.  .-. |  |---   /  
         (   )\  \  / (.-' (.-' |  |     / \ 
          `-'  `' `'   `--' `--'`-''    '   '
                    Shader Suite
                    by CeeJay.dk                    
 '--------------------------------------------------'
 
 - Version 1.6

SweetFX is a universal image improvement and tweaking mod,
that works with almost any 32bit (and hopefully soon 64bit) DirectX 9, 10 or 11 game or application.

It's goal is provide similar tools to games in realtime, as video processing software provides for movies and videos.

It runs on all Windows versions from Windows 2000 and up. Both 32bit and 64bit.
It works perfectly with all cards that can run DirectX9 games and support shader model 3. (that's all cards since the Ati Radeon X1xxx and Nvidia Geforce 6xxx series)
Some of the effects will even work on cards so old that they can only run shader model 2. (Ati Radeon 9xxx to X8xx series and the GeForce FX 5xxx series)
- there is a compability setting that enables support for these really old cards in /SweetFX/SweetFX_compatibility_settings.txt

Effects included:

* SMAA Anti-aliasing : Anti-aliases the image using the SMAA technique - see http://www.iryoku.com/smaa/
* FXAA Anti-aliasing : Anti-aliases the image using the FXAA technique - currently only work under DirectX9. Use the d3d9.dll found in \SweetFX\dlls\FXAA DX9 dll\ for this.
* Explosion : Scatters the pixels similarly to the Explosion filter in Irfanview
* Cartoon : Creates an outline-effect that makes the image look more cartoonish.
* Advanced CRT : Mimics the look of an old arcade CRT display.
* LumaSharpen : Sharpens the image, making details easier to see
* Bloom : Makes strong lights bleed their light into their surroundings
* HDR : Mimics an HDR tonemapped look
* Levels : Sets a new black and white point. A fast and easy way to increase contrast but it causes clipping. The Curves effect does this in a more subtle way without causing clipping.
* Technicolor : Makes the image look like it was processed using a three-strip Technicolor process - see http://en.wikipedia.org/wiki/Technicolor
* Cineon DPX : Makes the image look like it was converted from film to Cineon DPX. Can be used to create a "sunny" look.
* Monochrome : Removes colors from the image so it appears as if shot on black and white film.
* Lift Gamma Gain : Adjust brightness and color of shadows, midtones and highlights (and typically does it better then the Tonemap effect)
* Tonemap : Adjust gamma, exposure, saturation, bleach and defog. (may cause clipping)
* Vibrance : Intelligently saturates (or desaturates if you use negative values) the pixels depending on their original saturation.
* Curves : Contrast adjustments using S-curves - without causing clipping.
* Sepia : Sepia tones the image - see http://en.wikipedia.org/wiki/Sepia_tone#Sepia_toning
* Vignette : Darkens the edges of the image to make it look more like it was shot with a camera lens. - see http://en.wikipedia.org/wiki/Vignetting )
* Dither : Applies dithering to simulate more colors than your monitor can display. This lessens banding artifacts - see http://en.wikipedia.org/wiki/Dithering#Digital_photography_and_image_processing )
* Border : Makes the screenedge black as a workaround for the bright edge that forcing some AA modes sometimes causes.
* Splitscreen : Enables the before-and-after splitscreen comparison mode.

* Custom : A template to allow other to more easily program their own shader. Just edit /SweetFX/Shaders/custom.h (some programming knowledge required)


You can find new releases of SweetFX in it's thread on the Guru3d forums :
http://forums.guru3d.com/showthread.php?t=381912


   /*-----------------------------------------------------------.   
  /                      Installation                           /
  '-----------------------------------------------------------*/

1) Extract or copy all the files into the directory of a game exe (keeping the file structure intact).

The installed files are:
   d3d9.dll                 - DirectX 9 proxy dll that will inject shaders into DirectX 9 games
   d3d9.fx                  - DirectX 9 specific shader code
   dxgi.dll                 - DirectX 10/11 proxy dll that will inject shaders into DirectX 10/11 games
   dxgi.fx                  - DirectX 10/11 specific shader code
   shader.fx                - Alternative DirectX 9 specific shader code for FXAA support.
   injector.ini             - Settings for the shader injector dlls - you can reconfigure the keys used in this file
   SweetFX readme.txt       - This readme
   SweetFX_preset.txt       - You can choose which settings file to load here - default is to load SweetFX_settings.txt
   SweetFX_settings.txt     - SweetFX settings. Effects can be turned on and off here, and their settings can be tweaked.
   
   SweetFX/ (directory)     - The SweetFX subdirectory. 
   |- /Presets/             - Presets are stored here.
   |- /Shaders/             - All the shaders, except d3d9.fx and dxgi.fx are stored here.
   |- /dlls/                - Alternative DirectX proxy dlls are stored here.
   |   |- /FXAA DX9 dll/    - You will need to use the FXAA DX9 dll to use FXAA. Copy it over the one in the main folder.
   |   '- /SMAA/            - The SMAA dlls if you need to return to them. These are the same as the ones in the main folder.                
   |- /Game_Compability.txt - Can't make SweetFX work with a game? - You can find help here.
   |- /Making shaders.txt   - A few hints on making custom shaders for SweetFX.
   '- /SweetFX_compatibility_settings.txt - If your card can't run Shader Model 3, then you can force SweetFX to use shader model 2 here.

   log.log                  - This logfile is not installed, but will be created when the DirectX proxy dll runs.
                              If something goes wrong, this file will usually tell you why.

Some games require special attention - You can find a list of those and instructions on how to get them working with SweetFX 
in SweetFX/Game_Compability.txt
If you encounter a game not in the list that requires more effort to work with SweetFX, post about it in the official thread
on Guru3d : http://forums.guru3d.com/showthread.php?t=381912
                            
2) Install the latest DirectX update if you haven't already
   Last I looked it was here : http://www.microsoft.com/en-us/download/details.aspx?id=35
   (You don't need any of the other stuff Microsoft tries to push - just DirectX)

   If the smaller DirectX installer listed above gave you any trouble you can try the full package instead :
   http://www.microsoft.com/en-us/download/details.aspx?id=8109
   

   /*-----------------------------------------------------------.   
  /                          Usage                              /
  '-----------------------------------------------------------*/
  
It will automatically run when you start the DirectX 9, 10 or 11 game that you added SweetFX to.
If you want to run different game with SweetFX then you need to install to that games directory too.

It does not modify any game files either on disk or in memory.
Instead it uses a custom Direct3D runtime dll which the most DirectX games will call.

PRINTSCRN saves a screenshot named ScreenshotXXXX.bmp in the directory you installed SweetFX to.
SCROLL_LOCK switches it ON and OFF. It starts in ON mode.
PAUSE reloads the shader files (this is useful when you need to tweak the settings while the game is running)

Keys can be reconfigured in the injector.ini file.

Some keyboards (mostly on laptops) don't have a dedicated SCROLL_LOCK button,
but require you to hold down the Fn button while you press another key to activate Scroll Lock.

If you can't figure out the right combination just from looking at your keyboard and experimenting,
then read the documentation for your keyboard or just reconfigure the keys in injector.ini


   /*-----------------------------------------------------------.   
  /                      Tweaking settings                      /
  '-----------------------------------------------------------*/

You can choose which effects to enable, and set their parameters
in the SweetFX_settings.txt file - this can even be done *while* the game is running.

1) Switch away from your game with ALT+TAB or WIN+TAB
2) Open SweetFX_settings.txt in any text editor - fx. : Notepad (I use Notepad2)
3) Edit the settings and save.
4) Switch back to your game with ALT+TAB or WIN+TAB
5) If the game is running in fullscreen mode then it will now have reloaded the shader files
   and your new settings have been applied.
   If the game is running in Windowed mode then you need to press the PAUSE key to reload the shader files
   and apply your new settings.
   
And naturally you don't have to start the game before you edit your settings.
It can be done before the game runs as well.   

If you find editing a text file tedious and would rather want a GUI then I know of two third-party GUIs for SweetFX:
SweetFX Configurator (by Terrasque) : http://sweetfx.thelazy.net/ 
and FlightFX ( by Laser ) : http://riseofflight.com/forum/viewtopic.php?t=34103

   /*-----------------------------------------------------------.   
  /                          Presets                            /
  '-----------------------------------------------------------*/
SweetFX has a preset feature. Presets are just settings files made for a specific game, series of games or a special purpose.
Many (most) of these are made by the users of SweetFX.

You can find a lot of them in the SweetFX Settings Database (made by Terrasque who also made the SweetFX configurator GUI)
http://sfx.thelazy.net/games/

I have included a few of these in /SweetFX/Presets/ as examples.

They are a good start if you need help finding the settings that are just right for you.

The preset feature works like this:
1) SweetFX looks in SweetFX_preset.txt , which tells it what settings file to include (load)
2) It then includes (loads) those settings.

Per default the contents of SweetFX_preset.txt is a single command:
#include "SweetFX_settings.txt"

This tells SweetFX to load the settings in SweetFX_settings.txt

To load different settings simply point to a preset.

Fx. to use the awesome Torchlight2_TFL.txt preset by TFL that is intended to make Torchlight 2 look,
darker, dirtier, grittier and all-around more "evil" simply change the #include line to :
#include "SweetFX/Presets/Torchlight2_TFL.txt"

Note that although presets are often intended for a single specific game, they can be used in any game you wish.

To make your own preset simply copy the SweetFX_settings.txt file, rename it whatever you'd like, and point the #include line to its location

For example :
1) Make a copy
2) Rename it mycustom_preset.txt
3) Move it to the Presets folder (you don't HAVE to do this - this is just to keep the files organized)
4) Change the #include line to :

#include "SweetFX/Presets/mycustom_preset.txt"

If you make a really good preset please share it with other users in the SweetFX release thread at :
http://forums.guru3d.com/showthread.php?t=381912

And put them in the SweetFX Settings Database at:
http://sfx.thelazy.net/games/

Similar to the other presets try also to include some details about your preset

Game: What game(s) you made this for
SweetFX version: What SweetFX version you made this for
Author: Your name
Description: "Your description goes here"

   /*-----------------------------------------------------------.   
  /                  Making your own shaders                    /
  '-----------------------------------------------------------*/
I've included a few notes on how you can create your own shaders for SweetFX.
You can find the in the SweetFX subfolder.

Starting with SweetFX 1.5 I have made this even easier by making a blank template effect called custom.h, that you can edit to create your own effect.
This way you don't have to worry about how to integrate your effect with SweetFX - it already is.


   /*-----------------------------------------------------------.   
  /                         Problems?                           /
  '-----------------------------------------------------------*/

When the mod starts it creates a log.log file next to it's own location.
Open the log with a text editor and see what the problem is.

If no log file is created then the mod did not start.
- Maybe you didn't put the files in the right location?
- Or maybe the game doesn't use DirectX?

Most games use DirectX 9, 10 or 11.
Notable games that use OpenGL (which SweetFX doesn't work with) are all games by id software,
and those games based on their 3D engines.


Q: It says d3dx9_43.dll is missing
A: You need the latest DirectX 9 update.
   See step 2) of the installation section.
   
Q: It does not run with the 64bit version of my game exe.
A: SweetFX is not currently compatible with 64bit versions of games - use a 32bit version.
   Boulotaur2024 have released a special version of SweetFX that uses his own proxy dlls that does support 64bit. - find the link for that in the SweetFX thread on Guru3D.
   Support for 64bit games in the offical branch of SweetFX is underway - check the discussion thread for the lastest news on that.
   
Q: My game crashes with SweetFX installed.
A: The log.log file will most likely tell you why.
   
If you have installed SweetFX correctly and have run the game with the log.log file in the same folder
as the game .exe and the d3d9.dll and dxgi.dll files, then it should be overwritten with debug information that might help you understand why it crashed.

If it hasn't then it contains a helpful guide writen by me - which means your game likely crashed because SweetFX couldn't write to the log.log file.

Some steps to resolve this:
  1) Check that the log.log file is in the same folder as the game .exe and the d3d9.dll and dxgi.dll files.
     It's installed there per default so it should be there.

     If you moved the .dll's that came with SweetFX to another folder then check in that folder for the correct log.log,
     that the injector creates when it runs.

  2) Find out if it's a problem with insufficient user permissions in the game folder you installed SweetFX to.
     To do that try running the game with administrator rights by right-clicking it's exe and choosing "Run as administrator"
     If that worked then you have found the problem.

     To solve it, you can either keep running it as administrator every time, which can be a little annoying in the long run.

     You can also right click on the folder that contains this file and then choose "Properties"
     From there click "Security", then "Edit", then on your username, and then set "Full Control" to "Allow"
     This should also allow Modify, Execute, List, Read and Write - if it doesn't then also set those to "Allow"
     Now "OK" your way out of the dialogs.
     Your user account now has full control for that folder and you don't have to Run as administrator.

     Alternatively you can create a new shortcut to the game and right click that and choose "Properties"
     Under "Shortcut" click Advanced and check "Run as administrator" and "OK" your way out.
     This shortcut will now always run as administrator and the administrator account always has the necessary rights.

  3) Does it still crash?
     Try disabling all game overlays (like Origin), recording software (like Fraps), framerate displaying software (like Fraps),
     GPU overclocking and tweaking software software and other d3d9.dll or dxgi.dll proxy dlls (like ENB, Helix or Umod)


  4) If the above doesn't work and you can't solve the problem yourself or google your way to a solution then try to get support
     online in either the SweetFX thread on Guru3d or your preferred forum.
     Note that I prefer not to get support questions as PM's but I'd rather have you post in the thread so others can help you too.
     I'm not always in the thread but there is usually always other users.


Q: I don't see any change in the image
A: Try turning off anti-aliasing in the game (not in the mod)
   The mod is not compatible with some antialias implementations.
   It might be made compatible by setting compability flags.
   
   If not then you can always use the included SMAA anti-aliasing.

   
Q: How do I make MSI Afterburner / EVGA Precision / Rivatuner OSD work with this mod?
A: To make MSI Afterburner work with this mod and others like it you need to :

1) Update to the latest version of MSI Afterburner.
2) Start MSI Afterburner.
3) Switch to the "MSI On-Screen Display Server" window.
4) Create a new profile for your game and change to it.
5) Click the big wrench icon to change advanced settings.
6) Go to General -> Compatibility properties and turn on "Enable compatibility with modified Direct3D runtime libraries".

MSI Afterburner is now compatible with shader mods.

You can also change the setting for the Global profile,
but MSI does not recommend this because it might prevent some Direct3D applications from starting.

The same (very similar) steps also work with EVGA Precision and Rivatuner OSD,
as all 3 tools are based on Rivatuner OSD.


Q: How do I use SweetFX with ENBseries?
A: By making ENB run SweetFX. You need to: 

1) Rename d3d9.dll to sweetfx_d3d9.dll
2) Install the ENB series files into the same directory
3) Edit enbseries.ini so the top section looks like this:

[PROXY]
EnableProxyLibrary=true
InitProxyFunctions=true
ProxyLibrary=sweetfx_d3d9.dll

That should do it.

Q: How do I use SweetFX with OpenGL games?
A: SweetFX only supports DirectX 9 , 10 and 11 games, however you can use a OpenGL to DirectX wrapper.
   (Support for OpenGL (without using a wrapper) is in development) - see the SweetFX thread on Guru3D for news on that.

Try the QindieGL wrapper : http://code.google.com/p/qindie-gl/
It can translate OpenGL calls to DirectX 9 calls that SweetFX will work with.
It does not work with all OpenGL games and some games it does work with will have buggy graphics
and it will likely run slower since it's being translated, but if you want to try out SweetFX with OpenGL games this is probably your best bet.
I haven't tried it myself yet so let me know if it works or not.

Q: How do I use SweetFX with DirectX 8 games?
A: SweetFX only supports DirectX 9 , 10 and 11 games, however you can use a DirectX 8 to DirectX 9 wrapper.

Try the DX8 to DX9 convertor from ENBseries : http://enbdev.com/download_convertor_dx8todx9.htm
This works with some but not all DirectX 8 games.

Q: How do I use SweetFX with games that use DirectX 7 or older or even Glide?
A: Again you need to find a wrapper that will translate the API that the game uses to one that SweetFX supports.
   I've seen fans run old Glide games with SweetFX so it's possible, but so far I don't know any who have made DirectX 7 games work with SweetFX.


   /*-----------------------------------------------------------.   
  /                     Uninstallation                          /
  '-----------------------------------------------------------*/

1) Delete all the files you copied during the installation.


   /*-----------------------------------------------------------.   
  /                       Changelog                             /
  '-----------------------------------------------------------*/
Version 1.5.1  
  LumaSharpen in 1.5 still had some experimental code activated when it should not have. Fixed that.
  Changed some code and settings to workaround a bug in SweetFX Configurator. The configurator should now work fine with SweetFX 1.5.1
  The Custom shader now have some more interesting example code that inverts the luma of the image, and it now has an example setting.
  
Version 1.5
  New compatiblity mode allows some effects to run on really old cards that does not support Shader Model 3, but only 2.
  New Levels shader to allow people to easily set a new black and white point.
  New Explosion shader. Scatters the pixels similar to Irfanviews Explosion filter
  New Custom shader - a blank template already integrated into SweetFX, to make it even easier for people to write their own shaders

  New Vibrance setting "Vibrance_RGB_balance" allows people to set Vibrance per color component
  New border-width and border-color options for the Border shader

  Created two new curve formulas (9 and 10)

  Created a new ordered dithering algoritm with much better quality than the old one, while still being just as fast.
   - It also affects the compressibility of the screenshots and videos less.

  Improved the Cartoon shader. It should have better quality and be slightly faster now.

  New Splitscreen mode : Curvy.

  Wrote a new DX10 shader technique that will correctly bypass SMAA code when SMAA is disabled
  Wrote a new DX10 vertex shader that can generate texture coordinates without relying on the DXGI proxy to send it a position.
  Extra gamma corrections under DX10 is now only done when necessary, that is when both SMAA and another effect is enabled at the same time.
  Clamped output of Monochrome to ensure it never outputs shades that are out of range, even if the user used bad conversion values.
  Reworked some code to make it easier for myself to use GPU ShaderAnalyzer on the SweetFX shaders.

  Fixed problems with presets for older versions. SweetFX 1.5 should now be compatible with presets from all previous versions ( 1.0 to 1.5 )

  Included a log.log with the installation to hopefully prevent some of the issues with create file permissions on Windows Vista and up.
  This log also contains information to resolve the problem that arises if the injector can't write to this log.

  Improved performance of the Border shader
  Improved performance of Lift Gamma Gain
  Improved performance of the random dithering algoritm
  Improved performance of Curves formula 4 and 8
  Improved performance of LumaSharpen
  Improved performance of SMAA
  Improved performance of DPX
  Improved performance of Vignette

Version 1.4
    Adds the Border shader as a workaround for the bright screenedge forcing certain AA modes can cause
    Adds the Cartoon shader that can make the image look more cartoonish
    Adds the Advanced CRT shader that can mimic the look of an old arcade CRT display
    Adds the Monochrome shader that removes the colors
    Adds the FXAA shader as an alternative to SMAA for the few people that still prefer it. (only in DX9 for now though)
    Improved the Curves shader so it can now apply contrast to Chroma as well as Luma (as before) or both
    Improved the performance of formula 5 in the Curves shader (the simplified Catmull-rom spline)
    Improved the Dither shader with the option to use Random Dithering.
    Improved the Dither shader so now uses a subpixel dithering pattern. (Both when using Random or Ordered Dithering)
    Lowered the default SMAA threshold to 0.10 so fewer aliased lines escape processing.
    Fixed a bug where dark areas could on occasion appear when HDR and Lumasharpen where both activated at the same time.
    The alpha channel is now cleared before outputting the image to prevent it messing with screenshots converted to png.
    The SweetFX settings file now include a description field to help keep of which version the settings are for.
    Improved the Vignette shader to allow you to create oval shaped vignettes.
    Curves_formula 2 is now the default Curves formula.
    Includes some notes on how you can make custom shaders

Version 1.3
    Adds the Lift Gamma Gain shader which lets users adjust brightness and color of shadows, midtones and highlights.
    Adds the Curves shader which uses S-curves to adjust the contrast of the image
    Adds the Splitscreen shader which makes it easier to do comparison screenshots and videos.
    Reversed the DPX blend setting so smaller numbers now mean less effect and not more (it's more logical this way)
    Better default DPX settings
    More conservative default Vibrance settings (down from 0.20 to 0.15)
    All settings in the settings file now have ranges. (preparations for an upcoming GUI)

Version 1.2
    Fixes a rounding problem on AMD hardware with the dither shader.
    Includes usermade presets - look in the SweetFX/Presets/ folder.
    Updated and expanded documentation.
    Minor speed improvements to most of the shaders. Hopefully it adds up.
    Based on user feeedback default settings now use more conservative sharpening
    Also default settings now enable conservative Vibrance settings
    Slightly better default Sepia settings
    Vignette now more uniformly darkens all the color channels of the screen edges
    Adds the DPX shader - settings still need a lot of work though.
    
Version 1.1.1

    Fixes DirectX 10/11 support 

Version 1.1

    Keymappings have changed to Printscreen, Scroll_lock and Pause
    Settings now use a .txt suffix which is hopefully less scary for novices
    Optimized the Vignette shader to run a little faster
    Adds the Dither shader that performs dithering of the image to help remove or reduce banding artifacts (most commonly caused by the Vignette)
    Fixes and improves Vibrance
    Accidently broke DirectX 10/11 support  

Version 1.0

    First non-beta release.
    Adds SMAA, LumaSharpen, Vibrance
    Tweaks and improvements to HDR, Bloom, Tonemap, Sepia and Vignette
    SMAA is now configurable, so you can use your own settings and it even allows you to use Color Edge Detection
    Supports DX 9,10 and 11 and will automatically use the version the game requires without depending on the user to do anything 


   /*-----------------------------------------------------------.   
  /                          Credits                            /
  '-----------------------------------------------------------*/

 Uses SMAA. Copyright (C) 2011 by Jorge Jimenez, Jose I. Echevarria,
 Belen Masia, Fernando Navarro and Diego Gutierrez.
  - More info on: http://www.iryoku.com/smaa/
 
 Uses FXAA by Timothy Lottes (Nvidia) 
  - His blog: http://timothylottes.blogspot.com
 
 Uses InjectSMAA by Andrej Dudenhefner ( mrhaandi )
  - http://mrhaandi.blogspot.dk/p/injectsmaa.html
 
 Uses the Bloom, HDR, Tonemap, Technicolor, Sepia and Vignette shaders from FXAATool by Violator, [some dude], fpedace, BeetleatWar1977 and [DKT70]
  - https://www.assembla.com/wiki/show/fxaa-pp-inject/
  - All of these shaders have been modified by me (CeeJay.dk) .. some of them extensively.
  
 DPX shader by Loadus
 
 Border shader by Oomek - rewritten, optimized and improved by CeeJay.dk
 
 Advanced CRT shader by cgwg, Themaister and DOLLS - ported to SweetFX by Boulotaur2024.
 
 Lift Gamma Gain shader by 3an and CeeJay.dk
 
 Cartoon by CeeJay.dk, but based on the Auto Toon cg shader found in the Dolphin emulator.
  - http://dolphin-emu.org/
  
 SweetFX, LumaSharpen, Dither, Curves, Vibrance, Monochrome, Splitscreen, Explosion, Border, and Levels by Christian Cann Schuldt Jensen ( CeeJay.dk )
 
 Custom by You.
 
   /*-----------------------------------------------------------.   
  /                          Contact                            /
  '-----------------------------------------------------------*/
Post comments, suggestions, support questions, screenshots, videos and presets to the official SweetFX thread at:
http://forums.guru3d.com/showthread.php?t=381912

Submit your presets to the SweetFX Settings Database at:
http://sfx.thelazy.net/games/

Or email your comments and thoughts (but please no support questions - keep those to the Guru3D thread) to :
      CeeJay.dk  (at)  gmail.com 

You can also find me on reddit - my username there is CeeJayDK
