firewall:
  pkg.installed:
    - name: iptables


{% for family in ["ipv4", "ipv6"] %}
{% for table in ["INPUT", "FORWARD", "OUTPUT"] %}
allow policy for {{ family }} on {{ table }}:
  iptables.set_policy:
    - chain: {{ table }}
    - policy: ACCEP
    - family: {{ family }}
{% endfor %}

{% for protocol in ["http", "https"] %}
allow hc2 for {{ protocol }} for {{ family }}:
  iptables.append:
    - chain: OUTPUT
    - protocol: tcp
    - dport: {{ protocol }}
    - destination: hc2.ch
    - jump: ACCEPT

restrict {{ protocol }} for {{ family }}:
  iptables.append:
    - chain: OUTPUT
    - protocol: tcp
    - dport: {{ protocol }}
    - jump: DROP
{% endfor %}

{% endfor %}
