install salt packages:
  pkg.installed:
    - pkgs:
      - salt-minion
      - salt-master


enable salt minion:
  service.running:
    - name: salt-minion
    - enable: True
    - require:
      - pkg: install salt packages


enable salt master:
  service.running:
    - name: salt-master
    - enable: True
    - require:
      - pkg: install salt packages
