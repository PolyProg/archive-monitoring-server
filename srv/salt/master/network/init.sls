include:
  - .firewall
  - .mdns


network manager:
  pkg.installed:
    - name: NetworkManager-wifi


enable networkManager:
  service.running:
    - name: NetworkManager
    - enable: True

    - require:
      - pkg: network manager
