# BO3-Autosplits-Injected
# Summary
A collection of injectable autosplitters for Black Ops 3. These splits run via the game and offer more control over easter egg splitting and more accuracy for split times.  
Credits to serious for making the injector and making it customizable to add this functionality.

# Pre-Requisites
Download Visual Studio Code (VSC) - https://code.visualstudio.com/  
Download and install the T7/T8 Compiler - https://github.com/shiversoftdev/t7-compiler/releases/tag/current  
Run the exe file and click Install Compiler. You can install the VSC extension if you like, but it's not required.

# Setting up LiveSplit
Super egg splits are supplied with subsplits for each map and 1 split for each map. If you're not running super egg, you can just use your normal splits and layout. Open the corresponding splits and layout files for what you want.
## Important
Regardless of what splits you use, you need to configure the scriptable auto splitter in the livesplit layout to use the remove-pause.asl. All this file does is pause the timer if you pause the game.

# Setting up the autosplits
If you're doing round SRs, open VSC and open the AutoSplits Round & Egg folder.  
In VSC, open the main.gsc file in the scripts folder. Search for the level.round_sr variable and set it to true. This will enable splits on every round end.  
If you're doing egg SRs, this is enabled by default so you don't need to change anything.

## Important
For super eggs, open VSC and open the Autosplits Super Egg folder.
In VSC, open the main.gsc file in the scripts folder. If you want to split only at the end of each map, search for the level.splits_enabled variable and set it to 0.  
If you want subsplits for each map, this is already enabled so you don't need to change anything.

# Injecting the autosplits
Open VSC and click file -> Preferences -> Keyboard Shortcuts. Search for "run test task" and give it a keybind.  
To inject the autosplits, wait for the game to be open and at the main menu. Press your keybind while you have one of the gsc files open in VSC and it should tell you it has injected. Now you can just start playing.
