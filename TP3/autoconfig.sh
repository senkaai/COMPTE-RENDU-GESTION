#!/bin/bash

if [ "$EUID" -ne 0 ]; 
then
  echo "$(date +'%H:%M:%S') [ERROR] Ce script doit être exécuté en tant que root"
  exit 1
fi

echo "$(date +'%H:%M:%S') [INFO] Le script d'autoconfiguration a démarré"

if sestatus | grep "enabled" > /dev/null; 
then
  echo "$(date +'%H:%M:%S') [WARN] SELinux est toujours activé !"
  echo "$(date +'%H:%M:%S') [INFO] Désactivation de SELinux temporaire (setenforce)"
  setenforce 0
  echo "$(date +'%H:%M:%S') [INFO] Désactivation de SELinux définitive (fichier de config)"
  sed -i 's/^SELINUX=enforcing/SELINUX=permissive/' /etc/selinux/config
fi

if systemctl is-active --quiet firewalld; 
then
  echo "$(date +'%H:%M:%S') [INFO] Service de firewalling firewalld est activé"
else
  echo "$(date +'%H:%M:%S') [ERROR] Le service firewalld n'est pas activé"
  exit 1
fi

if grep -q "^Port 22" /etc/ssh/sshd_config; 
then
  echo "$(date +'%H:%M:%S') [WARN] Le service SSH tourne toujours sur le port 22/TCP"
  new_port=$((RANDOM % 64512 + 1024))
  echo "$(date +'%H:%M:%S') [INFO] Modification du fichier de configuration SSH pour écouter sur le port $new_port/TCP"
  sed -i "s/^#Port 22/Port $new_port/" /etc/ssh/sshd_config
  echo "$(date +'%H:%M:%S') [INFO] Redémarrage du service SSH"
  systemctl restart sshd
  echo "$(date +'%H:%M:%S') [INFO] Ouverture du port $new_port/TCP dans firewalld"
  firewall-cmd --permanent --add-port=$new_port/tcp
  firewall-cmd --permanent --remove-port=22/tcp
  firewall-cmd --reload
else
  echo "$(date +'%H:%M:%S') [INFO] Le service SSH ne tourne pas sur le port 22/TCP"
fi

current_hostname=$(hostname)
if [ "$current_hostname" == "localhost" ]; 
then
  echo "$(date +'%H:%M:%S') [WARN] La machine s'appelle toujours localhost !"
  echo "$(date +'%H:%M:%S') [INFO] Changement du nom pour $1"
  hostnamectl set-hostname $1
fi

if ! id -nG redzz | grep -qw "wheel"; 
then
  echo "$(date +'%H:%M:%S') [WARN] L'utilisateur redzz n'est pas dans le groupe wheel !"
  echo "$(date +'%H:%M:%S') [INFO] Ajout de l'utilisateur redzz au groupe wheel"
  usermod -aG wheel redzz
fi

echo "$(date +'%H:%M:%S') [INFO] Le script d'autoconfiguration s'est correctement déroulé"