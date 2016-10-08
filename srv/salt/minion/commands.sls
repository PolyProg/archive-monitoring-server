block:
  cmd.run:
    - name: pyxtrlock &
    - runas: polyprog
    - env:
      - DISPLAY: ":0.0"
