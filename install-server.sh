#!/usr/bin/env bash

# Update system dependencies
apt-get update -y
apt-get upgrade -y

# Install nginx
apt-get install nginx nginx-extras -y
systemctl start nginx.service
systemctl enable nginx

# Installing PHP and its extensions
apt-get install php -y
apt-get install php-{bcmath,bz2,intl,gd,mbstring,mysql,zip,fpm} -y

# Add repository for PHP 8.1
add-apt-repository ppa:ondrej/php -y
apt-get update

# Install PHP 8.1
apt-get install php8.1 php8.1-cli php8.1-common -y

# Install PHP 8.1 extensions
apt-get install php8.1-{curl,dev,gd,mbstring,zip,mysql,xml,fpm,imagick,xmlrpc,intl} -y

# Set PHP 8.1 as default version
update-alternatives --set php /usr/bin/php8.1

# Install imagemagick
apt-get install imagemagick -y

# Installing Imagick PHP Extension
apt-get install php-imagick -y

# Check Imagick configurations
php-config --extension-dir

# Add extension=imagick at end of php.ini
echo "extension=imagick" >> /etc/php/8.1/fpm/php.ini

# Restart Nginx
systemctl restart nginx

# Install Composer
wget https://getcomposer.org/installer
php installer
mv composer.phar /usr/local/bin/composer
chmod +x /usr/local/bin/composer

# Install MySQL
apt-get install mysql-server -y
service mysql stop

# Solve issue of restart without grant
mkdir -p /var/run/mysqld
chown -R mysql:mysql /var/run/mysqld
chown -R mysql:mysql /var/lib/mysql
mysqld_safe --skip-grant-tables &

echo "After prompt Type lines into sql-user-update.sh (line by line)"
mysql -u root
