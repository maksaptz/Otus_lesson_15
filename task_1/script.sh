#!/bin/bash

### разрешаем подключение ssh по паролю
sed -i 's/^PasswordAuthentication.*$/PasswordAuthentication yes/' /etc/ssh/sshd_config
### перезагрузка сервиса ssh
systemctl restart sshd.service

### добавляем пользователей и задаем пароли
useradd admin && useradd user
echo "admin:admin" | chpasswd && echo "user:user" | chpasswd

### создаем группу
groupadd -f admin

### добавляем пользователей в созданную группу. пользователи данной группы будут иметь постоянный достпуп к машине
usermod admin -a -G admin && usermod root -a -G admin && usermod vagrant -a -G admin
#### добавляем скрипт который позволит в ввыходные дни логиниться только пользователям группы admin
echo "#!/bin/bash
if [ \$(date +%a) = "Sat" ] || [ \$(date +%a) = "Sun" ]; then
 if getent group admin | grep -qw "\$PAM_USER"; then
        exit 0
      else
        exit 1
    fi
  else
    exit 0
fi" > /usr/local/bin/login.sh

### задаем права на исполнение
chmod +x /usr/local/bin/login.sh

### добавляем правило в  pam которые при подключении пользователя по ssh  будет запускать созданный нами скрипт. таким образом мы мыжем настроить дополнительные факторы для доступа на машину
echo "account    required     pam_exec.so /usr/local/bin/login.sh" >> /etc/pam.d/sshd
