/usr/local/bin:
  file.recurse:
    - source: salt://heimaailma/scriptit
    - file_mode: 755
