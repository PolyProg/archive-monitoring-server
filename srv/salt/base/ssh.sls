sshkeys:
  file.managed:
    - user: root
    - source: salt://files/authorized_keys
    - config: "%h/.ssh/authorized_keys"

  pkg.installed:
    - name: openssh-server

  service.running:
    - name: sshd
