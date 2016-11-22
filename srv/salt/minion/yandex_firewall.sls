firewall:
  pkg.installed:
    - name: iptables


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
allow hc2 for {{ port }}:
  iptables.append:
    - chain: OUTPUT
    - protocol: tcp
    - dport: {{ port }}
    - destination: hc2.ch
    - jump: ACCEPT
{% endfor %}


{% for port in ["http", "https"] %}
block connections for {{ port }}:
  iptables.append:
    - chain: OUTPUT
    - protocol: tcp
    - dport: {{ port }}
    - jump: DROP
