import tkinter as tk
import tkinter.ttk as ttk
import tkinter.messagebox
import subprocess
import os
import sys
import shutil


AUTOSTART_DIR = os.path.join(os.getenv("APPDATA"), "Microsoft\\Windows\\Start Menu\\Programs\\Startup")
BATCH_FILE_NAME = "set-audiodg-affinity.bat"
INSTALLED_SCRIPT_PATH = os.path.join(AUTOSTART_DIR, BATCH_FILE_NAME)

if hasattr(sys, "_MEIPASS"):
    # noinspection PyProtectedMember
    ORIGIN_BATCH_FILE_LOCATION = os.path.join(sys._MEIPASS, BATCH_FILE_NAME)
else:
    ORIGIN_BATCH_FILE_LOCATION = os.path.join(os.getcwd(), BATCH_FILE_NAME)


def install_batch_file():
    try:
        if not os.path.isfile(INSTALLED_SCRIPT_PATH):
            shutil.copy(ORIGIN_BATCH_FILE_LOCATION, AUTOSTART_DIR)
            subprocess.call([INSTALLED_SCRIPT_PATH])
            tk.messagebox.showinfo("Success", "The batch script was successfully installed")
        else:
            tk.messagebox.showerror("Error Occurred", "The batch script was already installed")
    except Exception as e:
        tk.messagebox.showerror("Error Occurred", e)


def uninstall_batch_file():
    try:
        if os.path.isfile(INSTALLED_SCRIPT_PATH):
            os.remove(INSTALLED_SCRIPT_PATH)
            tk.messagebox.showinfo("Success", "The batch script was successfully uninstalled")
        else:
            tk.messagebox.showerror("Error Occurred", "No installed script was found")
    except Exception as e:
        tk.messagebox.showerror("Error Occurred", e)


class Application(ttk.Frame):

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)

        self.info_text = "This is a simple tool that automatically installs the\nrequired batch file to the users " \
                         "autostart folder."

        # Row 0
        info_lbl = ttk.Label(self, text=self.info_text)
        info_lbl.grid(row=0, column=0, padx=3, pady=3)

        # Row 1
        install_button = ttk.Button(self, text="Install", command=install_batch_file)
        install_button.grid(row=1, column=0, padx=10, pady=10, ipadx=13)

        # Row 2
        uninstall_button = ttk.Button(self, text="Uninstall", command=uninstall_batch_file)
        uninstall_button.grid(row=2, column=0, padx=3, pady=3, ipadx=13)


if __name__ == '__main__':
    root = tk.Tk()
    root.title("voicemeeter-auto-affinity Installation Tool")
    root.resizable(False, False)
    application = Application(root)
    application.pack(fill="both", padx=5, pady=5)

    root.mainloop()
