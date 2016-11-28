{% if grains["os"] == "Ubuntu" %}
update-alternatives:
  pkg.installed:
    - name: dpkg

python:
  alternatives.install:
    - name: python3
    - link: /usr/bin/python3
    - path: /usr/bin/python3.2
    - priority: 100


gcc:
  alternatives.install:
    - name: gcc
    - link: /usr/bin/gcc
    - path: /usr/bin/gcc-4.9
    - priority: 100

g++:
  alternatives.install:
    - name: g++
    - link: /usr/bin/g++
    - path: /usr/bin/g++-4.9
    - priority: 100

{% else %}
update-alternatives:
  pkg.installed:
    - name: chkconfig

python:
  alternatives.install:
    - name: python3
    - link: /usr/bin/python3
    - path: /opt/python3/bin/python3
    - priority: 100

gcc:
  file.symlink:
    - name: /usr/bin/gcc
    - target: /opt/gcc-4.9.3/bin/gcc
    - force: True

g++:
  file.append:
    - name: /etc/bashrc
    - text: export LIBRARY_PATH=/opt/gcc-4.9.3/lib64/gcc/x86_64-fedoraunited-linux-gnu/lib64

{% endif %}


