unlock:
  cmd.run:
    {% if grains["os"] == "Fedora" %}
    - name: pkill pyxtrlock
    {% else %}
    - name: pkill xtrlock
    {% endif %}
