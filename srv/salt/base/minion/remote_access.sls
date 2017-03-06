xtrlock:
  pkg.installed:
    - name: xtrlock


locker.py:
  file.managed:
    - name: /usr/local/bin/lock
    - source: salt:///files/lock.py
    - user: root
    - group: root
    - mode: 700
