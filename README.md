# voicemeeter-auto-affinity
Automatically sets the affinity of "audiodg.exe" to only one core on computer start to fix the crackling noises that can
occur in VoiceMeeter.

## The Problem
Some users of the program VoiceMeeter have a problem with a sound channel having crackling noises. This can be fixed by
setting the affinity of the windows process "audiodg.exe" to only one core. This, however can not be done persistently
in Windows itself, so a common solution is to use [Process Lasso](https://bitsum.com/). My problem with this solution was
that the free version of this program asks to buy the paid version on every boot and constantly runs in the background although
the only feature I use does not require that. This is why I decided to write a simple batch script that is run once on
system boot and changes the affinity of audiodg to only one core.

## How to Use
To install the batch script, do one of the following:

### Using the Installation Tool
To conveniently install the batch script, download the InstallationTool.exe from the
[releases page](https://github.com/Gobidev/voicemeeter-auto-affinity/releases) and click the Install button.

### Manual Installation
Download the batch file directly and place it into the startup folder that you can access by pressing WIN + R and typing
"shell:startup".