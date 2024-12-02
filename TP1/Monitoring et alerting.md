# III. Monitoring et alerting

## 2. Un peu d'analyse de service

Un service `netdata` a été créé suite à l'installation.

🌞 **Démarrer le service `netdata`**
```
[redz@monitoring ~]$ sudo systemctl start netdata
[redz@monitoring ~]$ sudo systemctl status netdata
● netdata.service - Real time performance monitoring
     Loaded: loaded (/usr/lib/systemd/system/netdata.service; enabled; preset: enabled)
     Active: active (running) since Mon 2024-12-02 14:49:30 CET; 14s ago
   Main PID: 2920 (netdata)
      Tasks: 93 (limit: 11083)
     Memory: 92.0M
        CPU: 4.664s
     CGroup: /system.slice/netdata.service
             ├─2920 /usr/sbin/netdata -P /run/netdata/netdata.pid -D
             ├─2921 "spawn-plugins    " "  " "                        " "  "
             ├─3089 bash /usr/libexec/netdata/plugins.d/tc-qos-helper.sh 1
             ├─3104 /usr/libexec/netdata/plugins.d/apps.plugin 1
             ├─3106 /usr/libexec/netdata/plugins.d/debugfs.plugin 1
             ├─3107 /usr/libexec/netdata/plugins.d/ebpf.plugin 1
             ├─3108 /usr/libexec/netdata/plugins.d/go.d.plugin 1
             ├─3109 /usr/libexec/netdata/plugins.d/network-viewer.plugin 1
             ├─3112 /usr/libexec/netdata/plugins.d/systemd-journal.plugin 1
             ├─3119 "spawn-setns                                         " " "
             └─3319 /bin/chronyc serverstats
```
🌞 **Déterminer sur quel port tourne Netdata**
```
[redz@monitoring ~]$ sudo ss -lnpt | grep netdata
LISTEN 0      4096       127.0.0.1:8125       0.0.0.0:*    users:(("netdata",pid=2920,fd=53))
LISTEN 0      4096         0.0.0.0:19999      0.0.0.0:*    users:(("netdata",pid=2920,fd=6))
LISTEN 0      4096           [::1]:8125          [::]:*    users:(("netdata",pid=2920,fd=52))
LISTEN 0      4096            [::]:19999         [::]:*    users:(("netdata",pid=2920,fd=7))
[redz@monitoring ~]$ sudo firewall-cmd --permanent --add-port=19999/tcp
success
```
🌞 **Visiter l'interface Web**
```
$ curl http://10.1.1.2:19999 -s | head -n 7
<!doctype html><html lang="en" dir="ltr"><head><meta charset="utf-8"/><title>Netdata</title><script>const CONFIG = {
      cache: {
        agentInfo: false,
        cloudToken: true,
        agentToken: true,
      }
    }
```
## 3. Ajouter un check

🌞 **Ajouter un check**

- vérifier la disponibilité du port où le serveur web de `web.tp1.b1` est disponible
- je veux voir la conf qu vous ajoutez dans le compte-rendu
- n'oubliez pas de redémarrer Netdata pour que ça prenne effet
- vous devriez voir dans l'interface Web que le port surveillé est disponible
  - et même la latence
  - le taux d'erreur
  - etc
  - le feu.
- vous pouvez nommer le "job" : appelez le `WEB_web.tp1.b1`

🌞 **Ajouter un check**

- vérifier la disponibilité du port où le serveur SSH de `web.tp1.b1` est disponible
- je veux voir votre conf dans le compte-rendu
- n'oubliez pas de redémarrer Netdata pour que ça prenne effet
- vous pouvez nommer le "job" : appelez le `SSH_web.tp1.b1`

## 4. Ajouter des alertes

Netdata supporte d'envoyer des alertes quand des seuils sont atteints.

C'est automatiser un peu les bails, plut^pt que devoir rester devant l'interface toute la journée.

Pour le TP, on va choisir un alerting via Discord : Netdata enverra un message dans le salon d'un serveur Discord à vous quand il y a une alerte.

🌞 **Configurer l'alerting avec Discord**

- suivre la [doc officielle](https://learn.netdata.cloud/docs/alerts-&-notifications/notifications/agent-dispatched-notifications/discord)
- lisez bien les prérequis : il vous faut un ptit serveur Discord à vous, avec un webhook de créé

🌞 **Tester que ça fonctionne**

- un peu plus bas sur la page de la doc, ils filent des commandes pour envoyer des alertes de test
- vérifier que vous recevez bien les alertes de test sur votre serveur Discord

🌞 **Euh... tester que ça fonctionne pour de vrai**

- surchargez la machine
- genre y'a des commandes faites exprès (que ce soit pour surcharger le CPU, ou la RAM, ou remplir le disque, etc)
- faites lui mal quoi
- y'a plein d'alertes par défaut avec Netdata, ça devrait remonter

🌞 **Configurer une alerte quand le port du serveur Web ne répond plus**

- si le copain `web.tp1.b1` n'héberge plue le site web on veut le savoir !

🌞 **Tester que ça fonctionne !**

- en éteignant le serveur Web
- vous m'enverrez un MP avec une invitation vers votre serveur Discord où y'a les alertes si vous arrivez jusque là :)
