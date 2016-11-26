unlock:
  cmd.run:
    {% if grains["os"] == "Fedora" %}
    - name: pkill python3.5
    {% else %}
    - name: pkill xtrlock
    {% endif %}
