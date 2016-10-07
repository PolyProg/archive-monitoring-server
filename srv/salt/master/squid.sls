squid:
  pkg.installed:
    - name: squid
    
  service.running:
    - name: squid
    
    - require:
      - pkg: squid

  file.managed:
    - name: /etc/squid/squid.conf
    - source: salt://files/etc/squid/squid.conf
    - user: root
    - group: root
    - mode: 444

    - watch_in:
      - service: squid
    
    - require:
      - pkg: squid


dnf proxy:
  file.append:
    - name: /etc/dnf/dnf.conf
    - text: proxy=http://localhost:3128
