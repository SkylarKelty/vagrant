class webserver {

	package {
		[
			'apache2',
			'php5',
			'libapache2-mod-php5',
			'php-pear',
			'php5-cli',
			'php5-common',
			'php5-curl',
			'php5-dev',
			'php5-gd',
			'php5-geoip',
			'php5-imap',
			'php5-intl',
			'php5-mcrypt',
			'php5-memcache',
			'php5-memcached',
			'php5-mysql',
			'php5-json'
		]:
			ensure  => 'latest';
	}

	service {
		'apache2':
			ensure    => true,
			enable    => true,
			require   => Package['apache2'];
	}

	file {
		'/var/www/html':
			ensure  => directory,
			require => Package['apache2'];
		'no-default':
			path    => '/etc/apache2/sites-enabled/000-default.conf',
			ensure  => absent,
			notify  => Service['apache2'];
		'www':
			path    => '/etc/apache2/sites-enabled/vagrant.conf',
         	source  => 'puppet:///modules/webserver/apache2.conf',
			ensure  => link,
			notify  => Service['apache2'];
		'/etc/php5/apache2/conf.d/10-mcrypt.ini':
			ensure  => present,
			source  => 'puppet:///modules/webserver/mcrypt.ini',
			notify  => Service['apache2'];
	}
}