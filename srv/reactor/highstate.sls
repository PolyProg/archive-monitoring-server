# Put minions in high state
minion_highstate:
  local.state.highstate:
    - tgt: {{ data['id'] }}
