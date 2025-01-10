# Partie I : Script autoconfiguration

## 1. Ce que doit faire le script

➜ **Chaque opération qu'il fait doit être affiché**

- dès qu'il modifie un fichier ou redémarre un service par exemple, il doit l'écrire dans le terminal
- des ptits `echo` tout le long !

> Ca permettra de suivre son avancée lors de son exécution de façon claire.

➜ **Vérifiez que le script vient d'être lancé en `root`**

- sinon afficher un message d'erreur (de votre choix) et quitte
- la commande `id` permet d'afficher l'utilisateur qui aura lancé le script

> La suite du script va effectuer des opérations d'administration pour lesquelles il faudra les droits `root`. Et on s'amuse pas à utiliser `sudo` dans le script wtf ? Juste on force l'utilisateur à lancer le script en `root`.

➜ **Vérifier que SELinux est désactivé**

- la commande `sestatus` doit montrer : `Current mode : permissive` (et pas un autre `Current mode`)
  - pour changer le passer dans ce mode, il faut utiliser la commande `setenforce 0`
  - c'est une désactivation temporaire (qu'il faut faire) mais pas définitive
- la commande `sestatus` doit aussi montrer : `Mode from config file : permissive`
  - pour changer ce mode, il faut éditer le fichier de configuration `/etc/selinux/config`
  - il faut remplacer `enforcing` par `permissive` sur la ligne qui indique le mode
- pour remplacer un truc précis par un autre truc dans un fichier, on peut utiliser la commande `sed`
  - parce que votre script, il va pas lancer `nano` en plein milieu de l'exécution !
  - donc faut qu'il modifie le fichier `/etc/selinux/config` "automatiquement"
  - petit exemple de `sed` pour faire un truc du genre :

```bash
# supposons le fichier suivant :
$ cat meo.txt
chat1
chat2
chat3

# supposons qu'on veuille remplacer chat2 par angela
# on peut utiliser la commande suivante :
$ sed -i 's/chat2/angela/g' meo.txt

# preuve
$ cat meo.txt
chat1
angela
chat3
```

➜ **Vérifier que le firewall est activé**

- sinon il affiche un message d'erreur (de votre choix) et quitte
- le nom du service firewall sur Rocky c'est `firewalld`

> Ce `d` à la fin de `firewalld` c'est pour *daemon*. Un *daemon* c'est juste le nom qu'on donne à un programme destiné à tourner en tâche de fond, en permanence. La plupart des services sont donc des *daemons* !

➜ **Vérifier que le serveur SSH ne tourne PAS sur le port 22/TCP**

- **s'il tourne derrière le port 22/TCP, votre script doit :**
  - choisir un port aléatoire (plus grand que 1024, et inférieur à 65535)
    - avec la variable native `$RANDOM` qu'on a déjà utilisé
  - modifier la configuration du serveur SSH pour qu'il écoute sur ce nouveau port
    - pour rappel, le fichier de conf du serveur SSH est dans le dossier `/etc/ssh/`
  - redémarrer le service SSH
  - ouvrir ce port dans le firewall, et fermer le port 22
- **s'il ne tourne déjà plus sur le port 22/TCP, mais un autre, afficher un ptit message de succès**

➜ **Définit un nom à la machine**

- parce que j'en ai marre que vos machines soient nommées `localhost`
- on doit pouvoir passer en argument au script le nom qu'on souhaite donner à la machine
- il attribue ce nom si la machine s'appelle toujours `localhost`
- la configuration du nom de la machine c'est avec la commande `hostnamectl` (on peut voir ou changer le nom actuel avec cette commande)
- c'est à dire qu'on doit pouvoir appeler le script comme ça :

```bash
# exécution du script autoconfig.sh
# il attribuera le nom "music.tp3.b3" à la machine si on lui passe en argument :
$ /opt/autoconfig.sh music.tp3.b3
```

> J'vous en avais parlé vite fait, on s'en sert pas nous de SELinux, c'est un outil pour augmenter le niveau de sécurité mais qui est très fastidieux à configurer et demande des connaissances avancées. J'adore cet outil, mais ce sera pas pour maintenant avec vous !

➜ **Vérifie que votre utilisateur est "admin"**

- vous devez avoir un utilisateur, nommé comme vous le souhaitez (prénom, pseudo, etc)
- il doit appartenir au groupe `wheel`

> Le groupe `wheel`, comme on a déjà vu plusieurs fois, a une configuration `sudo` par défaut : tous les membres de ce groupe peuvent taper n'importe quelle commande `sudo`.

## 2. Rendu attendu

🌞 **Script `autoconfig.sh`**

- doit effectuer les configurations indiquées au dessus
- le script sera remis dans votre dépôt git
- je vous recommande de faire les tests sur une autre machine (et ne pas pourrir celle que vous avez préparée pour le TP éventuellement)
- vous pouvez customiser un peu comme vous voulez, mais l'exécution du script doit ressembler par exemple à :

```
[redz@music ~]$ sudo /opt/autoconfig.sh music.tp3.b3
15:22:34 [INFO] Le script d'autoconfiguration a démarré
15:22:34 [WARN] SELinux est toujours activé !
15:22:34 [INFO] Désactivation de SELinux temporaire (setenforce)
15:22:34 [INFO] Désactivation de SELinux définitive (fichier de config)
15:22:34 [INFO] Service de firewalling firewalld est activé
15:22:34 [WARN] Le service SSH tourne toujours sur le port 22/TCP
15:22:34 [INFO] Modification du fichier de configuration SSH pour écouter sur le port 32926/TCP
15:22:34 [INFO] Redémarrage du service SSH
15:22:34 [INFO] Ouverture du port 32926/TCP dans firewalld
15:22:35 [WARN] L'utilisateur redzz n'est pas dans le groupe wheel !
15:22:35 [INFO] Ajout de l'utilisateur redzz au groupe wheel
15:22:35 [INFO] Le script d'autoconfiguration s'est correctement déroulé
```
