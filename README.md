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
