@echo off

:: Get administrator priviliges
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

if '%errorlevel%' NEQ '0' (
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params = %*:"="
    echo UAC.ShellExecute "cmd.exe", "/c %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"


:: Set affinity
PowerShell.exe "$Process = Get-Process audiodg; $Process.ProcessorAffinity=1"

:: Affinity table
::Core # = Value = BitMask
::Core 1 = 1 = 00000001
::Core 2 = 2 = 00000010
::Core 3 = 4 = 00000100
::Core 4 = 8 = 00001000
::Core 5 = 16 = 00010000
::Core 6 = 32 = 00100000
::Core 7 = 64 = 01000000
::Core 8 = 128 = 10000000
::...