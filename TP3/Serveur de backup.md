# Partie IV : Serveur de backup

## 3. Gestion du disque dur

➜ **Depuis l'interface de VirtualBox**

- ajouter un nouveau disque dur à la machine `backup.tp3.b1`
- il doit faire 5G

🌞 **Partitionner le disque dur**
```
[redz@backup ~]$ sudo fdisk /dev/sdb
```
🌞 **Formater la partition créée**
```
[redz@backup ~]$ sudo mkfs.ext4 /dev/sdb1
```
🌞 **Monter la partition**
```
[redz@backup ~]$ sudo mkdir -p /mnt/backup
[redz@backup ~]$ sudo mount /dev/sdb1 /mnt/backup
```
🌞 **Configurer un montage automatique de la partition**
```
[redz@backup ~]$ sudo nano /etc/fstab
UUID=ca948ffc-a67f-4c89-b5dd-7073e78a873e
[redz@backup ~]$ sudo umount /mnt/backup
[redz@backup ~]$ sudo systemctl daemon-reload
[redz@backup ~]$ sudo mount -a
[redz@backup ~]$ df -h /mnt/backup
Filesystem      Size  Used Avail Use% Mounted on
/dev/sdb1       4.9G   24K  4.6G   1% /mnt/backup
```

## 4. Service NFS

🌞 **Installer et configurer un service NFS**
```
[redz@backup ~]$ sudo dnf install nfs-utils -y
[redz@backup ~]$ sudo systemctl enable --now nfs-server
Created symlink /etc/systemd/system/multi-user.target.wants/nfs-server.service → /usr/lib/systemd/system/nfs-server.service.
[redz@backup ~]$ sudo nano /etc/exports
  GNU nano 5.6.1                                         /etc/exports                                         Modified
/mnt/backup 10.3.1.11(rw,sync,no_subtree_check)
[redz@backup ~]$ sudo exportfs -a
```
- le dossier `/mnt/backup` doit être partagé sur le réseau
- la machine `music.tp3.b3` devra pouvoir y accéder

🌞 **Déterminer sur quel port écoute le service NFS**
```
[redz@backup ~]$ sudo rpcinfo -p | grep nfs
    100003    3   tcp   2049  nfs
    100003    4   tcp   2049  nfs
    100227    3   tcp   2049  nfs_acl
[redz@backup ~]$ sudo ss -lnpt | grep 2049
LISTEN 0      64           0.0.0.0:2049       0.0.0.0:*
LISTEN 0      64              [::]:2049          [::]:*
```
### B. El cliente

🌞 **Installer les outils NFS**
```
sudo dnf install nfs-utils -y
```
🌞 **Essayer d'accéder au dossier partagé**
```
[redz@music ~]$ sudo mkdir -p /mnt/backup
[redz@music ~]$ sudo mount 10.3.1.13:/mnt/backup /mnt/backup
[redz@music ~]$ df -h /mnt/backup
Filesystem             Size  Used Avail Use% Mounted on
10.3.1.13:/mnt/backup  4.9G     0  4.6G   0% /mnt/backup
```

🌞 **Configurer un montage automatique**
```
[redz@music ~]$ sudo nano /etc/fstab

#
# /etc/fstab
# Created by anaconda on Fri Nov 29 15:02:06 2024
#
# Accessible filesystems, by reference, are maintained under '/dev/disk/'.
# See man pages fstab(5), findfs(8), mount(8) and/or blkid(8) for more info.
#
# After editing this file, run 'systemctl daemon-reload' to update systemd
# units generated from this file.
#
/dev/mapper/rl_vbox-root /                       xfs     defaults        0 0
UUID=a3990df4-a9f1-4c61-9e2f-8bbc2b020c13 /boot                   xfs     defaults        0 0
/dev/mapper/rl_vbox-swap none                    swap    defaults        0 0

10.3.1.13:/mnt/backup /mnt/backup nfs defaults 0 0
[redz@music ~]$ sudo umount /mnt/backup
[redz@music ~]$ sudo systemctl daemon-reload
[redz@music ~]$ sudo mount -a
[redz@music ~]$ df -h /mnt/backup
Filesystem             Size  Used Avail Use% Mounted on
10.3.1.13:/mnt/backup  4.9G     0  4.6G   0% /mnt/backup
```

## 5. Service de backup

⚠️⚠️⚠️ **On reste sur `music.tp3.b3` pour cette section 4.**

Allez, on termine le TP avec l'écriture d'un script `bash` qui tourne à intervalles réguliers sur `music.tp3.b3` et effectue une sauvegarde de la musique !

Comme vous l'avez compris, j'espère meow, on va archiver la musique dans le dossier accédé à travers le réseau : `/mnt/music_backup`.

### A. Script de sauvegarde

Le script, très simpliste, va effectuer les opérations suivantes :

- compresser au format `.tar.gz` (ou `.zip` si vraiment t'as envie de zipper des trucs) toute la musique de Jellyfin
- déplacer cette archive compressée dans `/mnt/music_backup` pour que ce soit stockée sur le serveur de backup
- le nom de l'archive sera très précis : `music_yymmdd_hhmmss.tar.gz`
  - par exemple : `music_250110_103145.tar.gz`
  - dans cet exemple, c'est la backup du 1er janvier 2025 à 10:31:45.
- le script affiche un message de succès si la backup s'est bien effectuée

🌞 **Script `backup.sh`**
```
[redz@music ~]$ sudo nano /opt/backup.sh
#!/bin/bash

SOURCE_DIR="/srv/music"
DEST_DIR="/mnt/music_backup"

TIMESTAMP=$(date +"%y%m%d_%H%M%S")
ARCHIVE_NAME="music_${TIMESTAMP}.tar.gz"

tar -czf "${DEST_DIR}/${ARCHIVE_NAME}" -C "${SOURCE_DIR}" .

if [ $? -eq 0 ];
then
  echo "Backup successful: ${ARCHIVE_NAME}"
else
  echo "Backup failed"
fi
```

### B. Sauvegarde à intervalles réguliers

Pour ça, comme au TP2 : on va créer un service !

🌞 **Créer un nouveau service `backup.service`**
```
[redz@music ~]$ sudo nano /etc/systemd/system/backup.service

Description=Backup Music Service

[Service]
Type=oneshot
ExecStart=/opt/backup.sh

[Install]
WantedBy=multi-user.target
```

> Changez la description pour un truc un peu fancy !

🌞 **Indiquer au système qu'on a ajouté un nouveau service**

- ça se fait en exécutant la commande suivante :

```bash
$ sudo systemctl daemon-reload
```

🌞 **Utiliser et tester le nouveau service**
```
[redz@music ~]$ sudo systemctl start backup
[redz@music ~]$ sudo systemctl status backup
○ backup.service - Backup Music Service
     Loaded: loaded (/etc/systemd/system/backup.service; disabled; preset: disabled)
     Active: inactive (dead) since Wed 2025-01-15 09:17:46 CET; 1s ago
TriggeredBy: ● backup.timer
    Process: 3134 ExecStart=/opt/backup.sh (code=exited, status=0/SUCCESS)
   Main PID: 3134 (code=exited, status=0/SUCCESS)
        CPU: 787ms

Jan 15 09:17:45 music.tp3.b1 systemd[1]: Starting Backup Music Service...
Jan 15 09:17:46 music.tp3.b1 backup.sh[3134]: Backup successful: music_250115_091745.tar.gz
Jan 15 09:17:46 music.tp3.b1 systemd[1]: backup.service: Deactivated successfully.
Jan 15 09:17:46 music.tp3.b1 systemd[1]: Finished Backup Music Service.
```

🌞 **Faire un test et prouvez que ça a fonctionné**

``` 
[redz@music ~]$ sudo systemctl start backup
[redz@music ~]$ sudo systemctl status backup
○ backup.service - Backup Music Service
     Loaded: loaded (/etc/systemd/system/backup.service; disabled; preset: disabled)
     Active: inactive (dead) since Wed 2025-01-15 09:18:51 CET; 1s ago
TriggeredBy: ● backup.timer
    Process: 3149 ExecStart=/opt/backup.sh (code=exited, status=0/SUCCESS)
   Main PID: 3149 (code=exited, status=0/SUCCESS)
        CPU: 582ms

Jan 15 09:18:50 music.tp3.b1 systemd[1]: Starting Backup Music Service...
Jan 15 09:18:51 music.tp3.b1 backup.sh[3149]: Backup successful: music_250115_091850.tar.gz
Jan 15 09:18:51 music.tp3.b1 systemd[1]: backup.service: Deactivated successfully.
Jan 15 09:18:51 music.tp3.b1 systemd[1]: Finished Backup Music Service.
[redz@music ~]$ ls /mnt/music_backup
music_250115_091258.tar.gz  music_250115_091341.tar.gz
```

🌞 **Configurer un lancement automatique du service à intervalles réguliers**
```
[redz@music ~]$ sudo nano /etc/systemd/system/backup.timer  

Description=Run Backup Music Service every hour

[Timer]
OnCalendar=hourly
Persistent=true

[Install]
WantedBy=timers.target
```