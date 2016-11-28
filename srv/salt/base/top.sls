base:
  "roles:master:True":
    - match: pillar
    - ssh

  "roles:monitor:True":
    - match: pillar
    - ssh
