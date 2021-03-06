cobbler-dependencies:
  pkg.installed:
    - pkgs:
      - python-simplejson
      - python-urlgrabber
      - python-django
      - apache2
      - libapache2-mod-proxy-html
      - libapache2-mod-wsgi
      - cman

cobbler-a2en:
  cmd.run:
      - name: |
          a2enmod proxy
          a2enmod proxy_connect
          a2enmod proxy_http
          a2enmod ssl
          a2enmod rewrite
          a2ensite default-ssl
          service apache2 restart
      - require:
        - service: apache2

cobbler-server:
  pkg.installed:
    - sources:
      - cobbler: http://download.opensuse.org/repositories/home:/libertas-ict:/cobbler26/Debian_7.0/all/cobbler_2.6.5-1_all.deb

  file.directory:
    - name: /var/lib/cobbler/webui_sessions
    - makedirs: True
    - user: www-data
    - group: www-data
    - file_mode: 660
    - dir_mode: 775

cobbler-apache-service:
  service:
    - running
    - name: apache2
    - enable: True

cobblerd-service:
  service:
    - running
    - name: cobblerd
    - enable: True
  file.managed:
    - name: /etc/cobbler/settings
    - template: jinja
    - source: salt://cobbler/files/settings

/srv/tftp:
  file.directory:
    - makedirs: True

