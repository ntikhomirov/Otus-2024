Установка Zabbix — это важный этап для мониторинга инфраструктуры. Вот пошаговая инструкция по установке и настройке Zabbix 6.x (последняя стабильная версия по состоянию на 2023 год) на операционных системах Linux (например, CentOS, Ubuntu, Debian). Мы также рассмотрим настройку веб-интерфейса.

---

### Шаг 1: Установка сервера Zabbix

#### 1.1. Обновите вашу ОС и установите необходимые зависимости.

Для **Debian/Ubuntu** выполните:
```bash
sudo apt update && sudo apt upgrade -y
sudo apt install -y wget gnupg2 lsb-release
```

Для **CentOS/AlmaLinux/Rocky Linux**:
```bash
sudo yum update -y
sudo yum install -y epel-release
sudo yum install -y wget net-tools
```

---

#### 1.2. Установите Zabbix-репозиторий.

Для установки Zabbix 6.x зайдите на [официальный сайт](https://www.zabbix.com/download) и выберите Репозиторий для вашей ОС. Пример установки для каждой платформы:

**Debian/Ubuntu (версия 20.04/22.04):**
```bash
wget https://repo.zabbix.com/zabbix/6.0/ubuntu/pool/main/z/zabbix-release/zabbix-release_6.0-4+ubuntu$(lsb_release -rs)_all.deb
sudo dpkg -i zabbix-release_6.0-4+ubuntu$(lsb_release -rs)_all.deb
sudo apt update
```

**CentOS/AlmaLinux/Rocky Linux 8:**
```bash
sudo rpm -Uvh https://repo.zabbix.com/zabbix/6.0/rhel/8/x86_64/zabbix-release-6.0-2.el8.noarch.rpm
sudo yum clean all
```

---

### Шаг 2: Установка компонентов Zabbix

#### 2.1. Установите пакеты Zabbix Server, агент, интерфейс и базу данных.

Для **Debian/Ubuntu**:
```bash
sudo apt install -y zabbix-server-mysql zabbix-frontend-php zabbix-apache-conf zabbix-sql-scripts zabbix-agent
```

Для **CentOS/Red Hat**:
```bash
sudo yum install -y zabbix-server-mysql zabbix-web-mysql zabbix-web zabbix-agent
```

---

### Шаг 3: Установка базы данных MySQL/MariaDB для Zabbix

#### 3.1. Установите MariaDB/MySQL.

Для **Ubuntu/Debian**:
```bash
sudo apt install -y mariadb-server
```

Для **CentOS/Red Hat**:
```bash
sudo yum install -y mariadb-server
```

Запустите и активируйте MariaDB:
```bash
sudo systemctl start mariadb
sudo systemctl enable mariadb
```

#### 3.2. Настройте базу данных.

Запустите конфигуратор безопасности MySQL:
```bash
sudo mysql_secure_installation
```

Создайте базу данных и пользователя для Zabbix:
```bash
sudo mysql -uroot -p
CREATE DATABASE zabbix CHARACTER SET utf8mb4 COLLATE utf8mb4_bin;
CREATE USER 'zabbix'@'localhost' IDENTIFIED BY 'придумайте_пароль';
GRANT ALL PRIVILEGES ON zabbix.* TO 'zabbix'@'localhost';
FLUSH PRIVILEGES;
EXIT;
```

#### 3.3. Импортируйте структуру базы данных Zabbix.

Выполните импорт начальных данных:
```bash
zcat /usr/share/zabbix-sql-scripts/mysql/server.sql.gz | mysql -u zabbix -p zabbix
```

---

### Шаг 4: Настройка Zabbix Server

#### 4.1. Настройте Zabbix Server.

Откройте файл конфигурации:
```bash
sudo nano /etc/zabbix/zabbix_server.conf
```

Укажите параметры подключения к базе данных:
```plaintext
DBName=zabbix
DBUser=zabbix
DBPassword=придумайте_пароль
```

Сохраните изменения и закройте редактор.

---

#### 4.2. Запустите и добавьте в автозагрузку Zabbix Server и Agent:

```bash
sudo systemctl restart zabbix-server zabbix-agent apache2
sudo systemctl enable zabbix-server zabbix-agent apache2
```

Для CentOS/RedHat:
```bash
sudo systemctl restart zabbix-server zabbix-agent httpd
sudo systemctl enable zabbix-server zabbix-agent httpd
```

---

### Шаг 5: Настройка веб-интерфейса Zabbix

#### 5.1. Настройка Apache и PHP.

Откройте файл конфигурации:
```bash
sudo nano /etc/zabbix/apache.conf
```

Убедитесь, что параметры PHP настроены (например, `date.timezone`):
```plaintext
php_value[date.timezone] = Europe/Moscow
```

Сохраните изменения и перезапустите Apache:
```bash
sudo systemctl restart apache2
```

Для CentOS/RedHat:
```bash
sudo systemctl restart httpd
```

---

#### 5.2. Завершите настройку через веб-интерфейс.

1. Откройте браузер и перейдите по адресу: `http://<IP-адрес-сервера>/zabbix`.
2. Выберите язык установки и нажмите **"Next"**.
3. Проверьте наличие всех необходимых зависимостей.
4. Введите параметры подключения к базе данных, которые вы создали (имя базы `zabbix`, пользователь `zabbix`, пароль).
5. Укажите базовые настройки Zabbix.
6. Завершите установку.

После успешной установки войдите в систему:
- Логин: **Admin**
- Пароль: **zabbix**

---

### Шаг 6: Настройка Zabbix Agent на клиентских машинах

Установите Zabbix Agent на машины, которые требуют мониторинга. Пример для Ubuntu:
```bash
wget https://repo.zabbix.com/zabbix/6.0/ubuntu/pool/main/z/zabbix-release/zabbix-release_6.0-4+ubuntu$(lsb_release -rs)_all.deb
sudo dpkg -i zabbix-release_6.0-4+ubuntu$(lsb_release -rs)_all.deb
sudo apt update
sudo apt install -y zabbix-agent
```

В файле `/etc/zabbix/zabbix_agentd.conf` настройте:
```plaintext
Server=<IP-адрес-сервера-Zabbix>
ServerActive=<IP-адрес-сервера-Zabbix>
Hostname=<Имя-хоста (уникальное) для текущей машины>
```

Перезапустите Agent:
```bash
sudo systemctl restart zabbix-agent
sudo systemctl enable zabbix-agent
```

---
