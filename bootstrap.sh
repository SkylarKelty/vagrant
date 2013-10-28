#!/usr/bin/env bash

debconf-set-selections <<< 'mysql-server-5.5 mysql-server/root_password password rootpass'
debconf-set-selections <<< 'mysql-server-5.5 mysql-server/root_password_again password rootpass'
apt-get update
apt-get install -y apache2 php5 php5-mcrypt php5-mysql mysql-server php5-memcache memcached git

# Apache Config
a2dissite default
ln -s /vagrant/config/apache2.conf /etc/apache2/sites-enabled/vagrant
service apache2 reload

# Memcached
service memcached start
update-rc.d memcached enable