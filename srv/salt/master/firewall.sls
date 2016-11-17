Firewall:
  pkg.installed:
    - name: firewalld
    
  file.recurse:
    - name: /etc/firewalld/services
    - source: salt://files/etc/firewalld/services
    - clean: True

    - user: root
    - group: root
    - dir_mode: 500
    - file_mode: 400

    - watch_in:
      - service: Firewall
   
    - require:
      - pkg: Firewall
    
  firewalld.present:
    - name: external
    - default: True
    - services: 

      {% for services in pillar.get("services", {}).values() %}
      {% for service in services %}
      - {{ service }}
      {% endfor %}
      {% endfor %}     

    - require:
      - pkg: Firewall
      
    - watch_in:
      - service: Firewall


  service.running:
    - name: firewalld
    - enable: True

    - require:
      - pkg: Firewall
      - file: Firewall
