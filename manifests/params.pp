# Class: nuodb::params
#
# This class manages NuoDB parameters.
#
class nuodb::params {

  $manage_package = true
  $package_ensure = 'installed'
  $package_version = '2.6.0.4'
  $package_provider = $::os['family'] ? {
    /RedHat/ => 'rpm',
    default  => 'dpkg',
  }

  $manage_java = true
  $manage_thp = true
  $nuodb_home  = '/opt/nuodb'

  $config_overrides = { }
  $config_defaults = {
    domain              => 'domain',
    domainPassword      => 'ch@ngeMe',
    broker              => true,
    portRange           => 48005,
    singleHostDbRestart => true,
    advertiseAlt        => true,
    altAddr             => 'localhost',
  }

  $agent_service_ensure = 'running'
  $agent_service_enable = true
  $rest_service_ensure = 'running'
  $rest_service_enable = true
  $engine_service_ensure = 'stopped'
  $engine_service_enable = false
  $webconsole_service_ensure = 'stopped'
  $webconsole_service_enable = false
}
