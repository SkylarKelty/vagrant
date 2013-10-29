#!/usr/bin/env bash

if [ -f /var/.vagrant_lock ]; then
	exit 0
fi

debconf-set-selections <<< 'mysql-server-5.5 mysql-server/root_password password rootpass'
debconf-set-selections <<< 'mysql-server-5.5 mysql-server/root_password_again password rootpass'
apt-get update
apt-get install -y apache2 php5 php5-mcrypt php5-mysql mysql-server php5-memcache memcached git curl

# Apache Config
a2dissite default
ln -s /vagrant/config/apache2.conf /etc/apache2/sites-enabled/vagrant
service apache2 reload

# Memcached
service memcached start
update-rc.d memcached enable

# Install Composer
curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/bin/composer
composer --version

# Fancy bash
curl https://raw.github.com/SkylarKelty/bash/master/install.sh | bash

# Run once
touch /var/.vagrant_lock