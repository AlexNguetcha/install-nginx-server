#!/usr/bin/env bash

sudo su
#update system dependencies
apt-get update -y
apt-get upgrade -y

#install nginx
apt-get install nginx nginx-extras -y
systemctl start nginx.service
systemctl enable nginx

#installing php
apt-get install php -y

#installing basic extension for php
apt-get install php-{bcmath,bz2,intl,gd,mbstring,mysql,zip,fpm} -y

#installing symfony php extension requirement
apt install php libapache2-mod-php php-mbstring php-xmlrpc php-soap php-gd php-xml php-cli php-zip php-mysql php-curl php-opcache php-xml curl git -y
apt-get install php-fpm php-mbstring php-opcache php-xml php-zip php-curl php-mysql php-cli curl git -y

apt-get install software-properties-common

#go to php 7.3
LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/php -y
apt update
apt install php7.3 php7.3-cli php7.3-common -y

#installing extensions for 7.3
apt install php-pear php7.3-curl php7.3-dev php7.3-gd php7.3-mbstring php7.3-zip php7.3-mysql php7.3-xml php7.3-fpm
apt install libapache2-mod-php7.3 php7.3-imagick php7.3-recode php7.3-tidy
apt install php7.3-xmlrpc php7.3-intl php7.3-mbstring php7.3-gd -y

#setting php 7.3 as default level
update-alternatives --set php /usr/bin/php7.3

#install imagemagick
apt install imagemagick -y
#Installing Imagick PHP Extension
apt install php-imagick -y
#check imagick configurations
php-config --extension-dir
#add extension=imagick at end of
echo "extension=imagick" >> /etc/php/7.3/fpm/php.ini

systemctl restart nginx

#Just for projects which use PHP and composer packages
#installing composer for symfony php
wget https://getcomposer.org/installer
php installer
#making composer global
mv composer.phar /usr/local/bin/composer
chmod +x /usr/local/bin/composer


#installing mysql
apt install mysql-server -y
#stop mysql service
sudo service mysql stop

#solving issue of restart without grant
sudo mkdir -p /var/run/mysqld
sudo chown -R mysql:mysql /var/run/mysqld
sudo chown -R mysql:mysql /var/lib/mysql

sudo mysqld_safe --skip-grant-tables &

echo "After prompt Type lines into sql-user-update.sh (line by line)"

mysql -u root
#Type lines into sql-user-update.sh (line by line)

