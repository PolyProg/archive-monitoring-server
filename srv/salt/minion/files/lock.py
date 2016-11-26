#!/usr/bin/python3

import platform
import os
import re
import subprocess

import pwd


users = subprocess.check_output(["who"])
distribution = platform.linux_distribution()[0]

check = re.compile(r"(^\s*[a-zA-Z]+).*\(([0-9]*:[0-9]+(\.[0-9]*?)?)\)$")


def change_context(user):
    def context():
        try:
            pwnam = pwd.getpwnam(user)
            os.setuid(pwnam.pw_uid)
            os.setgid(pwnam.pw_gid)
        except Exception as e:
            print(e)

    return context


with open(os.devnull) as DEVNULL:
    for line in users.decode("utf8").split("\n"):
        m = re.search(check, line)

        if m is not None:
            g = m.groups()

            user = g[0]
            display = g[1]

            print("Locking screen {} for {}".format(display, user))

            if distribution == "Ubuntu":
                subprocess.Popen(
                    ["su", user, "-m", "-c", "/usr/bin/xtrlock"],
                    env=dict(DISPLAY=display),
                    stdout=DEVNULL,
                    stderr=subprocess.STDOUT
                )
            else:
                subprocess.Popen(
                    ["/usr/bin/python3.5", "/usr/bin/pyxtrlock"],
                    env=dict(DISPLAY=display),
                    stdout=DEVNULL,
                    stderr=subprocess.STDOUT,
                    preexec_fn=change_context(user)
                )
