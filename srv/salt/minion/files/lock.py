#!/usr/bin/python3

import platform
import re
import subprocess

users = subprocess.check_output(["who"])
distribution = platform.linux_distribution()[0]

if distribution == "Ubuntu":
    exe = "/usr/bin/xtrlock"
else:
    exe = "/usr/bin/pyxtrlock"


check = re.compile(r"(^\s*[a-zA-Z]+).*\(([0-9]*:[0-9]+(\.[0-9]*?)?)\)$")
for line in users.decode("utf8").split("\n"):
    m = re.search(check, line)

    if m is not None:
        g = m.groups()

        user = g[0]
        display = g[1]

        print("Locking screen {} for {}".format(display, user))

        subprocess.Popen(["su", user, "-m", "-c", exe], env=dict(DISPLAY=display), stdout=subprocess.DEVNULL, stderr=subprocess.STDOUT)

