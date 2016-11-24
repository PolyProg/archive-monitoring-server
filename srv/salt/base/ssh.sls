sshkeys:
  ssh_auth.present:
    - user: root
    - source: salt://authorized_keys
    - config: "%h/.ssh/authorized_keys"

