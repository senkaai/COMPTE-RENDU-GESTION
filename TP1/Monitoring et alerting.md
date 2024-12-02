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
```
## All available configuration options, their descriptions and default values:
## https://github.com/netdata/netdata/tree/master/src/go/plugin/go.d/modules/portcheck#readme

#jobs:
# - name: job1
#   host: 10.0.0.1
#   ports: [23, 80, 8080]
#
# - name: job2
#   host: 10.0.0.2
#   ports: [22, 19999]
jobs:
  - name: WEB_web.tp1.b1
    host: 10.1.1.1
    ports:
      - 12969
  - name: SSH_web.tp1.b1
    host: 10.1.1.1
    ports:
      - 22
```

## 4. Ajouter des alertes

🌞 **Configurer l'alerting avec Discord**
```
https://discord.com/api/webhooks/1313164325963431946/G8jNTb-iklSc5EfdkHQt7p2fxy7xifYkPXx3OK_r0f8Oewyy9N4JxmRLMHYebGPIKP0S
```
🌞 **Tester que ça fonctionne**
```
--- END received response ---
RECEIVED HTTP RESPONSE CODE: 200
time=2024-12-02T16:37:01.335+01:00 comm=alarm-notify.sh source=health level=info tid=14532 thread=alarm-notify msg_id=6db0018e83e34320ae2a659d78019fb7 node=monitoring.tp1.b1 instance=test.chart alert_id=1 alert_unique_id=1 alert=test_alarm alert_class=Test alert_recipient=nv alert_duration=1 alert_value=100 alert_value_old=90 alert_status=CLEAR alert_value_old=CRITICAL alert_units=units alert_summary="a test alarm" alert_info="this is a test alarm to verify notifications work" request="'/usr/libexec/netdata/plugins.d/alarm-notify.sh' 'nv' 'monitoring.tp1.b1' '1' '1' '3' '1733153819' 'test_alarm' 'test.chart' 'CLEAR' 'CRITICAL' '100' '90' '/usr/libexec/netdata/plugins.d/alarm-notify.sh' '1' '3' 'units' 'this is a test alarm to verify notifications work' 'new value' 'old value' 'evaluated expression' 'expression variable values' '0' '0' '' '' 'Test' 'command to edit the alarm=0=monitoring.tp1.b1' '' '' 'a test alarm' " msg="[ALERT NOTIFICATION]: sent discord notification to 'nv' for notification to 'nv' for transition from CRITICAL to CLEAR, of alert 'test_alarm' = 'new value', of instance 'test.chart', context '' on host 'monitoring.tp1.b1'"
# OK
```
🌞 **Euh... tester que ça fonctionne pour de vrai**

# **A vérifier sur le discord**

🌞 **Configurer une alerte quand le port du serveur Web ne répond plus**
```
  GNU nano 5.6.1                         /etc/netdata/health.d/web_server_alert.conf                          Modified
template: web_server_down
      on: portcheck.WEB_web.tp1.b1
    lookup: average -10s unaligned of availability
     every: 10s
      warn: $this < 1
      crit: $this < 1
     delay: down 10s
    repeat: every 20s
     units: %
      info: Web server is down
       to: nv
```
🌞 **Tester que ça fonctionne !**

- en éteignant le serveur Web
- vous m'enverrez un MP avec une invitation vers votre serveur Discord où y'a les alertes si vous arrivez jusque là :)
