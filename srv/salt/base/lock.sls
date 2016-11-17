lock:
  cmd.run:
    - name: pyxtrlock >/dev/null 2>&1 &
    - ignore_timeout: True
    - runas: polyprog
    - env:
      - DISPLAY: ":0.0"
