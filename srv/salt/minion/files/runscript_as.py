#!/usr/bin/python3

import platform
import os
import re
import subprocess

import pwd

import sys


users = subprocess.check_output(["who"])
distribution = platform.linux_distribution()[0]

check = re.compile(r"(^\s*[a-zA-Z]+).*\(([0-9]*:[0-9]+(\.[0-9]*?)?)\)$")


with open(os.devnull) as DEVNULL:
    for line in users.decode("utf8").split("\n"):
        m = re.search(check, line)

        if m is not None:
            g = m.groups()

            user = g[0]
            display = g[1]

            print("Running {} on {} for {}".format(sys.argv[1], display, user))

            subprocess.Popen(
                ["su", user, "-m", "-c", sys.argv[1]],
                env=dict(DISPLAY=display),
                stdout=DEVNULL,
                stderr=subprocess.STDOUT
            )
