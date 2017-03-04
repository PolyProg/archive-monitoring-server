sshkeys:
  file.managed:
    - name: "/home/root/.ssh/authorized_keys"
    - user: root
    - source: salt://files/authorized_keys

  pkg.installed:
    - name: openssh-server

  service.running:
    - name: sshd
