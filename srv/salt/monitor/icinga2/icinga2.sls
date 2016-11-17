include:
  - .requisites


configure icinga2 repository:
  pkg.installed:
    - sources:
      - icinga-rpm-release: https://packages.icinga.org/fedora/24/release/noarch/icinga-rpm-release-24-1.fc24.noarch.rpm
      
    - require:
      - service: enable postgresql
      - service: enable httpd


install icinga2:
  pkg.installed:
    - pkgs:
      - icinga2
      - icingacli 
      - icinga2-ido-pgsql

    - require:
      - pkg: configure icinga2 repository

  service.running:
    - name: icinga2
    - enable: True
    
    - require:
      - pkg: install icinga2


configure icinga2 pgsql:
  cmd.run:
    - name: icinga2 feature enable ido-pgsql
    - creates: /etc/icinga2/features-enabled/ido-pgsql.conf
    - watch_in: icinga2 service
    
    - require:
      - pkg: install icinga2
      
  file.recurse:
    - name: /etc/icinga2
    - source: salt://files/etc/icinga2
    - user: icinga
    - group: icinga
    - dir_mode: 2775
    - file_mode: 0644
    - template: jinja
    
    - watch_in: icinga2 service


configure icinga2 command:
  cmd.run:
    - name: icinga2 feature enable command
    - creates: /etc/icinga2/features-enabled/command.conf
    - watch_in: icinga2 service
    
    - require:
      - pkg: install icinga2


setup icinga2 database:
  postgres_user.present:
    - name: icinga
    - password: {{ pillar["icinga2_db_password"] }}
    - encrypted: True

    - require:
      - service: enable postgresql
      - pkg: install icinga2

  postgres_database.present:
    - name: icinga
    - encoding: utf8
    - template: template0
    - owner: icinga

    - require:
      -  postgres_user: setup icinga2 database

  cmd.run:
    - name: psql -U icinga -d icinga -h 127.0.0.1 < /usr/share/icinga2-ido-pgsql/schema/pgsql.sql
    - env:
      - PGPASSWORD: {{ pillar["icinga2_db_password"] }}
    - onchanges: 
      - postgres_database: setup icinga2 database


install nagios plugins:
  pkg.installed:
    - pkgs:
      - nagios-plugins-disk
      - nagios-plugins-swap
      - nagios-plugins-ssh
      - nagios-plugins-load
      - nagios-plugins-ping
      - perl-Nagios-Plugin
      
    - require:
      - pkg: install icinga2

    - watch_in: icinga2 service
      
  file.recurse:
    - name: /usr/lib64/nagios
    - source: salt://files/usr/lib64/nagios
    - user: root
    - group: root
    - dir_mode: 2775
    - file_mode: 0755
    
    - require:
      - pkg: install icinga2
      
    - watch_in: icinga2 service


register rsync plugin:
  file.append:
    - name: /etc/icinga2/conf.d/commands.conf
    - source: salt://files/misc/icinga2/conf.d/commands.conf
    
    - require:
      - pkg: install icinga2
      
    - require_in:
      - service: install icinga2

 
{% if salt["user.info"]("icinga") %}
salt ssh keys:
  file.recurse:
    - name: {{ salt['user.info']("icinga").home }}/.ssh/
    - source: salt://files/misc/icinga2/ssh
    - file_mode: 400
    - dir_mode: 2770
    - user: icinga
    - group: icinga
    - makedirs: True
    
    - require:
      - pkg: install icinga2
    
    - require_in:
      - service: install icinga2
{% endif %}


configure icinga2:
  file.managed:
    - name: /etc/icinga2/conf.d/hosts.conf
    - source: salt://files/etc/icinga2/conf.d/hosts.conf
    - user: root
    - group: root
    - mode: 444
    - template: jinja
    
    - require:
      - pkg: install icinga2
     
    - watch_in:
      - service: install icinga2
      
      
/root/.ssh/:
  file.recurse:
    - source: salt://files/misc/icinga2/ssh
    - file_mode: 400
    - dir_mode: 2770
    - user: root
    - group: root
    - makedirs: True
    
