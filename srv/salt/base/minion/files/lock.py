#!/usr/bin/python3

import os
import re
import subprocess


users = subprocess.check_output(["who"])
check = re.compile(r"(^\s*[a-zA-Z]+).*\(([0-9]*:[0-9]+(\.[0-9]*?)?)\)$")


with open(os.devnull) as DEVNULL:
    for line in users.decode("utf8").split("\n"):
        m = re.search(check, line)

        if m is not None:
            g = m.groups()

            user = g[0]
            display = g[1]

            print("Locking screen {} for {}".format(display, user))

            subprocess.Popen(
                ["su", user, "-m", "-c", "/usr/bin/xtrlock"],
                env=dict(DISPLAY=display),
                stdout=DEVNULL,
                stderr=subprocess.STDOUT
            )
