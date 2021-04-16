openssh-server:
  pkg.installed

/etc/ssh/sshd_config:
  file.managed:
    - source: salt://ssh/sshd_config

ssh.service:
  service.running:
    - watch:
      - file: /etc/ssh/sshd_config
