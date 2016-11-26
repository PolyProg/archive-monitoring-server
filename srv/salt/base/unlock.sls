unlock:
  cmd.run:
    {% if grains["os"] == "Fedora" %}
    - name: pkill pyhton3.5
    {% else %}
    - name: pkill xtrlock
    {% endif %}
