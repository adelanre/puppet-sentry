#### This module installs sentry and it's required dependencies 
class sentry (
  $version,
  $config_path,
  # Database configuration
  $db_name,
  $db_user,
  $db_password,
  $db_port,
  $db_host,
  $broker_version
)
{
  class {'sentry::install': broker_version => $broker_version} ->
  class {'sentry::config': version => $version} ->
  class {'sentry::service':}

  contain ('sentry::install', 'sentry::config', 'sentry::service')
}
