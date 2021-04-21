/etc/skel/testikansio:
  file.directory

/usr/local/bin:
  file.recurse:
    - source: salt://skel/scriptit/
    - file_mode: 755
 
#testi02:
#  user.present:
#    - fullname: ToniVapalo Testikayttaja
#    - home: /home/testi02
#    - shell: /bin/bash
    
