apache2:
  pkg.installed
    
userdir:
  cmd.run:
    - name: a2enmod userdir
    - creates: /etc/apache2/mods-enabled/userdir.load
    - require:
      - pkg: apache2

apache2.service:
  service.running:
    - watch:
      - cmd: userdir

#restart:
#  cmd.run:
#    - name: systemctl restart apache2
#    - require:
#      - pkg: apache2      

removedefault:
  cmd.run:
    - name: echo "Empty page" > /var/www/html/index.html
    - require:
      - pkg: apache2

/home/toni/public_html:
  file.directory:
    - name: /home/toni/public_html
    - user: toni
    - group: toni
    - mode: 755

/home/toni/public_html/index.html:
  file.managed:
    - source: salt://apache/index.html
    - user: toni
    - group: toni
    - file_mode: 644

#apache2.service:
#  service.running:
#    - watch:
#      - file: /home/toni/public_html/index.html
