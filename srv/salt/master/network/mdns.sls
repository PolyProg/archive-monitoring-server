avahi tools:
  pkg.installed:
    - pkgs:
      - avahi
      - nss-mdns


avahi daemon:
  service.running:
    - name: avahi-daemon
    - enable: True

    - require:
      - pkg: avahi tools
