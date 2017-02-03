# Class: nuodb
#
# Installs, configures and manages NuoDB service.
#
# @param manage_package Boolean specifying whether or not to manage the package. Defaults to true.
# @param package_ensure the ensure value to be set for the package resource when installing the package. Defaults to installed.
# @param package_version version of the package to install.
# @param package_download_url location to download the package from. This *must* be set unless a package source is provided.
# @param package_alt_source alternative location to get the package from. Will disregard the package_download_url if this is set.
# @param package_alt_name alternative package file name if the file names doesn't follow the standard distribution naming.
# @param package_provider provider to use when installing the package. Defaults to rpm on RedHat OS family and dpkg on Debian OS family.
# @param manage_java Boolean specifying whether or not to manage install Java. Defaults to true.
# @param manage_thp Boolean specifying whether or not to manage Transparent Hugepages (THP). Defaults to true.
# @param config_overrides Hash of properties to set in default.properties file, which will override any properties set via config_defaults
#   parameter. It is recommended to set the domainPassword parameter either in overrides or defaults.
# @param config_defaults Hash of properties to set in default.properties by default unless overridden by config_overrides parameter.
#   Uses sensible defaults. It is mandatory to set the domainPassword parameter either in overrides or defaults.
# @param agent_service_ensure the ensure value to set for the service resource for the agent service. Defaults to running.
# @param agent_service_enable Boolean enable parameter for the service resource to manage the agent service. Defaults to true.
# @param rest_service_ensure the ensure value to set for the service resource for the REST service. Defaults to running.
# @param rest_service_enable Boolean enable parameter for the service resource to manage the REST service. Defaults to true.
# @param engine_service_ensure the ensure value to set for the service resource for the engine service. Defaults to running.
# @param engine_service_enable Boolean enable parameter for the service resource to manage the engine service. Defaults to true.
# @param webconsole_service_ensure the ensure value to set for the service resource for the web console service. Defaults to running.
# @param webconsole_service_enable Boolean enable parameter for the service resource to manage the web console service. Defaults to true.
#
# @example
#   include ::nuodb # Use hiera to set 'package_download_url' and the 'domainPassword' in config_overrides
#
# @example
#   class { '::nuodb' :
#     package_download_url => 'http://yourdomain.com/path-to-nuodb-binary-dir/',
#     config_overrides     => {
#       domainPassword => 'mySuperSecretPassword',
#     },
#   }
#
class nuodb (
  $manage_package            = $::nuodb::params::manage_package,
  $package_ensure            = $::nuodb::params::package_ensure,
  $package_version           = $::nuodb::params::package_version,
  $package_download_url      = undef,
  $package_alt_source        = undef,
  $package_alt_name          = undef,
  $package_provider          = $::nuodb::params::package_provider,
  $manage_java               = $::nuodb::params::manage_java,
  $manage_thp                = $::nuodb::params::manage_thp,
  $config_overrides          = $::nuodb::params::config_overrides,
  $config_defaults           = $::nuodb::params::config_defaults,
  $agent_service_ensure      = $::nuodb::params::agent_service_ensure,
  $agent_service_enable      = $::nuodb::params::agent_service_enable,
  $rest_service_ensure       = $::nuodb::params::rest_service_ensure,
  $rest_service_enable       = $::nuodb::params::rest_service_enable,
  $engine_service_ensure     = $::nuodb::params::engine_service_ensure,
  $engine_service_enable     = $::nuodb::params::engine_service_enable,
  $webconsole_service_ensure = $::nuodb::params::webconsole_service_ensure,
  $webconsole_service_enable = $::nuodb::params::webconsole_service_enable,
) inherits ::nuodb::params {

  # Merge defaults and overrides
  $default_properties = merge($config_defaults, $config_overrides)

  validate_bool($manage_package)
  validate_bool($manage_java)
  validate_string($config_overrides['domainPassword'], 'domainPassword must be set')

  # Use puppetlabs-java module to install Java
  if ($manage_java) {
    include '::java'

    # Java should be installed for nuodb installtion
    Class['::java'] -> Package['nuodb']
  }

  # Use alexharvey-disable_transparent_hugepage module to disable THP
  if ($manage_thp) {
    include '::disable_transparent_hugepage'

    # Should be done before agent start
    Class['::disable_transparent_hugepage'] -> Service['nuoagent']
  }

  # Anchors
  anchor { '::nuodb::begin': }
  anchor { '::nuodb::end': }

  # Install
  include '::nuodb::install'
  include '::nuodb::config'
  include '::nuodb::service'

  # Ordering
  Anchor['::nuodb::begin'] ->
    Class['::nuodb::install'] ->
    Class['::nuodb::config']  ~>
    Class['::nuodb::service'] ->
  Anchor['::nuodb::end']
}
