# drassadnikov_infra
drassadnikov Infra repository
#Самостоятельное задание:
Исследовать способ подключения к someinternalhost в одну
команду из вашего рабочего устройства, проверить работоспособность
найденного решения и внести его в README.md в вашем репозитории

#Ответ:
Команда получилась следующая:
appuser@bastion:~$ ssh -R 8080:127.0.1.1:24 10.128.0.8

Шаги выполнения:
1. Подключимся к VMC bastion:
C:\Users\HOME>ssh -i ~/.ssh/appuser appuser@51.250.77.154
Welcome to Ubuntu 20.04.4 LTS (GNU/Linux 5.4.0-124-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage
New release '22.04.1 LTS' available.
Run 'do-release-upgrade' to upgrade to it.

Last login: Sun Sep 18 09:32:38 2022 from 85.234.3.77
appuser@bastion:~$

2. Запустим SSH-агент:
appuser@bastion:~$ eval $(ssh-agent -s)
Agent pid 3287

3. Добавим приватный ключ:
appuser@bastion:~$ ssh-add ~/.ssh/appuser
Identity added: /home/appuser/.ssh/appuser (/home/appuser/.ssh/appuser)

4. Узнаем порты VPC bastion и someinternalhost:

appuser@bastion:~$ ip a | grep inet
inet 127.0.0.1/8 scope host lo
    inet6 ::1/128 scope host
    inet 10.128.0.24/24 brd 10.128.0.255 scope global eth0
    inet6 fe80::d20d:14ff:fe8c:5cf0/64 scope link


appuser@someinternalhost:~$ ip a | grep inet
    inet 127.0.0.1/8 scope host lo
    inet6 ::1/128 scope host
    inet 10.128.0.8/24 brd 10.128.0.255 scope global eth0
    inet6 fe80::d20d:15ff:feb3:fe3f/64 scope link


5. Выполним команду с перебрасыванием портов на VPC someinternalhost:

appuser@bastion:~$ ssh -R 8080:127.0.1.1:24 10.128.0.8
Welcome to Ubuntu 20.04.4 LTS (GNU/Linux 5.4.0-124-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage
New release '22.04.1 LTS' available.
Run 'do-release-upgrade' to upgrade to it.

Last login: Sun Sep 18 16:35:33 2022 from 10.128.0.24

6. Убедимся, что попали на нужный хост:

appuser@someinternalhost:~$ hostname
someinternalhost
-----------------------------------------------------

#Дополнительное задание:
Предложить вариант решения для подключения из консоли при помощи
команды вида ssh someinternalhost из локальной консоли рабочего
устройства, чтобы подключение выполнялось по алиасу
someinternalhost и внести его в README.md в вашем репозитории

Решение:

1. В файле: /home/appuser/.bash_aliases настроил алиасы:

alias bastion='ssh -i ~/.ssh/appuser appuser@51.250.77.154'
alias sshagent='eval $(ssh-agent -s)'
alias IKey='ssh-add ~/.ssh/appuser'
alias someinternalforward='ssh -R 8080:127.0.1.1:24 10.128.0.8'
alias startbastion='IKey; bastion'
alias someinternalhost='sshagent; IKey; someinternalforward'

2. После добавление алиасов, выполнил команду:
   appuser@bastion:~$ source ~/.bashrc

3. Убедился что все алиасы подтянулись корректно:

appuser@bastion:~$ alias
alias IKey='ssh-add ~/.ssh/appuser'
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
alias bastion='ssh -i ~/.ssh/appuser appuser@51.250.77.154'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias grep='grep --color=auto'
alias l='ls -CF'
alias la='ls -A'
alias ll='ls -alF'
alias ls='ls --color=auto'
alias someinternalforward='ssh -R 8080:127.0.1.1:24 10.128.0.8'
alias someinternalhost='sshagent; IKey; someinternalforward'
alias sshagent='eval $(ssh-agent -s)'
alias startbastion='IKey; bastion'
appuser@bastion:~$

Т.к. someinternalhost, предварительно требует добавление ключа и перезапуск ssh-агента, вынес это все в отдельные алиасы, и настроил порядок действий:
alias someinternalhost='sshagent; IKey; someinternalforward'
Запускаю в консоли:
alias someinternalhost='sshagent; IKey; someinternalforward'
alias sshagent='eval $(ssh-agent -s)'
alias startbastion='IKey; bastion'
appuser@bastion:~$ ^C
appuser@bastion:~$ someinternalhost
Agent pid 3410
Identity added: /home/appuser/.ssh/appuser (/home/appuser/.ssh/appuser)
Welcome to Ubuntu 20.04.4 LTS (GNU/Linux 5.4.0-124-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage
New release '22.04.1 LTS' available.
Run 'do-release-upgrade' to upgrade to it.

Last login: Sun Sep 18 16:35:54 2022 from 10.128.0.24
appuser@someinternalhost:~$

Результат идентичный первому заданию, но в данном кейсе все выполнилось за один раз!
