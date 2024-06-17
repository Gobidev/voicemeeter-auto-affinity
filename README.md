# voicemeeter-auto-affinity

[![Github Downloads all Releases](https://img.shields.io/github/downloads/Gobidev/voicemeeter-auto-affinity/total)](https://github.com/Gobidev/voicemeeter-auto-affinity/releases)
[![Github Downloads latest Release](https://img.shields.io/github/downloads/Gobidev/voicemeeter-auto-affinity/latest/total)](https://github.com/Gobidev/voicemeeter-auto-affinity/releases/latest)
[![License](https://img.shields.io/github/license/Gobidev/voicemeeter-auto-affinity)](https://github.com/Gobidev/voicemeeter-auto-affinity/blob/main/LICENSE)
[![GitHub issues](https://img.shields.io/github/issues/Gobidev/voicemeeter-auto-affinity)](https://github.com/Gobidev/voicemeeter-auto-affinity/issues)

Automatically sets the affinity of "audiodg.exe" to only one core on computer
start to fix the crackling noises that can occur in VoiceMeeter.

## New in v2

I learned about
[Windows Task Scheduler](https://learn.microsoft.com/en-us/windows/win32/taskschd/schtasks)
that allows to run the script in a way that does not open an admin prompt on
every login and wrote a new script that makes use of that.

_Note: If you had v1 of the script installed, it is automatically uninstalled if
you install v2._

## New in v2.5

The affinity will now be set periodically in addition to only on login. For more
information, see
[#11](https://github.com/Gobidev/voicemeeter-auto-affinity/pull/11).

## How to Install

To install the script, download the `install.bat` file from the
[latest release](https://github.com/Gobidev/voicemeeter-auto-affinity/releases/latest)
and run it. That's it!

## How to Uninstall

To remove the Task Scheduler tasks, run the following commands from an
administrator command prompt:

```bat
schtasks /delete /f /tn audiodg-affinity
schtasks /delete /f /tn audiodg-affinity-recurring
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
