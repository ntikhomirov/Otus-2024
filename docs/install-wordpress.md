### Шаг 1: Подготовка виртуальной машины
Создайте виртуальную машину: Используйте любую платформу виртуализации (например, VirtualBox, VMware или облачные сервисы).
Выберите операционную систему: Ubuntu Server (например, 20.04 или 22.04) будет хорошим выбором.
Дайте машине доступ к интернету, чтобы можно было устанавливать пакеты.
### Шаг 2: Установка необходимых пакетов
Подключитесь к виртуальной машине через SSH или терминал.
Обновите список пакетов и установите необходимые зависимости:
   sudo apt update
   sudo apt upgrade -y
   sudo apt install nginx mysql-server php-fpm php-mysql php-xml php-mbstring php-curl php-zip -y
Если вы предпочитаете PostgreSQL, вместо php-mysql установите php-pgsql и postgresql.

### Шаг 3: Настройка базы данных
Для MySQL:
   sudo mysql_secure_installation
Следуйте инструкциям для настройки безопасности MySQL. Затем создайте базу данных и пользователя для WordPress:

   sudo mysql -u root -p
В MySQL выполните следующие команды:

   CREATE DATABASE wordpress;
   CREATE USER 'wordpressuser'@'localhost' IDENTIFIED BY 'your_password';
   GRANT ALL PRIVILEGES ON wordpress.* TO 'wordpressuser'@'localhost';
   FLUSH PRIVILEGES;
   EXIT;
Для PostgreSQL команды будут другие, такие как CREATE DATABASE wordpress; и создания пользователя.

### Шаг 4: Установка WordPress
Скачайте последнюю версию WordPress:
   cd /var/www/html
   sudo wget https://wordpress.org/latest.tar.gz
   sudo tar -xzvf latest.tar.gz
   sudo mv wordpress/* ./
   sudo rmdir wordpress
   sudo rm latest.tar.gz
Настройте разрешения:
   sudo chown -R www-data:www-data /var/www/html/
   sudo chmod -R 755 /var/www/html/
Настройте файл конфигурации WordPress:
   cp wp-config-sample.php wp-config.php
Отредактируйте файл wp-config.php:

   sudo nano wp-config.php
Замените следующие строки:

   define( 'DB_NAME', 'wordpress' );
   define( 'DB_USER', 'wordpressuser' );
   define( 'DB_PASSWORD', 'your_password' );
   define( 'DB_HOST', 'localhost' );
### Шаг 5: Настройка Nginx
Создайте конфигурацию для сайта WordPress:
   sudo nano /etc/nginx/sites-available/wordpress
Вставьте следующую конфигурацию:

   server {
       listen 80;
       server_name your_domain_or_IP;

       root /var/www/html;
       index index.php index.html index.htm;

       location / {
           try_files $uri $uri/ /index.php?$args;
       }

       location ~ \.php$ {
           include snippets/fastcgi-php.conf;
           fastcgi_pass unix:/var/run/php/php7.4-fpm.sock; # Замените на вашу версию PHP
           fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
           include fastcgi_params;
       }

       location ~ /\.ht {
           deny all;
       }
   }
Не забудьте заменить your_domain_or_IP на ваш IP-адрес или доменное имя.

Активируйте конфигурацию и перезагрузите Nginx:
   sudo ln -s /etc/nginx/sites-available/wordpress /etc/nginx/sites-enabled/
   sudo nginx -t
   sudo systemctl restart nginx
### Шаг 6: Завершение установки
Откройте веб-браузер и введите IP-адрес вашей виртуальной машины. Вы должны увидеть экран установки WordPress.
Следуйте инструкциям на экране, чтобы завершить установку.
