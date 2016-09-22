class sentry::profile {
  $hiera_db = 'sentry'
  create_resources('class', hiera('sentry::config_info'))
}
