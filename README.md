# drassadnikov_infra
drassadnikov Infra repository

#Выполнение:

Шаги выполнения:

1. Подключимся к VMC bastion:
C:\Users\HOME> ssh -i ~/.ssh/appuser appuser@51.250.83.214
Welcome to Ubuntu 20.04.4 LTS (GNU/Linux 5.4.0-124-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage
New release '22.04.1 LTS' available.
Run 'do-release-upgrade' to upgrade to it.

2. Настроим SSH Forwarding на вашей локальной машине:
  ssh-add -L
 The agent has no identities

PS C:\Users\HOME> ssh-add c:\Users\HOME\.ssh\appuser
Identity added: c:\Users\HOME\.ssh\appuser (c:\Users\HOME\.ssh\appuser)


3. Пробуем подключаться вновь, добавив в параметры подключения
ключик -A , чтобы явно включить SSH Agent Forwarding:
PS C:\Users\HOME> ssh -i ~/.ssh/appuser -A appuser@51.250.83.214
Welcome to Ubuntu 20.04.4 LTS (GNU/Linux 5.4.0-124-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage
New release '22.04.1 LTS' available.
Run 'do-release-upgrade' to upgrade to it.

Last login: Wed Sep 21 01:18:51 2022 from 51.250.83.214

appuser@bastion:~$ ssh 10.128.0.8
Welcome to Ubuntu 20.04.4 LTS (GNU/Linux 5.4.0-124-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage
Failed to connect to https://changelogs.ubuntu.com/meta-release-lts. Check your Internet connection or proxy settings

Last login: Wed Sep 21 01:18:30 2022 from 10.128.0.29
appuser@someinternalhost:~$ hostname
someinternalhost

appuser@someinternalhost:~$  ip a show eth0
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group default qlen 1000
    link/ether d0:0d:15:b3:fe:3f brd ff:ff:ff:ff:ff:ff
    inet 10.128.0.8/24 brd 10.128.0.255 scope global eth0
       valid_lft forever preferred_lft forever
    inet6 fe80::d20d:15ff:feb3:fe3f/64 scope link
       valid_lft forever preferred_lft forever

appuser@bastion:~$ ~$ ls -la ~/.ssh/
~$: command not found

#Самостоятельное задание:
Исследовать способ подключения к someinternalhost в одну
команду из вашего рабочего устройства, проверить работоспособность
найденного решения и внести его в README.md в вашем репозитории

#Решение:
Выполним команды:
1.  PS C:\Users\HOME> ssh -i ~/.ssh/appuser  -A appuser@51.250.83.214
Welcome to Ubuntu 20.04.4 LTS (GNU/Linux 5.4.0-124-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage
New release '22.04.1 LTS' available.
Run 'do-release-upgrade' to upgrade to it.

2. appuser@bastion:~$ ssh -o ProxyCommand="ssh 51.250.83.214 nc %h %p" 10.128.0.8
Welcome to Ubuntu 20.04.4 LTS (GNU/Linux 5.4.0-124-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage
Failed to connect to https://changelogs.ubuntu.com/meta-release-lts. Check your Internet connection or proxy settings

Last login: Wed Sep 21 02:06:05 2022 from 10.128.0.29
appuser@someinternalhost:~$


3. Убедимся, что попали на нужный хост:

appuser@someinternalhost:~$ hostname
someinternalhost
#-----------------------------------------------------

#Дополнительное задание:
Предложить вариант решения для подключения из консоли при помощи
команды вида ssh someinternalhost из локальной консоли рабочего
устройства, чтобы подключение выполнялось по алиасу
someinternalhost и внести его в README.md в вашем репозитории

#Решение:

1. Создадмс файл по пути /home/appuser/.bash_aliases настроим алиас:

alias someinternalhost='-o ProxyCommand="ssh 51.250.83.214 nc %h %p" 10.128.0.8'

2. После добавление алиасов, выполнил команду:
   appuser@bastion:~$ source ~/.bashrc

3. Убедимся что все алиасы подтянулись корректно:

appuser@bastion:~$ alias
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias grep='grep --color=auto'
alias l='ls -CF'
alias la='ls -A'
alias ll='ls -alF'
alias ls='ls --color=auto'
alias someinternalhost='-o ProxyCommand="ssh 51.250.83.214 nc %h %p" 10.128.0.8'

4. Выполним команду подключения:
PS C:\Users\HOME> ssh -i ~/.ssh/appuser  -A appuser@51.250.83.214
Welcome to Ubuntu 20.04.4 LTS (GNU/Linux 5.4.0-124-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage
New release '22.04.1 LTS' available.
Run 'do-release-upgrade' to upgrade to it.

5. Выполним команду используя алиас:
appuser@bastion:~$ ssh someinternalhost
Welcome to Ubuntu 20.04.4 LTS (GNU/Linux 5.4.0-124-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage
Failed to connect to https://changelogs.ubuntu.com/meta-release-lts. Check your Internet connection or proxy settings

Last login: Wed Sep 21 02:29:14 2022 from 10.128.0.29
appuser@someinternalhost:~$

Результат идентичный первому заданию, но в данном кейсе все выполнилось за один раз!

#---------------------------------------

bastion_IP = 51.250.83.214
someinternalhost_IP = 10.128.0.8

#------------- ДЗ к теме "Основные сервисы Yandex Cloud"

testapp_IP = 51.250.95.244
testapp_port = 9292

PS C:\Users\HOME> yc config list
token: y0_AgAAAAALvgvzAATuwQAAAADPy4cGyfqeI7nxQ-ufz30CLGqQszcZTqY
cloud-id: b1gorbtfqlahpr5802c4
folder-id: b1gpf2ca5rpkbvk7phms
compute-default-zone: ru-central1-a

#Переместим файлы cloud-bastion.ovpn и setupvpn.sh в VPN каталог через команды:

PS D:\!OTUS\GitHub\drassadnikov_infra> mkdir VPN

    Directory: D:\!OTUS\GitHub\drassadnikov_infra

Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d----          30.09.2022    21:57                VPN

PS D:\!OTUS\GitHub\drassadnikov_infra> git mv cloud-bastion.ovpn VPN
PS D:\!OTUS\GitHub\drassadnikov_infra> git mv setupvpn.sh VPN


#Самостоятельная работа

Команды по настройке системы и деплоя приложения нужно завернуть в
баш скрипты, чтобы не вбивать эти команды вручную:

Выполним команду по созданию ВМ:

yc compute instance create --name reddit-app --hostname reddit-app --memory=4 --create-boot-disk image-folder-id=standard-images,image-family=ubuntu-2004-lts,size=10GB --network-interface subnet-name=default-ru-central1-a,nat-ip-version=ipv4 --metadata serial-port-enable=1 --ssh-key $HOME/.ssh/appuser.pub

#1.Скрипт install_ruby.sh должен содержать команды по установке Ruby;
PS C:\Users\HOME> ssh yc-user@51.250.95.244
The authenticity of host '51.250.8.13 (51.250.8.13)' can't be established.
ECDSA key fingerprint is SHA256:RAVYPnNe1k0ZuqpHL2a1x7VTWseFPClX11xqHg0h3Dw.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added '51.250.95.244' (ECDSA) to the list of known hosts.
Welcome to Ubuntu 16.04.7 LTS (GNU/Linux 4.4.0-142-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

The programs included with the Ubuntu system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Ubuntu comes with ABSOLUTELY NO WARRANTY, to the extent permitted by
applicable law.

yc-user@reddit-app:~$


#1 Создадим  файл install_ruby.sh с содержимым:
Выполним команду по созданию sh файла на созданном ВМ:

cat <<EOF> install_ruby.sh
#!/bin/bash
sudo apt update
sudo apt install -y ruby-full ruby-bundler build-essential
ruby -v
bundler -v
EOF

После выполнения которого, создастся в каталоге /home/yc-user/ файл install_ruby.sh

Выполним команду:
yc-user@reddit-app:~$ sudo bash install_ruby.sh

#2.Скрипт install_mongodb.sh должен содержать команды по установке MongoDB;

Выполним команду по созданию sh файла на созданном ВМ:
cat <<EOF> install_mongodb.sh
#!/bin/bash
sudo apt update
sudo apt install -y apt-transport-https ca-certificates
wget -qO - https://www.mongodb.org/static/pgp/server-4.2.asc | sudo apt-key add -
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/4.2 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.2.list
sudo apt update
sudo apt install -y mongodb-org
sudo systemctl start mongod
sudo systemctl enable mongod
sudo systemctl status mongod
EOF

После выполнения которого, создастся в каталоге /home/yc-user/ файл install_mongodb.sh
Выполним команду:
yc-user@reddit-app:~$ sudo bash install_mongodb.sh

#3.Скрипт deploy.sh должен содержать команды скачивания кода, установки зависимостей через bundler и запуск приложения.

Выполним команду по созданию sh файла на созданном ВМ:
cat <<EOF> deploy.sh
#!/bin/bash
sudo apt install -y git
git clone -b monolith https://github.com/express42/reddit.git
cd reddit && bundle install
puma -d
EOF

После выполнения которого, создастся в каталоге /home/yc-user/ файл deploy.sh
Выполним команду:
yc-user@reddit-app:~$ sudo bash deploy.sh

#Дополнительное задание
В качестве доп. задания используйте созданные ранее скрипты для создания , который будет запускаться при создании инстанса.
В результате применения данной команды CLI мы должны получать инстанс с уже запущенным приложением. Startup скрипт необходимо закомитить, а используемую команду CLI добавить в описание репозитория (README.md).
#Команда:
yc compute instance create --name reddit-app --hostname reddit-app --memory=4  --create-boot-disk image-folder-id=standard-images,image-family=ubuntu-1604-lts,size=10GB --network-interface subnet-name=default-ru-central1-a,nat-ip-version=ipv4 --metadata serial-port-enable=1 --metadata-from-file user-data=$HOME\.ssh\startup.yaml

done (32s)
id: fhmquo5emedpjf26pspl
folder_id: b1gpf2ca5rpkbvk7phms
created_at: "2022-09-28T00:08:13Z"
name: reddit-app
zone_id: ru-central1-a
platform_id: standard-v2
resources:
  memory: "4294967296"
  cores: "2"
  core_fraction: "100"
status: RUNNING
metadata_options:
  gce_http_endpoint: ENABLED
  aws_v1_http_endpoint: ENABLED
  gce_http_token: ENABLED
  aws_v1_http_token: ENABLED
boot_disk:
  mode: READ_WRITE
  device_name: fhmc57db2v3ebj72lb5b
  auto_delete: true
  disk_id: fhmc57db2v3ebj72lb5b
network_interfaces:
  - index: "0"
    mac_address: d0:0d:1a:f6:0a:eb
    subnet_id: e9bjuql91rj8npqrnkf0
    primary_v4_address:
      address: 10.128.0.12
      one_to_one_nat:
        address: 51.250.2.196
        ip_version: IPV4
fqdn: reddit-app.ru-central1.internal
scheduling_policy: {}
network_settings:
  type: STANDARD
placement_policy: {}

Проверим установку скриптов после разворачивания ВМ reddit-app:

yc-user@reddit-app:~$ ruby -v
ruby 2.3.1p112 (2016-04-26) [x86_64-linux-gnu]
yc-user@reddit-app:~$ bundler -v
Bundler version 1.11.2
yc-user@reddit-app:~$

yc-user@reddit-app:~$ sudo systemctl status mongod
● mongod.service - MongoDB Database Server
   Loaded: loaded (/lib/systemd/system/mongod.service; enabled; vendor preset: enabled)
   Active: active (running) since Wed 2022-09-28 00:23:50 UTC; 9s ago
     Docs: https://docs.mongodb.org/manual
 Main PID: 2466 (mongod)
   CGroup: /system.slice/mongod.service
           └─2466 /usr/bin/mongod --config /etc/mongod.conf

Sep 28 00:23:50 reddit-app systemd[1]: Started MongoDB Database Server.

yc-user@reddit-app:~$ puma -d
Puma starting in single mode...
* Version 3.10.0 (ruby 2.3.1-p112), codename: Russell's Teapot
* Min threads: 0, max threads: 16
* Environment: development
* Daemonizing...
yc-user@reddit-app:~$ ps aux | grep puma
root      3244  0.9  0.7 721484 28452 ?        Sl   00:24   0:00 puma 3.10.0 (tcp://0.0.0.0:9292) [reddit]
yc-user   3384  0.0  0.0  14224   916 pts/1    S+   00:24   0:00 grep puma

http://51.250.95.244:9292/

Log In
Username:
travis
Password:
travis

Add a new post
Title:
travis-test
Link:
https://travis-ci.org/


Post successuly published

Выдадим права execute на скрипты sh:
PS D:\!OTUS\GitHub\drassadnikov_infra> git update-index --chmod=+x d:\!OTUS\GitHub\drassadnikov_infra\install_ruby.sh
PS D:\!OTUS\GitHub\drassadnikov_infra> git update-index --chmod=+x d:\!OTUS\GitHub\drassadnikov_infra\install_mongodb.sh
PS D:\!OTUS\GitHub\drassadnikov_infra> git update-index --chmod=+x d:\!OTUS\GitHub\drassadnikov_infra\deploy.sh

Выполним commit + push:
PS D:\!OTUS\GitHub\drassadnikov_infra> git commit -am "Task 4-drassadnikov"
[cloud-testapp 2420c4a] Task 4-drassadnikov
 4 files changed, 4 insertions(+), 1 deletion(-)
 mode change 100644 => 100755 deploy.sh
 mode change 100644 => 100755 install_mongodb.sh
 mode change 100644 => 100755 install_ruby.sh
PS D:\!OTUS\GitHub\drassadnikov_infra> git push
Enumerating objects: 5, done.
Counting objects: 100% (5/5), done.
Delta compression using up to 4 threads
Compressing objects: 100% (3/3), done.
Writing objects: 100% (3/3), 411 bytes | 411.00 KiB/s, done.
Total 3 (delta 2), reused 0 (delta 0), pack-reused 0
remote: Resolving deltas: 100% (2/2), completed with 2 local objects.
To https://github.com/Otus-DevOps-22-08/drassadnikov_infra.git
   967a00f..2420c4a  cloud-testapp -> cloud-testapp
PS D:\!OTUS\GitHub\drassadnikov_infra>