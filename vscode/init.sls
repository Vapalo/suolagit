/etc/apt/trusted.gpg.d/microsoft.gpg:
  file.managed:
    - source: salt://vscode/microsoft.gpg


/etc/apt/sources.list.d/vscode.list:
  file.managed:
    - source: salt://vscode/vscode.list
