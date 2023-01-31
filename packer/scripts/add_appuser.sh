#!/bin/bash
echo 'add user'
sudo useradd -m -d /home/appuser -s /bin/bash appuser
sudo su - appuser
mkdir -p /home/appuser/.ssh
touch .ssh/authorized_keys
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCns00kXqMyjQ+37uGmbpMdsWuArMYWLkVBNp1ceWoo0//rrNL52Ve9/ad17onIfXoC0s0U7Ure9xXflVrXHDZ3mE5hR0SXgxADFC6ujlYgwJJH1bjjzYfMoyaUtn2TU8zawMFoGPdM5phlYdNqcIzOxAEdrAdAY5fEmUP38Fxx0gwQJdsh9VYca40mRIZ+gJbySBnFvwJbiof9UYM4FbmWysxl8WFi6aCWqNvxvyMGMGiqLOfGbE08Gg0N3yIgPsoSkmnrfaOnOhZvmbAXJnJS3+T66WWayPQsiDLF46NLIF/AXaM/xhgTrTDaUZjOmEZTblQluHGJRxppBYPbI5HNZZUtz5z3TBd5JDH7tlpEj++0Sttj81uXgFa1yBGVHEvOXGJriyi431xrEbnHQ55ICIiHa57oIVpylmICGtlK5ZI1MQIcv1f/ZM8piJHLtdIa59SAngwG3aEistci0jtsXj0WbU2jR3n5OAh83Oleni1ucfocoEoFVuBO/M81qGM= appuser" > /home/appuser/.ssh/authorized_keys
chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys
