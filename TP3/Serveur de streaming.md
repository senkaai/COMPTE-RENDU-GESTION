# Partie II : Serveur de streaming

## 1. Préparation de la machine

🌞 **Exécution du script `autoconfig.sh` développé à la partie I**
```
[redz@music ~]$ sudo /opt/autoconfig.sh music.tp3.b1
15:28:43 [INFO] Le script d'autoconfiguration a démarré
15:28:43 [WARN] SELinux est toujours activé !
15:28:43 [INFO] Désactivation de SELinux temporaire (setenforce)
15:28:43 [INFO] Désactivation de SELinux définitive (fichier de config)
15:28:43 [INFO] Service de firewalling firewalld est activé
15:28:43 [WARN] Le service SSH tourne toujours sur le port 22/TCP
15:28:43 [INFO] Modification du fichier de configuration SSH pour écouter sur le port 3918/TCP
15:28:43 [INFO] Redémarrage du service SSH
15:28:44 [INFO] Ouverture du port 3918/TCP dans firewalld
15:28:44 [WARN] L'utilisateur redzz n'est pas dans le groupe wheel !
15:28:44 [INFO] Ajout de l'utilisateur redzz au groupe wheel
15:28:44 [INFO] Le script d'autoconfiguration s'est correctement déroulé
```
🌞 **Création d'un dossier où on hébergera les fichiers de musique**
```
sudo mkdir -p /srv/music
```
🌞 **Déposez quelques fichiers son là dedans**
```
PS C:\Users\emrep> scp "C:\Users\emrep\Downloads\MP3\Yugoslavskiy.mp3" redz@10.3.1.11:/srv/music/
redz@10.3.1.11's password:
Yugoslavskiy.mp3                                                                      100% 1620KB  35.2MB/s   00:00
PS C:\Users\emrep> scp "C:\Users\emrep\Downloads\MP3\Give Up the Goods (Just Step).mp3" redz@10.3.1.11:/srv/music/
redz@10.3.1.11's password:
Give Up the Goods (Just Step).mp3                                                     100% 5700KB  38.4MB/s   00:00
``` 
```
[redz@music ~]$ cd /srv/music
[redz@music music]$ ls
'Give Up the Goods (Just Step).mp3'   Yugoslavskiy.mp3
```
## 2. Installation du service de streaming

🌞 **Ajoutez les dépôts nécessaires pour installer Jellyfin**

```bash
sudo dnf install --nogpgcheck https://mirrors.rpmfusion.org/nonfree/el/rpmfusion-nonfree-release-$(rpm -E %rhel).noarch.rpm -y
```

🌞 **Installer le paquet `jellyfin`**
```
sudo dnf install jellyfin -y
```
🌞 **Lancer le service `jellyfin`**
```
sudo systemctl start jellyfin
sudo systemctl enable jellyfin
```
🌞 **Afficher la liste des ports TCP en écoute**
```
[redz@music ~]$ sudo ss -lnpt | grep jellyfin
LISTEN 0      512          0.0.0.0:8096      0.0.0.0:*    users:(("jellyfin",pid=12577,fd=310))
```
🌞 **Ouvrir le port derrière lequel Jellyfin écoute**
```
sudo firewall-cmd --permanent --add-port=8096/tcp
```
🌞 **Visitez l'interface Web !**
```
PS C:\Users\emrep> curl http://10.3.1.11:8096


StatusCode        : 200
StatusDescription : OK
Content           : <!doctype html><html class="preload"><head><meta charset="utf-8"><meta name="viewport" content="wid
                    th=device-width,initial-scale=1,minimum-scale=1,maximum-scale=1,user-scalable=no,viewport-fit=cover
                    ">...
RawContent        : HTTP/1.1 200 OK
                    X-Response-Time-ms: 0
                    Accept-Ranges: bytes
                    Content-Length: 7442
                    Content-Type: text/html
                    Date: Fri, 10 Jan 2025 15:59:42 GMT
                    ETag: "1da23514f439592"
                    Last-Modified: Thu, 30 Nov 20...
Forms             : {}
Headers           : {[X-Response-Time-ms, 0], [Accept-Ranges, bytes], [Content-Length, 7442], [Content-Type,
                    text/html]...}
Images            : {}
InputFields       : {}
Links             : {}
ParsedHtml        : mshtml.HTMLDocumentClass
RawContentLength  : 7442
```