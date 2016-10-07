master:
  "roles:master:True":
    - match: pillar
    - squid
    - salt
    - network
    - monitor
