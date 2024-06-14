@echo off

:: If not run as admin, open prompt
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

:: install vbs script to %UserProfile%
echo CreateObject("Wscript.Shell").Run "PowerShell.exe ""$Process = Get-Process audiodg; $Process.ProcessorAffinity=1; $Process.PriorityClass=""""""High""""""""", 0, True > "%UserProfile%\set-audiodg-affinity.vbs"
:: Affinity table
:: Core # = Value = BitMask
:: Core 0  = 1                = 00000001
:: Core 1  = 2                = 00000010
:: Core 2  = 4                = 00000100
:: Core 3  = 8                = 00001000
:: Core 4  = 16               = 00010000
:: Core 5  = 32               = 00100000
:: Core 6  = 64               = 01000000
:: Core 7  = 128              = 10000000
:: Core 8  = 256              = 1 00000000
:: Core 9  = 512              = 10 00000000
:: Core 10 = 1024             = 100 00000000
:: Core 11 = 2048             = 1000 00000000
:: Core 12 = 4096             = 10000 00000000
:: Core 13 = 8192             = 100000 00000000
:: Core 14 = 16384            = 1000000 00000000
:: Core 15 = 32768            = 10000000 00000000
:: Core 16 = 65536            = 1000000000 00000000
:: Core 17 = 131072           = 10000000000 00000000
:: Core 18 = 262144           = 100000000000 00000000
:: Core 19 = 524288           = 1000000000000 00000000
:: Core 20 = 1048576          = 10000000000000 00000000
:: Core 21 = 2097152          = 100000000000000 00000000
:: Core 22 = 4194304          = 1000000000000000 00000000
:: Core 23 = 8388608          = 10000000000000000 00000000
:: Core 24 = 16777216         = 100000000000000000 00000000
:: Core 25 = 33554432         = 1000000000000000000 00000000
:: Core 26 = 67108864         = 10000000000000000000 00000000
:: Core 27 = 134217728        = 100000000000000000000 00000000
:: Core 28 = 268435456        = 1000000000000000000000 00000000
:: Core 29 = 536870912        = 10000000000000000000000 00000000
:: Core 30 = 1073741824       = 100000000000000000000000 00000000
:: Core 31 = 2147483648       = 1000000000000000000000000 00000000

:: remove old version of program if present
cd "C:\Users\%username%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\"
del set-audiodg-affinity.bat 2>NUL

:: add task scheduler job
schtasks /create /sc ONLOGON /tn audiodg-affinity /delay 0000:20 /tr "wscript \"%UserProfile%\set-audiodg-affinity.vbs\"" /rl HIGHEST

:: Creating scheduled task so it is more persistently applying changes as the process is controlled by the Windows Audio service and will stop and restart process as needed
schtasks /create /sc MINUTE /tn audiodg-affinity-recurring /mo 5 /tr "wscript \"%UserProfile%\set-audiodg-affinity.vbs\"" /rl HIGHEST

:: run vbs script once to set the affinity for current session
wscript "%UserProfile%\set-audiodg-affinity.vbs"

:: Uninstall with
:: schtasks /delete /f /tn audiodg-affinity

echo.
echo.
echo INSTALLATION FINISHED
echo.
pause
