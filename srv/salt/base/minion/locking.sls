slock:
  pkg.installed:
    - name: slock


locker.py:
  file.managed:
    - name: /usr/local/bin/lock
    - source: salt:///minion/files/lock.py
    - user: root
    - group: root
    - mode: 700
