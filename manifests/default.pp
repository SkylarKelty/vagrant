
node 'default' {

	package {
		['memcached', 'mysql-server-5.5', 'git', 'curl', 'sudo', 'apache2']:
			ensure  => 'latest',
			require => Exec['apt_update'];
		['php5', 'libapache2-mod-php5', 'php-pear', 'php5-cli', 'php5-common', 'php5-curl', 'php5-dev', 'php5-gd', 'php5-geoip', 'php5-imap', 'php5-intl', 'php5-mcrypt', 'php5-memcache', 'php5-memcached', 'php5-mysql']:
			ensure  => 'latest',
			require => Exec['apt_update'],
			notify  => Service['apache2'];
	}

	service {
		['apache2', 'memcached', 'mysql', 'ssh']:
			ensure    => true,
			enable    => true;
	}

	file {
		'no-default':
			path    => '/etc/apache2/sites-enabled/000-default',
			ensure  => absent,
			notify  => Service['apache2'];
		'www':
			path    => '/etc/apache2/sites-enabled/vagrant',
			source  => '/mnt/remote/config/apache2.conf',
			ensure  => link,
			notify  => Service['apache2'];
		'composer':
			path    => '/usr/bin/composer',
			ensure  => present,
			source  => '/tmp/composer.phar',
			require => Exec['download_composer'];
	}

	exec {
		'download_composer':
			command     => '/usr/bin/curl -sSL http://getcomposer.org/installer | /usr/bin/php',
			cwd         => '/tmp/',
			require     => Package['curl'],
			creates     => '/tmp/composer.phar';
		'apt_update':
			command     => '/usr/bin/apt-get update';
	}

}