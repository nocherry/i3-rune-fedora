#!/usr/bin/env python3

import sys

from Xlib import X, display
from Xlib.ext import xinput


x = display.Display()
integer = x.intern_atom("INTEGER")
found = False

for device in x.xinput_query_device(xinput.AllDevices).devices:
    if "Touchpad" not in device.name:
        continue
    found = True
    for name in ("Device Enabled", "libinput Tapping Enabled"):
        prop = x.intern_atom(name, only_if_exists=True)
        if prop:
            x.xinput_change_device_property(device.deviceid, prop, integer, X.PropModeReplace, (8, b"\x01"))

x.sync()
if not found:
    print("Touchpad not found", file=sys.stderr)
    raise SystemExit(1)
