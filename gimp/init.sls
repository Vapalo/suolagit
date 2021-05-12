gimp:
  pkg.installed

/home/toni/.config/GIMP:
  file.directory:
    - user: toni
    - group: toni
    - mode: 755

/home/toni/.config/GIMP/2.10:
  file.directory:
    - user: toni
    - group: toni
    - mode: 755
    

/home/toni/.config/GIMP/2.10/themerc:
  file.managed:
    - source: salt://gimp/themerc
    - user: toni
    - group: toni

/home/toni/.config/GIMP/2.10/gimprc:
  file.managed:
    - source: salt://gimp/gimprc
    - user: toni
    - group: toni

/home/toni/.config/GIMP/2.10/profilerc:
  file.managed:
    - source: salt://gimp/profilerc
    - user: toni
    - group: toni
