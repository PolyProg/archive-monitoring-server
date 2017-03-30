#!/usr/bin/python3

import re
import subprocess


users = subprocess.check_output(["who"])
check = re.compile(r"(^\s*[a-zA-Z]+).*\(([0-9]*:[0-9]+(\.[0-9]*?)?)\)$")


for line in users.decode("utf8").split("\n"):
    m = re.search(check, line)
    if m is not None:
        g = m.groups()
        user = g[0]
        display = g[1]

        print("Locking screen {} for {}".format(display, user))

        subprocess.Popen(
            "su -c 'DISPLAY={} slock &' {}".format(display, user),
            shell=True,
            stderr=subprocess.DEVNULL,
            stdout=subprocess.DEVNULL
        )
