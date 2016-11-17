clean:
  cmd.run:
    - name: "systemctl stop lightdm.service && rsync -a --delete /etc/skel/ /home/polyprog && chown -R polyprog: /home/polyprog && rm -rf /tmp/* && systemctl start lightdm"
