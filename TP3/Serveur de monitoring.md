# Partie III : Serveur de monitoring

⚠️⚠️⚠️ **Sauf contre-indication, toutes les manipulations de cette partie sont à réaliser sur `monitoring.tp3.b1`.**

Un peu de répétition ici : on va utiliser Netdata pour qu'il surveille que Jellyfin est bien tout le temps allumé.

J'vais donc vous donner très peu d'indications ici, c'est (censé hihi) être une répétition du TP1.

🌞 **Dérouler le script `autoconfig.sh` développé à la partie I**
```
[redz@monitoring ~]$ sudo /opt/autoconfig.sh monitoring.tp3.b1
17:39:40 [INFO] Le script d'autoconfiguration a démarré
17:39:40 [WARN] SELinux est toujours activé !
17:39:40 [INFO] Désactivation de SELinux temporaire (setenforce)
17:39:40 [INFO] Désactivation de SELinux définitive (fichier de config)
17:39:40 [INFO] Service de firewalling firewalld est activé
17:39:40 [WARN] Le service SSH tourne toujours sur le port 22/TCP
17:39:40 [INFO] Modification du fichier de configuration SSH pour écouter sur le port 9518/TCP
17:39:40 [INFO] Redémarrage du service SSH
17:39:40 [INFO] Ouverture du port 9518/TCP dans firewalld
17:39:41 [INFO] Le script d'autoconfiguration s'est correctement déroulé
```
🌞 **Installer Netdata**
```
curl https://get.netdata.cloud/kickstart.sh > /tmp/netdata-kickstart.sh && sh /tmp/netdata-kickstart.sh --no-updates --stable-channel --disable-telemetry
```
🌞 **Ajouter un check TCP**
```
sudo nano /etc/netdata/go.d/portcheck.conf
jobs:
  - name: Jellyfin
    host: 10.3.1.1
    ports:
      - 8096
```

🌞 **Ajout d'une alerte Discord**
```
Sur le même discord que le TP1, je le met ici au cas-où^^

https://discord.gg/3MTn7ewf3Q
```