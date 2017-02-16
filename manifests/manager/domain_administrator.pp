# Define: nuodb::manager::domain_administrator
#
# This type allows creating and deleting a domain administrator. Note that the domain administrator password changes
# will not be reflected after the domain administrator has been created once.
#
# @param ensure the ensure value to determine if the domain administrator should be present or absent. Defaults to present.
# @param nuodb_home the directory where NuoDB is installed to. Defaults to the install location from the module.
# @param broker_host the host name for the broker instance to connect to create the domain administrator.
#   Defaults to the 'altAddr' property set for the default.properties in the module parameters.
# @param domain_password domain password to use for authenticating with the broker. Defaults to the 'domainPassword'
#   property set for the default.properties in the module parameters.
# @param username Domain administrator username for the domain. Defaults to the title.
# @param password Domain administrator password for the domain. Defaults to the title.
#
# @example
#   class { '::nuodb' :
#     domain_administrators => {
#       'testadmin1' => {
#         ensure   => present,
#         password => 'secret1',
#       },
#     },
#   }
#
# @example
#   ::nuodb::manager::domain_administrator { 'testadmin1':
#     ensure   => present,
#     password => 'secret1',
#   }
#
#
define nuodb::manager::domain_administrator (
  $ensure          = 'present',
  $nuodb_home      = $::nuodb::nuodb_home,
  $broker_host     = $::nuodb::default_properties['altAddr'],
  $domain_password = $::nuodb::default_properties['domainPassword'],
  $username        = $title,
  $password        = $title,
) {

  validate_re($ensure, '^(present|absent)$', "${ensure} is not supported. Allowed values are 'present' and 'absent'.")

  $base_command = "${nuodb_home}/bin/nuodbmgr --broker '${broker_host}' --password '${domain_password}' --command"
  $exists_check = "${base_command} \"show domain administrators\" | grep -q -Fx '${username}'"

  if ($ensure == 'present') {
    exec { "create-domain-administrator-${username}" :
      command => "${base_command} \"create domain administrator user '${username}' password '${password}'\"",
      unless  => $exists_check,
    }
  } else {
    exec { "remove-domain-administrator-${username}" :
      command => "${base_command} \"remove domain administrator user '${username}'\"",
      onlyif  => $exists_check,
    }
  }
}

