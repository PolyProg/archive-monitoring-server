enable postgresql:
  pkg.installed:
    - name: postgresql-server
      
  service.running:
    - name: postgresql
    - enable: True
    - require:
      - pkg: enable postgresql
      
  cmd.run:
    - name: postgresql-setup --initdb --unit postgresql
    - creates: /var/lib/pgsql/data/postgresql.conf

    - require_in:
      - service: enable postgresql
      

disable ident authentication:
  file.comment:
    - name: /var/lib/pgsql/data/pg_hba.conf
    - regex: ^host.*ident$
    
    - require:
      - cmd: enable postgresql
     
    - watch_in:
      - service: enable postgresql
     
 
enable md5 authentication ipv4:
  file.append:
    - name: /var/lib/pgsql/data/pg_hba.conf
    - text: "host	all		all		127.0.0.1/32		md5"
    
    - require:
      - pkg: enable postgresql
    
    - watch_in:
      - service: enable postgresql
       
enable md5 authentication ipv6:
  file.append:
    - name: /var/lib/pgsql/data/pg_hba.conf
    - text: "host	all		all		::1/128			md5"
    
    - require:
      - pkg: enable postgresql
    
    - watch_in:
      - service: enable postgresql


enable httpd:
  pkg.installed:
    - name: httpd
    
  service.running:
    - name: httpd
    - enable: True
    - require:
      - pkg: enable httpd

  file.append:
    - name: /etc/php.ini
    - text: date.timezone = Europe/Zurich
    
    - require:
      - pkg: enable httpd
      
    - watch_in:
      - service: enable httpd
      
  selinux.boolean:
    - name: httpd_can_network_connect_db
    - value: True
    - persist: True

    - require:
      - pkg: enable httpd
