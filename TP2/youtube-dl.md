# Partie III : Script yt-dlp

### B. Rendu attendu

🌞 **Vous fournirez dans le compte-rendu :**

- le script `yt.sh` dans le dépôt git
- un exemple d'exécution
  - genre tu le lances, et tu copie/colles le résultats dans le compte-rendu
- un `cat /var/log/yt/download.log`
  - pour que je vois quelques lignes de logss

```
[redz@node1 ~]$ /opt/yt/yt.sh https://www.youtube.com/watch?v=sNx57atloH8
Video https://www.youtube.com/watch?v=sNx57atloH8 was downloaded.
File path : /opt/yt/downloads/tomato anxiety/tomato anxiety.mp4
```

```
[redz@node1 ~]$ cat /var/log/yt/download.log
[24/12/16 15:08:59] Video https://www.youtube.com/watch?v=sNx57atloH8 was downloaded. File path : /opt/yt/downloads/tomato anxiety/tomato anxiety.mp4
[24/12/16 15:11:17] Video https://www.youtube.com/watch?v=eDEKffbWeJ0 was downloaded. File path : /opt/yt/downloads/TYLER1 SCREAM/TYLER1 SCREAM.mp4
[24/12/16 15:11:30] Video https://youtu.be/eDEKffbWeJ0?si=ijVJEKZUoKwy3UfN was downloaded. File path : /opt/yt/downloads/TYLER1 SCREAM/TYLER1 SCREAM.mp4
[24/12/16 15:13:16] Video https://youtube.com/shorts/b44UciVXntc?si=U_bWHWgAiB7aQv19 was downloaded. File path : /opt/yt/downloads/Programming With Russian #shorts #meme/Programming With Russian #shorts #meme.mp4
```

## 2. MAKE IT A SERVICE

### C. Rendu attendu

🌞 **Toutes les commandes que vous utilisez**

- pour gérer les permissions du dossier `/opt/yt` par exemple
  
```
[redz@node1 ~]$ sudo useradd -r -s /bin/false yt
[redz@node1 ~]$ sudo chmod +x /opt/yt/yt-next-gen.sh
[redz@node1 ~]$ sudo chown -R yt:yt /opt/yt
[redz@node1 ~]$ sudo chown -R yt:yt /var/log/yt
[redz@node1 ~]$ sudo chown yt:yt /opt/yt/yt-next-gen.sh
```

🌞 **Le script `yt-next-gen.sh` dans le dépôt git**

```
Dans le dépôt -_- !
```

🌞 **Le fichier `yt.service` dans le dépôt git**

```
Dans le dépôt -_- !
```