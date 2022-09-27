# drassadnikov_infra
drassadnikov Infra repository

<<<<<<< Updated upstream
#----- ДЗ к теме  "Знакомство с облачной инфраструктурой и облачными сервисами"
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

testapp_IP = 51.250.83.237
testapp_port = 9292

PS C:\Users\HOME> yc config list
token: y0_AgAAAAALvgvzAATuwQAAAADPy4cGyfqeI7nxQ-ufz30CLGqQszcZTqY
cloud-id: b1gorbtfqlahpr5802c4
folder-id: b1gpf2ca5rpkbvk7phms
compute-default-zone: ru-central1-a

#Самостоятельная работа

Команды по настройке системы и деплоя приложения нужно завернуть в
баш скрипты, чтобы не вбивать эти команды вручную:

Выполним команду по созданию ВМ:

C:\WINDOWS\system32>yc compute instance create --name reddit-app --hostname reddit-app --memory=4 --create-boot-disk image-folder-id=standard-images,image-family=ubuntu-1604-lts,size=10GB --network-interface subnet-name=default-ru-central1-a,nat-ip-version=ipv4 --metadata serial-port-enable=1 --ssh-key c:\Users\HOME\.ssh\appuser.pub
done (24s)
id: fhmqa316vtuo23im6ffh
folder_id: b1gpf2ca5rpkbvk7phms
created_at: "2022-09-26T00:48:43Z"
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
  device_name: fhm6qv22tjhcv8j084g2
  auto_delete: true
  disk_id: fhm6qv22tjhcv8j084g2
network_interfaces:
  - index: "0"
    mac_address: d0:0d:1a:50:c2:6f
    subnet_id: e9bjuql91rj8npqrnkf0
    primary_v4_address:
      address: 10.128.0.23
      one_to_one_nat:
        address: 51.250.83.237
        ip_version: IPV4
fqdn: reddit-app.ru-central1.internal
scheduling_policy: {}
network_settings:
  type: STANDARD
placement_policy: {}


#1.Скрипт install_ruby.sh должен содержать команды по установке Ruby;
После подключение к созданному ВМ:
ssh yc-user@51.250.83.237

Выполним команду по созданию sh файла на созданном ВМ:
cat <<EOF> install_ruby.sh
#!/bin/bash
sudo apt update
sudo apt install -y ruby-full ruby-bundler build-essential
ruby -v
bundler -v
EOF

После выполнения которого, создастся в каталоге /home/yc-user/ файл install_ruby.sh с содержимым:
#!/bin/bash
sudo apt update
sudo apt install -y ruby-full ruby-bundler build-essential
ruby -v
bundler -v

После выполнения команды:
yc-user@reddit-app:~$ sudo bash install_ruby.sh

Убедимся в успешной установке Ruby:
yc-user@reddit-app:~$ sudo bash install_ruby.sh
Hit:1 http://mirror.yandex.ru/ubuntu xenial InRelease
Hit:2 http://mirror.yandex.ru/ubuntu xenial-updates InRelease
Hit:3 http://mirror.yandex.ru/ubuntu xenial-backports InRelease
Hit:4 http://security.ubuntu.com/ubuntu xenial-security InRelease
Ign:5 https://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/4.2 InRelease
Hit:6 https://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/4.2 Release
Reading package lists... Done
Building dependency tree
Reading state information... Done
8 packages can be upgraded. Run 'apt list --upgradable' to see them.
Reading package lists... Done
Building dependency tree
Reading state information... Done
build-essential is already the newest version (12.1ubuntu2).
ruby-bundler is already the newest version (1.11.2-1).
ruby-full is already the newest version (1:2.3.0+1).
0 upgraded, 0 newly installed, 0 to remove and 8 not upgraded.
ruby 2.3.1p112 (2016-04-26) [x86_64-linux-gnu]
Bundler version 1.11.2

#2.Скрипт install_mongodb.sh должен содержать команды по установке MongoDB;

Выполним команду по созданию sh файла на созданном ВМ:
cat <<EOF> install_mongodb.sh
#!/bin/bash
wget -qO - https://www.mongodb.org/static/pgp/server-4.2.asc | sudo apt-key add -
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/4.2 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.2.list
sudo apt-get update
sudo apt-get install -y mongodb-org
sudo systemctl start mongod
sudo systemctl enable mongod
sudo systemctl status mongod
EOF

После выполнения которого, создастся в каталоге /home/yc-user/ файл install_mongodb.sh с содержимым:

#!/bin/bash
wget -qO - https://www.mongodb.org/static/pgp/server-4.2.asc | sudo apt-key add -
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/4.2 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.2.list
sudo apt-get update
sudo apt-get install -y mongodb-org
sudo systemctl start mongod
sudo systemctl enable mongod
sudo systemctl status mongod

После выполнения команды:
yc-user@reddit-app:~$ sudo bash install_mongodb.sh


Убедимся в успешной установке MongoDB:
OK
deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/4.2 multiverse
Hit:1 http://mirror.yandex.ru/ubuntu xenial InRelease
Hit:2 http://mirror.yandex.ru/ubuntu xenial-updates InRelease
Hit:3 http://mirror.yandex.ru/ubuntu xenial-backports InRelease
Hit:4 http://security.ubuntu.com/ubuntu xenial-security InRelease
Ign:5 https://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/4.2 InRelease
Hit:6 https://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/4.2 Release
Reading package lists... Done
Reading package lists... Done
Building dependency tree
Reading state information... Done
mongodb-org is already the newest version (4.2.22).
0 upgraded, 0 newly installed, 0 to remove and 8 not upgraded.
● mongod.service - MongoDB Database Server
   Loaded: loaded (/lib/systemd/system/mongod.service; enabled; vendor preset: enabled)
   Active: active (running) since Mon 2022-09-26 01:01:03 UTC; 20h ago
     Docs: https://docs.mongodb.org/manual
 Main PID: 2614 (mongod)
   CGroup: /system.slice/mongod.service
           └─2614 /usr/bin/mongod --config /etc/mongod.conf

Sep 26 01:01:03 reddit-app systemd[1]: Started MongoDB Database Server.
Sep 26 21:12:36 reddit-app systemd[1]: Started MongoDB Database Server.


#3.Скрипт deploy.sh должен содержать команды скачивания кода, установки зависимостей через bundler и запуск приложения.

Выполним команду по созданию sh файла на созданном ВМ:
cat <<EOF> deploy.sh
#!/bin/bash
sudo apt update
sudo apt install -y git
rm -rf /home/yc-user/reddit
git clone -b monolith https://github.com/express42/reddit.git
cd reddit && bundle install
puma -d
ps aux | grep puma
EOF

После выполнения которого, создастся в каталоге /home/yc-user/ файл deploy.sh с содержимым:

#!/bin/bash
sudo apt update
sudo apt install -y git
rm -rf /home/yc-user/reddit
git clone -b monolith https://github.com/express42/reddit.git
cd reddit && bundle install
puma -d
ps aux | grep puma

После выполнения команды:
yc-user@reddit-app:~$ sudo bash deploy.sh

Убедимся в успешной установки зависимостей через bundler и запуск приложения:
yc-user@reddit-app:~$ sudo bash deploy.sh
Get:1 http://security.ubuntu.com/ubuntu xenial-security InRelease [99.8 kB]
Ign:2 https://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/4.2 InRelease
Hit:3 https://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/4.2 Release
Hit:5 http://mirror.yandex.ru/ubuntu xenial InRelease
Hit:6 http://mirror.yandex.ru/ubuntu xenial-updates InRelease
Hit:7 http://mirror.yandex.ru/ubuntu xenial-backports InRelease
Fetched 99.8 kB in 4s (21.7 kB/s)
Reading package lists... Done
Building dependency tree
Reading state information... Done
8 packages can be upgraded. Run 'apt list --upgradable' to see them.
Reading package lists... Done
Building dependency tree
Reading state information... Done
git is already the newest version (1:2.7.4-0ubuntu1.10).
0 upgraded, 0 newly installed, 0 to remove and 8 not upgraded.
Cloning into 'reddit'...
remote: Enumerating objects: 376, done.
remote: Counting objects: 100% (5/5), done.
remote: Compressing objects: 100% (5/5), done.
remote: Total 376 (delta 0), reused 0 (delta 0), pack-reused 371
Receiving objects: 100% (376/376), 67.42 KiB | 0 bytes/s, done.
Resolving deltas: 100% (201/201), done.
Checking connectivity... done.
Don't run Bundler as root. Bundler can ask for sudo if it is needed, and installing your bundle as root will break this
application for all non-root users on this machine.
Warning: the running version of Bundler is older than the version that created the lockfile. We suggest you upgrade to the latest version of Bundler by running `gem install bundler`.
Using rake 12.0.0
Using net-ssh 4.1.0
Using bcrypt 3.1.11
Using bson 4.2.2
Using bson_ext 1.5.1
Using i18n 0.8.6
Using puma 3.10.0
Using temple 0.8.0
Using tilt 2.0.8
Using json 2.1.0
Using mustermann 1.0.2
Using rack 2.0.5
Using bundler 1.11.2
Using net-scp 1.2.1
Using mongo 2.4.3
Using haml 5.0.2
Using rack-protection 2.0.2
Using sshkit 1.14.0
Using sinatra 2.0.2
Using airbrussh 1.3.0
Using capistrano 3.9.0
Using capistrano-bundler 1.2.0
Using capistrano-rvm 0.1.2
Using capistrano3-puma 3.1.1
Bundle complete! 11 Gemfile dependencies, 24 gems now installed.
Use `bundle show [gemname]` to see where a bundled gem is installed.
Puma starting in single mode...
* Version 3.10.0 (ruby 2.3.1-p112), codename: Russell's Teapot
* Min threads: 0, max threads: 16
* Environment: development
* Daemonizing...
yc-user   3708  0.0  1.1 721572 45300 ?        Sl   01:21   0:25 puma 3.10.0 (tcp://0.0.0.0:9292) [reddit]
root      8138  0.0  0.3  73952 14488 ?        Rl   21:58   0:00 puma 3.10.0 (tcp://0.0.0.0:9292) [reddit]
root      8142  0.0  0.0  14224   972 pts/1    S+   21:58   0:00 grep puma

#Дополнительное задание
В качестве доп. задания используйте созданные ранее скрипты для создания , который будет запускаться при создании инстанса.
В результате применения данной команды CLI мы должны получать инстанс с уже запущенным приложением. Startup скрипт необходимо закомитить, а используемую команду CLI добавить в описание репозитория (README.md).
#Команда:
yc compute instance create --name reddit-app2 --hostname reddit-app2 --memory=4  --create-boot-disk image-folder-id=standard-images,image-family=ubuntu-1604-lts,size=10GB --network-interface subnet-name=default-ru-central1-a,nat-ip-version=ipv4 --metadata serial-port-enable=1 --metadata-from-file user-data=c:\Users\HOME\.ssh\startup.yaml

 Проверим установку скриптов после разворачивания ВМ reddit-app2:

appuser@reddit-app2:~$ ruby -v
ruby 2.3.1p112 (2016-04-26) [x86_64-linux-gnu]
appuser@reddit-app2:~$ bundler -v
Bundler version 1.11.2
appuser@reddit-app2:~$ sudo systemctl status mongod
● mongod.service - MongoDB Database Server
   Loaded: loaded (/lib/systemd/system/mongod.service; enabled; vendor preset: enabled)
   Active: active (running) since Tue 2022-09-27 02:08:53 UTC; 4min 13s ago
     Docs: https://docs.mongodb.org/manual
 Main PID: 2435 (mongod)
   CGroup: /system.slice/mongod.service
           └─2435 /usr/bin/mongod --config /etc/mongod.conf

Sep 27 02:08:53 reddit-app2 systemd[1]: Started MongoDB Database Server.
appuser@reddit-app2:~$ ps aux | grep puma
root      3210  0.0  0.6 516676 27928 ?        Sl   02:09   0:00 puma 3.10.0 (tcp://0.0.0.0:9292) [reddit]
appuser   3372  0.0  0.0  14224   960 pts/0    S+   02:18   0:00 grep puma
appuser@reddit-app2:~$
=======
testapp_IP = 51.250.67.53
testapp_port = 9292
>>>>>>> Stashed changes
