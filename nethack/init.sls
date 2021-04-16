nethack-console:
  pkg.installed

/home/toni/.nethackrc:
  file.managed:
    - source: salt://nethack/.nethackrc
    - user: toni
    - group: toni
    - file_mode: 644
