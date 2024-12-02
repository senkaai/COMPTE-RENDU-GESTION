# II. Service HTTP

## 1. Mise en places

🌞 **Installer le serveur NGINX**
```
[redz@wep ~]$ dnf search NGINX
Rocky Linux 9 - BaseOS                                                                  1.2 MB/s | 2.3 MB     00:01
Rocky Linux 9 - AppStream                                                               1.2 MB/s | 8.3 MB     00:06
Rocky Linux 9 - Extras                                                                   30 kB/s |  16 kB     00:00
============================================ Name & Summary Matched: NGINX =============================================
nginx-all-modules.noarch : A meta package that installs all available Nginx modules
nginx-core.x86_64 : nginx minimal core
nginx-filesystem.noarch : The basic directory layout for the Nginx server
nginx-mod-http-image-filter.x86_64 : Nginx HTTP image filter module
nginx-mod-http-perl.x86_64 : Nginx HTTP perl module
nginx-mod-http-xslt-filter.x86_64 : Nginx XSLT module
nginx-mod-mail.x86_64 : Nginx mail modules
nginx-mod-stream.x86_64 : Nginx stream modules
pcp-pmda-nginx.x86_64 : Performance Co-Pilot (PCP) metrics for the Nginx Webserver
================================================= Name Matched: NGINX ==================================================
nginx.x86_64 : A high performance web server and reverse proxy server
[redz@wep ~]$ sudo dnf install nginx
[sudo] password for redz:
Last metadata expiration check: 0:18:06 ago on Fri 29 Nov 2024 05:23:34 PM CET.
Dependencies resolved.
========================================================================================================================
 Package                         Architecture         Version                             Repository               Size
========================================================================================================================
Installing:
 nginx                           x86_64               2:1.20.1-20.el9.0.1                 appstream                36 k
Installing dependencies:
 nginx-core                      x86_64               2:1.20.1-20.el9.0.1                 appstream               566 k
 nginx-filesystem                noarch               2:1.20.1-20.el9.0.1                 appstream               8.4 k
 rocky-logos-httpd               noarch               90.15-2.el9                         appstream                24 k

Transaction Summary
========================================================================================================================
Install  4 Packages

Total download size: 634 k
Installed size: 1.8 M
Is this ok [y/N]: y
Downloading Packages:
(1/4): nginx-filesystem-1.20.1-20.el9.0.1.noarch.rpm                                     52 kB/s | 8.4 kB     00:00
(2/4): rocky-logos-httpd-90.15-2.el9.noarch.rpm                                         104 kB/s |  24 kB     00:00
(3/4): nginx-1.20.1-20.el9.0.1.x86_64.rpm                                               141 kB/s |  36 kB     00:00
(4/4): nginx-core-1.20.1-20.el9.0.1.x86_64.rpm                                          1.7 MB/s | 566 kB     00:00
------------------------------------------------------------------------------------------------------------------------
Total                                                                                   338 kB/s | 634 kB     00:01
Running transaction check
Transaction check succeeded.
Running transaction test
Transaction test succeeded.
Running transaction
  Preparing        :                                                                                                1/1
  Running scriptlet: nginx-filesystem-2:1.20.1-20.el9.0.1.noarch                                                    1/4
  Installing       : nginx-filesystem-2:1.20.1-20.el9.0.1.noarch                                                    1/4
  Installing       : nginx-core-2:1.20.1-20.el9.0.1.x86_64                                                          2/4
  Installing       : rocky-logos-httpd-90.15-2.el9.noarch                                                           3/4
  Installing       : nginx-2:1.20.1-20.el9.0.1.x86_64                                                               4/4
  Running scriptlet: nginx-2:1.20.1-20.el9.0.1.x86_64                                                               4/4
  Verifying        : rocky-logos-httpd-90.15-2.el9.noarch                                                           1/4
  Verifying        : nginx-filesystem-2:1.20.1-20.el9.0.1.noarch                                                    2/4
  Verifying        : nginx-2:1.20.1-20.el9.0.1.x86_64                                                               3/4
  Verifying        : nginx-core-2:1.20.1-20.el9.0.1.x86_64                                                          4/4

Installed:
  nginx-2:1.20.1-20.el9.0.1.x86_64                              nginx-core-2:1.20.1-20.el9.0.1.x86_64
  nginx-filesystem-2:1.20.1-20.el9.0.1.noarch                   rocky-logos-httpd-90.15-2.el9.noarch

Complete!
```

🌞 **Démarrer le service NGINX**
```
[redz@wep ~]$ sudo systemctl start nginx
```
🌞 **Déterminer sur quel port tourne NGINX**
```
[redz@wep ~]$ sudo ss -lnpt | grep nginx
LISTEN 0      511          0.0.0.0:80        0.0.0.0:*    users:(("nginx",pid=1798,fd=6),("nginx",pid=1797,fd=6))
LISTEN 0      511             [::]:80           [::]:*    users:(("nginx",pid=1798,fd=7),("nginx",pid=1797,fd=7))
[redz@wep ~]$ sudo firewall-cmd --permanent --add-port=80/tcp
success
```
🌞 **Déterminer les processus liés au service NGINX**
```
[redz@wep ~]$ ps aux | grep nginx
root        1797  0.0  0.0  11292  1600 ?        Ss   17:43   0:00 nginx: master process /usr/sbin/nginx
nginx       1798  0.0  0.2  15532  5312 ?        S    17:43   0:00 nginx: worker process
redz        1820  0.0  0.1   6408  2304 pts/0    S+   17:45   0:00 grep --color=auto nginx
```
🌞 **Déterminer le nom de l'utilisateur qui lance NGINX**
```
[redz@wep ~]$ cat /etc/passwd | grep root
root:x:0:0:root:/root:/bin/bash
```
🌞 **Test !**
```
$ curl http://10.1.1.1:80 | head -n 7
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0<!doctype html>
<html>
  <head>
    <meta charset='utf-8'>
    <meta name='viewport' content='width=device-width, initial-scale=1'>
    <title>HTTP Server Test Page powered by: Rocky Linux</title>
    <style type="text/css">
100  7620  100  7620    0     0   422k      0 --:--:-- --:--:-- --:--:--  437k
curl: Failed writing body
```
## 2. Analyser la conf de NGINX

🌞 **Déterminer le path du fichier de configuration de NGINX**
```
[redz@wep ~]$ ls -al /etc/nginx/nginx.conf
-rw-r--r--. 1 root root 2334 Nov  8 17:43 /etc/nginx/nginx.conf
```
🌞 **Trouver dans le fichier de conf**
```
[redz@wep ~]$ cat /etc/nginx/nginx.conf | grep 'server {' -A 20
    server {
        listen       80;
        listen       [::]:80;
        server_name  _;
        root         /usr/share/nginx/html;

        # Load configuration files for the default server block.
        include /etc/nginx/default.d/*.conf;

        error_page 404 /404.html;
        location = /404.html {
        }

        error_page 500 502 503 504 /50x.html;
        location = /50x.html {
        }
    }

# Settings for a TLS enabled server.
#
#    server {
#        listen       443 ssl http2;
#        listen       [::]:443 ssl http2;
#        server_name  _;
#        root         /usr/share/nginx/html;
#
#        ssl_certificate "/etc/pki/nginx/server.crt";
#        ssl_certificate_key "/etc/pki/nginx/private/server.key";
#        ssl_session_cache shared:SSL:1m;
#        ssl_session_timeout  10m;
#        ssl_ciphers PROFILE=SYSTEM;
#        ssl_prefer_server_ciphers on;
#
#        # Load configuration files for the default server block.
#        include /etc/nginx/default.d/*.conf;
#
#        error_page 404 /404.html;
#            location = /40x.html {
#        }
#
#        error_page 500 502 503 504 /50x.html;
[redz@wep ~]$ cat /etc/nginx/nginx.conf | grep 'include'
include /usr/share/nginx/modules/*.conf;
    include             /etc/nginx/mime.types;
    # See http://nginx.org/en/docs/ngx_core_module.html#include
    include /etc/nginx/conf.d/*.conf;
        include /etc/nginx/default.d/*.conf;
#        include /etc/nginx/default.d/*.conf;
[redz@wep ~]$ cat /etc/nginx/nginx.conf | grep 'user'
user nginx;
    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '"$http_user_agent" "$http_x_forwarded_for"';
```
## 3. Déployer un nouveau site web

🌞 **Créer un site web**
```
[redz@wep ~]$ sudo mkdir -p /var/www/tp1_parc
[sudo] password for redz:
[redz@wep ~]$ echo '<h1>MEOW mon premier serveur web</h1>' | sudo tee /var/www/tp1_parc/index.html
<h1>MEOW mon premier serveur web</h1>
```
🌞 **Gérer les permissions**
```
sudo chown -R nginx:nginx /var/www/tp1_parc
```
🌞 **Adapter la conf NGINX**
```
[redz@wep tp1_parc]$ sudo nano /etc/nginx/nginx.conf
[redz@wep tp1_parc]$ sudo systemctl restart nginx
[redz@wep tp1_parc]$ echo $RANDOM
12969
[redz@wep tp1_parc]$ sudo nano /etc/nginx/conf.d/tp1_parc.conf
server {
  listen 12969;

  root /var/www/tp1_parc;
}
[redz@wep tp1_parc]$ sudo firewall-cmd --permanent --remove-port=80/tcp
success
[redz@wep tp1_parc]$ sudo firewall-cmd --permanent --add-port=12969/tcp
success
[redz@wep tp1_parc]$ sudo firewall-cmd --reload
success
[redz@wep tp1_parc]$ sudo systemctl restart nginx
[redz@wep tp1_parc]$ sudo firewall-cmd --list-all | grep 12969
  ports: 22/tcp 12969/tcp
```
🌞 **Visitez votre super site web**

```
$ curl http://10.1.1.1:12969 | head -n 7
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100    38  100    38    0     0   1008      0 --:--:-- --:--:-- --:--:--  1027<h1>MEOW mon premier serveur web</h1>
```