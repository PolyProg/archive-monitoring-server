firewall:
  pkg.installed:
    - name: iptables


{% for chain in ["INPUT", "OUTPUT"] %}
allow established traffic for {{ chain }}:
  iptables.append:
    - chain: {{ chain }}
    - jump: ACCEPT
    - match: state
    - connstate: ESTABLISHED,RELATED
{% endfor %}


allow loopback on INPUT:
  iptables.append:
    - chain: INPUT
    - jump: ACCEPT
    - in-interface: lo


allow loopback on OUTPUT:
  iptables.append:
    - chain: OUTPUT
    - jump: ACCEPT
    - out-interface: lo

    - require:
      - pkg: firewall


allow dns:
  iptables.append:
    - chain: OUTPUT
    - proto: udp
    - dport: domain
    - jump: ACCEPT


allow incoming ssh:
  iptables.append:
    - chain: INPUT
    - proto: tcp
    - dport: ssh
    - jump: ACCEPT


allow ping:
  iptables.append:
    - chain: INPUT
    - protocol: icmp
    - icmp-type: echo-request
    - jump: ACCEPT


{% for port in ["http", "https"] %}
allow hc2 for {{ port }}:
  iptables.append:
    - chain: OUTPUT
    - protocol: tcp
    - dport: {{ port }}
    - destination: hc2.ch
    - jump: ACCEPT
{% endfor %}


{% for port in ["4505", "4506"] %}
allow to monitor on {{ port }}:
  iptables.append:
    - chain: OUTPUT
    - protocol: tcp
    - dport: {{ port }}
    - jump: ACCEPT
    - destination: master.hc2.ch
{% endfor %}


{% for table in ["INPUT", "FORWARD", "OUTPUT"] %}
  {% for family in ["ipv4", "ipv6"] %}
restrict {{ table }} on {{ family }}:
  iptables.set_policy:
    - chain: {{ table }}
    - policy: DROP
    - family: {{ family }}
  {% endfor %}
{% endfor %}