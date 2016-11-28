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

{% if grains["os"] == "Ubuntu" %}
uninstall unneeded packages:
  pkg.purged:
    - pkgs: ["account-plugin-aim", "account-plugin-jabber",
      "account-plugin-salut", "account-plugin-yahoo", "aisleriot", "baobab",
      "brasero", "cheese", "empathy", "gnome-mahjongg", "gnome-mines",
      "gnome-orca", "gnome-sudoku", "gnomine",
      "libreoffice-avmedia-backend-gstreamer", "libreoffice-base-core",
      "libreoffice-calc", "libreoffice-common", "libreoffice-core",
      "libreoffice-draw", "libreoffice-gnome", "libreoffice-gtk",
      "libreoffice-help-en-us", "libreoffice-impress", "libreoffice-math",
      "libreoffice-ogltrans", "libreoffice-pdfimport",
      "libreoffice-presentation-minimizer", "libreoffice-style-human",
      "libreoffice-writer", "libunity-webapps0", "mcp-account-manager-uoa",
      "mythes-en-us", "nautilus-sendto-empathy", "onboard", "onboard-data",
      "python3-uno", "remmina", "remmina-plugin-rdp", "remmina-plugin-vnc",
      "rhythmbox", "rhythmbox-mozilla", "rhythmbox-plugin-cdrecorder",
      "rhythmbox-plugin-magnatune", "rhythmbox-plugin-zeitgeist",
      "rhythmbox-plugins", "shotwell", "simple-scan", "software-center",
      "thunderbird", "thunderbird-gnome-support", "thunderbird-locale-en",
      "thunderbird-locale-en-us", "totem", "totem-mozilla", "totem-plugins",
      "transmission-common", "transmission-gtk", "ubuntu-desktop",
      "unity-webapps-common", "unity-webapps-service", "vino",
      "webapp-container", "webbrowser-app", "xul-ext-unity",
      "xul-ext-websites-integration"]

install python-gdbm:
  pkg.installed:
    - name: python3.2-gdbm

/etc/skel/.mozilla:
  file.recurse:
    - source: salt://files/.mozilla
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


locale:
  cmd.run:
    - name: timedatectl set-local-rtc 0

timezone:
  cmd.run:
    - name: timedatectl set-timezone Europe/Zurich
