#!/bin/bash

### обновим менеджер пакетов и установим пакеты необходимые для работы
apt update
apt install docker.io -y
###Создадим пользователя и добавим его в группу docker которая позволяет управлять dockerom
useradd user -s /bin/bash -G docker
###зададим пароль
echo "user:user" | chpasswd
###добавим дополнительный модуль в sudoers который позволит рестартить сервис
echo "user ALL= NOPASSWD: /bin/systemctl restart docker.service" > /etc/sudoers.d/user
