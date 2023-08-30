#!/bin/bash

### обновим менеджер пакетов и установим пакеты необходимые для работы
apt update
apt install docker.io -y

useradd user -s /bin/bash -G docker

echo "user:user" | chpasswd

echo "user ALL= NOPASSWD: /bin/systemctl restart docker.service" > /etc/sudoers.d/user

### sudo systemctl restart docker.service
### docker ps
