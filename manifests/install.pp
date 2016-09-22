## Install all dependencies 
class sentry::install(
  $broker_version
){
   # Package Redis
     package { 'redis-server': ensure => $broker_version }
     package { 'redis-tools': ensure => $broker_version }
     # Python packages 
     package { 'python-setuptools': ensure => 'installed' }
     package { 'python-pip': ensure => 'installed' }
     package { 'python-dev': ensure => 'installed' }
     package { 'libxslt1-dev': ensure => 'installed' }
     package { 'libxml2-dev': ensure => 'installed' }
     package { 'libz-dev': ensure => 'installed' }
     package { 'libffi-dev': ensure => 'installed' }
     package { 'libssl-dev': ensure => 'installed' }
     package { 'libpq-dev': ensure => 'installed' }
     package { 'libyaml-dev': ensure => 'installed' }
     package { 'python-django-auth-ldap': ensure => 'installed' }
     package { 'python-ldap': ensure => 'installed', provider => 'pip' }
     package { 'libldap2-dev': ensure => 'installed' }
     package { 'libsasl2-dev': ensure => 'installed' }
     # Install nginx-full and supervisor
     package { 'nginx-full': ensure => 'installed' }
     package { 'supervisor': ensure => 'installed' }
     # Install virtualenv for sentry
     package {'virtualenv': ensure => 'installed', provider => 'pip', install_options => '-U'}

}


