class sentry::config (
  $version
){
   ## create sentry user
  user {'sentry':
    ensure     => 'present',
    managehome => true,
    uid => '5015',
  } ->
       
  group { 'sentry':
    ensure => 'present',
    gid => '5015',
  } ->

  file {'/home/sentry':
    ensure => 'directory',
    owner  => 'sentry',
    group  => 'sentry',
    mode   => '0600',
  } ->
       
  exec {'create_virtualenv':
    user    => 'sentry',
    command => 'virtualenv /home/sentry/sentry_env/',
    path    => '/usr/local/bin/:/bin/',
    require => Package['virtualenv'],
  } ->

  exec {'source_virtualenv':
    user    => 'sentry',
    command => "/bin/bash -c 'source /home/sentry/sentry_env/bin/activate'",
  } ->

  package {'sentry':
    ensure          => $version,
    provider        => 'pip',
    install_options => ['-U'],
  } ->

  exec {'sentry_initialize':
    user    => 'sentry',
    command => 'sentry init',
    path    => ['/usr/local/bin/:/bin/', '/usr/bin'],
    unless  => ['test -f /home/sentry/.sentry/config.yml', 'test -f /home/sentry/.sentry/sentry.conf.py'],
  } ->

  exec { 'rm_config_files':
    command => 'sudo rm -rf /home/sentry/.sentry/*',
    path    => '/usr/bin',
  } ->

  file {'/home/sentry/.sentry/sentry.conf.py':
    ensure  => present,
    owner   => 'sentry',
    group   => 'sentry',
    content => template('sentry/sentry.conf.py.erb'),
  } ->

  file {'/home/sentry/.sentry/config.yml':
    ensure  => present,
    owner   => 'sentry',
    group   => 'sentry',
    content => template('sentry/config.yml.erb'),
  } ->

  exec {'sentry_upgrade':
    user    => 'sentry',
    command => 'sentry upgrade',
    path    => '/usr/local/bin/:/bin/',
  } ->

  file { '/etc/supervisor/conf.d/sentry.conf':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
    content => template('sentry/sentry.conf.erb'),
  } ->

  exec {'supervisor_reread':
    command => 'sudo supervisorctl reread',
    path    => '/usr/bin',
  } ->
  
  exec {'supervisor_update':
    command => 'sudo supervisorctl update',
    path    => '/usr/bin',
  } ->
  
  file {'/etc/nginx/sites-enabled/default':
    ensure => present,
    owner  => 'root',
    group  => 'root',
    mode   => '0600',
    source => 'puppet:///modules/sentry/nginx-default',
    notify => Service['nginx'],
  } ->
  
  file {'/etc/nginx/ssl':
    ensure => 'directory',
    owner  => 'root',
    group  => 'root',
    mode   => '0600',
  } ->

  file {'/etc/nginx/ssl/nginx.crt':
    ensure => present,
    owner  => 'root',
    group  => 'root',
    mode   => '0600',
    source => 'puppet:///modules/sentry/nginx.crt',
    notify => Service['nginx'],
  } ->

  file {'/etc/nginx/ssl/nginx.key':
    ensure => present,
    owner  => 'root',
    group  => 'root',
    mode   => '0600',
    source => 'puppet:///modules/sentry/nginx.key',
    notify => Service['nginx'],

  }
}
