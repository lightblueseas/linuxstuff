#!/usr/bin/python3
import subprocess
import time
import os 

appdir = "/home/astrapi69/ides/idea"

f = os.path.join(os.environ["HOME"], "keylist")

def run(cmd):
    subprocess.call(cmd)

def get(cmd):
    try:
        return subprocess.check_output(cmd).decode("utf-8").strip()
    except:
        pass

def getactive():
    return get(["xdotool", "getactivewindow"])

def setkeys(val):
    # --- add the keys to be disabled below  
    keys = [
         ["org.gnome.settings-daemon.plugins.media-keys", "logout"],
         ["org.gnome.settings-daemon.plugins.media-keys", "screensaver"],
         ["org.gnome.desktop.wm.keybindings", "begin-move"],
        ]
    # ---
    writelist = []
    if not val:
        try:
            values = open(f).read().splitlines()
        except FileNotFoundError:
            values = []
        # for key in keys:
        for i, key in enumerate(keys):
            try:
                cmd = ["gsettings", "set"]+key+[values[i]]
            except IndexError:
                cmd = ["gsettings", "reset"]+key
            run(cmd)
    else:
        for key in keys:
            cmd = ["gsettings", "set"]+key+["['']"]
            read =  get(["gsettings", "get"]+key)
            writelist.append(read)
            run(cmd)
    if writelist:
        open(f, "wt").write("\n".join(writelist))

front1 = None

while True:
    time.sleep(1)
    # check if any of the apps runs at all
    checkpids = get(["pgrep", "-f", appdir])
    # if so:
    if checkpids:
        checkpids = checkpids.splitlines()
        active = getactive()
        # get pid frontmost (doesn't work on pid 0)
        match = [l for l in get(["xprop", "-id", active]).splitlines()\
                 if "_NET_WM_PID(CARDINAL)" in l]
        if match:
            # check if pid is of any of the relevant apps
            pid = match[0].split("=")[1].strip()
            front2 = True if pid in checkpids else False
        else:
            front2 = False
    else:
        front2 = False
    if front2 != front1:
        if front2:
            setkeys(True)
        else:
            setkeys(False)
    front1 = front2
