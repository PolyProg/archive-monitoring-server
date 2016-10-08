/root/.ssh/authorized_keys:
  file.managed:
    - source: salt://files/misc/icinga2/ssh/id_rsa.pub?saltenv=master
    - makedirs: True
    - mode: 440


root:
  user.present:
    - password: {{ salt['shadow.gen_password'](salt['pillar.get']('password')) }}
