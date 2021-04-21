#!/bin/sh

pyinstaller --noconfirm --windowed --onefile --add-data "set-audiodg-affinity.bat;." "install.py"
