php:
  pkg.installed

/etc/php/7.3/apache2/php.ini:
  file.managed:
    - source: salt://php/php.ini
    
