#!/bin/bash

red=$'\e[1;31m'
grn=$'\e[1;32m'
yel=$'\e[1;33m'
blu=$'\e[1;34m'
mag=$'\e[1;35m'
cyn=$'\e[1;36m'
end=$'\e[0m'

#apt-get update && apt-get -y upgrade

apt-get install htop

dpkg-reconfigure tzdata

cat <<EOF

********************************************************************
* Installing Apache
********************************************************************
EOF


echo -e '\E[37;42m'"\033[1mInstall Apache as:\033[0m"

select ap in "Apache Prefork (Default)" "Apache MPM-Worker"; do
    case $ap in
        "Apache Prefork (Default)" ) apt-get -y install apache2 php5 libapache2-mod-php5 php5-curl php5-gd php5-mcrypt php5-imagick; break;;
        "Apache MPM-Worker" ) apt-get -y install apache2-mpm-worker libapache2-mod-fastcgi php5-fpm php5 php5-curl php5-gd php5-mcrypt php5-imagick; break;;
    esac
done



sed -i -e "s/Options Indexes FollowSymLinks MultiViews/Options -Indexes FollowSymLinks MultiViews/g" /etc/apache2/sites-available/default
sed -i -e 's/ServerTokens OS/ServerTokens Prod/g' /etc/apache2/conf.d/security
sed -i -e 's/ServerSignature On/ServerSignature Off/g' /etc/apache2/conf.d/security



if [ -f /etc/php5/apache2/php.ini ]; 
then
    sed -i -e 's/expose_php = On/expose_php = Off/g' /etc/php5/apache2/php.ini
	sed -i -e 's/max_execution_time = 30/max_execution_time = 130/g' /etc/php5/apache2/php.ini
	sed -i -e 's/memory_limit = 128M/memory_limit = 256M/g' /etc/php5/apache2/php.ini
	sed -i -e 's/post_max_size = 8M/post_max_size = 25M/g' /etc/php5/apache2/php.ini
	sed -i -e 's/upload_max_filesize = 2M/upload_max_filesize = 25M/g' /etc/php5/apache2/php.ini
fi

a2enmod rewrite

service apache2 restart

cat <<EOF

********************************************************************
* Installing MySQL
********************************************************************
EOF

while true; do
    read -p "${grn}Install MySQL?${end}" yn
    case $yn in
        [Yy]* ) apt-get install mysql-server mysql-client php5-mysql; break;;
        [Nn]* ) break;;
        * ) echo -e '\E[38;41m'"\033[1mPlease answer yes or no.\033[0m";;
    esac
done

if which mysqld >/dev/null; then
    mysql_secure_installation

cat <<EOF

********************************************************************
* Installing PHPMyAdmin
********************************************************************
EOF
	
	while true; do
		
		read -p "${grn}Install PHPMyAdmin?${end}" yn
		case $yn in
			[Yy]* ) apt-get install phpmyadmin; break;;
			[Nn]* ) break;;
			* ) echo -e '\E[38;41m'"\033[1mPlease answer yes or no.\033[0m";;
		esac
	done
	
fi

cat <<EOF

********************************************************************
* Installing PostgreSQL
********************************************************************
EOF

while true; do

	read -p "${grn}Install PostgreSQL?${end}" yn
    case $yn in
        [Yy]* ) echo 'deb http://apt.postgresql.org/pub/repos/apt/ precise-pgdg main' > /etc/apt/sources.list.d/pgdg.list;
		wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | \
		  sudo apt-key add -;
		  apt-get update;
		  apt-get install postgresql-9.4;
		break;;
        [Nn]* ) break;;
        * ) echo -e '\E[38;41m'"\033[1mPlease answer yes or no.\033[0m";;
    esac
done

if which postgresql >/dev/null; then

	while true; do
		
		read -p "${grn}Install PHPpgadmin?${end}" yn
		case $yn in
			[Yy]* ) apt-get install phppgadmin; break;;
			[Nn]* ) break;;
			* ) echo -e '\E[38;41m'"\033[1mPlease answer yes or no.\033[0m";;
		esac
	done
	
fi

cat <<EOF

********************************************************************
* Installing Fail2ban
********************************************************************
EOF

while true; do

	read -p "${grn}Install Fail2ban?${end}" yn
    case $yn in
        [Yy]* ) apt-get install fail2ban; break;;
        [Nn]* ) break;;
        * ) echo -e '\E[38;41m'"\033[1mPlease answer yes or no.\033[0m";;
    esac
done

while true; do

	read -p "${grn}Install LFTP?${end}" yn
    case $yn in
        [Yy]* ) apt-get install lftp; break;;
        [Nn]* ) break;;
        * ) echo -e '\E[38;41m'"\033[1mPlease answer yes or no.\033[0m";;
    esac
done


while true; do
    
	read -p "${grn}Install Postfix?${end}" yn
    case $yn in
        [Yy]* ) apt-get install postfix;
		  apt-get install mailutils;
		break;;
        [Nn]* ) break;;
        * ) echo -e '\E[38;41m'"\033[1mPlease answer yes or no.\033[0m";;
    esac
done

###### clear coloring of prompt if needed
tput sgr0