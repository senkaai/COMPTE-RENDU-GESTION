# I. Service SSH

## 1. Analyse du service

> *Réalisez cette partie en entier sur `web.tp1.b1`.*

On va, dans cette première partie, analyser le service SSH qui est en cours d'exécution.

🌞 **S'assurer que le service `sshd` est démarré**
```
[redz@wep ~]$ systemctl status sshd
● sshd.service - OpenSSH server daemon
     Loaded: loaded (/usr/lib/systemd/system/sshd.service; enabled; preset: enabled)
     Active: active (running) since Fri 2024-11-29 16:53:01 CET; 11min ago
       Docs: man:sshd(8)
             man:sshd_config(5)
   Main PID: 703 (sshd)
      Tasks: 1 (limit: 11083)
     Memory: 5.0M
        CPU: 64ms
     CGroup: /system.slice/sshd.service
             └─703 "sshd: /usr/sbin/sshd -D [listener] 0 of 10-100 startups"

Nov 29 16:53:01 wep.tp1.b1 systemd[1]: Starting OpenSSH server daemon...
Nov 29 16:53:01 wep.tp1.b1 sshd[703]: Server listening on 0.0.0.0 port 22.
Nov 29 16:53:01 wep.tp1.b1 sshd[703]: Server listening on :: port 22.
Nov 29 16:53:01 wep.tp1.b1 systemd[1]: Started OpenSSH server daemon.
Nov 29 16:53:19 wep.tp1.b1 sshd[1256]: Accepted password for redz from 10.1.1.10 port 59015 ssh2
Nov 29 16:53:19 wep.tp1.b1 sshd[1256]: pam_unix(sshd:session): session opened for user redz(uid=1000) by redz(uid=0)
```

🌞 **Analyser les processus liés au service SSH**
```
[redz@wep ~]$ ps aux | grep ssh
root         703  0.0  0.5  16796  9344 ?        Ss   16:53   0:00 sshd: /usr/sbin/sshd -D [listener] 0 of 10-100 startups
root        1256  0.0  0.6  20312 11648 ?        Ss   16:53   0:00 sshd: redz [priv]
redz        1260  0.0  0.3  20312  7056 ?        S    16:53   0:00 sshd: redz@pts/0
redz        1365  0.0  0.1   6408  2432 pts/0    S+   17:08   0:00 grep --color=auto ssh
```
🌞 **Déterminer le port sur lequel écoute le service SSH**
```
[redz@wep ~]$ sudo ss -lnpt
State      Recv-Q     Send-Q         Local Address:Port         Peer Address:Port    Process
LISTEN     0          128                  0.0.0.0:22                0.0.0.0:*        users:(("sshd",pid=1495,fd=3))
LISTEN     0          128                     [::]:22                   [::]:*        users:(("sshd",pid=1495,fd=4))
```
🌞 **Consulter les logs du service SSH**
```
[redz@wep ~]$ journalctl -u sshd
Nov 29 16:53:01 wep.tp1.b1 systemd[1]: Starting OpenSSH server daemon...
Nov 29 16:53:01 wep.tp1.b1 sshd[703]: Server listening on 0.0.0.0 port 22.
Nov 29 16:53:01 wep.tp1.b1 sshd[703]: Server listening on :: port 22.
Nov 29 16:53:01 wep.tp1.b1 systemd[1]: Started OpenSSH server daemon.
Nov 29 16:53:19 wep.tp1.b1 sshd[1256]: Accepted password for redz from 10.1.1.10 port 59015 ssh2
Nov 29 16:53:19 wep.tp1.b1 sshd[1256]: pam_unix(sshd:session): session opened for user redz(uid=1000) by redz(uid=0)
```

```
[redz@wep ~]$ sudo tail -n 10 /var/log/secure
Nov 29 17:08:52 wep sudo[1366]: pam_unix(sudo:session): session closed for user root
Nov 29 17:10:12 wep sudo[1376]:    redz : TTY=pts/0 ; PWD=/home/redz ; USER=root ; COMMAND=/bin/journalctl -u sshd
Nov 29 17:10:12 wep sudo[1376]: pam_unix(sudo:session): session opened for user root(uid=0) by redz(uid=1000)
Nov 29 17:10:12 wep sudo[1376]: pam_unix(sudo:session): session closed for user root
Nov 29 17:10:19 wep sudo[1380]:    redz : TTY=pts/0 ; PWD=/home/redz ; USER=root ; COMMAND=/bin/tail -n 10 /var/log/auth.log
Nov 29 17:10:19 wep sudo[1380]: pam_unix(sudo:session): session opened for user root(uid=0) by redz(uid=1000)
Nov 29 17:10:19 wep sudo[1380]: pam_unix(sudo:session): session closed for user root
Nov 29 17:10:30 wep sudo[1383]:    redz : TTY=pts/0 ; PWD=/home/redz ; USER=root ; COMMAND=/bin/tail -n 10 /var/log
Nov 29 17:10:30 wep sudo[1383]: pam_unix(sudo:session): session opened for user root(uid=0) by redz(uid=1000)
Nov 29 17:10:30 wep sudo[1383]: pam_unix(sudo:session): session closed for user root
```
## 2. Modification du service

🌞 **Identifier le fichier de configuration du serveur SSH**
```
[redz@wep ~]$ sudo cat /etc/ssh/sshd_config
#       $OpenBSD: sshd_config,v 1.104 2021/07/02 05:11:21 dtucker Exp $

# This is the sshd server system-wide configuration file.  See
# sshd_config(5) for more information.

# This sshd was compiled with PATH=/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin

# The strategy used for options in the default sshd_config shipped with
# OpenSSH is to specify options with their default value where
# possible, but leave them commented.  Uncommented options override the
# default value.

# To modify the system-wide sshd configuration, create a  *.conf  file under
#  /etc/ssh/sshd_config.d/  which will be automatically included below
Include /etc/ssh/sshd_config.d/*.conf

# If you want to change the port on a SELinux system, you have to tell
# SELinux about this change.
# semanage port -a -t ssh_port_t -p tcp #PORTNUMBER
#
#Port 22
#AddressFamily any
#ListenAddress 0.0.0.0
#ListenAddress ::

#HostKey /etc/ssh/ssh_host_rsa_key
#HostKey /etc/ssh/ssh_host_ecdsa_key
#HostKey /etc/ssh/ssh_host_ed25519_key

# Ciphers and keying
#RekeyLimit default none

# Logging
#SyslogFacility AUTH
#LogLevel INFO

# Authentication:

#LoginGraceTime 2m
#PermitRootLogin prohibit-password
#StrictModes yes
#MaxAuthTries 6
#MaxSessions 10

#PubkeyAuthentication yes

# The default is to check both .ssh/authorized_keys and .ssh/authorized_keys2
# but this is overridden so installations will only check .ssh/authorized_keys
AuthorizedKeysFile      .ssh/authorized_keys

#AuthorizedPrincipalsFile none

#AuthorizedKeysCommand none
#AuthorizedKeysCommandUser nobody

# For this to work you will also need host keys in /etc/ssh/ssh_known_hosts
#HostbasedAuthentication no
# Change to yes if you don't trust ~/.ssh/known_hosts for
# HostbasedAuthentication
#IgnoreUserKnownHosts no
# Don't read the user's ~/.rhosts and ~/.shosts files
#IgnoreRhosts yes

# To disable tunneled clear text passwords, change to no here!
#PasswordAuthentication yes
#PermitEmptyPasswords no

# Change to no to disable s/key passwords
#KbdInteractiveAuthentication yes

# Kerberos options
#KerberosAuthentication no
#KerberosOrLocalPasswd yes
#KerberosTicketCleanup yes
#KerberosGetAFSToken no
#KerberosUseKuserok yes

# GSSAPI options
#GSSAPIAuthentication no
#GSSAPICleanupCredentials yes
#GSSAPIStrictAcceptorCheck yes
#GSSAPIKeyExchange no
#GSSAPIEnablek5users no

# Set this to 'yes' to enable PAM authentication, account processing,
# and session processing. If this is enabled, PAM authentication will
# be allowed through the KbdInteractiveAuthentication and
# PasswordAuthentication.  Depending on your PAM configuration,
# PAM authentication via KbdInteractiveAuthentication may bypass
# the setting of "PermitRootLogin without-password".
# If you just want the PAM account and session checks to run without
# PAM authentication, then enable this but set PasswordAuthentication
# and KbdInteractiveAuthentication to 'no'.
# WARNING: 'UsePAM no' is not supported in RHEL and may cause several
# problems.
#UsePAM no

#AllowAgentForwarding yes
#AllowTcpForwarding yes
#GatewayPorts no
#X11Forwarding no
#X11DisplayOffset 10
#X11UseLocalhost yes
#PermitTTY yes
#PrintMotd yes
#PrintLastLog yes
#TCPKeepAlive yes
#PermitUserEnvironment no
#Compression delayed
#ClientAliveInterval 0
#ClientAliveCountMax 3
#UseDNS no
#PidFile /var/run/sshd.pid
#MaxStartups 10:30:100
#PermitTunnel no
#ChrootDirectory none
#VersionAddendum none

# no default banner path
#Banner none

# override default of no subsystems
Subsystem       sftp    /usr/libexec/openssh/sftp-server

# Example of overriding settings on a per-user basis
#Match User anoncvs
#       X11Forwarding no
#       AllowTcpForwarding no
#       PermitTTY no
#       ForceCommand cvs server
```
🌞 **Modifier le fichier de conf**
```
[redz@wep ~]$ echo $RANDOM
18078
[redz@wep ~]$ sudo cat /etc/ssh/sshd_config | grep Port
#Port 18078
#GatewayPorts no
[redz@wep ~]$ sudo firewall-cmd --permanent --remove-port=22/tcp
success
[redz@wep ~]$ sudo firewall-cmd --permanent --add-port=18078/tcp
success
[redz@wep ~]$ sudo firewall-cmd --list-all | grep 18078
  ports: 18078/tcp
```
🌞 **Redémarrer le service**
```
sudo systemctl restart sshd
```
🌞 **Effectuer une connexion SSH sur le nouveau port**
```
PS C:\Users\emrep> ssh -p 18078 redz@10.1.1.1
redz@10.1.1.1's password:
Last login: Fri Nov 29 17:29:17 2024 from 10.1.1.10
```
✨ **Bonus : affiner la conf du serveur SSH**
```
PermitRootLogin no
PasswordAuthentication no
PubkeyAuthentication yes
ClientAliveInterval 300
ClientAliveCountMax 0
MaxAuthTries 3
```