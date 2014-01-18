
node 'base-dev' {

	class {
		'::mysql::server':
			root_password    => 'AnActualPassword';
		'phpmyadmin': ;
		'webserver': ;
	}

	package {
		['memcached', 'git', 'curl', 'sudo']:
			ensure  => 'latest';
	}

	service {
		'memcached':
			ensure    => true,
			enable    => true,
			require   => Package['memcached'];
		'ssh':
			ensure    => true,
			enable    => true;
	}

	file {
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
			require     => Package['curl', 'php5-json'],
			creates     => '/tmp/composer.phar';
	}

}