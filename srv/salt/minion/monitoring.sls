/root/.ssh/authorized_keys:
  file.managed:
    - source: salt://files/misc/icinga2/ssh/id_rsa.pub?saltenv=master
    - makedirs: True
    - mode: 440


root:
  user.present:
    - password: {{ salt['shadow.gen_password'](salt['pillar.get']('password')) }}


xtrlock:
  pkg.installed:
    {% if grains["os"] == "Ubuntu" %}
    - name: xtrlock
    {% else %}
    - name: pyxtrlock
    {% endif %}

{% if grains["os"] == "Ubuntu" %}
  file.managed:
    - name: /usr/bin/xtrlock
    - mode: 4711
    - user: root
    - group: root
{% endif %}


locker.py:
  file.managed:
    - name: /usr/local/bin/lock
    - source: salt:///files/lock.py
    - user: root
    - group: root
    - mode: 700


runscript:
  file.managed:
    - name: /usr/local/bin/runscript
    - source: salt:///files/runscript_as.py
    - user: root
    - group: root
    - mode: 755
