roles:
  master: True


services:
  master:
    - salt-master
    - mdns
    - ssh
