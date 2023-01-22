# voicemeeter-auto-affinity

Automatically sets the affinity of "audiodg.exe" to only one core on computer
start to fix the crackling noises that can occur in VoiceMeeter.

## New in v2

I learned about
[Windows Task Scheduler](https://learn.microsoft.com/en-us/windows/win32/taskschd/schtasks)
that allows to run the script in a way that does not open an admin prompt on
every login and wrote a new script that makes use of that.

_Note: If you had v1 of the script installed, it is automatically uninstalled if
you install v2._

## How to Install

To install the script, download the `install.bat` file from the
[latest release](https://github.com/Gobidev/voicemeeter-auto-affinity/releases/latest)
and run it. That's it!

## How to Uninstall

If you no longer want the audiodg affinity to be set at login, run the following
command from an administrator command prompt:

```bat
schtasks /delete /f /tn audiodg-affinity
```

## The Problem

Some users of the program VoiceMeeter have a problem with a sound channel having
crackling noises. This can be fixed by setting the affinity of the windows
process `audiodg.exe` to only one core. This, however can not be done
persistently in Windows itself, so a common solution is to use
[Process Lasso](https://bitsum.com/). My problem with this solution was that the
free version of this program asks to buy the paid version on every boot and
constantly runs in the background although the only feature I use does not
require that. This is why I decided to write a simple script that is run once on
system boot and changes the affinity of audiodg to only one core.
