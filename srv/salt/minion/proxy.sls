dnf proxy:
  file.append:
    - name: /etc/dnf/dnf.conf
    - text: proxy=http://polyprog-monitor.local:3128

