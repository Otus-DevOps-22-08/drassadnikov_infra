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

#------------- ДЗ к теме "Модели управления инфраструктурой. Подготовка образов с помощью Packer"


PS C:\Users\HOME> yc config list
token: y0_AgAAAAALvgvzAATuwQAAAADPy4cGyfqeI7nxQ-ufz30CLGqQszcZTqY
cloud-id: b1gorbtfqlahpr5802c4
folder-id: b1gpf2ca5rpkbvk7phms
compute-default-zone: ru-central1-a
PS C:\Users\HOME>



$SVC_ACCT="drassadnikov"
$FOLDER_ID="b1gpf2ca5rpkbvk7phms"
yc iam service-account create --name $SVC_ACCT --folder-id $FOLDER_ID

PowerShell 7.2.6
Copyright (c) Microsoft Corporation.

https://aka.ms/powershell
Type 'help' to get help.

PS C:\Users\HOME> $SVC_ACCT="drassadnikov"
PS C:\Users\HOME> $FOLDER_ID="b1gpf2ca5rpkbvk7phms"
PS C:\Users\HOME> yc iam service-account create --name $SVC_ACCT --folder-id $FOLDER_ID
id: ajefc02afilbi8mm4mtk
folder_id: b1gpf2ca5rpkbvk7phms
created_at: "2022-09-27T04:06:31.673495073Z"
name: drassadnikov

PS C:\Users\HOME>


$ACCT_ID=$(yc iam service-account get $SVC_ACCT | grep ^id | awk '{print $2}')
yc resource-manager folder add-access-binding --id b1gpf2ca5rpkbvk7phms --role editor --service-account-id ajefc02afilbi8mm4mtk



PS C:\Users\HOME> yc iam service-account list
+----------------------+--------------+
|          ID          |     NAME     |
+----------------------+--------------+
| ajebut28s1ln8lndo0v1 | appuser      |
| ajeecntc5n1v4ldubqft | drassadnikov |
+----------------------+--------------+

yc resource-manager folder add-access-binding --id b1gpf2ca5rpkbvk7phms --role editor --service-account-id ajeecntc5n1v4ldubqft

PS C:\Users\HOME> yc resource-manager folder add-access-binding --id b1gpf2ca5rpkbvk7phms --role editor --service-account-id ajeecntc5n1v4ldubqft
done (1s)
PS C:\Users\HOME>

PS C:\Users\HOME> yc iam key create --service-account-id ajeecntc5n1v4ldubqft --output d:\!OTUS\GitHub\drassadnikov_infra\key.json
id: ajenoftpsii8tdmptith
service_account_id: ajeecntc5n1v4ldubqft
created_at: "2022-10-04T21:22:06.972930168Z"
key_algorithm: RSA_2048

PS D:\!OTUS\GitHub\drassadnikov_infra\packer> packer validate ./ubuntu16.json
The configuration is valid.

PS D:\!OTUS\GitHub\drassadnikov_infra\packer> packer build ./ubuntu16.json
yandex: output will be in this color.

==> yandex: Creating temporary RSA SSH key for instance...
==> yandex: Using as source image: fd8ip4qsne4vvmq4rnm5 (name: "ubuntu-16-04-lts-v20221003", family: "ubuntu-1604-lts")
==> yandex: Creating network...
==> yandex: Error creating network: server-request-id = 82b98164-3c1a-441e-9961-6aebd4e56e9a server-trace-id = e8691986440ba5c1:d0df7cd552fe5dc1:e8691986440ba5c1:1 client-request-id = a82813fb-8310-421c-866a-3191567d4421 client-trace-id = 3de0300b-bdce-43a5-bdd5-a3885629774e rpc error: code = ResourceExhausted desc = Quota limit vpc.networks.count exceeded
Build 'yandex' errored after 6 seconds 169 milliseconds: Error creating network: server-request-id = 82b98164-3c1a-441e-9961-6aebd4e56e9a server-trace-id = e8691986440ba5c1:d0df7cd552fe5dc1:e8691986440ba5c1:1 client-request-id = a82813fb-8310-421c-866a-3191567d4421 client-trace-id = 3de0300b-bdce-43a5-bdd5-a3885629774e rpc error: code = ResourceExhausted desc = Quota limit vpc.networks.count exceeded

==> Wait completed after 6 seconds 170 milliseconds

==> Some builds didn't complete successfully and had errors:
--> yandex: Error creating network: server-request-id = 82b98164-3c1a-441e-9961-6aebd4e56e9a server-trace-id = e8691986440ba5c1:d0df7cd552fe5dc1:e8691986440ba5c1:1 client-request-id = a82813fb-8310-421c-866a-3191567d4421 client-trace-id = 3de0300b-bdce-43a5-bdd5-a3885629774e rpc error: code = ResourceExhausted desc = Quota limit vpc.networks.count exceeded

==> Builds finished but no artifacts were created.
PS D:\!OTUS\GitHub\drassadnikov_infra\packer>


PS D:\!OTUS\GitHub\drassadnikov_infra\packer> ssh -i ~/.ssh/appuser appuser@51.250.9.219
The authenticity of host '51.250.9.219 (51.250.9.219)' can't be established.
ECDSA key fingerprint is SHA256:nlJwtptko075+pVI1dO1+aRtJWO+BZP+4mcwqkCWYFE.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added '51.250.9.219' (ECDSA) to the list of known hosts.
Welcome to Ubuntu 16.04.7 LTS (GNU/Linux 4.4.0-142-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

The programs included with the Ubuntu system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Ubuntu comes with ABSOLUTELY NO WARRANTY, to the extent permitted by
applicable law.

appuser@fhm83fvvn0nb0qdl6cn7:~$

PS D:\!OTUS\GitHub\drassadnikov_infra\packer> packer build -var-file="variables.json" ubuntu16.json

PS D:\!OTUS\GitHub\drassadnikov_infra\packer> packer validate -var-file="variables.json" ./immutable.json
The configuration is valid.

yc compute instance create --name reddit-full --hostname reddit-full --memory=4 --create-boot-disk folder-id=b1gpf2ca5rpkbvk7phms,size=10GB --network-interface subnet-name=default-ru-central1-a,nat-ip-version=ipv4 --metadata serial-port-enable=1 --ssh-key appuser.pub

#------------- ДЗ к теме "Знакомство с Terraform"

[redos@redos terraform]$ yc config list
token: y0_AgAAAAALvgvzAATuwQAAAADPy4cGyfqeI7nxQ-ufz30CLGqQszcZTqY
cloud-id: b1gorbtfqlahpr5802c4
folder-id: b1gpf2ca5rpkbvk7phms
compute-default-zone: ru-central1-a

[redos@redos terraform]$ terraform apply -auto-approve

[redos@redos terraform]$ terraform show | grep nat_ip_address
nat_ip_address     = "51.250.73.15"

[redos@redos terraform]$ yc config list
token: y0_AgAAAAALvgvzAATuwQAAAADPy4cGyfqeI7nxQ-ufz30CLGqQszcZTqY
cloud-id: b1gorbtfqlahpr5802c4
folder-id: b1gpf2ca5rpkbvk7phms
compute-default-zone: ru-central1-a


resource "yandex_compute_instance" "app" {
...
metadata = {
ssh-keys = "ubuntu:${file("~/.ssh/yc.pub")}"
}
...

[redos@redos terraform]$ terraform destroy -auto-approve

[redos@redos terraform]$ terraform apply -auto-approve

[redos@redos terraform]$ ssh ubuntu@84.201.131.92
The authenticity of host '84.201.131.92 (84.201.131.92)' can't be established.
ED25519 key fingerprint is SHA256:VaN6cB9Np8Hvx9xbea6BVJTi3Ykf0Cdp3lWHuXEaavY.
This key is not known by any other names
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added '84.201.131.92' (ED25519) to the list of known hosts.
Welcome to Ubuntu 16.04.7 LTS (GNU/Linux 4.4.0-142-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage
ubuntu@fhmctip3k7dqcdjfchjl:~$ 


[redos@redos terraform]$ terraform refresh
yandex_compute_instance.app: Refreshing state... [id=fhmctip3k7dqcdjfchjl]

Outputs:

external_ip_address_app = "84.201.131.92"
[redos@redos terraform]$ terraform output
external_ip_address_app = "84.201.131.92"
[redos@redos terraform]$ terraform output external_ip_address_app
"84.201.131.92"
[redos@redos terraform]$ 

 terraform taint yandex_compute_instance.app
Resource instance yandex_compute_instance.app has been marked as tainted.




external_ip_address_app = "51.250.88.45"

http://51.250.88.45:9292/

Post successuly published

Отформатируйте все конфигурационные файлы используя
команду terraform fmt;

[redos@redos terraform]$ terraform fmt -recursive


Outputs:
Созданы instances reddit-base из образа "fd85rjds6es4ta4aagpp" с переменной count:
   1. reddit-app-0 ```http://51.250.71.23:9292/
   2. reddit-app-1 ```http://51.250.64.139:9292/
   3. load_balancer_ip_address: ```http://51.250.7.54/


#------------- ДЗ к теме "Знакомство с Terraform-2"


yc iam access-key create --service-account-name drassadnikov --description "this key is for my bucket"
access_key:
  id: ajeodlikv5joqdgkp439
  service_account_id: ajeboklp8j94qbhsc7e4
  created_at: "2023-01-16T01:45:06.781817123Z"
  description: this key is for my bucket
  key_id: YCAJEcoJme8fBDMzorm-q19Ay
secret: YCNcoZod-AWqPTvph5SKtFUgcAav51iDpd1b6Gzg

#------------- ДЗ к теме "8.Управление конфигурацией. Знакомство с Ansible"


--------------------------------
[redos@redos ansible]$ ansible reddit-app-0 -i ./inventory -m ping
reddit-app-0 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "changed": false,
    "ping": "pong"
}

[redos@redos ansible]$ ansible reddit-db-0 -i ./inventory -m ping
reddit-db-0 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "changed": false,
    "ping": "pong"
}

--------

[defaults]
inventory = ./inventory
remote_user = appuser
private_key_file = ~/.ssh/appuser
host_key_checking = False
retry_files_enabled = False

reddit-app-0 ansible_host=158.160.44.203
reddit-db-0 ansible_host=158.160.57.246

--------------
[redos@redos ansible]$ ansible reddit-db-0 -m command -a uptime
reddit-db-0 | CHANGED | rc=0 >>
 09:47:50 up 23 min,  1 user,  load average: 0.00, 0.00, 0.00
[redos@redos ansible]$ ansible reddit-app-0 -m command -a uptime
reddit-app-0 | CHANGED | rc=0 >>
 09:48:05 up 23 min,  1 user,  load average: 0.00, 0.00, 0.00
 ------
 
 [app]
reddit-app-0 ansible_host=158.160.44.203

[db]
reddit-db-0 ansible_host=158.160.57.246

[redos@redos ansible]$ ansible app -m ping
reddit-app-0 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "changed": false,
    "ping": "pong"
}

[redos@redos ansible]$ ansible db -m ping
reddit-db-0 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "changed": false,
    "ping": "pong"
}

-----------
[redos@redos ansible]$ ansible all -m ping -i inventory.yml
reddit-app-0 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "changed": false,
    "ping": "pong"
}
reddit-db-0 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "changed": false,
    "ping": "pong"
}
-------------------------
[redos@redos ansible]$ ansible app -m command -a 'ruby -v'
reddit-app-0 | CHANGED | rc=0 >>
ruby 2.3.1p112 (2016-04-26) [x86_64-linux-gnu]
[redos@redos ansible]$ ansible app -m command -a 'bundler -v'
reddit-app-0 | CHANGED | rc=0 >>
Bundler version 1.11.2
-------------

[redos@redos ansible]$ ansible app -m command -a 'ruby -v; bundler -v'
reddit-app-0 | FAILED | rc=1 >>
ruby: invalid option -;  (-h will show valid options) (RuntimeError)non-zero return code
----

redos@redos ansible]$ ansible app -m shell -a 'ruby -v; bundler -v'
reddit-app-0 | CHANGED | rc=0 >>
ruby 2.3.1p112 (2016-04-26) [x86_64-linux-gnu]
Bundler version 1.11.2
--------------

[redos@redos ansible]$ ansible db -m command -a 'systemctl status mongod'
reddit-db-0 | CHANGED | rc=0 >>
● mongod.service - MongoDB Database Server
   Loaded: loaded (/lib/systemd/system/mongod.service; enabled; vendor preset: enabled)
   Active: active (running) since Sun 2023-01-29 09:24:57 UTC; 42min ago
     Docs: https://docs.mongodb.org/manual
 Main PID: 639 (mongod)
   CGroup: /system.slice/mongod.service
           └─639 /usr/bin/mongod --config /etc/mongod.conf

[redos@redos ansible]$ ansible db -m shell -a 'systemctl status mongod'
reddit-db-0 | CHANGED | rc=0 >>
● mongod.service - MongoDB Database Server
   Loaded: loaded (/lib/systemd/system/mongod.service; enabled; vendor preset: enabled)
   Active: active (running) since Sun 2023-01-29 09:24:57 UTC; 43min ago
     Docs: https://docs.mongodb.org/manual
 Main PID: 639 (mongod)
   CGroup: /system.slice/mongod.service
           └─639 /usr/bin/mongod --config /etc/mongod.conf		   
		   
------		   
[redos@redos ansible]$ ansible db -m systemd -a name=mongod
reddit-db-0 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "changed": false,
    "name": "mongod",
    "status": {
        "ActiveEnterTimestamp": "Sun 2023-01-29 09:24:57 UTC",
        "ActiveEnterTimestampMonotonic": "13626617",
        "ActiveExitTimestampMonotonic": "0",
        "ActiveState": "active",
        "After": "basic.target sysinit.target systemd-journald.socket system.slice network.target",
        "AllowIsolate": "no",
        "AmbientCapabilities": "0",
        "AssertResult": "yes",
        "AssertTimestamp": "Sun 2023-01-29 09:24:57 UTC",
        "AssertTimestampMonotonic": "13625974",
        "Before": "shutdown.target multi-user.target",
        "BlockIOAccounting": "no",
        "BlockIOWeight": "18446744073709551615",
        "CPUAccounting": "no",
        "CPUQuotaPerSecUSec": "infinity",
        "CPUSchedulingPolicy": "0",
        "CPUSchedulingPriority": "0",
        "CPUSchedulingResetOnFork": "no",
        "CPUShares": "18446744073709551615",
        "CPUUsageNSec": "18446744073709551615",
        "CanIsolate": "no",
        "CanReload": "no",
        "CanStart": "yes",
        "CanStop": "yes",
        "CapabilityBoundingSet": "18446744073709551615",
        "ConditionResult": "yes",
        "ConditionTimestamp": "Sun 2023-01-29 09:24:57 UTC",
        "ConditionTimestampMonotonic": "13625973",
        "Conflicts": "shutdown.target",
        "ControlGroup": "/system.slice/mongod.service",
        "ControlPID": "0",
        "DefaultDependencies": "yes",
        "Delegate": "no",
        "Description": "MongoDB Database Server",
        "DevicePolicy": "auto",
        "Documentation": "https://docs.mongodb.org/manual",
        "EnvironmentFile": "/etc/default/mongod (ignore_errors=yes)",
        "ExecMainCode": "0",
        "ExecMainExitTimestampMonotonic": "0",
        "ExecMainPID": "639",
        "ExecMainStartTimestamp": "Sun 2023-01-29 09:24:57 UTC",
        "ExecMainStartTimestampMonotonic": "13626560",
        "ExecMainStatus": "0",
        "ExecStart": "{ path=/usr/bin/mongod ; argv[]=/usr/bin/mongod --config /etc/mongod.conf ; ignore_errors=no ; start_time=[Sun 2023-01-29 09:24:57 UTC] ; stop_time=[n/a] ; pid=639 ; code=(null) ; status=0/0 }",
        "FailureAction": "none",
        "FileDescriptorStoreMax": "0",
        "FragmentPath": "/lib/systemd/system/mongod.service",
        "Group": "mongodb",
        "GuessMainPID": "yes",
        "IOScheduling": "0",
        "Id": "mongod.service",
        "IgnoreOnIsolate": "no",
        "IgnoreSIGPIPE": "yes",
        "InactiveEnterTimestampMonotonic": "0",
        "InactiveExitTimestamp": "Sun 2023-01-29 09:24:57 UTC",
        "InactiveExitTimestampMonotonic": "13626617",
        "JobTimeoutAction": "none",
        "JobTimeoutUSec": "infinity",
        "KillMode": "control-group",
        "KillSignal": "15",
        "LimitAS": "18446744073709551615",
        "LimitASSoft": "18446744073709551615",
        "LimitCORE": "18446744073709551615",
        "LimitCORESoft": "0",
        "LimitCPU": "18446744073709551615",
        "LimitCPUSoft": "18446744073709551615",
        "LimitDATA": "18446744073709551615",
        "LimitDATASoft": "18446744073709551615",
        "LimitFSIZE": "18446744073709551615",
        "LimitFSIZESoft": "18446744073709551615",
        "LimitLOCKS": "18446744073709551615",
        "LimitLOCKSSoft": "18446744073709551615",
        "LimitMEMLOCK": "18446744073709551615",
        "LimitMEMLOCKSoft": "18446744073709551615",
        "LimitMSGQUEUE": "819200",
        "LimitMSGQUEUESoft": "819200",
        "LimitNICE": "0",
        "LimitNICESoft": "0",
        "LimitNOFILE": "64000",
        "LimitNOFILESoft": "64000",
        "LimitNPROC": "64000",
        "LimitNPROCSoft": "64000",
        "LimitRSS": "18446744073709551615",
        "LimitRSSSoft": "18446744073709551615",
        "LimitRTPRIO": "0",
        "LimitRTPRIOSoft": "0",
        "LimitRTTIME": "18446744073709551615",
        "LimitRTTIMESoft": "18446744073709551615",
        "LimitSIGPENDING": "7846",
        "LimitSIGPENDINGSoft": "7846",
        "LimitSTACK": "18446744073709551615",
        "LimitSTACKSoft": "8388608",
        "LoadState": "loaded",
        "MainPID": "639",
        "MemoryAccounting": "no",
        "MemoryCurrent": "18446744073709551615",
        "MemoryLimit": "18446744073709551615",
        "MountFlags": "0",
        "NFileDescriptorStore": "0",
        "Names": "mongod.service",
        "NeedDaemonReload": "no",
        "Nice": "0",
        "NoNewPrivileges": "no",
        "NonBlocking": "no",
        "NotifyAccess": "none",
        "OOMScoreAdjust": "0",
        "OnFailureJobMode": "replace",
        "PIDFile": "/var/run/mongodb/mongod.pid",
        "PermissionsStartOnly": "no",
        "PrivateDevices": "no",
        "PrivateNetwork": "no",
        "PrivateTmp": "no",
        "ProtectHome": "no",
        "ProtectSystem": "no",
        "RefuseManualStart": "no",
        "RefuseManualStop": "no",
        "RemainAfterExit": "no",
        "Requires": "system.slice sysinit.target",
        "Restart": "no",
        "RestartUSec": "100ms",
        "Result": "success",
        "RootDirectoryStartOnly": "no",
        "RuntimeDirectoryMode": "0755",
        "RuntimeMaxUSec": "infinity",
        "SameProcessGroup": "no",
        "SecureBits": "0",
        "SendSIGHUP": "no",
        "SendSIGKILL": "yes",
        "Slice": "system.slice",
        "StandardError": "inherit",
        "StandardInput": "null",
        "StandardOutput": "journal",
        "StartLimitAction": "none",
        "StartLimitBurst": "5",
        "StartLimitInterval": "10000000",
        "StartupBlockIOWeight": "18446744073709551615",
        "StartupCPUShares": "18446744073709551615",
        "StateChangeTimestamp": "Sun 2023-01-29 09:24:57 UTC",
        "StateChangeTimestampMonotonic": "13626617",
        "StatusErrno": "0",
        "StopWhenUnneeded": "no",
        "SubState": "running",
        "SyslogFacility": "3",
        "SyslogLevel": "6",
        "SyslogLevelPrefix": "yes",
        "SyslogPriority": "30",
        "SystemCallErrorNumber": "0",
        "TTYReset": "no",
        "TTYVHangup": "no",
        "TTYVTDisallocate": "no",
        "TasksAccounting": "no",
        "TasksCurrent": "18446744073709551615",
        "TasksMax": "18446744073709551615",
        "TimeoutStartUSec": "1min 30s",
        "TimeoutStopUSec": "1min 30s",
        "TimerSlackNSec": "50000",
        "Transient": "no",
        "Type": "simple",
        "UMask": "0022",
        "UnitFilePreset": "enabled",
        "UnitFileState": "enabled",
        "User": "mongodb",
        "UtmpMode": "init",
        "WantedBy": "multi-user.target",
        "WatchdogTimestamp": "Sun 2023-01-29 09:24:57 UTC",
        "WatchdogTimestampMonotonic": "13626615",
        "WatchdogUSec": "0"
    }
}

[redos@redos ansible]$  ansible db -m service -a name=mongod
reddit-db-0 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "changed": false,
    "name": "mongod",
    "status": {
        "ActiveEnterTimestamp": "Sun 2023-01-29 09:24:57 UTC",
		
		---------------------
		
	ansible app -m git -a 'repo=https://github.com/express42/reddit.git dest=/home/appuser/reddit'

[redos@redos ansible]$ ansible app -m git -a 'repo=https://github.com/express42/reddit.git dest=/home/appuser/reddit'
reddit-app-0 | CHANGED => {
    "after": "5c217c565c1122c5343dc0514c116ae816c17ca2",
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "before": null,
    "changed": true
}
[redos@redos ansible]$ ansible app -m git -a 'repo=https://github.com/express42/reddit.git dest=/home/appuser/reddit'
reddit-app-0 | SUCCESS => {
    "after": "5c217c565c1122c5343dc0514c116ae816c17ca2",
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "before": "5c217c565c1122c5343dc0514c116ae816c17ca2",
    "changed": false,
    "remote_url_changed": false
}
------------
ansible app -m command -a 'git clone https://github.com/express42/reddit.git /home/appuser/reddit'

[redos@redos ansible]$ ansible app -m command -a 'git clone https://github.com/express42/reddit.git /home/appuser/reddit'
reddit-app-0 | FAILED | rc=128 >>
fatal: destination path '/home/appuser/reddit' already exists and is not an empty directory.non-zero return code
--------
--PlayBook

[redos@redos ansible]$ ansible-playbook clone.yml

PLAY [Clone] ***************************************************************************************************************************************

TASK [Gathering Facts] *****************************************************************************************************************************
ok: [reddit-app-0]

TASK [Clone repo] **********************************************************************************************************************************
ok: [reddit-app-0]

PLAY RECAP *****************************************************************************************************************************************
reddit-app-0               : ok=2    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

Теперь выполните ansible app -m command -a 'rm -rf ~/reddit'
и проверьте еще раз выполнение плейбука. Что изменилось и почему?
Добавьте информацию в README.md 

[redos@redos ansible]$ ansible app -m command -a 'rm -rf ~/reddit'
reddit-app-0 | CHANGED | rc=0 >>


1. Развернут ansible
2. Добавлен inventory-файл с параметрами подключения к инстансу app и db.
3. Добавлен ansible.cfg. 
4. Проверено управление хостом с помощью ansible.
5. Протестирована группа хостов с проверкой равернутых приложений.
6. Добавлен inventory.yaml
7. Написан плейбук clone.yml.


#------------- ДЗ к теме "9.Продолжение знакомства с Ansible: templates, handlers, dynamic inventory, vault, tags"

[redos@redos ansible]$ ansible-playbook reddit_app.yml --check --limit db

PLAY [Configure hosts & deploy application] ********************************************************************************************************

TASK [Gathering Facts] *****************************************************************************************************************************
ok: [reddit-db-0]

TASK [Change mongo config file] ********************************************************************************************************************
changed: [reddit-db-0]

RUNNING HANDLER [restart mongod] *******************************************************************************************************************
changed: [reddit-db-0]

PLAY RECAP *****************************************************************************************************************************************
reddit-db-0                : ok=3    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

[redos@redos ansible]$ 









































