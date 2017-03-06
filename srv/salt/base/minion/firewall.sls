firewall:
  pkg.installed:
    - name: iptables


{% for family in ["ipv4", "ipv6"] %}
{% for table in ["INPUT", "FORWARD", "OUTPUT"] %}
allow policy for {{ family }} on {{ table }}:
  iptables.set_policy:
    - chain: {{ table }}
    - policy: ACCEPT
    - family: {{ family }}
{% endfor %}

{% for protocol in ["http", "https"] %}
{% for site in pillar["allowed_sites"] %}
allow {{ site }} for {{ protocol }} for {{ family }}:
  iptables.append:
    - chain: OUTPUT
    - protocol: tcp
    - dport: {{ protocol }}
    - destination: {{ site }}
    - jump: ACCEPT
{% endfor %}

restrict {{ protocol }} for {{ family }}:
  iptables.append:
    - chain: OUTPUT
    - protocol: tcp
    - dport: {{ protocol }}
    - jump: DROP
{% endfor %}

{% endfor %}
