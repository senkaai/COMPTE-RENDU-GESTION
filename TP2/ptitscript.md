# Partie II : Un premier ptit script

> **Je vous recommande *TRES FORT* d'utiliser votre VSCode connecté à la VM pour ce TP. Ne vous faites pas du mal à coder avec `nano` ou `vim` si vous maîtrisez pas.**

## 2. Premiers pas scripting

🌞 **Ecrire un script qui produit exactement l'affichage demandé**

```bash
[redz@node1 ~]$ sudo nano /opt/id.sh
#!/bin/bash
# Script pour afficher les informations système
# redz 09/12/2024

USER=$(echo $USER)
DATE=$(date +"%d/%m/%y %H:%M:%S")
SHELL=$(cat /etc/passwd | grep $USER | cut -d: -f7)
OS=$(source /etc/os-release && echo "$NAME $VERSION")
KERNEL=$(uname -r)
RAM=$(free -mh | grep 'Mem:' | tr -s ' ' | cut -d' ' -f7)
DISK=$(df -h / | grep '/' | tr -s ' ' | cut -d' ' -f4)
INODE=$(df -i / | grep '/' | tr -s ' ' | cut -d' ' -f4)
PACKETS=$(rpm -qa | wc -l)
PORTS=$(ss -lnpt | grep LISTEN | wc -l)
PYTHON=$(which python3)

echo "Salu a toa $USER."
echo "Nouvelle connexion $DATE."
echo "Connecté avec le shell $SHELL."
echo "OS : $OS - Kernel : $KERNEL"
echo "Ressources :"
echo "  - $RAM RAM dispo"
echo "  - $DISK espace disque dispo"
echo "  - $INODE fichiers restants"
echo "Actuellement :"
echo "  - $PACKETS paquets installés"
echo "  - $PORTS port(s) ouvert(s)"
echo "Python est bien installé sur la machine au chemin : $PYTHON"
```

```bash
[redz@node1 ~]$ /opt/id.sh
Salu a toa redz.
Nouvelle connexion 09/12/24 16:25:07.
Connecté avec le shell /bin/bash.
OS : Rocky Linux 9.5 (Blue Onyx) - Kernel : 5.14.0-503.14.1.el9_5.x86_64
Ressources :
  - 1.4Gi RAM dispo
  - 6.8G espace disque dispo
  - 4197848 fichiers restants
Actuellement :
  - 358 paquets installés
  - 2 port(s) ouvert(s)
Python est bien installé sur la machine au chemin : /usr/bin/python3
```

## 3. Amélioration du script

On continue à s'entraîner, mais vous allez avoir besoin de `if` pour cette section.

La syntaxe est rude, mais j'ai foi en vous.

🌞 **Le script `id.sh` affiche l'état du firewall**

```bash
#!/bin/bash
# Script pour afficher les informations système
# redz 09/12/2024

USER=$(echo $USER)
DATE=$(date +"%d/%m/%y %H:%M:%S")
SHELL=$(cat /etc/passwd | grep $USER | cut -d: -f7)
OS=$(source /etc/os-release && echo "$NAME $VERSION")
KERNEL=$(uname -r)
RAM=$(free -mh | grep 'Mem:' | tr -s ' ' | cut -d' ' -f7)
DISK=$(df -h / | grep '/' | tr -s ' ' | cut -d' ' -f4)
INODE=$(df -i / | grep '/' | tr -s ' ' | cut -d' ' -f4)
PACKETS=$(rpm -qa | wc -l)
PORTS=$(ss -lnpt | grep LISTEN | wc -l)
PYTHON=$(which python3)
FIREWALL_STATUS=$(systemctl is-active firewalld)

echo "Salu a toa $USER."
echo "Nouvelle connexion $DATE."
echo "Connecté avec le shell $SHELL."
echo "OS : $OS - Kernel : $KERNEL"
echo "Ressources :"
echo "  - $RAM RAM dispo"
echo "  - $DISK espace disque dispo"
echo "  - $INODE fichiers restants"
echo "Actuellement :"
echo "  - $PACKETS paquets installés"
echo "  - $PORTS port(s) ouvert(s)"
echo "Python est bien installé sur la machine au chemin : $PYTHON"

if [ "$FIREWALL_STATUS" = "active" ]; 
then
  echo "Le firewall est actif."
else
  echo "Le firewall est inactif."
fi
```

```bash
[redz@node1 ~]$ /opt/id.sh
Salu a toa redz.
Nouvelle connexion 09/12/24 16:33:05.
Connecté avec le shell /bin/bash.
OS : Rocky Linux 9.5 (Blue Onyx) - Kernel : 5.14.0-503.14.1.el9_5.x86_64
Ressources :
  - 1.4Gi RAM dispo
  - 6.8G espace disque dispo
  - 4197848 fichiers restants
Actuellement :
  - 358 paquets installés
  - 2 port(s) ouvert(s)
Python est bien installé sur la machine au chemin : /usr/bin/python3
Le firewall est inactif.
```

🌞 **Le script `id.sh` affiche l'URL vers une photo de chat random**

```bash
#!/bin/bash
# Script pour afficher les informations système
# redz 09/12/2024

USER=$(echo $USER)
DATE=$(date +"%d/%m/%y %H:%M:%S")
SHELL=$(cat /etc/passwd | grep $USER | cut -d: -f7)
OS=$(source /etc/os-release && echo "$NAME $VERSION")
KERNEL=$(uname -r)
RAM=$(free -mh | grep 'Mem:' | tr -s ' ' | cut -d' ' -f7)
DISK=$(df -h / | grep '/' | tr -s ' ' | cut -d' ' -f4)
INODE=$(df -i / | grep '/' | tr -s ' ' | cut -d' ' -f4)
PACKETS=$(rpm -qa | wc -l)
PORTS=$(ss -lnpt | grep LISTEN | wc -l)
PYTHON=$(which python3)
FIREWALL_STATUS=$(systemctl is-active firewalld)
CAT_URL=$(curl -s https://api.thecatapi.com/v1/images/search | grep -o 'https://cdn2.thecatapi.com/images/[^\"]*')

echo "Salu a toa $USER."
echo "Nouvelle connexion $DATE."
echo "Connecté avec le shell $SHELL."
echo "OS : $OS - Kernel : $KERNEL"
echo "Ressources :"
echo "  - $RAM RAM dispo"
echo "  - $DISK espace disque dispo"
echo "  - $INODE fichiers restants"
echo "Actuellement :"
echo "  - $PACKETS paquets installés"
echo "  - $PORTS port(s) ouvert(s)"
echo "Python est bien installé sur la machine au chemin : $PYTHON"

if [ "$FIREWALL_STATUS" = "active" ]; 
then
  echo "Le firewall est actif."
else
  echo "Le firewall est inactif."
fi

echo "Voilà ta photo de chat : $CAT_URL"
```

```bash
[redz@node1 ~]$ /opt/id.sh
Salu a toa redz.
Nouvelle connexion 09/12/24 16:47:04.
Connecté avec le shell /bin/bash.
OS : Rocky Linux 9.5 (Blue Onyx) - Kernel : 5.14.0-503.14.1.el9_5.x86_64
Ressources :
  - 1.4Gi RAM dispo
  - 6.8G espace disque dispo
  - 4197847 fichiers restants
Actuellement :
  - 358 paquets installés
  - 2 port(s) ouvert(s)
Python est bien installé sur la machine au chemin : /usr/bin/python3
Le firewall est actif.
Voilà ta photo de chat : https://cdn2.thecatapi.com/images/c4m.jpg
```

## 4. Bannière

Bon et maintenant, on va faire en sorte qu'il se lance automatiquement à chaque fois qu'on ouvre un terminal.

Comme ça on ouvre un terminal, et on est bien accueillis tavu :d

🌞 **Stocker le fichier `id.sh` dans `/opt`**

```bash
[redz@node1 ~]$ sudo touch /opt/id.sh
[redz@node1 ~]$ sudo touch /opt/id.sh
```

🌞 **Prouvez que tout le monde peut exécuter le script**
```bash
[redz@node1 ~]$ ls -al /opt/id.sh
-rwxr-xr-x. 1 root root 1261 Dec  9 16:46 /opt/id.sh
```
🌞 **Ajouter l'exécution au `.bashrc` de votre utilisateur**

- il existe un fichier `.bashrc` dans le homedir de votre utilisateur
- genre dans `/home/toto/` y'a un fichier `.bashrc` si ton user c'est `toto`s
- ce fichier est exécuté en entier à chaque fois que tu lances un terminal
- ajoute à la dernière ligne l'exécution de `/opt/id.sh`
- pour prouver que ça marche dans le compte-rendu, je veux voir une connexion SSH et l'affichage qui pop direct, comme ça :

```
PS C:\Users\emrep> ssh redz@10.2.1.1
redz@10.2.1.1's password:
Last login: Mon Dec  9 15:47:03 2024 from 10.2.1.10
Salu a toa redz.
Nouvelle connexion 09/12/24 16:55:14.
Connecté avec le shell /bin/bash.
OS : Rocky Linux 9.5 (Blue Onyx) - Kernel : 5.14.0-503.14.1.el9_5.x86_64
Ressources :
  - 1.4Gi RAM dispo
  - 6.8G espace disque dispo
  - 4197842 fichiers restants
Actuellement :
  - 358 paquets installés
  - 2 port(s) ouvert(s)
Python est bien installé sur la machine au chemin : /usr/bin/python3
Le firewall est actif.
Voilà ta photo de chat : https://cdn2.thecatapi.com/images/1uk.jpg
[redz@node1 ~]$
```

## 5. Bonus : des paillettes

On peut s'amuser ~~un peu~~ avec l'affichage dans le terminal. Afficher des trucs en couleurs, en gras, étou.

C'est natif dans le terminal, mais comme tous les trucs un peu bas niveau, faut s'habituer à la mécanique.

Pour afficher un truc en couleur, il faut :

- utiliser `echo -e` et pas juste `echo`
- afficher une séquence spécifique qui correspond à la couleur
- afficher le texte
- réinitiatliser la couleur (sinon le reste du texte sera toujours de la même couleur)
- afficher le reste du texte

Par exeeeeeeeeeemple :

```bash
# une variable RED pour mettre... en rouge
RED="\e[31m"
# j'aime bien "NC" pour "non-colored" : on réinitialise la couleur
NC="\e[0m"

echo -e "je suis blanc${RED} je suis rouuuuge${NC} je suis blaaanc :o"
```

> [Je vous conseille cette page](https://misc.flogisoft.com/bash/tip_colors_and_formatting) pour voir toutes les séquences, pour changer les couleurs, mettre en gras, italique, etc.

⭐ **BONUS** : propose un script `id.sh` un peu plus...

- flashy
- sexy
- pimped-up
- avec des paillettes tavu

```bash
#!/bin/bash
# Script pour afficher les informations système
# redz 09/12/2024

# Couleurs
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[0;37m'
BOLD='\033[1m'
RESET='\033[0m'

USER=$(echo $USER)
DATE=$(date +"%d/%m/%y %H:%M:%S")
SHELL=$(cat /etc/passwd | grep $USER | cut -d: -f7)
OS=$(source /etc/os-release && echo "$NAME $VERSION")
KERNEL=$(uname -r)
RAM=$(free -mh | grep 'Mem:' | tr -s ' ' | cut -d' ' -f7)
DISK=$(df -h / | grep '/' | tr -s ' ' | cut -d' ' -f4)
INODE=$(df -i / | grep '/' | tr -s ' ' | cut -d' ' -f4)
PACKETS=$(rpm -qa | wc -l)
PORTS=$(ss -lnpt | grep LISTEN | wc -l)
PYTHON=$(which python3)
FIREWALL_STATUS=$(systemctl is-active firewalld)
CAT_URL=$(curl -s https://api.thecatapi.com/v1/images/search | grep -o 'https://cdn2.thecatapi.com/images/[^\"]*')

echo -e "${BOLD}${CYAN}Salu a toa $USER.${RESET}"
echo -e "${BOLD}${CYAN}Nouvelle connexion $DATE.${RESET}"
echo -e "${BOLD}${CYAN}Connecté avec le shell $SHELL.${RESET}"
echo -e "${BOLD}${CYAN}OS : $OS - Kernel : $KERNEL${RESET}"
echo -e "${BOLD}${CYAN}Ressources :${RESET}"
echo -e "${BOLD}${CYAN}  - $RAM RAM dispo${RESET}"
echo -e "${BOLD}${CYAN}  - $DISK espace disque dispo${RESET}"
echo -e "${BOLD}${CYAN}  - $INODE fichiers restants${RESET}"
echo -e "${BOLD}${CYAN}Actuellement :${RESET}"
echo -e "${BOLD}${CYAN}  - $PACKETS paquets installés${RESET}"
echo -e "${BOLD}${CYAN}  - $PORTS port(s) ouvert(s)${RESET}"
echo -e "${BOLD}${CYAN}Python est bien installé sur la machine au chemin : $PYTHON${RESET}"

if [ "$FIREWALL_STATUS" = "active" ]; 
then
  echo -e "${BOLD}${GREEN}Le firewall est actif.${RESET}"
else
  echo -e "${BOLD}${RED}Le firewall est inactif.${RESET}"
fi

echo -e "${BOLD}${MAGENTA}Voilà ta photo de chat : $CAT_URL${RESET}"
```