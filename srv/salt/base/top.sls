base:
  "*":
    - ssh

  "roles:master:True":
    - match: pillar
    - master

  "roles:minion:True":
    - match: pillar
    - minion