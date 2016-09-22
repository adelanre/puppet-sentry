class sentry::service (
)
  {
  service {'nginx':
     ensure  => 'running',
     enable  => true,
     require => Package['nginx-full'],
  }
}
