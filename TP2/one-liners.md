# Partie I : Des beaux one-liners

## 1. Intro

**Le but de cette première partie, c'est un échauffement, vous allez fabriquer des commandes pour aller récupérer des infos précises.**

Par exemple, si je demande : "afficher la quantité de RAM disponible en Gi", il ne faut afficher QUE la quantité de RAM dispo.

Voilà comment procéder :

```bash
# déjà, trouver une commande qui donne l'info
# pour afficher l'état de la RAM, c'est la commande free
❯ free -mh
               total        used        free      shared  buff/cache   available
Mem:           7.6Gi       3.8Gi       205Mi       731Mi       4.6Gi       3.8Gi
Swap:          8.0Gi       512Ki       8.0Gi
# l'info qu'on veut est dans la colonne tout à droite, sur la ligne du milieu

# déjà on récupère que la ligne du milieu en faisant un grep 'Mem:'
❯ free -mh | grep 'Mem:'
Mem:           7.6Gi       3.8Gi       225Mi       730Mi       4.6Gi       3.8Gi

# ensuite on remplace les espaces consécutifs par un seul espace
# ce sera utile pour la prochaine commande
❯ free -mh | grep 'Mem:' | tr -s ' '
Mem: 7.6Gi 3.7Gi 366Mi 730Mi 4.6Gi 3.8Gi

# cut permet de récupérer une seule colonne dans la ligne
# avec -d on indique le delemiter : le caractère qui définit les colonnes
# avec -f on indique le field : le numéro de la colonne qu'on veut afficher
❯ free -mh | grep 'Mem:' | tr -s ' ' | cut -d' ' -f7
3.8Gi

# et hop !
```

La réponse à "afficher la quantité de RAM disponible en Gi" serait donc : `free -mh | grep 'Mem:' | tr -s ' ' | cut -d' ' -f7`.

## 2. Let's go

Chaque 🌞 dans cette partie c'est une seule commande qui donne la réponse attendue, et uniquement la réponse attendue.

Vous n'êtes pas à limité à ça, mais je vous indique avec l'emoji 📎 la commande que je vous recommande d'utiliser pour réaliser chaque étape.

🌞 **Afficher la quantité d'espace disque disponible**

```bash
[redz@node1 ~]$ df -h / | grep '/' | tr -s ' ' | cut -d' ' -f4
6.8G
```

🌞 **Afficher combien de fichiers il est possible de créer**

```bash
[redz@node1 ~]$ df -i / | grep '/' | tr -s ' ' | cut -d' ' -f4
4197849
```

🌞 **Afficher l'heure et la date**

```bash
date +"%d/%m/%y %H:%M:%S"
```

🌞 **Afficher la version de l'OS précise**

```bash
[redz@node1 ~]$ source /etc/os-release && echo "$NAME $VERSION"
Rocky Linux 9.5 (Blue Onyx)
```

🌞 **Afficher la version du kernel en cours d'utilisation précise**

```bash
[redz@node1 ~]$ uname -r
5.14.0-503.14.1.el9_5.x86_64
```

🌞 **Afficher le chemin vers la commande `python3`**

```bash
[redz@node1 ~]$ which python3
/usr/bin/python3
```

🌞 **Afficher l'utilisateur actuellement connecté**

```bash
[redz@node1 ~]$ echo $USER
redz
```

🌞 **Afficher le shell par défaut de votre utilisateur actuellement connecté**

```bash
[redz@node1 ~]$ cat /etc/passwd | grep $USER | cut -d: -f7
/bin/bash
```

🌞 **Afficher le nombre de paquets installés**

```bash
[redz@node1 ~]$ rpm -qa | wc -l
358
```

🌞 **Afficher le nombre de ports en écoute**

```bash
[redz@node1 ~]$ ss -lnpt | grep LISTEN | wc -l
2
```