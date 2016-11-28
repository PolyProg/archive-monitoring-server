include:
  - .monitoring
  - .defaults


firewall:
  pkg.installed:
    - name: iptables

{% if grains["os"] == "Fedora" %}
keep network running:
  cmd.run:
    - name: /usr/sbin/dhclient eno1
{% endif %}

{% for table in ["INPUT", "FORWARD", "OUTPUT"] %}
  {% for family in ["ipv4", "ipv6"] %}
restrict {{ table }} on {{ family }}:
  iptables.set_policy:
    - chain: {{ table }}
    - policy: ACCEPT
    - family: {{ family }}
  {% endfor %}
{% endfor %}

{% for port in ["http", "https"] %}
{% for addr in [
  "hc2.ch", "polyprog.epfl.ch",
  "mc.yandex.ru", "social.yandex.ru", "img.fotki.yandex.ru", "export.yandex.ru", "contest.yandex.ru",
  "contest2.yandex.ru", "front.contest.yandex.net", "static.yandex.net", "passport.yandex.com", "passport.yandex.ru",
  "pass.yandex.ru", "awaps.yandex.ru", "clck.yandex.ru"
] %}
allow {{ addr }} for {{ port }}:
  iptables.append:
    - chain: OUTPUT
    - protocol: tcp
    - dport: {{ port }}
    - destination: {{ addr }}
    - jump: ACCEPT
{% endfor %}
{% endfor %}

{% for port in ["http", "https"] %}
block connections for {{ port }}:
  iptables.append:
    - chain: OUTPUT
    - protocol: tcp
    - dport: {{ port }}
    - jump: DROP
{% endfor %}


/usr/local/bin/change-background:
  file.managed:
    - source: salt://files/change-background.sh
    - user: root
    - group: root
    - mode: 755


/usr/share/backgrounds/warty-final-ubuntu.png:
  file.managed:
    - source: salt://files/santa.png
    - user: root
    - group: root
    - mode: 644


/usr/share/backgrounds/santa.png:
  file.managed:
    - source: salt://files/santa.png
    - user: root
    - group: root
    - mode: 644

    - require:
      - file: /usr/local/bin/change-background
      - file: /usr/share/backgrounds/warty-final-ubuntu.png

  cmd.run:
    - name: /usr/local/bin/runscript /usr/local/bin/change-background
