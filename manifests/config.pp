# Class: nuodb::package
#
# This class manages NuoDB configuration.
#
class nuodb::config (
  $default_properties = $::nuodb::default_properties
) inherits nuodb {

  file { "${::nuodb::nuodb_home}/etc/default.properties":
    ensure  => present,
    owner   => 'nuodb',
    group   => 'nuodb',
    mode    => '0600',
    content => template('nuodb/config/default.properties.erb'),
  }
}
