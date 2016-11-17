include:
  - .icinga2


install icingaweb2:
  pkg.installed:
    - pkgs:
      - icingaweb2

    - require:
      - pkg: configure icinga2 repository


setup icingaweb2 directory:
  cmd.run:
    - name: icingacli setup config directory --group icingaweb2
    - creates: /etc/icingaweb2

    - require:
      - pkg: install icingaweb2
      
  file.recurse:
    - name: /etc/icingaweb2
    - source: salt://files/etc/icingaweb2
    - user: root
    - group: icingaweb2
    - dir_mode: 2775
    - file_mode: 0640
    - template: jinja
    
    - require:
      - cmd: setup icingaweb2 directory
 
 
/etc/icingaweb2/enabledModules/monitoring:
  file.symlink:
    - target: /usr/share/icingaweb2/modules/monitoring
    - makedirs: True
    
    - require:
      - file: setup icingaweb2 directory



setup icingaweb2 database:
  postgres_user.present:
    - name: icingaweb2
    - encrypted: True
    - password: {{ pillar["icingaweb2_db_password"] }}

    - require:
      - service: enable postgresql
      - pkg: install icingaweb2

  postgres_database.present:
    - name: icingaweb2
    - encoding: utf8
    - template: template0
    - owner: icingaweb2

    - require:
      -  postgres_user: setup icingaweb2 database

  cmd.run:
    - name: psql -U icingaweb2 -d icingaweb2 -h 127.0.0.1 < /usr/share/doc/icingaweb2/schema/pgsql.schema.sql && echo "INSERT INTO icingaweb_user (name, active, password_hash) VALUES ('plg-admin', 1, '{{ salt["cmd.run"]("openssl passwd -1 " + pillar["icingaweb2_password"]) }}');" | psql -U icingaweb2 -d icingaweb2 -h 127.0.0.1
    - env:
      - PGPASSWORD: {{ pillar["icingaweb2_db_password"] }}
    - onchanges: 
      - postgres_database: setup icingaweb2 database
