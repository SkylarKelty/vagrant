#!/usr/bin/env bash

apt-get update
apt-get install apache2 php5 php5-mcrypt php5-mysql mysql-server php5-memcache memcached -y

# Apache Config
a2dissite default
ln -s /vagrant/config/apache2.conf /etc/apache2/sites-enabled/vagrant
service apache2 reload

# Memcached
service memcached start
update-rc.d memcached enable